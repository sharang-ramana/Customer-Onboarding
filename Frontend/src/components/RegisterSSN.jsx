import React, { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";

const RegisterSSNAndConsent = () => {
  const location = useLocation();
  const navigate = useNavigate();

  const [ssn, setSSN] = useState("");
  const [termsConsent, setTermsConsent] = useState(false);
  const [creditCheckConsent, setCreditCheckConsent] = useState(false);

  const prevData = location.state || {};

  const handleNext = () => {
    const UserConsentSSNData = {
        ssn,
        termsConsent,
        creditCheckConsent,
        ...prevData,
      };
  
    navigate("/signup/SSN-Credit-Verification", { state: UserConsentSSNData });
  };

  return (
    <div className="auth-form-container">
      <h2>SSN and Consents</h2>
      <form className="register-form">
        <label htmlFor="ssn">Social Security Number</label>
        <input
          type="text"
          id="ssn"
          placeholder="SSN"
          value={ssn}
          onChange={(e) => setSSN(e.target.value)}
          required
        />

        <label htmlFor="identityVerification">Identity Verification</label>
        <div className="file-input-container">
          <input
            type="file"
            id="identityVerification"
            accept=".jpg, .jpeg, .png, .pdf" 
            className="file-input"
          />
        </div>

        <div className="consent-checkbox">
          <label>
            <input
              type="checkbox"
              checked={termsConsent}
              onChange={(e) => setTermsConsent(e.target.checked)}
            />
            I agree to the terms and conditions
          </label>
        </div>

        <div className="consent-checkbox">
          <label>
            <input
              type="checkbox"
              checked={creditCheckConsent}
              onChange={(e) => setCreditCheckConsent(e.target.checked)}
            />
            I consent to a credit check
          </label>
        </div>

        <button className="link-btn" type="button" onClick={handleNext}>
          Submit
        </button>
      </form>
    </div>
  );
};

export default RegisterSSNAndConsent;
