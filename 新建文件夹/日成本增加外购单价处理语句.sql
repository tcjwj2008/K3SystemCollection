SELECT TOP 50000
        t13.FNumber ,
        u1.fqty ,
        u1.Famount AS Famount      
        
FROM    ICStockBill v1
        INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                          AND u1.FInterID <> 0
        INNER JOIN t_ICItem t13 ON u1.FItemID = t13.FItemID
                                   AND t13.FItemID <> 0
WHERE   1 = 1
        AND ( v1.Fdate = '2019-05-09' ) AND V1.FDate<=GETDATE()
        AND ( v1.FTranType = 1 )
        AND V1.FCancellation = 0            --未作废单据
        AND V1.FStatus = 1                --己审核单据
       -- AND T13.FNumber =''
    
