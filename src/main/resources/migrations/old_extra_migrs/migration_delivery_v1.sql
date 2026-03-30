-- ============================================================
-- Migration: Delivery System v1
-- Date: 2026-03-08
-- Description:
--   1. Create delivery_rates table (admin-managed, per vehicle type)
--   2. Add delivery_fee, delivery_latitude, delivery_longitude to orders
--   3. Add delivery_fee to store_orders
--   4. Drop driver-set fare columns from vehicles, add vehicle_category FK
-- ============================================================

-- 1. Create delivery_rates table
CREATE TABLE IF NOT EXISTS `delivery_rates` (
  `rate_id`             INT NOT NULL AUTO_INCREMENT,
  `vehicle_type`        VARCHAR(50) NOT NULL,
  `cost_per_km`         DECIMAL(10,2) NOT NULL,
  `base_fee`            DECIMAL(10,2) NOT NULL DEFAULT 100.00,
  `distribution_weight` DECIMAL(5,2)  NOT NULL DEFAULT 33.33
    COMMENT 'Percentage weight used in weighted-average customer price (weights should sum to 100)',
  `is_active`           TINYINT(1) NOT NULL DEFAULT 1,
  `created_at`          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rate_id`),
  UNIQUE KEY `uq_vehicle_type` (`vehicle_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Seed default vehicle types (skip if already exist)
INSERT IGNORE INTO `delivery_rates` (`vehicle_type`, `cost_per_km`, `base_fee`, `distribution_weight`) VALUES
  ('Bike',        60.00, 100.00, 50.00),
  ('Three-wheel', 100.00, 100.00, 35.00),
  ('Lorry',       150.00, 100.00, 15.00);

-- 2. Add delivery columns to orders
ALTER TABLE `orders`
  ADD COLUMN `delivery_fee`       DECIMAL(10,2)  NOT NULL DEFAULT 0.00 AFTER `total_amount`,
  ADD COLUMN `delivery_latitude`  DECIMAL(10,7)  DEFAULT NULL,
  ADD COLUMN `delivery_longitude` DECIMAL(11,7)  DEFAULT NULL;

-- 3. Add delivery_fee to store_orders
ALTER TABLE `store_orders`
  ADD COLUMN `delivery_fee` DECIMAL(10,2) NOT NULL DEFAULT 0.00 AFTER `store_total`;

-- 4. Update vehicles table: drop driver-set fare columns, add vehicle_category
ALTER TABLE `vehicles`
  DROP COLUMN `fare_first_km`,
  DROP COLUMN `fare_next_km`,
  ADD COLUMN `vehicle_category` VARCHAR(50) NOT NULL DEFAULT 'Bike' AFTER `plate_number`;
