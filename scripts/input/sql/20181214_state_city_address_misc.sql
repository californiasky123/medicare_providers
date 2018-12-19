INSERT IGNORE INTO address_temp(street, zip_code, city_id)
SELECT DISTINCT tm.street, tm.zip_code, cn.city_id
FROM temp_medicare tm 
LEFT JOIN city cn
ON tm.city_name = cn.city_name 
LEFT JOIN state 
on tm.state_name = tm.state_name




INSERT IGNORE INTO city(city_name, state_id) SELECT DISTINCT tm.city_name, sn.state_id
FROM temp_medicare tm
LEFT JOIN state sn
ON tm.state_name = sn.state_name;