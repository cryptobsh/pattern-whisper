-- Pattern Whisper - Pattern Analysis Tables
-- Run after initial schema

-- 1) Pattern windows cache (pre-computed for speed)
create table if not exists pattern_windows (
  id uuid default gen_random_uuid() primary key,
  ticker text not null,
  window_end date not null,
  window_days int not null default 252,
  
  -- Computed features (stored as JSONB for flexibility)
  price_features jsonb not null, -- returns, volatility, drawdown, etc.
  volume_features jsonb,          -- volume patterns, liquidity
  fundamental_features jsonb,     -- PE/PS at window end
  
  -- Pattern embedding for similarity search
  embedding vector(128),
  
  -- Metadata
  computed_at timestamptz default now(),
  expires_at timestamptz default (now() + interval '7 days'),
  
  -- Unique constraint to prevent duplicates
  unique(ticker, window_end, window_days)
);

create index idx_pattern_windows_ticker_date on pattern_windows(ticker, window_end);
create index idx_pattern_windows_expires on pattern_windows(expires_at);

-- Vector similarity index (create after data loaded)
-- CREATE INDEX pattern_embedding_idx ON pattern_windows 
-- USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- 2) Pattern matches cache (expensive queries cached)
create table if not exists pattern_matches (
  id uuid default gen_random_uuid() primary key,
  
  -- Query parameters
  source_ticker text not null,
  source_date date not null,
  window_days int not null default 252,
  
  -- Results (array of matches)
  matches jsonb not null, -- [{ticker, date, similarity, forward_returns}, ...]
  match_count int not null,
  
  -- Confidence metrics
  avg_similarity float,
  confidence_score float,
  
  -- Cache management
  computed_at timestamptz default now(),
  expires_at timestamptz default (now() + interval '24 hours'),
  
  unique(source_ticker, source_date, window_days)
);

create index idx_pattern_matches_lookup on pattern_matches(source_ticker, source_date);
create index idx_pattern_matches_expires on pattern_matches(expires_at);

-- 3) User activity tracking (for recommendations)
create table if not exists user_activity (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade,
  activity_type text not null, -- 'search', 'view', 'share', 'favorite'
  ticker text,
  metadata jsonb,
  created_at timestamptz default now()
);

create index idx_user_activity_user on user_activity(user_id, created_at desc);
create index idx_user_activity_ticker on user_activity(ticker);

-- Enable RLS on user activity
alter table user_activity enable row level security;

create policy "users_own_activity" on user_activity
  for all using (auth.uid() = user_id);

-- 4) Popular patterns (for homepage)
create materialized view if not exists mv_popular_patterns as
select 
  ticker,
  count(*) as search_count,
  max(created_at) as last_searched
from user_activity
where activity_type = 'search'
and created_at > now() - interval '7 days'
group by ticker
order by search_count desc
limit 20;

-- Refresh popular patterns every hour
create index on mv_popular_patterns(ticker);

-- Helper function to clean expired caches
create or replace function clean_expired_caches()
returns void
language sql
as $$
  delete from pattern_windows where expires_at < now();
  delete from pattern_matches where expires_at < now();
$$;

comment on table pattern_windows is 'Pre-computed pattern features and embeddings';
comment on table pattern_matches is 'Cached pattern similarity search results';
comment on table user_activity is 'Track user interactions for personalization';