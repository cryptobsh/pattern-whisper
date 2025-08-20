# Pattern Whisper 📈

> Find patterns in history. See what happened next.

A mobile-first stock pattern matching application that uses historical data to predict future price movements.

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Set up database (run in Supabase SQL editor)
# 1. Run supabase/migrations/001_initial_schema.sql
# 2. Run supabase/migrations/002_pattern_analysis.sql
# 3. Run supabase/migrations/003_performance_indexes.sql

# Start development
npm run dev
```

## 📁 Project Structure

```
pattern-whisper/
├── docs/                      # Documentation
│   ├── ARCHITECTURE.md       # Technical architecture decisions
│   ├── DEPLOYMENT.md         # Deployment guide
│   └── API.md               # API documentation
│
├── src/                      # Frontend application (Vite + React)
│   ├── components/          # React components
│   │   ├── charts/         # Chart components
│   │   ├── patterns/       # Pattern-specific components
│   │   └── ui/            # shadcn/ui components
│   │
│   ├── config/             # Configuration
│   │   └── app.config.ts  # Application settings
│   │
│   ├── lib/               # Utilities
│   │   ├── supabase.ts   # Supabase client
│   │   ├── analytics.ts  # Pattern analysis logic
│   │   └── twitter.ts    # Share functionality
│   │
│   ├── hooks/             # Custom React hooks
│   ├── pages/             # Page components
│   ├── stores/            # Zustand stores
│   └── types/             # TypeScript types
│
├── supabase/                # Backend (Database + Functions)
│   ├── migrations/         # Database migrations
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_pattern_analysis.sql
│   │   └── 003_performance_indexes.sql
│   │
│   ├── seed/              # Seed data for development
│   │   └── demo_data.sql
│   │
│   └── functions/         # Edge Functions
│       ├── analyze-pattern/     # Core pattern matching
│       ├── user-favorites/      # User operations
│       ├── ingest-data/        # Data ingestion
│       └── shared/             # Shared utilities
│
├── public/                 # Static assets
├── .env                   # Local environment variables
├── .env.example          # Environment template
├── CLAUDE.md             # AI assistant context
└── package.json
```

## 🔑 Environment Variables

Copy `.env.example` to `.env` and fill in:

```env
# Supabase (get from dashboard)
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key

# Features
VITE_DEMO_MODE=true
VITE_ENABLE_CRYPTO=true
```

## 🏗️ Architecture

- **Frontend**: Vite + React + TypeScript
- **Database**: Supabase (PostgreSQL + pgvector)
- **API**: Supabase Edge Functions
- **Deployment**: Vercel (static) + Supabase (backend)

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed decisions.

## 🚢 Deployment

See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) for production deployment.

## 🧪 Development

```bash
# Run frontend
npm run dev

# Run Edge Functions locally
supabase functions serve

# Run tests
npm test

# Type checking
npm run type-check

# Linting
npm run lint
```

## 📊 Features

- **Pattern Matching**: Find similar historical patterns using vector similarity
- **Predictions**: See what happened after similar patterns
- **Mobile First**: Optimized for mobile devices
- **Twitter Sharing**: One-click sharing with beautiful cards
- **User Favorites**: Save and track patterns
- **Real-time Data**: Live updates (coming soon)

## 🎯 Philosophy

- **Clarity over cleverness**: Simple, readable code
- **Speed of iteration**: Ship fast, iterate based on feedback
- **Emotional resonance**: Create delightful user experiences
- **Mobile-first**: Real users, real devices

## 📝 License

MIT

## 🤝 Contributing

1. Read [CLAUDE.md](CLAUDE.md) for project context
2. Follow the architecture in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
3. Test on mobile devices
4. Create PR with clear description

---

Built with ❤️ for retail investors