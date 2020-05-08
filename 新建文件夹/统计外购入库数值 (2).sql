
SELECT 
t13.FNumber,
t13.FName,
SUM(u1.FAuxQty) AS Fauxqty, 
SUM(u1.FAmount) AS Famount,
CASE SUM(u1.fauxqty)    
FROM    
        ICStockBill v1
        INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
          AND u1.FInterID <> 0
        INNER JOIN t_ICItem t13 ON u1.FItemID = t13.FItemID
        AND t13.FItemID <> 0
WHERE   1 = 1
        AND ( v1.FTranType = 1
              AND ( ( v1.FCheckerID > 0 )
                    AND ( v1.FDate >= '2019-06-01'
                          AND v1.FDate < '2019-07-01'
                        )
                  )
            )            
GROUP BY t13.FNumber,t13.FName