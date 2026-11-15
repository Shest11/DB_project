SELECT 
    v.id AS vendor_id, 
    v.firstname AS vendor_name,
    COUNT(so.ID) AS ops_cnt,
    ISNULL(SUM(so.Amount), 0) AS total_amount
FROM dbo.vendors v
LEFT JOIN dbo.bm_StorageOperations so ON so.VendorID = v.id
GROUP BY v.id, v.firstname;