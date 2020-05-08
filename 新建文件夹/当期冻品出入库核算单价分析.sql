SET NoCount ON
SET Ansi_Warnings OFF
CREATE TABLE #Happen
    (
      FItemID INT NULL ,
      FStockID INT NULL ,
      FStockPlaceID INT NULL ,
      FBatchNo VARCHAR(200) ,
      FMTONo NVARCHAR(100) ,
      FAuxPropID INT NOT NULL
                     DEFAULT ( 0 ) ,
      FBegQty DECIMAL(28, 10) ,
      FBegBal DECIMAL(28, 10) ,
      FInQty DECIMAL(28, 10) ,
      FInPrice DECIMAL(28, 10) ,
      FInAmount DECIMAL(28, 10) ,
      FOutQty DECIMAL(28, 10) ,
      FOutPrice DECIMAL(28, 10) ,
      FOutAmount DECIMAL(28, 10) ,
      FInSecQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FOutSecQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FBegSecQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FBegCUUnitQty DECIMAL(28, 10) ,
      FInCUUnitQty DECIMAL(28, 10) ,
      FOutCUUnitQty DECIMAL(28, 10)
    )
INSERT  INTO #Happen
        SELECT  v2.FItemID ,
                v2.FStockID ,
                ISNULL(v2.FStockPlaceID, 0) ,
                v2.FBatchNo ,
                '' AS FMTONo ,
                v2.FAuxPropID ,
                SUM(v2.FBegQty) ,
                CASE WHEN t1.FTrack = 81
                     THEN SUM(ROUND(v2.FBegBal, 2) - ROUND(v2.FBegDiff, 2))
                     ELSE SUM(ROUND(v2.FBegBal, 2))
                END ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                SUM(v2.FSecBegQty) ,
                0 ,
                0 ,
                0
        FROM    ( SELECT    ic.FBrNo ,
                            ic.FYear ,
                            ic.FPeriod ,
                            ic.FStockID ,
                            ic.FItemID ,
                            ic.FBatchNo ,
                            ic.FBegQty ,
                            ic.FReceive ,
                            ic.FSend ,
                            ic.FYtdReceive ,
                            ic.FYtdSend ,
                            ic.FEndQty ,
                            ic.FBegBal ,
                            ic.FDebit ,
                            ic.FCredit ,
                            ic.FYtdDebit ,
                            ic.FYtdCredit ,
                            ic.FEndBal ,
                            ic.FBegDiff ,
                            ic.FReceiveDiff ,
                            ic.FSendDiff ,
                            ic.FEndDiff ,
                            ic.FBillInterID ,
                            ic.FStockPlaceID ,
                            ic.FKFPeriod ,
                            ic.FKFDate ,
                            ic.FYtdReceiveDiff ,
                            ic.FYtdSendDiff ,
                            ic.FSecBegQty ,
                            ic.FSecReceive ,
                            ic.FSecSend ,
                            ic.FSecYtdReceive ,
                            ic.FSecYtdSend ,
                            ic.FSecEndQty ,
                            ic.FAuxPropID ,
                            ic.FStockInDate ,
                            ic.FMTONo ,
                            ic.FSupplyID
                  FROM      ICInvBal ic
                            LEFT JOIN t_Stock tzz ON tzz.FItemid = ic.FStockID
                  WHERE     tzz.FTypeID <> 504
                  UNION ALL
                  SELECT    FBrNo ,
                            FYear ,
                            FPeriod ,
                            FStockID ,
                            FItemID ,
                            FBatchNo ,
                            FBegQty ,
                            FReceive ,
                            FSend ,
                            FYtdReceive ,
                            FYtdSend ,
                            FEndQty ,
                            FBegBal ,
                            FDebit ,
                            FCredit ,
                            FYtdDebit ,
                            FYtdCredit ,
                            FEndBal ,
                            FBegDiff ,
                            FReceiveDiff ,
                            FSendDiff ,
                            FEndDiff ,
                            FBillInterID ,
                            FStockPlaceID ,
                            FKFPeriod ,
                            FKFDate ,
                            FYtdReceiveDiff ,
                            FYtdSendDiff ,
                            FSecBegQty ,
                            FSecReceive ,
                            FSecSend ,
                            FSecYtdReceive ,
                            FSecYtdSend ,
                            FSecEndQty ,
                            FAuxPropID ,
                            FStockInDate ,
                            FMTONo ,
                            FSupplyID
                  FROM      ICVMIInvBal
                ) v2
                LEFT JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
                LEFT JOIN t_Stock t2 ON v2.FStockID = t2.FItemID
                LEFT JOIN t_StockPlace t11 ON v2.FStockPlaceID = t11.FSPID
        WHERE   v2.FYear = 2019
                AND v2.FPeriod = 3
                AND t1.FNumber >= '7.1.02.01.00252'
                AND t1.FNumber <= '7.1.02.01.00252'
                AND t2.FNumber >= '01.07'
                AND t2.FNumber <= '01.07'
        GROUP BY v2.FItemID ,
                v2.FStockID ,
                v2.FStockPlaceID ,
                v2.FBatchNo ,
                v2.FAuxPropID ,
                t1.FTrack
INSERT  INTO #Happen
        SELECT  v2.FItemID ,
                t2.FItemID ,
                ISNULL(v2.FDCSPID, 0) ,
                v2.FBatchNo ,
                '' AS FMTONo ,
                v2.FAuxPropID ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FQty, 0)) ,
                CASE WHEN v1.FTranType IN ( 1, 2, 5, 10, 40, 100, 101, 102 )
                          AND t1.FTrack <> 81 THEN MAX(ISNULL(v2.FPrice, 0))
                     WHEN v1.FTranType IN ( 1, 2, 5, 10, 40, 100, 101, 102 )
                          AND t1.FTrack = 81
                     THEN MAX(ISNULL(v2.FPlanPrice, 0))
                     ELSE 0
                END ,
                CASE WHEN v1.FTranType IN ( 1, 2, 5, 10, 40, 100, 101, 102 )
                          AND t1.FTrack <> 81
                     THEN SUM(ISNULL(ROUND(v2.FAmount, 2), 0))
                     WHEN v1.FTranType IN ( 1, 2, 5, 10, 40, 100, 101, 102 )
                          AND t1.FTrack = 81
                     THEN SUM(ISNULL(ROUND(v2.FPlanAmount, 2), 0))
                     ELSE 0
                END ,
                0 ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FSecQty, 0)) ,
                0 ,
                0 ,
                0 ,
                0 ,
                0
        FROM    ICStockBill v1
                INNER JOIN ICStockBillEntry v2 ON v1.FInterID = v2.FInterID
                LEFT JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
                LEFT JOIN t_Stock t2 ON v2.FDCStockID = t2.FItemID
                LEFT JOIN t_StockPlace t11 ON v2.FDCSPID = t11.FSPID
        WHERE   ( v1.FTranType IN ( 1, 2, 5, 10, 40, 101, 102 )
                  OR ( V1.FTranType = 100
                       AND V1.FBillTypeID = 12542
                     )
                )
                AND v1.FDate >= '2019-03-01'
                AND v1.FDate < '2019-04-01'
                AND t1.FNumber >= '7.1.02.01.00252'
                AND t1.FNumber <= '7.1.02.01.00252'
                AND t2.FNumber >= '01.07'
                AND t2.FNumber <= '01.07'
                AND v1.FCancelLation = 0
                AND ( NOT ( v1.FTranType = 1
                            AND v1.FPoMode = 36681
                          )
                    )
        GROUP BY v2.FItemID ,
                t2.FItemID ,
                v2.FDCSPID ,
                v2.FBatchNo ,
                v2.FAuxPropID ,
                v1.FTranType ,
                t1.FTrack
INSERT  INTO #Happen
        SELECT  v2.FItemID ,
                t2.FItemID ,
                ISNULL(v2.FDCSPID, 0) ,
                v2.FBatchNo ,
                '' AS FMTONo ,
                v2.FAuxPropID ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FQty, 0)) ,
                CASE WHEN v1.FTranType IN ( 41 )
                          AND t1.FTrack = 81
                     THEN MAX(ISNULL(v2.FPlanPrice, 0))
                     WHEN v1.FTranType = 41 THEN MAX(ISNULL(v2.FPriceRef, 0))
                     ELSE 0
                END ,
                CASE WHEN v1.FTranType IN ( 41 )
                          AND t1.FTrack = 81
                     THEN SUM(ISNULL(ROUND(v2.FPlanAmount, 2), 0))
                     WHEN v1.FTranType = 41
                     THEN SUM(ISNULL(ROUND(v2.FAmtRef, 2), 0))
                     ELSE 0
                END ,
                0 ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FSecQty, 0)) ,
                0 ,
                0 ,
                0 ,
                0 ,
                0
        FROM    ICStockBill v1
                INNER JOIN ICStockBillEntry v2 ON v1.FInterID = v2.FInterID
                LEFT JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
                LEFT JOIN t_Stock t2 ON v2.FDCStockID = t2.FItemID
                LEFT JOIN t_StockPlace t11 ON v2.FDCSPID = t11.FSPID
        WHERE   v1.FTranType = 41
                AND v1.FDate >= '2019-03-01'
                AND v1.FDate < '2019-04-01'
                AND t1.FNumber >= '7.1.02.01.00252'
                AND t1.FNumber <= '7.1.02.01.00252'
                AND t2.FNumber >= '01.07'
                AND t2.FNumber <= '01.07'
                AND v1.FCancelLation = 0
                AND ( NOT ( v1.FTranType = 1
                            AND v1.FPoMode = 36681
                          )
                    )
        GROUP BY v2.FItemID ,
                t2.FItemID ,
                v2.FDCSPID ,
                v2.FBatchNo ,
                v2.FAuxPropID ,
                v1.FTranType ,
                t1.FTrack

INSERT  INTO #Happen
        SELECT  v2.FItemID ,
                t2.FItemID ,
                ISNULL(v2.FSPID, 0) ,
                v2.FBatchNo ,
                '' AS FMTONo ,
                v2.FAuxPropID ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FQty, 0)) ,
                MAX(ROUND(ISNULL(v2.FAuxPrice, 0) / tzz.FCoefficient, 2)) ,
                SUM(ISNULL(ROUND(v2.FAmount, 2), 0)) ,
                0 ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FSecQty, 0)) ,
                0 ,
                0 ,
                0 ,
                0 ,
                0
        FROM    ICVMIInStock v1
                INNER JOIN ICVMIInStockEntry v2 ON v1.FID = v2.FID
                LEFT JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
                LEFT JOIN t_Stock t2 ON v2.FStockID = t2.FItemID
                LEFT JOIN t_StockPlace t11 ON v2.FSPID = t11.FSPID
                LEFT JOIN t_MeasureUnit tzz ON v2.FAuxUnitID = tzz.FMeasureUnitID
        WHERE   v1.FClassTypeID = 1007601
                AND v1.FDate >= '2019-03-01'
                AND v1.FDate < '2019-04-01'
                AND t1.FNumber >= '7.1.02.01.00252'
                AND t1.FNumber <= '7.1.02.01.00252'
                AND t2.FNumber >= '01.07'
                AND t2.FNumber <= '01.07'
        GROUP BY v2.FItemID ,
                t2.FItemID ,
                v2.FSPID ,
                v2.FBatchNo ,
                v2.FAuxPropID ,
                t1.FTrack
INSERT  INTO #Happen
        SELECT  v2.FItemID ,
                t2.FItemID ,
                ISNULL(v2.FDCSPID, 0) ,
                v2.FBatchNo ,
                '' AS FMTONo ,
                v2.FAuxPropID ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FQty, 0)) ,
                CASE WHEN t1.FTrack <> 81 THEN MAX(ISNULL(v2.FPrice, 0))
                     WHEN t1.FTrack = 81 THEN MAX(ISNULL(v2.FPlanPrice, 0))
                     ELSE 0
                END ,
                CASE WHEN t1.FTrack <> 81
                     THEN SUM(ISNULL(ROUND(v2.FAmount, 2), 0))
                     WHEN t1.FTrack = 81
                     THEN SUM(ISNULL(ROUND(v2.FPlanAmount, 2), 0))
                     ELSE 0
                END ,
                0 ,
                SUM(ISNULL(v2.FSecQty, 0)) ,
                0 ,
                0 ,
                0 ,
                0
        FROM    ICStockBill v1
                INNER JOIN ICStockBillEntry v2 ON v1.FInterID = v2.FInterID
                LEFT JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
                LEFT JOIN t_Stock t2 ON v2.FDCStockID = t2.FItemID
                LEFT JOIN t_StockPlace t11 ON v2.FDCSPID = t11.FSPID
        WHERE   ( v1.FTranType IN ( 21, 28, 29, 43 )
                  OR ( V1.FTranType = 100
                       AND V1.FBillTypeID = 12541
                     )
                )
                AND v1.FDate >= '2019-03-01'
                AND v1.FDate < '2019-04-01'
                AND t1.FNumber >= '7.1.02.01.00252'
                AND t1.FNumber <= '7.1.02.01.00252'
                AND t2.FNumber >= '01.07'
                AND t2.FNumber <= '01.07'
                AND v1.FCancelLation = 0
        GROUP BY v2.FItemID ,
                t2.FItemID ,
                v2.FDCSPID ,
                v2.FBatchNo ,
                v2.FAuxPropID ,
                v1.FTranType ,
                t1.FTrack
INSERT  INTO #Happen
        SELECT  v2.FItemID ,
                t2.FItemID ,
                v2.FDCSPID ,
                v2.FBatchNo ,
                '' AS FMTONo ,
                v2.FAuxPropID ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FQty, 0)) ,
                CASE WHEN t1.FTrack <> 81 THEN MAX(ISNULL(v2.FPrice, 0))
                     ELSE MAX(ISNULL(v2.FPlanPrice, 0))
                END ,
                CASE WHEN t1.FTrack <> 81
                     THEN SUM(ISNULL(ROUND(v2.FAmount, 2), 0))
                     ELSE SUM(ISNULL(ROUND(v2.FPlanAmount, 2), 0))
                END ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FSecQty, 0)) ,
                0 ,
                0 ,
                0
        FROM    ICStockBill v1
                INNER JOIN ICStockBillEntry v2 ON v1.FInterID = v2.FInterID
                LEFT JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
                LEFT JOIN t_Stock t2 ON v2.FSCStockID = t2.FItemID
                LEFT JOIN t_MeasureUnit t3 ON t1.FStoreUnitID = t3.FMeasureUnitID
                LEFT JOIN t_StockPlace t11 ON v2.FDCSPID = t11.FSPID
        WHERE   v1.FTranType IN ( 24 )
                AND v1.FDate >= '2019-03-01'
                AND v1.FDate < '2019-04-01'
                AND t1.FNumber >= '7.1.02.01.00252'
                AND t1.FNumber <= '7.1.02.01.00252'
                AND t2.FNumber >= '01.07'
                AND t2.FNumber <= '01.07'
                AND v1.FCancelLation = 0
        GROUP BY v2.FItemID ,
                t2.FItemID ,
                v2.FDCSPID ,
                v2.FBatchNo ,
                v2.FAuxPropID ,
                v1.FTranType ,
                t1.FTrack
INSERT  INTO #Happen
        SELECT  v2.FItemID ,
                t2.FItemID ,
                v2.FSCSPID ,
                v2.FBatchNo ,
                '' AS FMTONo ,
                v2.FAuxPropID ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FQty, 0)) ,
                CASE WHEN t1.FTrack <> 81 THEN MAX(ISNULL(v2.FPrice, 0))
                     ELSE MAX(ISNULL(v2.FPlanPrice, 0))
                END ,
                CASE WHEN t1.FTrack <> 81
                     THEN SUM(ISNULL(ROUND(v2.FAmount, 2), 0))
                     ELSE SUM(ISNULL(ROUND(v2.FPlanAmount, 2), 0))
                END ,
                0 ,
                0 ,
                SUM(ISNULL(v2.FSecQty, 0)) ,
                0 ,
                0 ,
                0
        FROM    ICStockBill v1
                INNER JOIN ICStockBillEntry v2 ON v1.FInterID = v2.FInterID
                LEFT JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
                LEFT JOIN t_Stock t2 ON v2.FSCStockID = t2.FItemID
                LEFT JOIN t_MeasureUnit t3 ON t1.FStoreUnitID = t3.FMeasureUnitID
                LEFT JOIN t_StockPlace t11 ON v2.FSCSPID = t11.FSPID
        WHERE   v1.FTranType IN ( 41 )
                AND v1.FDate >= '2019-03-01'
                AND v1.FDate < '2019-04-01'
                AND t1.FNumber >= '7.1.02.01.00252'
                AND t1.FNumber <= '7.1.02.01.00252'
                AND t2.FNumber >= '01.07'
                AND t2.FNumber <= '01.07'
                AND v1.FCancelLation = 0
        GROUP BY v2.FItemID ,
                t2.FItemID ,
                v2.FSCSPID ,
                v2.FBatchNo ,
                v2.FAuxPropID ,
                v1.FTranType ,
                t1.FTrack
UPDATE  #Happen
SET     FBegCUUnitQty = ISNULL(FBegQty, 0)
        / CAST(t3.FCoefficient AS DECIMAL(28, 10)) ,
        FInCUUnitQty = ISNULL(FInQty, 0)
        / CAST(t3.FCoefficient AS DECIMAL(28, 10)) ,
        FOutCUUnitQty = ISNULL(FOutQty, 0)
        / CAST(t3.FCoefficient AS DECIMAL(28, 10))
FROM    #Happen v2
        INNER JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
        INNER JOIN t_MeasureUnit t3 ON t1.FStoreUnitID = t3.FMeasureUnitID 
SELECT  v1.FItemID ,
        v1.FStockID ,
        v1.FStockPlaceID ,
        v1.FBatchNo ,
        v1.FMTONo ,
        v1.FAuxPropID ,
        SUM(v1.FBegQty) AS FBegQty ,
        SUM(v1.FBegBal) AS FBegBal ,
        SUM(v1.FInQty) AS FInQty ,
        MAX(v1.FInPrice) AS FInPrice ,
        SUM(v1.FInAmount) AS FInAmount ,
        SUM(v1.FOutQty) AS FOutQty ,
        MAX(v1.FOutPrice) AS FOutPrice ,
        SUM(v1.FOutAmount) AS FOutAmount ,
        SUM(v1.FInSecQty) AS FInSecQty ,
        SUM(v1.FOutSecQty) AS FOutSecQty ,
        SUM(v1.FBegSecQty) AS FBegSecQty ,
        SUM(v1.FBegCUUnitQty) AS FBegCUUnitQty ,
        SUM(v1.FInCUUnitQty) AS FInCUUnitQty ,
        SUM(v1.FOutCUUnitQty) AS FOutCUUnitQty
INTO    #Happen1
FROM    #Happen v1
WHERE   1 = 1
GROUP BY v1.FItemID ,
        v1.FStockID ,
        v1.FStockPlaceID ,
        v1.FMTONo ,
        v1.FBatchNo ,
        v1.FAuxPropID
SET NOCOUNT ON
CREATE TABLE #Data
    (
      ForderByID INT DEFAULT ( 0 ) ,
      FProp05 VARCHAR(355) NULL ,
      FStockID INT ,
      FNumber VARCHAR(355) NULL ,
      FShortNumber VARCHAR(355) NULL ,
      FName VARCHAR(355) NULL ,
      FModel VARCHAR(355) NULL ,
      FSUnitName VARCHAR(355) NULL ,
      FCUnitName VARCHAR(355) NULL ,
      FUnitName VARCHAR(355) NULL ,
      FQtyDecimal SMALLINT NULL ,
      FPriceDecimal SMALLINT NULL ,
      FBegQty DECIMAL(28, 10) ,
      FBegPrice DECIMAL(28, 10) ,
      FBegBal DECIMAL(28, 10) ,
      FInQty DECIMAL(28, 10) ,
      FInPrice DECIMAL(28, 10) ,
      FInAmount DECIMAL(28, 10) ,
      FOutQty DECIMAL(28, 10) ,
      FOutPrice DECIMAL(28, 10) ,
      FOutAmount DECIMAL(28, 10) ,
      FEndQty DECIMAL(28, 10) ,
      FEndPrice DECIMAL(28, 10) ,
      FEndAmount DECIMAL(28, 10) ,
      FSumSort SMALLINT NOT NULL
                        DEFAULT ( 0 ) ,
      FID INT IDENTITY ,
      FBegSecQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FInSecQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FOutSecQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FBalSecQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FCUUnitName VARCHAR(355) NULL ,
      FBegCUUnitQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FBegCUUnitPrice DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FInCUUnitQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FInCUUnitPrice DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FOutCUUnitQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FOutCUUnitPrice DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FEndCUUnitQty DECIMAL(28, 10) DEFAULT ( 0 ) ,
      FEndCUUnitPrice DECIMAL(28, 10) DEFAULT ( 0 )
    )

INSERT  INTO #Data
        SELECT  0 ,
                CASE WHEN GROUPING(FItemID) = 1 THEN '合计'
                     WHEN GROUPING(FICItemNumber) = 1
                     THEN CONVERT(VARCHAR(355), FItemID) + '(小计)'
                     ELSE CONVERT(VARCHAR(355), FItemID)
                END ,
                FItemID ,
                FICItemNumber ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                6 ,
                4 ,
                SUM(FBegQty) ,
                CASE WHEN SUM(FBegQty) <> 0 THEN SUM(FBegBal) / SUM(FBegQty)
                     ELSE 0
                END ,
                SUM(FBegBal) ,
                SUM(FInQty) ,
                CASE WHEN SUM(FInQty) <> 0 THEN SUM(FInAmount) / SUM(FInQty)
                     ELSE 0
                END ,
                SUM(FInAmount) ,
                SUM(FOutQty) ,
                CASE WHEN SUM(FOutQty) <> 0
                     THEN CAST(SUM(FOutAmount) AS DECIMAL(28, 10))
                          / CAST(SUM(FOutQty) AS DECIMAL(28, 10))
                     ELSE 0
                END ,
                SUM(FOutAmount) ,
                SUM(FEndQty) AS FEndQty ,
                CASE WHEN SUM(FEndQty) <> 0
                     THEN CAST(SUM(FEndAmount) AS DECIMAL(28, 10))
                          / CAST(SUM(FEndQty) AS DECIMAL(28, 10))
                     ELSE 0
                END ,
                SUM(FEndAmount) ,
                CASE WHEN GROUPING(FItemID) = 1 THEN 101
                     WHEN GROUPING(FICItemNumber) = 1 THEN 102
                     ELSE 0
                END ,
                SUM(FBegSecQty) ,
                SUM(FInSecQty) ,
                SUM(FOutSecQty) ,
                SUM(FBalSecQty) ,
                '' ,
                SUM(FBegCUUnitQty) ,
                CASE WHEN SUM(FBegCUUnitQty) <> 0
                     THEN CAST(SUM(FBegBal) AS DECIMAL(28, 10))
                          / CAST(SUM(FBegCUUnitQty) AS DECIMAL(28, 10))
                     ELSE 0
                END ,
                SUM(FInCUUnitQty) ,
                CASE WHEN SUM(FInCUUnitQty) <> 0
                     THEN CAST(SUM(FInAmount) AS DECIMAL(28, 10))
                          / CAST(SUM(FInCUUnitQty) AS DECIMAL(28, 10))
                     ELSE 0
                END ,
                SUM(FOutCUUnitQty) ,
                CASE WHEN SUM(FOutCUUnitQty) <> 0
                     THEN CAST(SUM(FOutAmount) AS DECIMAL(28, 10))
                          / CAST(SUM(FOutCUUnitQty) AS DECIMAL(28, 10))
                     ELSE 0
                END ,
                SUM(FEndCUUnitQty) ,
                CASE WHEN SUM(FEndCUUnitQty) <> 0
                     THEN CAST(SUM(FEndAmount) AS DECIMAL(28, 10))
                          / CAST(SUM(FEndCUUnitQty) AS DECIMAL(28, 10))
                     ELSE 0
                END
        FROM    ( SELECT    t2.FItemID ,
                            t2.FName ,
                            t1.FNumber FICItemNumber ,
                            '' AS col1 ,
                            '' AS col2 ,
                            '' AS col3 ,
                            '' AS col4 ,
                            MAX(t1.FQtyDecimal) AS col5 ,
                            MAX(t1.FPriceDecimal) AS col6 ,
                            SUM(ISNULL(v2.FBegQty, 0)) AS FBegQty ,
                            CASE WHEN SUM(ISNULL(v2.FBegQty, 0)) <> 0
                                 THEN CAST(SUM(ISNULL(FBegBal, 0)) AS DECIMAL(28,
                                                              10))
                                      / CAST(SUM(ISNULL(FBegQty, 0)) AS DECIMAL(28,
                                                              10))
                                 ELSE 0
                            END AS FBegPrice ,
                            SUM(ISNULL(v2.FBegBal, 0)) AS FBegBal ,
                            SUM(ISNULL(FInQty, 0)) AS FInQty ,
                            CASE WHEN SUM(ISNULL(FInQty, 0)) <> 0
                                 THEN CAST(SUM(ISNULL(FInAmount, 0)) AS DECIMAL(28,
                                                              10))
                                      / CAST(SUM(FInQty) AS DECIMAL(28, 10))
                                 ELSE 0
                            END AS FInPrice ,
                            SUM(ISNULL(FInAmount, 0)) AS FInAmount ,
                            SUM(ISNULL(FOutQty, 0)) AS FOutQty ,
                            CASE WHEN SUM(ISNULL(FOutQty, 0)) <> 0
                                 THEN CAST(SUM(ISNULL(FOutAmount, 0)) AS DECIMAL(28,
                                                              10))
                                      / CAST(SUM(ISNULL(FOutQty, 0)) AS DECIMAL(28,
                                                              10))
                                 ELSE 0
                            END AS FOutPrice ,
                            SUM(ISNULL(FOutAmount, 0)) AS FOutAmount ,
                            SUM(ISNULL(FBegQty, 0)) + SUM(ISNULL(FInQty, 0))
                            - SUM(ISNULL(FOutQty, 0)) AS FEndQty ,
                            CASE WHEN SUM(ISNULL(FBegQty, 0))
                                      + SUM(ISNULL(FInQty, 0))
                                      - SUM(ISNULL(FOutQty, 0)) <> 0
                                 THEN CAST(( SUM(ISNULL(FBegBal, 0))
                                             + SUM(ISNULL(FInAmount, 0))
                                             - SUM(ISNULL(FOutAmount, 0)) ) AS DECIMAL(28,
                                                              10))
                                      / CAST(( SUM(ISNULL(FBegQty, 0))
                                               + SUM(ISNULL(FInQty, 0))
                                               - SUM(ISNULL(FOutQty, 0)) ) AS DECIMAL(28,
                                                              10))
                                 ELSE 0
                            END AS FEndPrice ,
                            SUM(ISNULL(FBegBal, 0)) + SUM(ISNULL(FInAmount, 0))
                            - SUM(ISNULL(FOutAmount, 0)) AS FEndAmount ,
                            0 AS FSumSort ,
                            SUM(ISNULL(v2.FBegSecQty, 0)) AS FBegSecQty ,
                            SUM(ISNULL(v2.FInSecQty, 0)) AS FInSecQty ,
                            SUM(ISNULL(v2.FOutSecQty, 0)) AS FOutSecQty ,
                            SUM(ISNULL(v2.FBegSecQty, 0))
                            + SUM(ISNULL(v2.FInSecQty, 0))
                            - SUM(ISNULL(v2.FOutSecQty, 0)) AS FBalSecQty ,
                            '' AS FCUUnitName ,
                            SUM(ISNULL(v2.FBegCUUnitQty, 0)) AS FBegCUUnitQty ,
                            SUM(ISNULL(v2.FInCUUnitQty, 0)) AS FInCUUnitQty ,
                            SUM(ISNULL(v2.FOutCUUnitQty, 0)) AS FOutCUUnitQty ,
                            SUM(ISNULL(v2.FBegCUUnitQty, 0))
                            + SUM(ISNULL(v2.FInCUUnitQty, 0))
                            - SUM(ISNULL(v2.FOutCUUnitQty, 0)) AS FEndCUUnitQty
                  FROM      #Happen1 v2
                            INNER JOIN t_ICItem t1 ON v2.FItemID = t1.FItemID
                            LEFT JOIN t_Stock t2 ON v2.FStockID = t2.FItemID
                            LEFT JOIN t_AuxItem ta ON v2.FAuxPropID = ta.FItemID
                  WHERE     1 = 1
                  GROUP BY  t2.FItemID ,
                            t2.FName ,
                            t1.FNumber
                ) t
        GROUP BY FItemID ,
                FICItemNumber
                WITH ROLLUP
UPDATE  t1
SET     t1.FName = ISNULL(t2.FName, '') ,
        t1.FShortNumber = ISNULL(t2.FShortNumber, '') ,
        t1.FModel = ISNULL(t2.FModel, '') ,
        t1.FSUnitName = t3.FName ,
        t1.FCUnitName = t4.FName ,
        t1.FUnitName = t3.FName ,
        t1.FQtyDecimal = t2.FQtyDecimal ,
        t1.FPriceDecimal = t2.FPriceDecimal ,
        t1.FCUUnitName = t4.FName
FROM    #DATA t1
        LEFT JOIN t_ICItem t2 ON t1.FNumber = t2.FNumber
        LEFT JOIN t_MeasureUnit t3 ON t2.FUnitID = t3.FMeasureUnitID
        LEFT JOIN t_MeasureUnit t4 ON t2.FStoreUnitID = t4.FMeasureUnitID
WHERE   t3.FStandard = 1
UPDATE  #data
SET     FshortNumber = '合计' ,
        FOrderbyID = 1
WHERE   fnumber = '合计'
UPDATE  t1
SET     t1.FProp05 = ( CASE WHEN ISNULL(t1.FNumber, '') = ''
                            THEN t2.FName + '(小计)'
                            ELSE t2.FName
                       END )
FROM    #DATA t1
        INNER JOIN t_Stock t2 ON t1.FStockID = t2.FItemID 
SELECT  t.* ,
        tm.FName AS FSecUnitName
FROM    #Data t
        LEFT JOIN t_ICItem ti ON t.FNumber = ti.FNumber
        LEFT JOIN t_MeasureUnit tm ON ti.FSecUnitID = tm.FMeasureUnitID
WHERE   NOT ( FBegQty = 0
              AND FBegBal = 0
              AND FInQty = 0
              AND FInAmount = 0
              AND FOutQty = 0
              AND FOutAmount = 0
            )
ORDER BY t.ForderbyID ,
        t.FID
DROP TABLE #Data  

DROP TABLE #Happen
DROP TABLE #Happen1
