-- V7: Add max_simultaneous_orders column to delivery_rates
-- Controls how many ACCEPTED + PICKED_UP orders a driver of each vehicle type can hold at once.

ALTER TABLE delivery_rates
  ADD COLUMN max_simultaneous_orders INT NOT NULL DEFAULT 3
  COMMENT 'Max concurrent ACCEPTED+PICKED_UP orders a driver of this vehicle type can hold';

-- Seed defaults for existing vehicle types
UPDATE delivery_rates SET max_simultaneous_orders = 3  WHERE vehicle_type = 'Bike';
UPDATE delivery_rates SET max_simultaneous_orders = 6  WHERE vehicle_type = 'Three-wheel';
UPDATE delivery_rates SET max_simultaneous_orders = 10 WHERE vehicle_type = 'Lorry';
