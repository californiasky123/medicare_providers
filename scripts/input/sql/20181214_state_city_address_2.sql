-- state
INSERT IGNORE INTO state(state_name) SELECT DISTINCT state_name FROM temp_medicare;


-- city 
INSERT IGNORE INTO city(city_name, state_id)
SELECT DISTINCT tm.city_name, sn.state_id
FROM temp_medicare tm
LEFT JOIN state sn
ON tm.state_name = sn.state_name;

-- address - regular fields
INSERT IGNORE INTO address_temp_A(street, zip_code, city_id)
SELECT tm.street, tm.zip_code, cn.city_id
FROM temp_medicare tm 
LEFT JOIN city cn
ON tm.city_name = cn.city_name 
LEFT JOIN state sn
on tm.state_name = sn.state_name
ORDER BY city_id;

