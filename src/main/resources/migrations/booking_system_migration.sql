-- Migration for DailyFixer Booking System
-- Created: 2026-02-17
-- Description: Adds tables for technician availability, bookings, chat, and related features

-- Service Categories Table
CREATE TABLE IF NOT EXISTS `service_categories` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Technician Availability Table
CREATE TABLE IF NOT EXISTS `technician_availability` (
  `availability_id` INT NOT NULL AUTO_INCREMENT,
  `technician_id` INT NOT NULL,
  `availability_mode` ENUM('WEEKDAYS', 'WEEKENDS', 'CUSTOM') NOT NULL DEFAULT 'WEEKDAYS',
  `monday` TINYINT(1) DEFAULT 0,
  `tuesday` TINYINT(1) DEFAULT 0,
  `wednesday` TINYINT(1) DEFAULT 0,
  `thursday` TINYINT(1) DEFAULT 0,
  `friday` TINYINT(1) DEFAULT 0,
  `saturday` TINYINT(1) DEFAULT 0,
  `sunday` TINYINT(1) DEFAULT 0,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`availability_id`),
  KEY `idx_technician` (`technician_id`),
  CONSTRAINT `fk_availability_technician` FOREIGN KEY (`technician_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bookings Table
CREATE TABLE IF NOT EXISTS `bookings` (
  `booking_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `technician_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  `booking_date` DATE NOT NULL,
  `booking_time` TIME NOT NULL,
  `phone_number` VARCHAR(20) NOT NULL,
  `problem_description` TEXT NOT NULL,
  `location_address` VARCHAR(255) NOT NULL,
  `location_latitude` DECIMAL(10, 8) DEFAULT NULL,
  `location_longitude` DECIMAL(11, 8) DEFAULT NULL,
  `status` ENUM('REQUESTED', 'ACCEPTED', 'REJECTED', 'CANCELLED', 'TECHNICIAN_COMPLETED', 'FULLY_COMPLETED') NOT NULL DEFAULT 'REQUESTED',
  `rejection_reason` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_technician` (`technician_id`),
  KEY `idx_service` (`service_id`),
  KEY `idx_status` (`status`),
  KEY `idx_booking_date` (`booking_date`),
  CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_booking_technician` FOREIGN KEY (`technician_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_booking_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Booking Cancellations Table
CREATE TABLE IF NOT EXISTS `booking_cancellations` (
  `cancellation_id` INT NOT NULL AUTO_INCREMENT,
  `booking_id` INT NOT NULL,
  `cancelled_by` INT NOT NULL,
  `cancellation_reason` TEXT NOT NULL,
  `cancelled_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cancellation_id`),
  KEY `idx_booking` (`booking_id`),
  KEY `idx_cancelled_by` (`cancelled_by`),
  CONSTRAINT `fk_cancellation_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cancellation_user` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Chats Table
CREATE TABLE IF NOT EXISTS `chats` (
  `chat_id` INT NOT NULL AUTO_INCREMENT,
  `booking_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `technician_id` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`chat_id`),
  UNIQUE KEY `unique_booking_chat` (`booking_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_technician` (`technician_id`),
  CONSTRAINT `fk_chat_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_chat_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_chat_technician` FOREIGN KEY (`technician_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Chat Messages Table
CREATE TABLE IF NOT EXISTS `chat_messages` (
  `message_id` INT NOT NULL AUTO_INCREMENT,
  `chat_id` INT NOT NULL,
  `sender_id` INT NOT NULL,
  `message` TEXT NOT NULL,
  `is_read` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `idx_chat` (`chat_id`),
  KEY `idx_sender` (`sender_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_message_chat` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`chat_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_message_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert default service categories
INSERT INTO `service_categories` (`name`, `description`) VALUES
('Plumbing', 'Plumbing repair and installation services'),
('Electrical', 'Electrical repair and installation services'),
('Carpentry', 'Carpentry and woodwork services'),
('Painting', 'Painting and decoration services'),
('HVAC', 'Heating, ventilation, and air conditioning services'),
('Appliance Repair', 'Home appliance repair services'),
('Cleaning', 'Professional cleaning services'),
('Landscaping', 'Garden and landscaping services'),
('Other', 'Other miscellaneous services')
ON DUPLICATE KEY UPDATE name = name;
