-- ============================================================
-- Payout System Migration
-- Compatible with schema.sql (dailyfixer_main)
-- Run AFTER schema.sql has been applied.
-- ============================================================

-- 1. Bank details for stores and drivers
CREATE TABLE IF NOT EXISTS `bank_details` (
  `bank_detail_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `branch` varchar(100) DEFAULT NULL,
  `account_number` varchar(30) NOT NULL,
  `account_holder_name` varchar(150) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`bank_detail_id`),
  UNIQUE KEY `uq_bank_user` (`user_id`),
  CONSTRAINT `fk_bank_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. Payout requests / records
CREATE TABLE IF NOT EXISTS `payouts` (
  `payout_id` int NOT NULL AUTO_INCREMENT,
  `payee_type` enum('STORE','DRIVER') NOT NULL,
  `payee_id` int NOT NULL COMMENT 'store_id for STORE, user_id for DRIVER',
  `amount` decimal(12,2) NOT NULL,
  `status` enum('PENDING','PROCESSING','COMPLETED') NOT NULL DEFAULT 'PENDING',
  `locked_by_admin_id` int DEFAULT NULL,
  `receipt_image_path` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payout_id`),
  KEY `idx_payouts_status` (`status`),
  KEY `idx_payouts_payee` (`payee_type`, `payee_id`),
  KEY `idx_payouts_admin` (`locked_by_admin_id`),
  CONSTRAINT `fk_payout_admin` FOREIGN KEY (`locked_by_admin_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3. Line items linking each payout to its source records (audit trail + dedup)
CREATE TABLE IF NOT EXISTS `payout_line_items` (
  `line_item_id` int NOT NULL AUTO_INCREMENT,
  `payout_id` int NOT NULL,
  `source_type` enum('STORE_ORDER','DELIVERY') NOT NULL,
  `source_id` int NOT NULL COMMENT 'store_order_id or assignment_id',
  `amount` decimal(12,2) NOT NULL,
  PRIMARY KEY (`line_item_id`),
  KEY `idx_pli_payout` (`payout_id`),
  KEY `idx_pli_source` (`source_type`, `source_id`),
  CONSTRAINT `fk_pli_payout` FOREIGN KEY (`payout_id`) REFERENCES `payouts` (`payout_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
