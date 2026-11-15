SELECT 
    COUNT(*) AS total_products,
    COUNT(c.id) AS matched_category,
    COUNT(*) - COUNT(c.id) AS diff
FROM dbo.product p
LEFT JOIN dbo.category c ON c.id = p.CategoryID;