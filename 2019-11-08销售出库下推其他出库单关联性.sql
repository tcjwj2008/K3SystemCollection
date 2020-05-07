SELECT  *
FROM    test_YXRY20191006.dbo.ICClassLink
WHERE   FSourClassTypeID = -21
        AND FDestClassTypeID = -29
        AND FIsUsed = 2
UNION ALL 
SELECT * 
FROM AIS20191002101010.dbo.ICClassLink
WHERE
    FSourClassTypeID=-21
	AND FDestClassTypeID=-29
	AND FIsUsed=2
GO
SELECT DISTINCT
        FSourPage ,
        FDestPage
FROM    ICClassLinkEntry
WHERE   FSourClassTypeID = -21
        AND FDestClassTypeID = -29;
GO
SELECT  t1.* ,
        t2.FTabIndex AS FDestTabIndex ,
        t3.FTabIndex AS FSourTabIndex
FROM    ICClassLinkEntry t1
        INNER JOIN ICClassTableInfo t2 ON t1.FDestFKey = t2.FKey
                                          AND t1.FDestClassTypeID = t2.FClassTypeID
        INNER JOIN ICClassTableInfo t3 ON t1.FSourFKey = t3.FKey
                                          AND t1.FSourClassTypeID = t3.FClassTypeID
WHERE   t1.FSourClassTypeID = -21
        AND t1.FDestClassTypeID = -29;
GO
SELECT  t1.* ,
        t2.FTabIndex AS FDestTabIndex
FROM    ICClassLinkEntry t1
        INNER JOIN ICClassTableInfo t2 ON t1.FDestFKey = t2.FKey
                                          AND t1.FDestClassTypeID = t2.FClassTypeID
WHERE   t1.FSourClassTypeID = -21
        AND t1.FDestClassTypeID = -29
        AND FSourFKey LIKE '%.%'; 

GO
SELECT  FPage ,
        FKey ,
        FSRCTableName ,
        FSRCTableNameAs ,
        FSRCFieldName ,
        FDSPFieldName ,
        FFNDFieldName
FROM    ICClassTableInfo
WHERE   FClassTypeID = -21
        AND FSRCTableNameAs <> ''
        AND FCtlType = 1
        AND FSourceType = 1
        AND FKeyWord = '';

GO
SELECT  *
FROM    ICClassLinkEntry
WHERE   FSourClassTypeID = -21
        AND FDestClassTypeID = -29
        AND FAfterFormula <> '';
GO
SELECT  T1.* ,
        T2.FDestFKey ,
        T2.FRedNeg
FROM    ICClassLinkCommit T1
        INNER JOIN ICClassLinkEntry T2 ON T1.FSrcClsTypID = T2.FSourClassTypeID
                                          AND T1.FDstClsTypID = T2.FDestClassTypeID
                                          AND T1.FCheckKey = T2.FSourFKey
                                          AND T2.FIsCheck >= 0
WHERE   T1.FSrcClsTypID = -21
        AND T1.FDstClsTypID = -29;
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO
SELECT  1
FROM    ICStockBill v1
        INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                          AND u1.FInterID <> 0
        INNER JOIN t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                        AND t4.FItemID <> 0
        INNER JOIN t_Stock t8 ON u1.FDCStockID = t8.FItemID
                                 AND t8.FItemID <> 0
        INNER JOIN t_ICItem t14 ON u1.FItemID = t14.FItemID
                                   AND t14.FItemID <> 0
        INNER JOIN t_MeasureUnit t17 ON u1.FUnitID = t17.FItemID
                                        AND t17.FItemID <> 0
        INNER JOIN t_MeasureUnit t30 ON t14.FUnitID = t30.FItemID
                                        AND t30.FItemID <> 0
        LEFT OUTER JOIN ICVoucherTpl t16 ON v1.FPlanVchTplID = t16.FInterID
                                            AND t16.FInterID <> 0
        LEFT OUTER JOIN ICVoucherTpl t13 ON v1.FActualVchTplID = t13.FInterID
                                            AND t13.FInterID <> 0
        LEFT OUTER JOIN t_Department t105 ON v1.FDeptID = t105.FItemID
                                             AND t105.FItemID <> 0
        LEFT OUTER JOIN t_Emp t106 ON v1.FEmpID = t106.FItemID
                                      AND t106.FItemID <> 0
        LEFT OUTER JOIN t_MeasureUnit t500 ON t14.FStoreUnitID = t500.FItemID
                                              AND t500.FItemID <> 0
        LEFT OUTER JOIN t_Currency t503 ON v1.FCurrencyID = t503.FCurrencyID
                                           AND t503.FCurrencyID <> 0
        LEFT OUTER JOIN ZPStockBill t523 ON v1.FInterID = t523.FRelateBillInterID
                                            AND t523.FRelateBillInterID <> 0
        LEFT OUTER JOIN t_MeasureUnit t552 ON t14.FSecUnitID = t552.FItemID
                                              AND t552.FItemID <> 0
        LEFT OUTER JOIN t_Organization t44 ON v1.FConsignee = t44.FItemID
                                              AND t44.FItemID <> 0
        LEFT OUTER JOIN t_PayColCondition t_Pay ON v1.FPayCondition = t_Pay.FID
                                                   AND t_Pay.FID <> 0
WHERE   ( 1 = 1
          AND ( u1.FEntrySelfB0167 > 0.0000000000 )
          AND ( v1.FTranType = 21
                AND ( ( v1.FCheckerID > 0 )
                      AND v1.FCancellation = 0
                    )
              )
        )
        AND ( ( u1.FInterID = 1056102
                AND u1.FEntryID = 1
              )
              OR ( u1.FInterID = 1056103
                   AND u1.FEntryID = 1
                 )
            );
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT  t1.FName AS FBillName ,
        t3.FName AS FSelBillName ,
        t2.FRemark AS FAction ,
        t2.FCondition
FROM    ICTransactionType t1
        INNER JOIN ICClassLink t2 ON t2.FDestTranTypeID = t1.FID
        INNER JOIN ICListTemplate t3 ON t3.FID = t2.FSelectListID
WHERE   t1.FTemplateID = 'B09'
        AND t2.FFieldName = '21';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO
SET TRANSACTION ISOLATION LEVEL  READ UNCOMMITTED;
SELECT DISTINCT
        REPLACE(ISNULL(t4.FCaption,
                       ISNULL(t6.FHeadCaption,
                              REPLACE(ISNULL(t5.FColCaption, ''), '$', ''))),
                ':', '') AS FCaption ,
        t1.FName AS FFieldName ,
        t2.FHeadTable ,
        t1.FColName AS FRSIDField ,
        RTRIM(t1.FColName) + 'Name' AS FRSNameField ,
        RTRIM(t1.FTableAlias) + LEFT('.', LEN(t1.FTableAlias))
        + RTRIM(t1.FName) AS FIDField ,
        ISNULL(RTRIM(t5.FTableAlias) + '.' + RTRIM(t5.FName), '') AS FNameField ,
        t1.FTableName AS FCurrTable
FROM    ICSelbills t1
        INNER JOIN v_ICBillFlow t2 ON t2.FDestTemplateID = t1.FID
                                      AND t2.FFieldName = t1.FFieldName
        LEFT OUTER JOIN ICListTemplate t3 ON t2.FIsNewBill = -1
                                             AND t2.FSelBill = t3.FID
        LEFT OUTER JOIN ICTemplate t4 ON t4.FID = t1.FID
                                         AND t4.FFieldName = t1.FDstCtlField
        LEFT OUTER JOIN ICChatBillTitle t5 ON t5.FColName = RTRIM(t1.FColName)
                                              + 'Name'
                                              AND t5.FTypeID = t3.FTemplateID
        LEFT OUTER JOIN ICTemplateEntry t6 ON t6.FID = t1.FID
                                              AND t6.FFieldName = t1.FDstCtlField
WHERE   t1.FSelType = 1
        AND ( t1.FID = 'B09' )
        AND ( t1.FFieldName = '21' )
        AND t2.FSourTranTypeID = 21;
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO
SELECT  u1.FDetailID AS FListEntryID ,
        0 AS FSel ,
        t16.FName AS FPlanVchTplName ,
        t13.FName AS FActualVchTplName ,
        v1.FPlanVchTplID AS FPlanVchTplID ,
        v1.FActualVchTplID AS FActualVchTplID ,
        ( u1.FQty - u1.FAllHookQTY ) AS FHookQTY ,
        v1.FSupplyID AS FSupplyID ,
        v1.FVchInterID AS FVchInterID ,
        v1.FTranType AS FTranType ,
        v1.FInterID AS FInterID ,
        u1.FEntryID AS FEntryID ,
        v1.FDate AS Fdate ,
        CASE WHEN v1.FCheckerID > 0 THEN 'Y'
             WHEN v1.FCheckerID < 0 THEN 'Y'
             ELSE ''
        END AS FCheck ,
        CASE WHEN v1.FCancellation = 1 THEN 'Y'
             ELSE ''
        END AS FCancellation ,
        v1.FBillNo AS FBillNo ,
        v1.FPrintCount AS FPrintCount ,
        t4.FName AS FSupplyIDName ,
        t8.FName AS FDCStockIDName ,
        t14.FNumber AS FFullNumber ,
        t14.FName AS FItemName ,
        t14.FModel AS FItemModel ,
        t17.FName AS FUnitIDName ,
        u1.FBatchNo AS FBatchNo ,
        u1.FAuxQty AS Fauxqty ,
        u1.FAuxPrice AS Fauxprice ,
        u1.FAmount AS Famount ,
        t4.FItemID AS FCustID ,
        CASE WHEN v1.FVchInterID > 0 THEN 'Y'
             WHEN v1.FVchInterID < 0 THEN 'Y'
             ELSE ''
        END AS FVoucherStatus ,
        ( SELECT    ( SELECT    FName
                      FROM      t_VoucherGroup
                      WHERE     FGroupID = t_Voucher.FGroupID
                    ) + '-' + CONVERT(VARCHAR(30), FNumber)
          FROM      t_Voucher
          WHERE     FVoucherID = v1.FVchInterID
        ) AS FVoucherNumber ,
        CASE WHEN v1.FHookStatus = 1 THEN 'P'
             WHEN v1.FHookStatus = 2 THEN 'Y'
             ELSE ''
        END AS FHookStatus ,
        v1.FMarketingStyle AS FMarketingStyle ,
        t105.FName AS FDeptIDName ,
        t106.FName AS FEmpIDName ,
        t14.FQtyDecimal AS FQtyDecimal ,
        t14.FPriceDecimal AS FPriceDecimal ,
        v1.FOrgBillInterID AS FOrgBillInterID ,
        v1.FStatus AS FStatus ,
        CASE WHEN ( v1.FOrgBillInterID <> 0 ) THEN 'Y'
             ELSE NULL
        END AS FHasSplitBill ,
        t30.FName AS FBaseUnitID ,
        CASE WHEN t14.FStoreUnitID = 0 THEN ''
             ELSE t500.FName
        END AS FCUUnitName ,
        CASE WHEN v1.FCurrencyID IS NULL
                  OR v1.FCurrencyID = '' THEN ( SELECT  FScale
                                                FROM    t_Currency
                                                WHERE   FCurrencyID = 1
                                              )
             ELSE t503.FScale
        END AS FAmountDecimal ,
        CASE WHEN ( v1.FROB <> 1 ) THEN 'Y'
             ELSE ''
        END AS FRedFlag ,
        t523.FBillNo AS FZPBillNo ,
        u1.FConsignPrice AS FConsignPrice ,
        u1.FConsignAmount AS FConsignAmount ,
        CASE WHEN v1.FTranStatus = 1 THEN 'Y'
             ELSE ''
        END AS FTranStatus ,
        t552.FName AS FSecUnitName ,
        u1.FSecCoefficient AS FSecCoefficient ,
        u1.FSecQty AS FSecQty ,
        t44.FName AS FConsigneeName ,
        v1.FConsignee AS FConsignee ,
        v1.FConfirmDate AS FConfirmDate ,
        CASE v1.FConfirmStatus
          WHEN 1 THEN 'Y'
          WHEN 2 THEN 'N'
          ELSE ''
        END AS FConfirmStatus ,
        t_Pay.FName AS FPayCondition ,
        u1.FOLOrderBillNo AS FOLOrderBillNo ,
        t5460.FNumber AS FHeadSelfB0150 ,
        u1.FEntrySelfB0167 AS FEntrySelfB0167
FROM    ICStockBill v1
        INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                          AND u1.FInterID <> 0
        INNER JOIN t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                        AND t4.FItemID <> 0
        INNER JOIN t_Stock t8 ON u1.FDCStockID = t8.FItemID
                                 AND t8.FItemID <> 0
        INNER JOIN t_ICItem t14 ON u1.FItemID = t14.FItemID
                                   AND t14.FItemID <> 0
        INNER JOIN t_MeasureUnit t17 ON u1.FUnitID = t17.FItemID
                                        AND t17.FItemID <> 0
        INNER JOIN t_MeasureUnit t30 ON t14.FUnitID = t30.FItemID
                                        AND t30.FItemID <> 0
        LEFT OUTER JOIN ICVoucherTpl t16 ON v1.FPlanVchTplID = t16.FInterID
                                            AND t16.FInterID <> 0
        LEFT OUTER JOIN ICVoucherTpl t13 ON v1.FActualVchTplID = t13.FInterID
                                            AND t13.FInterID <> 0
        LEFT OUTER JOIN t_Department t105 ON v1.FDeptID = t105.FItemID
                                             AND t105.FItemID <> 0
        LEFT OUTER JOIN t_Emp t106 ON v1.FEmpID = t106.FItemID
                                      AND t106.FItemID <> 0
        LEFT OUTER JOIN t_MeasureUnit t500 ON t14.FStoreUnitID = t500.FItemID
                                              AND t500.FItemID <> 0
        LEFT OUTER JOIN t_Currency t503 ON v1.FCurrencyID = t503.FCurrencyID
                                           AND t503.FCurrencyID <> 0
        LEFT OUTER JOIN ZPStockBill t523 ON v1.FInterID = t523.FRelateBillInterID
                                            AND t523.FRelateBillInterID <> 0
        LEFT OUTER JOIN t_MeasureUnit t552 ON t14.FSecUnitID = t552.FItemID
                                              AND t552.FItemID <> 0
        LEFT OUTER JOIN t_Organization t5460 ON v1.FSupplyID = t5460.FItemID
                                                AND t5460.FItemID <> 0
        LEFT OUTER JOIN t_Organization t44 ON v1.FConsignee = t44.FItemID
                                              AND t44.FItemID <> 0
        LEFT OUTER JOIN t_PayColCondition t_Pay ON v1.FPayCondition = t_Pay.FID
                                                   AND t_Pay.FID <> 0
WHERE   1 = 1
        AND ( u1.FEntrySelfB0167 > 0.0000000000
              AND v1.FDate >= '2019-09-10'
            )
        AND ( v1.FTranType = 21
              AND ( ( v1.FCheckerID > 0 )
                    AND v1.FCancellation = 0
                  )
            )
        AND ( ( v1.FInterID = 1056102
                AND u1.FEntryID = 1
              )
              OR ( v1.FInterID = 1056103
                   AND u1.FEntryID = 1
                 )
            )
ORDER BY v1.FInterID ,
        u1.FEntryID;
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT  FValue
FROM    t_SystemProfile
WHERE   FCategory = 'IC'
        AND FKey = 'PrecisionOfDiscountRate';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT  FValue
FROM    t_SystemProfile
WHERE   FCategory = 'IC'
        AND FKey = 'PrecisionOfDiscountRate';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3Bills.frmBill'
        AND t.FCategory IN ( 'YYHY', 'GMPHY' ); 
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3Bills.frmBill'
        AND t.FCategory = 'YYHY';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3Bills.frmBill'
        AND t.FCategory = 'SPHY';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3Bills.frmBill'
        AND t.FCategory = 'QPHY';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3BILLS.Bill'
        AND t.FCategory = 'MCHY';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO
SET TRANSACTION ISOLATION LEVEL  READ UNCOMMITTED;
SELECT  FScale
FROM    t_Currency
WHERE   FCurrencyID = 1;
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT  GETDATE(); 
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3Bills.Bill'
        AND t.FCategory = 'QPHY ';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3Bills.Bill'
        AND t.FCategory = 'YYHY';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3Bills.Bill'
        AND t.FCategory = 'GMPHY';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        1
FROM    sysobjects
WHERE   name = 't_SMEComponents'
        AND xtype = 'U'; 
GO
SELECT  t.FCategory
FROM    t_SmeComponents t
WHERE   FComponent = 'K3Bills.Bill'
        AND t.FCategory = 'SPHY';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT  ISNULL(FValue, 0) AS FValue
FROM    t_SystemProfile
WHERE   FKey = 'EnablePromoteMant'
        AND FCategory = 'IC';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT TOP 1
        FValue
FROM    t_SystemProfile
WHERE   FCategory = 'IC'
        AND FKey = 'EnableExpDateAlgorithm';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT  FKey ,
        FValue
FROM    t_SystemProfile
WHERE   FCategory IN ( 'IC', 'Base' )
        AND FKey IN ( 'PriceClearByPurchaseMaterial', 'IsLocalBatch',
                      'ICClosed', 'SInvoiceDecimal', 'UseShortNumber',
                      'DoubleUnit', 'AuditChoice', 'AlertDiffStock',
                      'MoneyVisForRequestFromOrder', 'UpStockWhenSave',
                      'PoInvSynInPrice', 'SEOrderTaxInPrice',
                      'POOrderTaxInPrice', 'PoInvSynInPrice',
                      'NoAlertForExistsBillNO', 'PurTaxRateOption',
                      'SaleTaxRateOption', 'AutoCreateBatNo', 'BatchManual',
                      'PurchaseSupportPartiallyHook',
                      'SaleSupportPartiallyHook',
                      'POOrderAutoTransAfterApproval',
                      'SEOrderAutoTransAfterApproval',
                      'CarryInvAutoTransAfterAffirm',
                      'OtherInOutAutoTransAfterAffirm', 'BillStatus',
                      'IsOkToModAfterClose', 'PrecisionOfDiscountRate',
                      'CurrentPeriod', 'CurrentYear', 'ApplyMapInPurchase',
                      'ApplyMapInSale', 'ApplyMapInStock', 'DoubleUnit',
                      'SecUnit', 'EnableATP', 'SEOrderOOSAlert',
                      'TransferBillType', 'BrID', 'ISUsePriceManage',
                      'AutoRSupplyWhenPOS', 'POOrderCanAppendItem',
                      'SEOrderCanAppendItem', 'EditSelfBill',
                      'PurHPriceControl', 'PurHPricePSW', 'PurHPriceZero',
                      'PurHPriceContrlPoint', 'IsUsePurPrcMgr',
                      'AlertHighPriceWhenCheck', 'AlertSELowPrice',
                      'AlertSELowPriceWhenCheck', 'ControlSelBillQty',
                      'AllowPurchase', 'allowmodifyexchangerate',
                      'InCludeDefectiveProducts', 'ISUseMultiCheck',
                      'CreditEnable', 'OutBillBatchNoAuto', 'ISUsePriceManage',
                      'HookFutureBillAllowed', 'HookFutureBillAllowedInSale',
                      'POQtyLargeStock', 'OrdStockOutByProportion',
                      'NumberControl', 'MakeZanGuVoucher', 'EnableMtoPlanMode',
                      'BillDiscount', 'DisCountIncludeTax',
                      'SEOrderEditResourcePrice', 'AffirmPayableDate',
                      'CalCostByBatch', 'CalSubcontractCostByBatch',
                      'BatchReturnQty', 'EnableSupplierCooperation',
                      'VMIOption', 'BatchNoAutoGetMTO', 'OutBillBatchNoAuto',
                      'BillMaxRows', 'BillSecCoefficientModify' )
UNION
SELECT  FKey ,
        FValue
FROM    IcPrcOpt
WHERE   ( ( FKey = 'PrcSynBInv'
            OR FKey = 'IsTaxInPrc'
            OR FKey = 'ISUsePrcMgr'
            OR FKey = 'SOrdAutoUpdPrc'
          )
          AND FCategory = 'ICPrcPlyEls'
        )
        OR ( FCategory = 'LowPrcCtrl'
             AND FKey = 'CtrlTime'
           )
UNION
SELECT  FKey ,
        FValue
FROM    t_RP_SystemProfile
WHERE   FKey IN ( 'FCheckAccount', 'FFinishInitAP', 'FFinishInitAR' )
UNION
SELECT  FKey ,
        FValue
FROM    t_SystemProfile
WHERE   FCategory = 'StdCost'
        AND FKey = 'StdCostStart'
UNION
SELECT  FKey ,
        FValue
FROM    t_SystemProfile
WHERE   FCategory = 'IC_SUBC'
        AND FKey IN ( 'AutoClientVerAfterCheck' );

GO
DECLARE @p3 DATETIME;
SET @p3 = '2019-10-01 00:00:00';
DECLARE @p4 DATETIME;
SET @p4 = '2019-11-01 00:00:00';
EXEC GetPeriodStartEnd 2019, 10, @p3 OUTPUT, @p4 OUTPUT;
SELECT  @p3 ,
        @p4;
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT  FValue
FROM    t_SystemProfile
WHERE   FCategory = 'IC'
        AND FKey = 'InCludeDefectiveProducts';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
EXEC sp_executesql N'SELECT * FROM t_UserProfile WHERE FUserID = @P1 AND FCategory = @P2 AND FKey = @P3',
    N'@P1 int,@P2 nvarchar(180),@P3 nvarchar(255)', 16394,
    N'K3Function.IniFile', N'App.Path\JXCSystem.INI';
GO
EXEC sp_reset_connection;
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO
SET NO_BROWSETABLE ON;
GO
