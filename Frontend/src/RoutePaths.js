import React from "react";
import { Route, Routes } from "react-router-dom"; // Import Switch
import App from "./App"; // Your main App component
import WelcomeEmailPage from "./WelcomeEmailPage"; // The new page component

const RoutePaths = () => {
  return (
    <Routes>
      <Route exact path="/" element={<App/>} />
      <Route path="/welcome-email" element={<WelcomeEmailPage/>} />
      {/* Other routes */}
    </Routes>
  );
};

export default RoutePaths;
