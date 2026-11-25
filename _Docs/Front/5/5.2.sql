SELECT 
    COUNT(*) AS total_products,
    COUNT(s.ID) AS matched_size,
    COUNT(*) - COUNT(s.ID) AS diff
FROM dbo.product p
LEFT JOIN dbo.size s ON s.ID = p.SizeID;