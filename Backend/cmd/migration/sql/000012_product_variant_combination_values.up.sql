CREATE TABLE IF NOT EXISTS product_variant_combination_values (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  product_variant_combination_id BIGINT NOT NULL,
  variant_value_id BIGINT NOT NULL,
  FOREIGN KEY (product_variant_combination_id) REFERENCES product_variant_combinations(id) ON DELETE CASCADE,
  FOREIGN KEY (variant_value_id) REFERENCES variant_values(id) ON DELETE CASCADE
);
