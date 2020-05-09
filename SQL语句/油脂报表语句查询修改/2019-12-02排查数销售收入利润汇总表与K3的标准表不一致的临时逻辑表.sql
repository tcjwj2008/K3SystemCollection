 SET NOCOUNT ON;
 SET NOCOUNT ON;
 CREATE TABLE #DATA2
    (
      FItemID INT NULL ,
      FCustID INT NULL ,
      FDeptID INT NULL ,
      FEmpID INT NULL ,
      FSaleQty DECIMAL(28, 10) NOT  NULL
                               DEFAULT ( 0 ) ,
      FSaleIn DECIMAL(28, 10) NOT  NULL
                              DEFAULT ( 0 ) ,
      FSendQty DECIMAL(28, 10) NOT  NULL
                               DEFAULT ( 0 ) ,
      FSaleCost DECIMAL(28, 10) NOT  NULL
                                DEFAULT ( 0 ) ,
      FMTONo NVARCHAR(100) DEFAULT ( '' )
    );
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSendQty ,
          FSaleCost ,
          FMTONo
        )
        SELECT  v2.FItemID ,
                v1.FSupplyID ,
                v1.FDeptID ,
                v1.FEmpID ,
                v2.FQty ,
                v2.FAmount ,
                v2.FMTONo
        FROM    ICStockBill v1 ,
                ICStockBillEntry v2 ,
                t_ICItem t1 ,
                t_Organization t2
        WHERE   v1.FInterID = v2.FInterID
                AND v2.FItemID = t1.FItemID
                AND v1.FSupplyID = t2.FItemID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v1.FSaleStyle IN ( 100, 101, 20297, 20298 )
                AND v1.FDate >= '2019-11-01'
                AND v1.FDate < '2019-12-01'
                AND v1.FSaleStyle IN ( 100, 101, 102, 103, 20296, 20297, 20298 )
                AND ( ( EXISTS ( SELECT FItemID
                                 FROM   t_Stock
                                 WHERE  FItemID = v2.FSCStockID
                                        AND FIncludeAccounting = 1 ) )
                      OR ( EXISTS ( SELECT  FItemID
                                    FROM    t_Stock
                                    WHERE   FItemID = v2.FDCStockID
                                            AND FIncludeAccounting = 1 ) )
                    );  
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSendQty ,
          FSaleCost ,
          FMTONo
        )
        SELECT  v2.FItemID ,
                v1.FSupplyID ,
                v1.FDeptID ,
                v1.FEmpID ,
                t8.FHookQty ,
                v2.FAmount * CASE WHEN v2.FQty = 0 THEN 0
                                  ELSE ( CAST(t8.FHookQty AS DECIMAL(28, 10))
                                         / CAST(v2.FQty AS DECIMAL(28, 10)) )
                             END ,
                v2.FMTONo
        FROM    ICStockBill v1 ,
                ICStockBillEntry v2 ,
                t_ICItem t1 ,
                t_Organization t2 ,
                ( SELECT    SUM(FHookQty) AS FHookQty ,
                            FIBInterID ,
                            FEntryID
                  FROM      ICHookRelations
                  WHERE     FHookType = 1
                            AND FIBTag = 1
                            AND FYear = 2019
                            AND FPeriod = 11
                  GROUP BY  FIBInterID ,
                            FEntryID
                ) t8
        WHERE   v1.FInterID = v2.FInterID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v2.FItemID = t1.FItemID
                AND v1.FSupplyID = t2.FItemID
                AND v1.FSaleStyle IN ( 102, 103 )
                AND t8.FIBInterID = v1.FInterID
                AND t8.FEntryID = v2.FEntryID
                AND v1.FSaleStyle IN ( 100, 101, 102, 103, 20296, 20297, 20298 )
                AND ( ( EXISTS ( SELECT FItemID
                                 FROM   t_Stock
                                 WHERE  FItemID = v2.FSCStockID
                                        AND FIncludeAccounting = 1 ) )
                      OR ( EXISTS ( SELECT  FItemID
                                    FROM    t_Stock
                                    WHERE   FItemID = v2.FDCStockID
                                            AND FIncludeAccounting = 1 ) )
                    );  
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSendQty ,
          FSaleCost ,
          FMTONo
        )
        SELECT  v2.FItemID ,
                v1.FCustID ,
                v1.FDeptID ,
                v1.FEmpID ,
                v2.FQty ,
                ( CASE WHEN v3.FTranType IN ( 75 ) THEN v4.FStdAmount
                       ELSE v4.FStdAmount - v4.FStdTaxAmount
                  END ) * ( CASE WHEN v4.FQty = 0 THEN 0
                                 ELSE CAST(v2.FQty AS DECIMAL(28, 10))
                                      / CAST(v4.FQty AS DECIMAL(28, 10))
                            END ) ,
                v2.FMTONo
        FROM    ICSale v1 ,
                ICSaleEntry v2 ,
                ICPurchase v3 ,
                ICPurchaseEntry v4 ,
                t_ICItem t1 ,
                t_Organization t2
        WHERE   v1.FInterID = v2.FInterID
                AND v3.FInterID = v4.FInterID
                AND v2.FSourceInterId = v3.FInterID
                AND v2.FSourceEntryID = v4.FEntryID
                AND v2.FSourceTranType IN ( 75, 76 )
                AND v2.FItemID = t1.FItemID
                AND v1.FCustID = t2.FItemID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v1.FSubSystemID <> 1
                AND v1.FSaleStyle = 20296
                AND v1.FDate >= '2019-11-01'
                AND v1.FDate < '2019-12-01'
                AND v1.FSaleStyle IN ( 100, 101, 102, 103, 20296, 20297, 20298 ); 
  
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSendQty ,
          FSaleCost ,
          FMTONo
        )
        SELECT  v2.FItemID ,
                v1.FCustID ,
                v1.FDeptID ,
                v1.FEmpID ,
                v4.FQty ,
                ( CASE WHEN v3.FTranType IN ( 75 ) THEN v4.FStdAmount
                       ELSE v4.FStdAmount - v4.FStdTaxAmount
                  END ) ,
                v2.FMTONo
        FROM    ICSale v1 ,
                ICSaleEntry v2 ,
                ICPurchase v3 ,
                ICPurchaseEntry v4 ,
                t_ICItem t1 ,
                t_Organization t2
        WHERE   v1.FInterID = v2.FInterID
                AND v3.FInterID = v4.FInterID
                AND v1.FInterID = v4.FSourceInterId
                AND v2.FEntryID = v4.FSourceEntryID
                AND v4.FSourceTranType IN ( 80, 86 )
                AND NOT EXISTS ( SELECT *
                                 FROM   ICPurchase t100
                                        INNER JOIN ICPurchaseEntry t101 ON t100.FInterID = t101.FInterID
                                 WHERE  t100.FInterID = v2.FSourceInterId
                                        AND t101.FEntryID = v2.FSourceEntryID
                                        AND v2.FSourceTranType IN ( 75, 76 ) )
                AND v2.FItemID = t1.FItemID
                AND v1.FCustID = t2.FItemID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v1.FSubSystemID <> 1
                AND v1.FSaleStyle = 20296
                AND v1.FDate >= '2019-11-01'
                AND v1.FDate < '2019-12-01'
                AND v1.FSaleStyle IN ( 100, 101, 102, 103, 20296, 20297, 20298 ); 
  
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSendQty ,
          FSaleCost
        )
        SELECT  v2.FItemID ,
                '' AS FSupplyID ,
                v1.FDeptID ,
                v1.FEmpID ,
                0 AS FQty ,
                v2.FAmount
        FROM    ICStockBill v1
                INNER JOIN ICStockBillEntry v2 ON v1.FInterID = v2.FInterID
                INNER JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
        WHERE   v1.FStatus > 0
                AND v1.FCancellation = 0
                AND FTranType = 100
                AND v1.FBillTypeID = 12541
                AND v1.FRefType = 12571
                AND v1.FDate >= '2019-11-01'
                AND v1.FDate < '2019-12-01'
                AND ( ( EXISTS ( SELECT FItemID
                                 FROM   t_Stock
                                 WHERE  FItemID = v2.FSCStockID
                                        AND FIncludeAccounting = 1 ) )
                      OR ( EXISTS ( SELECT  FItemID
                                    FROM    t_Stock
                                    WHERE   FItemID = v2.FDCStockID
                                            AND FIncludeAccounting = 1 ) )
                    );  
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSaleQty ,
          FSaleIn ,
          FMTONo
        )
        SELECT  v2.FItemID ,
                v1.FCustID ,
                v1.FDeptID ,
                v1.FEmpID ,
                v2.FQty ,
                ROUND(CASE v1.FTranType
                        WHEN 80 THEN v2.FStdAmount
                        ELSE ( v2.FStdAmount - v2.FStdTaxAmount )
                      END, 2) ,
                v2.FMTONo
        FROM    ICSale v1 ,
                ICSaleEntry v2 ,
                t_ICItem t1 ,
                t_Organization t2
        WHERE   v1.FInterID = v2.FInterID
                AND v2.FItemID = t1.FItemID
                AND v1.FCustID = t2.FItemID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v1.FSubSystemID <> 1
                AND v1.FSaleStyle IN ( 100, 101, 20297, 20298 )
                AND v1.FDate >= '2019-11-01'
                AND v1.FDate < '2019-12-01'
                AND v1.FSaleStyle IN ( 100, 101, 102, 103, 20296, 20297, 20298 ); 
  
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSaleQty ,
          FSaleIn ,
          FMTONo
        )
        SELECT  v2.FItemID ,
                v1.FCustID ,
                v1.FDeptID ,
                v1.FEmpID ,
                t8.FHookQty ,
                ROUND(CASE v1.FTranType
                        WHEN 80 THEN v2.FStdAmount
                        ELSE ( v2.FStdAmount - v2.FStdTaxAmount )
                      END, 2) * CASE WHEN v2.FQty = 0 THEN 0
                                     ELSE ( CAST(t8.FHookQty AS DECIMAL(28, 10))
                                            / CAST(v2.FQty AS DECIMAL(28, 10)) )
                                END ,
                v2.FMTONo
        FROM    ICSale v1 ,
                ICSaleEntry v2 ,
                t_ICItem t1 ,
                t_Organization t2 ,
                ( SELECT    SUM(FHookQty) AS FHookQty ,
                            FIBInterID ,
                            FEntryID
                  FROM      ICHookRelations
                  WHERE     FHookType = 1
                            AND FIBTag = 0
                            AND FYear = 2019
                            AND FPeriod = 11
                  GROUP BY  FIBInterID ,
                            FEntryID
                ) t8
        WHERE   v1.FInterID = v2.FInterID
                AND v1.FInterID = t8.FIBInterID
                AND v2.FEntryID = t8.FEntryID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v1.FSubSystemID <> 1
                AND v1.FSaleStyle IN ( 102, 103 )
                AND v2.FItemID = t1.FItemID
                AND v1.FCustID = t2.FItemID
                AND v1.FSaleStyle IN ( 100, 101, 102, 103, 20296, 20297, 20298 ); 
  
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSaleQty ,
          FSaleIn ,
          FMTONo
        )
        SELECT  v2.FItemID ,
                v1.FCustID ,
                v1.FDeptID ,
                v1.FEmpID ,
                v2.FQty ,
                CASE v1.FTranType
                  WHEN 80 THEN v2.FStdAmount
                  ELSE v2.FStdAmount - v2.FStdTaxAmount
                END AS FAmount ,
                v2.FMTONo
        FROM    ICSale v1 ,
                ICSaleEntry v2 ,
                ICPurchase v3 ,
                ICPurchaseEntry v4 ,
                t_ICItem t1 ,
                t_Organization t2
        WHERE   v1.FInterID = v2.FInterID
                AND v3.FInterID = v4.FInterID
                AND v2.FSourceInterId = v3.FInterID
                AND v2.FSourceEntryID = v4.FEntryID
                AND v2.FSourceTranType IN ( 75, 76 )
                AND v2.FItemID = t1.FItemID
                AND v1.FCustID = t2.FItemID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v1.FSubSystemID <> 1
                AND v1.FSaleStyle = 20296
                AND v2.FItemID = t1.FItemID
                AND v1.FCustID = t2.FItemID
                AND v1.FDate >= '2019-11-01'
                AND v1.FDate < '2019-12-01'
                AND v1.FSaleStyle IN ( 100, 101, 102, 103, 20296, 20297, 20298 ); 
  
 INSERT INTO #DATA2
        ( FItemID ,
          FCustID ,
          FDeptID ,
          FEmpID ,
          FSaleQty ,
          FSaleIn ,
          FMTONo
        )
        SELECT  v2.FItemID ,
                v1.FCustID ,
                v1.FDeptID ,
                v1.FEmpID ,
                v4.FQty ,
                ( CASE v1.FTranType
                    WHEN 80 THEN v2.FStdAmount
                    ELSE v2.FStdAmount - v2.FStdTaxAmount
                  END ) * ( CASE WHEN v2.FQty = 0 THEN 0
                                 ELSE ( CAST(v4.FQty AS DECIMAL(28, 10))
                                        / CAST(v2.FQty AS DECIMAL(28, 10)) )
                            END ) AS FAmount ,
                v2.FMTONo
        FROM    ICSale v1 ,
                ICSaleEntry v2 ,
                ICPurchase v3 ,
                ICPurchaseEntry v4 ,
                t_ICItem t1 ,
                t_Organization t2
        WHERE   v1.FInterID = v2.FInterID
                AND v3.FInterID = v4.FInterID
                AND v2.FInterID = v4.FSourceInterId
                AND v2.FEntryID = v4.FSourceEntryID
                AND v4.FSourceTranType IN ( 80, 86 )
                AND NOT EXISTS ( SELECT *
                                 FROM   ICPurchase t100
                                        INNER JOIN ICPurchaseEntry t101 ON t100.FInterID = t101.FInterID
                                 WHERE  t100.FInterID = v2.FSourceInterId
                                        AND t101.FEntryID = v2.FSourceEntryID
                                        AND v2.FSourceTranType IN ( 75, 76 ) )
                AND v2.FItemID = t1.FItemID
                AND v1.FCustID = t2.FItemID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v1.FSubSystemID <> 1
                AND v1.FSaleStyle = 20296
                AND v1.FDate >= '2019-11-01'
                AND v1.FDate < '2019-12-01'
                AND v1.FSaleStyle IN ( 100, 101, 102, 103, 20296, 20297, 20298 ); 
  

 SELECT * FROM #DATA2;
 DROP TABLE #data2;