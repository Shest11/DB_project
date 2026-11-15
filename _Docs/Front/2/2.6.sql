SELECT COUNT(*) AS journal_with_login,
       COUNT(p.personid) AS matched_person,
       COUNT(*) - COUNT(p.personid) AS diff
FROM dbo.journal j
LEFT JOIN dbo.personnel p ON CAST(p.personid AS varchar(20)) = j.loginid
WHERE ISNULL(j.loginid, '') != '';