-- Pattern Whisper - MVP Schema v1
-- Single migration file for initial setup

-- Enable vector extension for future pattern matching
create extension if not exists vector;

-- 1) STOCKS: Combined daily table (prices + fundamentals)
create table if not exists stocks_daily (
  ticker text not null,
  d date not null,
  -- Prices
  open double precision,
  high double precision,
  low double precision,
  close double precision,
  adj_close double precision,
  volume double precision,
  -- Fundamentals (daily snapshots, carry-forward allowed)
  pe double precision,
  ps double precision,
  ev_ebitda double precision,
  eps_ttm double precision,
  revenue_ttm double precision,
  fcf_ttm double precision,
  market_cap double precision,
  debt_to_equity double precision,
  gross_margin double precision,
  op_margin double precision,
  net_margin double precision,
  buyback_yield double precision,
  div_yield double precision,
  -- Meta
  sector_code text,
  currency text default 'USD',
  updated_at timestamptz default now(),
  primary key (ticker, d)
);

create index if not exists idx_stocks_daily_d on stocks_daily (d);
create index if not exists idx_stocks_daily_ticker on stocks_daily (ticker);
create index if not exists idx_stocks_daily_sector on stocks_daily (sector_code);

comment on table stocks_daily is 'All equity/ETF daily data: OHLCV + daily fundamentals snapshot';

-- 2) CRYPTO: Combined daily table (prices + token fundamentals)
create table if not exists crypto_daily (
  ticker text not null,                -- e.g., BTC-USD, ETH-USD, SOL-USD
  coin_name text,
  d date not null,
  -- Prices
  open double precision,
  high double precision,
  low double precision,
  close double precision,
  volume double precision,
  -- Token fundamentals
  total_supply double precision,
  circulating_supply double precision,
  market_cap double precision,
  -- Meta
  currency text default 'USD',
  updated_at timestamptz default now(),
  primary key (ticker, d)
);

create index if not exists idx_crypto_daily_d on crypto_daily (d);
create index if not exists idx_crypto_daily_ticker on crypto_daily (ticker);

comment on table crypto_daily is 'All crypto daily data: OHLCV + token fundamentals';

-- 3) MACRO: Lean macro factors
create table if not exists macro_daily (
  d date primary key,
  fed_funds double precision,
  cpi_yoy double precision,
  ust2y double precision,
  ust10y double precision,
  vix double precision,
  dxy double precision,
  wti double precision,
  spx_ret double precision,
  updated_at timestamptz default now()
);

comment on table macro_daily is 'Daily macro indicators affecting all markets';

-- 4) USER FAVORITES with RLS
create table if not exists user_favorites (
  user_id uuid references auth.users(id) on delete cascade,
  ticker text not null,                 -- stock or crypto symbol
  asset_type text check (asset_type in ('equity','etf','crypto')) not null,
  note text,
  created_at timestamptz default now(),
  primary key (user_id, ticker)
);

-- Enable Row Level Security
alter table user_favorites enable row level security;

-- Create policy for user favorites (if not exists)
do $$ 
begin
  if not exists (
    select 1 from pg_policies 
    where schemaname = 'public' 
    and tablename = 'user_favorites'
    and policyname = 'own_favorites'
  ) then
    create policy "own_favorites" on user_favorites
      for all using (auth.uid() = user_id) 
      with check (auth.uid() = user_id);
  end if;
end $$;

comment on table user_favorites is 'User saved tickers with RLS protection';

-- 5) Convenience views for latest data
create or replace view v_stock_latest as
select distinct on (ticker)
  ticker, 
  d, 
  close, 
  volume, 
  pe, 
  ps, 
  ev_ebitda, 
  market_cap, 
  eps_ttm, 
  fcf_ttm,
  sector_code, 
  currency, 
  updated_at
from stocks_daily
order by ticker, d desc;

comment on view v_stock_latest is 'Latest stock data per ticker';

create or replace view v_crypto_latest as
select distinct on (ticker)
  ticker, 
  coin_name, 
  d, 
  close, 
  volume, 
  total_supply, 
  circulating_supply, 
  market_cap,
  currency, 
  updated_at
from crypto_daily
order by ticker, d desc;

comment on view v_crypto_latest is 'Latest crypto data per ticker';

-- 6) Function to get pattern window data (helper for API)
create or replace function get_stock_window(
  p_ticker text,
  p_days integer default 252
)
returns table (
  d date,
  close double precision,
  adj_close double precision,
  volume double precision,
  pe double precision,
  ps double precision,
  market_cap double precision
) 
language sql
stable
as $$
  select 
    d,
    close,
    adj_close,
    volume,
    pe,
    ps,
    market_cap
  from stocks_daily
  where ticker = p_ticker
  order by d desc
  limit p_days;
$$;

comment on function get_stock_window is 'Get recent trading days for pattern analysis';

-- 7) Function to get crypto window data
create or replace function get_crypto_window(
  p_ticker text,
  p_days integer default 365
)
returns table (
  d date,
  close double precision,
  volume double precision,
  market_cap double precision,
  circulating_supply double precision
) 
language sql
stable
as $$
  select 
    d,
    close,
    volume,
    market_cap,
    circulating_supply
  from crypto_daily
  where ticker = p_ticker
  order by d desc
  limit p_days;
$$;

comment on function get_crypto_window is 'Get recent trading days for crypto pattern analysis';