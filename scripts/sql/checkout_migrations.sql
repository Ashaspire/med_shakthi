-- ============================================================================
-- CHECKOUT & ORDERS - DATABASE MIGRATIONS & DEBUGGING QUERIES
-- Consolidated SQL scripts from checkout and payment implementation
-- ============================================================================

-- ============================================================================
-- SECTION 1: ORDERS TABLE SCHEMA UPDATES
-- ============================================================================

-- Check if shipping_address and payment_method_id columns exist
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'orders'
AND column_name IN ('shipping_address', 'payment_method_id', 'order_items')
ORDER BY ordinal_position;

-- Add missing columns to orders table
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS shipping_address TEXT,
ADD COLUMN IF NOT EXISTS payment_method_id UUID REFERENCES user_payment_methods(id);

-- ============================================================================
-- SECTION 2: ORDER_DETAILS TABLE SCHEMA
-- ============================================================================

-- Inspect order_details table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'order_details'
ORDER BY ordinal_position;

-- Expected columns:
-- id (uuid), order_id (uuid), product_id (uuid), item_name (text),
-- brand (text), unit_size (text), image_url (text), price (numeric),
-- quantity (integer), created_at (timestamp)

-- ============================================================================
-- SECTION 3: VERIFICATION QUERIES
-- ============================================================================

-- Check orders table structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns  
WHERE table_name = 'orders'
ORDER BY ordinal_position;

-- Verify recent orders have shipping_address and payment_method_id
SELECT 
  id, 
  user_id,
  shipping_address,
  payment_method_id,
  status,
  total_amount,
  created_at
FROM orders
ORDER BY created_at DESC
LIMIT 10;

-- Check order_details for specific order
SELECT 
  od.id,
  od.order_id,
  od.item_name,
  od.brand,
  od.quantity,
  od.price,
  (od.quantity * od.price) as subtotal
FROM order_details od
WHERE od.order_id = 'YOUR_ORDER_ID_HERE'
ORDER BY od.created_at;

-- ============================================================================
-- SECTION 4: TROUBLESHOOTING QUERIES
-- ============================================================================

-- Find orders missing items in order_details
SELECT o.id, o.created_at, o.status
FROM orders o
LEFT JOIN order_details od ON o.id = od.order_id
WHERE od.id IS NULL
ORDER BY o.created_at DESC;

-- Check foreign key constraints
SELECT
  tc.table_name, 
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name IN ('orders', 'order_details');
