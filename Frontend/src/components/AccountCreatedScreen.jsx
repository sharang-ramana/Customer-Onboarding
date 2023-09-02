import React from "react";
import { Link } from "react-router-dom";

const AccountCreatedScreen = () => {
  return (
    <div className="account-created-container">
      <div className="tick-mark">&#10004;</div>
      <h2>Your account is created successfully!!</h2>
      <button className="login-button">
        <Link to="/login">Login</Link>
      </button>
    </div>
  );
};

export default AccountCreatedScreen;