-- =====================================================
-- Volunteer Registration System Migration
-- Creates volunteer_requests + volunteer_proofs tables
-- Alters volunteers table to add new fields
-- =====================================================

-- Table: volunteer_requests
-- Stores pending volunteer applications for admin review
CREATE TABLE IF NOT EXISTS `volunteer_requests` (
    `request_id` INT NOT NULL AUTO_INCREMENT,
    `full_name` VARCHAR(100) NOT NULL,
    `username` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `profile_picture_path` VARCHAR(255) DEFAULT NULL,
    `expertise` VARCHAR(500) NOT NULL,
    `skill_level` ENUM('Beginner','Intermediate','Advanced','Professional') NOT NULL,
    `experience_years` ENUM('0-1','1-3','3-5','5+') NOT NULL,
    `bio` TEXT,
    `sample_guide` TEXT,
    `sample_guide_file_path` VARCHAR(255) DEFAULT NULL,
    `status` ENUM('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
    `rejection_reason` TEXT,
    `submitted_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `reviewed_date` TIMESTAMP NULL,
    `reviewed_by` INT DEFAULT NULL,
    PRIMARY KEY (`request_id`),
    UNIQUE KEY `uq_vr_username` (`username`),
    UNIQUE KEY `uq_vr_email` (`email`),
    KEY `idx_vr_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: volunteer_proofs
-- Stores qualification proof uploads (up to 5 per request)
CREATE TABLE IF NOT EXISTS `volunteer_proofs` (
    `proof_id` INT NOT NULL AUTO_INCREMENT,
    `request_id` INT NOT NULL,
    `proof_type` ENUM(
        'Educational Certificate',
        'Technical Certification',
        'Trade License',
        'Workshop Training Certificate',
        'Work Experience Letter',
        'Portfolio Screenshot',
        'Previous Published Guide',
        'Professional ID',
        'Other'
    ) NOT NULL,
    `image_path` VARCHAR(255) NOT NULL,
    `description` VARCHAR(500) DEFAULT NULL,
    `upload_order` INT DEFAULT 1,
    PRIMARY KEY (`proof_id`),
    KEY `idx_vp_request` (`request_id`),
    CONSTRAINT `fk_vp_request` FOREIGN KEY (`request_id`) REFERENCES `volunteer_requests` (`request_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Alter volunteers table to add new professional fields
ALTER TABLE `volunteers`
    ADD COLUMN `skill_level` VARCHAR(20) DEFAULT NULL AFTER `expertise`,
    ADD COLUMN `experience_years` VARCHAR(10) DEFAULT NULL AFTER `skill_level`,
    ADD COLUMN `bio` TEXT DEFAULT NULL AFTER `experience_years`,
    ADD COLUMN `profile_picture_path` VARCHAR(255) DEFAULT NULL AFTER `bio`;
