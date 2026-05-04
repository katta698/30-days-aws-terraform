const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send(`
    <body style="background-color:#dcfce7;text-align:center;font-family:Arial;padding:50px;">
      <h1>Version 2.0</h1>
      <h2>Green Environment Staging</h2>
    </body>
  `);
});

app.listen(process.env.PORT || 8080);