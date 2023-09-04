import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { api } from "../Api";
import { LoginSuccess } from "./LoginSuccess"; 

const Login = () => {
  const [email_id, setemail_id] = useState('');
  const [pass, setPass] = useState('');
  const [loginSuccess, setLoginSuccess] = useState(false);
  const navigate = useNavigate(); 

  
  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const credentials = {
        email_id: email_id,
        password: pass
      };

      const response = await api.login(credentials);

      if (response.success) {
        console.log("Login successful:", response.message);
        setLoginSuccess(true);
      } else {
        console.error("Login failed:", response.error);
      }
    } catch (error) {
      console.error("An error occurred:", error);
    }
  };

  const handleRegisterClick = () => {
    navigate("/signup/personalInfo");
  };

  return (
    <div className="auth-form-container">
      {loginSuccess ? (
        <LoginSuccess />
      ) : (
        <div>
          <h2>Login</h2>
          <form className="login-form" onSubmit={handleSubmit}>
            <label htmlFor="email_id">Email</label>
            <input value={email_id} onChange={(e) => setemail_id(e.target.value)} type="email" placeholder="youremail@gmail.com" id="email_id" name="email_id" />
            <label htmlFor="password">Password</label>
            <input value={pass} onChange={(e) => setPass(e.target.value)} type="password" placeholder="********" id="password" name="password" />
            <button type="submit">Log In</button>
          </form>
          <button className="link-btn" onClick={handleRegisterClick}>Don't have an account? Register here.</button>
        </div>
      )}
    </div>
  );
};

export default Login;