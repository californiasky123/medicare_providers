INSERT IGNORE INTO provider_drg (provider_id, drg_id, avg_med_payment, avg_cov_charges, avg_total_payment, total_discharges)
SELECT fm.provider_id, fm.drg_id, fm.avg_med_payment, fm.avg_cov_charges, fm.avg_total_payment, fm.total_discharges
  FROM f_medicare fm
       LEFT JOIN provider pt
              ON fm.provider_id = pt.provider_id
	   LEFT JOIN drg dr
			ON fm.drg_id = dr.drg_id
 WHERE IFNULL(fm.provider_id, 0) = IFNULL(pt.provider_id, 0)
 AND IFNULL(fm.drg_id, 0) = IFNULL(dr.drg_id, 0)