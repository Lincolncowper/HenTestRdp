const express = require('express');
const fetch = require('node-fetch');
const cron = require('node-cron');
require('dotenv').config();
const app = express();
const port = process.env.PORT || 3000;

// Mengatur view engine menggunakan EJS
app.set('view engine', 'ejs');

// Menampilkan file statis
app.use(express.static('public'));

// Fungsi untuk memicu workflow
async function triggerWorkflow() {
  const GITHUB_API_TOKEN = process.env.GITHUB_API_TOKEN;
  const GITHUB_REPO = process.env.GITHUB_REPO;
  const WORKFLOW_FILE_NAME = process.env.WORKFLOW_FILE_NAME;

  const url = `https://api.github.com/repos/${GITHUB_REPO}/actions/workflows/${WORKFLOW_FILE_NAME}/dispatches`;
  
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${GITHUB_API_TOKEN}`,
      'Accept': 'application/vnd.github.v3+json',
    },
    body: JSON.stringify({
      ref: 'main', // Atau ref lain sesuai kebutuhan Anda
    }),
  });

  if (response.ok) {
    console.log('Workflow triggered successfully');
  } else {
    console.error('Failed to trigger workflow:', response.statusText);
  }
}

// Fungsi untuk memeriksa status workflow
async function checkWorkflowStatus() {
  const GITHUB_API_TOKEN = process.env.GITHUB_API_TOKEN;
  const GITHUB_REPO = process.env.GITHUB_REPO;

  const url = `https://api.github.com/repos/${GITHUB_REPO}/actions/runs`;
  const response = await fetch(url, {
    headers: {
      'Authorization': `Bearer ${GITHUB_API_TOKEN}`,
      'Accept': 'application/vnd.github.v3+json',
    }
  });

  if (response.ok) {
    const data = await response.json();
    const latestRun = data.workflow_runs[0]; // Ambil run terbaru
    return latestRun.status;
  } else {
    console.error('Failed to fetch workflow status:', response.statusText);
    return 'offline';
  }
}

// Cron job untuk memeriksa status setiap 10 menit
cron.schedule('*/10 * * * *', async () => {
  const status = await checkWorkflowStatus();
  console.log('GitHub Actions Status:', status);
});

// Halaman utama untuk menampilkan status GitHub Actions
app.get('/', async (req, res) => {
  const status = await checkWorkflowStatus();
  const statusMessage = status === 'success' ? 'Github Online' : 'Github Offline';
  const statusColor = status === 'success' ? 'green' : 'red';
  res.render('index', { statusMessage, statusColor });
});

// Mulai server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});