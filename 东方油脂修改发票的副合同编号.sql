SELECT TOP 100
        *
FROM    ICSale
WHERE   FBillNo = 'ZSEFP000553';

SELECT TOP 100
        *
FROM    dbo.ICSaleEntry
WHERE   FInterID = 2440;

--ZSEFP000552

SELECT TOP 100
        *
FROM    ICSale
WHERE   FBillNo = 'PSEFP000817';

SELECT TOP 100
        *
FROM    dbo.ICSaleEntry
WHERE   FInterID = 2439;

--PSEFP000817

SELECT  FSourceEntryID ,
        A.FSourceBillNo ,
        B.FEntrySelfB0180
        
 --UPDATE A SET A.FEntrySelfI0473=B.FEntrySelfB0180
 --UPDATE A SET A.FEntrySelfI0572=B.FEntrySelfB0180
FROM    dbo.ICSaleEntry A
        INNER JOIN ( SELECT ICStockBill.FBillNo ,
                            dbo.ICStockBillEntry.FEntryID ,
                            FEntrySelfB0180
                     FROM   ICStockBill ,
                            ICStockBillEntry
                     WHERE  dbo.ICStockBill.FInterID = ICStockBillEntry.FInterID
                   ) B ON A.FSourceEntryID = B.FEntryID
                          AND A.FSourceBillNo = B.FBillNo;
GO

dbo.SpK3_2Str @sName = 'ICStockBillEntry';
 -- varchar(50)

GO

dbo.SpK3_2Str @sName = 'ICSaleEntry'; 
-- varchar(50)


SELECT  *
FROM    ICSaleEntry;

SELECT  FEntrySelfA0168 ,
        FEntrySelfB0180 ,
        *
FROM    ICStockBillEntry;




SELECT  FSourceEntryID ,
        A.FSourceBillNo ,
        B.FEntrySelfB0180,
        A.FTranType,
        A.FEntrySelfI0572
 --UPDATE A SET A.FEntrySelfI0572=B.FEntrySelfB0180
FROM    (SELECT A.FSourceBillNo,AFSourceBillNo,A.FTranType FROM  dbo.ICSaleEntry ,ICSALE WHERE ICSALE.FInterID=dbo.ICSaleEntry.FInterID)A
        INNER JOIN ( SELECT ICStockBill.FBillNo ,
                            dbo.ICStockBillEntry.FEntryID ,
                            FEntrySelfB0180
                     FROM   ICStockBill ,
                            ICStockBillEntry
                     WHERE  dbo.ICStockBill.FInterID = ICStockBillEntry.FInterID
                   ) B ON A.FSourceEntryID = B.FEntryID
                          AND A.FSourceBillNo = B.FBillNo
                          AND A.FTranType=86

                          
                          
                          
SELECT  FSourceEntryID ,
        A.FSourceBillNo ,
        B.FEntrySelfB0180,
        A.FTranType
 UPDATE A SET A.FEntrySelfI0473=B.FEntrySelfB0180

FROM    (SELECT A.FSourceBillNo,AFSourceBillNo,A.FTranType FROM  dbo.ICSaleEntry ,ICSALE WHERE ICSALE.FInterID=dbo.ICSaleEntry.FInterID)A
        INNER JOIN ( SELECT ICStockBill.FBillNo ,
                            dbo.ICStockBillEntry.FEntryID ,
                            FEntrySelfB0180
                     FROM   ICStockBill ,
                            ICStockBillEntry
                     WHERE  dbo.ICStockBill.FInterID = ICStockBillEntry.FInterID
                   ) B ON A.FSourceEntryID = B.FEntryID
                          AND A.FSourceBillNo = B.FBillNo
                          AND A.FTranType=80



GO

dbo.SpK3_2Str @sName = 'ICSale' -- varchar(50)


SELECT * FROM dbo.ICSaleEntry

SELECT FSourceBillNo,FSourceBillNo,FTranType,FEntrySelfI0473,FEntrySelfI0572 FROM  dbo.ICSaleEntry ,ICSALE WHERE ICSALE.FInterID=dbo.ICSaleEntry.FInterID ORDER BY FDATE DESC




SELECT  FSourceEntryID ,
        A.FSourceBillNo ,
        B.FEntrySelfB0180,
     
        C.FTranType,
        A.FEntrySelfI0572
 --UPDATE A SET A.FEntrySelfI0473=B.FEntrySelfB0180
FROM    dbo.ICSaleEntry A INNER JOIN ICSALE C
       ON A.FInterID=C.FInterID
        inner JOIN ( SELECT ICStockBill.FBillNo ,
                            dbo.ICStockBillEntry.FEntryID ,
                            FEntrySelfB0180
                     FROM   ICStockBill ,
                            ICStockBillEntry
                     WHERE  dbo.ICStockBill.FInterID = ICStockBillEntry.FInterID
                     AND FTranType=21
                   ) B ON  A.FSourceEntryID = B.FEntryID AND
                           A.FSourceBillNo = B.FBillNo
                          AND C.FTranType=80
                          
                          
                          
 SELECT  FSourceEntryID ,
        A.FSourceBillNo ,
        B.FEntrySelfB0180,
     
        C.FTranType,
        A.FEntrySelfI0572
 --UPDATE A SET A.FEntrySelfI0572=B.FEntrySelfB0180
FROM    dbo.ICSaleEntry A INNER JOIN ICSALE C
       ON A.FInterID=C.FInterID
        inner JOIN ( SELECT ICStockBill.FBillNo ,
                            dbo.ICStockBillEntry.FEntryID ,
                            FEntrySelfB0180
                     FROM   ICStockBill ,
                            ICStockBillEntry
                     WHERE  dbo.ICStockBill.FInterID = ICStockBillEntry.FInterID
                     AND FTranType=21
                   ) B ON  A.FSourceEntryID = B.FEntryID AND
                           A.FSourceBillNo = B.FBillNo
                          AND C.FTranType=86                        
                          

                   SELECT * FROM icsaleentry WHERE FSourceBillNo='XOUT000003'       