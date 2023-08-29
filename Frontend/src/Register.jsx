import React, { useState } from "react";
import { api } from "./Api"; // Import the api functions

export const Register = (props) => {
    const [email, setEmail] = useState('');
    const [pass, setPass] = useState('');
    const [name, setName] = useState('');

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const userData = {
              email: email,
              password: pass,
              name: name
            };
      
            const response = await api.signup(userData); // Call the api.signup function
      
            if (response.success) {
              console.log("User registered successfully:", response.message);
              props.onSignup(); // Trigger verification page after signup
            } else {
              console.error("Registration failed:", response.error);
            }
        } catch (error) {
            console.error("An error occurred:", error);
        }
    }

    return (
        <div className="auth-form-container">
          <h2>Register</h2>
          <form className="register-form" onSubmit={handleSubmit}>
            <label htmlFor="name">Full name</label>
            <input value={name} name="name" onChange={(e) => setName(e.target.value)} id="name" placeholder="full name" />
            <label htmlFor="email">Email</label>
            <input value={email} onChange={(e) => setEmail(e.target.value)}type="email" placeholder="youremail@example.com" id="email" name="email" />
            <label htmlFor="password">Password</label>
            <input value={pass} onChange={(e) => setPass(e.target.value)} type="password" placeholder="********" id="password" name="password" />
            <button type="submit">Sign Up</button>
          </form>
          <button className="link-btn" onClick={() => props.onFormSwitch('login')}>Already have an account? Login here.</button>
        </div>
    );
}
