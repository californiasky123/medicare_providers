  CREATE TABLE IF NOT EXISTS city_dummy
    (
      city_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
      city_name VARCHAR (100) NOT NULL,
      state_id INTEGER NOT NULL,
      PRIMARY KEY (city_id)
    )
  ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS address_temp_dummy_2
  (
    address_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    CN_city_name varchar(500) NOT NULL,
    TM_city_name varchar(500) NOT NULL,
    state_name varchar(40) NOT NULL,
    street VARCHAR(500) NOT NULL,
    zip_code VARCHAR(5) NOT NULL, 
    city_id INTEGER NOT NULL,
    PRIMARY KEY (address_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS address_temp_dummy_3
  (
    address_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    CN_city_name varchar(500) NOT NULL,
    TM_city_name varchar(500) NOT NULL,
    state_name varchar(40) NOT NULL,
    street VARCHAR(500) NOT NULL,
    zip_code VARCHAR(5) NOT NULL, 
    city_id INTEGER NOT NULL,
    PRIMARY KEY (address_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS address_temp_A
  (
    address_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    state_name varchar(40) NOT NULL,
    street VARCHAR(500) NOT NULL,
    zip_code VARCHAR(5) NOT NULL, 
    city_id INTEGER NOT NULL,
    PRIMARY KEY (address_id),
    FOREIGN KEY (city_id) REFERENCES city(city_id) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;


-- state
INSERT IGNORE INTO state(state_name) SELECT DISTINCT state_name FROM temp_medicare;


-- city 
INSERT IGNORE INTO city_dummy(city_name, state_id)
SELECT DISTINCT tm.city_name, sn.state_id
FROM temp_medicare tm
LEFT JOIN state sn
ON tm.state_name = sn.state_name;


-- address - pull from city_dummy to see if FKs are screwing it up
INSERT IGNORE INTO address_temp(street, zip_code, city_id)
SELECT DISTINCT tm.street, tm.zip_code, cn.city_id
FROM temp_medicare tm 
LEFT JOIN city_dummy cn
ON tm.city_name = cn.city_name 
LEFT JOIN state sn
on tm.state_name = sn.state_name;


-- address - regular fields
INSERT IGNORE INTO address_temp(street, zip_code, city_id)
SELECT DISTINCT tm.street, tm.zip_code, cn.city_id
FROM temp_medicare tm 
LEFT JOIN city cn
ON tm.city_name = cn.city_name 
LEFT JOIN state sn
on tm.state_name = sn.state_name

-- address - regular fields
INSERT IGNORE address_temp_A (street, zip_code, city_id)
SELECT DISTINCT tm.street, tm.zip_code, cn.city_id
FROM temp_medicare tm
LEFT JOIN city cn
ON tm.city_name = cn.city_name 
LEFT JOIN state sn
on tm.state_name = sn.state_name




-- address - more fields 
INSERT IGNORE INTO address_temp_dummy_2(street, zip_code, city_id, CN_city_name, TM_city_name, state_name)
SELECT DISTINCT tm.street, tm.zip_code, cn.city_id, cn.city_name, tm.city_name, tm.state_name
FROM temp_medicare tm 
LEFT JOIN city cn
ON tm.city_name = cn.city_name 
LEFT JOIN state sn
on tm.state_name = sn.state_name;

-- address - try inner join?  --> took too long 




