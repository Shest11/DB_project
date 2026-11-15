SELECT 
    COUNT(*) AS total_ops,
    COUNT(sot.ID) AS matched_by_type,
    COUNT(*) - COUNT(sot.ID) AS diff
FROM dbo.bm_StorageOperations so
LEFT JOIN dbo.bm_StorageOperationsType sot ON sot.ID = so.OperationID;