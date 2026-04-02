-- V5: Replace BLOB product images with file paths, add warranty, add variant images
-- Run this migration ONCE on the live database.
-- NOTE: Any existing BLOB product images will be removed. 
--       Migrate existing blobs to files before running if needed.

-- 1. Products: drop blob, add image_path, add warranty_info
ALTER TABLE `products`
    DROP COLUMN `image`,
    ADD COLUMN `image_path` VARCHAR(255) DEFAULT NULL AFTER `description`,
    ADD COLUMN `warranty_info` VARCHAR(500) DEFAULT NULL AFTER `image_path`;

-- 2. Product variants: add per-variant image path
ALTER TABLE `product_variants`
    ADD COLUMN `image_path` VARCHAR(255) DEFAULT NULL;
