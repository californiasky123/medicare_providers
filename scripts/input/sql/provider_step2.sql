INSERT IGNORE INTO provider (old_provider_id, provider_name, referral_region_id, address_id)
SELECT fm.old_provider_id, fm.provider_name, fm.referral_region_id, fm.address_id
  FROM f_medicare fm
       LEFT JOIN provider_temp pt
              ON fm.provider_id = pt.provider_id
 WHERE IFNULL(fm.provider_id, 0) = IFNULL(pt.provider_id, 0)