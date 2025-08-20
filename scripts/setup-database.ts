/**
 * Pattern Whisper - Database Setup Script
 * Run with: npx tsx scripts/setup-database.ts
 */

import { createClient } from '@supabase/supabase-js'
import { readFileSync } from 'fs'
import { join } from 'path'

const SUPABASE_URL = 'https://ztgvmqdencafiyoaarpu.supabase.co'
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!SERVICE_ROLE_KEY) {
  console.error('❌ Missing SUPABASE_SERVICE_ROLE_KEY environment variable')
  console.log('Get it from: https://supabase.com/dashboard/project/ztgvmqdencafiyoaarpu/settings/api')
  process.exit(1)
}

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { persistSession: false }
})

async function runMigration(filename: string) {
  console.log(`🔄 Running ${filename}...`)
  
  try {
    const migrationPath = join(process.cwd(), 'supabase/migrations', filename)
    const sql = readFileSync(migrationPath, 'utf-8')
    
    const { error } = await supabase.rpc('exec_sql', { sql })
    
    if (error) {
      console.error(`❌ Error in ${filename}:`, error.message)
      return false
    }
    
    console.log(`✅ ${filename} completed`)
    return true
  } catch (error) {
    console.error(`❌ Failed to read ${filename}:`, error)
    return false
  }
}

async function setupDatabase() {
  console.log('🚀 Setting up Pattern Whisper database...\n')
  
  const migrations = [
    '001_initial_schema.sql',
    '002_pattern_analysis.sql', 
    '003_performance_indexes.sql'
  ]
  
  for (const migration of migrations) {
    const success = await runMigration(migration)
    if (!success) {
      console.error(`❌ Migration failed at ${migration}`)
      process.exit(1)
    }
  }
  
  console.log('\n✅ All migrations completed successfully!')
  console.log('📝 Next steps:')
  console.log('1. Run demo data (optional): npx tsx scripts/seed-demo-data.ts')
  console.log('2. Start development: npm run dev')
}

// Custom SQL execution function (Supabase doesn't have this built-in)
async function createExecFunction() {
  const { error } = await supabase.rpc('exec', { 
    query: `
      CREATE OR REPLACE FUNCTION exec_sql(sql text)
      RETURNS void
      LANGUAGE plpgsql
      AS $function$
      BEGIN
        EXECUTE sql;
      END;
      $function$;
    `
  })
  
  if (error && !error.message.includes('already exists')) {
    console.error('Failed to create exec function:', error)
  }
}

// Run setup
createExecFunction().then(setupDatabase).catch(console.error)