import React from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import "./styles.css";
import Tetris from "./components/Tetris";

export default function App() {
  return (
    <Router basename={process.env.PUBLIC_URL}>
      <Switch>
        <Route exact path="/">
          <Tetris />
        </Route>
        {/* No need for separate /dev or /uat routes if using PUBLIC_URL */}
      </Switch>
    </Router>
  );
}