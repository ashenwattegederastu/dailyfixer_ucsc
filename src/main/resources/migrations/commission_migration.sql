-- ============================================================
-- Commission System Migration
-- Backfills 10% commission on existing DELIVERED orders.
-- The commission and payable_amount columns already exist
-- in store_orders (from schema.sql), this just populates them.
-- Run ONCE against dailyfixer_main.
-- ============================================================

SET SQL_SAFE_UPDATES = 0;

UPDATE store_orders so
JOIN orders o ON so.order_id = o.order_id
SET so.commission     = ROUND(so.store_total * 0.10, 2),
    so.payable_amount = ROUND(so.store_total * 0.90, 2)
WHERE UPPER(o.status) = 'DELIVERED'
  AND so.commission = 0.00;

SET SQL_SAFE_UPDATES = 1;
