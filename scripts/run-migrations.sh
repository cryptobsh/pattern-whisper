#!/bin/bash

# Pattern Whisper - Database Migration Script
# Run this after installing Supabase CLI

echo "🚀 Running Pattern Whisper database migrations..."

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Install with:"
    echo "brew install supabase/tap/supabase"
    exit 1
fi

# Check if we're linked to the project
if [ ! -f .supabase/config.toml ]; then
    echo "🔗 Linking to Supabase project..."
    supabase link --project-ref ztgvmqdencafiyoaarpu
fi

# Run migrations in order
echo "📊 Running initial schema..."
supabase db push --include-all

echo "✅ Migrations completed!"
echo "📝 Next steps:"
echo "1. Run demo data: supabase db seed"
echo "2. Start development: npm run dev"