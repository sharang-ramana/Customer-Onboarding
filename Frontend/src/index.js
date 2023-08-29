import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter } from "react-router-dom"; // Import BrowserRouter
import RoutePaths from "./RoutePaths"; // Import the Routes component
import "./index.css";

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <BrowserRouter>
      <RoutePaths />
    </BrowserRouter>
  </React.StrictMode>
);
