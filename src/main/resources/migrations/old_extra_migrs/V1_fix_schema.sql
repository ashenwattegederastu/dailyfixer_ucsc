-- =============================================================================
-- V1_fix_schema.sql — Fix Database Schema Issues §1.1–1.5
-- Run this against your MySQL database BEFORE deploying updated Java code.
-- =============================================================================

-- Disable safe update mode (required for UPDATE ... JOIN without key column)
SET SQL_SAFE_UPDATES = 0;

-- §1.1: Add store_id FK to products table
-- ----------------------------------------
-- Add store_id column if it doesn't exist
ALTER TABLE products ADD COLUMN store_id INT AFTER store_username;

-- Populate store_id from existing store_username → users → stores
UPDATE products p
    JOIN users u ON p.store_username = u.username
    JOIN stores s ON u.user_id = s.user_id
SET p.store_id = s.store_id
WHERE p.store_id IS NULL;

-- Add FK constraint
ALTER TABLE products ADD CONSTRAINT fk_products_store
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE;


-- §1.2: Add store_id FK to orders table
-- ----------------------------------------
ALTER TABLE orders ADD COLUMN store_id INT AFTER store_username;

-- Populate store_id from existing store_username → users → stores
UPDATE orders o
    JOIN users u ON o.store_username = u.username
    JOIN stores s ON u.user_id = s.user_id
SET o.store_id = s.store_id
WHERE o.store_id IS NULL AND o.store_username IS NOT NULL;

-- Add FK constraint (SET NULL because we don't want to delete orders if a store is removed)
ALTER TABLE orders ADD CONSTRAINT fk_orders_store
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE SET NULL;


-- §1.3: Add first_name and last_name columns to orders table
-- -----------------------------------------------------------
ALTER TABLE orders ADD COLUMN first_name VARCHAR(100) AFTER customer_name;
ALTER TABLE orders ADD COLUMN last_name VARCHAR(100) AFTER first_name;

-- Populate from existing customer_name
UPDATE orders
SET first_name = SUBSTRING_INDEX(customer_name, ' ', 1),
    last_name  = TRIM(SUBSTRING(customer_name FROM LOCATE(' ', customer_name) + 1))
WHERE customer_name IS NOT NULL AND first_name IS NULL;

-- Handle single-word names (no space found → last_name gets the whole name, fix it)
UPDATE orders
SET last_name = ''
WHERE customer_name IS NOT NULL
  AND LOCATE(' ', customer_name) = 0
  AND last_name = customer_name;


-- §1.4: orders.product_name — no schema change needed
-- The column stays for PayHere gateway compatibility. order_items is the source of truth.


-- §1.5: store_orders table already exists — no schema change needed
-- The StoreOrderDAO will be created in Java to populate it during checkout.

-- =============================================================================
-- Verification queries (run these to confirm the migration worked):
-- =============================================================================
-- SELECT product_id, store_username, store_id FROM products;
-- SELECT order_id, customer_name, first_name, last_name, store_username, store_id FROM orders;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;
