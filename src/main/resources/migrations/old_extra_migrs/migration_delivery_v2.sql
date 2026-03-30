-- ============================================================
-- Migration: Driver Delivery System v1
-- Phase 1: delivery_assignments table + driver home base location
-- ============================================================

-- 1. Add driver home base location to users table
--    Used for 10km radius filtering of delivery requests
ALTER TABLE `users`
  ADD COLUMN `latitude`  DECIMAL(10,7) DEFAULT NULL AFTER `city`,
  ADD COLUMN `longitude` DECIMAL(11,7) DEFAULT NULL AFTER `latitude`;

-- 2. delivery_assignments table
--    One row per order leg (one per store in a multi-store order).
--    Lifecycle: PENDING → ACCEPTED → DELIVERED | CANCELLED
--
--    Race condition is handled at the application layer via atomic:
--      UPDATE ... SET status='ACCEPTED', driver_id=? WHERE assignment_id=? AND status='PENDING'
--    MySQL InnoDB row-level locking serialises concurrent UPDATE on the same row,
--    so exactly one driver gets rowsAffected=1; all others get 0.
CREATE TABLE IF NOT EXISTS `delivery_assignments` (
  `assignment_id`         INT           NOT NULL AUTO_INCREMENT,
  `order_id`              VARCHAR(50)   NOT NULL,
  `store_id`              INT           NOT NULL,
  `driver_id`             INT           DEFAULT NULL,          -- NULL until a driver accepts
  `required_vehicle_type` VARCHAR(50)   NOT NULL,              -- set by store at dispatch time
  `delivery_fee_earned`   DECIMAL(10,2) NOT NULL DEFAULT 0.00, -- copied from orders.delivery_fee
  `pickup_address`        VARCHAR(255)  DEFAULT NULL,          -- store address (display only)
  `delivery_address`      TEXT          DEFAULT NULL,          -- customer address (display only)
  `delivery_lat`          DECIMAL(10,7) DEFAULT NULL,          -- customer lat (for driver nav)
  `delivery_lng`          DECIMAL(11,7) DEFAULT NULL,          -- customer lng
  `status`                VARCHAR(20)   NOT NULL DEFAULT 'PENDING',
  `assigned_at`           TIMESTAMP     NULL DEFAULT NULL,     -- when driver accepted
  `completed_at`          TIMESTAMP     NULL DEFAULT NULL,     -- when driver marked delivered
  `driver_payout_id`      INT           DEFAULT NULL,          -- FK added in Phase 5 migration
  `created_at`            TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`assignment_id`),
  UNIQUE  KEY `uq_da_order`  (`order_id`),                    -- one assignment per order leg
  KEY `idx_da_status`        (`status`),
  KEY `idx_da_driver`        (`driver_id`),
  KEY `idx_da_store`         (`store_id`),
  CONSTRAINT `fk_da_order`  FOREIGN KEY (`order_id`)  REFERENCES `orders`  (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_da_store`  FOREIGN KEY (`store_id`)  REFERENCES `stores`  (`store_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_da_driver` FOREIGN KEY (`driver_id`) REFERENCES `users`   (`user_id`)  ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
