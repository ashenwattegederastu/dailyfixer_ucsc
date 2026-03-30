-- =====================================================
-- Guide Flagging System - Database Migration
-- DailyFixer Project
-- =====================================================

-- 1. Add status column to guides table
ALTER TABLE guides
    ADD COLUMN status ENUM('ACTIVE', 'HIDDEN', 'PENDING_REVIEW') NOT NULL DEFAULT 'ACTIVE' AFTER view_count,
    ADD COLUMN hide_reason VARCHAR(500) DEFAULT NULL AFTER status,
    ADD COLUMN hidden_at TIMESTAMP NULL DEFAULT NULL AFTER hide_reason,
    ADD COLUMN hidden_by INT DEFAULT NULL AFTER hidden_at,
    ADD INDEX idx_guides_status (status);

-- 2. Guide flags table - tracks individual user flags
CREATE TABLE guide_flags (
    flag_id INT AUTO_INCREMENT PRIMARY KEY,
    guide_id INT NOT NULL,
    user_id INT NOT NULL,
    reason ENUM('INACCURATE', 'OUTDATED', 'INAPPROPRIATE', 'SPAM', 'OTHER') NOT NULL,
    description VARCHAR(500) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_flag (guide_id, user_id),
    FOREIGN KEY (guide_id) REFERENCES guides(guide_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3. Guide moderation log - tracks admin actions
CREATE TABLE guide_moderation_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    guide_id INT NOT NULL,
    admin_id INT NOT NULL,
    action ENUM('HIDDEN', 'DISMISSED', 'UNHIDDEN') NOT NULL,
    reason VARCHAR(500) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guide_id) REFERENCES guides(guide_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Indexes for performance
CREATE INDEX idx_guide_flags_guide ON guide_flags(guide_id);
CREATE INDEX idx_guide_flags_user ON guide_flags(user_id);
CREATE INDEX idx_guide_mod_log_guide ON guide_moderation_log(guide_id);
