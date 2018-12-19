CREATE TABLE IF NOT EXISTS city_state_f
  (
    city_state_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    city_state_name VARCHAR (100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (city_state_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;