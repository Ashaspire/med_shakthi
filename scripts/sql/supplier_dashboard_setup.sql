-- ============================================================================
-- SUPPLIER DASHBOARD - CONSOLIDATED SQL SCRIPTS
-- All SQL scripts for enabling realtime, test data, and debugging
-- ============================================================================

-- ============================================================================
-- SECTION 1: ENABLE SUPABASE REALTIME
-- ============================================================================

-- Enable Realtime for the tables
ALTER PUBLICATION supabase_realtime ADD TABLE orders;
ALTER PUBLICATION supabase_realtime ADD TABLE products;
ALTER PUBLICATION supabase_realtime ADD TABLE inventory;

-- Create indexes for better real-time performance
CREATE INDEX IF NOT EXISTS idx_orders_supplier_code ON orders(supplier_code);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_products_supplier_code ON products(supplier_code);
CREATE INDEX IF NOT EXISTS idx_inventory_supplier_id ON inventory(supplier_id);

-- ============================================================================
-- SECTION 2: TEST DATA INSERT
-- Note: Replace 'YOUR_USER_ID' and 'YOUR_CLIENT_USER_ID' with actual IDs
-- ============================================================================

-- Create test supplier
INSERT INTO suppliers (
  id, user_id, name, email, phone, supplier_code,
  company_name, password, verification_status
) VALUES (
  gen_random_uuid(),
  'YOUR_USER_ID', -- REPLACE THIS
  'Test Supplier Ltd',
  'test@supplier.com',
  '+91-9876543210',
  'SUP001',
  'Test Medical Supplies',
  'hashed_password_here',
  'VERIFIED'
) ON CONFLICT (supplier_code) DO NOTHING;

-- Add test products
INSERT INTO products (
  id, name, generic_name, brand, sku, price, expiry_date,
  unit_size, category, supplier_code, image_url, sub_category
) VALUES 
  (gen_random_uuid(), 'Paracetamol 500mg', 'Acetaminophen', 'Crocin', 'MED001', 50.00, '2026-12-31', '10 tablets', 'Medicines', 'SUP001', 'https://via.placeholder.com/150', 'Pain Relief'),
  (gen_random_uuid(), 'Amoxicillin 250mg', 'Amoxicillin', 'Amoxil', 'MED002', 120.00, '2026-10-31', '10 capsules', 'Medicines', 'SUP001', 'https://via.placeholder.com/150', 'Antibiotics'),
  (gen_random_uuid(), 'Vitamin D3 1000IU', 'Cholecalciferol', 'HealthVit', 'VIT001', 250.00, '2027-06-30', '60 tablets', 'Vitamins', 'SUP001', 'https://via.placeholder.com/150', 'Supplements')
ON CONFLICT (sku) DO NOTHING;

-- ============================================================================
-- SECTION 3: VERIFICATION AND DEBUGGING QUERIES
-- ============================================================================

-- Verify realtime is enabled
SELECT schemaname, tablename
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime'
AND tablename IN ('orders', 'products', 'inventory');

-- Check supplier stats
SELECT 
  status,
  COUNT(*) as count,
  SUM(total_amount) as total_revenue
FROM orders 
WHERE supplier_code = 'SUP001'
GROUP BY status;

-- Check RLS policies
SELECT schemaname, tablename, policyname, cmd
FROM pg_policies
WHERE tablename IN ('orders', 'products', 'inventory');
