-- Add delivery_pin column to delivery_assignments
-- A 6-digit PIN shown to buyer, entered by driver to confirm delivery
ALTER TABLE delivery_assignments
    ADD COLUMN delivery_pin CHAR(6) DEFAULT NULL AFTER delivery_lng;
