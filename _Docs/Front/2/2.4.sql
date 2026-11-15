SELECT 
    COUNT(*) AS total_journal,
    COUNT(c.id) AS matched_category,
    COUNT(*) - COUNT(c.id) AS diff
FROM dbo.journal j
LEFT JOIN dbo.category c ON c.id = TRY_CAST(j.categoryid AS bigint)
WHERE ISNULL(j.categoryid, '') != '';