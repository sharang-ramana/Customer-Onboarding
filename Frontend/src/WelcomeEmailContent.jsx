import React from "react";
import "./App.css";

const WelcomeEmailContent = ({ content, loginLink }) => {

  const handleLoginClick = () => {
    window.location.href = loginLink; // Navigate to the login link directly
  };

  return (
    <div className="auth-form-container welcome-email-content">
      <div dangerouslySetInnerHTML={{ __html: content.replace(/\n/g, "<br>") }} />
      <span className="button-spacing"></span>
      <p>Your can also login here.</p>
      <button onClick={handleLoginClick}>Login</button>
    </div>
  );
};

export default WelcomeEmailContent;
