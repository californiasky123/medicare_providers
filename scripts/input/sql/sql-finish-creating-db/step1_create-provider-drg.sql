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
    FOREIGN KEY (provider_id) REFERENCES provider_temp(provider_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (drg_id) REFERENCES drg(drg_id) ON DELETE CASCADE ON UPDATE CASCADE
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;
