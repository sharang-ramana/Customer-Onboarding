import React, { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";

const PasswordScreen = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const prevData = location.state || {};

  const handleNext = () => {
    const combinedData = {
      ...prevData,
      password,
    };

    console.log("Combined Data:", combinedData);

    navigate("/signup/account-created", { state: combinedData });
  };

  return (
    <div className="auth-form-container">
      <h2>Create Password</h2>
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <input
        type="password"
        placeholder="Confirm Password"
        value={confirmPassword}
        onChange={(e) => setConfirmPassword(e.target.value)}
        required
      />
      <button className="link-btn" type="button" onClick={handleNext}>
        Next
      </button>
    </div>
  );
};

export default PasswordScreen;