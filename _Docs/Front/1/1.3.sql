SELECT 
    COUNT(*) AS total_ops,
    COUNT(p.id) AS matched_by_product,
    COUNT(*) - COUNT(p.id) AS diff
FROM dbo.bm_StorageOperations so
LEFT JOIN dbo.product p ON p.id = so.ProductID;