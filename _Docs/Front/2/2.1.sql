SELECT 
    COUNT(*) AS total_details,
    COUNT(j.transnumber) AS matched_journal,
    COUNT(*) - COUNT(j.transnumber) AS diff
FROM dbo.bm_Journal_Details jd
LEFT JOIN dbo.journal j ON j.transnumber = jd.SourceID;