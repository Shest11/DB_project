SELECT 
    COUNT(*) AS products_with_vendor,
    COUNT(v.id) AS matched_vendor,
    COUNT(*) - COUNT(v.id) AS diff
FROM dbo.product p
LEFT JOIN dbo.vendors v ON v.id = p.vendorid
WHERE ISNULL(p.vendorid, 0) != 0;