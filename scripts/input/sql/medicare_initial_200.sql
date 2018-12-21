
--
-- Comment drop database out later
-- 

DROP DATABASE IF EXISTS medicare; 
--
-- Create database
--

CREATE DATABASE IF NOT EXISTS medicare;
USE medicare; 
--
--
-- Drop tables
-- turn off FK checks temporarily to eliminate drop order issues
--


SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS drg, provider_drg, provider_temp, referral_region, address_temp, provider, address, city_state_temp, city_state, t_medicare, temp_medicare, final_medicare, city, state;
SET FOREIGN_KEY_CHECKS=1;


-- -------------------
-- -------------------
-- 1. CREATE TABLES --
-- -------------------
-- -------------------


--
-- CITY
--

CREATE TABLE IF NOT EXISTS city
    (
      city_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
      city_name VARCHAR (100) NOT NULL,
      PRIMARY KEY (city_id)
    )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;




--
-- REFERRAL REGION
--

CREATE TABLE IF NOT EXISTS referral_region
  (
    referral_region_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    referral_region_desc VARCHAR(100) NOT NULL,
    PRIMARY KEY (referral_region_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;


-- STATE
--

CREATE TABLE IF NOT EXISTS state
  (
    state_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    state_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (state_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

--
-- DRG 
-- 

CREATE TABLE IF NOT EXISTS drg
  (
    drg_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    drg_desc VARCHAR(500) NOT NULL,
    PRIMARY KEY (drg_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;


CREATE TABLE IF NOT EXISTS provider
  (
    provider_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    old_provider_id VARCHAR(100) NOT NULL UNIQUE,
    provider_name VARCHAR(100) NOT NULL UNIQUE,
    referral_region_id INTEGER NOT NULL UNIQUE, 
    street VARCHAR(255),
    state_id INTEGER NOT NULL,
    city_id INTEGER NOT NULL,
    zip_code VARCHAR(10),
    PRIMARY KEY (provider_id),
    FOREIGN KEY (referral_region_id) REFERENCES referral_region(referral_region_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (state_id) REFERENCES state(state_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (city_id) REFERENCES city(city_id) ON DELETE RESTRICT ON UPDATE CASCADE
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;


-- GOAL  

-- CREATE TABLE IF NOT EXISTS provider
--   (
--     provider_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
--     old_provider_id VARCHAR(100) NOT NULL UNIQUE,
--     provider_name VARCHAR(100) NOT NULL UNIQUE,
--     referral_region_id INTEGER NOT NULL UNIQUE, 
--     street VARCHAR(255),
--     city_id INTEGER NOT NULL,
--     state_id INTEGER NOT NULL,
--     zip_code VARCHAR(10),
--     PRIMARY KEY (provider_id),
--     FOREIGN KEY (referral_region_id) REFERENCES referral_region(referral_region_id) ON DELETE RESTRICT ON UPDATE CASCADE,
--     FOREIGN KEY (city_id) REFERENCES city(city_id) ON DELETE RESTRICT ON UPDATE CASCADE,
--     FOREIGN KEY (state_id) REFERENCES state(state_id) ON DELETE RESTRICT ON UPDATE CASCADE,
--   )
-- ENGINE=InnoDB
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_0900_ai_ci;



--
-- PROVIDER/DRG 
-- 


CREATE TABLE IF NOT EXISTS provider_drg
  (
    provider_drg_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    provider_id INTEGER NOT NULL,
    drg_id INTEGER NOT NULL,
    avg_med_payment NUMERIC ( 19,4 ),
    avg_cov_charges NUMERIC ( 19,4 ),
    avg_total_payment NUMERIC ( 19,4 ),
    total_discharges NUMERIC ( 19,4 ),
    PRIMARY KEY (provider_drg_id),
    FOREIGN KEY (provider_id) REFERENCES provider(provider_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (drg_id) REFERENCES drg(drg_id) ON DELETE CASCADE ON UPDATE CASCADE
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;


--
-- TEMP MEDICARE
-- 


CREATE TABLE IF NOT EXISTS temp_medicare

  (
    temp_medicare_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    drg_desc VARCHAR(500) NOT NULL,
    old_provider_id VARCHAR(100) NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    street VARCHAR(500) NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    zip_code VARCHAR(5) NOT NULL,
    referral_region_desc VARCHAR(100) NOT NULL,
    avg_med_payment NUMERIC ( 19,4 ),
    avg_cov_charges NUMERIC ( 19,4 ),
    avg_total_payment NUMERIC ( 19,4 ),
    total_discharges NUMERIC ( 19,4 ),
    city_state_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (temp_medicare_id)
  );


-- -------------------
-- -------------------
-- 2. LOAD DATA FROM EXTERNAL
-- -------------------
-- -------------------


-- Load data from external file.
-- Check for blank entries and set to NULL.
LOAD DATA LOCAL INFILE 'medicare_data_output.csv' -- don't need long filepath
INTO TABLE temp_medicare
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY '\,'
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  -- LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (drg_desc, old_provider_id, provider_name, street, city_name, state_name, zip_code, referral_region_desc, total_discharges, avg_cov_charges, avg_total_payment, avg_med_payment, city_state_name)

  SET drg_desc = IF(drg_desc = '', NULL, drg_desc),
  old_provider_id = IF(old_provider_id = '', NULL, old_provider_id),
  provider_name = IF(provider_name = '', NULL, provider_name),
  street = IF(street = '', NULL, street),
  city_name = IF(city_name = '', NULL, city_name),
  state_name = IF(state_name = '', NULL, state_name),
  zip_code = IF(zip_code = '', NULL, zip_code),
  referral_region_desc = IF(referral_region_desc = '', NULL, referral_region_desc),
  total_discharges = IF(total_discharges = '', NULL, total_discharges),
  avg_cov_charges = IF(avg_cov_charges = '', NULL, avg_cov_charges),
  avg_total_payment = IF(avg_total_payment = '', NULL, avg_total_payment),
  avg_med_payment = IF(avg_med_payment = '', NULL, avg_med_payment),
  city_state_name = IF(city_state_name = '', NULL, city_state_name);

-- -- -------------------
-- -- -------------------
-- -- 3. INSERT UNIQUE VALUES
-- -- -------------------
-- -- -------------------


-- This should populate my tables with my unique values I pulled from the temp_medicare table. 



-- Populate referral_region table


INSERT IGNORE INTO referral_region(referral_region_desc) SELECT DISTINCT referral_region_desc FROM temp_medicare;


-- Populate state table

INSERT IGNORE INTO state(state_name) SELECT DISTINCT state_name FROM temp_medicare;


-- Populate city table 

INSERT IGNORE INTO city(city_name) SELECT DISTINCT city_name FROM temp_medicare;


-- Populate drg description table

INSERT IGNORE INTO drg(drg_desc) SELECT DISTINCT drg_desc FROM temp_medicare;

-- Populate provider  

INSERT IGNORE INTO provider(old_provider_id, provider_name, referral_region_id, street, city_id, state_id, zip_code) 
SELECT DISTINCT tm.old_provider_id, tm.provider_name, rr.referral_region_id, tm.street, cn.city_id, sn.state_id, tm.zip_code
FROM temp_medicare tm
LEFT JOIN referral_region rr
ON tm.referral_region_desc = rr.referral_region_desc
LEFT JOIN city cn
ON tm.city_name = cn.city_name
LEFT JOIN state sn
ON tm.state_name = sn.state_name;


-- 
-- Populate provider_drg table 
-- 


  -- INSERT IGNORE INTO provider_drg (old_provider_id, drg_desc, avg_med_payment, avg_cov_charges, avg_total_payment, total_discharges)

INSERT IGNORE INTO provider_drg(avg_med_payment, avg_cov_charges, avg_total_payment, total_discharges, drg_id, provider_id)
SELECT tm.avg_med_payment, tm.avg_cov_charges, tm.avg_total_payment, tm.total_discharges, dr.drg_id, pt.provider_id
FROM temp_medicare tm    
LEFT JOIN provider pt       
ON tm.old_provider_id = pt.old_provider_id    
LEFT JOIN drg dr        
ON tm.drg_desc = dr.drg_desc   
WHERE IFNULL(tm.old_provider_id, 0) = IFNULL(pt.old_provider_id, 0)   
AND IFNULL(tm.drg_desc, 0) = IFNULL(dr.drg_desc, 0);


-- -- -------------------
-- -- -------------------
-- -- 4. MAKE FK DB CHANGES RECOMMENDED BY ANTHONY
-- -- -------------------
-- -- -------------------



ALTER TABLE `medicare`.`provider` 
DROP FOREIGN KEY `provider_ibfk_1`;

ALTER TABLE `medicare`.`provider` 
DROP INDEX `referral_region_id` ;

ALTER TABLE `medicare`.`provider` 
ADD CONSTRAINT `referral_region_id_fk`
  FOREIGN KEY (`referral_region_id`)
  REFERENCES `medicare`.`referral_region` (`referral_region_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;


ALTER TABLE `medicare`.`provider` 
ADD INDEX `provider_ibfk_1_idx` (`referral_region_id` ASC) VISIBLE;
;
ALTER TABLE `medicare`.`provider` 
ADD CONSTRAINT `provider_ibfk_1`
  FOREIGN KEY (`referral_region_id`)
  REFERENCES `medicare`.`referral_region` (`referral_region_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
