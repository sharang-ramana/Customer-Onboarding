import React, { useState } from "react";
import { api } from "../Api"; 
import { LoginSuccess } from "./LoginSuccess"; 


export const Login = (props) => {
    const [email, setEmail] = useState('');
    const [pass, setPass] = useState('');
    const [loginSuccess, setLoginSuccess] = useState(false); 

    const handleSubmit = async (e) => {
        e.preventDefault();
    
        try {
          const credentials = {
            email: email,
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


    return (
        <div className="auth-form-container">
          {loginSuccess ? (
            <LoginSuccess />
          ) : (
            <div>
              <h2>Login</h2>
              <form className="login-form" onSubmit={handleSubmit}>
                <label htmlFor="email">Email</label>
                <input value={email} onChange={(e) => setEmail(e.target.value)} type="email" placeholder="youremail@gmail.com" id="email" name="email" />
                <label htmlFor="password">Password</label>
                <input value={pass} onChange={(e) => setPass(e.target.value)} type="password" placeholder="********" id="password" name="password" />
                <button type="submit">Log In</button>
              </form>
              <button className="link-btn" onClick={() => props.onFormSwitch('register')}>Don't have an account? Register here.</button>
            </div>
          )}
        </div>
      );      
}