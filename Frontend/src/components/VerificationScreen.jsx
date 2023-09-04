import React, { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { api } from "../Api";

const VerificationScreen = () => {
  const [verificationStep, setVerificationStep] = useState(0);
  const location = useLocation();
  const navigate = useNavigate();

  const stepTitles = [
    "Verifying your Identity!!",
    "Verifying your Credit!!",
    "Hurray!!",
  ];

  useEffect(() => {
    const dataFromPreviousScreen = location.state;

    console.log("Data from previous screen:", dataFromPreviousScreen);

    const timer = setTimeout(() => {
      if (verificationStep < 2) {
        setVerificationStep(verificationStep + 1);
      } else {
        api
          .sendEvent(
            dataFromPreviousScreen.email_id,
            "Identity and Credit Verification",
            "success"
          )
          .then((eventResponse) => {
            console.log("Event Response:", eventResponse);
          })
          .catch((error) => {
            console.error("Error sending event:", error);
          });
      }
    }, 3000);

    return () => clearTimeout(timer);
  }, [verificationStep, location.state, navigate]);

  return (
    <div className="verification-container">
      <h2>{stepTitles[verificationStep]}</h2>
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
            <button
              className="custom-button"
              type="button"
              onClick={() =>
                navigate("/signup/security-question", {
                  state: {
                    ...location.state,
                    is_identity_verified: true,
                    is_credit_check_verified: true,
                  },
                })
              }
            >
              Continue
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default VerificationScreen;