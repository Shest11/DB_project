SELECT COUNT(*) AS journal_with_client,
       COUNT(c.id) AS matched_client,
       COUNT(*) - COUNT(c.id) AS diff
FROM dbo.journal j
LEFT JOIN dbo.clients c ON c.clientid = j.customerid
WHERE ISNULL(j.customerid, '') != '';