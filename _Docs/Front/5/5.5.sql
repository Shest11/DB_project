SELECT 
    COUNT(*) AS total_pricelist,
    COUNT(p.id) AS matched_product,
    COUNT(*) - COUNT(p.id) AS diff
FROM dbo.pricelist pl
LEFT JOIN dbo.product p ON p.id = pl.productid;