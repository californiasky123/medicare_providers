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
DROP TABLE IF EXISTS drg, provider_drg, provider_temp, referral_region, address_temp, provider, address, city_state, t_medicare, t_medicare_1, f_medicare;
SET FOREIGN_KEY_CHECKS=1;



--
-- STATE
--

CREATE TABLE IF NOT EXISTS city_state
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

--
-- ADDRESS - TEMP
--

CREATE TABLE IF NOT EXISTS address_temp
  (
    address_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    street VARCHAR(500) NOT NULL UNIQUE,
    zip VARCHAR(5) NOT NULL, 
    city_state_id INTEGER NOT NULL
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

CREATE TABLE IF NOT EXISTS provider_temp
  (
    provider_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    old_provider_id VARCHAR(100) NOT NULL UNIQUE,
    provider_name VARCHAR(100) NOT NULL,
    referral_region_id INTEGER NOT NULL, 
    address_id INTEGER NOT NULL,
    PRIMARY KEY (provider_id)
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
    drg_desc VARCHAR(500) NOT NULL UNIQUE,
    PRIMARY KEY (drg_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Temporary target table for medicare data import



-- --
-- -- PROVIDER_DRG (LINK TABLE) 
-- -- #chnote Comment this out for now until we have provider and address tables that aren't temp 
-- --

-- CREATE TABLE IF NOT EXISTS provider_drg
--   (
--     provider_drg_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
--     provider_id INTEGER NOT NULL,
--     drg_id INTEGER NOT NULL,
--     avg_med_payment NUMERIC ( 19,4 ),
--     avg_cov_charges NUMERIC ( 19,4 ),
--     avg_total_payment NUMERIC ( 19,4 ),
--     total_discharges NUMERIC ( 19,4 ),
--     PRIMARY KEY (provider_drg_id),
--     FOREIGN KEY (provider_id) REFERENCES provider(provider_id) ON DELETE CASCADE ON UPDATE CASCADE,
--     FOREIGN KEY (drg_id) REFERENCES drg(drg_id) ON DELETE CASCADE ON UPDATE CASCADE
--   )
-- ENGINE=InnoDB
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_0900_ai_ci;



-- CREATE TEMPORARY TABLE t_medicare

CREATE TABLE IF NOT EXISTS t_medicare_1
-- Change to root table, not temporary table. That way I can look at it and run queries on it. 
-- Later change back. 

  (
    id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    drg_desc VARCHAR(500),
    old_provider_id VARCHAR(100) NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    street VARCHAR(500) NOT NULL UNIQUE,
    city_name VARCHAR(100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    zip VARCHAR(5) NOT NULL,
    referral_region_desc VARCHAR(100) NOT NULL,
    avg_med_payment NUMERIC ( 19,4 ),
    avg_cov_charges NUMERIC ( 19,4 ),
    avg_total_payment NUMERIC ( 19,4 ),
    total_discharges NUMERIC ( 19,4 ),
    city_state_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
  )

ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;


LOAD DATA LOCAL INFILE './output/referral_region_desc.csv'
INTO TABLE referral_region
  FIELDS TERMINATED BY '\,'
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 0 LINES
  (referral_region_desc)

  SET referral_region_desc = IF(referral_region_desc = '', NULL, referral_region_desc);



LOAD DATA LOCAL INFILE './output/city_state_name.csv'
INTO TABLE city_state
  FIELDS TERMINATED BY '\,'
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 0 LINES
  (city_state_name)

  SET city_state_name = IF(city_state_name = '', NULL, city_state_name);



LOAD DATA LOCAL INFILE './output/drg_desc.csv'
INTO TABLE drg
  FIELDS TERMINATED BY '\,'
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 0 LINES
  (drg_desc)

  SET drg_desc = IF(drg_desc = '', NULL, drg_desc);



LOAD DATA LOCAL INFILE './output/street.csv'
INTO TABLE address_temp
  FIELDS TERMINATED BY '\,'
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 0 LINES
  (street)

  SET street = IF(street = '', NULL, street);



LOAD DATA LOCAL INFILE './output/old_provider_id.csv'
INTO TABLE provider_temp
  FIELDS TERMINATED BY '\,'
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 0 LINES
  (old_provider_id)

  SET old_provider_id = IF(old_provider_id = '', NULL, old_provider_id);


-- Load data from external file.
-- Check for blank entries and set to NULL.
LOAD DATA LOCAL INFILE 'medicare_data_1212.csv' -- don't need long filepath
INTO TABLE t_medicare_1
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY '\,'
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  -- LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (drg_desc, old_provider_id, provider_name, street, city_name, state_name, zip, referral_region_desc, total_discharges, avg_cov_charges, avg_total_payment, avg_med_payment, city_state_name)

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
  avg_med_payment = IF(avg_med_payment = '', NULL, avg_med_payment),
  city_state_name = IF(city_state_name = '', NULL, city_state_name);



-- create final medicare
CREATE TABLE IF NOT EXISTS f_medicare
-- Change to root table, not temporary table. That way I can look at it and run queries on it. 
-- Later change back. 

  (
    id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    drg_desc VARCHAR(500),
    old_provider_id VARCHAR(100) NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    street VARCHAR(500) NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    zip VARCHAR(5) NOT NULL,
    referral_region_desc VARCHAR(100),
    avg_med_payment NUMERIC ( 19,4 ),
    avg_cov_charges NUMERIC ( 19,4 ),
    avg_total_payment NUMERIC ( 19,4 ),
    total_discharges NUMERIC ( 19,4 ),
    city_state_name VARCHAR(100) NOT NULL,
    city_state_id VARCHAR(100) NOT NULL,
    referral_region_id VARCHAR(100) NOT NULL,
    drg_id INTEGER NOT NULL,
    address_id INTEGER NOT NULL,
    provider_id INTEGER NOT NULL,
    PRIMARY KEY (id)
  )

ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

INSERT IGNORE INTO f_medicare (drg_desc, old_provider_id, provider_name, street, city_name, state_name, zip, referral_region_desc, total_discharges, avg_cov_charges, avg_total_payment, avg_med_payment, city_state_name, city_state_id, referral_region_id, drg_id, address_id, provider_id)
SELECT tm.drg_desc, tm.provider_name, tm.street, tm.city_state_name, tm.state_name, tm.city_name,
       tm.zip, tm.referral_region_desc, tm.avg_med_payment, tm.avg_cov_charges, 
       tm.avg_total_payment, tm.total_discharges, tm.old_provider_id, cs.city_state_id, rr.referral_region_id, dr.drg_id, ad.address_id, pr.provider_id
  FROM t_medicare_1 tm
       LEFT JOIN drg dr
              ON tm.drg_desc = dr.drg_desc
       LEFT JOIN provider_temp pr
              ON tm.old_provider_id = pr.old_provider_id
       LEFT JOIN referral_region rr
              ON tm.referral_region_desc = rr.referral_region_desc
       LEFT JOIN address_temp ad
              ON tm.street = ad.street
       LEFT JOIN city_state cs
              ON tm.city_state_name = cs.city_state_name
 WHERE IFNULL(tm.drg_desc, 0) = IFNULL(dr.drg_desc, 0)
   AND IFNULL(tm.old_provider_id, 0) = IFNULL(pr.old_provider_id, 0)
   AND IFNULL(tm.referral_region_desc, 0) = IFNULL(rr.referral_region_desc, 0)
   AND IFNULL(tm.street, 0) = IFNULL(ad.street, 0)
   AND IFNULL(tm.city_state_name, 0) = IFNULL(cs.city_state_name, 0)
 ORDER BY tm.drg_desc;
