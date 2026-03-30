-- Migration: Add buyer_id to orders table
-- This enables tracking which logged-in user placed each order
-- buyer_id is nullable to support guest checkout

ALTER TABLE orders ADD COLUMN buyer_id int DEFAULT NULL;

ALTER TABLE orders ADD CONSTRAINT fk_orders_buyer 
  FOREIGN KEY (buyer_id) REFERENCES users(user_id) ON DELETE SET NULL;

-- Create index for efficient lookups by buyer_id
CREATE INDEX idx_orders_buyer ON orders(buyer_id);
