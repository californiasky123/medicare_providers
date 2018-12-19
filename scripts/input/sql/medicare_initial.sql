-- Source: https://whc.unesco.org/en/list/
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
DROP TABLE IF EXISTS drg, provider_drg, provider, referral_region, address, city, state;
SET FOREIGN_KEY_CHECKS=1;


-- CREATE TEMPORARY TABLE temp_medicare

CREATE TABLE IF NOT EXISTS temp_medicare
-- Change to root table, not temporary table. That way I can look at it and run queries on it. 
-- Later change back. 

  (
    id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    drg_desc VARCHAR(100),
    provider_name VARCHAR(100) NOT NULL,
    street VARCHAR(100) NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    zip CHAR(5) NOT NULL,
    referral_region_desc VARCHAR(100),
    avg_med_payment NUMERIC ( 19,4 ),
    avg_cov_charges NUMERIC ( 19,4 ),
    avg_total_payment NUMERIC ( 19,4 ),
    total_discharges NUMERIC ( 19,4 ),
    old_provider_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
  )

ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Load data from external file.
-- Check for blank entries and set to NULL.
LOAD DATA LOCAL INFILE 'medicare_data.csv' -- don't need long filepath
INTO TABLE temp_medicare
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY '\,'
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  -- LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (drg_desc, old_provider_id, provider_name, street, city_name, state_name, zip, referral_region_desc, total_discharges, avg_cov_charges, avg_total_payment, avg_med_payment)

  SET drg_desc = IF(drg_desc = '', NULL, drg_desc),
  old_provider_id = IF(old_provider_id = '', NULL, old_provider_id),
  provider_name = IF(provider_name = '', NULL, provider_name),
  street = IF(street = '', NULL, street),
  city_name = IF(city_name = '', NULL, city_name),
  state_name = IF(state_name = '', NULL, state_name),
  zip = IF(zip = '', NULL, zip),
  referral_region_desc = IF(referral_region_desc = '', NULL, referral_region_desc),
  total_discharges = IF(total_discharges = '', NULL, total_discharges),
  avg_cov_charges = IF(avg_cov_charges = '', NULL, avg_cov_charges),
  avg_total_payment = IF(avg_total_payment = '', NULL, avg_total_payment),
  avg_med_payment = IF(avg_med_payment = '', NULL, avg_med_payment);

-- DROP TEMPORARY TABLE temp_medicare -- Comment back in later 

--
-- STATE
--

CREATE TABLE IF NOT EXISTS state
  (
    state_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    state_name VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (state_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

--
-- CITY
--

CREATE TABLE IF NOT EXISTS city
  (
    city_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    city_name VARCHAR(100) NOT NULL UNIQUE,
    state_id INTEGER NOT NULL,
    PRIMARY KEY (city_id),
    FOREIGN KEY (state_id) REFERENCES state(state_id) ON DELETE RESTRICT ON UPDATE CASCADE
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

--
-- ADDRESS
--

CREATE TABLE IF NOT EXISTS address
  (
    address_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    street VARCHAR(100) NOT NULL UNIQUE,
    zip VARCHAR(5) NOT NULL UNIQUE, 
    city_id INTEGER NOT NULL,
    PRIMARY KEY (address_id),
    FOREIGN KEY (city_id) REFERENCES city(city_id) ON DELETE RESTRICT
    ON UPDATE CASCADE
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
    referral_region_desc VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (referral_region_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;


--
-- PROVIDER
--

CREATE TABLE IF NOT EXISTS provider
  (
    provider_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    old_provider_id VARCHAR(100) NOT NULL,
    provider_name VARCHAR(100) NOT NULL UNIQUE,
    referral_region_id INTEGER NOT NULL UNIQUE, 
    address_id INTEGER NOT NULL,
    PRIMARY KEY (provider_id),
    FOREIGN KEY (referral_region_id) REFERENCES referral_region(referral_region_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (address_id) REFERENCES address(address_id) ON DELETE RESTRICT ON UPDATE CASCADE
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
    drg_desc VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (drg_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Temporary target table for medicare data import



--
-- PROVIDER_DRG (LINK TABLE)
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


