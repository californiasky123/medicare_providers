INSERT IGNORE INTO city_state_f (city_state_name, state_name, city_name)
SELECT fm.city_state_name, fm.state_name, fm.city_name
  FROM f_medicare fm
       LEFT JOIN city_state cs
              ON fm.city_state_id = cs.city_state_id
 WHERE IFNULL(fm.city_state_id, 0) = IFNULL(fm.city_state_id, 0)