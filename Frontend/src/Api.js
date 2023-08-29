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

  verifyEmail: async (email) => {
    const response = await fetch(`${BASE_URL}/verify-email`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email }),
    });
    return response.json();
  },

  getWelcomeEmail: async (email) => {
    const response = await fetch(`${BASE_URL}/welcome-email`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email }),
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
};
