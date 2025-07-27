CREATE TABLE IF NOT EXISTS product_variant_combinations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT NOT NULL,
  sku VARCHAR(100),
  price DECIMAL(10,2),
  stock INT DEFAULT 0,
  image_url TEXT,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
