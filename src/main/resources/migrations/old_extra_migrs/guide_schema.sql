-- =====================================================
-- Guide Write Tool - Database Schema
-- DailyFixer Project
-- Run this script in MySQL Workbench or CLI
-- =====================================================

-- Drop existing guide tables if any (be careful in production!)
DROP TABLE IF EXISTS guide_comments;
DROP TABLE IF EXISTS guide_ratings;
DROP TABLE IF EXISTS guide_step_images;
DROP TABLE IF EXISTS guide_steps;
DROP TABLE IF EXISTS guide_requirements;
DROP TABLE IF EXISTS guides;

-- Main guides table with categories & role tracking
CREATE TABLE guides (
    guide_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    main_image_path VARCHAR(255),
    main_category VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100) NOT NULL,
    youtube_url VARCHAR(255),
    created_by INT NOT NULL,
    created_role ENUM('admin', 'volunteer') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Requirements list for each guide
CREATE TABLE guide_requirements (
    req_id INT AUTO_INCREMENT PRIMARY KEY,
    guide_id INT NOT NULL,
    requirement VARCHAR(500) NOT NULL,
    FOREIGN KEY (guide_id) REFERENCES guides(guide_id) ON DELETE CASCADE
);

-- Steps for each guide with ordering
CREATE TABLE guide_steps (
    step_id INT AUTO_INCREMENT PRIMARY KEY,
    guide_id INT NOT NULL,
    step_order INT NOT NULL,
    step_title VARCHAR(255) NOT NULL,
    step_body TEXT,
    FOREIGN KEY (guide_id) REFERENCES guides(guide_id) ON DELETE CASCADE
);

-- Multiple images per step (stores file paths)
CREATE TABLE guide_step_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    step_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    FOREIGN KEY (step_id) REFERENCES guide_steps(step_id) ON DELETE CASCADE
);

-- Ratings (thumbs up/down, one per user per guide)
CREATE TABLE guide_ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    guide_id INT NOT NULL,
    user_id INT NOT NULL,
    rating ENUM('UP', 'DOWN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_rating (guide_id, user_id),
    FOREIGN KEY (guide_id) REFERENCES guides(guide_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Comments on guides
CREATE TABLE guide_comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    guide_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guide_id) REFERENCES guides(guide_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Index for performance
CREATE INDEX idx_guides_category ON guides(main_category, sub_category);
CREATE INDEX idx_guides_created_by ON guides(created_by);

ALTER TABLE guides ADD COLUMN view_count INT DEFAULT 0;

