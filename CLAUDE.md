# Pattern Whisper - Project Specification

## 🎯 Philosophy & Core Principles

Every project decision optimizes for **clarity over cleverness**, **speed of iteration**, and **emotional resonance** with users.

### Development Philosophy
- **Designer's Mindset**: UI/UX is as important as logic
- **Zero-Friction Workflows**: Minimal steps to test, preview, or ship
- **Code for the Next Person**: Write for clarity, not just functionality
- **Mobile-First Always**: Real-user flows, not abstractions
- **Responsive Design Mandatory**: Every component must work across all screen sizes
- **AI-Assisted Development**: Leverage AI for speed and quality

### Decision Framework
- **User Impact First**: Does this improve the user experience?
- **Speed of Iteration**: Can we test this quickly?
- **Emotional Resonance**: Does this create delight?
- **Technical Debt**: Are we building for long-term maintainability?

## Project Overview
Pattern Whisper is a production-quality stock pattern matching application that finds historical patterns similar to current price movements and predicts future outcomes based on historical analogs. Built with a consumer-focused mindset, optimizing for clarity, shareability, and actionable insights.

## 🚀 Current Status (Updated Aug 20, 2025)

### What's Working ✅
- **Database**: Fully operational with 3 tables, demo data, and optimized indexes
- **API Layer**: Type-safe functions connecting React to Supabase 
- **Connection Test**: `getStockWindow('NVDA', 5)` returns real data
- **Project Structure**: Clean, organized, and ready for scaling
- **Environment**: Configured for development and production
- **Documentation**: Comprehensive specs and deployment guides

### Ready to Use 🎯  
```bash
npm install && npm run dev
# Visit http://localhost:3000 to see database connection test
# All API functions are tested and working
```

### Next Sprint (Phase 2 - UI Components)
1. Ticker search with autocomplete
2. Basic price chart display  
3. Home page layout
4. Mobile-responsive design
5. Loading states and error handling

## Tech Stack
- **Frontend**: Vite + React 18 + TypeScript (fast dev, simple build)
- **Styling**: Tailwind CSS, shadcn/ui components, Lucide React icons
- **Database**: Supabase (PostgreSQL with pgvector extension)
- **State Management**: Zustand + TanStack Query
- **Charts**: Recharts (clean, minimal, no 3D)
- **Authentication**: Supabase Auth (email/password)
- **API**: Supabase Edge Functions (serverless)
- **Deployment**: Vercel (static site)
- **Image Generation**: html2canvas for Twitter sharing

## Core Features

### 1. Pattern Analysis Engine
- Analyzes 252-day rolling windows (configurable in backend)
- Finds historical analogs using vector similarity search
- Supports both equities and cryptocurrencies
- Handles both EOD and intraday data
- Clear, actionable insights for retail investors

### 2. User Features
- Email authentication with Supabase Auth
- Favorites/watchlist (persisted to database)
- Pattern comparison views
- Twitter sharing with optimized images (1200x675px)
- Mobile-first responsive design with emotional resonance

### 3. Pages & Routes
- `/` - Home page with search and recent patterns
- `/stocks/:ticker` - Stock pattern analysis
- `/crypto/:symbol` - Crypto pattern analysis  
- `/compare/:ticker1/:ticker2` - Pattern comparison
- `/favorites` - User's saved patterns
- `/auth` - Authentication pages

### 4. Visual Design Principles
- **Card-based layouts** with rounded-2xl corners
- **Circular badges** for match percentages and outcomes
- **Soft shadows** and generous spacing
- **Bold typography** for key metrics
- **Minimal animations** - smooth but not distracting
- **High contrast** for accessibility

## Database Architecture

### Core Tables (IMPLEMENTED ✅)
1. **stocks_daily** - Combined OHLCV + fundamentals (PE, PS, market cap, etc.)
2. **crypto_daily** - Crypto prices + token metrics (supply, market cap)
3. **macro_daily** - Economic indicators (Fed funds, CPI, VIX, etc.)
4. **user_favorites** - User saved tickers with RLS protection
5. **pattern_windows** - Pre-computed pattern features cache
6. **pattern_matches** - Cached similarity search results
7. **user_activity** - Track user interactions for recommendations

### Helper Functions (WORKING ✅)
- `get_stock_window(ticker, days)` - Retrieve stock data for analysis
- `get_crypto_window(ticker, days)` - Retrieve crypto data for analysis
- `v_stock_latest` - Latest stock data per ticker (materialized view)
- `v_crypto_latest` - Latest crypto data per ticker (materialized view)

### Key Indexes
- pgvector ivfflat index on embeddings for fast similarity search
- Composite indexes on (ticker, date) for time series queries
- User-specific indexes for favorites and history

## Configuration System
All adjustable parameters in `/config/app.config.ts`:
```typescript
export const config = {
  patterns: {
    windowLength: 252,
    minSimilarity: 0.7,
    maxAnalogs: 50,
    horizons: [21, 63, 126, 252]
  },
  data: {
    historicalStartYear: 1990,
    updateFrequency: 'daily'
  },
  confidence: {
    highThreshold: 0.8,
    mediumThreshold: 0.6
  },
  rateLimit: {
    perHour: 100,
    perMinute: 20
  }
}
```

## Development Principles

### Code Style (Clarity Over Cleverness)
- Functional TypeScript with strict typing
- React Server Components where possible
- Descriptive variable names (isLoading, hasError)
- File structure: components/helpers/types per module
- Comments explain "why", not "what"
- Zero magic numbers - all in config

### Performance Optimizations (Speed of Iteration)
- Dynamic imports for code splitting
- Image optimization with WebP and lazy loading
- Aggressive caching with TanStack Query (5min staleTime)
- Database query optimization with proper indexes
- Edge functions for computationally intensive tasks
- Skeleton loaders for perceived performance

### Security
- Row Level Security (RLS) in Supabase
- Input validation with Zod schemas
- SQL injection prevention via parameterized queries
- API rate limiting per user/IP
- Secure session management
- Never expose sensitive data in client code

### UI/UX Excellence (Emotional Resonance)
- **One-click actions** everywhere
- **Visual storytelling** through charts
- **Plain language** explanations
- **Twitter-optimized** sharing
- **Delightful micro-interactions**
- **Accessibility first** (ARIA labels, keyboard nav)

## MVP Scope

### Phase 1 (COMPLETED ✅ - Database & Infrastructure)
✅ Database schema and migrations (3 migrations + performance indexes)
✅ Configuration system (src/config/app.config.ts)
✅ CLAUDE.md documentation (comprehensive project spec)
✅ Seed scripts for demo data (NVDA, AAPL, MSFT, BTC, ETH, SOL)
✅ Supabase setup with RLS and vector extension
✅ API layer with type-safe functions (stocks, crypto, test utilities)
✅ Vite + React + TypeScript project structure
✅ Environment configuration (.env files)
✅ Database connection testing (working API calls)

### Phase 2 (IN PROGRESS 🚧 - Core UI Components)
⏳ Ticker search component with autocomplete
⏳ Pattern chart display (Recharts integration)
⏳ Basic pattern matching algorithm
⏳ Home page with search and recent patterns
⏳ Mobile-first responsive layouts
⏳ Loading states and error handling

### Phase 3 (PENDING - Advanced Features)
- Authentication system (Supabase Auth)
- User favorites and watchlist
- Pattern comparison page
- Twitter sharing with image generation
- Real-time data updates
- Performance optimizations

## Environment Variables (CONFIGURED ✅)
```env
# Supabase (Vite uses VITE_ prefix)
VITE_SUPABASE_URL=https://ztgvmqdencafiyoaarpu.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ... (configured)
SUPABASE_SERVICE_ROLE_KEY=eyJ... (configured for Edge Functions)

# App Configuration
VITE_APP_URL=https://pattern-whisper.vercel.app

# Feature Flags
VITE_DEMO_MODE=true
VITE_ENABLE_CRYPTO=true
VITE_ENABLE_INTRADAY=false
```

## Folder Structure (IMPLEMENTED ✅)
```
pattern-whisper/
├── src/                    # Frontend code (Vite structure)
│   ├── components/        # React components
│   │   ├── ui/           # shadcn/ui base components
│   │   ├── charts/       # Chart components (pending)
│   │   ├── patterns/     # Pattern-specific components (pending)
│   │   └── layout/       # Layout components (pending)
│   │
│   ├── lib/              # Utilities and API layer ✅
│   │   ├── supabase/     # Supabase client ✅
│   │   ├── api/          # API functions (stocks, crypto, test) ✅
│   │   └── utils/        # General utilities (pending)
│   │
│   ├── config/           # Configuration ✅
│   │   └── app.config.ts # All adjustable parameters ✅
│   │
│   ├── features/         # Feature modules (pending)
│   ├── stores/           # Zustand stores (pending)
│   ├── hooks/            # Custom React hooks (pending)
│   ├── types/            # TypeScript types (pending)
│   └── styles/           # Global styles ✅
│
├── supabase/             # Database layer ✅
│   ├── migrations/       # 3 SQL migration files ✅
│   │   ├── 001_initial_schema.sql ✅
│   │   ├── 002_pattern_analysis.sql ✅
│   │   └── 003_performance_indexes.sql ✅
│   │
│   ├── seed/            # Demo data ✅
│   │   └── demo_data.sql # NVDA/AAPL/MSFT/BTC/ETH/SOL ✅
│   │
│   └── functions/       # Edge Functions (pending)
│
├── docs/                # Documentation ✅
│   ├── ARCHITECTURE.md  # Technical decisions ✅
│   ├── DEPLOYMENT.md    # Deploy guide ✅
│   └── NEXT_STEPS.md    # What to build next ✅
│
└── Root config files ✅  # package.json, vite.config.ts, etc.
```

## Key Design Decisions

1. **Supabase over custom backend**: Faster development, built-in auth, real-time capabilities
2. **pgvector for similarity search**: Native Postgres extension, efficient for high-dimensional vectors
3. **Server Components first**: Better performance, SEO, reduced client bundle
4. **Zustand + TanStack Query**: Simple state management with powerful data fetching
5. **shadcn/ui components**: Customizable, accessible, well-maintained
6. **Mobile-first approach**: Majority of users will access via mobile devices
7. **Config-driven development**: All magic numbers and thresholds in one place

## Success Metrics
- Pattern match accuracy > 80%
- API response time < 500ms for pattern search
- Lighthouse scores: Performance > 90, Accessibility > 95
- User engagement: >3 patterns analyzed per session
- Twitter share rate > 20% of analyses
- Mobile usage > 60% of traffic

## Component Standards

### Every Component Must:
- Work on mobile (320px) to desktop (2560px)
- Include loading and error states
- Have proper TypeScript types
- Include JSDoc comments for props
- Support dark mode (via Tailwind)
- Be accessible (ARIA labels, keyboard nav)

### Chart Components Must:
- Be responsive and touch-friendly
- Include tooltips on hover/tap
- Support "Share Chart" functionality
- Use consistent color palette
- Animate smoothly but subtly

## Data Flow Architecture
```
User Action → Client Component → Server Action → Supabase → Response
                    ↓                              ↓
              TanStack Query ← ← ← ← ← ← Cached Result
                    ↓
              Zustand Store (UI State Only)
```

## Testing Strategy
- Unit tests for utility functions
- Component tests for critical UI
- E2E tests for user flows (auth, search, share)
- Visual regression tests for charts
- Performance testing for pattern matching
- Accessibility testing with axe-core

## Notes for Developers
- All pattern matching algorithms are configurable and swappable
- Database schema supports future ML model integration
- UI components are designed for easy A/B testing
- System is built to scale horizontally with Vercel's edge functions
- Prioritize user delight over technical perfection
- Ship fast, iterate based on user feedback
- When in doubt, choose the simpler solution