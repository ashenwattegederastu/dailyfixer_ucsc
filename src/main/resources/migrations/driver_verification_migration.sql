-- Driver Verification System Migration
-- Adds driver_requests table for admin-verified driver registration
-- and identification columns to users table for post-approval access

-- 1. Create driver_requests table (mirrors volunteer_requests pattern)
CREATE TABLE IF NOT EXISTS `driver_requests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `city` varchar(50) DEFAULT NULL,
  `nic_number` varchar(20) NOT NULL,
  `nic_front_path` varchar(255) NOT NULL,
  `nic_back_path` varchar(255) NOT NULL,
  `profile_picture_path` varchar(255) NOT NULL,
  `license_front_path` varchar(255) NOT NULL,
  `license_back_path` varchar(255) DEFAULT NULL,
  `policy_accepted` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
  `rejection_reason` text,
  `submitted_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_date` timestamp NULL DEFAULT NULL,
  `reviewed_by` int DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  UNIQUE KEY `uq_dr_username` (`username`),
  UNIQUE KEY `uq_dr_email` (`email`),
  KEY `idx_dr_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. Add identification columns to users table (populated on driver approval)
ALTER TABLE `users`
  ADD COLUMN `nic_number` varchar(20) DEFAULT NULL AFTER `longitude`,
  ADD COLUMN `nic_front_path` varchar(255) DEFAULT NULL AFTER `nic_number`,
  ADD COLUMN `nic_back_path` varchar(255) DEFAULT NULL AFTER `nic_front_path`,
  ADD COLUMN `license_front_path` varchar(255) DEFAULT NULL AFTER `nic_back_path`,
  ADD COLUMN `license_back_path` varchar(255) DEFAULT NULL AFTER `license_front_path`;
