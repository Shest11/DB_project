SELECT 
    COUNT(*) AS total_vendors,
    COUNT(cg.vendorgroupid) AS matched_group,
    COUNT(*) - COUNT(cg.vendorgroupid) AS diff
FROM dbo.vendors v
LEFT JOIN dbo.vendorgroup cg ON cg.vendorgroupid = v.clientgroup;