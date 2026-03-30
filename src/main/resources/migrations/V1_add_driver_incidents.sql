-- =============================================================
-- Migration: Add driver_incidents table
-- Purpose:   Track driver accountability when delivery timeouts
--            occur (Rule 3: accept-no-pickup, Rule 4: pickup-no-delivery)
-- Run:       Execute this manually against your MySQL 8 database
-- =============================================================

CREATE TABLE IF NOT EXISTS driver_incidents (
    incident_id     INT AUTO_INCREMENT PRIMARY KEY,
    driver_id       INT NOT NULL,
    assignment_id   INT NOT NULL,
    order_id        VARCHAR(50) NOT NULL,
    incident_type   ENUM('PICKUP_NO_DELIVERY', 'ACCEPT_NO_PICKUP') NOT NULL,
    description     VARCHAR(500),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (driver_id)      REFERENCES users(user_id),
    FOREIGN KEY (assignment_id)  REFERENCES delivery_assignments(assignment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Index for fast lookups by driver (admin summary page)
CREATE INDEX idx_driver_incidents_driver ON driver_incidents(driver_id);

-- Index for fast lookups by incident type
CREATE INDEX idx_driver_incidents_type   ON driver_incidents(incident_type);
