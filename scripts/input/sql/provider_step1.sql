CREATE TABLE IF NOT EXISTS provider
  (
    provider_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    old_provider_id VARCHAR(100) NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    referral_region_id INTEGER NOT NULL, 
    address_id INTEGER NOT NULL,
    PRIMARY KEY (provider_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;