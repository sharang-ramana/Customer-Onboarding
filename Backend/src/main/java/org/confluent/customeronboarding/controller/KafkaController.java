package org.confluent.customeronboarding.controller;

import org.confluent.customeronboarding.entity.customer;
import org.confluent.customeronboarding.repository.CustomerRepository;
import org.confluent.customeronboarding.service.KafkaProducerService;
import org.confluent.customeronboarding.utils.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;

@RestController
@RequestMapping("/api")
public class KafkaController {

    private final KafkaProducerService kafkaProducerService;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    public KafkaController(KafkaProducerService kafkaProducerService) {
        this.kafkaProducerService = kafkaProducerService;
    }

    @PostMapping("/signup")
    public ResponseEntity<ApiResponse> signup(@RequestBody SignupRequest signupRequest) {
        try {
            if (signupRequest.getEmailId() == null || signupRequest.getEmailId().isEmpty()) {
                throw new IllegalArgumentException("Email ID is a mandatory field.");
            }

            kafkaProducerService.sendMessage(signupRequest.getEmailId(), signupRequest, "signup");

            ApiResponse response = new ApiResponse();
            response.setSuccess(true);
            response.setMessage("User signed up successfully.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            ApiResponse response = new ApiResponse();
            response.setSuccess(false);
            response.setError("Error occurred while sending message to Kafka.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse> login(@RequestBody LoginRequest loginRequest) {
        customer customer = customerRepository.findByEmailId(loginRequest.getEmail());

        ApiResponse response = new ApiResponse();
        if (customer != null && customer.getPassword().equals(loginRequest.getPassword())) {
            response.setSuccess(true);
            response.setMessage("Login successful.");

            Event event = createEvent(loginRequest.getEmail(), "User successfully logged in", "SUCCESS");
            if (!sendEventToKafka(loginRequest.getEmail(), event, response)) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }

            return ResponseEntity.ok(response);
        } else {
            response.setSuccess(false);
            response.setError("Invalid credentials.");

            Event event = createEvent(loginRequest.getEmail(), "User login failed", "FAILURE");
            if (!sendEventToKafka(loginRequest.getEmail(), event, response)) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }

            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/events")
    public ResponseEntity<ApiResponse> sendEvent(@RequestBody EventsRequest eventsRequest) {
        ApiResponse response = new ApiResponse();

        if (eventsRequest.getEmailId() == null || eventsRequest.getEmailId().isEmpty()) {
            response.setSuccess(false);
            response.setError("Email ID is required.");
            return ResponseEntity.badRequest().body(response);
        }

        Event event = createEvent(eventsRequest.getEmailId(), eventsRequest.getMessage(), eventsRequest.getStatus());

        if (!setFormattedTimestamp(event, response)) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }

        if (!sendEventToKafka(eventsRequest.getEmailId(), event, response)) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }

        response.setSuccess(true);
        response.setMessage("Event sent successfully.");
        return ResponseEntity.ok(response);
    }

    private Event createEvent(String email, String message, String status) {
        Event event = new Event();
        event.setEmailId(email);
        event.setMessage(message);
        event.setStatus(status);
        return event;
    }

    private boolean setFormattedTimestamp(Event event, ApiResponse response) {
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String formattedTimestamp = dateFormat.format(new Date());
            event.setTimestamp(formattedTimestamp);
            return true;
        } catch (Exception e) {
            response.setSuccess(false);
            response.setError("Error formatting timestamp.");
            return false;
        }
    }

    private boolean sendEventToKafka(String emailId, Event event, ApiResponse response) {
        try {
            kafkaProducerService.sendMessage(emailId, event, "events");
            return true;
        } catch (Exception e) {
            response.setSuccess(false);
            response.setError("Error sending event to Kafka.");
            return false;
        }
    }
}

