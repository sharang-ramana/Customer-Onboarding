import React, { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { api } from "../Api";


const SecurityQuestionScreen = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const [securityAnswer, setSecurityAnswer] = useState("");

  const prevData = location.state || {};
  const securityQuestion = "What is your Last 4 digits of SSN?";

  const handleNext = async (e) => {
    e.preventDefault();

    const combinedData = {
      ...prevData,
      securityQuestion,
      securityAnswer,
    };

    const eventResponse = await api.sendEvent(
        prevData.emailId,
        "Gather User's Security Question",
        "success"
    );

    console.log("Event Response:", eventResponse);

    navigate("/signup/password", { state: combinedData });
  };

  return (
    <div className="auth-form-container">
      <h2>Security Question</h2>
      <form className="register-form" onSubmit={handleNext}>
        <label htmlFor="securityQuestion">Choose a Security Question:</label>
        <select id="securityQuestion">
            <option value="ssnLast4">What is your last 4 digits of your SSN?</option>
        </select>
        <input
            type="text"
            placeholder="What is your Last 4 digits of SSN?"
            value={securityAnswer}
            onChange={(e) => setSecurityAnswer(e.target.value)}
            required
        />
        <button className="custom-button" type="submit">
            Continue
        </button>
      </form>
    </div>
  );
};

export default SecurityQuestionScreen;