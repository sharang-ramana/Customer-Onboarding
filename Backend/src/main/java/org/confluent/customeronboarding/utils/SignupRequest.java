package org.confluent.customeronboarding.utils;

import java.sql.Date;

public class SignupRequest {
    private String full_name;
    private Date dob;
    private String gender;
    private String email_id;
    private String phone;
    private String address;
    private String ssn;
    private String is_consents_agreed;
    private boolean is_identity_verified;
    private boolean is_credit_check_verified;
    private String security_question;
    private String security_answer;
    private String password;

    public SignupRequest(String full_name, Date dob, String gender, String email_id, String phone, String address, String ssn, String is_consents_agreed, boolean is_identity_verified, boolean is_credit_check_verified, String security_question, String security_answer, String password) {
        this.full_name = full_name;
        this.dob = dob;
        this.gender = gender;
        this.email_id = email_id;
        this.phone = phone;
        this.address = address;
        this.ssn = ssn;
        this.is_consents_agreed = is_consents_agreed;
        this.is_identity_verified = is_identity_verified;
        this.is_credit_check_verified = is_credit_check_verified;
        this.security_question = security_question;
        this.security_answer = security_answer;
        this.password = password;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getEmail_id() {
        return email_id;
    }

    public void setEmail_id(String email_id) {
        this.email_id = email_id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getSsn() {
        return ssn;
    }

    public void setSsn(String ssn) {
        this.ssn = ssn;
    }

    public String getIs_consents_agreed() {
        return is_consents_agreed;
    }

    public void setIs_consents_agreed(String is_consents_agreed) {
        this.is_consents_agreed = is_consents_agreed;
    }

    public boolean isIs_identity_verified() {
        return is_identity_verified;
    }

    public void setIs_identity_verified(boolean is_identity_verified) {
        this.is_identity_verified = is_identity_verified;
    }

    public boolean isIs_credit_check_verified() {
        return is_credit_check_verified;
    }

    public void setIs_credit_check_verified(boolean is_credit_check_verified) {
        this.is_credit_check_verified = is_credit_check_verified;
    }

    public String getSecurity_question() {
        return security_question;
    }

    public void setSecurity_question(String security_question) {
        this.security_question = security_question;
    }

    public String getSecurity_answer() {
        return security_answer;
    }

    public void setSecurity_answer(String security_answer) {
        this.security_answer = security_answer;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}


