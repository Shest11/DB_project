SELECT 
    COUNT(*) AS total_bonus,
    COUNT(p.personid) AS matched_person,
    COUNT(*) - COUNT(p.personid) AS diff
FROM dbo.bm_BonusHistory bh
LEFT JOIN dbo.personnel p ON p.personid = bh.PersonID;