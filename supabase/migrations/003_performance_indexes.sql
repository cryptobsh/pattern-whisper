-- Pattern Whisper - Performance Optimizations
-- Run after data is loaded

-- 1) Partial indexes for common queries
-- Only index recent data that's accessed frequently
-- Note: Using fixed date for immutable index. Update periodically.
create index if not exists idx_stocks_recent 
on stocks_daily(ticker, d desc) 
where d > '2023-01-01'::date;

create index if not exists idx_crypto_recent 
on crypto_daily(ticker, d desc) 
where d > '2024-01-01'::date;

-- 2) Composite indexes for pattern analysis
create index if not exists idx_stocks_pattern_lookup 
on stocks_daily(ticker, d, close, volume, pe, market_cap);

-- 3) Covering index for latest data view
-- Note: Update the date monthly for optimal performance
create index if not exists idx_stocks_latest_covering 
on stocks_daily(ticker, d desc, close, pe, ps, market_cap) 
where d > '2025-07-01'::date;

-- 4) Function for fast pattern window retrieval
create or replace function get_pattern_window(
  p_ticker text,
  p_end_date date default CURRENT_DATE,
  p_days int default 252
)
returns table (
  d date,
  close double precision,
  volume double precision,
  returns double precision,
  pe double precision,
  market_cap double precision
)
language sql
stable
parallel safe
as $$
  with window_data as (
    select 
      d,
      close,
      volume,
      pe,
      market_cap,
      lag(close) over (order by d) as prev_close
    from stocks_daily
    where ticker = p_ticker
      and d <= p_end_date
      and d > p_end_date - (p_days * 2 || ' days')::interval
    order by d desc
    limit p_days + 1
  )
  select 
    d,
    close,
    volume,
    ln(close / nullif(prev_close, 0)) as returns,
    pe,
    market_cap
  from window_data
  where prev_close is not null
  order by d desc
  limit p_days;
$$;

-- 5) Materialized view for sector averages (refresh daily)
create materialized view if not exists mv_sector_metrics as
select 
  sector_code,
  d,
  avg(pe) filter (where pe > 0 and pe < 100) as avg_pe,
  avg(ps) filter (where ps > 0 and ps < 50) as avg_ps,
  avg(div_yield) as avg_div_yield,
  count(distinct ticker) as stock_count
from stocks_daily
where d > '2025-07-01'::date
group by sector_code, d;

create unique index on mv_sector_metrics(sector_code, d);

-- 6) Table partitioning setup (for future scaling)
-- When you hit 10M+ rows, convert to partitioned tables:
-- ALTER TABLE stocks_daily PARTITION BY RANGE (d);
-- CREATE TABLE stocks_daily_2025 PARTITION OF stocks_daily
--   FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

comment on function get_pattern_window is 'Optimized function for retrieving pattern analysis windows with returns calculation';