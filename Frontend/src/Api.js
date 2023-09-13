const BASE_URL = "http://localhost:8080/api"; // Replace with your actual backend URL

export const api = {
  signup: async (userData) => {
    const response = await fetch(`${BASE_URL}/signup`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(userData),
    });
    return response.json();
  },

  login: async (credentials) => {
    const response = await fetch(`${BASE_URL}/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(credentials),
    });
    return response.json();
  },

  sendEvent: async (email_id, message, status) => {
    const eventData = {
      email_id,
      message,
      status,
    };

    const response = await fetch(`${BASE_URL}/events`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(eventData),
    });

    return response.json();
  },

  calculateAndVerifyCreditScore: async (email_id, ssn) => {
    const creditScoreData = {
      email_id,
      ssn,
    };

    const response = await fetch(`${BASE_URL}/creditscore`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(creditScoreData),
    });

    return response.json();
  },
};
