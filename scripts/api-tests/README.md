API auth header test scripts

Usage (Node.js):
- Install node-fetch if needed: `npm install node-fetch`
- Set environment variables for keys/URLs, then run the scripts.

Examples:

OPENAI_KEY and OPENAI_URL:
  node openai_faulty.js
  node openai_correct.js

ANTHROPIC_KEY and ANTHROPIC_URL:
  node anthropic_faulty.js
  node anthropic_correct.js

AZURE_KEY and AZURE_URL:
  node azure_faulty.js
  node azure_correct.js

Notes:
- Faulty scripts intentionally use the wrong header to trigger auth failures.
- Correct scripts show the expected header formats per provider.
