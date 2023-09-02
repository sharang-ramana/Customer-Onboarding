import React, { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";

const VerificationScreen = () => {
  const [verificationStep, setVerificationStep] = useState(0);
  const location = useLocation();
  const navigate = useNavigate();

  useEffect(() => {
    const dataFromPreviousScreen = location.state;

    console.log("Data from previous screen:", dataFromPreviousScreen);

    const timer = setTimeout(() => {
      if (verificationStep < 2) {
        setVerificationStep(verificationStep + 1);
      } else {
        navigate("/signup/security-question", { state: dataFromPreviousScreen });
      }
    }, 3000);

    return () => clearTimeout(timer);
  }, [verificationStep, location.state, navigate]);

  return (
    <div className="verification-container">
      <h2>Verifying Your Identity</h2>
      <div className="animation-container">
        {verificationStep === 0 && (
          <div className="rotation-animation">
            <i className="fa fa-spinner fa-spin fa-3x fa-fw"></i>
          </div>
        )}
        {verificationStep === 1 && (
          <div className="rotation-animation">
            <i className="fa fa-spinner fa-spin fa-3x fa-fw"></i>
          </div>
        )}
        {verificationStep === 2 && (
          <div className="success-animation">
            <div className="tick-mark">&#10004;</div>
            <div className="success-message-container">
              <h2 className="success-message">Verified Successfully!!</h2>
            </div>
            <button className="next-button" onClick={() => navigate("/signup/security-question", { state: location.state })}>
              Next
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default VerificationScreen;