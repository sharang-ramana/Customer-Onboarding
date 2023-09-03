import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { api } from "../Api";

const RegisterPersonalInfo = () => {
  const [fullName, setFullName] = useState("");
  const [dob, setDOB] = useState("");
  const [gender, setGender] = useState("");
  const [emailId, setEmailId] = useState("");
  const [phone, setPhone] = useState("");
  const [address, setAddress] = useState("");

  const navigate = useNavigate();

  const handleNext = async (e) => {
    e.preventDefault();

    const userData = {
      fullName,
      dob,
      gender,
      emailId,
      phone,
      address,
    };

    const eventResponse = await api.sendEvent(
      emailId,
      "Gather User's Personal Information",
      "success"
    );

    console.log("Event Response:", eventResponse);

    navigate("/signup/SSN", { state: userData });
  };

  return (
    <div className="auth-form-container">
      <h2>Personal Information</h2>
      <form className="register-form" onSubmit={handleNext}>
        <label htmlFor="fullName">Full Name</label>
        <input
          type="text"
          id="fullName"
          placeholder="Full Name"
          value={fullName}
          onChange={(e) => setFullName(e.target.value)}
          required
        />

        <label htmlFor="dob">Date of Birth</label>
        <input
          type="date"
          id="dob"
          value={dob}
          onChange={(e) => setDOB(e.target.value)}
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

        <label htmlFor="emailId">emailId</label>
        <input
          type="emailId"
          id="emailId"
          placeholder="youremailId@example.com"
          value={emailId}
          onChange={(e) => setEmailId(e.target.value)}
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

        <button className="custom-button" type="submit">Continue</button>
      </form>
      <button className="link-btn">
        <Link to="/login" className="custom-link">Already have an account? Login here.</Link>
      </button>    
    </div>
  );
};

export default RegisterPersonalInfo;
