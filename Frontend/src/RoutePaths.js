import React from "react";
import { Route, Routes } from "react-router-dom";
import "./App.css";
import RegisterPersonalInfo from "./components/RegisterPersonalInfo";
import RegisterSSN from "./components/RegisterSSN";
import VerificationScreen from "./components/VerificationScreen.jsx";
import SecurityQuestionScreen from "./components/SecurityQuestionScreen";
import PasswordScreen from "./components/PasswordScreen";
import AccountCreatedScreen from "./components/AccountCreatedScreen";
import Login from "./components/Login";
import { LoginSuccess } from "./components/LoginSuccess";

const RoutePaths = () => {
  return (
    <div className="App">
      <Routes>
          <Route path="/" element={<RegisterPersonalInfo />} />
          <Route path="/signup/personalInfo" element={<RegisterPersonalInfo/>} />
          <Route path="/signup/SSN" element={<RegisterSSN/>} />
          <Route path="/signup/SSN-Credit-Verification" element={<VerificationScreen/>} />
          <Route path="/signup/security-question" element={<SecurityQuestionScreen/>} />
          <Route path="/signup/password" element={<PasswordScreen/>} />
          <Route path="/signup/account-created" element={<AccountCreatedScreen/>} />
          <Route path="/login" element={<Login/>} />
          <Route path="/login/success" element={<LoginSuccess/>} />
      </Routes>
    </div>
  );
};

export default RoutePaths;