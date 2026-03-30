-- =====================================================
-- Volunteer Reputation System - Database Schema
-- DailyFixer Project
-- =====================================================

-- 1. Add reputation_score to volunteers table
--    Stores the calculated reputation score for quick access
ALTER TABLE volunteers ADD COLUMN reputation_score DECIMAL(10, 2) DEFAULT 0.00;

-- 2. Create Badges table
--    Stores the definitions of available badges
CREATE TABLE IF NOT EXISTS badges (
    badge_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- e.g., 'Helper', 'Expert'
    description VARCHAR(255),
    icon VARCHAR(50), -- text emoji or class name
    required_score INT DEFAULT 0, -- Min reputation needed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Create Volunteer Badges table
--    Links volunteers to earned badges
CREATE TABLE IF NOT EXISTS volunteer_badges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    volunteer_id INT NOT NULL,
    badge_id INT NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (volunteer_id) REFERENCES volunteers(volunteer_id) ON DELETE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES badges(badge_id) ON DELETE CASCADE,
    UNIQUE KEY unique_badge_per_volunteer (volunteer_id, badge_id)
);

-- 4. Insert default badges
INSERT INTO badges (name, description, icon, required_score) VALUES 
('Helper', 'Completed first 5 guides', '🌱', 10),
('Trusted Helper', 'High approval rating and consistent contribution', '🛡️', 50),
('Expert Volunteer', 'Top tier contributor with excellent quality', '⭐', 100),
('Diagnostic Contributor', 'Authorized to contribute to diagnostic trees', '🔧', 150) 
ON DUPLICATE KEY UPDATE name=name;

-- 5. Permission/Access Level Table (Future Proofing for Diagnostic Tool)
--    To control who can edit/view the future decision tree
CREATE TABLE IF NOT EXISTS access_permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    volunteer_id INT NOT NULL,
    resource_type ENUM('DIAGNOSTIC_TREE', 'OTHER') DEFAULT 'DIAGNOSTIC_TREE',
    access_level ENUM('VIEW', 'SUGGEST', 'EDIT', 'APPROVE') DEFAULT 'VIEW',
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (volunteer_id) REFERENCES volunteers(volunteer_id) ON DELETE CASCADE
);
