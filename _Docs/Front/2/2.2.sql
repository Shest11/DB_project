SELECT 
    COUNT(*) AS total_journal,
    COUNT(tt.transtypeid) AS matched_transtype,
    COUNT(*) - COUNT(tt.transtypeid) AS diff
FROM dbo.journal j
LEFT JOIN dbo.transtype tt ON tt.transtypeid = j.transtype;