const express = require('express');
const app = express();
const PORT = 80;

app.get('/', (req, res) => {
  res.send('🚀 Hello from Kubernetes via Jenkins CI/CD!');
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
});
