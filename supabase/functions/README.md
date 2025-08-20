# Supabase Edge Functions

Since we're using Vite (client-side only), all API logic lives in Supabase Edge Functions.

## Setup

1. Install Supabase CLI:
```bash
brew install supabase/tap/supabase
```

2. Login to Supabase:
```bash
supabase login
```

3. Link your project:
```bash
supabase link --project-ref ztgvmqdencafiyoaarpu
```

4. Deploy functions:
```bash
supabase functions deploy
```

## Functions

### Core Functions Needed:

1. **analyze-pattern** - Main pattern matching logic
   - Input: ticker, date, window
   - Output: similar patterns + predictions

2. **ingest-data** - Data ingestion (protected)
   - Accepts: stock/crypto/macro data
   - Requires: AUTH_TOKEN

3. **get-favorites** - User favorites
   - Uses RLS for security

4. **share-pattern** - Generate Twitter share
   - Creates shareable image URL

## Environment Variables

Set in Supabase Dashboard → Edge Functions → Secrets:

```
AUTH_TOKEN=your_secure_token
DATA_PROVIDER_KEY=your_api_key
```

## Development

Test locally:
```bash
supabase functions serve analyze-pattern --env-file .env
```

## Architecture Benefits

- **No cold starts** - Always warm on Supabase
- **Auto-scaling** - Handles traffic spikes
- **Built-in auth** - Supabase handles JWT
- **Close to data** - Same region as database
- **TypeScript native** - Full type safety