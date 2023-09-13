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
import java.util.concurrent.ThreadLocalRandom;

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
            if (signupRequest.getEmail_id() == null || signupRequest.getEmail_id().isEmpty()) {
                throw new IllegalArgumentException("Email ID is a mandatory field.");
            }

            kafkaProducerService.sendMessage(signupRequest.getEmail_id(), signupRequest, "customer");

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
            if (!setFormattedTimestamp(event, response) || !sendEventToKafka(loginRequest.getEmail(), event, response)) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }

            return ResponseEntity.ok(response);
        } else {
            response.setSuccess(false);
            response.setError("Invalid credentials.");

            Event event = createEvent(loginRequest.getEmail(), "User login failed", "FAILURE");
            if (!setFormattedTimestamp(event, response) || !sendEventToKafka(loginRequest.getEmail(), event, response)) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }

            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/events")
    public ResponseEntity<ApiResponse> sendEvent(@RequestBody EventsRequest eventsRequest) {
        ApiResponse response = new ApiResponse();

        if (eventsRequest.getEmail_id() == null || eventsRequest.getEmail_id().isEmpty()) {
            response.setSuccess(false);
            response.setError("Email ID is required.");
            return ResponseEntity.badRequest().body(response);
        }

        Event event = createEvent(eventsRequest.getEmail_id(), eventsRequest.getMessage(), eventsRequest.getStatus());

        if (!setFormattedTimestamp(event, response)) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }

        if (!sendEventToKafka(eventsRequest.getEmail_id(), event, response)) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }

        response.setSuccess(true);
        response.setMessage("Event sent successfully.");
        return ResponseEntity.ok(response);
    }

    private Event createEvent(String email, String message, String status) {
        Event event = new Event();
        event.setEmail_id(email);
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

    @PostMapping("/creditscore")
    public ResponseEntity<ApiResponse> calculateCreditScore(@RequestBody CreditScoreRequest creditScoreRequest) {
        try {
            if (creditScoreRequest.getEmail_id() == null || creditScoreRequest.getEmail_id().isEmpty()) {
                throw new IllegalArgumentException("Email ID is a mandatory field.");
            }

            // Generate a random credit score between 500 and 850
            int randomCreditScore = ThreadLocalRandom.current().nextInt(500, 851);

            CreditScoreResponse creditScoreResponse = new CreditScoreResponse(creditScoreRequest.getEmail_id(), creditScoreRequest.getSsn(), randomCreditScore);

            kafkaProducerService.sendMessage(creditScoreRequest.getEmail_id(), creditScoreResponse, "credit_score");

            ApiResponse response = new ApiResponse();
            response.setSuccess(true);
            response.setMessage("Credit score calculated and sent successfully.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            ApiResponse response = new ApiResponse();
            response.setSuccess(false);
            response.setError("Error occurred while sending credit score to Kafka.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

}

