package org.confluent.customeronboarding.utils;

public class CreditScoreResponse {
    private String email_id;
    private String ssn;
    private int credit_score;

    public CreditScoreResponse(String email_id, String ssn, int credit_score) {
        this.email_id = email_id;
        this.ssn = ssn;
        this.credit_score = credit_score;
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

    public int getCredit_score() {
        return credit_score;
    }

    public void setCredit_score(int credit_score) {
        this.credit_score = credit_score;
    }
}

