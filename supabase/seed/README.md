# Database Setup Instructions

## Quick Start

### 1. Run Migration in Supabase

1. Go to your Supabase project: https://supabase.com/dashboard/project/ztgvmqdencafiyoaarpu
2. Navigate to **SQL Editor**
3. Copy the contents of `migrations/001_initial_schema.sql`
4. Paste and click **Run**
5. You should see "Success. No rows returned"

### 2. Load Demo Data (Optional)

1. Still in SQL Editor
2. Copy the contents of `seed/demo_data.sql`
3. Paste and click **Run**
4. This loads sample data for NVDA, AAPL, MSFT, BTC, ETH, SOL

### 3. Verify Setup

Run this query to verify:

```sql
-- Check tables exist
select table_name 
from information_schema.tables 
where table_schema = 'public' 
and table_name in ('stocks_daily', 'crypto_daily', 'macro_daily', 'user_favorites');

-- Check demo data
select ticker, count(*) as days 
from stocks_daily 
group by ticker;

select ticker, count(*) as days 
from crypto_daily 
group by ticker;
```

## Environment Variables

Add these to your `.env.local` file:

```env
# From your Supabase project settings
NEXT_PUBLIC_SUPABASE_URL=https://ztgvmqdencafiyoaarpu.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0Z3ZtcWRlbmNhZml5b2FhcnB1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MTY5MjIsImV4cCI6MjA3MTI5MjkyMn0.Zszgp1oraDnFm8zKieA3U8GXCFJ_tO0Zjs_ybWNSrKs

# Get this from Supabase Settings > API > Service Role Key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Create your own secure token for API protection
AUTH_TOKEN=your_secure_random_token_here
```

## Database Schema

### Tables Created

1. **stocks_daily** - Stock prices + fundamentals
   - Primary key: (ticker, d)
   - Indexes: date, ticker, sector

2. **crypto_daily** - Crypto prices + token metrics
   - Primary key: (ticker, d)
   - Indexes: date, ticker

3. **macro_daily** - Economic indicators
   - Primary key: d

4. **user_favorites** - User saved tickers
   - Primary key: (user_id, ticker)
   - Row Level Security enabled

### Views Created

- **v_stock_latest** - Latest stock data per ticker
- **v_crypto_latest** - Latest crypto data per ticker

### Functions Created

- **get_stock_window(ticker, days)** - Get recent stock data
- **get_crypto_window(ticker, days)** - Get recent crypto data

## Next Steps

1. Test the API endpoints (see `/api` folder)
2. Start ingesting real data
3. Build the pattern matching logic
4. Create the UI components

## Troubleshooting

### "Permission denied" errors
- Make sure RLS policies are created
- Check that you're using the correct API keys

### "Table does not exist" errors
- Run the migration script first
- Check you're in the right Supabase project

### Demo data issues
- The seed script uses `generate_series` which requires PostgreSQL
- Make sure to run migration before seed