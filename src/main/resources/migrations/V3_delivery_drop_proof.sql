-- Add doorstep-drop consent to orders
ALTER TABLE orders
    ADD COLUMN doorstep_drop_consent TINYINT(1) NOT NULL DEFAULT 0 AFTER delivery_longitude;

-- Track delivery completion path on assignments
ALTER TABLE delivery_assignments
    ADD COLUMN completion_method VARCHAR(24) DEFAULT NULL AFTER status;

-- Doorstep proof bundle for unreachable-buyer completions
CREATE TABLE delivery_drop_proofs (
    proof_id INT NOT NULL AUTO_INCREMENT,
    assignment_id INT NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    driver_id INT NOT NULL,
    photo_package_path VARCHAR(255) NOT NULL,
    photo_door_context_path VARCHAR(255) NOT NULL,
    note VARCHAR(500) DEFAULT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (proof_id),
    UNIQUE KEY uq_ddp_assignment (assignment_id),
    KEY idx_ddp_order (order_id),
    KEY idx_ddp_driver (driver_id),
    CONSTRAINT fk_ddp_assignment FOREIGN KEY (assignment_id) REFERENCES delivery_assignments (assignment_id) ON DELETE CASCADE,
    CONSTRAINT fk_ddp_order FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_ddp_driver FOREIGN KEY (driver_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
