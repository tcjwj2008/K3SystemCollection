SELECT  *
FROM    t_TableDescription
WHERE   FTableName = 'ICCreditBill'
SELECT  *
FROM    t_TableDescription
WHERE   fdescription LIKE '%采购发票%'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 60038
ORDER BY FFieldName
SELECT  *
FROM    t_TableDescription
WHERE   fdescription LIKE '%入库%'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 210009
ORDER BY FFieldName
SELECT  *
FROM    t_TableDescription
WHERE   ftablename LIKE '%t_rpcontract%'
  --合同表（应付/应收）
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 50030
ORDER BY FFieldName
SELECT  *
FROM    ICPurchase            
--专票					
SELECT  FPeriod ,
        FYear
FROM    T_PeriodDate
WHERE   '2018-04-10' >= FStartDate
        AND '2018-04-10' <= FEndDate                

DECLARE @p2 INT
SET @p2 = 1204
EXEC GetICMaxNum 'ICPurchase', @p2 OUTPUT, 1, 16394
SELECT  @p2

INSERT  INTO ICPurchaseEntry
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
          FDiscountRate ,
          FAuxPriceDiscount ,
          Famount ,
          FStdAmount ,
          FAmtDiscount ,
          FStdAmtDiscount ,
          FTaxRate ,
          FTaxAmount ,
          FStdTaxAmount ,
          FAmountMust ,
          FAmountMustOld ,
          FNoMust ,
          FNoMustOld ,
          FDeductTax ,
          FDeductTaxOld ,
          FOrgBillEntryID ,
          FOrderPrice ,
          FAuxOrderPrice ,
          FClassID_SRC ,
          FEntryID_SRC ,
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
          FStdAllHookAmount ,
          FCurrentHookQTY ,
          FStdCurrentHookAmount ,
          FPlanMode ,
          FMTONo ,
          FOrderType ,
          FBatchNo ,
          FItemStatementBillNO ,
          FItemStatementEntryID ,
          FItemStatementInterID
        )
        SELECT  1204 ,
                1 ,
                '0' ,
                '' ,
                '' ,
                604 ,
                0 ,
                3418 ,
                161 ,
                3418 ,
                0 ,
                0 ,
                36.504274 ,
                42.71 ,
                0 ,
                42.71 ,
                124771.61 ,
                124771.61 ,
                0 ,
                0 ,
                17 ,
                21211.17 ,
                21211.17 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                42.71 ,
                42.71 ,
                0 ,
                0 ,
                'WIN000085' ,
                1 ,
                2199 ,
                1 ,
                '' ,
                0 ,
                0 ,
                'POORD000080' ,
                1227 ,
                1 ,
                0 ,
                0 ,
                0 ,
                0 ,
                14036 ,
                '' ,
                71 ,
                '' ,
                '' ,
                0 ,
                0
        UNION ALL
        SELECT  1204 ,
                2 ,
                '0' ,
                '' ,
                '' ,
                609 ,
                0 ,
                890 ,
                161 ,
                890 ,
                0 ,
                0 ,
                32.435897 ,
                37.95 ,
                0 ,
                37.95 ,
                28867.95 ,
                28867.95 ,
                0 ,
                0 ,
                17 ,
                4907.55 ,
                4907.55 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                37.95 ,
                37.95 ,
                0 ,
                0 ,
                'WIN000085' ,
                1 ,
                2199 ,
                2 ,
                '' ,
                0 ,
                0 ,
                'POORD000080' ,
                1227 ,
                2 ,
                0 ,
                0 ,
                0 ,
                0 ,
                14036 ,
                '' ,
                71 ,
                '' ,
                '' ,
                0 ,
                0
        UNION ALL
        SELECT  1204 ,
                3 ,
                '0' ,
                '' ,
                '' ,
                609 ,
                0 ,
                140 ,
                161 ,
                140 ,
                0 ,
                0 ,
                32.435897 ,
                37.95 ,
                0 ,
                37.95 ,
                4541.03 ,
                4541.03 ,
                0 ,
                0 ,
                17 ,
                771.97 ,
                771.97 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                37.95 ,
                37.95 ,
                0 ,
                0 ,
                'WIN000085' ,
                1 ,
                2199 ,
                3 ,
                '' ,
                0 ,
                0 ,
                'POORD000080' ,
                1227 ,
                3 ,
                0 ,
                0 ,
                0 ,
                0 ,
                14036 ,
                '' ,
                71 ,
                '' ,
                '' ,
                0 ,
                0
        UNION ALL
        SELECT  1204 ,
                4 ,
                '0' ,
                '' ,
                '' ,
                611 ,
                0 ,
                1670 ,
                161 ,
                1670 ,
                0 ,
                0 ,
                30.820513 ,
                36.06 ,
                0 ,
                36.06 ,
                51470.26 ,
                51470.26 ,
                0 ,
                0 ,
                17 ,
                8749.94 ,
                8749.94 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                36.06 ,
                36.06 ,
                0 ,
                0 ,
                'WIN000085' ,
                1 ,
                2199 ,
                4 ,
                '' ,
                0 ,
                0 ,
                'POORD000080' ,
                1227 ,
                4 ,
                0 ,
                0 ,
                0 ,
                0 ,
                14036 ,
                '' ,
                71 ,
                '' ,
                '' ,
                0 ,
                0
        UNION ALL
        SELECT  1204 ,
                5 ,
                '0' ,
                '' ,
                '' ,
                611 ,
                0 ,
                468 ,
                161 ,
                468 ,
                0 ,
                0 ,
                30.820513 ,
                36.06 ,
                0 ,
                36.06 ,
                14424 ,
                14424 ,
                0 ,
                0 ,
                17 ,
                2452.08 ,
                2452.08 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                36.06 ,
                36.06 ,
                0 ,
                0 ,
                'WIN000085' ,
                1 ,
                2199 ,
                5 ,
                '' ,
                0 ,
                0 ,
                'POORD000080' ,
                1227 ,
                5 ,
                0 ,
                0 ,
                0 ,
                0 ,
                14036 ,
                '' ,
                71 ,
                '' ,
                '' ,
                0 ,
                0 
EXEC p_UpdateBillRelateData 75, 1204, 'ICPurchase', 'ICPurchaseEntry' 

INSERT  INTO ICPurchase
        ( FInterID ,
          FBillNo ,
          FBrNo ,
          FTranType ,
          FCancellation ,
          FStatus ,
          FROB ,
          FClassTypeID ,
          FSubSystemID ,
          FYear ,
          FPeriod ,
          FItemClassID ,
          FFincDate ,
          FHookStatus ,
          FTotalCostFor ,
          FTotalCost ,
          Fdate ,
          FSupplyID ,
          FTaxNum ,
          FCheckDate ,
          FDeptID ,
          FEmpID ,
          FBillerName ,
          FCurrencyID ,
          FInvStyle ,
          FExchangeRateType ,
          FExchangeRate ,
          FCompactNo ,
          Fnote ,
          FBillerID ,
          FPOStyle ,
          FYearPeriod ,
          FMultiCheckDate1 ,
          FMultiCheckDate2 ,
          FPOOrdBillNo ,
          FMultiCheckDate3 ,
          FMultiCheckDate4 ,
          FMultiCheckDate5 ,
          FMultiCheckDate6 ,
          FPrintCount ,
          FYtdIntRate ,
          FAcctID ,
          FOrgBillInterID ,
          FHookerID ,
          FSelTranType ,
          FBrID ,
          FManagerID ,
          FCussentAcctID ,
          FPayCondition ,
          FSettleDate ,
          FSysStatus
        )
        SELECT  1204 ,
                'ZPOFP000095' ,
                '0' ,
                75 ,
                0 ,
                0 ,
                1 ,
                1000004 ,
                0 ,
                2018 ,
                4 ,
                8 ,
                '2018-04-10' ,
                0 ,
                262167.56 ,
                262167.56 ,
                '2018-04-10' ,
                412 ,
                '' ,
                NULL ,
                241 ,
                2188 ,
                '' ,
                1 ,
                12510 ,
                1 ,
                1 ,
                '' ,
                '' ,
                16394 ,
                252 ,
                '' ,
                NULL ,
                NULL ,
                '' ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                1 ,
                0 ,
                0 ,
                0 ,
                1006 ,
                '2018-05-08' ,
                0

UPDATE  ICPurchase
SET     FSysStatus = 2
WHERE   FInterID = 1204

UPDATE  ICPurchase
SET     FUUID = NEWID()
WHERE   FInterID = 1204

 --更新采购入库单的开票数量
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(src.fqtyinvoice, 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( ABS(src.fqty) > ABS(@fsrccommitfield_prevalue)
                                            OR ABS(src.fqty) > ABS(@fsrccommitfield_endvalue)
                                          ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fqtyinvoice = @fsrccommitfield_endvalue , --基本单位开票数量
        src.fauxqtyinvoice = @fsrccommitfield_endvalue
        / CAST(t1.fcoefficient AS FLOAT)  --开票数量
FROM    icstockbillentry src
        INNER JOIN icstockbill srchead ON src.finterid = srchead.finterid
        INNER JOIN ( SELECT u1.fsourceinterid AS fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid ,
                            SUM(u1.fqty) AS fqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
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
                FROM    icstockbill src
                        RIGHT JOIN ( SELECT u1.fsourceinterid AS fsourceinterid ,
                                            u1.fsourceentryid ,
                                            u1.fitemid ,
                                            SUM(u1.fqty) AS fqty
                                     FROM   icpurchaseentry u1
                                     WHERE  u1.finterid = 1204
                                     GROUP BY u1.fsourceinterid ,
                                            u1.fsourceentryid ,
                                            u1.fitemid
                                   ) dest ON dest.fsourceinterid = src.finterid
                WHERE   dest.fsourceinterid > 0
                        AND src.finterid IS NULL ) 
        RAISERROR('所选单据已被删除',18,18)

--更新采购订单的开票数量
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(src.fqtyinvoice, 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fqtyinvoice = @fsrccommitfield_endvalue ,
        src.fauxqtyinvoice = @fsrccommitfield_endvalue
        / CAST(t1.fcoefficient AS FLOAT)
FROM    poorderentry src
        INNER JOIN poorder srchead ON src.finterid = srchead.finterid
        INNER JOIN ( SELECT u1.forderinterid AS fsourceinterid ,
                            u1.forderentryid ,
                            u1.fitemid ,
                            SUM(u1.fqty) AS fqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.forderinterid ,
                            u1.forderentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.finterid
                             AND dest.fitemid = src.fitemid
                             AND src.fentryid = dest.forderentryid
        INNER JOIN t_measureunit t1 ON src.funitid = t1.fitemid

 --更新合同（应付）的开票数量
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.finvoiceqty_relative_base),
                                           0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.finvoiceqty_relative_base = CASE WHEN src.fquantity_base < 0
                                             THEN -1
                                                  * @fsrccommitfield_endvalue
                                             ELSE @fsrccommitfield_endvalue
                                        END ,
        src.finvoiceqty_relative = CASE WHEN src.fquantity_base < 0
                                        THEN -1 * ( @fsrccommitfield_endvalue
                                                    / CAST(t1.fcoefficient AS FLOAT) )
                                        ELSE @fsrccommitfield_endvalue
                                             / CAST(t1.fcoefficient AS FLOAT)
                                   END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.fqty) AS fqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid
        INNER JOIN t_measureunit t1 ON src.funitid = t1.fitemid
WHERE   ( SELECT    fclasstypeid
          FROM      t_rpcontract
          WHERE     fcontractid = src.fcontractid
        ) = 1000020

 --更新合同（应付）的发票关联金额（本位币）
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.finvoiceamt_relative), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue
        + dest.fstdamountincludetax ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.finvoiceamt_relative = CASE WHEN src.famountincludetax < 0
                                        THEN -1 * @fsrccommitfield_endvalue
                                        ELSE @fsrccommitfield_endvalue
                                   END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.fstdamountincludetax) AS fstdamountincludetax
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchase tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchaser tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid
WHERE   ( SELECT    fclasstypeid
          FROM      t_rpcontract
          WHERE     fcontractid = src.fcontractid
        ) = 1000020 

 --更新合同（应付）的发票关联金额                                                                              
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.finvoiceamtfor_relative), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue
        + dest.famountincludetax ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.finvoiceamtfor_relative = CASE WHEN src.famountincludetax < 0
                                           THEN -1 * @fsrccommitfield_endvalue
                                           ELSE @fsrccommitfield_endvalue
                                      END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.famountincludetax) AS famountincludetax
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchase tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchaser tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid
WHERE   ( SELECT    fclasstypeid
          FROM      t_rpcontract
          WHERE     fcontractid = src.fcontractid
        ) = 1000020 

  --更新合同（应付）的发票关联数量、发票关联基本数量 
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.finvoiceqty_relative_base),
                                           0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.finvoiceqty_relative_base = CASE WHEN src.fquantity_base < 0
                                             THEN -1
                                                  * @fsrccommitfield_endvalue
                                             ELSE @fsrccommitfield_endvalue
                                        END ,
        src.finvoiceqty_relative = CASE WHEN src.fquantity_base < 0
                                        THEN -1 * ( @fsrccommitfield_endvalue
                                                    / CAST(t1.fcoefficient AS FLOAT) )
                                        ELSE @fsrccommitfield_endvalue
                                             / CAST(t1.fcoefficient AS FLOAT)
                                   END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.fqty) AS fqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid
        INNER JOIN t_measureunit t1 ON src.funitid = t1.fitemid
WHERE   ( SELECT    fclasstypeid
          FROM      t_rpcontract
          WHERE     fcontractid = src.fcontractid
        ) = 1000551

  --更新初始化合同（应付）的发票关联金额  
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.finvoiceamt_relative), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue
        + dest.fstdamountincludetax ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.finvoiceamt_relative = CASE WHEN src.famountincludetax < 0
                                        THEN -1 * @fsrccommitfield_endvalue
                                        ELSE @fsrccommitfield_endvalue
                                   END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.fstdamountincludetax) AS fstdamountincludetax
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchase tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchaser tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid
WHERE   ( SELECT    fclasstypeid
          FROM      t_rpcontract
          WHERE     fcontractid = src.fcontractid
        ) = 1000551 

   --更新初始化合同（应付）的发票关联金额（本位币） 
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.finvoiceamtfor_relative), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue
        + dest.famountincludetax ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.finvoiceamtfor_relative = CASE WHEN src.famountincludetax < 0
                                           THEN -1 * @fsrccommitfield_endvalue
                                           ELSE @fsrccommitfield_endvalue
                                      END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.famountincludetax) AS famountincludetax
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchase tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchaser tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid
WHERE   ( SELECT    fclasstypeid
          FROM      t_rpcontract
          WHERE     fcontractid = src.fcontractid
        ) = 1000551 

   --更新合同（应付）的收款关联金额 （本位币） 
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.freceiveamount), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue
        + dest.fstdamountincludetax ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.freceiveamount = CASE WHEN src.famountincludetax < 0
                                  THEN -1 * @fsrccommitfield_endvalue
                                  ELSE @fsrccommitfield_endvalue
                             END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.fstdamountincludetax) AS fstdamountincludetax
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchase tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchaser tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND ( SELECT    fpostyle
                                  FROM      icpurchase
                                  WHERE     finterid = u1.finterid
                                ) = 251
                            AND ( SELECT    fclasstypeid
                                  FROM      t_rpcontract
                                  WHERE     fcontractid = u1.fcontractinterid
                                ) = 1000020
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid

   --更新合同（应付）的发票关联金额 
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.freceiveamountfor), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue
        + dest.famountincludetax ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.freceiveamountfor = CASE WHEN src.famountincludetax < 0
                                     THEN -1 * @fsrccommitfield_endvalue
                                     ELSE @fsrccommitfield_endvalue
                                END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.famountincludetax) AS famountincludetax
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchase tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchaser tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND ( SELECT    fpostyle
                                  FROM      icpurchase
                                  WHERE     finterid = u1.finterid
                                ) = 251
                            AND ( SELECT    fclasstypeid
                                  FROM      t_rpcontract
                                  WHERE     fcontractid = u1.fcontractinterid
                                ) = 1000020
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid

   --更新合同（应付）的收款执行金额（本位币） 
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.fbillamt_commit), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue
        + dest.fstdamountincludetax ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fbillamt_commit = CASE WHEN src.famountincludetax < 0
                                   THEN -1 * @fsrccommitfield_endvalue
                                   ELSE @fsrccommitfield_endvalue
                              END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.fstdamountincludetax) AS fstdamountincludetax
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchase tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchaser tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND ( SELECT    fpostyle
                                  FROM      icpurchase
                                  WHERE     finterid = u1.finterid
                                ) = 251
                            AND ( SELECT    fclasstypeid
                                  FROM      t_rpcontract
                                  WHERE     fcontractid = u1.fcontractinterid
                                ) = 1000551
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid

  --更新合同（应付）
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.fbillamtfor_commit), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue
        + dest.famountincludetax ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fbillamtfor_commit = CASE WHEN src.famountincludetax < 0
                                      THEN -1 * @fsrccommitfield_endvalue
                                      ELSE @fsrccommitfield_endvalue
                                 END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.famountincludetax) AS famountincludetax
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchase tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND NOT EXISTS ( SELECT 1
                                             FROM   icbillrelations_purchaser tr
                                             WHERE  u1.finterid = tr.fbillid
                                                    AND u1.fentryid = tr.fdestentryid )
                            AND ( SELECT    fpostyle
                                  FROM      icpurchase
                                  WHERE     finterid = u1.finterid
                                ) = 251
                            AND ( SELECT    fclasstypeid
                                  FROM      t_rpcontract
                                  WHERE     fcontractid = u1.fcontractinterid
                                ) = 1000551
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid

 --更新外购入库的辅助单位开票数量
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(src.fsecinvoiceqty, 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fsecqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fsecinvoiceqty = @fsrccommitfield_endvalue
FROM    icstockbillentry src
        INNER JOIN icstockbill srchead ON src.finterid = srchead.finterid
        INNER JOIN ( SELECT u1.fsourceinterid AS fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid ,
                            SUM(u1.fsecqty) AS fsecqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.finterid
                             AND dest.fitemid = src.fitemid
                             AND src.fentryid = dest.fsourceentryid

--更新采购订单的辅助单位开票数量
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(src.fsecinvoiceqty, 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fsecqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fsecinvoiceqty = @fsrccommitfield_endvalue
FROM    poorderentry src
        INNER JOIN poorder srchead ON src.finterid = srchead.finterid
        INNER JOIN ( SELECT u1.forderinterid AS fsourceinterid ,
                            u1.forderentryid ,
                            u1.fitemid ,
                            SUM(u1.fsecqty) AS fsecqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.forderinterid ,
                            u1.forderentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.finterid
                             AND dest.fitemid = src.fitemid
                             AND src.fentryid = dest.forderentryid


 --更新合同（应付）
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.fsecinvoicecommitqty), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fsecqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fsecinvoicecommitqty = CASE WHEN src.fsecqty < 0
                                        THEN -1 * @fsrccommitfield_endvalue
                                        ELSE @fsrccommitfield_endvalue
                                   END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.fsecqty) AS fsecqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid
WHERE   ( SELECT    fclasstypeid
          FROM      t_rpcontract
          WHERE     fcontractid = src.fcontractid
        ) = 1000020


  --更新合同（应付）
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(ABS(src.fsecinvoicecommitqty), 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fsecqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fsecinvoicecommitqty = CASE WHEN src.fsecqty < 0
                                        THEN -1 * @fsrccommitfield_endvalue
                                        ELSE @fsrccommitfield_endvalue
                                   END
FROM    t_rpcontractentry src
        INNER JOIN t_rpcontract srchead ON src.fcontractid = srchead.fcontractid
        INNER JOIN ( SELECT u1.fcontractinterid AS fsourceinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid ,
                            SUM(u1.fsecqty) AS fsecqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.fcontractinterid ,
                            u1.fcontractentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fcontractid
                             AND dest.fitemid = src.fproductid
                             AND src.fentryid = dest.fcontractentryid
WHERE   ( SELECT    fclasstypeid
          FROM      t_rpcontract
          WHERE     fcontractid = src.fcontractid
        ) = 1000551


 --更新VMI物料消耗结算单表体汇总                                                                                                                                                                                                                                                 
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(src.fqtyinvoice, 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.fqty ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( ABS(src.fqty) >= ABS(@fsrccommitfield_endvalue) )
                                     THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fqtyinvoice = @fsrccommitfield_endvalue ,
        src.fauxqtyinvoice = @fsrccommitfield_endvalue
        / CAST(t1.fcoefficient AS FLOAT)
FROM    icitemaccountcheckentrysum src
        INNER JOIN icitemaccountcheck srchead ON src.fid = srchead.fid
        INNER JOIN ( SELECT u1.fitemstatementinterid AS fsourceinterid ,
                            u1.fitemstatemententryid ,
                            u1.fitemid ,
                            SUM(u1.fqty) AS fqty
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.fitemstatementinterid ,
                            u1.fitemstatemententryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.fid
                             AND dest.fitemid = src.fitemid
                             AND src.fentryid = dest.fitemstatemententryid
        INNER JOIN t_measureunit t1 ON src.funitid = t1.fitemid

IF ( ISNULL(@fcheck_fail, 0) = -1 ) 
    RAISERROR('可能的原因是：
 1、所选单据已被其他单据关联
 2、所选单据已被反审核
 3、当前单据和所选单据的关联数量超过了所选单据的数量
 4、所选单据已经关闭',18,18)
ELSE 
    IF EXISTS ( SELECT  1
                FROM    icitemaccountcheck src
                        RIGHT JOIN ( SELECT u1.fitemstatementinterid AS fsourceinterid ,
                                            u1.fitemstatemententryid ,
                                            u1.fitemid ,
                                            SUM(u1.fqty) AS fqty
                                     FROM   icpurchaseentry u1
                                     WHERE  u1.finterid = 1204
                                     GROUP BY u1.fitemstatementinterid ,
                                            u1.fitemstatemententryid ,
                                            u1.fitemid
                                   ) dest ON dest.fsourceinterid = src.fid
                WHERE   dest.fsourceinterid > 0
                        AND src.fid IS NULL ) 
        RAISERROR('所选单据已被删除',18,18)

--更新外购入库的
SET nocount ON
DECLARE @fcheck_fail INT
DECLARE @fsrccommitfield_prevalue DECIMAL(28, 13)
DECLARE @fsrccommitfield_endvalue DECIMAL(28, 10)
DECLARE @maxorder INT 
UPDATE  src
SET     @fsrccommitfield_prevalue = ISNULL(src.fcommitamt, 0) ,
        @fsrccommitfield_endvalue = @fsrccommitfield_prevalue + dest.famount ,
        @fcheck_fail = CASE ISNULL(@maxorder, 0)
                         WHEN 1 THEN 0
                         ELSE ( CASE WHEN ( 1 = 1 ) THEN @fcheck_fail
                                     ELSE -1
                                END )
                       END ,
        src.fcommitamt = @fsrccommitfield_endvalue
FROM    icstockbillentry src
        INNER JOIN icstockbill srchead ON src.finterid = srchead.finterid
        INNER JOIN ( SELECT u1.fsourceinterid AS fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid ,
                            SUM(u1.famount) AS famount
                     FROM   icpurchaseentry u1
                     WHERE  u1.finterid = 1204
                     GROUP BY u1.fsourceinterid ,
                            u1.fsourceentryid ,
                            u1.fitemid
                   ) dest ON dest.fsourceinterid = src.finterid
                             AND dest.fitemid = src.fitemid
                             AND src.fentryid = dest.fsourceentryid


IF EXISTS ( SELECT  1
            FROM    ICBillRelations_Purchase
            WHERE   FBillType = 75
                    AND FBillID = 1204 ) 
    BEGIN
        UPDATE  t1
        SET     t1.FChildren = t1.FChildren + 1
        FROM    ICStockBill t1
                INNER JOIN ICStockBillEntry t2 ON t1.FInterID = t2.FInterID
                INNER JOIN ICBillRelations_Purchase t3 ON t3.FMultiEntryID = t2.FEntryID
                                                          AND t3.FMultiInterID = t2.FInterID
        WHERE   t3.FBillType = 75
                AND t3.FBillID = 1204
    END
ELSE 
    BEGIN
        UPDATE  t3
        SET     t3.FChildren = t3.FChildren + 1
        FROM    ICPurchase t1
                INNER JOIN ICPurchaseEntry t2 ON t1.FInterID = t2.FInterID
                INNER JOIN ICStockBill t3 ON t3.FTranType = t2.FSourceTranType
                                             AND t3.FInterID = t2.FSourceInterID
        WHERE   t1.FTranType = 75
                AND t1.FInterID = 1204
                AND t2.FSourceInterID > 0
    END

--更新合同（应付）
UPDATE  t_rpContractEntry
SET     FInvoiceAmtFor_Relative = ROUND(( u.FInvoiceAmtFor_Relative + ( 1 )
                                          * t1.FQty * t4.FPriceDiscount ),
                                        ISNULL(t6.FScale, 2)) ,
        FInvoiceAmt_Relative = ROUND(( u.FInvoiceAmt_Relative + ( 1 )
                                       * t1.FQty * t4.FPriceDiscount
                                       * t3.FExchangeRate ),
                                     ISNULL(t6.FScale, 2)) ,
        FReceiveAmountFor = CASE WHEN t3.FPOStyle = 251
                                 THEN ROUND(( u.FReceiveAmountFor + ( 1 )
                                              * t1.FQty * t4.FPriceDiscount ),
                                            ISNULL(t6.FScale, 2))
                                 ELSE u.FReceiveAmountFor
                            END ,
        FReceiveAmount = CASE WHEN t3.FPOStyle = 251
                              THEN ROUND(( u.FReceiveAmount + ( 1 ) * t1.FQty
                                           * t4.FPriceDiscount
                                           * t3.FExchangeRate ),
                                         ISNULL(t6.FScale, 2))
                              ELSE u.FReceiveAmount
                         END
FROM    t_rpContractEntry u
        JOIN t_rpContract v ON v.FContractID = u.FContractID
        JOIN ICStockBillEntry t2 ON u.FEntryID = t2.FContractEntryID
        JOIN ICBillRelations_Purchase t1 ON t1.FMultiInterID = t2.FInterID
                                            AND t1.FMultiEntryID = t2.FEntryID
        JOIN ICPurchase t3 ON t1.FBillID = t3.FInterID
        JOIN ICPurchaseEntry t4 ON t1.FBillID = t4.FInterID
                                   AND t1.FDestEntryID = t4.FEntryID
        LEFT JOIN t_Currency t6 ON v.FCurrencyID = t6.FCurrencyID
WHERE   t1.FBillID = 1204

--更新合同（应付）
UPDATE  t_rpContractEntry
SET     FInvoiceAmtFor_Relative = ROUND(( u.FInvoiceAmtFor_Relative - ( 1 )
                                          * t1.FQty * t4.FPriceDiscount ),
                                        ISNULL(t6.FScale, 2)) ,
        FInvoiceAmt_Relative = ROUND(( u.FInvoiceAmt_Relative - ( 1 )
                                       * t1.FQty * t4.FPriceDiscount
                                       * t3.FExchangeRate ),
                                     ISNULL(t6.FScale, 2)) ,
        FInvoiceQty_Relative = ROUND(( u.FInvoiceQty_Relative - ( 1 )
                                       * t1.FQty ), ISNULL(t7.FQtyDecimal, 4)) ,
        FInvoiceQty_Relative_Base = ROUND(( u.FInvoiceQty_Relative_Base
                                            - ( 1 ) * t1.FQty
                                            * tu.FCoefficient ),
                                          ISNULL(t7.FQtyDecimal, 4)) ,
        FSecInvoiceCommitQty = ROUND(( u.FSecInvoiceCommitQty - ( 1 )
                                       * t1.FQty / t4.FSecCoefficient ),
                                     ISNULL(t7.FQtyDecimal, 4)) ,
        FReceiveAmountFor = CASE WHEN t3.FPOStyle = 251
                                 THEN ROUND(( u.FReceiveAmountFor - ( 1 )
                                              * t1.FQty * t4.FPriceDiscount ),
                                            ISNULL(t6.FScale, 2))
                                 ELSE u.FReceiveAmountFor
                            END ,
        FReceiveAmount = CASE WHEN t3.FPOStyle = 251
                              THEN ROUND(( u.FReceiveAmount - ( 1 ) * t1.FQty
                                           * t4.FPriceDiscount
                                           * t3.FExchangeRate ),
                                         ISNULL(t6.FScale, 2))
                              ELSE u.FReceiveAmount
                         END
FROM    t_rpContractEntry u
        JOIN t_rpContract v ON v.FContractID = u.FContractID
        JOIN ICStockBillEntry t2 ON u.FEntryID = t2.FContractEntryID
        JOIN ICBillRelations_PurchaseR t1 ON t1.FMultiInterID = t2.FInterID
                                             AND t1.FMultiEntryID = t2.FEntryID
                                             AND t1.FSourceTranType IN ( 1, 5 )
        JOIN ICPurchase t3 ON t1.FBillID = t3.FInterID
        JOIN ICPurchaseEntry t4 ON t1.FBillID = t4.FInterID
                                   AND t1.FDestEntryID = t4.FEntryID
        LEFT JOIN t_MeasureUnit tu ON t4.FUnitID = tu.FMeasureUnitID
        LEFT JOIN t_Currency t6 ON v.FCurrencyID = t6.FCurrencyID
        LEFT JOIN t_ICItem t7 ON u.FProductID = t7.FItemID
WHERE   t1.FBillID = 1204


--更新采购订单
UPDATE  Src
SET     Src.FReceiveAmountFor_Commit = Src.FReceiveAmountFor_Commit
        + ( ISNULL(Dest.FCommitAmtFor, 0) * ISNULL(Dest.FExchangeRate, 1)
            / ISNULL(Head.FExchangeRate, 1) ) ,
        Src.FReceiveAmount_Commit = Src.FReceiveAmount_Commit
        + ISNULL(Dest.FCommitAmt, 0)
FROM    POOrderEntry Src
        INNER JOIN POOrder Head ON Src.FInterID = Head.FInterID
        INNER JOIN ( SELECT ISNULL(ti.FOrderInterID, t1.FOrderInterID) AS FOrderInterID ,
                            ISNULL(ti.FOrderEntryID, t1.FOrderEntryID) AS FOrderEntryID ,
                            t1.Fitemid ,
                            SUM(CASE WHEN ti.FOrderInterID IS NULL
                                     THEN ( CASE t2.FTranType
                                              WHEN 75
                                              THEN t1.FAmountIncludeTax
                                              WHEN 76 THEN t1.FAmount
                                              ELSE 0
                                            END )
                                     ELSE ti.FQty
                                          * ( CASE t2.FTranType
                                                WHEN 75
                                                THEN t1.FAmountIncludeTax
                                                WHEN 76 THEN t1.FAmount
                                                ELSE 0
                                              END ) / t1.FQty
                                END) AS FCommitAmtFor ,
                            SUM(CASE WHEN ti.FOrderInterID IS NULL
                                     THEN ( CASE t2.FTranType
                                              WHEN 75
                                              THEN t1.FStdAmountIncludeTax
                                              WHEN 76 THEN t1.FStdAmount
                                              ELSE 0
                                            END )
                                     ELSE ti.FQty
                                          * ( CASE t2.FTranType
                                                WHEN 75
                                                THEN t1.FStdAmountIncludeTax
                                                WHEN 76 THEN t1.FStdAmount
                                                ELSE 0
                                              END ) / t1.FQty
                                END) AS FCommitAmt ,
                            t2.FExchangeRate
                     FROM   ICPurchaseEntry t1
                            LEFT JOIN ICPurchase t2 ON t1.FInterID = t2.FInterID
                            LEFT JOIN ( SELECT  a.fbillid ,
                                                a.FDestEntryID ,
                                                b.FOrderInterID ,
                                                b.FOrderEntryID ,
                                                a.fqty
                                        FROM    ICBillRelations_Purchase a
                                                JOIN ICStockBillEntry b ON a.FMultiInterID = b.FInterID
                                                              AND a.FMultiEntryID = b.fentryid
                                      ) ti ON t1.FInterID = ti.FBillID
                                              AND t1.FEntryID = ti.FDestEntryID
                     WHERE  t2.FTranType IN ( 75, 76 )
                            AND t2.FPOStyle = 251
                            AND t1.FOrderInterID > 0
                            AND t2.FInterID = 1204
                     GROUP BY ISNULL(ti.FOrderInterID, t1.FOrderInterID) ,
                            ISNULL(ti.FOrderEntryID, t1.FOrderEntryID) ,
                            t1.FItemID ,
                            t2.FTranType ,
                            t2.FExchangeRate
                   ) Dest ON Dest.FOrderInterID = Src.FInterID
                             AND Dest.Fitemid = Src.Fitemid
                             AND Src.Fentryid = Dest.FOrderEntryID 


 --更新合同收款计划明细
UPDATE  t_rpContractScheme
SET     FReceiveAmountFor = t1.FReceiveAmountFor - t2.FReceiveAmountFor
FROM    t_rpContractScheme t1 ,
        ( SELECT    FContractID ,
                    FSchemeEntryID ,
                    SUM(FAmountFor) FReceiveAmountFor
          FROM      t_rp_ContractPlanReceive
          WHERE     FBillID = 1204
                    AND FBillType = 4
          GROUP BY  FContractID ,
                    FSchemeEntryID
        ) t2
WHERE   t1.FContractID = t2.FContractID
        AND t1.FEntryID = t2.FSchemeEntryID 
DELETE  t_rp_ContractPlanReceive
WHERE   FBillID = 1204
        AND FBillType = 4


UPDATE  ICPurchase
SET     FFincDate = FDate ,
        FYear = 2018 ,
        FPeriod = 4
WHERE   FinterID = 1204

UPDATE  ICPurchase
SET     FFincDate = FDate ,
        FYear = 2018 ,
        FPeriod = 4
WHERE   FinterID = 1204
UPDATE  e
SET     e.FRemainAmount = ( CASE h.FClassTypeID
                              WHEN 1000003 THEN e.FStdAmount
                              ELSE e.FStdAmountincludetax
                            END ) ,
        e.FRemainAmountFor = ( CASE h.FClassTypeID
                                 WHEN 1000003 THEN e.FAmount
                                 ELSE e.FAmountincludetax
                               END ) ,
        e.FRemainQty = e.FAuxQty ,
        e.FClassID_SRC = e.FSourceTranType
FROM    ICPurchaseEntry e
        JOIN ICPurchase h ON e.FinterID = h.FinterID
WHERE   e.FinterID = 1204

UPDATE  t1
SET     t1.FAdjustExchangeRate = CASE WHEN t2.FOperator = '/'
                                      THEN 1 / t1.FExchangerate
                                      ELSE t1.FExchangerate
                                 END ,
        t1.FCheckStatus = ( CASE t1.FPoStyle
                              WHEN 251 THEN 1
                              ELSE 0
                            END ) ,
        t1.FArapStatus = ( CASE t1.FPoStyle
                             WHEN 251 THEN 4
                             ELSE 0
                           END )
FROM    ICPurchase t1
        INNER JOIN t_Currency t2 ON t1.FCurrencyID = t2.FCurrencyID
WHERE   t1.FinterID = 1204

--新增付款计划
INSERT  INTO t_rp_plan_ap
        ( FOrgID ,
          FDate ,
          FAmount ,
          FAmountFor ,
          FRemainAmount ,
          FRemainAmountFor ,
          FRP ,
          FinterID
        )
VALUES  ( 0 ,
          '2018-05-08' ,
          262167.56 ,
          262167.56 ,
          262167.56 ,
          262167.56 ,
          0 ,
          1204
        )

 --应收、应付往来表                                                                                                                                                                                                                                                       
EXEC sp_executesql N'INSERT INTO t_RP_Contact (FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FCustomer,FDepartment,FEmployee,FCurrencyID,FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FK3Import,FInterestRate,FBillType,finvoicetype,FItemClassID,FExplanation,FPreparer) VALUES (@P1,@P2,@P3,@P4,@P5,@P6,@P7,@P8,@P9,@P10,@P11,@P12,@P13,@P14,@P15,@P16,@P17,@P18,@P19,@P20,@P21,@P22,@P23,@P24,@P25)',
    N'@P1 int,@P2 int,@P3 smallint,@P4 smallint,@P5 datetime,@P6 datetime,@P7 varchar(255),@P8 int,@P9 int,@P10 int,@P11 int,@P12 float,@P13 money,@P14 money,@P15 money,@P16 money,@P17 int,@P18 datetime,@P19 smallint,@P20 float,@P21 int,@P22 smallint,@P23 int,@P24 varchar(255),@P25 int',
    2018, 4, 0, 4, '2018-04-10 00:00:00', '2018-04-10 00:00:00', 'ZPOFP000095',
    412, 241, 2188, 1, 1, $262167.5600, $262167.5600, $262167.5600,
    $262167.5600, 1204, '2018-04-10 00:00:00', 1, 0, 1, 2, 8, '', 16394


UPDATE  t_rp_plan_ap
SET     FOrgID = 338
WHERE   FIsinit = 0
        AND FinterID = 1204
        AND FRP = 0

  --最后交易金额
UPDATE  t_supplier
SET     FLastTradeDate = '2018-04-10' ,
        FLastTradeAmount = 262167.56
WHERE   FItemID = 412

UPDATE  ICPurchase
SET     FSubSystemID = 0
WHERE   Ftrantype IN ( 75, 76 )
        AND FInterID = 1204

UPDATE  v1
SET     v1.FOrderPrice = ROUND(u1.FPrice * w1.FExchangeRate * ( 100
                                                              - u1.FDiscountRate )
                               / 100, t1.FPriceDecimal)
FROM    t_ICItemCore v1
        RIGHT JOIN ICPurchaseEntry u1 ON v1.FItemID = u1.FItemID
        LEFT JOIN ICPurchase w1 ON u1.FInterID = w1.FInterID
        LEFT JOIN t_ICItem t1 ON t1.FItemID = u1.FItemID
WHERE   u1.finterid = 1204
        AND u1.FEntryID = ( SELECT  MAX(FEntryid)
                            FROM    ICPurchaseEntry
                            WHERE   FInterid = u1.FInterid
                                    AND FItemid = u1.FItemid
                          )

UPDATE  ICPurchaseEntry
SET     FAmountMustOld = FAmountMust ,
        FNoMustOld = FNoMust ,
        FDeductTaxOld = FDeductTax
WHERE   FInterID = 1204


UPDATE  ICStockBill
SET     FRelateInvoiceID = 1204
WHERE   FInterID = 2199  

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
          'K000301' ,
          3 ,
          '编号为ZPOFP000095的单据保存成功' ,
          'WIN-5579AATH4RN' ,
          '192.168.6.149'
        )


UPDATE  icpurchase
SET     FCheckerID = 16394 ,
        FArApStatus = FArApStatus | 1 ,
        fcheckdate = GETDATE()
WHERE   FInterID = 1204; 
 
UPDATE  t_RP_Contact
SET     FStatus = FStatus | 1 ,
        FToBal = 1
WHERE   FInvoiceID = 1204
        AND FType = 4
        AND FK3Import = 1

UPDATE  ICPurchase
SET     FCheckerID = 16394 ,
        FStatus = 1 ,
        FCheckDate = '2018-04-10'
WHERE   FInterID = 1204