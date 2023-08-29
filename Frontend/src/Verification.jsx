import React, { useState } from "react";
import { useNavigate } from "react-router-dom"; 
import { api } from "./Api";

export const Verification = ({ onBackToLogin, email }) => {
  const [emailVerified, setEmailVerified] = useState(false);

  const handleEmailVerification = async () => {
    try {
      const response = await api.verifyEmail(email);

      if (response.success) {
        setEmailVerified(true);
      } else {
        console.error("Email verification failed:", response.error);
      }
    } catch (error) {
      console.error("An error occurred:", error);
    }
  };

  const navigate = useNavigate();

  const handleOpenWelcomeEmail = async () => {
    try {
      const response = await api.getWelcomeEmail(email);
  
      if (response.success) {
        navigate("/welcome-email", {
          state: {
            content: response.content,
            loginLink: response.loginLink,
          },
        });
      } else {
        console.error("Failed to retrieve welcome email:", response.error);
      }
    } catch (error) {
      console.error("An error occurred:", error);
    }
  };  

  return (
    <div className="auth-form-container">
      <h2>Email Verification</h2>
      {emailVerified ? (
        <>
          <p>Email verified successfully.</p>
          <button className="link-btn" onClick={onBackToLogin}>
            Back to Login
          </button>
        </>
      ) : (
        <>
          <p>Your email needs verification.</p>
          <button onClick={handleEmailVerification}>Verify Email</button>
          <span className="button-spacing"></span>
          <button onClick={handleOpenWelcomeEmail}>Open Welcome Email</button>
        </>
      )}
    </div>
  );
};
