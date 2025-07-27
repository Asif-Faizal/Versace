CREATE TABLE IF NOT EXISTS product_variant_images (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT NOT NULL,
  master_variant_id BIGINT NOT NULL,
  variant_value_id BIGINT NOT NULL,
  image_url TEXT NOT NULL,
  sort_order INT DEFAULT 0,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  FOREIGN KEY (master_variant_id) REFERENCES master_variants(id),
  FOREIGN KEY (variant_value_id) REFERENCES variant_values(id)
);
