-- Step 1: create address table
CREATE TABLE IF NOT EXISTS address
  (
    address_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    street VARCHAR(500) NOT NULL,
    zip VARCHAR(5) NOT NULL, 
    city_state_id INTEGER NOT NULL,
    PRIMARY KEY (address_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Step 2: Populate address table
INSERT IGNORE INTO address (street, zip, city_state_id)
SELECT fm.street, fm.zip, fm.city_state_id
  FROM f_medicare fm
       LEFT JOIN address_temp at
              ON fm.address_id = at.address_id
 WHERE IFNULL(fm.address_id, 0) = IFNULL(at.address_id, 0)
 
 -- step 3: check address table
SELECT * FROM medicare.address;