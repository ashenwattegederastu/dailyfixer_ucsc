-- ============================================================
-- Recurring Bookings Migration
-- Technicians can enable recurring monthly bookings on their
-- service listings. Contracts last exactly 1 year (12 months).
-- Payments are handled physically between technician and user.
-- ============================================================

-- 1. Add recurring fields to services table
ALTER TABLE `services`
    ADD COLUMN `recurring_enabled` BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN `recurring_fee`     DECIMAL(10,2) DEFAULT NULL;

-- 2. Create recurring_contracts table
CREATE TABLE `recurring_contracts` (
    `contract_id`          INT           NOT NULL AUTO_INCREMENT,
    `user_id`              INT           NOT NULL,
    `technician_id`        INT           NOT NULL,
    `service_id`           INT           NOT NULL,
    `start_date`           DATE          NOT NULL,
    `end_date`             DATE          NOT NULL,
    `booking_day_of_month` TINYINT       NOT NULL COMMENT 'Day 1-28 that repeats each month',
    `recurring_fee`        DECIMAL(10,2) NOT NULL COMMENT 'Snapshot of fee at time of contract',
    `status`               ENUM('PENDING','ACTIVE','CANCELLED','COMPLETED') NOT NULL DEFAULT 'PENDING',
    `created_at`           TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`contract_id`),
    KEY `idx_rc_user`       (`user_id`),
    KEY `idx_rc_technician` (`technician_id`),
    KEY `idx_rc_service`    (`service_id`),
    KEY `idx_rc_status`     (`status`),
    CONSTRAINT `fk_rc_user`       FOREIGN KEY (`user_id`)       REFERENCES `users` (`user_id`),
    CONSTRAINT `fk_rc_technician` FOREIGN KEY (`technician_id`) REFERENCES `users` (`user_id`),
    CONSTRAINT `fk_rc_service`    FOREIGN KEY (`service_id`)    REFERENCES `services` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Add recurring reference columns to bookings table
ALTER TABLE `bookings`
    ADD COLUMN `recurring_contract_id` INT     DEFAULT NULL,
    ADD COLUMN `recurring_sequence`    TINYINT DEFAULT NULL COMMENT '1-12, which month in the contract',
    ADD KEY `idx_recurring_contract` (`recurring_contract_id`),
    ADD CONSTRAINT `fk_booking_contract`
        FOREIGN KEY (`recurring_contract_id`) REFERENCES `recurring_contracts` (`contract_id`);
