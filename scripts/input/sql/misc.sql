-- doesn't return referral region_d onwards
USE medicare;
SELECT tm.drg_desc, tm.provider_name, tm.street, tm.city_state_name, tm.state_name, tm.city_name,
       tm.zip, tm.referral_region_desc, tm.avg_med_payment, tm.avg_cov_charges, 
       tm.avg_total_payment, tm.total_discharges, tm.old_provider_id, cs.city_state_id, dr.drg_desc
       
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