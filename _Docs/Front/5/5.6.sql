SELECT 
    COUNT(*) AS total_pricelist,
    COUNT(pg.pricegroupid) AS matched_group,
    COUNT(*) - COUNT(pg.pricegroupid) AS diff
FROM dbo.pricelist pl
LEFT JOIN dbo.pricegroup pg ON pg.pricegroupid = pl.groupid;