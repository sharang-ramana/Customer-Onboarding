package org.confluent.customeronboarding.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

import java.sql.Date;

@Entity
public class customer_enriched {
    @Id
    private String emailId;

    private String fullName;
    private Date dob;
    private String gender;
    private String phone;
    private String address;
    private String ssn;
    private String isConsentsAgreed;
    private boolean isIdentityVerified;
    private boolean isCreditCheckVerified;
    private String securityQuestion;
    private String securityAnswer;
    private String password;

    private int creditScore;

    public customer_enriched(String emailId, String fullName, Date dob, String gender, String phone, String address, String ssn, String isConsentsAgreed, boolean isIdentityVerified, boolean isCreditCheckVerified, String securityQuestion, String securityAnswer, String password, int creditScore) {
        this.emailId = emailId;
        this.fullName = fullName;
        this.dob = dob;
        this.gender = gender;
        this.phone = phone;
        this.address = address;
        this.ssn = ssn;
        this.isConsentsAgreed = isConsentsAgreed;
        this.isIdentityVerified = isIdentityVerified;
        this.isCreditCheckVerified = isCreditCheckVerified;
        this.securityQuestion = securityQuestion;
        this.securityAnswer = securityAnswer;
        this.password = password;
        this.creditScore = creditScore;
    }

    public customer_enriched() {
    }

    // Getters and setters for all fields

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
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

    public String getEmailId() {
        return emailId;
    }

    public void setEmailId(String emailId) {
        this.emailId = emailId;
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

    public String getIsConsentsAgreed() {
        return isConsentsAgreed;
    }

    public void setIsConsentsAgreed(String isConsentsAgreed) {
        this.isConsentsAgreed = isConsentsAgreed;
    }

    public boolean isIdentityVerified() {
        return isIdentityVerified;
    }

    public void setIdentityVerified(boolean isIdentityVerified) {
        this.isIdentityVerified = isIdentityVerified;
    }

    public boolean isCreditCheckVerified() {
        return isCreditCheckVerified;
    }

    public void setCreditCheckVerified(boolean isCreditCheckVerified) {
        this.isCreditCheckVerified = isCreditCheckVerified;
    }

    public String getSecurityQuestion() {
        return securityQuestion;
    }

    public void setSecurityQuestion(String securityQuestion) {
        this.securityQuestion = securityQuestion;
    }

    public String getSecurityAnswer() {
        return securityAnswer;
    }

    public void setSecurityAnswer(String securityAnswer) {
        this.securityAnswer = securityAnswer;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getCreditScore() {
        return creditScore;
    }

    public void setCreditScore(int creditScore) {
        this.creditScore = creditScore;
    }
}


