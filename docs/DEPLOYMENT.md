# Deployment Guide

## Vercel Environment Variables (Production)

Add these in Vercel Dashboard → Settings → Environment Variables:

```bash
# Public vars (safe to expose)
VITE_SUPABASE_URL=https://ztgvmqdencafiyoaarpu.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here

# Feature flags
VITE_DEMO_MODE=false
VITE_ENABLE_CRYPTO=true

# App URL
VITE_APP_URL=https://pattern-whisper.vercel.app
```

## Supabase Edge Function Secrets

Set these via Supabase CLI (NOT in Vercel):

```bash
# Service role key (for admin operations)
supabase secrets set SERVICE_ROLE_KEY=your_service_role_key_here

# Data provider keys (if using external APIs)
supabase secrets set POLYGON_API_KEY=your_key_here
supabase secrets set ALPHA_VANTAGE_KEY=your_key_here
```

## Deployment Steps

### 1. Database Setup
```bash
# Run migrations in Supabase Dashboard SQL Editor
# 1. Run 001_initial_schema.sql
# 2. Run 002_pattern_analysis.sql  
# 3. Run 003_performance_indexes.sql
# 4. Run demo_data.sql (optional)
```

### 2. Deploy Edge Functions
```bash
# Install Supabase CLI
brew install supabase/tap/supabase

# Login and link project
supabase login
supabase link --project-ref ztgvmqdencafiyoaarpu

# Deploy all functions
supabase functions deploy
```

### 3. Deploy Frontend to Vercel
```bash
# Connect GitHub repo to Vercel
# OR deploy manually:
npm run build
vercel --prod
```

## Local Development

### Environment Files

**.env** (for local Vite development)
```env
VITE_SUPABASE_URL=https://ztgvmqdencafiyoaarpu.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
VITE_DEMO_MODE=true
```

**.env.local** (for local Edge Functions)
```env
SUPABASE_URL=https://ztgvmqdencafiyoaarpu.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Start Everything
```bash
# Terminal 1: Frontend
npm run dev

# Terminal 2: Edge Functions
supabase functions serve --env-file .env.local

# Terminal 3: Database (if using local Supabase)
supabase start
```

## Monitoring

### Supabase Dashboard
- Database queries: https://supabase.com/dashboard/project/ztgvmqdencafiyoaarpu/editor
- Edge Functions logs: https://supabase.com/dashboard/project/ztgvmqdencafiyoaarpu/functions
- Auth users: https://supabase.com/dashboard/project/ztgvmqdencafiyoaarpu/auth/users

### Vercel Dashboard  
- Deployments: https://vercel.com/dashboard/project/pattern-whisper
- Analytics: https://vercel.com/dashboard/project/pattern-whisper/analytics
- Functions (if any): https://vercel.com/dashboard/project/pattern-whisper/functions

## Rollback Procedures

### Database
```bash
# View migration history
supabase db migrations list

# Create down migration
supabase db migrations new rollback_pattern_tables
```

### Edge Functions
```bash
# List deployed functions
supabase functions list

# Delete a function
supabase functions delete function-name
```

### Frontend
- Vercel automatically keeps previous deployments
- Instant rollback via Vercel dashboard

## Security Checklist

- [ ] Never commit SERVICE_ROLE_KEY to git
- [ ] RLS policies enabled on all user tables
- [ ] CORS configured for your domain only
- [ ] Rate limiting implemented on Edge Functions
- [ ] Input validation on all endpoints
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (React handles by default)

## Performance Checklist

- [ ] Database indexes created
- [ ] Pattern cache tables implemented
- [ ] Static assets on CDN
- [ ] Code splitting configured
- [ ] Images optimized (WebP format)
- [ ] Lighthouse score > 90