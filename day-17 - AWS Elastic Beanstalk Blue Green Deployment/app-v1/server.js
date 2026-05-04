const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send(`
    <body style="background-color:#dbeafe;text-align:center;font-family:Arial;padding:50px;">
      <h1>Version 1.0</h1>
      <h2>Blue Environment Production</h2>
    </body>
  `);
});

app.listen(process.env.PORT || 8080);