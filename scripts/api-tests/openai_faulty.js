// Faulty OpenAI example: uses wrong header name (x-api-key) instead of Authorization: Bearer {key}
const fetch = require('node-fetch');
const OPENAI_URL = process.env.OPENAI_URL || 'https://api.openai.com/v1/chat/completions';
const OPENAI_KEY = process.env.OPENAI_KEY || 'REPLACE_ME';

async function run() {
  const payload = { model: 'gpt-4o-mini', messages: [{ role: 'user', content: 'Hello' }] };
  const res = await fetch(OPENAI_URL, {
    method: 'POST',
    headers: {
      // ❌ WRONG header for OpenAI
      'x-api-key': OPENAI_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  });

  console.log('status', res.status);
  console.log(await res.text());
}

run().catch(console.error);
