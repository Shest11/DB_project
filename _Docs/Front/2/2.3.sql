SELECT 
    COUNT(*) AS total_journal,
    COUNT(p.id) AS matched_product,
    COUNT(*) - COUNT(p.id) AS diff
FROM dbo.journal j
LEFT JOIN dbo.product p ON p.productid = j.id
WHERE ISNULL(j.id, '') != '';