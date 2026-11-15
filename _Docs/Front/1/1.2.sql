SELECT 
    COUNT(*) AS total_ops,
    COUNT(d.ID) AS matched_by_doc,
    COUNT(*) - COUNT(d.ID) AS diff
FROM dbo.bm_StorageOperations so
LEFT JOIN dbo.bm_JournalBarnetDocs d ON d.ID = so.DocumentID;