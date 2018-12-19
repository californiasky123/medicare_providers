USE medicare;
INSERT IGNORE INTO f_medicare (drg_desc, old_provider_id, provider_name, street, city_name, state_name, zip, referral_region_desc, total_discharges, avg_cov_charges, avg_total_payment, avg_med_payment, city_state_name, city_state_id, referral_region_id, drg_id, address_id, provider_id)
SELECT tm.drg_desc, tm.old_provider_id, tm.provider_name, tm.street, tm.city_state_name, tm.state_name, tm.city_name, tm.zip, tm.referral_region_desc, tm.total_discharges, tm.avg_cov_charges, tm.avg_total_payment, tm.avg_med_payment, tm.city_state_name, cs.city_state_id, rr.referral_region_id, dr.drg_id, ad.address_id, pr.provider_id
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