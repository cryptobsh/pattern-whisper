-- Pattern Whisper - Demo Seed Data
-- Run this after migrations to populate demo data

-- Clear existing demo data (optional)
delete from stocks_daily where ticker in ('NVDA', 'AAPL', 'MSFT');
delete from crypto_daily where ticker in ('BTC-USD', 'ETH-USD', 'SOL-USD');
delete from macro_daily where d >= '2025-08-01';

-- Insert demo stock data (last 5 days for testing)
insert into stocks_daily (ticker, d, open, high, low, close, adj_close, volume, pe, ps, ev_ebitda, market_cap, sector_code) values
-- NVDA
('NVDA', '2025-08-11', 136.5, 138.2, 135.8, 137.4, 137.4, 1180000000, 67.2, 39.8, 54.3, 3380000000000, 'tech'),
('NVDA', '2025-08-12', 137.4, 139.1, 136.9, 138.7, 138.7, 1210000000, 67.8, 40.1, 54.6, 3410000000000, 'tech'),
('NVDA', '2025-08-13', 138.7, 140.2, 137.5, 139.8, 139.8, 1195000000, 68.2, 40.4, 54.9, 3430000000000, 'tech'),
('NVDA', '2025-08-14', 139.8, 141.5, 138.2, 140.1, 140.1, 1225000000, 68.4, 40.5, 55.0, 3440000000000, 'tech'),
('NVDA', '2025-08-15', 139.2, 141.0, 137.8, 140.6, 140.6, 1230000000, 68.5, 40.3, 55.1, 3450000000000, 'tech'),
-- AAPL
('AAPL', '2025-08-11', 224.5, 226.2, 223.8, 225.4, 225.4, 45000000, 35.2, 7.8, 28.3, 3450000000000, 'tech'),
('AAPL', '2025-08-12', 225.4, 227.1, 224.9, 226.7, 226.7, 46000000, 35.4, 7.9, 28.4, 3470000000000, 'tech'),
('AAPL', '2025-08-13', 226.7, 228.2, 225.5, 227.8, 227.8, 44500000, 35.6, 7.9, 28.5, 3490000000000, 'tech'),
('AAPL', '2025-08-14', 227.8, 229.5, 226.2, 228.1, 228.1, 47000000, 35.6, 8.0, 28.6, 3495000000000, 'tech'),
('AAPL', '2025-08-15', 228.1, 229.8, 226.8, 229.2, 229.2, 48000000, 35.8, 8.0, 28.7, 3510000000000, 'tech'),
-- MSFT
('MSFT', '2025-08-11', 412.5, 415.2, 411.8, 414.4, 414.4, 18000000, 36.2, 14.8, 24.3, 3080000000000, 'tech'),
('MSFT', '2025-08-12', 414.4, 417.1, 413.9, 416.7, 416.7, 18500000, 36.4, 14.9, 24.4, 3100000000000, 'tech'),
('MSFT', '2025-08-13', 416.7, 419.2, 415.5, 418.8, 418.8, 17800000, 36.6, 15.0, 24.5, 3115000000000, 'tech'),
('MSFT', '2025-08-14', 418.8, 421.5, 417.2, 420.1, 420.1, 19000000, 36.7, 15.0, 24.6, 3125000000000, 'tech'),
('MSFT', '2025-08-15', 420.1, 422.8, 418.8, 421.9, 421.9, 19500000, 36.9, 15.1, 24.7, 3140000000000, 'tech');

-- Insert demo crypto data
insert into crypto_daily (ticker, coin_name, d, open, high, low, close, volume, total_supply, circulating_supply, market_cap) values
-- BTC
('BTC-USD', 'Bitcoin', '2025-08-11', 96500, 98200, 95800, 97800, 30000000000, 21000000, 19600000, 1917000000000),
('BTC-USD', 'Bitcoin', '2025-08-12', 97800, 99500, 96900, 98900, 31000000000, 21000000, 19600000, 1938000000000),
('BTC-USD', 'Bitcoin', '2025-08-13', 98900, 100500, 97500, 99200, 29500000000, 21000000, 19600000, 1944000000000),
('BTC-USD', 'Bitcoin', '2025-08-14', 99200, 101000, 98000, 99500, 32500000000, 21000000, 19600000, 1950000000000),
('BTC-USD', 'Bitcoin', '2025-08-15', 98500, 100200, 97000, 99880, 32000000000, 21000000, 19600000, 1958000000000),
-- ETH
('ETH-USD', 'Ethereum', '2025-08-11', 3120, 3180, 3090, 3150, 12000000000, 120500000, 120500000, 379500000000),
('ETH-USD', 'Ethereum', '2025-08-12', 3150, 3220, 3120, 3190, 12500000000, 120500000, 120500000, 384400000000),
('ETH-USD', 'Ethereum', '2025-08-13', 3190, 3250, 3150, 3210, 11800000000, 120500000, 120500000, 386800000000),
('ETH-USD', 'Ethereum', '2025-08-14', 3210, 3280, 3180, 3240, 13000000000, 120500000, 120500000, 390400000000),
('ETH-USD', 'Ethereum', '2025-08-15', 3240, 3300, 3200, 3265, 12800000000, 120500000, 120500000, 393400000000),
-- SOL
('SOL-USD', 'Solana', '2025-08-11', 185, 189, 183, 187, 2500000000, 580000000, 470000000, 87900000000),
('SOL-USD', 'Solana', '2025-08-12', 187, 192, 185, 190, 2600000000, 580000000, 470000000, 89300000000),
('SOL-USD', 'Solana', '2025-08-13', 190, 194, 188, 192, 2400000000, 580000000, 470000000, 90240000000),
('SOL-USD', 'Solana', '2025-08-14', 192, 196, 190, 194, 2700000000, 580000000, 470000000, 91180000000),
('SOL-USD', 'Solana', '2025-08-15', 194, 198, 191, 196, 2650000000, 580000000, 470000000, 92120000000);

-- Insert demo macro data
insert into macro_daily (d, fed_funds, cpi_yoy, ust2y, ust10y, vix, dxy, wti, spx_ret) values
('2025-08-11', 4.88, 2.7, 4.15, 4.05, 13.2, 102.8, 76.5, 0.003),
('2025-08-12', 4.88, 2.7, 4.18, 4.08, 13.5, 103.0, 77.2, 0.005),
('2025-08-13', 4.88, 2.7, 4.20, 4.10, 13.8, 103.1, 77.5, -0.002),
('2025-08-14', 4.88, 2.7, 4.19, 4.09, 13.4, 103.0, 77.8, 0.004),
('2025-08-15', 4.88, 2.7, 4.20, 4.10, 13.5, 103.2, 77.8, 0.004);

-- Add some historical data for pattern matching (30 more days)
-- This would be expanded with real historical data in production
insert into stocks_daily (ticker, d, open, high, low, close, adj_close, volume, pe, ps, market_cap, sector_code)
select 
  'NVDA' as ticker,
  ('2025-08-10'::date - (n || ' days')::interval)::date as d,
  135 - (random() * 10) as open,
  137 - (random() * 10) as high,
  133 - (random() * 10) as low,
  135 - (random() * 10) as close,
  135 - (random() * 10) as adj_close,
  (1100000000 + random() * 200000000)::bigint as volume,
  65 + (random() * 5) as pe,
  38 + (random() * 3) as ps,
  3300000000000 + (random() * 100000000000) as market_cap,
  'tech' as sector_code
from generate_series(1, 30) as n;

-- Similar for AAPL and MSFT
insert into stocks_daily (ticker, d, open, high, low, close, adj_close, volume, pe, ps, market_cap, sector_code)
select 
  'AAPL' as ticker,
  ('2025-08-10'::date - (n || ' days')::interval)::date as d,
  220 + (random() * 5) as open,
  222 + (random() * 5) as high,
  218 + (random() * 5) as low,
  220 + (random() * 5) as close,
  220 + (random() * 5) as adj_close,
  (40000000 + random() * 10000000)::bigint as volume,
  34 + (random() * 2) as pe,
  7.5 + (random() * 0.5) as ps,
  3400000000000 + (random() * 50000000000) as market_cap,
  'tech' as sector_code
from generate_series(1, 30) as n;

insert into stocks_daily (ticker, d, open, high, low, close, adj_close, volume, pe, ps, market_cap, sector_code)
select 
  'MSFT' as ticker,
  ('2025-08-10'::date - (n || ' days')::interval)::date as d,
  410 + (random() * 10) as open,
  412 + (random() * 10) as high,
  408 + (random() * 10) as low,
  410 + (random() * 10) as close,
  410 + (random() * 10) as adj_close,
  (17000000 + random() * 3000000)::bigint as volume,
  35 + (random() * 2) as pe,
  14 + (random() * 1) as ps,
  3000000000000 + (random() * 50000000000) as market_cap,
  'tech' as sector_code
from generate_series(1, 30) as n;