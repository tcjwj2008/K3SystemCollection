SELECT  *
FROM    t_TableDescription
WHERE   FTableName = 'seorder'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 230004
ORDER BY FFieldName
SELECT  *
FROM    t_TableDescription
WHERE   FTableName = 'ICPrcPlyEntry'

--spk3_2tab @sname='ICPrcPlyEntry'

SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 230005
ORDER BY FFieldName
DECLARE @p2 INT
SET @p2 = 1219
EXEC GetICMaxNum 'SEOrder', @p2 OUTPUT, 1, 16394
SELECT  @p2

INSERT  INTO SEOrderEntry
        ( FInterID ,
          FEntryID ,
          FBrNo ,
          FMapNumber ,
          FMapName ,
          FItemID ,
          FAuxPropID ,
          FQty ,
          FUnitID ,
          Fauxqty ,
          FSecCoefficient ,
          FSecQty ,
          Fauxprice ,
          FAuxTaxPrice ,
          Famount ,
          FCess ,
          FTaxRate ,
          FUniDiscount ,
          FTaxAmount ,
          FAuxPriceDiscount ,
          FTaxAmt ,
          FAllAmount ,
          FTranLeadTime ,
          FInForecast ,
          FDate ,
          Fnote ,
          FPlanMode ,
          FMTONo ,
          FBOMCategory ,
          FBomInterID ,
          FOrderBOMStatus ,
          FCostObjectID ,
          FAdviceConsignDate ,
          FATPDeduct ,
          FLockFlag ,
          FSourceBillNo ,
          FSourceTranType ,
          FSourceInterId ,
          FSourceEntryID ,
          FContractBillNo ,
          FContractInterID ,
          FContractEntryID ,
          FSecCommitInstall ,
          FCommitInstall ,
          FAuxCommitInstall ,
          FAllStdAmount ,
          FMrpLockFlag ,
          FHaveMrp ,
          FReceiveAmountFor_Commit ,
          FOrderBOMInterID ,
          FOrderBillNo ,
          FOrderEntryID ,
          FOutSourceInterID ,
          FOutSourceEntryID ,
          FOutSourceTranType
        )
        SELECT  1219 ,
                1 ,
                '0' ,
                '' ,
                '' ,
                1688 ,
                0 ,
                1 ,
                186 ,
                1 ,
                0 ,
                0 ,
                1 ,
                1.17 ,
                1 ,
                17 ,
                0 ,
                0 ,
                0 ,
                1.17 ,
                .17 ,
                1.17 ,
                '' ,
                0 ,
                '2018-04-11' ,
                '' ,
                14036 ,
                '' ,
                0 ,
                0 ,
                0 ,
                '0' ,
                '2018-04-11' ,
                0 ,
                0 ,
                '' ,
                0 ,
                0 ,
                0 ,
                '' ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                1.17 ,
                0 ,
                0 ,
                0 ,
                0 ,
                '' ,
                '' ,
                0 ,
                0 ,
                0 

EXEC p_UpdateBillRelateData 81, 1219, 'SEOrder', 'SEOrderEntry' 

INSERT  INTO SEOrder
        ( FInterID ,
          FBillNo ,
          FBrNo ,
          FTranType ,
          FCancellation ,
          FStatus ,
          FDiscountType ,
          Fdate ,
          FCustAddress ,
          FSaleStyle ,
          FFetchStyle ,
          FCurrencyID ,
          FCustID ,
          FFetchAdd ,
          FCheckDate ,
          FMangerID ,
          FDeptID ,
          FEmpID ,
          FBillerID ,
          FSettleID ,
          FExchangeRateType ,
          FExchangeRate ,
          FMultiCheckLevel1 ,
          FMultiCheckDate1 ,
          FMultiCheckLevel2 ,
          FMultiCheckDate2 ,
          FMultiCheckLevel3 ,
          FMultiCheckDate3 ,
          FMultiCheckLevel4 ,
          FMultiCheckDate4 ,
          FMultiCheckLevel5 ,
          FMultiCheckDate5 ,
          FMultiCheckLevel6 ,
          FMultiCheckDate6 ,
          FPOOrdBillNo ,
          FRelateBrID ,
          FTransitAheadTime ,
          FImport ,
          FSelTranType ,
          FBrID ,
          FSettleDate ,
          FExplanation ,
          FAreaPS ,
          FManageType ,
          FSysStatus ,
          FValidaterName ,
          FConsignee ,
          FVersionNo ,
          FChangeDate ,
          FChangeUser ,
          FChangeCauses ,
          FChangeMark ,
          FPrintCount ,
          FPlanCategory ,
          FEnterpriseID ,
          FSendStatus
        )
        SELECT  1219 ,
                'SEORD000086' ,
                '0' ,
                81 ,
                0 ,
                0 ,
                0 ,
                '2018-04-11' ,
                0 ,
                101 ,
                '' ,
                1 ,
                2656 ,
                '' ,
                NULL ,
                0 ,
                237 ,
                263 ,
                16394 ,
                0 ,
                1 ,
                1 ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                '' ,
                0 ,
                '0' ,
                0 ,
                1000019 ,
                0 ,
                '2018-04-11' ,
                '' ,
                20302 ,
                0 ,
                0 ,
                '' ,
                0 ,
                '000' ,
                NULL ,
                0 ,
                '' ,
                '' ,
                0 ,
                '1' ,
                0 ,
                0

UPDATE  SEOrder
SET     FSysStatus = 2
WHERE   FInterID = 1219

UPDATE  SEOrder
SET     FUUID = NEWID()
WHERE   FInterID = 1219

 --成本对象
SET NOCOUNT ON
SELECT  v1.FBillNo ,
        u1.FCostObjectID
INTO    #OldCostObject
FROM    SEOrder v1
        INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID
WHERE   v1.FInterID = 1219
SELECT  v1.FBillNo ,
        u1.FCostObjectID
INTO    #NewCostObject
FROM    SEOrder v1
        INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID
WHERE   v1.FInterID = 1219
        AND u1.FCostObjectID > 0
UPDATE  t1
SET     FSBillNo = ''
FROM    CBCostobj t1
        INNER JOIN #OldCostObject t2 ON t1.FSBillNo = t2.FBillNo 
UPDATE  t1
SET     FSBillNo = t2.FBillNo
FROM    CBCostobj t1
        INNER JOIN #NewCostObject t2 ON t2.FCostObjectID = t1.FItemID 
DROP TABLE #OldCostObject
DROP TABLE #NewCostObject

--辅助属性
UPDATE  obc
SET     obc.FItemPropID = oo.FAuxPropID
FROM    PPOrderEntry oo
        INNER JOIN ICOrderBOMChild obc ON oo.FInterID = 1219
                                          AND oo.FOrderBOMInterID = obc.FInterID
                                          AND obc.FParentID = 0
UPDATE  obc
SET     obc.FItemPropID = oo.FAuxPropID
FROM    PPOrderEntry oo
        INNER JOIN ICOrderBOM obc ON oo.FInterID = 1219
                                     AND oo.FOrderBOMInterID = obc.FInterID
UPDATE  obc
SET     obc.FItemPropID = oo.FAuxPropID
FROM    SEOrderEntry oo
        INNER JOIN ICOrderBOMChild obc ON oo.FInterID = 1219
                                          AND oo.FOrderBOMInterID = obc.FInterID
                                          AND obc.FParentID = 0
UPDATE  obc
SET     obc.FItemPropID = oo.FAuxPropID
FROM    SEOrderEntry oo
        INNER JOIN ICOrderBOM obc ON oo.FInterID = 1219
                                     AND oo.FOrderBOMInterID = obc.FInterID

--网上订货单
UPDATE  v1
SET     v1.FExecStatus = 1
FROM    ICCustNetOrder v1
        INNER JOIN SEOrderEntry u2 ON v1.FID = u2.FSourceInterID
                                      AND u2.FSourceTranType = 1007553
                                      AND u2.FInterID = 1219

--价格政策
CREATE TABLE #tmpPrcPly
    (
      FRowNo INT ,
      FItemID INT ,
      FAuxPropID INT ,
      FUnitID INT ,
      FCuryID INT ,
      FDisType INT ,
      FPrice DECIMAL(28, 10) NOT NULL
                             DEFAULT 0 ,
      FAppScale INT ,
      FQty DECIMAL(28, 10) ,
      FBaseQty DECIMAL(28, 10) ,
      FDiscount DECIMAL(28, 10) NOT NULL
                                DEFAULT 0 ,
      FPrcInterID INT ,
      FPrcEntryID INT ,
      FDisInterID INT ,
      FDisEntryID INT ,
      FMainterID INT ,
      FMaintDate DATETIME ,
      FCheckerID INT ,
      FCheckDate DATETIME
    )

INSERT  INTO #tmpPrcPly
        ( FRowNo ,
          FItemID ,
          FAuxPropId ,
          FUnitID ,
          FCuryID ,
          FDisType ,
          FPrice ,
          FAppScale ,
          FQty ,
          FBaseQty ,
          FDisCount ,
          FPrcInterID ,
          FPrcEntryID ,
          FDisInterID ,
          FDisEntryID ,
          FMainterID ,
          FMaintDate ,
          FCheckerID ,
          FCheckDate
        )
VALUES  ( 1 ,
          1688 ,
          0 ,
          186 ,
          1 ,
          0 ,
          1.17 ,
          0 ,
          1 ,
          1 ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          16394 ,
          CONVERT(VARCHAR(10), GETDATE(), 120) ,
          NULL ,
          NULL
        )

UPDATE  t1
SET     FUnitID = ISNULL(t2.FUnitID, 0) ,
        FPrice = ISNULL(FPrice / tm.FCoefficient, 0)
FROM    #tmpPrcPly t1
        LEFT JOIN t_ICItem t2 ON t1.FItemID = t2.FItemID
        LEFT JOIN t_MeasureUnit tm ON t1.FUnitID = tm.FMeasureUnitID
SELECT  t1.FPri ,
        t1.FInterID ,
        t2.FEntryID ,
        t3.FPrice ,
        t3.FItemID ,
        t3.FAuxPropID ,
        t3.FUnitID ,
        t3.FQty ,
        CASE WHEN t1.FPlyType = 'PrcAsm1' THEN '2656'
             WHEN t1.FPlyType = 'PrcAsm2' THEN ( SELECT TOP 1
                                                        ftypeid
                                                 FROM   t_Organization
                                                 WHERE  FItemID = '2656'
                                               )
             WHEN t1.FPlyType = 'PrcAsm3' THEN '263'
             WHEN t1.FPlyType = 'PrcAsm4' THEN ( SELECT TOP 1
                                                        Fempgroup
                                                 FROM   t_Emp
                                                 WHERE  FItemID = '263'
                                               )
        END AS FRelatedID
INTO    #tmpPri
FROM    IcPrcPly t1
        INNER JOIN IcPrcPlyEntry t2 ON t1.FInterId = t2.FInterID
        INNER JOIN #tmpPrcPly t3 ON t2.FCuryID = t3.FCuryID
                                    AND t3.FItemID = t2.FItemID
                                    AND t3.FAuxPropID = t2.FAuxPropID
                                    AND t3.FUnitID = t2.FUnitID
        INNER JOIN ( SELECT MAX(FRowNo) FRowNo
                     FROM   #tmpPrcPly
                     GROUP BY FItemID ,
                            FAuxPropID ,
                            FUnitID
                   ) t4 ON t3.FRowNo = t4.FRowNo
WHERE   t1.FPlyType = ( SELECT TOP 1
                                FKey
                        FROM    ICPrcOpt
                        WHERE   FCategory = 'ICPrcPlyType'
                                AND FValue = 1
                        ORDER BY FSort
                      )
        AND ( FPeriodType = 0
              OR ( FPeriodType = 1
                   AND FCycBegTime <= '18:39:11'
                   AND FCycEndTime >= '18:39:11'
                 )
              OR ( FPeriodType = 2
                   AND FCycBegTime <= '18:39:11'
                   AND FCycEndTime >= '18:39:11'
                   AND CHARINDEX('3', FWeek) > 0
                 )
              OR ( FPeriodType = 3
                   AND FCycBegTime <= '18:39:11'
                   AND FCycEndTime >= '18:39:11'
                   AND CHARINDEX('04', FMonth) > 0
                   AND ( FDayPerMonth = '11'
                         OR ( FSerialWeekPerMonth = '2'
                              AND FWeekDayPerMonth = '3'
                            )
                       )
                 )
            )
        AND t2.FBegDate <= '2018-04-11'
        AND t2.FEndDate >= '2018-04-11'
        AND t2.FChecked = 0
        AND t3.FPrice > 0
        AND ( ( t2.FBegQty <= t3.FBaseQty
                AND t2.FEndQty >= t3.FBaseQty
              )
              OR ( t2.FBegQty = 0
                   AND t2.FEndQty = 0
                 )
            ) 
UPDATE  t1
SET     FPrice = t2.FPrice ,
        FMainterID = 16394 ,
        FMaintDate = CONVERT(VARCHAR(10), GETDATE(), 120) ,
        FCheckerID = ( CASE WHEN FChecked = 1 THEN 16394
                            ELSE FCheckerID
                       END ) ,
        FCheckDate = ( CASE WHEN FChecked = 1
                            THEN CONVERT(VARCHAR(10), GETDATE(), 120)
                            ELSE FCheckDate
                       END )
FROM    ICPrcPlyEntry t1
        INNER JOIN #tmpPri t2 ON t1.FInterID = t2.FInterID
                                 AND t1.FEntryID = t2.FEntryID
                                 AND t1.FRelatedID = t2.FRelatedID
        INNER JOIN ( SELECT MIN(Fpri) AS FPri ,
                            FItemID ,
                            FAuxPropID ,
                            FUnitID ,
                            FQty
                     FROM   #tmpPri
                     GROUP BY FItemID ,
                            FAuxPropID ,
                            FUnitID ,
                            FQty
                   ) t3 ON t2.Fpri = t3.FPri
                           AND t2.FItemID = t3.FItemID
                           AND t2.FAuxPropID = t3.FAuxPropID
                           AND t2.FUnitID = t3.FUnitID
                           AND t2.FQty = t3.FQty
DROP TABLE #tmpPri 
SELECT  t1.FPri ,
        t1.FInterID ,
        t2.FEntryID ,
        t3.FDiscount ,
        t3.FItemID ,
        t3.FAuxPropID ,
        t3.FUnitID ,
        t3.FQty
INTO    #tmpDis
FROM    IcDisPly t1
        INNER JOIN IcDisPlyEntry t2 ON t1.FInterId = t2.FInterID
        INNER JOIN #tmpPrcPly t3 ON t3.FItemID = t2.FItemID
                                    AND t3.FAuxPropID = t2.FAuxPropID
                                    AND t3.FUnitID = t2.FUnitID
        INNER JOIN ( SELECT MAX(FRowNo) FRowNo
                     FROM   #tmpPrcPly
                     GROUP BY FItemID ,
                            FAuxPropID ,
                            FUnitID
                   ) t4 ON t3.FRowNo = t4.FRowNo
WHERE   t1.FPlyType = 'DisAsm1'
        AND ( FPeriodType = 0
              OR ( FPeriodType = 1
                   AND FCycBegTime <= '18:39:11'
                   AND FCycEndTime >= '18:39:11'
                 )
              OR ( FPeriodType = 2
                   AND FCycBegTime <= '18:39:11'
                   AND FCycEndTime >= '18:39:11'
                   AND CHARINDEX('3', FWeek) > 0
                 )
              OR ( FPeriodType = 3
                   AND FCycBegTime <= '18:39:11'
                   AND FCycEndTime >= '18:39:11'
                   AND CHARINDEX('04', FMonth) > 0
                   AND ( FDayPerMonth = '11'
                         OR ( FSerialWeekPerMonth = '2'
                              AND FWeekDayPerMonth = '3'
                            )
                       )
                 )
            )
        AND t2.FBegDate <= '2018-04-11'
        AND t2.FEndDate >= '2018-04-11'
        AND t2.FChecked = 0
        AND t3.FDiscount <> 0
        AND t3.FAppScale = 0
        AND t2.FAppScale = t3.FAppScale
        AND t2.FDisType = t3.FDisType
        AND ( ( t2.FBegQty <= t3.FBaseQty
                AND t2.FEndQty >= t3.FBaseQty
              )
              OR ( t2.FBegQty = 0
                   AND t2.FEndQty = 0
                 )
            ) 
UPDATE  t1
SET     FValue = t2.FDiscount ,
        FMainterID = 16394 ,
        FMaintDate = CONVERT(VARCHAR(10), GETDATE(), 120) ,
        FCheckerID = ( CASE WHEN FChecked = 1 THEN 16394
                            ELSE FCheckerID
                       END ) ,
        FCheckDate = ( CASE WHEN FChecked = 1
                            THEN CONVERT(VARCHAR(10), GETDATE(), 120)
                            ELSE FCheckDate
                       END )
FROM    IcDisPlyEntry t1
        INNER JOIN #tmpDis t2 ON t1.FInterID = t2.FInterID
                                 AND t1.FEntryID = t2.FEntryID
        INNER JOIN ( SELECT MIN(Fpri) AS FPri ,
                            FItemID ,
                            FAuxPropID ,
                            FUnitID ,
                            FQty
                     FROM   #tmpDis
                     GROUP BY FItemID ,
                            FAuxPropID ,
                            FUnitID ,
                            FQty
                   ) t3 ON t2.Fpri = t3.FPri
                           AND t2.FItemID = t3.FItemID
                           AND t2.FAuxPropID = t3.FAuxPropID
                           AND t2.FUnitID = t3.FUnitID
                           AND t2.FQty = t3.FQty
WHERE   t1.frelatedid = 2656
DROP TABLE #tmpDis 

INSERT  INTO ICPrcPlyEntry
        ( FInterID ,
          FItemID ,
          FRelatedID ,
          FUnitID ,
          FAuxPropID ,
          FBegQty ,
          FEndQty ,
          FCuryID ,
          FPriceType ,
          FPrice ,
          FBegDate ,
          FEndDate ,
          FChecked ,
          FMainterID ,
          FMaintDate ,
          FCheckerID ,
          FCheckDate
        )
        SELECT  t3.FInterID AS FInterID ,
                t1.FItemID ,
                t3.FRelatedID AS FRelatedID ,
                t1.FUnitID ,
                t1.FAuxPropID ,
                0 ,
                0 ,
                t1.FCuryID ,
                0 ,
                t1.FPrice ,
                '2018-04-11' ,
                '2100-01-01' ,
                0 ,
                t1.FMainterID ,
                t1.FMaintDate ,
                t1.FCheckerID ,
                t1.FCheckDate
        FROM    #tmpPrcPly t1
                INNER JOIN ( SELECT MAX(FRowNo) FRowNo
                             FROM   #tmpPrcPly
                             GROUP BY FItemID ,
                                    FAuxPropID ,
                                    FUnitID
                           ) t2 ON t1.FRowNo = t2.FRowNo
                CROSS JOIN ( SELECT tt1.FPlyType ,
                                    tt1.FInterid ,
                                    CASE WHEN tt1.FPlyType = 'PrcAsm1'
                                         THEN '2656'
                                         WHEN tt1.FPlyType = 'PrcAsm2'
                                         THEN ( SELECT TOP 1
                                                        ftypeid
                                                FROM    t_Organization
                                                WHERE   FItemID = '2656'
                                              )
                                         WHEN tt1.FPlyType = 'PrcAsm3'
                                         THEN '263'
                                         WHEN tt1.FPlyType = 'PrcAsm4'
                                         THEN ( SELECT TOP 1
                                                        Fempgroup
                                                FROM    t_Emp
                                                WHERE   FItemID = '263'
                                              )
                                    END AS FRelatedID
                             FROM   IcprcPly tt1
                             WHERE  tt1.FPlyType IN (
                                    SELECT TOP 1
                                            FKey
                                    FROM    ICPrcOpt
                                    WHERE   FCategory = 'ICPrcPlyType'
                                            AND FValue = 1
                                    ORDER BY FSort )
                                    AND tt1.FInterID = ( SELECT TOP 1
                                                              FInterid
                                                         FROM IcprcPly tt2
                                                         WHERE
                                                              tt1.FPlyType = tt2.FPlyType
                                                         ORDER BY FPri
                                                       )
                           ) t3
        WHERE   t1.FPrice > 0
                AND t3.FRelatedID > 0
                AND NOT EXISTS ( SELECT 1
                                 FROM   ICPrcPly t100 ,
                                        ICPrcPlyEntry t101
                                 WHERE  t100.FInterID = t101.FInterID
                                        AND t101.FChecked = 0
                                        AND t101.FRelatedID = t3.FRelatedID
                                        AND t101.FItemID = t1.FItemID
                                        AND t101.FAuxPropID = t1.FAuxPropID
                                        AND t101.FUnitID = t1.FUnitID
                                        AND t101.FCuryID = t1.FCuryID
                                        AND ( ( t101.FBegQty <= t1.FBaseQty
                                                AND t101.FEndQty >= t1.FBaseQty
                                              )
                                              OR ( t101.FBegQty = 0
                                                   AND t101.FEndQty = 0
                                                 )
                                            )
                                        AND t100.FPlyType = t3.FPlyType
                                        AND ( FPeriodType = 0
                                              OR ( FPeriodType = 1
                                                   AND FCycBegTime <= '18:39:11'
                                                   AND FCycEndTime >= '18:39:11'
                                                 )
                                              OR ( FPeriodType = 2
                                                   AND FCycBegTime <= '18:39:11'
                                                   AND FCycEndTime >= '18:39:11'
                                                   AND CHARINDEX('3', FWeek) > 0
                                                 )
                                              OR ( FPeriodType = 3
                                                   AND FCycBegTime <= '18:39:11'
                                                   AND FCycEndTime >= '18:39:11'
                                                   AND CHARINDEX('04', FMonth) > 0
                                                   AND ( FDayPerMonth = '11'
                                                         OR ( FSerialWeekPerMonth = '2'
                                                              AND FWeekDayPerMonth = '3'
                                                            )
                                                       )
                                                 )
                                            )
                                        AND t101.FBegDate <= '2018-04-11'
                                        AND t101.FEndDate >= '2018-04-11' )

INSERT  INTO ICDisPlyEntry
        ( FInterID ,
          FItemID ,
          FRelatedID ,
          FUnitID ,
          FAuxPropID ,
          FBegQty ,
          FEndQty ,
          FBegAmt ,
          FEndAmt ,
          FCuryID ,
          FDisType ,
          FAppScale ,
          FValue ,
          FBegDate ,
          FEndDate ,
          FChecked ,
          FMainterID ,
          FMaintDate ,
          FCheckerID ,
          FCheckDate
        )
        SELECT  ( SELECT TOP 1
                            FInterid
                  FROM      IcDisPly
                  WHERE     FPlyType = 'DisAsm1'
                  ORDER BY  FPri
                ) AS FInterID ,
                t1.FItemID ,
                2656 ,
                t1.FUnitID ,
                FAuxPropID ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                t1.FDisType ,
                0 ,
                t1.FDiscount ,
                '2018-04-11' ,
                '2100-01-01' ,
                0 ,
                t1.FMainterID ,
                t1.FMaintDate ,
                t1.FCheckerID ,
                t1.FCheckDate
        FROM    #tmpPrcPly t1
                INNER JOIN ( SELECT MAX(FRowNo) FRowNo
                             FROM   #tmpPrcPly
                             GROUP BY FItemID ,
                                    FAuxPropID ,
                                    FUnitID
                           ) t2 ON t1.FRowNo = t2.FRowNo
        WHERE   t1.FDiscount <> 0
                AND NOT EXISTS ( SELECT 1
                                 FROM   ICDisPly t100 ,
                                        ICDisPlyEntry t101
                                 WHERE  t100.FInterID = t101.FInterID
                                        AND t101.FAppScale = 0
                                        AND t101.FChecked = 0
                                        AND t101.FRelatedID = 2656
                                        AND t101.FItemID = t1.FItemID
                                        AND t101.FAuxPropID = t1.FAuxPropID
                                        AND t101.FUnitID = t1.FUnitID
                                        AND ( ( t101.FBegQty <= t1.FBaseQty
                                                AND t101.FEndQty >= t1.FBaseQty
                                              )
                                              OR ( t101.FBegQty = 0
                                                   AND t101.FEndQty = 0
                                                 )
                                            )
                                        AND t100.FPlyType = 'DisAsm1'
                                        AND ( FPeriodType = 0
                                              OR ( FPeriodType = 1
                                                   AND FCycBegTime <= '18:39:11'
                                                   AND FCycEndTime >= '18:39:11'
                                                 )
                                              OR ( FPeriodType = 2
                                                   AND FCycBegTime <= '18:39:11'
                                                   AND FCycEndTime >= '18:39:11'
                                                   AND CHARINDEX('3', FWeek) > 0
                                                 )
                                              OR ( FPeriodType = 3
                                                   AND FCycBegTime <= '18:39:11'
                                                   AND FCycEndTime >= '18:39:11'
                                                   AND CHARINDEX('04', FMonth) > 0
                                                   AND ( FDayPerMonth = '11'
                                                         OR ( FSerialWeekPerMonth = '2'
                                                              AND FWeekDayPerMonth = '3'
                                                            )
                                                       )
                                                 )
                                            )
                                        AND t101.FBegDate <= '2018-04-11'
                                        AND t101.FEndDate >= '2018-04-11' )
                AND EXISTS ( SELECT 1
                             FROM   IcDisPly
                             WHERE  FPlyType = 'DisAsm1' )
DROP TABLE #tmpPrcPly

INSERT  INTO t_Log
        ( FDate ,
          FUserID ,
          FFunctionID ,
          FStatement ,
          FDescription ,
          FMachineName ,
          FIPAddress
        )
VALUES  ( GETDATE() ,
          16394 ,
          'K030101' ,
          3 ,
          '编号为SEORD000086的单据保存成功' ,
          'WIN-5579AATH4RN' ,
          '192.168.6.149'
        )




