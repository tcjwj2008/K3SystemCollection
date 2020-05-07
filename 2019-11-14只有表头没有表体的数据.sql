SELECT DISTINCT
        FDate ,
        FBillNo
FROM    dbo.ICStockBill
WHERE   FInterID NOT IN ( SELECT    FInterID
                          FROM      dbo.ICStockBillEntry );