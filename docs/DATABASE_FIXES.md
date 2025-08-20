# Database Migration Fixes

## Error: Functions in index predicate must be marked IMMUTABLE

### Problem
PostgreSQL requires functions used in index predicates (WHERE clauses in indexes) to be marked as IMMUTABLE. Functions like `current_date` and `now()` are not immutable because they return different values over time.

### Solution
Replace dynamic dates with fixed dates in index predicates.

## Fixed Files

### ✅ supabase/migrations/003_performance_indexes.sql
- Changed `current_date - interval '2 years'` to `'2023-01-01'::date`
- Changed `current_date - interval '1 year'` to `'2024-01-01'::date` 
- Changed `current_date - interval '30 days'` to `'2025-07-01'::date`

### Migration Commands (Run in Supabase SQL Editor)

1. **First run**: `001_initial_schema.sql` ✅
2. **Then run**: `002_pattern_analysis.sql` ✅
3. **Finally run**: `003_performance_indexes.sql` ✅ (now fixed)

## Maintenance Notes

### Index Date Updates
These partial indexes should be updated periodically for optimal performance:

```sql
-- Update annually (around January)
DROP INDEX IF EXISTS idx_stocks_recent;
CREATE INDEX idx_stocks_recent 
ON stocks_daily(ticker, d DESC) 
WHERE d > '2024-01-01'::date;

-- Update monthly for latest data index
DROP INDEX IF EXISTS idx_stocks_latest_covering;
CREATE INDEX idx_stocks_latest_covering 
ON stocks_daily(ticker, d DESC, close, pe, ps, market_cap) 
WHERE d > '2025-08-01'::date;
```

### Alternative: Use Functions Instead of Indexes

If you prefer dynamic dates, create immutable functions:

```sql
-- Create immutable function
CREATE OR REPLACE FUNCTION get_recent_date()
RETURNS date
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT '2023-01-01'::date;
$$;

-- Use in index
CREATE INDEX idx_stocks_dynamic 
ON stocks_daily(ticker, d DESC) 
WHERE d > get_recent_date();
```

### Why Fixed Dates Are Better for MVP

1. **Predictable performance** - Index size doesn't change daily
2. **Simpler maintenance** - No function updates needed
3. **Clear intent** - Explicit about what data is indexed
4. **Production ready** - Many large systems use this pattern

## Test the Fix

After running the migrations, test with:

```sql
-- Verify indexes were created
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename IN ('stocks_daily', 'crypto_daily')
ORDER BY indexname;

-- Test function
SELECT * FROM get_pattern_window('NVDA', '2025-08-15', 5);
```

The migrations should now run without errors!