SELECT 
    COUNT(*) AS total_sessions,
    COUNT(p.personid) AS matched_person,
    COUNT(*) - COUNT(p.personid) AS diff
FROM dbo.bm_JournalSessions js
LEFT JOIN dbo.personnel p ON p.personid = js.PersonID;