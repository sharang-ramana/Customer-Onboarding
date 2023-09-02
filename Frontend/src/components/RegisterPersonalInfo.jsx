import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";

const RegisterPersonalInfo = () => {
  const [fullName, setFullName] = useState("");
  const [dateOfBirth, setDateOfBirth] = useState("");
  const [gender, setGender] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [address, setAddress] = useState("");

  const navigate = useNavigate();

  const handleNext = () => {
    const userData = {
      fullName,
      dateOfBirth,
      gender,
      email,
      phone,
      address,
    };

    navigate("/signup/SSN", { state: userData });
  };

  return (
    <div className="auth-form-container">
      <h2>Personal Information</h2>
      <form className="register-form">
        <label htmlFor="fullName">Full Name</label>
        <input
          type="text"
          id="fullName"
          placeholder="Full Name"
          value={fullName}
          onChange={(e) => setFullName(e.target.value)}
          required
        />

        <label htmlFor="dateOfBirth">Date of Birth</label>
        <input
          type="date"
          id="dateOfBirth"
          value={dateOfBirth}
          onChange={(e) => setDateOfBirth(e.target.value)}
          required
        />

        <label htmlFor="gender">Gender</label>
        <select
          id="gender"
          value={gender}
          onChange={(e) => setGender(e.target.value)}
          required
        >
          <option value="">Select Gender</option>
          <option value="male">Male</option>
          <option value="female">Female</option>
          <option value="other">Other</option>
        </select>

        <label htmlFor="email">Email</label>
        <input
          type="email"
          id="email"
          placeholder="youremail@example.com"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />

        <label htmlFor="phone">Phone</label>
        <input
          type="tel"
          id="phone"
          placeholder="Phone"
          value={phone}
          onChange={(e) => setPhone(e.target.value)}
          required
        />

        <label htmlFor="address">Address</label>
        <textarea
          id="address"
          placeholder="Address"
          value={address}
          onChange={(e) => setAddress(e.target.value)}
          required
        />

        <button className="link-btn" type="button" onClick={handleNext}>Next</button>
      </form>
      <button className="link-btn">
        <Link to="/login">Already have an account? Login here.</Link>
      </button>    
    </div>
  );
};

export default RegisterPersonalInfo;
