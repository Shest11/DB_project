SELECT 
    pt.paymenttypeid, 
    pt.description, 
    COUNT(po.ID) AS ops_cnt
FROM dbo.paymenttype pt
LEFT JOIN dbo.bm_PaymentOperations po ON po.PaymentTypeID = pt.paymenttypeid
GROUP BY pt.paymenttypeid, pt.description;