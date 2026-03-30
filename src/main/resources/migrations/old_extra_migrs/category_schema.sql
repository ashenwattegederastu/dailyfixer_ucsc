-- =====================================================
-- Dynamic Categories Schema for Guide Write Tool
-- DailyFixer Project
-- Run this script after the main guide_schema.sql
-- =====================================================

-- Main categories table
CREATE TABLE IF NOT EXISTS guide_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sub-categories table (linked to main categories)
CREATE TABLE IF NOT EXISTS guide_sub_categories (
    sub_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES guide_categories(category_id) ON DELETE CASCADE,
    UNIQUE KEY unique_sub (category_id, name)
);

-- Index for performance
CREATE INDEX idx_sub_cat_parent ON guide_sub_categories(category_id);

-- =====================================================
-- Seed existing categories
-- =====================================================

-- Main categories
INSERT INTO guide_categories (name) VALUES 
    ('Home Repair'),
    ('Home Electronics / Appliance Repair'),
    ('Vehicle Repair');

-- Sub-categories for Home Repair (category_id = 1)
INSERT INTO guide_sub_categories (category_id, name) VALUES 
    (1, 'Plumbing'), 
    (1, 'Electrical'), 
    (1, 'Masonry'), 
    (1, 'Painting & Finishing'), 
    (1, 'Carpentry'), 
    (1, 'Roofing'),
    (1, 'Flooring & Tiling'), 
    (1, 'Doors & Windows'), 
    (1, 'Ceiling & False Ceiling'), 
    (1, 'Waterproofing'),
    (1, 'Glass & Mirrors'), 
    (1, 'Locks & Hardware');

-- Sub-categories for Home Electronics / Appliance Repair (category_id = 2)
INSERT INTO guide_sub_categories (category_id, name) VALUES 
    (2, 'Refrigerator'), 
    (2, 'Washing Machine'), 
    (2, 'Microwave Oven'),
    (2, 'Electric Kettle'), 
    (2, 'Rice Cooker'), 
    (2, 'Mixer / Blender'),
    (2, 'Air Conditioner'), 
    (2, 'Water Heater'), 
    (2, 'Fans'),
    (2, 'Television'), 
    (2, 'Home Theatre / Speakers'), 
    (2, 'Inverter / UPS'), 
    (2, 'Voltage Stabilizer');

-- Sub-categories for Vehicle Repair (category_id = 3)
INSERT INTO guide_sub_categories (category_id, name) VALUES 
    (3, 'Engine System'), 
    (3, 'Fuel System'), 
    (3, 'Electrical System'),
    (3, 'Battery & Charging'), 
    (3, 'Transmission'), 
    (3, 'Clutch System'),
    (3, 'Brake System'), 
    (3, 'Steering System'), 
    (3, 'Suspension System'),
    (3, 'Tyres & Wheels'), 
    (3, 'Cooling System'), 
    (3, 'Exhaust System'),
    (3, 'Body & Interior');
