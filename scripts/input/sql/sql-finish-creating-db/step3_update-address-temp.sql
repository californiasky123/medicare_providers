INSERT IGNORE INTO address_temp (zip, city_state_id)
SELECT fm.zip, fm.city_state_id
  FROM f_medicare fm
        LEFT JOIN address_temp ad 
        ON fm.address_id = ad.address_id
		WHERE IFNULL(fm.address_id, 0) = IFNULL(ad.address_id, 0)
ORDER BY fm.address_id;