CREATE TABLE IF NOT EXISTS variant_values (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  master_variant_id BIGINT NOT NULL,
  value VARCHAR(255) NOT NULL,
  hex_code VARCHAR(7), -- optional for color
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (master_variant_id) REFERENCES master_variants(id) ON DELETE CASCADE
);
