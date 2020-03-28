SELECT  *
FROM    t_TableDescription
WHERE   ftablename LIKE '%poorder%'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 200005
ORDER BY FFieldName


DECLARE @p2 INT
SET @p2 = 1816
EXEC GetICMaxNum 'ICStockBill', @p2 OUTPUT, 1, 16394
SELECT  @p2

INSERT  INTO ICStockBillEntry
        ( FInterID ,
          FEntryID ,
          FBrNo ,
          FMapNumber ,
          FMapName ,
          FItemID ,
          FOLOrderBillNo ,
          FAuxPropID ,
          FBatchNo ,
          FQty ,
          FUnitID ,
          FAuxQtyMust ,
          Fauxqty ,
          FSecCoefficient ,
          FSecQty ,
          FAuxPlanPrice ,
          FPlanAmount ,
          Fauxprice ,
          Famount ,
          Fnote ,
          FKFDate ,
          FKFPeriod ,
          FPeriodDate ,
          FIsVMI ,
          FEntrySupply ,
          FDCStockID ,
          FDCSPID ,
          FConsignPrice ,
          FDiscountRate ,
          FConsignAmount ,
          FDiscountAmount ,
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
          FCurrentHookQTY ,
          FQtyMust ,
          FSepcialSaleId ,
          FPlanMode ,
          FMTONo ,
          FClientOrderNo ,
          FConfirmMemEntry ,
          FClientEntryID ,
          FChkPassItem ,
          FSEOutBillNo ,
          FSEOutEntryID ,
          FSEOutInterID ,
          FReturnNoticeBillNo ,
          FReturnNoticeEntryID ,
          FReturnNoticeInterID ,
          FProductFileQty ,
          FPostFee ,
          FOutSourceInterID ,
          FOutSourceEntryID ,
          FOutSourceTranType ,
          FShopName
        )
        SELECT  1816 ,
                1 ,
                '0' ,
                '' ,
                '' ,
                41002 ,
                '' ,
                0 ,
                '' ,
                2 ,
                39239 ,
                2 ,
                2 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                '' ,
                NULL ,
                0 ,
                NULL ,
                0 ,
                0 ,
                42954 ,
                0 ,
                .47 ,
                0 ,
                .94 ,
                0 ,
                0 ,
                0 ,
                'SEORD000086' ,
                81 ,
                1150 ,
                1 ,
                '' ,
                0 ,
                0 ,
                'SEORD000086' ,
                1150 ,
                1 ,
                0 ,
                0 ,
                2 ,
                0 ,
                14036 ,
                '' ,
                '' ,
                '' ,
                '0' ,
                1058 ,
                '' ,
                0 ,
                0 ,
                '' ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                ''

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
          FSaleStyle ,
          FConfirmDate ,
          FCheckDate ,
          FFManagerID ,
          FSManagerID ,
          FBillerID ,
          FConfirmer ,
          FMultiCheckDate1 ,
          FMultiCheckDate2 ,
          FMultiCheckDate3 ,
          FMultiCheckDate4 ,
          FMultiCheckDate5 ,
          FPOOrdBillNo ,
          FMultiCheckDate6 ,
          FRelateBrID ,
          FOrgBillInterID ,
          FMarketingStyle ,
          FPrintCount ,
          FSelTranType ,
          FBrID ,
          FFetchAdd ,
          FExplanation ,
          FConfirmMem ,
          FDeptID ,
          FEmpID ,
          FManagerID ,
          FVIPCardID ,
          FVIPScore ,
          FReceiver ,
          FHolisticDiscountRate ,
          FPOSName ,
          FWorkShiftId ,
          FLSSrcInterID ,
          FManageType ,
          FPayCondition ,
          FSettleDate ,
          FConsignee ,
          FInvoiceStatus ,
          FReceiveMan ,
          FConsigneeAdd ,
          FCod ,
          FReceiverMobile ,
          FEnterpriseID ,
          FSendStatus
        )
        SELECT  1816 ,
                'XOUT000003' ,
                '0' ,
                21 ,
                0 ,
                0 ,
                0 ,
                1 ,
                0 ,
                '2018-05-07' ,
                42797 ,
                101 ,
                NULL ,
                NULL ,
                42842 ,
                42842 ,
                16394 ,
                0 ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                '' ,
                NULL ,
                0 ,
                0 ,
                12530 ,
                0 ,
                81 ,
                0 ,
                '' ,
                '' ,
                '' ,
                35633 ,
                42842 ,
                0 ,
                0 ,
                0 ,
                '' ,
                0 ,
                '' ,
                0 ,
                0 ,
                0 ,
                0 ,
                '2018-05-07' ,
                0 ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                0 ,
                0

UPDATE  ICStockBill
SET     FUUID = NEWID()
WHERE   FInterID = 1816


  --更新销售订单：发货数量，辅助发货数量                                                                                                                                                                                                                                                         
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(src.fcommitqty, 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fqty ,
        @maxorder = ( SELECT    fvalue
                      FROM      t_systemprofile
                      WHERE     fcategory = 'ic'
                                AND fkey = 'cqtylargerseqty'
                    ) ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( ABS(src.fqty) > ABS(@fsrccommitfield_prevalue)
                                            OR ABS(src.fqty) > ABS(@fsrccommitfield_endvalue)
                                          ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fcommitqty = @fsrccommitfield_endvalue ,
        src.fauxcommitqty = @fsrccommitfield_endvalue
        / CAST(t1.fcoefficient AS FLOAT)
FROM    seorderentry src
        INNER JOIN seorder srchead ON src.finterid = srchead.finterid
        INNER JOIN ( SELECT u1.fsourceinterid AS fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid ,
                            SUM(u1.fqty) AS fqty
                     FROM   icstockbillentry u1
                     WHERE  u1.finterid = 1816
                     GROUP BY u1.fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.finterid
                             AND dest.fitemid = src.fitemid
                             AND src.fentryid = dest.fsourceentryid
        INNER JOIN t_measureunit t1 ON src.funitid = t1.fitemid
IF ( ISNULL(@fcheck_fail, 0) = -1 ) 
    RAISERROR('可能的原因是：
 1、所选单据已被其他单据关联
 2、所选单据已被反审核
 3、当前单据和所选单据的关联数量超过了所选单据的数量
 4、所选单据已经关闭',18,18)
ELSE 
    IF EXISTS ( SELECT  1
                FROM    seorder src
                        RIGHT JOIN ( SELECT u1.fsourceinterid AS fsourceinterid ,
                                            u1.fsourceentryid ,
                                            u1.fitemid ,
                                            SUM(u1.fqty) AS fqty
                                     FROM   icstockbillentry u1
                                     WHERE  u1.finterid = 1816
                                     GROUP BY u1.fsourceinterid ,
                                            u1.fsourceentryid ,
                                            u1.fitemid
                                   ) dest ON dest.fsourceinterid = src.finterid
                WHERE   dest.fsourceinterid > 0
                        AND src.finterid IS NULL ) 
        RAISERROR('所选单据已被删除',18,18)

--更新销售订单：审核状态、关闭状态
UPDATE  t
SET     t.FStatus = CASE WHEN ( SELECT  COUNT(1)
                                FROM    SEOrderEntry
                                WHERE   ( FCommitQty > 0
                                          OR ( ISNULL(FMRPClosed, 0) = 1
                                               AND ISNULL(FMRPAutoClosed, 1) = 0
                                             )
                                        )
                                        AND FInterID IN ( 1150 )
                              ) = 0 THEN 1
                         WHEN ( SELECT  COUNT(1)
                                FROM    SEOrderEntry te
                                WHERE   ( ISNULL(FMRPClosed, 0) = 1
                                          OR FCommitQty >= FQty
                                        )
                                        AND FInterID IN ( 1150 )
                              ) < ( SELECT  COUNT(1)
                                    FROM    SEOrderEntry
                                    WHERE   FInterID IN ( 1150 )
                                  ) THEN 2
                         ELSE 3
                    END ,
        t.FClosed = CASE WHEN ( SELECT  COUNT(1)
                                FROM    SEOrderEntry te
                                WHERE   ( FCommitQty >= FQty
                                          OR ( ISNULL(te.FMRPAutoClosed, 1) = 0
                                               AND ISNULL(FMRPClosed, 0) = 1
                                             )
                                        )
                                        AND te.FInterID IN ( 1150 )
                              ) = ( SELECT  COUNT(1)
                                    FROM    SEOrderEntry te
                                    WHERE   te.FInterID IN ( 1150 )
                                  ) THEN 1
                         ELSE 0
                    END
FROM    SEOrder t
WHERE   t.FInterID IN ( 1150 )

--更新销售订单：辅助执行数量
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(src.fseccommitqty, 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fsecqty ,
        @maxorder = ( SELECT    fvalue
                      FROM      t_systemprofile
                      WHERE     fcategory = 'ic'
                                AND fkey = 'cqtylargerseqty'
                    ) ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fseccommitqty = @fsrccommitfield_endvalue
FROM    seorderentry src
        INNER JOIN seorder srchead ON src.finterid = srchead.finterid
        INNER JOIN ( SELECT u1.fsourceinterid AS fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid ,
                            SUM(u1.fsecqty) AS fsecqty
                     FROM   icstockbillentry u1
                     WHERE  u1.finterid = 1816
                     GROUP BY u1.fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.finterid
                             AND dest.fitemid = src.fitemid
                             AND src.fentryid = dest.fsourceentryid


IF EXISTS ( SELECT  1
            FROM    ICBillRelations_Sale
            WHERE   FBillType = 21
                    AND FBillID = 1816 ) 
    BEGIN
        UPDATE  t1
        SET     t1.FChildren = t1.FChildren + 1
        FROM    SEOrder t1
                INNER JOIN SEOrderEntry t2 ON t1.FInterID = t2.FInterID
                INNER JOIN ICBillRelations_Sale t3 ON t3.FMultiEntryID = t2.FEntryID
                                                      AND t3.FMultiInterID = t2.FInterID
        WHERE   t3.FBillType = 21
                AND t3.FBillID = 1816
    END
ELSE 
    BEGIN
        UPDATE  t3
        SET     t3.FChildren = t3.FChildren + 1
        FROM    ICStockBill t1
                INNER JOIN ICStockBillEntry t2 ON t1.FInterID = t2.FInterID
                INNER JOIN SEOrder t3 ON t3.FTranType = t2.FSourceTranType
                                         AND t3.FInterID = t2.FSourceInterID
        WHERE   t1.FTranType = 21
                AND t1.FInterID = 1816
                AND t2.FSourceInterID > 0
    END

--出运商品明细
UPDATE  t1
SET     FcmtQty_O = FcmtQty_O
FROM    ExpOutReqEntry t1
        INNER JOIN ( SELECT SUM(t1.FQty) FQty ,
                            t3.fdetailid
                     FROM   ICStockBillEntry t1
                            INNER JOIN ExpOutReqEntry t2 ON t2.fdetailid = t1.fsourceEntryid
                            INNER JOIN ExpOutReqEntry t3 ON t3.fdetailid = t2.fentryid_src
                     WHERE  fsourceinterid > 0
                            AND fsourcebillno <> ''
                            AND fsourcetrantype = 1007131
                            AND t1.finterid = 1816
                     GROUP BY t3.fdetailid
                   ) t2 ON t1.fdetailid = t2.fdetailid


UPDATE  ICStockBill
SET     FVIPScore = ABS(FVIPScore) * ( -1 )
WHERE   FROB = -1
        AND FInterID = 1816

UPDATE  RTL_VIP
SET     FVIPScore = FVIPScore + 0
WHERE   FID = 0

--更新销售出库单：提交数量，辅助提交数量
UPDATE  A
SET     A.FCommitQty = A.FCommitQty - D.FQty ,
        A.FAuxCommitQty = A.FAuxCommitQty - ( D.FQty / T.FCoefficient ) ,
        A.FSecCommitQty = A.FSecCommitQty - D.FSecQty
FROM    ICStockBillEntry A
        INNER JOIN ICWebReturnEntry B ON B.FID_SRC = A.FInterID
                                         AND B.FEntryID_SRC = A.FDetailID
                                         AND B.FClassID_SRC = 1007572
        INNER JOIN SEOutStockEntry C ON C.FSourceInterId = B.FID
                                        AND C.FSourceEntryID = B.FEntryID
        INNER JOIN ICStockBillEntry D ON D.FSourceInterId = C.FInterID
                                         AND D.FSourceEntryID = C.FEntryID
                                         AND D.FSourceTranType = 82
        LEFT JOIN t_MeasureUnit T ON A.FUnitID = T.FMeasureUnitID
WHERE   D.FInterID = 1816


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
                21 AS FTranType ,
                u1.FItemID ,
                ISNULL(u1.FBatchNo, '') AS FBatchNo ,
                ISNULL(u1.FMTONo, '') AS FMTONo ,
                u1.FAuxPropID ,
                ISNULL(u1.FDCStockID, 0) AS FDCStockID ,
                ISNULL(u1.FDCSPID, 0) AS FDCSPID ,
                ISNULL(u1.FKFPeriod, 0) AS FKFPeriod ,
                LEFT(ISNULL(CONVERT(VARCHAR(20), u1.FKFdate, 120), ''), 10) AS FKFDate ,
                FEntrySupply ,
                -1 * u1.FQty AS FQty ,
                -1 * u1.FSecQty AS FSecQty ,
                -1 * u1.FAmount
        FROM    ICStockBillEntry u1
        WHERE   u1.FInterID = 1816
        ORDER BY u1.FEntryID

SELECT  *
INTO    #TempBill2
FROM    #TempBill 
UPDATE  t1
SET     t1.FQty = t1.FQty + ( u1.FQty ) ,
        t1.FSecQty = t1.FSecQty + ( u1.FSecQty )
FROM    ICInventory t1
        INNER JOIN ( SELECT FItemID ,
                            FBatchNo ,
                            FMTONo ,
                            FAuxPropID ,
                            FStockID ,
                            FStockPlaceID ,
                            FKFPeriod ,
                            FKFDate ,
                            FSupplyID ,
                            SUM(FQty) AS FQty ,
                            SUM(FSecQty) AS FSecQty
                     FROM   #TempBill2
                     GROUP BY FItemID ,
                            FBatchNo ,
                            FMTONo ,
                            FAuxPropID ,
                            FStockID ,
                            FStockPlaceID ,
                            FKFPeriod ,
                            FKFDate ,
                            FSupplyID
                   ) u1 ON t1.FItemID = u1.FItemID
                           AND t1.FBatchNo = u1.FBatchNo
                           AND t1.FMTONo = u1.FMTONo
                           AND t1.FAuxPropID = u1.FAuxPropID
                           AND t1.FStockID = u1.FStockID
                           AND t1.FStockPlaceID = u1.FStockPlaceID
                           AND t1.FKFPeriod = u1.FKFPeriod
                           AND t1.FKFDate = u1.FKFDate
                           AND t1.FSupplyID = u1.FSupplyID

DELETE  u1
FROM    ICInventory t1
        INNER JOIN #TempBill2 u1 ON t1.FItemID = u1.FItemID
                                    AND t1.FBatchNo = u1.FBatchNo
                                    AND t1.FMTONo = u1.FMTONo
                                    AND t1.FAuxPropID = u1.FAuxPropID
                                    AND t1.FStockID = u1.FStockID
                                    AND t1.FStockPlaceID = u1.FStockPlaceID
                                    AND t1.FKFPeriod = u1.FKFPeriod
                                    AND t1.FKFDate = u1.FKFDate
                                    AND t1.FSupplyID = u1.FSupplyID

INSERT  INTO ICInventory
        ( FBrNo ,
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
          FSecQty
        )
        SELECT  '' ,
                FItemID ,
                FBatchNo ,
                FMTONo ,
                FAuxPropID ,
                FStockID ,
                FStockPlaceID ,
                FKFPeriod ,
                FKFDate ,
                FSupplyID ,
                SUM(FQty) AS FQty ,
                SUM(FSecQty) AS FSecQty
        FROM    #TempBill2
        GROUP BY FItemID ,
                FBatchNo ,
                FMTONo ,
                FAuxPropID ,
                FStockID ,
                FStockPlaceID ,
                FKFPeriod ,
                FKFDate ,
                FSupplyID


DROP TABLE #TempBill2


UPDATE  P1
SET     P1.FLockFlag = ( CASE WHEN ISNULL(t1.FQty, 0) <= 0 THEN 0
                              ELSE 1
                         END )
FROM    SEOrderEntry P1
        INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID = P1.FInterID
                                          AND u1.FOrderEntryID = P1.FEntryID
                                          AND u1.FItemID = P1.FItemID
        INNER JOIN ( SELECT FInterID ,
                            FEntryID ,
                            SUM(FQty) AS FQty
                     FROM   t_LockStock
                     WHERE  FTranType = 81
                     GROUP BY FInterID ,
                            FEntryID
                   ) t1 ON P1.FInterID = t1.FInterID
                           AND P1.FEntryID = t1.FEntryID
WHERE   u1.FInterID = 1816

DROP TABLE #TempBill

UPDATE  ICStockBill
SET     FOrderAffirm = 0
WHERE   FInterID = 1816

UPDATE  ICStockBill
SET     FCheckerID = 16394 ,
        FStatus = 1 ,
        FCheckDate = '2018-05-07'
WHERE   FInterID = 1816

IF EXISTS ( SELECT  FOrderInterID
            FROM    ICStockBillEntry
            WHERE   FOrderInterID > 0
                    AND FInterID = 1816 ) 
    BEGIN 
        UPDATE  u1
        SET     u1.FStockQty = u1.FStockQty + 1 * CAST(u2.FStockQty AS FLOAT) ,
                u1.FSecStockQty = u1.FSecStockQty + 1
                * CAST(u2.FSecStockQty AS FLOAT) ,
                u1.FAuxStockQty = ROUND(( u1.FStockQty + 1
                                          * CAST(u2.FStockQty AS FLOAT) )
                                        / CAST(t3.FCoefficient AS FLOAT),
                                        t1.FQtyDecimal)
        FROM    SEOrderEntry u1
                INNER JOIN ( SELECT FOrderInterID ,
                                    FOrderEntryID ,
                                    FItemID ,
                                    SUM(FQty) AS FStockQty ,
                                    SUM(FAuxQty) AS FAuxStockQty ,
                                    SUM(FSecQty) AS FSecStockQty
                             FROM   ICStockBillEntry
                             WHERE  FInterID = 1816
                             GROUP BY FOrderInterID ,
                                    FOrderEntryID ,
                                    FItemID
                           ) u2 ON u1.FInterID = u2.FOrderInterID
                                   AND u1.FEntryID = u2.FOrderEntryID
                                   AND u1.FItemID = u2.FItemID
                INNER JOIN t_ICItemBase t1 ON u1.FItemID = t1.FItemID
                INNER JOIN t_MeasureUnit t3 ON u1.FUnitID = t3.FItemID
 
 --供给汇总数据
        IF OBJECT_ID('tempdb..#tmpPMCIndex', 'U') IS NOT NULL 
            DROP TABLE #tmpPMCIndex
        SELECT  u0.FIndex
        INTO    #tmpPMCIndex
        FROM    ICPlan_PMCdetail u0
                INNER JOIN SEOrderEntry u1 ON u0.FRelTranType = 81
                                              AND u0.FRelInterID = u1.FInterID
                                              AND u0.FRelEntryID = u1.FEntryID
                                              AND u0.FBillType IN ( 22, 25 )
                INNER JOIN ( SELECT DISTINCT
                                    FOrderInterID ,
                                    FOrderEntryID ,
                                    FItemID
                             FROM   ICStockBillEntry
                             WHERE  FOrderInterID > 0
                                    AND FInterID = 1816
                           ) u2 ON u1.FInterID = u2.FOrderInterID
                                   AND u1.FEntryID = u2.FOrderEntryID
                                   AND u1.FItemID = u2.FItemID 
        CREATE CLUSTERED INDEX PK_#tmpPMCIndex ON #tmpPMCIndex(FIndex) 
 
        UPDATE  u0
        SET     u0.FWillOutQty = CASE WHEN u1.FQty > u1.FStockQty
                                      THEN u1.FQty - u1.FStockQty
                                      ELSE 0
                                 END
        FROM    ICPlan_PMCdetail u0
                INNER JOIN SEOrderEntry u1 ON u0.FRelTranType = 81
                                              AND u0.FRelInterID = u1.FInterID
                                              AND u0.FRelEntryID = u1.FEntryID
                                              AND u0.FBillType IN ( 22, 25 )
        WHERE   EXISTS ( SELECT 1
                         FROM   #tmpPMCIndex
                         WHERE  FIndex = u0.FIndex )
        DROP TABLE #tmpPMCIndex
 
    END 

--更新销售订单
IF EXISTS ( SELECT  FOrderInterID
            FROM    ICStockBillEntry
            WHERE   FOrderInterID > 0
                    AND FInterID = 1816 ) 
    BEGIN 
        UPDATE  u1
        SET     u1.FStockQty = u1.FStockQty + 1 * CAST(u2.FStockQty AS FLOAT) ,
                u1.FSecStockQty = u1.FSecStockQty + 1
                * CAST(u2.FSecStockQty AS FLOAT) ,
                u1.FAuxStockQty = ROUND(( u1.FStockQty + 1
                                          * CAST(u2.FStockQty AS FLOAT) )
                                        / CAST(t3.FCoefficient AS FLOAT),
                                        t1.FQtyDecimal)
        FROM    SEOrderEntry u1
                INNER JOIN ( SELECT FOrderInterID ,
                                    FOrderEntryID ,
                                    FItemID ,
                                    SUM(FQty) AS FStockQty ,
                                    SUM(FAuxQty) AS FAuxStockQty ,
                                    SUM(FSecQty) AS FSecStockQty
                             FROM   ICStockBillEntry
                             WHERE  FInterID = 1816
                             GROUP BY FOrderInterID ,
                                    FOrderEntryID ,
                                    FItemID
                           ) u2 ON u1.FInterID = u2.FOrderInterID
                                   AND u1.FEntryID = u2.FOrderEntryID
                                   AND u1.FItemID = u2.FItemID
                INNER JOIN t_ICItemBase t1 ON u1.FItemID = t1.FItemID
                INNER JOIN t_MeasureUnit t3 ON u1.FUnitID = t3.FItemID
 
        IF OBJECT_ID('tempdb..#tmpPMCIndex', 'U') IS NOT NULL 
            DROP TABLE #tmpPMCIndex
        SELECT  u0.FIndex
        INTO    #tmpPMCIndex
        FROM    ICPlan_PMCdetail u0
                INNER JOIN SEOrderEntry u1 ON u0.FRelTranType = 81
                                              AND u0.FRelInterID = u1.FInterID
                                              AND u0.FRelEntryID = u1.FEntryID
                                              AND u0.FBillType IN ( 22, 25 )
                INNER JOIN ( SELECT DISTINCT
                                    FOrderInterID ,
                                    FOrderEntryID ,
                                    FItemID
                             FROM   ICStockBillEntry
                             WHERE  FOrderInterID > 0
                                    AND FInterID = 1816
                           ) u2 ON u1.FInterID = u2.FOrderInterID
                                   AND u1.FEntryID = u2.FOrderEntryID
                                   AND u1.FItemID = u2.FItemID 
        CREATE CLUSTERED INDEX PK_#tmpPMCIndex ON #tmpPMCIndex(FIndex) 
 
        UPDATE  u0
        SET     u0.FWillOutQty = CASE WHEN u1.FQty > u1.FStockQty
                                      THEN u1.FQty - u1.FStockQty
                                      ELSE 0
                                 END
        FROM    ICPlan_PMCdetail u0
                INNER JOIN SEOrderEntry u1 ON u0.FRelTranType = 81
                                              AND u0.FRelInterID = u1.FInterID
                                              AND u0.FRelEntryID = u1.FEntryID
                                              AND u0.FBillType IN ( 22, 25 )
        WHERE   EXISTS ( SELECT 1
                         FROM   #tmpPMCIndex
                         WHERE  FIndex = u0.FIndex )
        DROP TABLE #tmpPMCIndex
 
    END 


UPDATE  p1
SET     p1.FMrpClosed = CASE WHEN ISNULL(p1.FMRPAutoClosed, 1) = 1
                             THEN ( CASE WHEN p1.FStockQty < p1.FQty THEN 0
                                         ELSE 1
                                    END )
                             ELSE p1.FMrpClosed
                        END
FROM    SEOrderEntry p1
        INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID = p1.FInterID
                                          AND u1.FOrderEntryID = p1.FEntryID
WHERE   u1.FInterID = 1816
UPDATE  t
SET     t.FStatus = CASE WHEN ( SELECT  COUNT(1)
                                FROM    SEOrderEntry
                                WHERE   ( FCommitQty > 0
                                          OR ( ISNULL(FMRPClosed, 0) = 1
                                               AND ISNULL(FMRPAutoClosed, 1) = 0
                                             )
                                        )
                                        AND FInterID IN ( 1150 )
                              ) = 0 THEN 1
                         WHEN ( SELECT  COUNT(1)
                                FROM    SEOrderEntry te
                                WHERE   ( ISNULL(FMRPClosed, 0) = 1
                                          OR FCommitQty >= FQty
                                        )
                                        AND FInterID IN ( 1150 )
                              ) < ( SELECT  COUNT(1)
                                    FROM    SEOrderEntry
                                    WHERE   FInterID IN ( 1150 )
                                  ) THEN 2
                         ELSE 3
                    END ,
        t.FClosed = CASE WHEN ( SELECT  COUNT(1)
                                FROM    SEOrderEntry te
                                WHERE   ( FCommitQty >= FQty
                                          OR ( ISNULL(te.FMRPAutoClosed, 1) = 0
                                               AND ISNULL(FMRPClosed, 0) = 1
                                             )
                                        )
                                        AND te.FInterID IN ( 1150 )
                              ) = ( SELECT  COUNT(1)
                                    FROM    SEOrderEntry te
                                    WHERE   te.FInterID IN ( 1150 )
                                  ) THEN 1
                         ELSE 0
                    END
FROM    SEOrder t
WHERE   t.FInterID IN ( 1150 )


IF EXISTS ( SELECT  FOrderInterID
            FROM    ICStockBillEntry
            WHERE   FSEOutInterID > 0
                    AND FInterID = 1816 ) 
    UPDATE  u1
    SET     u1.FStockQty = u1.FStockQty + 1 * CAST(u2.FStockQty AS FLOAT) ,
            u1.FSecStockQty = u1.FSecStockQty + 1
            * CAST(u2.FSecStockQty AS FLOAT) ,
            u1.FAuxStockQty = ROUND(( u1.FStockQty + 1
                                      * CAST(u2.FStockQty AS FLOAT) )
                                    / CAST(t3.FCoefficient AS FLOAT),
                                    t1.FQtyDecimal)
    FROM    SEOutStockEntry u1
            INNER JOIN ( SELECT FSEOutInterID ,
                                FSEOutEntryID ,
                                FItemID ,
                                SUM(FQty) AS FStockQty ,
                                SUM(FAuxQty) AS FAuxStockQty ,
                                SUM(FSecQty) AS FSecStockQty
                         FROM   ICStockBillEntry
                         WHERE  FInterID = 1816
                         GROUP BY FSEOutInterID ,
                                FSEOutEntryID ,
                                FItemID
                       ) u2 ON u1.FInterID = u2.FSEOutInterID
                               AND u1.FEntryID = u2.FSEOutEntryID
                               AND u1.FItemID = u2.FItemID
            INNER JOIN t_ICItemBase t1 ON u1.FItemID = t1.FItemID
            INNER JOIN t_MeasureUnit t3 ON u1.FUnitID = t3.FItemID


