import React, { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { api } from "../Api";

const PasswordScreen = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordError, setPasswordError] = useState("");
  const prevData = location.state || {};

  const handleNext = async (e) => {
    e.preventDefault();

    if (password !== confirmPassword) {
        setPasswordError("Please ensure that the password and confirm password match."); 
        return; 
    }

    const combinedData = {
      ...prevData,
      password,
    };

    console.log("Combined Data:", combinedData);

    const eventResponse = await api.sendEvent(
        prevData.emailId,
        "Gather User's Password",
        "success"
      );
  
    console.log("Event Response:", eventResponse);

    try {
        const signupResponse = await api.signup(combinedData);
  
        console.log("Signup Response:", signupResponse);
  
        if (signupResponse.success) {
          const eventResponse = await api.sendEvent(
            prevData.emailId,
            "Account Created Successfully",
            "success"
          );
  
          console.log("Event Response:", eventResponse);
  
          navigate("/signup/account-created", { state: combinedData });
        } else {
          console.error("Signup failed:", signupResponse.error);
        }
      } catch (error) {
        console.error("Error:", error);
      }

    navigate("/signup/account-created", { state: combinedData });
  };

  return (
    <div className="auth-form-container">
      <form className="register-form" onSubmit={handleNext}>
        <h2 style={{ textAlign: "left" }}>Your account setup is almost done...</h2>
        <h2 style={{ textAlign: "left", marginTop: "0px" }}>Please set your password</h2>
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
        {passwordError && <p style={{ color: "red" }}>{passwordError}</p>}
        <button className="custom-button" type="submit">
            Submit
        </button>
      </form>
    </div>
  );
};

export default PasswordScreen;