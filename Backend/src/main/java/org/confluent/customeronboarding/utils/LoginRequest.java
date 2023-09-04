package org.confluent.customeronboarding.utils;

public class LoginRequest {
    private String email_id;

    private String password;

    public String getEmail() {
        return email_id;
    }

    public String getEmail_id() {
        return email_id;
    }

    public LoginRequest(String email_id, String password) {
        this.email_id = email_id;
        this.password = password;
    }

    public void setEmail_id(String email_id) {
        this.email_id = email_id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
