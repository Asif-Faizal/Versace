CREATE TABLE IF NOT EXISTS master_variants (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL, -- e.g. "Color", "Size"
  type VARCHAR(50),           -- optional: string, hex, number
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
