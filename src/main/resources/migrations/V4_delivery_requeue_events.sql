-- Migration: Add audit log for no-penalty driver re-queue actions
-- Purpose: driver can cancel accepted order before pickup and return it to pool

CREATE TABLE IF NOT EXISTS delivery_requeue_events (
    requeue_event_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    actor_driver_id INT NOT NULL,
    reason_code ENUM('NOT_ENOUGH_SPACE', 'EMERGENCY', 'VEHICLE_ISSUE', 'OTHER') NOT NULL,
    reason_note VARCHAR(400) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_dre_assignment FOREIGN KEY (assignment_id)
        REFERENCES delivery_assignments (assignment_id) ON DELETE CASCADE,
    CONSTRAINT fk_dre_driver FOREIGN KEY (actor_driver_id)
        REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE INDEX idx_dre_assignment ON delivery_requeue_events (assignment_id);
CREATE INDEX idx_dre_driver ON delivery_requeue_events (actor_driver_id);
CREATE INDEX idx_dre_created_at ON delivery_requeue_events (created_at);
