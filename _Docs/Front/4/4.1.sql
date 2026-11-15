SELECT 
    COUNT(*) AS total_personnel,
    COUNT(sa.securityaccessid) AS matched_access,
    COUNT(*) - COUNT(sa.securityaccessid) AS diff
FROM dbo.personnel p
LEFT JOIN dbo.securityaccess sa ON sa.securityaccessid = p.securityaccess;