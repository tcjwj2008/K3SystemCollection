SELECT  dbo.ICStockBillEntry.FInterID ,
        FEntryID ,
        FSCBillInterID FSCBillNo ,
        FSourceEntryID ,
        FSCSPID ,
        FSourceTranType ,
        FSourceInterId ,
        FSourceBillNo ,
        FOrderInterID ,
        FOrderEntryID ,
        FOrderBillNo ,
        dbo.ICStockBillEntry.FSCStockID ,
        dbo.ICStockBillEntry.FDCStockID ,
        FDetailID ,
        FInStockID ,
        FClientOrderNo ,
        FClientEntryID ,
        ICStockBillEntry.*
FROM    ICStockBill ,
        dbo.ICStockBillEntry
WHERE   dbo.ICStockBill.FInterID = dbo.ICStockBillEntry.FInterID
        AND FBillNo = 'XOUT850845'  --5882915
UNION ALL
SELECT  dbo.ICStockBillEntry.FInterID ,
        FEntryID ,
        FSCBillInterID FSCBillNo ,
        FSourceEntryID ,
        FSCSPID ,
        FSourceTranType ,
        FSourceInterId ,
        FSourceBillNo ,
        FOrderInterID ,
        FOrderEntryID ,
        FOrderBillNo ,
        dbo.ICStockBillEntry.FSCStockID ,
        dbo.ICStockBillEntry.FDCStockID ,
        FDetailID ,
        FInStockID ,
        FClientOrderNo ,
        FClientEntryID ,
        ICStockBillEntry.*
FROM    ICStockBill ,
        dbo.ICStockBillEntry
WHERE   dbo.ICStockBill.FInterID = dbo.ICStockBillEntry.FInterID
        AND FBillNo = 'XOUT848639';
 --5882914



UPDATE  ICStockBillEntry
SET     FDetailID = 5882915
FROM    ICStockBill ,
        dbo.ICStockBillEntry
WHERE   dbo.ICStockBill.FInterID = dbo.ICStockBillEntry.FInterID
        AND FBillNo = 'XOUT848639';
 --5882914

GO

dbo.SpK3_2Str @sName = 'ICStockBillEntry';
 -- varchar(50)


SELECT TOP 10000
        FDetailID ,
        *
FROM    ICStockBillEntry
ORDER BY FInterID;









UPDATE  b
SET     --FAuxStockQty= ISNULL(c.Fauxqty,0),-- 出库数量         
  --FStockQty=ISNULL(c.FQty,0),-- 基本单位出库数量        
        FAuxCommitQty = ISNULL(c.Fauxqty, 0) ,-- 关联数量           
        FCommitQty = ISNULL(c.FQty, 0)  --基本单位关联数量         
FROM    SEOrder a
        INNER JOIN SEOrderEntry b ON a.FInterID = b.FInterID
        LEFT JOIN ( SELECT  b.FSourceEntryID ,
                            b.FSourceInterId ,
                            b.FSourceBillNo ,
                            SUM(b.FAuxQty) Fauxqty ,
                            SUM(b.FQty) FQty
                    FROM    ICStockBill a
                            INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID
                    WHERE   a.FTranType = 21
                            AND b.FSourceTranType = 81
                    GROUP BY b.FSourceEntryID ,
                            b.FSourceInterId ,
                            b.FSourceBillNo
                  ) c ON a.FBillNo = c.FSourceBillNo
                         AND a.FInterID = c.FSourceInterId
                         AND b.FEntryID = c.FSourceEntryID
WHERE   a.FBillNo = @FOrderNO;  




SELECT  b.FSourceEntryID ,
        b.FSourceInterId ,
        b.FSourceBillNo ,
        SUM(b.FAuxQty) Fauxqty ,
        SUM(b.FQty) FQty
FROM    ICStockBill a
        INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID
WHERE   a.FTranType = 21
        AND b.FSourceTranType = 81
        AND a.FBillNo = 'XOUT848639'
GROUP BY b.FSourceEntryID ,
        b.FSourceInterId ,
        b.FSourceBillNo;
        
        
     
                            
                            
                            
                            
SELECT  a.FInterID ,
        b.FEntryID ,
        a.FBillNo
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007743'
        AND a.FInterID = 12134
        AND b.FEntryID = 2;
                            
                            
UPDATE  b
SET     --FAuxStockQty= ISNULL(c.Fauxqty,0),-- 出库数量         
  --FStockQty=ISNULL(c.FQty,0),-- 基本单位出库数量        
        FAuxCommitQty = ISNULL(c.Fauxqty, 0) ,-- 关联数量           
        FCommitQty = ISNULL(c.FQty, 0)  --基本单位关联数量         
FROM    SEOrder a
        INNER JOIN SEOrderEntry b ON a.FInterID = b.FInterID
        LEFT JOIN ( SELECT  b.FSourceEntryID ,
                            b.FSourceInterId ,
                            b.FSourceBillNo ,
                            SUM(b.FAuxQty) Fauxqty ,
                            SUM(b.FQty) FQty
                    FROM    ICStockBill a
                            INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID
                    WHERE   a.FTranType = 21
                            AND b.FSourceTranType = 81
                    GROUP BY b.FSourceEntryID ,
                            b.FSourceInterId ,
                            b.FSourceBillNo
                  ) c ON a.FBillNo = c.FSourceBillNo
                         AND a.FInterID = c.FSourceInterId
                         AND b.FEntryID = c.FSourceEntryID
WHERE   a.FBillNo = @FOrderNO;  




SELECT  b.FSourceEntryID ,
        b.FSourceInterId ,
        b.FSourceBillNo ,
        SUM(b.FAuxQty) Fauxqty ,
        SUM(b.FQty) FQty
FROM    ICStockBill a
        INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID
WHERE   a.FTranType = 21
        AND b.FSourceTranType = 81
GROUP BY b.FSourceEntryID ,
        b.FSourceInterId ,
        b.FSourceBillNo;
                            
                            
                            
                            
SELECT  b.FCommitQty
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007743'
        AND FEntryID = 2;
                            
                            
                               
                            
UPDATE  SEOrderEntry
SET     FCommitQty = 0
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007743'
        AND FEntryID = 2;
                            
                            
                                      
SELECT  b.FAuxCommitQty ,
        b.FCommitQty ,
        *
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007870'
UNION ALL
SELECT  b.FAuxCommitQty ,
        b.FCommitQty ,
        *
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007734'
        AND b.FEntryID = 13;
                            
                            
UPDATE  SEOrder
SET     FPrintCount = 0
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007734'
        AND b.FEntryID = 13;
                            
                                                   
    
SELECT  b.FAuxCommitQty ,
        b.FCommitQty ,
        FStatus ,
        a.FSysStatus ,
        *
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007870'
UNION ALL
SELECT  b.FAuxCommitQty ,
        b.FCommitQty ,
        a.FSysStatus ,
        *
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007734'
        AND b.FEntryID = 13;
        
        
        
SELECT  b.FAuxCommitQty ,
        b.FCommitQty ,
        a.FStatus ,
        *
FROM    SEOrder a ,
        dbo.SEOrderEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FBillNo = 'SEORD007743';
       
    
    
SELECT  1
FROM    ICBillRelations_Sale
WHERE   FBillType = 21
        AND FBillID = 1109299;
    
    
    
SELECT  *
FROM    dbo.ICStockBill a ,
        dbo.ICStockBillEntry b
WHERE   a.FInterID = b.FInterID
        AND FBillNo = 'XOUT850853'
UNION ALL
SELECT  *
FROM    dbo.ICStockBill a ,
        dbo.ICStockBillEntry b
WHERE   a.FInterID = b.FInterID
        AND FBillNo = 'XOUT848661';
        
        
        
       GO
       
       dbo.SpK3_2Str @sName = 'icstockbillentry' -- varchar(50)
       
       
       SELECT FSCBillInterID	原单内码                                                                                                                                                                                                                                                           
FSCBillNo	原单单号     




SELECT * FROM dbo.t_Department     WHERE fname LIKE '%门店%'                                                                                                                                                                                                                                                  FROM icstock
       
    
    
    SELECT * 
    FROM    dbo.ICStockBill a ,
        dbo.ICStockBillEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FStatus=0
        
        AND fdate>='2020-04-01'  
         AND fdate<='2020-04-03'  
        --AND a.FDeptID=10172
        
        AND b.FSourceBillNo='SEORD007734'
    
    
    
UPDATE dbo.ICStockBillentry SET  FSourceBillNo='' ,FSourceInterId='',FSourceEntryID='',
FOrderInterID=0,
FOrderEntryID=0,
FOrderBillNo='',

FSCBillInterID=0,
FSCBillNo=''
FROM    dbo.ICStockBill a ,
        dbo.ICStockBillEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FStatus=0
        
        AND fdate>='2020-04-01'  
         AND fdate<='2020-04-03'  
        AND a.FDeptID=10172
        
        AND a.fbillno='XOUT848656'
    
   
    
UPDATE  b
                SET     FAuxStockQty= ISNULL(c.Fauxqty,0),-- 出库数量         
                        FStockQty=ISNULL(c.FQty,0),-- 基本单位出库数量        
                        FAuxCommitQty = ISNULL(c.Fauxqty, 0) ,-- 关联数量           
                        FCommitQty = ISNULL(c.FQty, 0)  --基本单位关联数量         
                FROM    SEOrder a
                        INNER JOIN SEOrderEntry b ON a.FInterID = b.FInterID
                        LEFT JOIN ( SELECT  b.FSourceEntryID ,
                                            b.FSourceInterId ,
                                            b.FSourceBillNo ,
                                            SUM(b.FAuxQty) Fauxqty ,
                                            SUM(b.FQty) FQty
                                    FROM    ICStockBill a
                                            INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID
                                    WHERE   a.FTranType = 21
                                            AND b.FSourceTranType = 81
                                    GROUP BY b.FSourceEntryID ,
                                            b.FSourceInterId ,
                                            b.FSourceBillNo
                                  ) c ON a.FBillNo = c.FSourceBillNo
                                         AND a.FInterID = c.FSourceInterId
                                         AND b.FEntryID = c.FSourceEntryID
                WHERE   a.FBillNo  IN (SELECT b.FSourceBillNo
FROM    dbo.ICStockBill a ,
        dbo.ICStockBillEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FStatus=0
        
        AND fdate>='2020-04-01'
        AND a.FDeptID=10172)
        
        
    
    
    
    
    
    
    UPDATE dbo.ICStockBill SET 
    
   FCancellation=0
FROM    dbo.ICStockBill a ,
        dbo.ICStockBillEntry b
WHERE   a.FInterID = b.FInterID
        AND a.FStatus=0
        
        AND fdate>='2020-04-01'  
         AND fdate<='2020-04-03'  
        AND a.FDeptID=10172
    
   
    
UPDATE  b
                SET     --FAuxStockQty= ISNULL(c.Fauxqty,0),-- 出库数量         
  --FStockQty=ISNULL(c.FQty,0),-- 基本单位出库数量        
                        FAuxCommitQty = ISNULL(c.Fauxqty, 0) ,-- 关联数量           
                        FCommitQty = ISNULL(c.FQty, 0)  --基本单位关联数量         
                FROM    SEOrder a
                        INNER JOIN SEOrderEntry b ON a.FInterID = b.FInterID
                        LEFT JOIN ( SELECT  b.FSourceEntryID ,
                                            b.FSourceInterId ,
                                            b.FSourceBillNo ,
                                            SUM(b.FAuxQty) Fauxqty ,
                                            SUM(b.FQty) FQty
                                    FROM    ICStockBill a
                                            INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID
                                    WHERE   a.FTranType = 21
                                            AND b.FSourceTranType = 81
                                    GROUP BY b.FSourceEntryID ,
                                            b.FSourceInterId ,
                                            b.FSourceBillNo
                                  ) c ON a.FBillNo = c.FSourceBillNo
                                         AND a.FInterID = c.FSourceInterId
                                         AND b.FEntryID = c.FSourceEntryID
                WHERE   a.FBillNo = @FOrderNO; 
                
                
                
                GO 
                
                dbo.SpK3_2Str @sName = 'ICStockBillEntry' -- varchar(50)
                 
    
    
   
   
   
   
   
   
                            
                            
                            
                    