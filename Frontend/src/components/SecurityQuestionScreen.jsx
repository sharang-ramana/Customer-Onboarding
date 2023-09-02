import React, { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";

const SecurityQuestionScreen = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const [securityAnswer, setSecurityAnswer] = useState("");

  const prevData = location.data;
  const securityQuestion = "What is your Last 4 digits of SSN?";

  const handleNext = () => {
    const combinedData = {
      ...prevData,
      securityQuestion,
      securityAnswer,
    };

    navigate("/signup/password", { state: combinedData });
  };

  return (
    <div className="auth-form-container">
      <h2>Security Question</h2>
      <p>What is your last 4 digits of your SSN?</p>
      <input
        type="text"
        placeholder="What is your Last 4 digits of SSN?"
        value={securityAnswer}
        onChange={(e) => setSecurityAnswer(e.target.value)}
        required
      />
      <button className="link-btn" type="button" onClick={handleNext}>
        Next
      </button>
    </div>
  );
};

export default SecurityQuestionScreen;