package org.confluent.customeronboarding.utils;

public class CreditScoreRequest {
    private String email_id;
    private String ssn;

    public CreditScoreRequest(String email_id, String ssn) {
        this.email_id = email_id;
        this.ssn = ssn;
    }

    public String getEmail_id() {
        return email_id;
    }

    public void setEmail_id(String email_id) {
        this.email_id = email_id;
    }

    public String getSsn() {
        return ssn;
    }

    public void setSsn(String ssn) {
        this.ssn = ssn;
    }
}
