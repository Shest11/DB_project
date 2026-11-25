SELECT 
    COUNT(*) AS ops_with_vendor,
    COUNT(v.id) AS matched_vendor,
    COUNT(*) - COUNT(v.id) AS diff
FROM dbo.bm_StorageOperations so
LEFT JOIN dbo.vendors v ON v.id = so.VendorID
WHERE so.VendorID IS NOT NULL AND so.VendorID != 0;