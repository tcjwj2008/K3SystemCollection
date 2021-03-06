USE [AISDF_DFYX]
GO
/****** Object:  StoredProcedure [dbo].[sp_BalanceCal_QIU]    Script Date: 04/22/2020 09:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_BalanceCal_QIU] ( @FCustno VARCHAR(20) ) --[sp_BalanceCal_QIU] '01.038'
AS
    BEGIN
    --定义常量
        DECLARE @fdate VARCHAR(100);
        DECLARE @ffyear INT;
        DECLARE @ffmonth INT;
        
        
        DECLARE @fdate_month VARCHAR(100); 
        SET @fdate_month = CONVERT(VARCHAR(10), DATEPART(YEAR, GETDATE()))
            + '-' + CONVERT(VARCHAR(10), DATEPART(MONTH, GETDATE())) + '-01';
        SET @fdate = CONVERT(VARCHAR(100), GETDATE(), 23);
        
        SET @ffyear = YEAR(CONVERT(VARCHAR(100), GETDATE(), 23));
        SET @ffmonth = MONTH(CONVERT(VARCHAR(100), GETDATE(), 23));
    
    
    --查询期初数据的年度和月份
        DECLARE @ffyear_bal INT;
        DECLARE @ffmonth_bal INT;
    
        IF @ffmonth = 12
            BEGIN
                SET @ffmonth_bal = 1;
                SET @ffyear_bal = @ffyear + 1;
            END;
        ELSE
            BEGIN
                SET @ffmonth_bal = @ffmonth + 1;
                SET @ffyear_bal = @ffyear;
            END;
    
    

        CREATE TABLE #tmpBalance
            (
              FLAG FLOAT ,        --标识
              ContactNo NVARCHAR(MAX) ,   --副合同号
              BeginDate NVARCHAR(MAX) ,   --起始日期
              EndDate NVARCHAR(MAX) ,   --截止日期
              ContactNum FLOAT ,         --合同总量
              ContactPrice FLOAT ,        --单价
              YTDNum FLOAT ,              --已提数总数
              KDWTHNum FLOAT ,            --开单未提货总数
              KDWTHMoney FLOAT ,          --开单未提货金额
              ContactBalance FLOAT ,      --合同余量
              BeforePay FLOAT ,           --定金
              BalanceAll FLOAT ,           --总余款
              CanAll FLOAT                --可提货金额        
            );
--------------------------------------处理期初余额(0)-------------------------------------------------------------------------------------------

        INSERT  INTO #tmpBalance
                ( FLAG ,   --标识
                  ContactNo ,   --副合同号
                  BeginDate ,   --起始日期
                  EndDate ,   --截止日期
                  ContactNum , --合同总量
                  ContactPrice ,--单价
                  YTDNum ,      --已提数总数
                  KDWTHNum ,    --开单未提货总数
                  KDWTHMoney ,  --开单未提货金额
                  ContactBalance ,--合同余量
                  BeforePay ,   --定金
                  BalanceAll ,   --总余款
                  CanAll          --可提货金额       
                )
                SELECT  '0' AS FLAG ,--标识   
                        '' AS ContactNo ,   --副合同号
                        '' AS BeginDate ,   --起始日期
                        '' AS EndDate ,   --截止日期
                        0 AS ContactNum , --合同总量
                        0 AS ContactPrice ,--单价
                        0 AS YTDNum ,      --已提数总数
                        0 AS KDWTHNum ,    --开单未提货总数
                        0 AS KDWTHMoney ,  --开单未提货金额
                        0 AS ContactBalance ,--合同余量
                        0 AS BeforePay ,   --定金
                        SUM(t.sellamount1) - SUM(t.sellqty1)
                        + SUM(t.beginbalance) AS BalanceAll ,   --总余款
                        0 AS CanAll          --可提货金额    
                FROM    (
                
                --余额
                          SELECT    DATEADD(DAY, -1, @fdate) fdate ,
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
                          WHERE     a.FYear = @ffyear
                                    AND a.FPeriod = MONTH(DATEADD(MONTH, -1,
                                                              @fdate))
                                    AND a.FRP = '1'
                                    AND b.FName LIKE '%' + @FCustno + '%'
                          GROUP BY  a.FCustomer ,
                                    b.FNumber ,
                                    b.FName
                          UNION ALL
                          
                          --出库应收
                          SELECT    DATEADD(DAY, -1, @fdate) fdate ,
                                    ' ' AS fdateInvoiceToissue ,
                                    ' ' AS fcontractbillno ,
                                    ' ' AS fbillno ,
                                    b.FSupplyID fcustid ,
                                    k.FNumber fcustnumber ,
                                    k.FName fcustname ,
                                    0 beginbalance ,
                                    0 sellprice1 ,
                                    0 sellqty1 ,
                                    SUM(a.FConsignAmount) sellamount1 ,
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
                          FROM      ICStockBill b
                                    JOIN ICStockBillEntry a ON a.FInterID = b.FInterID
                                                              AND b.FDate BETWEEN @fdate_month AND @fdate
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
                                                        AND ( FYear * 12
                                                              + FPeriod ) <= YEAR(@fdate)
                                                        * 12 + MONTH(@fdate)
                                                GROUP BY FIBInterID ,
                                                        FEntryID
                                              ) tz ON b.FInterID = tz.FIBInterID
                                                      AND a.FEntryID = tz.FEntryID
                                    LEFT JOIN ( SELECT  FIBInterID
                                                FROM    ICHookRelations
                                                WHERE   FIBTag = 1
                                                        AND FTranType <> 1002523
                                                        AND FEquityHook = 1
                                                        AND ( FYear * 12
                                                              + FPeriod ) <= YEAR(@fdate)
                                                        * 12 + MONTH(@fdate)
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
                                    AND b.FDate BETWEEN @fdate_month AND @fdate
                                    AND b.FStatus >= 1
                                    AND ( CASE WHEN a.FQty = 0
                                               THEN a.FConsignAmount
                                               ELSE ( a.FQty
                                                      - ISNULL(tz.fhookqty, 0) )
                                                    * a.FConsignAmount
                                                    / a.FQty
                                          END ) <> 0
                                    AND ty.FIBInterID IS NULL
                                    AND k.FName LIKE '%' + @FCustno + '%'
                          GROUP BY  b.FSupplyID ,
                                    k.FNumber ,
                                    k.FName
                          UNION ALL
                          
                          --实收
                          SELECT    DATEADD(DAY, -1, @fdate) fdate ,
                                    ' ' AS fdateInvoiceToissue ,
                                    ' ' AS fcontractbillno ,
                                    ' ' AS fbillno ,
                                    a.FCustomer fcustid ,
                                    b.FNumber fcustnumber ,
                                    b.FName fcustname ,
                                    0 beginbalance ,
                                    0 sellprice1 ,
                                    SUM(a.FAmount) sellqty1 ,
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
                          FROM      t_RP_Contact a
                                    INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                          WHERE     a.FDate BETWEEN @fdate_month AND @fdate
                                    AND FType = '5'
                                    AND FRP = '1'
                                    AND b.FName LIKE '%' + @FCustno + '%'
                          GROUP BY  a.FCustomer ,
                                    b.FNumber ,
                                    b.FName
                          UNION ALL
                          
                          --发票应收
                          SELECT    DATEADD(DAY, -1, @fdate) fdate ,
                                    ' ' AS fdateInvoiceToissue ,
                                    ' ' AS fcontractbillno ,
                                    ' ' AS fbillno ,
                                    b.fcustid fcustid ,
                                    k.FNumber fcustnumber ,
                                    k.FName fcustname ,
                                    0 beginbalance ,
                                    0 sellprice1 ,
                                    0 sellqty1 ,
                                    SUM(b.FAmount) sellamount1 ,
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
                                                            1000000, 1000003,
                                                            1007140 )
                                                       THEN a.FStdAmount
                                                       ELSE a.FStdAmountincludetax
                                                  END ) FAmount ,
                                                ( CASE WHEN b.FClassTypeID IN (
                                                            1000000, 1000003,
                                                            1007140 )
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
                                                CASE WHEN b.FSaleStyle IN (
                                                          100, 20298 ) THEN 3
                                                     ELSE 1
                                                END FInvoiceType ,
                                                b.FItemClassID ,
                                                b.FNote FExplanation ,
                                                b.FSubSystemID ,
                                                b.FTranType ,
                                                CAST(v1.FName AS NVARCHAR(30))
                                                + '-'
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
                                    AND b.FDate BETWEEN @fdate_month AND @fdate
                                    AND b.FStatus >= 1
                                    AND k.FName LIKE '%' + @FCustno + '%'
                          GROUP BY  b.fcustid ,
                                    k.FNumber ,
                                    k.FName      
                                                                          
                /*本期实收  
                  UNION ALL
                  SELECT    DATEADD(DAY, -1, @fdate) fdate ,
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
                  WHERE     fdate >= DATEADD(MONTH, -1, @fdate)
                            AND fdate <= DATEADD(DAY, -1, @fdate)
                            AND FTranType = 21
                            AND FCancellation = 0
                            AND FAllHookQTY <> FQty
                            AND B.FNumber=@FCustno
                  GROUP BY  b.FItemID ,
                            b.FNumber ,
                            b.FName ,
                            t_Stock.FName
                          --u.fscstockid  */   
                        ) t
           
           
           
           
           --取合同副合同号
                UNION ALL
                SELECT  AA.FLAG ,   --标识
                        AA.ContactNo ,   --副合同号
                        AA.BeginDate ,   --起始日期
                        AA.EndDate ,   --截止日期
                        AA.ContactNum , --合同总量
                        AA.ContactPrice ,--单价
                        AA.YTDNum ,      --已提数总数
                        AA.KDWTHNum ,    --开单未提货总数
                        AA.KDWTHMoney ,  --开单未提货金额
                        AA.ContactBalance ,--合同余量
                        BB.BeforePay ,   --定金
                        AA.BalanceAll ,   --总余款
                        AA.CanAll          --可提货金额 
                FROM    ( SELECT    '2' AS FLAG ,--标识   
                                    A.FHTBH AS ContactNo ,   --副合同号
                                    CONVERT(VARCHAR(100), A.FValiStartDate, 23) AS BeginDate ,   --起始日期
                                    CONVERT(VARCHAR(100), A.FValiEndDate, 23) AS EndDate ,   --截止日期
                                    ISNULL(A.FQuantity, 0) AS ContactNum , --合同总量
                                    A.FTaxPrice AS ContactPrice ,--单价
                                    ISNULL(B.FQty, 0) AS YTDNum ,      --已提数总数
                                    ISNULL(C.FQTY, 0) AS KDWTHNum ,    --开单未提货总数
                                    ISNULL(C.FTAXAMOUNT, 0) AS KDWTHMoney ,  --开单未提货金额
                                    ISNULL(A.FQuantity, 0) - ISNULL(B.FQty, 0)
                                    - ISNULL(C.FQTY, 0) AS ContactBalance ,--合同余量
                                    CASE WHEN ( ( ISNULL(d.FQuantity, 0)
                                                  - ISNULL(e.FQTY, 0)
                                                  - ISNULL(f.FQTY, 0) ) >= ( ISNULL(d.FQuantity,
                                                              0) * 0.1 ) )
                                         THEN ( ISNULL(d.FQuantity, 0)
                                                * ISNULL(d.FTaxPrice, 0) * 0.1 )
                                         ELSE ( ISNULL(d.FQuantity, 0)
                                                - ISNULL(e.FQTY, 0)
                                                - ISNULL(f.FQTY, 0) )
                                              * ISNULL(d.FTaxPrice, 0)
                                    END AS BeforePay ,   --定金                       
                        
                        
                        
                        
                        /*取消按分录数来计算定金
                        CASE WHEN ( ( ISNULL(A.FQuantity, 0) - ISNULL(B.FQty,
                                                              0)
                                      - ISNULL(C.FQTY, 0) ) >= ( ISNULL(A.FQUANTITY,
                                                              0) * 0.1 ) )
                             THEN ( ISNULL(A.FQUANTITY, 0)
                                    * ISNULL(A.FTaxPrice, 0) * 0.1 )
                             ELSE ( ISNULL(A.FQuantity, 0) - ISNULL(B.FQty, 0)
                                    - ISNULL(C.FQTY, 0) ) * ISNULL(A.FTaxPrice,
                                                              0)
                        END AS BeforePay ,   --定金
                        取消按分录数来计算定金*/
                                    0 AS BalanceAll ,   --总余款
                                    0 AS CanAll          --可提货金额    
                          FROM      ( SELECT    FCustomer ,
                                                MAX(t_RPContract.FContractNo) FContractNo ,
                                                t_rpContractEntry.fhtbh ,
                                                MAX(dbo.t_RPContract.FValiStartDate) AS FValiStartDate ,
                                                MAX(FValiEndDate) AS FValiEndDate ,
                                                SUM(dbo.t_rpContractEntry.FQuantity) AS FQuantity ,
                                                AVG(dbo.t_rpContractEntry.FTaxPrice) FTaxPrice
                                      FROM      t_RPContract
                                                INNER JOIN t_rpContractEntry ON t_RPContract.FContractID = t_rpContractEntry.FContractID
                                                INNER JOIN t_ICItem ON t_ICItem.FItemID = dbo.t_rpContractEntry.FProductID
                                                INNER JOIN dbo.t_Organization ON t_Organization.FItemID = t_RPContract.FCustomer
                                      WHERE     ( t_ICItem.FNumber LIKE '10.01.%'
                                                  OR t_ICItem.FNumber LIKE '10.03.%'
                                                )
                                                AND dbo.t_Organization.FName LIKE '%'
                                                + @FCustno + '%'
                                                AND 1 = 1--FContractNo = 'DFYZYX20190904-1'
                                                AND CHARINDEX('_',
                                                              t_RPContract.FContractNo) <= 0
                                                AND dbo.t_RPContract.Fstatus < 2
                                                AND byl = '否' --不参与补余量
                                      GROUP BY  FCustomer ,
                                                fhtbh
                                    ) A
                                    LEFT  JOIN ( SELECT B.FEntrySelfB0180 AS FHTBH ,
                                                        SUM(FQty) AS FQTY
                                                 FROM   dbo.ICStockBill A ,
                                                        dbo.ICStockBillEntry B
                                                 WHERE  A.FInterID = B.FInterID
                                                        AND A.FTranType = 21
                                                        AND A.FCancellation = 0
                                                        AND A.FStatus = 1
                                                 GROUP BY B.FEntrySelfB0180
                                               ) B ON A.FHTBH = B.FHTBH
                                    LEFT JOIN ( SELECT  B.FEntrySelfS0170 AS FHTBH ,
                                                        SUM(FQty) AS FQTY ,
                                                        SUM(B.FAmount) AS FTAXAMOUNT
                                                FROM    dbo.SEOrder A ,
                                                        dbo.SEOrderEntry B
                                                WHERE   A.FInterID = B.FInterID
                                                        AND A.FCancellation = 0
                                          --  AND A.FStatus = 1
                                                        AND B.FMrpClosed = 0
                                                GROUP BY B.FEntrySelfS0170
                                              ) C ON A.FHTBH = C.FHTBH
                                    LEFT JOIN ( SELECT  FCustomer ,
                                                        dbo.t_RPContract.FContractNo ,
                                                        MAX(t_rpContractEntry.fhtbh) FHTBH ,
                                                        MAX(dbo.t_RPContract.FValiStartDate) AS FValiStartDate ,
                                                        MAX(FValiEndDate) AS FValiEndDate ,
                                                        SUM(dbo.t_rpContractEntry.FQuantity) AS FQuantity ,--合计合同数量
                                                        MAX(dbo.t_rpContractEntry.FTaxPrice) FTaxPrice  --最高单价
                                                FROM    t_RPContract
                                                        INNER JOIN t_rpContractEntry ON t_RPContract.FContractID = t_rpContractEntry.FContractID
                                                        INNER JOIN t_ICItem ON t_ICItem.FItemID = dbo.t_rpContractEntry.FProductID
                                                        INNER JOIN dbo.t_Organization ON t_Organization.FItemID = t_RPContract.FCustomer
                                                WHERE   ( t_ICItem.FNumber LIKE '10.01.%'
                                                          OR t_ICItem.FNumber LIKE '10.03.%'
                                                        )
                                                        AND dbo.t_Organization.FName LIKE '%'
                                                        + @FCustno + '%'
                                                        AND 1 = 1--FContractNo = 'DFYZYX20190904-1'
                                                        AND CHARINDEX('_',
                                                              t_RPContract.FContractNo) <= 0
                                                        AND dbo.t_RPContract.Fstatus < 2
                                                        AND byl = '否' --不参与补余量
                                                GROUP BY FCustomer ,
                                                        dbo.t_RPContract.FContractNo
                                              ) d ON d.FContractNo = A.FContractNo
                                    LEFT  JOIN ( SELECT FContractBillNo AS FContractNo ,
                                                        SUM(FQty) AS FQTY
                                                 FROM   dbo.ICStockBill A ,
                                                        dbo.ICStockBillEntry B
                                                 WHERE  A.FInterID = B.FInterID
                                                        AND A.FTranType = 21
                                                        AND A.FCancellation = 0
                                                        AND A.FStatus = 1
                                                 GROUP BY B.FContractBillNo
                                               ) e ON e.FContractNo = A.FContractNo
                                    LEFT JOIN ( SELECT  B.FContractBillNo AS FContractNo ,
                                                        SUM(FQty) AS FQTY ,
                                                        SUM(B.FAmount) AS FTAXAMOUNT
                                                FROM    dbo.SEOrder A ,
                                                        dbo.SEOrderEntry B
                                                WHERE   A.FInterID = B.FInterID
                                                        AND A.FCancellation = 0
                                          --  AND A.FStatus = 1
                                                        AND B.FMrpClosed = 0
                                                GROUP BY B.FContractBillNo
                                              ) f ON f.FContractNo = A.FContractNo
                        ) AA
                        LEFT JOIN ( SELECT  '2' AS FLAG ,--标识   
                                            A.FContractNo AS FCONTRACTNO,
                                            MAX(A.FHTBH) AS ContactNo ,   --副合同号
                                            (CONVERT(VARCHAR(100), MAX(A.FValiStartDate), 23)) AS BeginDate ,   --起始日期
                                            (CONVERT(VARCHAR(100), MAX(A.FValiEndDate), 23)) AS EndDate ,   --截止日期
                                            ISNULL(MAX(A.FQuantity), 0) AS ContactNum , --合同总量
                                            MAX(A.FTaxPrice) AS ContactPrice ,--单价
                                            ISNULL(MAX(B.FQty), 0) AS YTDNum ,      --已提数总数
                                            ISNULL(MAX(C.FQTY), 0) AS KDWTHNum ,    --开单未提货总数
                                            ISNULL(MAX(C.FTAXAMOUNT), 0) AS KDWTHMoney ,  --开单未提货金额
                                            ISNULL(MAX(A.FQuantity), 0)
                                            - ISNULL(MAX(B.FQty), 0)
                                            - ISNULL(MAX(C.FQTY), 0) AS ContactBalance ,--合同余量
                                            CASE WHEN(MAX(CASE WHEN ( ( ISNULL(d.FQuantity,
                                                              0)
                                                          - ISNULL(e.FQTY, 0)
                                                          - ISNULL(f.FQTY, 0) ) >= ( ISNULL(d.FQuantity,
                                                              0) * 0.1 ) )
                                                 THEN ( ISNULL(d.FQuantity, 0)
                                                        * ISNULL(d.FTaxPrice,
                                                              0) * 0.1 )
                                                 ELSE ( ISNULL(d.FQuantity, 0)
                                                        - ISNULL(e.FQTY, 0)
                                                        - ISNULL(f.FQTY, 0) )
                                                      * ISNULL(d.FTaxPrice, 0)
                                            END))<0 THEN 0 ELSE 
                                            (MAX(CASE WHEN ( ( ISNULL(d.FQuantity,
                                                              0)
                                                          - ISNULL(e.FQTY, 0)
                                                          - ISNULL(f.FQTY, 0) ) >= ( ISNULL(d.FQuantity,
                                                              0) * 0.1 ) )
                                                 THEN ( ISNULL(d.FQuantity, 0)
                                                        * ISNULL(d.FTaxPrice,
                                                              0) * 0.1 )
                                                 ELSE ( ISNULL(d.FQuantity, 0)
                                                        - ISNULL(e.FQTY, 0)
                                                        - ISNULL(f.FQTY, 0) )
                                                      * ISNULL(d.FTaxPrice, 0)
                                            END)) end AS BeforePay ,   --定金                       
                        
                        
                        
                        
                        /*取消按分录数来计算定金
                        CASE WHEN ( ( ISNULL(A.FQuantity, 0) - ISNULL(B.FQty,
                                                              0)
                                      - ISNULL(C.FQTY, 0) ) >= ( ISNULL(A.FQUANTITY,
                                                              0) * 0.1 ) )
                             THEN ( ISNULL(A.FQUANTITY, 0)
                                    * ISNULL(A.FTaxPrice, 0) * 0.1 )
                             ELSE ( ISNULL(A.FQuantity, 0) - ISNULL(B.FQty, 0)
                                    - ISNULL(C.FQTY, 0) ) * ISNULL(A.FTaxPrice,
                                                              0)
                        END AS BeforePay ,   --定金
                        取消按分录数来计算定金*/
                                            0 AS BalanceAll ,   --总余款
                                            0 AS CanAll          --可提货金额    
                                    FROM    ( SELECT    FCustomer ,
                                                        MAX(t_RPContract.FContractNo) FContractNo ,
                                                        t_rpContractEntry.fhtbh ,
                                                        MAX(dbo.t_RPContract.FValiStartDate) AS FValiStartDate ,
                                                        MAX(FValiEndDate) AS FValiEndDate ,
                                                        SUM(dbo.t_rpContractEntry.FQuantity) AS FQuantity ,
                                                        AVG(dbo.t_rpContractEntry.FTaxPrice) FTaxPrice
                                              FROM      t_RPContract
                                                        INNER JOIN t_rpContractEntry ON t_RPContract.FContractID = t_rpContractEntry.FContractID
                                                        INNER JOIN t_ICItem ON t_ICItem.FItemID = dbo.t_rpContractEntry.FProductID
                                                        INNER JOIN dbo.t_Organization ON t_Organization.FItemID = t_RPContract.FCustomer
                                              WHERE     ( t_ICItem.FNumber LIKE '10.01.%'
                                                          OR t_ICItem.FNumber LIKE '10.03.%'
                                                        )
                                                        AND dbo.t_Organization.FName LIKE '%'
                                                        + @FCustno + '%'
                                                        AND 1 = 1--FContractNo = 'DFYZYX20190904-1'
                                                        AND CHARINDEX('_',
                                                              t_RPContract.FContractNo) <= 0
                                                        AND dbo.t_RPContract.Fstatus < 2
                                                        AND byl = '否' --不参与补余量
                                              GROUP BY  FCustomer ,
                                                        fhtbh
                                            ) A
                                            LEFT  JOIN ( SELECT
                                                              B.FEntrySelfB0180 AS FHTBH ,
                                                              SUM(FQty) AS FQTY
                                                         FROM dbo.ICStockBill A ,
                                                              dbo.ICStockBillEntry B
                                                         WHERE
                                                              A.FInterID = B.FInterID
                                                              AND A.FTranType = 21
                                                              AND A.FCancellation = 0
                                                              AND A.FStatus = 1
                                                         GROUP BY B.FEntrySelfB0180
                                                       ) B ON A.FHTBH = B.FHTBH
                                            LEFT JOIN ( SELECT
                                                              B.FEntrySelfS0170 AS FHTBH ,
                                                              SUM(FQty) AS FQTY ,
                                                              SUM(B.FAmount) AS FTAXAMOUNT
                                                        FROM  dbo.SEOrder A ,
                                                              dbo.SEOrderEntry B
                                                        WHERE A.FInterID = B.FInterID
                                                              AND A.FCancellation = 0
                                          --  AND A.FStatus = 1
                                                              AND B.FMrpClosed = 0
                                                        GROUP BY B.FEntrySelfS0170
                                                      ) C ON A.FHTBH = C.FHTBH
                                            LEFT JOIN ( SELECT
                                                              FCustomer ,
                                                              dbo.t_RPContract.FContractNo ,
                                                              MAX(t_rpContractEntry.fhtbh) FHTBH ,
                                                              MAX(dbo.t_RPContract.FValiStartDate) AS FValiStartDate ,
                                                              MAX(FValiEndDate) AS FValiEndDate ,
                                                              SUM(dbo.t_rpContractEntry.FQuantity) AS FQuantity ,--合计合同数量
                                                              MAX(dbo.t_rpContractEntry.FTaxPrice) FTaxPrice  --最高单价
                                                        FROM  t_RPContract
                                                              INNER JOIN t_rpContractEntry ON t_RPContract.FContractID = t_rpContractEntry.FContractID
                                                              INNER JOIN t_ICItem ON t_ICItem.FItemID = dbo.t_rpContractEntry.FProductID
                                                              INNER JOIN dbo.t_Organization ON t_Organization.FItemID = t_RPContract.FCustomer
                                                        WHERE ( t_ICItem.FNumber LIKE '10.01.%'
                                                              OR t_ICItem.FNumber LIKE '10.03.%'
                                                              )
                                                              AND dbo.t_Organization.FName LIKE '%'
                                                              + @FCustno + '%'
                                                              AND 1 = 1--FContractNo = 'DFYZYX20190904-1'
                                                              AND CHARINDEX('_',
                                                              t_RPContract.FContractNo) <= 0
                                                              AND dbo.t_RPContract.Fstatus < 2
                                                              AND byl = '否' --不参与补余量
                                                        GROUP BY FCustomer ,
                                                              dbo.t_RPContract.FContractNo
                                                      ) d ON d.FContractNo = A.FContractNo
                                            LEFT  JOIN ( SELECT
                                                              FContractBillNo AS FContractNo ,
                                                              SUM(FQty) AS FQTY
                                                         FROM dbo.ICStockBill A ,
                                                              dbo.ICStockBillEntry B
                                                         WHERE
                                                              A.FInterID = B.FInterID
                                                              AND A.FTranType = 21
                                                              AND A.FCancellation = 0
                                                              AND A.FStatus = 1
                                                         GROUP BY B.FContractBillNo
                                                       ) e ON e.FContractNo = A.FContractNo
                                            LEFT JOIN ( SELECT
                                                              B.FContractBillNo AS FContractNo ,
                                                              SUM(FQty) AS FQTY ,
                                                              SUM(B.FAmount) AS FTAXAMOUNT
                                                        FROM  dbo.SEOrder A ,
                                                              dbo.SEOrderEntry B
                                                        WHERE A.FInterID = B.FInterID
                                                              AND A.FCancellation = 0
                                          --  AND A.FStatus = 1
                                                              AND B.FMrpClosed = 0
                                                        GROUP BY B.FContractBillNo
                                                      ) f ON f.FContractNo = A.FContractNo
                               
                                  WHERE 1=1
                                  GROUP BY A.FContractNo
                               
                                  ) bb ON AA.ContactNo = bb.ContactNo  ;
                    
                                                                 
                        
                  
                 
                       
        INSERT  INTO #tmpBalance
                ( FLAG ,   --标识
                  ContactNo ,   --副合同号
                  BeginDate ,   --起始日期
                  EndDate ,   --截止日期
                  ContactNum , --合同总量
                  ContactPrice ,--单价
                  YTDNum ,      --已提数总数
                  KDWTHNum ,    --开单未提货总数
                  KDWTHMoney ,  --开单未提货金额
                  ContactBalance ,--合同余量
                  BeforePay ,   --定金
                  BalanceAll ,   --总余款
                  CanAll          --可提货金额       
                )
                SELECT  1 AS 标识 ,
                        '合计' AS 副合同号 ,
                        '' 起始日期 ,
                        '' 截止日期 ,
                        SUM(ContactNum) 合同总量 ,
                        0 单价 ,
                        SUM(YTDNum) 已提数总数 ,
                        SUM(KDWTHNum) 开单未提货总数 ,
                        SUM(KDWTHMoney) 开单未提货金额 ,
                        SUM(ContactBalance) 合同余量 ,
                        SUM(BeforePay) 定金 ,
                        0 总余款 ,
                        (  SUM(balanceall)  ) + ( SUM(BeforePay)
                                                + SUM(KDWTHMoney) ) 可提货金额
                FROM    #tmpBalance;        
                  
                  
                  
        SELECT  FLAG AS 标识 ,
                ContactNo AS 副合同号 ,
                BeginDate 起始日期 ,
                EndDate 截止日期 ,
                ContactNum 合同总量 ,
                ContactPrice 单价 ,
                YTDNum 已提数总数 ,
                KDWTHNum 开单未提货总数 ,
                KDWTHMoney 开单未提货金额 ,
                ContactBalance 合同余量 ,
                BeforePay 定金 ,
                BalanceAll 总余款 ,
                CanAll 可提货金额
        FROM    #tmpBalance
        ORDER BY FLAG;         
                  
    END;

   

