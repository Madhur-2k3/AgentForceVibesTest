// Correct Azure OpenAI example (resource key): uses api-key header
const fetch = require('node-fetch');
const AZURE_URL = process.env.AZURE_URL || 'https://<your-resource>.openai.azure.com/openai/deployments/<deployment>/chat/completions?api-version=2023-05-15';
const AZURE_KEY = process.env.AZURE_KEY || 'REPLACE_ME';

async function run() {
  const payload = { messages: [{ role: 'user', content: 'Hello' }] };
  const res = await fetch(AZURE_URL, {
    method: 'POST',
    headers: {
      'api-key': AZURE_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  });

  console.log('status', res.status);
  console.log(await res.text());
}

run().catch(console.error);
