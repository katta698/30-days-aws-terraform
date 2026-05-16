const express = require("express");
const app = express();

const backendUrl = process.env.BACKEND_URL || "http://localhost:8080";

app.get("/", async (req, res) => {
  res.send(`
    <h1>Day 28 - 3 Tier Application</h1>
    <p>Frontend is running.</p>
    <p>Backend URL: ${backendUrl}</p>
    <a href="/api-test">Test Backend</a>
  `);
});

app.get("/api-test", async (req, res) => {
  try {
    const response = await fetch(`${backendUrl}/health`);
    const data = await response.text();
    res.send(`<h2>Backend Response</h2><pre>${data}</pre>`);
  } catch (err) {
    res.status(500).send(`Backend test failed: ${err.message}`);
  }
});

app.listen(3000, () => {
  console.log("Frontend running on port 3000");
});