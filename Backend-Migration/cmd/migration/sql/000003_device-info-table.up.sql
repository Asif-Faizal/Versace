-- Create device_info table
CREATE TABLE IF NOT EXISTS device_info (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    token_id INT UNSIGNED NOT NULL REFERENCES tokens(id) ON DELETE CASCADE,
    device_id TEXT,
    device_name TEXT,
    device_type TEXT,
    device_os TEXT,
    device_model TEXT,
    device_ip TEXT
); 