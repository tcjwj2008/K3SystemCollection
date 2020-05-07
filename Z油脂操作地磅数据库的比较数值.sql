
SELECT TOP 50000

v1.*

    
FROM    ICStockBill v1
        INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                          AND u1.FInterID <> 0
        INNER JOIN t_ICItem t13 ON u1.FItemID = t13.FItemID
                                   AND t13.FItemID <> 0
WHERE   1 = 1            
        AND v1.FBillNo IN ('XOUT001943','XOUT001942')              



SELECT TOP 50000

u1.*

    
FROM    ICStockBill v1
        INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                          AND u1.FInterID <> 0
        INNER JOIN t_ICItem t13 ON u1.FItemID = t13.FItemID
                                   AND t13.FItemID <> 0
WHERE   1 = 1
                   
        AND v1.FBillNo IN ('XOUT001943','XOUT001942')              
