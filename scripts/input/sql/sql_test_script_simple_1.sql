-- doesn't return referral region_d onwards
USE medicare;
SELECT tm.old_provider_id, dr.drg_desc
  FROM t_medicare_1 tm
       LEFT JOIN drg dr
              ON tm.drg_desc = dr.drg_desc