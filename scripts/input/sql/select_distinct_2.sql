USE medicare;


CREATE TABLE IF NOT EXISTS referral_region_2
  (
    referral_region_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    referral_region_desc VARCHAR(100) NOT NULL,
    PRIMARY KEY (referral_region_id)
  );

INSERT referral_region_2(referral_region_desc) SELECT DISTINCT referral_region_desc FROM t_medicare_1;

SELECT * FROM referral_region_2