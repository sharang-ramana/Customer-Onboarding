import React from "react";
import { useLocation } from "react-router-dom";
import WelcomeEmailContent from "./WelcomeEmailContent"; 

const WelcomeEmailPage = () => {
  const location = useLocation();
  const { content, loginLink } = location.state || {};

  return (
    <div className="App">
      <WelcomeEmailContent content={content} loginLink={loginLink} />
    </div>
  );
};

export default WelcomeEmailPage;
