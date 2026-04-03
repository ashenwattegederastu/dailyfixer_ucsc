-- Migration: V6 Vehicle Overhaul
-- Date: 2026-04-03
-- Description: Limit drivers to 1 vehicle; replace single picture blob with 4 angle images;
--              add 3 document blobs (registration, insurance optional, revenue);
--              add vehicle_makes lookup table with seeded data.

-- ─────────────────────────────────────────────────────────────
-- Step 1: If any driver has more than 1 vehicle, keep only the
--         most recently created one and delete the rest.
-- ─────────────────────────────────────────────────────────────
DELETE FROM vehicles
WHERE id NOT IN (
    SELECT max_id FROM (
        SELECT MAX(id) AS max_id
        FROM vehicles
        GROUP BY driver_id
    ) AS latest
);

-- ─────────────────────────────────────────────────────────────
-- Step 2: Drop old single picture column, add 4 angle images
--         and 3 document columns, enforce 1-vehicle-per-driver.
-- ─────────────────────────────────────────────────────────────
ALTER TABLE vehicles
    DROP COLUMN picture,
    ADD COLUMN img_front        VARCHAR(500) NULL     AFTER plate_number,
    ADD COLUMN img_left         VARCHAR(500) NULL     AFTER img_front,
    ADD COLUMN img_right        VARCHAR(500) NULL     AFTER img_left,
    ADD COLUMN img_back         VARCHAR(500) NULL     AFTER img_right,
    ADD COLUMN doc_registration VARCHAR(500) NULL     AFTER img_back,
    ADD COLUMN doc_insurance    VARCHAR(500) NULL     AFTER doc_registration,
    ADD COLUMN doc_revenue      VARCHAR(500) NULL     AFTER doc_insurance,
    ADD UNIQUE KEY uq_driver_vehicle (driver_id);

-- ─────────────────────────────────────────────────────────────
-- Step 3: Create vehicle_makes lookup table
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `vehicle_makes` (
    `id`        INT         NOT NULL AUTO_INCREMENT,
    `category`  VARCHAR(50) NOT NULL,
    `make_name` VARCHAR(100) NOT NULL,
    `is_custom` TINYINT(1)  NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_make` (`category`, `make_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ─────────────────────────────────────────────────────────────
-- Step 4: Seed built-in makes (is_custom = 0)
-- ─────────────────────────────────────────────────────────────
INSERT IGNORE INTO vehicle_makes (category, make_name, is_custom) VALUES
    -- Bike
    ('Bike', 'Honda', 0),
    ('Bike', 'Yamaha', 0),
    ('Bike', 'Suzuki', 0),
    ('Bike', 'Kawasaki', 0),
    ('Bike', 'Bajaj', 0),
    ('Bike', 'TVS', 0),
    ('Bike', 'Hero', 0),
    -- Three-wheel
    ('Three-wheel', 'Bajaj', 0),
    ('Three-wheel', 'TVS', 0),
    ('Three-wheel', 'Piaggio', 0),
    ('Three-wheel', 'Mahindra', 0),
    ('Three-wheel', 'HERMI Electric', 0),
    -- Lorry
    ('Lorry', 'Isuzu', 0),
    ('Lorry', 'Mitsubishi Fuso', 0),
    ('Lorry', 'Hino', 0),
    ('Lorry', 'Toyota', 0),
    ('Lorry', 'Tata', 0),
    ('Lorry', 'Ashok Leyland', 0),
    ('Lorry', 'Mahindra', 0),
    ('Lorry', 'Eicher', 0),
    ('Lorry', 'Nissan Diesel', 0);
