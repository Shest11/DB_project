SELECT 
    so.StorageID, 
    s.description, 
    COUNT(*) AS ops_cnt
FROM dbo.bm_StorageOperations so
LEFT JOIN dbo.storages s ON s.id = so.StorageID
GROUP BY so.StorageID, s.description;