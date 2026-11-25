SELECT 
    COUNT(*) AS total_ps,
    COUNT(p.personid) AS matched_person,
    COUNT(*) - COUNT(p.personid) AS diff
FROM dbo.bm_PersonnelSecurity ps
LEFT JOIN dbo.personnel p ON p.personid = ps.PersonID;