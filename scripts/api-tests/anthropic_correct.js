// Correct Anthropic example: uses x-api-key header
const fetch = require('node-fetch');
const ANTHROPIC_URL = process.env.ANTHROPIC_URL || 'https://api.anthropic.com/v1/complete';
const ANTHROPIC_KEY = process.env.ANTHROPIC_KEY || 'REPLACE_ME';

async function run() {
  const payload = { prompt: 'Hello' };
  const res = await fetch(ANTHROPIC_URL, {
    method: 'POST',
    headers: {
      'x-api-key': ANTHROPIC_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  });

  console.log('status', res.status);
  console.log(await res.text());
}

run().catch(console.error);
