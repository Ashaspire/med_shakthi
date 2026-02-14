-- ============================================================================
-- BANNER MANAGEMENT SYSTEM - COMPLETE DATABASE SETUP
-- Consolidated setup script for Supabase
-- ============================================================================

-- ============================================================================
-- SECTION 1: BANNERS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS banners (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  image_url TEXT NOT NULL,
  supplier_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  supplier_name TEXT,
  category TEXT NOT NULL CHECK (category IN ('Medicines', 'Devices', 'Health', 'Vitamins')),
  active BOOLEAN DEFAULT true,
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- SECTION 2: PERFORMANCE INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_banners_active ON banners(active);
CREATE INDEX IF NOT EXISTS idx_banners_supplier_id ON banners(supplier_id);
CREATE INDEX IF NOT EXISTS idx_banners_category ON banners(category);
CREATE INDEX IF NOT EXISTS idx_banners_dates ON banners(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_banners_active_dates ON banners(active, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_banners_created_at ON banners(created_at DESC);

-- ============================================================================
-- SECTION 3: ROW LEVEL SECURITY (RLS)
-- ============================================================================

ALTER TABLE banners ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Anyone can read active banners" ON banners;
DROP POLICY IF EXISTS "Suppliers can read own banners" ON banners;
DROP POLICY IF EXISTS "Suppliers can insert own banners" ON banners;
DROP POLICY IF EXISTS "Suppliers can update own banners" ON banners;
DROP POLICY IF EXISTS "Suppliers can delete own banners" ON banners;

-- Create RLS policies
CREATE POLICY "Anyone can read active banners"
ON banners FOR SELECT
USING (
  active = true 
  AND start_date <= NOW() 
  AND end_date >= NOW()
);

CREATE POLICY "Suppliers can read own banners"
ON banners FOR SELECT
USING (auth.uid() = supplier_id);

CREATE POLICY "Suppliers can insert own banners"
ON banners FOR INSERT
WITH CHECK (auth.uid() = supplier_id);

CREATE POLICY "Suppliers can update own banners"
ON banners FOR UPDATE
USING (auth.uid() = supplier_id)
WITH CHECK (auth.uid() = supplier_id);

CREATE POLICY "Suppliers can delete own banners"
ON banners FOR DELETE
USING (auth.uid() = supplier_id);

-- ============================================================================
-- SECTION 4: AUTO-UPDATE TRIGGER
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_banners_updated_at ON banners;
CREATE TRIGGER update_banners_updated_at
BEFORE UPDATE ON banners
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- SECTION 5: AUTO-DISABLE EXPIRED BANNERS
-- ============================================================================

CREATE OR REPLACE FUNCTION disable_expired_banners()
RETURNS void AS $$
BEGIN
  UPDATE banners
  SET active = false
  WHERE active = true
  AND end_date < NOW();
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- SECTION 6: ENABLE REALTIME
-- ============================================================================

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
        CREATE PUBLICATION supabase_realtime FOR ALL TABLES;
    END IF;
END $$;
ALTER PUBLICATION supabase_realtime ADD TABLE banners;

-- ============================================================================
-- SECTION 7: STORAGE BUCKET POLICIES
-- Note: Create 'banner-images' bucket first (Public) in Supabase Dashboard
-- ============================================================================

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Drop existing storage policies
DROP POLICY IF EXISTS "Anyone can view banner images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload banner images" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own banner images" ON storage.objects;

-- Create storage policies
CREATE POLICY "Anyone can view banner images"
ON storage.objects FOR SELECT
USING (bucket_id = 'banner-images');

CREATE POLICY "Authenticated users can upload banner images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'banner-images' 
  AND auth.role() = 'authenticated'
);

CREATE POLICY "Users can delete their own banner images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'banner-images' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- ============================================================================
-- SECTION 8: VERIFICATION QUERIES
-- ============================================================================

-- View all banners
-- SELECT * FROM banners ORDER BY created_at DESC;

-- View active banners
-- SELECT * FROM banners 
-- WHERE active = true 
-- AND start_date <= NOW() 
-- AND end_date >= NOW();

-- Count banners by category
-- SELECT category, COUNT(*) as count 
-- FROM banners 
-- GROUP BY category 
-- ORDER BY count DESC;

-- Find expired but still active banners
-- SELECT id, title, end_date 
-- FROM banners 
-- WHERE active = true AND end_date < NOW();

-- ============================================================================
-- SETUP COMPLETE!
-- Next steps:
-- 1. Create 'banner-images' storage bucket (Public) in Supabase Dashboard
-- 2. Test by creating a banner in your app
-- ============================================================================
