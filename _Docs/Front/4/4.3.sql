SELECT 
    COUNT(*) AS total_ps,
    COUNT(o.ID) AS matched_object,
    COUNT(*) - COUNT(o.ID) AS diff
FROM dbo.bm_PersonnelSecurity ps
LEFT JOIN dbo.bm_SecurityObjects o ON o.ID = ps.ObjectID;