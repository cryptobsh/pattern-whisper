-- Pattern Whisper - Vector Index for Pattern Matching
-- Run this AFTER you have some data in pattern_windows table

-- Create the critical vector similarity index
-- This enables fast pattern matching via pgvector
CREATE INDEX IF NOT EXISTS pattern_embedding_idx 
ON pattern_windows 
USING ivfflat (embedding vector_cosine_ops) 
WITH (lists = 100);

-- Analyze table for better query planning
ANALYZE pattern_windows;

comment on index pattern_embedding_idx is 'Vector similarity index for fast pattern matching using cosine distance';