package org.confluent.customeronboarding.utils;

public class EventsRequest {
    private String email_id;
    private String message;
    private String status;

    public EventsRequest(String email_id, String message, String status) {
        this.email_id = email_id;
        this.message = message;
        this.status = status;
    }

    public String getEmail_id() {
        return email_id;
    }

    public void setEmail_id(String email_id) {
        this.email_id = email_id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
