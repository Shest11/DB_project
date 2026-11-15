SELECT 
    d.CompanyID, 
    c.CompanyName, 
    COUNT(*) AS docs_cnt
FROM dbo.bm_JournalBarnetDocs d
LEFT JOIN dbo.bm_Companies c ON c.ID = d.CompanyID
GROUP BY d.CompanyID, c.CompanyName;