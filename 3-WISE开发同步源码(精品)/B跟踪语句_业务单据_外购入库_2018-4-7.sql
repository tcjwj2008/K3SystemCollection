--新增
--增加非跟踪逻辑：判断是否存在上游单据，且上游单据未下推其他数据。
--如没有上游单据，则保存失败，日志预警；如已下推，则保存失败，日志预警
SELECT  *
FROM    t_TableDescription
WHERE   ftablename = 'icstockbill'
SELECT  *
FROM    t_FieldDescription
WHERE   ftableid = 210008
ORDER BY FFieldName

DECLARE @p2 INT
SET @p2 = 1784
EXEC GetICMaxNum 'ICStockBill', @p2 OUTPUT, 1, 16394
SELECT  @p2

INSERT  INTO ICStockBillEntry
        ( FInterID ,
          FEntryID ,
          FBrNo ,
          FMapNumber ,
          FMapName ,
          FItemID ,
          FAuxPropID ,
          FBatchNo ,
          FQtyMust ,
          FQty ,
          FUnitID ,
          FAuxQtyMust ,
          Fauxqty ,
          FSecCoefficient ,
          FSecQty ,
          FAuxPlanPrice ,
          FPurchasePrice ,
          FPlanAmount ,
          Fauxprice ,
          FDiscountRate ,
          FDiscountAmount ,
          Famount ,
          Fnote ,
          FPurchaseAmount ,
          FKFDate ,
          FKFPeriod ,
          FPeriodDate ,
          FDCStockID ,
          FDCSPID ,
          FOrgBillEntryID ,
          FSNListID ,
          FSourceBillNo ,
          FSourceTranType ,
          FSourceInterId ,
          FSourceEntryID ,
          FContractBillNo ,
          FContractInterID ,
          FContractEntryID ,
          FOrderBillNo ,
          FOrderInterID ,
          FOrderEntryID ,
          FAllHookQTY ,
          FAllHookAmount ,
          FCurrentHookQTY ,
          FCurrentHookAmount ,
          FPlanMode ,
          FMTONo ,
          FChkPassItem ,
          FDeliveryNoticeFID ,
          FDeliveryNoticeEntryID ,
          FCheckAmount ,
          FOutSourceInterID ,
          FOutSourceEntryID ,
          FOutSourceTranType
        )
        SELECT  1784 ,
                1 ,
                '0' ,
                '' ,
                '' ,
                42587 ,
                0 ,
                '' ,
                1 ,
                1 ,
                39265 ,
                1 ,
                1 ,
                0 ,
                0 ,
                0 ,
                1 ,
                0 ,
                1 ,
                0 ,
                0 ,
                1 ,
                '' ,
                1 ,
                NULL ,
                0 ,
                NULL ,
                42937 ,
                0 ,
                0 ,
                0 ,
                'POORDN000003' ,
                71 ,
                1171 ,
                1 ,
                '' ,
                0 ,
                0 ,
                'POORDN000003' ,
                1171 ,
                1 ,
                0 ,
                0 ,
                0 ,
                0 ,
                14036 ,
                '' ,
                1058 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 

EXEC p_UpdateBillRelateData 1, 1784, 'ICStockBill', 'ICStockBillEntry' 


INSERT  INTO ICStockBill
        ( FInterID ,
          FBillNo ,
          FBrNo ,
          FTranType ,
          FCancellation ,
          FStatus ,
          FUpStockWhenSave ,
          FROB ,
          FHookStatus ,
          Fdate ,
          FSupplyID ,
          FCheckDate ,
          FFManagerID ,
          FSManagerID ,
          FBillerID ,
          FPOStyle ,
          FMultiCheckDate1 ,
          FMultiCheckDate2 ,
          FMultiCheckDate3 ,
          FMultiCheckDate4 ,
          FMultiCheckDate5 ,
          FMultiCheckDate6 ,
          FRelateBrID ,
          FPOOrdBillNo ,
          FOrgBillInterID ,
          FSelTranType ,
          FBrID ,
          FExplanation ,
          FDeptID ,
          FManagerID ,
          FEmpID ,
          FCussentAcctID ,
          FManageType ,
          FPOMode ,
          FSettleDate ,
          FPrintCount ,
          FPayCondition ,
          FEnterpriseID ,
          FSendStatus ,
          FISUpLoad
        )
        SELECT  1784 ,
                'WIN000002' ,
                '0' ,
                1 ,
                0 ,
                0 ,
                0 ,
                1 ,
                0 ,
                '2018-04-07' ,
                42755 ,
                NULL ,
                42842 ,
                42842 ,
                16394 ,
                252 ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                0 ,
                '' ,
                0 ,
                71 ,
                0 ,
                '' ,
                35633 ,
                0 ,
                42842 ,
                1001 ,
                0 ,
                36680 ,
                '2018-04-07' ,
                0 ,
                0 ,
                0 ,
                0 ,
                1059

UPDATE  ICStockBill
SET     FUUID = NEWID()
WHERE   FInterID = 1784

UPDATE  t
SET     t.FStatus = CASE WHEN ( SELECT  COUNT(1)
                                FROM    POOrderEntry
                                WHERE   ( FCommitQty > 0
                                          OR ( ISNULL(FMRPClosed, 0) = 1
                                               AND ISNULL(FMRPAutoClosed, 1) = 0
                                             )
                                        )
                                        AND FInterID IN ( 1171 )
                              ) = 0 THEN 1
                         WHEN ( SELECT  COUNT(1)
                                FROM    POOrderEntry te
                                WHERE   ( ISNULL(FMRPClosed, 0) = 1
                                          OR FCommitQty >= FQty
                                        )
                                        AND FInterID IN ( 1171 )
                              ) < ( SELECT  COUNT(1)
                                    FROM    POOrderEntry
                                    WHERE   FInterID IN ( 1171 )
                                  ) THEN 2
                         ELSE 3
                    END ,
        t.FClosed = CASE WHEN ( SELECT  COUNT(1)
                                FROM    POOrderEntry te
                                WHERE   ( FCommitQty >= FQty
                                          OR ( ISNULL(te.FMRPAutoClosed, 1) = 0
                                               AND ISNULL(FMRPClosed, 0) = 1
                                             )
                                        )
                                        AND te.FInterID IN ( 1171 )
                              ) = ( SELECT  COUNT(1)
                                    FROM    POOrderEntry te
                                    WHERE   te.FInterID IN ( 1171 )
                                  ) THEN 1
                         ELSE 0
                    END
FROM    POOrder t
WHERE   t.FInterID IN ( 1171 )

UPDATE  v1
SET     v1.FStatus = ( CASE WHEN u1.sumqty > 0
                            THEN ( CASE WHEN u1.qty <= u1.sumqty THEN 3
                                        ELSE 1
                                   END )
                            ELSE v1.FStatus
                       END ) ,
        FChildren = ( CASE WHEN u1.sumqty > 0 THEN 1
                           ELSE 0
                      END )
FROM    POInStock v1
        INNER JOIN ( SELECT t2.FInterID ,
                            SUM(t2.fqty) AS qty ,
                            SUM(t2.fconcommitqty + t2.fcommitqty
                                + t2.FSampleBreakQty) AS sumqty
                     FROM   POInStockEntry t2
                            INNER JOIN ICStockBillEntry t3 ON t2.FInterID = t3.fsourceinterid
                     WHERE  t3.fsourcetrantype = 702
                            AND t3.FInterID = 1784
                     GROUP BY t2.FInterID
                   ) u1 ON v1.FInterID = u1.FInterID

IF EXISTS ( SELECT  1
            FROM    ICBillRelations_Sale
            WHERE   FBillType = 1
                    AND FBillID = 1784 ) 
    BEGIN
        UPDATE  t1
        SET     t1.FChildren = t1.FChildren + 1
        FROM    POOrder t1
                INNER JOIN POOrderEntry t2 ON t1.FInterID = t2.FInterID
                INNER JOIN ICBillRelations_Sale t3 ON t3.FMultiEntryID = t2.FEntryID
                                                      AND t3.FMultiInterID = t2.FInterID
        WHERE   t3.FBillType = 1
                AND t3.FBillID = 1784
    END
ELSE 
    BEGIN
        UPDATE  t3
        SET     t3.FChildren = t3.FChildren + 1
        FROM    ICStockBill t1
                INNER JOIN ICStockBillEntry t2 ON t1.FInterID = t2.FInterID
                INNER JOIN POOrder t3 ON t3.FTranType = t2.FSourceTranType
                                         AND t3.FInterID = t2.FSourceInterID
        WHERE   t1.FTranType = 1
                AND t1.FInterID = 1784
                AND t2.FSourceInterID > 0
    END



--审核
DROP TABLE #TempBill

SET NOCOUNT ON
CREATE TABLE #TempBill
    (
      FID INT IDENTITY(1, 1) ,
      FBrNo VARCHAR(10) NOT NULL
                        DEFAULT ( '' ) ,
      FInterID INT NOT NULL
                   DEFAULT ( 0 ) ,
      FEntryID INT NOT NULL
                   DEFAULT ( 0 ) ,
      FTranType INT NOT NULL
                    DEFAULT ( 0 ) ,
      FItemID INT NOT NULL
                  DEFAULT ( 0 ) ,
      FBatchNo NVARCHAR(255) NOT NULL
                             DEFAULT ( '' ) ,
      FMTONo NVARCHAR(255) NOT NULL
                           DEFAULT ( '' ) ,
      FAuxPropID INT NOT NULL
                     DEFAULT ( 0 ) ,
      FStockID INT NOT NULL
                   DEFAULT ( 0 ) ,
      FStockPlaceID INT NOT NULL
                        DEFAULT ( 0 ) ,
      FKFPeriod INT NOT NULL
                    DEFAULT ( 0 ) ,
      FKFDate VARCHAR(20) NOT NULL
                          DEFAULT ( '' ) ,
      FSupplyID INT NOT NULL
                    DEFAULT ( 0 ) ,
      FQty DECIMAL(28, 10) NOT NULL
                           DEFAULT ( 0 ) ,
      FSecQty DECIMAL(28, 10) NOT NULL
                              DEFAULT ( 0 ) ,
      FAmount DECIMAL(28, 2) NOT NULL
                             DEFAULT ( 0 )
    )

INSERT  INTO #TempBill
        ( FBrNo ,
          FInterID ,
          FEntryID ,
          FTranType ,
          FItemID ,
          FBatchNo ,
          FMTONo ,
          FAuxPropID ,
          FStockID ,
          FStockPlaceID ,
          FKFPeriod ,
          FKFDate ,
          FSupplyID ,
          FQty ,
          FSecQty ,
          FAmount
        )
        SELECT  '' ,
                u1.FInterID ,
                u1.FEntryID ,
                1 AS FTranType ,
                u1.FItemID ,
                ISNULL(u1.FBatchNo, '') AS FBatchNo ,
                ISNULL(u1.FMTONo, '') AS FMTONo ,
                u1.FAuxPropID ,
                ISNULL(u1.FDCStockID, 0) AS FDCStockID ,
                ISNULL(u1.FDCSPID, 0) AS FDCSPID ,
                ISNULL(u1.FKFPeriod, 0) AS FKFPeriod ,
                LEFT(ISNULL(CONVERT(VARCHAR(20), u1.FKFdate, 120), ''), 10) AS FKFDate ,
                FEntrySupply ,
                1 * u1.FQty AS FQty ,
                1 * u1.FSecQty AS FSecQty ,
                1 * u1.FAmount
        FROM    ICStockBillEntry u1
        WHERE   u1.FInterID = 1784
        ORDER BY u1.FEntryID

DROP TABLE #TempPOBill

UPDATE  ICStockBill
SET     FOrderAffirm = 0
WHERE   FInterID = 1784

UPDATE  ICStockBill
SET     FCheckerID = 16394 ,
        FStatus = 1 ,
        FCheckDate = '2018-04-07'
WHERE   FInterID = 1784

IF EXISTS ( SELECT  FOrderInterID
            FROM    ICStockBillEntry
            WHERE   FOrderInterID > 0
                    AND FInterID = 1784 ) 
    UPDATE  u1
    SET     u1.FStockQty = u1.FStockQty + 1 * CAST(u2.FStockQty AS FLOAT) ,
            u1.FSecStockQty = u1.FSecStockQty + 1
            * CAST(u2.FSecStockQty AS FLOAT) ,
            u1.FAuxStockQty = ROUND(( u1.FStockQty + 1
                                      * CAST(u2.FStockQty AS FLOAT) )
                                    / CAST(t3.FCoefficient AS FLOAT),
                                    t1.FQtyDecimal)
    FROM    POOrderEntry u1
            INNER JOIN ( SELECT FOrderInterID ,
                                FOrderEntryID ,
                                FItemID ,
                                SUM(FQty) AS FStockQty ,
                                SUM(FSecQty) AS FSecStockQty ,
                                SUM(FAuxQty) AS FAuxStockQty
                         FROM   ICStockBillEntry
                         WHERE  FInterID = 1784
                         GROUP BY FOrderInterID ,
                                FOrderEntryID ,
                                FItemID
                       ) u2 ON u1.FInterID = u2.FOrderInterID
                               AND u1.FEntryID = u2.FOrderEntryID
                               AND u1.FItemID = u2.FItemID
            INNER JOIN t_ICItem t1 ON u1.FItemID = t1.FItemID
            INNER JOIN t_MeasureUnit t3 ON u1.FUnitID = t3.FItemID


 --PMC这部分也不要
IF OBJECT_ID('tempdb..#tmpPMCPOOrder') IS NOT NULL 
    EXEC('DROP TABLE #tmpPMCPOOrder') 
CREATE TABLE #tmpPMCPOOrder
    (
      FPMCIndex INT NOT NULL
                    DEFAULT ( 0 ) ,
      FOrderInterID INT NOT NULL
                        DEFAULT ( 0 ) ,
      FOrderEntryID INT NOT NULL
                        DEFAULT ( 0 ) ,
      FItemID INT NOT NULL
                  DEFAULT ( 0 )
    )
INSERT  INTO #tmpPMCPOOrder
        ( FOrderInterID ,
          FOrderEntryID ,
          FItemID
        )
        SELECT DISTINCT
                FOrderInterID ,
                FOrderEntryID ,
                FItemID
        FROM    ICStockBillEntry
        WHERE   FOrderInterID > 0
                AND FInterID = 1784
        ORDER BY FOrderInterID ,
                FOrderEntryID
IF @@ROWCOUNT > 0 
    BEGIN
        CREATE INDEX idx_#tmpPMCPOOrder ON #tmpPMCPOOrder(FOrderInterID,FOrderEntryID,FItemID)

        UPDATE  t1
        SET     t1.FPMCIndex = t2.FIndex
        FROM    #tmpPMCPOOrder t1
                INNER  JOIN ICPlan_PMCDetail t2 ON t2.fRelTrantype = 71
                                                   AND t2.FRelInterID = t1.FOrderInterID
                                                   AND t1.FOrderEntryID = t2.FRelEntryID
        CREATE INDEX idx_#tmpPMCPOOrder_FPMCIndex ON #tmpPMCPOOrder(FPMCIndex)
        UPDATE  u1
        SET     u1.FWillInQty = u2.FQty - u2.FStockQty
        FROM    ICPlan_PMCDetail u1
                INNER  JOIN POOrderEntry u2 ON U1.fRelTrantype = 71
                                               AND u1.FRelInterID = u2.FInterID
                                               AND u1.FRelEntryID = u2.FEntryID
        WHERE   EXISTS ( SELECT 1
                         FROM   #tmpPMCPOOrder
                         WHERE  FPMCIndex = u1.FIndex ) 

        CREATE TABLE #tmpPMCPODeliveryPlan
            (
              FWillInQty DECIMAL(23, 10) ,
              FReplyQty DECIMAL(23, 10) ,
              FReplyDate DATETIME ,
              FIndex INT ,
              FRelEntryID INT
            )
        INSERT  INTO #tmpPMCPODeliveryPlan
                ( FWillInQty ,
                  FReplyQty ,
                  FReplyDate ,
                  FIndex ,
                  FRelEntryID
                )
                SELECT  PMC.FWillInQty ,
                        DP.FReplyQty ,
                        DP.FReplyDate ,
                        DP.FIndex ,
                        PMC.FRelEntryID
                FROM    ICPlan_PMCDetail PMC
                        INNER JOIN #tmpPMCPOOrder u3 ON PMC.fRelTrantype = 71
                                                        AND PMC.FRelInterID = u3.FOrderInterID
                                                        AND PMC.FRelEntryID = u3.FOrderEntryID
                        INNER JOIN ICPlan_PMCPODeliveryPlan DP ON DP.FRelInterID = PMC.FRelInterID
                                                              AND DP.FRelEntryID = PMC.FRelEntryID
                                                              AND DP.FRelTranType = PMC.FRelTranType
                ORDER BY PMC.FRelEntryID ,
                        DP.FReplyDate DESC
        DECLARE @FReplyQty AS DECIMAL(23, 10)
        DECLARE @FRelEntryID AS INT
        SET @FReplyQty = 0
        SET @FRelEntryID = 0
        UPDATE  #tmpPMCPODeliveryPlan
        SET     @FReplyQty = CASE WHEN @FRelEntryID <> FRelEntryID
                                  THEN FWillInQty - FReplyQty
                                  ELSE @FReplyQty - FReplyQty
                             END ,
                FReplyQty = CASE WHEN FReplyDate = ( SELECT MIN(P.FReplyDate)
                                                     FROM   #tmpPMCPODeliveryPlan P
                                                     WHERE  P.FRelEntryID = FRelEntryID
                                                   )
                                 THEN FReplyQty + @FReplyQty
                                 WHEN @FReplyQty > 0 THEN FReplyQty
                                 ELSE FReplyQty + @FReplyQty
                            END ,
                @FRelEntryID = FRelEntryID
        DELETE  ICPlan_PMCPODeliveryPlan
        WHERE   FIndex IN ( SELECT DISTINCT
                                    FIndex
                            FROM    #tmpPMCPODeliveryPlan
                            WHERE   FReplyQty <= 0 )
        UPDATE  DP
        SET     DP.FReplyQty = TMP.FReplyQty
        FROM    #tmpPMCPODeliveryPlan TMP
                INNER JOIN ICPlan_PMCPODeliveryPlan DP ON TMP.FReplyQty > 0
                                                          AND TMP.FIndex = DP.FIndex
        DROP TABLE #tmpPMCPODeliveryPlan

        DELETE  u1
        FROM    ICPlan_PMCDetail u1
                INNER  JOIN POOrderEntry u2 ON U1.FRelTrantype = 71
                                               AND u1.FRelInterID = u2.FInterID
                                               AND u1.FRelEntryID = u2.FEntryID
        WHERE   u2.FQty <= u2.FStockQty
                AND EXISTS ( SELECT 1
                             FROM   #tmpPMCPOOrder
                             WHERE  FPMCIndex = u1.FIndex )

        INSERT  INTO ICPlan_PMCDetail
                ( FItemID ,
                  FUnitID ,
                  FNeedDate ,
                  FSrcTranType ,
                  FSrcInterID ,
                  FSrcEntryID ,
                  FRelTranType ,
                  FRelInterID ,
                  FRelEntryID ,
                  FParentTranType ,
                  FParentInterID ,
                  FParentEntryID ,
                  FNeedQty ,
                  FWillInQty ,
                  FBillType ,
                  FAuxPropID ,
                  FPlanCategory 
                )
                SELECT  v1.FItemID ,
                        v2.FUnitID ,
                        v1.FDate ,
                        0 ,
                        0 ,
                        0 ,
                        71 ,
                        v1.FInterID ,
                        v1.FEntryID ,
                        71 ,
                        v1.FInterID ,
                        v1.FEntryID ,
                        v1.FQty AS FNeedQty ,
                        ( CASE WHEN v1.FQty > v1.FStockQty
                               THEN v1.FQty - v1.FStockQty
                               ELSE 0
                          END ) FWillQty ,
                        5 AS FBillType ,
                        v1.FAuxPropID ,
                        v4.FPlanCategory
                FROM    POOrderEntry v1
                        INNER JOIN t_ICItemBase v2 ON v1.FItemID = v2.FItemID
                        INNER JOIN #tmpPMCPOOrder v3 ON v1.FInterID = v3.FOrderInterID
                                                        AND v1.FEntryID = v3.FOrderEntryID
                                                        AND v1.FItemID = v3.FItemID
                        INNER JOIN POOrder v4 ON v1.FInterID = v4.FInterID
                WHERE   v1.FQty > v1.FStockQty
                        AND NOT EXISTS ( SELECT 1
                                         FROM   ICPlan_PMCDetail WITH ( NOLOCK )
                                         WHERE  FRelTranType = 71
                                                AND FRelInterID = v1.FInterID
                                                AND FRelEntryID = v1.FEntryID )
    END

DROP TABLE #tmpPMCPOOrder 


UPDATE  p1
SET     p1.FMrpClosed = CASE WHEN ISNULL(p1.FMRPAutoClosed, 1) = 1
                             THEN ( CASE WHEN p1.FStockQty < p1.FQty THEN 0
                                         ELSE 1
                                    END )
                             ELSE p1.FMrpClosed
                        END
FROM    POOrderEntry p1
        INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID = p1.FInterID
                                          AND u1.FOrderEntryID = p1.FEntryID
WHERE   u1.FInterID = 1784

UPDATE  t
SET     t.FStatus = CASE WHEN ( SELECT  COUNT(1)
                                FROM    POOrderEntry
                                WHERE   ( FCommitQty > 0
                                          OR ( ISNULL(FMRPClosed, 0) = 1
                                               AND ISNULL(FMRPAutoClosed, 1) = 0
                                             )
                                        )
                                        AND FInterID IN ( 1171 )
                              ) = 0 THEN 1
                         WHEN ( SELECT  COUNT(1)
                                FROM    POOrderEntry te
                                WHERE   ( ISNULL(FMRPClosed, 0) = 1
                                          OR FCommitQty >= FQty
                                        )
                                        AND FInterID IN ( 1171 )
                              ) < ( SELECT  COUNT(1)
                                    FROM    POOrderEntry
                                    WHERE   FInterID IN ( 1171 )
                                  ) THEN 2
                         ELSE 3
                    END ,
        t.FClosed = CASE WHEN ( SELECT  COUNT(1)
                                FROM    POOrderEntry te
                                WHERE   ( FCommitQty >= FQty
                                          OR ( ISNULL(te.FMRPAutoClosed, 1) = 0
                                               AND ISNULL(FMRPClosed, 0) = 1
                                             )
                                        )
                                        AND te.FInterID IN ( 1171 )
                              ) = ( SELECT  COUNT(1)
                                    FROM    POOrderEntry te
                                    WHERE   te.FInterID IN ( 1171 )
                                  ) THEN 1
                         ELSE 0
                    END
FROM    POOrder t
WHERE   t.FInterID IN ( 1171 )

 --供应商协同
DELETE  FROM SRM_DistributeDataInfo
WHERE   FInterID = 1171
        AND FTableName = 'v_ic_Poorder71' 
INSERT  SRM_DistributeDataInfo
        ( FInterID, FTableName, FSynDataWay )
VALUES  ( 1171, 'v_ic_Poorder71', 1 ) 


UPDATE  p1
SET     p1.FCloseEntryUser = CASE WHEN ISNULL(p1.FMRPAutoClosed, 1) = 1
                                  THEN ( CASE WHEN p1.FMrpClosed = 1
                                              THEN 16394
                                              ELSE 0
                                         END )
                                  ELSE 0
                             END ,
        p1.FCloseEntryDate = CASE WHEN ISNULL(p1.FMRPAutoClosed, 1) = 1
                                  THEN ( CASE WHEN p1.FMrpClosed = 1
                                              THEN GETDATE()
                                              ELSE NULL
                                         END )
                                  ELSE NULL
                             END ,
        p1.FCloseEntryCauses = CASE WHEN ISNULL(p1.FMRPAutoClosed, 1) = 1
                                    THEN ( CASE WHEN p1.FMrpClosed = 1
                                                THEN '系统自动关闭'
                                                ELSE ''
                                           END )
                                    ELSE ''
                               END
FROM    POOrderEntry p1
        INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID = p1.FInterID
                                          AND u1.FOrderEntryID = p1.FEntryID
WHERE   u1.FInterID = 1784

 --供应商协同
DECLARE @TempOrder TABLE ( FInterID INT )
INSERT  INTO @TempOrder
        ( FInterID
        )
        SELECT DISTINCT
                t0.FInterID
        FROM    POOrder t0
                INNER JOIN ICStockBillEntry t1 ON t0.FInterID = t1.FOrderInterID
                                                  AND t1.FSourceTranType = 71
                INNER JOIN ICStockBill t2 ON t1.FInterID = t2.FInterID
                INNER JOIN t_Supplier t3 ON t0.FSupplyID = t3.FItemID
        WHERE   t0.FTranType = 71
                AND t0.FClassTypeID = 0
                AND ISNULL(t3.FSupplierCoroutineFlag, 0) = 1
                AND t2.FInterID = 1784
DELETE  t1
FROM    SRM_DistributeDataInfo t1
        INNER JOIN @TempOrder t2 ON t1.FInterID = t2.FInterID
WHERE   FTableName = 'v_IC_POOrder71'
INSERT  INTO SRM_DistributeDataInfo
        ( FInterID ,
          FTableName ,
          FSynDataWay
        )
        SELECT DISTINCT
                FInterID ,
                'v_IC_POOrder71' ,
                1
        FROM    @TempOrder
DELETE  @TempOrder
INSERT  INTO @TempOrder
        ( FInterID
        )
        SELECT DISTINCT
                t0.FInterID
        FROM    ICSubContract t0
                INNER JOIN ICStockBillEntry t1 ON t0.FInterID = t1.FOrderInterID
                                                  AND t1.FSourceTranType = 1007105
                INNER JOIN ICStockBill t2 ON t1.FInterID = t2.FInterID
                INNER JOIN t_Supplier t3 ON t0.FSupplyID = t3.FItemID
        WHERE   ISNULL(t3.FSupplierCoroutineFlag, 0) = 1
                AND t2.FInterID = 1784
DELETE  t1
FROM    SRM_DistributeDataInfo t1
        INNER JOIN @TempOrder t2 ON t1.FInterID = t2.FInterID
WHERE   FTableName = 'v_IC_SubContract1007105'
INSERT  INTO SRM_DistributeDataInfo
        ( FInterID ,
          FTableName ,
          FSynDataWay
        )
        SELECT DISTINCT
                FInterID ,
                'v_IC_SubContract1007105' ,
                1
        FROM    @TempOrder


SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 9

SELECT  FProperty ,
        *
FROM    t_stock


