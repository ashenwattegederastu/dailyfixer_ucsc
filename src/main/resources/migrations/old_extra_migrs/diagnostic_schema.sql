-- =====================================================
-- Decision Tree System Database Schema
-- Daily Fixer - Diagnostic Tool
-- =====================================================

-- -----------------------------------------------------
-- Table: diagnostic_categories
-- Stores main categories and sub-categories
-- If parent_id is NULL, it's a main category
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS diagnostic_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES diagnostic_categories(category_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: diagnostic_trees
-- Stores decision tree metadata
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS diagnostic_trees (
    tree_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    creator_id INT NOT NULL,
    status ENUM('draft', 'published') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES diagnostic_categories(category_id) ON DELETE RESTRICT,
    FOREIGN KEY (creator_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: diagnostic_nodes
-- Stores tree nodes (questions and results)
-- If parent_id is NULL, it's the root node
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS diagnostic_nodes (
    node_id INT AUTO_INCREMENT PRIMARY KEY,
    tree_id INT NOT NULL,
    parent_id INT NULL,
    node_text TEXT NOT NULL,
    option_label VARCHAR(255),
    node_type ENUM('QUESTION', 'RESULT') NOT NULL DEFAULT 'QUESTION',
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tree_id) REFERENCES diagnostic_trees(tree_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES diagnostic_nodes(node_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: diagnostic_ratings
-- Stores user ratings for trees (1-5 stars)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS diagnostic_ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    tree_id INT NOT NULL,
    user_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tree_id) REFERENCES diagnostic_trees(tree_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_tree_rating (tree_id, user_id)
);

-- -----------------------------------------------------
-- Insert Default Categories
-- -----------------------------------------------------

-- Main Category: Home Repair
INSERT INTO diagnostic_categories (name, parent_id) VALUES ('Home Repair', NULL);
SET @home_repair_id = LAST_INSERT_ID();

INSERT INTO diagnostic_categories (name, parent_id) VALUES 
    ('Plumbing', @home_repair_id),
    ('Electrical (Basic)', @home_repair_id),
    ('Carpentry', @home_repair_id),
    ('Painting & Finishing', @home_repair_id),
    ('Masonry', @home_repair_id),
    ('Roofing', @home_repair_id),
    ('Flooring', @home_repair_id),
    ('Doors & Windows', @home_repair_id);

-- Main Category: Home Electronic Repair
INSERT INTO diagnostic_categories (name, parent_id) VALUES ('Home Electronic Repair', NULL);
SET @electronic_id = LAST_INSERT_ID();

INSERT INTO diagnostic_categories (name, parent_id) VALUES 
    ('Mobile Devices', @electronic_id),
    ('Computers & Laptops', @electronic_id),
    ('Networking Devices', @electronic_id),
    ('Home Appliances', @electronic_id),
    ('Kitchen Electronics', @electronic_id),
    ('Entertainment Systems', @electronic_id),
    ('Power & Batteries', @electronic_id);

-- Main Category: Vehicle Repair
INSERT INTO diagnostic_categories (name, parent_id) VALUES ('Vehicle Repair', NULL);
SET @vehicle_id = LAST_INSERT_ID();

INSERT INTO diagnostic_categories (name, parent_id) VALUES 
    ('Engine & Mechanical', @vehicle_id),
    ('Electrical Systems', @vehicle_id),
    ('Braking System', @vehicle_id),
    ('Suspension & Steering', @vehicle_id),
    ('Transmission', @vehicle_id),
    ('Cooling System', @vehicle_id),
    ('Tyres & Wheels', @vehicle_id),
    ('Body & Paint', @vehicle_id);

-- -----------------------------------------------------
-- Indexes for better query performance
-- -----------------------------------------------------
CREATE INDEX idx_trees_category ON diagnostic_trees(category_id);
CREATE INDEX idx_trees_creator ON diagnostic_trees(creator_id);
CREATE INDEX idx_trees_status ON diagnostic_trees(status);
CREATE INDEX idx_nodes_tree ON diagnostic_nodes(tree_id);
CREATE INDEX idx_nodes_parent ON diagnostic_nodes(parent_id);
CREATE INDEX idx_ratings_tree ON diagnostic_ratings(tree_id);
