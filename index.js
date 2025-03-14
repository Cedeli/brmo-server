import express from 'express';
import path from 'path';

const app = express();
const port = process.env.PORT || 8080;

app.use(express.json());

console.log("Current working directory:", process.cwd());
const staticPath = path.resolve('./ITS122L/dist/brmo');
console.log("Resolved static path:", staticPath);

app.use(express.static(staticPath));

app.get('*', (req, res) => {
  res.sendFile(path.join(staticPath, 'index.html'));
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});