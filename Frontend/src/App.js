import React, { useState } from "react";
import "./App.css";
import { Login } from "./Login";
import { Register } from "./Register";
import { Verification } from "./Verification"; // Import the new component

function App() {
  const [currentForm, setCurrentForm] = useState("login");
  const [showVerification, setShowVerification] = useState(false);
  const [email, setEmail] = useState(""); // Add email state

  const toggleForm = (formName) => {
    setCurrentForm(formName);
    setShowVerification(false);
  };

  const handleVerification = (email) => {
    setShowVerification(true);
    setEmail(email); // Set the email in the state
  };

  return (
    <div className="App">
      {showVerification ? (
        <Verification onBackToLogin={() => toggleForm("login")} email={email} />
      ) : (
        currentForm === "login" ? (
          <Login onFormSwitch={toggleForm} />
        ) : (
          <Register onFormSwitch={toggleForm} onSignup={handleVerification} />
        )
      )}
    </div>
  );
}

export default App;
