USE [AISDF_DFYX];
GO
/****** Object:  StoredProcedure [dbo].[CustomerVerifyAccount_BasedInvoiceAmount_qiu]    Script Date: 2019-11-07 10:39:26 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROCEDURE [dbo].[CustomerVerifyAccount_BasedInvoiceAmount_qiu]
    @fYear VARCHAR(20) ,
    @BeginDate VARCHAR(20) ,
    @EndDate VARCHAR(20) ,
    @fcustname VARCHAR(100)
AS
    BEGIN
        DECLARE @ffyear INT;
        DECLARE @ffmonth INT;
        SET @ffyear = YEAR(@EndDate);
        SET @ffmonth = MONTH(@EndDate);

        SELECT  1 orderNum ,
                CONVERT(VARCHAR(12), MAX(fdate), 111) fdate ,
               CASE WHEN MAX(fdateInvoiceToissue)='' THEN '' ELSE  CONVERT(VARCHAR(12), MAX(fdateInvoiceToissue), 111) end AS fdateInvoiceToissue ,
                fcustnumber ,
                fcustname ,
                fcontractbillno ,
                fbillno ,
                fitemname ,
                stockname ,
                fmodel ,
                funitname ,
                fnote ,
                CAST(SUM(sellqty1) AS DECIMAL(18, 4)) AS sellqty1 ,
                CAST(CASE WHEN SUM(sellqty1) <> 0
                          THEN ( SUM(sellamount1) ) / SUM(sellqty1)
                          ELSE SUM(sellqty1)
                     END AS DECIMAL(18, 2)) AS sellprice1 ,
                CAST(SUM(sellamount1) AS DECIMAL(18, 2)) AS sellamount1 ,
                CAST(SUM(frecieved) AS DECIMAL(18, 2)) AS frecieved ,
                CAST(SUM(fdiscount) AS DECIMAL(18, 2)) AS fdiscount ,
                CAST(SUM(beginbalance) AS DECIMAL(18, 2)) AS beginbalance
        FROM    ( SELECT    DATEADD(DAY, -1, @BeginDate) fdate ,
                            ' ' AS fdateInvoiceToissue ,
                            ' ' AS fcontractbillno ,
                            ' ' AS fbillno ,
                            a.FCustomer fcustid ,
                            b.FNumber fcustnumber ,
                            b.FName fcustname ,
                            SUM(ISNULL(a.FEndBalance, 0)) beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 fhookamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            ' ' stockname ,
                            ' ' funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            ' ' fnote
                  FROM      t_RP_ContactBal AS a
                            INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                  WHERE     a.FYear = @fYear
                            AND a.FPeriod = MONTH(DATEADD(MONTH, -1,
                                                          @BeginDate))
                            AND a.FRP = '1'
                  GROUP BY  a.FCustomer ,
                            b.FNumber ,
                            b.FName 
                    
 
 
                   --以下是销售出库未完全钩稽的应收余额情况
                  UNION ALL
                  SELECT    DATEADD(DAY, -1, @BeginDate) fdate ,
                            '' AS fdateInvoiceToissue ,
                            ' ' fcontractbillno ,
                            ' ' fbillno ,
                            b.FItemID fcustid ,
                            b.FNumber fcustnumber ,
                            b.FName fcustname ,
                            SUM(ISNULL(( FQty - FAllHookQTY ) * FConsignPrice,
                                       0)) beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 fhookamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            t_Stock.FName stockname ,
                            ' ' funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            ' ' fnote
                  FROM      ICStockBillEntry u
                            INNER JOIN ICStockBill v ON v.FInterID = u.FInterID
                            INNER JOIN dbo.t_Organization b ON b.FItemID = v.FSupplyID
                            INNER JOIN t_Stock ON u.FDCStockID = t_Stock.FItemID
                  WHERE     fdate >= DATEADD(MONTH, -1, @BeginDate)
                            AND fdate <= DATEADD(DAY, -1, @BeginDate)
                            AND FTranType = 21
                            AND FCancellation = 0
                            AND FAllHookQTY <> FQty
                  GROUP BY  b.FItemID ,
                            b.FNumber ,
                            b.FName ,
                            t_Stock.FName
                          --u.fscstockid     
                    
                ---以上是期初余额表
                  UNION ALL
                  SELECT    b.FDate fdate ,
                            '' fdateInvoiceToissue ,
                            a.FEntrySelfB0180 fcontractbillno ,
                            b.FBillNo ,
                            b.FSupplyID fcustid ,
                            k.FNumber fcustnumber ,
                            k.FName fcustname ,
                            0 beginbalance ,
                            a.FConsignPrice sellprice1 ,
                            a.FQty sellqty1 ,
                            a.FConsignAmount sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 FhookAMOUNT ,
                            x.FModel ,
                            x.FName fitemname ,
                            t_Stock.FName stockname ,
                            y.FName funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            a.FNote
                  FROM      ICStockBill b
                            JOIN ICStockBillEntry a ON a.FInterID = b.FInterID
                                                       AND b.FDate BETWEEN @BeginDate AND @EndDate
                            INNER JOIN T_PeriodDate tp ON b.FDate >= tp.FStartDate
                                                          AND b.FDate <= tp.FEndDate
                            LEFT JOIN t_Voucher v ON b.FVchInterID = v.FVoucherID
                            LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                            JOIN t_Item k ON b.FSupplyID = k.FItemID
                            LEFT JOIN t_Item d ON b.FDeptID = d.FItemID
                            LEFT JOIN t_Item e ON b.FEmpID = e.FItemID
                            INNER JOIN t_ICItem x ON a.FItemID = x.FItemID
                            INNER JOIN t_MeasureUnit y ON x.FUnitID = y.FMeasureUnitID
                            INNER JOIN t_Stock ON t_Stock.FItemID = a.FDCStockID
                            LEFT JOIN t_Account t ON b.FCussentAcctID = t.FAccountID
                            LEFT JOIN ( SELECT  FIBInterID ,
                                                FEntryID ,
                                                SUM(FHookQty) AS fhookqty
                                        FROM    ICHookRelations
                                        WHERE   FIBTag = 1
                                                AND FTranType <> 1002523
                                                AND ( FYear * 12 + FPeriod ) <= @ffyear
                                                * 12 + @ffmonth
                                        GROUP BY FIBInterID ,
                                                FEntryID
                                      ) tz ON b.FInterID = tz.FIBInterID
                                              AND a.FEntryID = tz.FEntryID
                            LEFT JOIN ( SELECT  FIBInterID
                                        FROM    ICHookRelations
                                        WHERE   FIBTag = 1
                                                AND FTranType <> 1002523
                                                AND FEquityHook = 1
                                                AND ( FYear * 12 + FPeriod ) <= @ffyear
                                                * 12 + @ffmonth
                                      ) ty ON b.FInterID = ty.FIBInterID
                  WHERE     1 = 1
                            AND 1 = 1
                            AND 1 = 1
                            AND b.FTranType = 21
                            AND b.FCancellation <> 1
                            AND NOT EXISTS ( SELECT 1
                                             FROM   ICHookRelations
                                             WHERE  FIBTag = 4
                                                    AND FIBInterID = b.FInterID
                                                    AND FTranType = 21 )
                            AND b.FDate BETWEEN @BeginDate AND @EndDate
                            AND b.FStatus >= 1
                            AND ( CASE WHEN a.FQty = 0 THEN a.FConsignAmount
                                       ELSE ( a.FQty - ISNULL(tz.fhookqty, 0) )
                                            * a.FConsignAmount / a.FQty
                                  END ) <> 0
                            AND ty.FIBInterID IS NULL
                  UNION ALL
                 
	--己出库但未开票的单据			 
                  SELECT    b.FDate fdate ,
                            b.fInOutDate AS fdateInvoiceToissue ,
                            b.fcontractbillno ,
                            b.FBillNo ,
                            b.fcustid ,
                            k.FNumber fcustnumber ,
                            k.FName fcustname ,
                            0 beginbalance ,
                            b.sellprice1 sellprice1 ,
                            b.sellqty1 sellqty1 ,
                            b.FAmount sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 FhookAMOUNT ,
                            x.FModel ,
                            x.FName fitemname ,
                            t_Stock.FName stockname ,
                            y.FName funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            '' FNote
                  FROM      ( SELECT    z.FEntrySelfB0180 fcontractbillno ,
                                        b.FBillNo ,
                                        y.FSupplyID fcustid ,
                                        a.FPrice sellprice1 ,
                                        a.FQty sellqty1 ,
                                        z.FAmount sellamount1 ,
                                        z.FNote ,
                                        b.FClassTypeID ,
                                        b.FInterID AS FInterID ,
                                        0 AS FID ,
                                        b.FYear ,
                                        b.FPeriod ,
                                        1 AS FRP ,
                                        3 AS FType ,
                                        b.FDate AS FDate ,
                                        b.FFincDate AS FFincDate ,
                                        b.FBillNo AS FNumber ,
                                        FCustID AS FCustomer ,
                                        b.FDeptID AS FDepartment ,
                                        b.FEmpID AS FEmployee ,
                                        b.FCurrencyID ,
                                        b.FExchangeRate ,
                                        b.FCompactNo AS FContractNo ,
                                        ( CASE WHEN b.FClassTypeID IN (
                                                    1000000, 1000003, 1007140 )
                                               THEN a.FStdAmount
                                               ELSE a.FStdAmountincludetax
                                          END ) FAmount ,
                                        ( CASE WHEN b.FClassTypeID IN (
                                                    1000000, 1000003, 1007140 )
                                               THEN a.FAmount
                                               ELSE a.FAmountincludetax
                                          END ) FAmountFor ,
                                        a.FRemainAmount FRemainAmount ,
                                        a.FRemainAmountFor FRemainAmountFor ,
                                        0 AS FIsBad ,
                                        b.FVchInterID AS FVoucherID ,
                                        0 AS FGroupID ,
                                        b.FCussentAcctID AS FAccountID ,
                                        0 AS FIsInit ,
                                        b.FArApStatus AS FStatus ,
                                        '' AS FDetailBillType ,
                                        '' AS FDetailBillTypeName ,
                                        CASE WHEN b.FSaleStyle IN ( 100, 20298 )
                                             THEN 3
                                             ELSE 1
                                        END FInvoiceType ,
                                        b.FItemClassID ,
                                        b.FNote FExplanation ,
                                        b.FSubSystemID ,
                                        b.FTranType ,
                                        CAST(v1.FName AS NVARCHAR(30)) + '-'
                                        + CAST(v.FNumber AS NVARCHAR(30)) AS FVoucherNo ,
                                        bt.FName AS FBillTypeName ,
                                        b.FJSBillNo ,
                                        s.FName AS FSettleName ,
                                        '' AS FSettleNo ,
                                        a.FSourceBillNo ,
                                        a.FSourceEntryID ,
                                        a.FSourceInterId ,
                                        z.FDCStockID ,
                                        z.FItemID ,
                                        y.FDate AS fInOutDate
                              FROM      ICSale b
                                        JOIN t_RP_Contact c ON b.FInterID = c.FInvoiceID
                                                              AND c.FType = 3
                                        JOIN ICSaleEntry a ON b.FInterID = a.FInterID
                                        LEFT JOIN t_rp_BillType bt ON b.FClassTypeID = bt.FID
                                        LEFT JOIN t_Voucher v ON b.FVchInterID = v.FVoucherID
                                        LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                                        LEFT JOIN t_Settle s ON b.FSettleID = s.FItemID
                                        INNER JOIN dbo.ICStockBillEntry z ON z.FEntryID = a.FSourceEntryID
                                                              AND a.FSourceInterId = z.FInterID
                                        INNER JOIN dbo.ICStockBill y ON z.FInterID = y.FInterID
                              WHERE     b.FCancellation <> 1
                            ) b
                            JOIN t_Item k ON b.FCustomer = k.FItemID
                            LEFT JOIN t_Item d ON b.FDepartment = d.FItemID
                            LEFT JOIN t_Item e ON b.FEmployee = e.FItemID
                            LEFT JOIN t_Account t ON b.FAccountID = t.FAccountID
                            INNER JOIN t_ICItem x ON b.FItemID = x.FItemID
                            INNER JOIN t_MeasureUnit y ON x.FUnitID = y.FMeasureUnitID
                            INNER JOIN t_Stock ON t_Stock.FItemID = b.FDCStockID
                  WHERE     b.FRP = 1
                            AND b.FItemClassID = 1
                            AND b.FCurrencyID = 1
                            AND b.FInvoiceType NOT IN ( 3, 4 )
                            AND b.FDate BETWEEN @BeginDate AND @EndDate
                            AND b.FStatus >= 1                          
 
                      
----销售出库单 
                  UNION ALL
                  SELECT    a.FFincDate fdate ,
                            ' ' AS fdateInvoiceToissue ,
                            ' ' fcontractbillno ,
                            a.FNumber fbillno ,
                            a.FCustomer fcustid ,
                            b.FNumber fcustnumber ,
                            b.FName fcustname ,
                            0 beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 fhookamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            ' ' stockname ,
                            ' ' funitname ,
                            a.FAmount frecieved ,
                            0 fdiscount ,
                            FExplanation fnote
                  FROM      t_RP_Contact a
                            INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                  WHERE     a.FDate BETWEEN @BeginDate AND @EndDate
                            AND FType = '5'
                            AND FRP = '1'
                            

---收款单(退款单)           
                  UNION ALL
                  SELECT    a.FFincDate fdate ,
                            ' ' AS fdateInvoiceToissue ,
                            ' ' fcontractbillno ,
                            a.FNumber fbillno ,
                            a.FCustomer fcustid ,
                            b.FNumber fcustnumber ,
                            b.FName fcustname ,
                            0 beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookqty ,
                            0 fhookamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            ' ' stockname ,
                            ' ' funitname ,
                            0 frecieved ,
                            a.FAmount fdiscount ,
                            FExplanation fnote
                  FROM      t_RP_Contact a
                            INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                  WHERE     a.FDate BETWEEN @BeginDate AND @EndDate
                            AND FType = '1'
                            AND FRP = '1'
---其他应收单      
                ) x
        WHERE   fcustname = @fcustname
        GROUP BY fcustnumber ,
                fcustname ,
                fcontractbillno ,
                fbillno ,
                fitemname ,
                fmodel ,
                funitname ,
                fnote ,
                sellprice ,
                stockname
        UNION ALL
        SELECT  2 orderNum ,
                '总计' fdate ,
                CONVERT(VARCHAR(12), MAX(fdateInvoiceToissue), 111) AS fdateInvoiceToissue ,
                fcustnumber ,
                '本期合计' fcustname ,
                ' ' fcontractbillno ,
                ' ' fbillno ,
                ' ' fitemname ,
                ' ' stockname ,
                ' ' fmodel ,
                ' ' funitname ,
                '　' fnote ,
                SUM(sellqty1) sellqty1 ,
                0 sellprice1 ,
                CAST(SUM(fhookamount + sellamount1) AS DECIMAL(18, 2)) ,
                --0 AS DECIMAL(18, 4)) ,
                --0 sellprice ,
                --0 AS DECIMAL(18, 2)) ,
               -- 0 AS hookqty ,
                --0 AS hookfprice ,
                --CAST(SUM(fhookamount) AS DECIMAL(18, 2)) AS hookamount ,
                CAST(SUM(ISNULL(frecieved, 0)) AS DECIMAL(18, 2)) ,
                CAST(SUM(ISNULL(fdiscount, 0)) AS DECIMAL(18, 2)) ,
                CAST(SUM(ISNULL(beginbalance, 0)) + SUM(ISNULL(sellamount1, 0))
                - SUM(ISNULL(frecieved, 0)) + SUM(ISNULL(fdiscount, 0)) AS DECIMAL(18,
                                                              2))
        FROM    ( 
        
          --往来余额表，账期内金额，应收余额表
                  SELECT    DATEADD(DAY, -1, @BeginDate) fdate ,
                            ' ' fdateInvoiceToissue ,
                            ' ' fcontractbillno ,
                            ' ' fbillno ,
                            a.FCustomer fcustid ,
                            b.FNumber fcustnumber ,
                            b.FName fcustname ,
                            SUM(ISNULL(a.FEndBalance, 0)) beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 fhookamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            ' ' stockname ,
                            ' ' funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            ' ' fnote
                  FROM      t_RP_ContactBal AS a
                            INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                  WHERE     a.FYear = @fYear
                            AND a.FPeriod = MONTH(DATEADD(MONTH, -1,
                                                          @BeginDate))
                            AND a.FRP = '1'
                  GROUP BY  a.FCustomer ,
                            b.FNumber ,
                            b.FName 
                    
 
 
                   --以下是销售出库未完全钩稽的应收余额情况
                  UNION ALL
                  SELECT    DATEADD(DAY, -1, @BeginDate) fdate ,
                            ' ' fdateInvoiceToissue ,
                            ' ' fcontractbillno ,
                            ' ' fbillno ,
                            b.FItemID fcustid ,
                            b.FNumber fcustnumber ,
                            b.FName fcustname ,
                            SUM(ISNULL(( FQty - FAllHookQTY ) * FConsignPrice,
                                       0)) beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 fhookamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            t_Stock.FName stockname ,
                            ' ' funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            ' ' fnote
                  FROM      ICStockBillEntry u
                            INNER JOIN ICStockBill v ON v.FInterID = u.FInterID
                            INNER JOIN dbo.t_Organization b ON b.FItemID = v.FSupplyID
                            INNER JOIN t_Stock ON u.FDCStockID = t_Stock.FItemID
                  WHERE     fdate >= DATEADD(MONTH, -1, @BeginDate)
                            AND fdate <= DATEADD(DAY, -1, @BeginDate)
                            AND FTranType = 21
                            AND FCancellation = 0
                            AND FAllHookQTY <> FQty
                  GROUP BY  b.FItemID ,
                            b.FNumber ,
                            b.FName ,
                            t_Stock.FName
                          --u.fscstockid            
                    
                    
                    
                  ---以上是期初余额表
                  UNION ALL
                  SELECT    b.FDate fdate ,
                            ' ' fdateInvoiceToissue ,
                            a.FEntrySelfB0180 fcontractbillno ,
                            b.FBillNo ,
                            b.FSupplyID fcustid ,
                            k.FNumber fcustnumber ,
                            k.FName fcustname ,
                            0 beginbalance ,
                            a.FPrice sellprice1 ,
                            a.FQty sellqty1 ,
                            ( CASE WHEN a.FQty = 0 THEN a.FConsignAmount
                                   ELSE ( a.FQty - ISNULL(tz.fhookqty, 0) )
                                        * a.FConsignAmount / a.FQty
                              END ) sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 FhookAMOUNT ,
                            x.FModel ,
                            x.FName fitemname ,
                            t_Stock.FName stockname ,
                            y.FName funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            '己出库未开票' FNote
                  FROM      ICStockBill b
                            JOIN ICStockBillEntry a ON a.FInterID = b.FInterID
                                                       AND b.FDate BETWEEN @BeginDate AND @EndDate
                            INNER JOIN T_PeriodDate tp ON b.FDate >= tp.FStartDate
                                                          AND b.FDate <= tp.FEndDate
                            LEFT JOIN t_Voucher v ON b.FVchInterID = v.FVoucherID
                            LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                            JOIN t_Item k ON b.FSupplyID = k.FItemID
                            LEFT JOIN t_Item d ON b.FDeptID = d.FItemID
                            LEFT JOIN t_Item e ON b.FEmpID = e.FItemID
                            INNER JOIN t_ICItem x ON a.FItemID = x.FItemID
                            INNER JOIN t_MeasureUnit y ON x.FUnitID = y.FMeasureUnitID
                            INNER JOIN t_Stock ON t_Stock.FItemID = a.FDCStockID
                            LEFT JOIN t_Account t ON b.FCussentAcctID = t.FAccountID
                            LEFT JOIN ( SELECT  FIBInterID ,
                                                FEntryID ,
                                                SUM(FHookQty) AS fhookqty
                                        FROM    ICHookRelations
                                        WHERE   FIBTag = 1
                                                AND FTranType <> 1002523
                                                AND ( FYear * 12 + FPeriod ) <= @ffyear
                                                * 12 + @ffmonth
                                        GROUP BY FIBInterID ,
                                                FEntryID
                                      ) tz ON b.FInterID = tz.FIBInterID
                                              AND a.FEntryID = tz.FEntryID
                            LEFT JOIN ( SELECT  FIBInterID
                                        FROM    ICHookRelations
                                        WHERE   FIBTag = 1
                                                AND FTranType <> 1002523
                                                AND FEquityHook = 1
                                                AND ( FYear * 12 + FPeriod ) <= @ffyear
                                                * 12 + @ffmonth
                                      ) ty ON b.FInterID = ty.FIBInterID
                  WHERE     1 = 1
                            AND 1 = 1
                            AND 1 = 1
                            AND b.FTranType = 21
                            AND b.FCancellation <> 1
                            AND NOT EXISTS ( SELECT 1
                                             FROM   ICHookRelations
                                             WHERE  FIBTag = 4
                                                    AND FIBInterID = b.FInterID
                                                    AND FTranType = 21 )
                            AND b.FDate BETWEEN @BeginDate AND @EndDate
                            AND b.FStatus >= 1
                            AND ( CASE WHEN a.FQty = 0 THEN a.FConsignAmount
                                       ELSE ( a.FQty - ISNULL(tz.fhookqty, 0) )
                                            * a.FConsignAmount / a.FQty
                                  END ) <> 0
                            AND ty.FIBInterID IS NULL
                  UNION ALL
                  SELECT    b.FDate fdate ,
                            b.fInOutDate fdateInvoiceToissue ,
                            b.fcontractbillno ,
                            b.FBillNo ,
                            b.fcustid ,
                            k.FNumber fcustnumber ,
                            k.FName fcustname ,
                            0 beginbalance ,
                            b.sellprice1 sellprice1 ,
                            b.sellqty1 sellqty1 ,
                            b.FAmount sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 FhookAMOUNT ,
                            x.FModel ,
                            x.FName fitemname ,
                            t_Stock.FName stockname ,
                            y.FName funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            '' FNote
                  FROM      ( SELECT    z.FEntrySelfB0180 fcontractbillno ,
                                        y.FBillNo ,
                                        y.FSupplyID fcustid ,
                                        a.FPrice sellprice1 ,
                                        a.FQty sellqty1 ,
                                        z.FAmount sellamount1 ,
                                        z.FNote ,
                                        b.FClassTypeID ,
                                        b.FInterID AS FInterID ,
                                        0 AS FID ,
                                        b.FYear ,
                                        b.FPeriod ,
                                        1 AS FRP ,
                                        3 AS FType ,
                                        b.FDate AS FDate ,
                                        b.FFincDate AS FFincDate ,
                                        b.FBillNo AS FNumber ,
                                        FCustID AS FCustomer ,
                                        b.FDeptID AS FDepartment ,
                                        b.FEmpID AS FEmployee ,
                                        b.FCurrencyID ,
                                        b.FExchangeRate ,
                                        b.FCompactNo AS FContractNo ,
                                        ( CASE WHEN b.FClassTypeID IN (
                                                    1000000, 1000003, 1007140 )
                                               THEN a.FStdAmount
                                               ELSE a.FStdAmountincludetax
                                          END ) FAmount ,
                                        ( CASE WHEN b.FClassTypeID IN (
                                                    1000000, 1000003, 1007140 )
                                               THEN a.FAmount
                                               ELSE a.FAmountincludetax
                                          END ) FAmountFor ,
                                        a.FRemainAmount FRemainAmount ,
                                        a.FRemainAmountFor FRemainAmountFor ,
                                        0 AS FIsBad ,
                                        b.FVchInterID AS FVoucherID ,
                                        0 AS FGroupID ,
                                        b.FCussentAcctID AS FAccountID ,
                                        0 AS FIsInit ,
                                        b.FArApStatus AS FStatus ,
                                        '' AS FDetailBillType ,
                                        '' AS FDetailBillTypeName ,
                                        CASE WHEN b.FSaleStyle IN ( 100, 20298 )
                                             THEN 3
                                             ELSE 1
                                        END FInvoiceType ,
                                        b.FItemClassID ,
                                        b.FNote FExplanation ,
                                        b.FSubSystemID ,
                                        b.FTranType ,
                                        CAST(v1.FName AS NVARCHAR(30)) + '-'
                                        + CAST(v.FNumber AS NVARCHAR(30)) AS FVoucherNo ,
                                        bt.FName AS FBillTypeName ,
                                        b.FJSBillNo ,
                                        s.FName AS FSettleName ,
                                        '' AS FSettleNo ,
                                        a.FSourceBillNo ,
                                        a.FSourceEntryID ,
                                        a.FSourceInterId ,
                                        z.FDCStockID ,
                                        z.FItemID ,
                                        y.FDate AS fInOutDate
                              FROM      ICSale b
                                        JOIN t_RP_Contact c ON b.FInterID = c.FInvoiceID
                                                              AND c.FType = 3
                                        JOIN ICSaleEntry a ON b.FInterID = a.FInterID
                                        LEFT JOIN t_rp_BillType bt ON b.FClassTypeID = bt.FID
                                        LEFT JOIN t_Voucher v ON b.FVchInterID = v.FVoucherID
                                        LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                                        LEFT JOIN t_Settle s ON b.FSettleID = s.FItemID
                                        INNER JOIN dbo.ICStockBillEntry z ON z.FEntryID = a.FSourceEntryID
                                                              AND a.FSourceInterId = z.FInterID
                                        INNER JOIN dbo.ICStockBill y ON z.FInterID = y.FInterID
                              WHERE     b.FCancellation <> 1
                            ) b
                            JOIN t_Item k ON b.FCustomer = k.FItemID
                            LEFT JOIN t_Item d ON b.FDepartment = d.FItemID
                            LEFT JOIN t_Item e ON b.FEmployee = e.FItemID
                            LEFT JOIN t_Account t ON b.FAccountID = t.FAccountID
                            INNER JOIN t_ICItem x ON b.FItemID = x.FItemID
                            INNER JOIN t_MeasureUnit y ON x.FUnitID = y.FMeasureUnitID
                            INNER JOIN t_Stock ON t_Stock.FItemID = b.FDCStockID
                  WHERE     b.FRP = 1
                            AND b.FItemClassID = 1
                            AND b.FCurrencyID = 1
                            AND b.FInvoiceType NOT IN ( 3, 4 )
                            AND b.FDate BETWEEN @BeginDate AND @EndDate
                            AND b.FStatus >= 1                          
 
                                                       
                            

----销售出库单 
                  UNION ALL
                  SELECT    a.FFincDate fdate ,
                            ' ' fdateInvoiceToissue ,
                            ' ' fcontractbillno ,
                            a.FNumber fbillno ,
                            a.FCustomer fcustid ,
                            b.FNumber fcustnumber ,
                            b.FName fcustname ,
                            0 beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookprice ,
                            0 fhookamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            ' ' stockname ,
                            ' ' funitname ,
                            a.FAmount frecieved ,
                            0 fdiscount ,
                            FExplanation fnote
                  FROM      t_RP_Contact a
                            INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                  WHERE     a.FDate BETWEEN @BeginDate AND @EndDate
                            AND FType = '5'
                            AND FRP = '1'
                            
                           -- spk3_2tab @sname='t_rp_contact'
                             -- spk3_2str @sname='t_rp_contact'
---收款单(退款单)           
                  UNION ALL
                  SELECT    a.FFincDate fdate ,
                            ' ' fdateInvoiceToissue ,
                            ' ' fcontractbillno ,
                            a.FNumber fbillno ,
                            a.FCustomer fcustid ,
                            b.FNumber fcustnumber ,
                            b.FName fcustname ,
                            0 beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            0 fhookqty ,
                            0 fhookqty ,
                            0 fhookamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            ' ' stockname ,
                            ' ' funitname ,
                            0 frecieved ,
                            a.FAmount fdiscount ,
                            FExplanation fnote
                  FROM      t_RP_Contact a
                            INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                  WHERE     a.FDate BETWEEN @BeginDate AND @EndDate
                            AND FType = '1'
                            AND FRP = '1'
---其他应收单      
                ) x
        WHERE   fcustname = @fcustname
        GROUP BY fcustnumber
        ORDER BY --fcustnumber ,
                fdate ,
                orderNum ,
                stockname;

    END;