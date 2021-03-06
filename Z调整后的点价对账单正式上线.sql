USE [AISDF_DFYX]
GO
/****** Object:  StoredProcedure [dbo].[CustomerVerifyAccount_BasedInvoiceAmount_qiu]    Script Date: 09/29/2019 10:11:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CustomerVerifyAccount_BasedInvoiceAmount_qiu]
    @fYear VARCHAR(20) ,
    @BeginDate VARCHAR(20) ,
    @EndDate VARCHAR(20) ,
    @BegCustNo VARCHAR(100) ,
    @EndCustNo VARCHAR(100)
AS 
    BEGIN

        SELECT  1 orderNum ,
                CONVERT(VARCHAR(12), MAX(fdate), 111) fdate ,
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
                CAST(ROUND(sum(sellprice1), 0) AS INT) AS sellprice1 ,
                CAST(SUM(sellamount1) AS DECIMAL(18, 2)) AS sellamount1 ,
                0 AS sellqty ,
                0 AS sellprice ,
                CAST(SUM(sellamount1-fhookamount) AS DECIMAL(18, 2)) AS sellamount ,
                CAST(SUM(fhookqty) AS DECIMAL(18, 4)) AS hookqty ,
                CAST(SUM(fhookprice) AS DECIMAL(18, 4)) AS hookfprice ,
                CAST(SUM(fhookamount) AS DECIMAL(18, 2)) AS hookamount ,
                CAST(SUM(frecieved) AS DECIMAL(18, 2)) AS frecieved ,
                CAST(SUM(fdiscount) AS DECIMAL(18, 2)) AS fdiscount ,
                CAST(SUM(beginbalance) AS DECIMAL(18, 2)) AS beginbalance
        FROM    ( 
        --往来余额表，账期内金额，应收余额表
                  SELECT    DATEADD(day, -1, @BeginDate) fdate ,
                            ' ' fcontractbillno ,
                            ' ' fbillno ,
                            a.fcustomer fcustid ,
                            b.fnumber fcustnumber ,
                            b.fname fcustname ,
                            SUM(ISNULL(a.fendbalance, 0)) beginbalance ,
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
                  FROM      t_rp_contactbal AS a
                            INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                  WHERE     a.fyear = @fYear
                            AND a.fperiod = MONTH(DATEADD(month, -1,
                                                          @BeginDate))
                            AND a.frp = '1'
                  GROUP BY  a.fcustomer ,
                            b.fnumber ,
                            b.fname 
                    
 
 
                   --以下是销售出库未完全钩稽的应收余额情况
                  UNION ALL
                  SELECT    DATEADD(day, -1, @BeginDate) fdate ,
                            ' ' fcontractbillno ,
                            ' ' fbillno ,
                            b.FItemID fcustid ,
                            b.fnumber fcustnumber ,
                            b.fname fcustname ,
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
                            t_stock.FName stockname ,
                            ' ' funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            ' ' fnote
                  FROM      ICStockBillEntry u
                            INNER JOIN ICStockBill v ON v.FInterID = u.FInterID
                            INNER JOIN dbo.t_Organization b ON b.FItemID = v.FSupplyID
                            INNER JOIN t_stock ON u.FDCStockID = t_stock.FItemID
                  WHERE     FDate >= DATEADD(month, -1, @BeginDate)
                            AND FDate <= DATEADD(day, -1, @BeginDate)
                            AND FTranType = 21
                            AND FCancellation = 0
                            AND FAllHookQTY <> FQty
                  GROUP BY  b.FItemID ,
                            b.fnumber ,
                            b.fname ,
                            t_stock.FName
                          --u.fscstockid            
                    
                    
                    
                  ---以上是期初余额表
                  
                  
                  
                  UNION ALL
                  SELECT    v.fdate fdate ,
                            v.fcontractbillno ,
                            v.fbillno ,
                            v.fcustid ,
                            v.fcustnumber ,
                            v.fcustname ,
                            0 beginbalance ,
                             v.sellprice1 ,
                              v.sellqty1 ,
                              v.sellamount1 ,
                            v.sellprice ,
                            v.sellqty ,
                            v.sellamount ,
                            v.fhookqty ,
                            v.fhookprice ,
                            v.FhookAMOUNT ,
                            v.fmodel ,
                            v.fitemname ,
                            v.stockname ,
                            v.funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            v.fnote
                  FROM      ( SELECT    a.fdate fdate ,
                                        b.FEntrySelfB0180 fcontractbillno ,
                                        a.fbillno ,
                                        a.fsupplyid fcustid ,
                                        c.fnumber fcustnumber ,
                                        c.fname fcustname ,
                                        SUM(b.fqty) sellprice1 ,
                                        AVG(b.FConsignPrice)  sellqty1 ,
                                        SUM(b.fconsignamount) sellamount1 ,
                                        0 sellqty ,
                                        0 sellprice ,
                                        0 sellamount ,
                                        0 fhookqty ,
                                        0 fhookprice ,
                                        0 FhookAMOUNT ,                       
                                     
                                        d.fmodel ,
                                        d.fname fitemname ,
                                        t_stock.FName stockname ,
                                        e.fname funitname ,
                                        b.fnote fnote
                              FROM      icstockbill a
                                        INNER JOIN icstockbillentry b ON a.finterid = b.finterid
                                        INNER JOIN t_organization c ON a.fsupplyid = c.fitemid
                                        INNER JOIN t_icitem d ON b.fitemid = d.fitemid
                                        INNER JOIN t_measureunit e ON d.funitid = e.fmeasureunitid
                                        INNER JOIN t_stock ON t_stock.FItemID = b.FDCStockID
                        
                              WHERE     a.fdate BETWEEN @BeginDate AND @EndDate
                                        AND ftrantype = '21'
                                        AND fcancellation = 0
                              GROUP BY  a.fdate ,
                                        b.FEntrySelfB0180 ,
                                        a.fbillno ,
                                        a.fsupplyid ,
                                        c.fnumber ,
                                        c.fname ,
                                        d.fmodel ,
                                        d.fname ,
                                        e.fname ,
                                        b.fnote ,
                                        b.FConsignPrice ,
                                        --b.FSCStockID
                                        t_stock.FName
                            ) v
                            
                            
                            
                            
  --以上是出库的总金额表
                  UNION ALL
                  SELECT    v.fdate fdate ,
                            v.fcontractbillno ,
                            v.fbillno ,
                            v.fcustid ,
                            v.fcustnumber ,
                            v.fcustname ,
                            0 beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            v.fhookqty ,
                            v.fhookprice ,
                            v.FhookAMOUNT ,
                            v.fmodel ,
                            v.fitemname ,
                            v.stockname ,
                            v.funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            v.fnote
                  FROM      ( SELECT    a.fdate fdate ,
                                        b.FEntrySelfB0180 fcontractbillno ,
                                        a.fbillno ,
                                        a.fsupplyid fcustid ,
                                        c.fnumber fcustnumber ,
                                        c.fname fcustname ,
                                        SUM(b.fqty - t8.FQty) sellqty ,
                                       --  SUM(b.fconsignamount-t8.FAmount) sellamount ,
                                       -- SUM(b.fconsignamount-t8.FAmount) sellamount ,
                                        SUM(( b.fqty - t8.FQty )
                                            * FConsignPrice) sellamount ,
                                        SUM(t8.FQty) fhookqty ,
                                        AVG(t8.FPrice) fhookprice ,
                                        SUM(t8.FAmount) AS FhookAMOUNT ,
                                --SUM(b.fconsignamount) / SUM(b.fqty) sellprice ,
                                        b.FConsignPrice sellprice ,
                                        d.fmodel ,
                                        d.fname fitemname ,
                                        t_stock.FName stockname ,
                                        e.fname funitname ,
                                        b.fnote fnote
                              FROM      icstockbill a
                                        INNER JOIN icstockbillentry b ON a.finterid = b.finterid
                                        INNER JOIN t_organization c ON a.fsupplyid = c.fitemid
                                        INNER JOIN t_icitem d ON b.fitemid = d.fitemid
                                        INNER JOIN t_measureunit e ON d.funitid = e.fmeasureunitid
                                        INNER JOIN t_stock ON t_stock.FItemID = b.FDCStockID
                                        INNER JOIN ( SELECT FSourceBillNo ,
                                                            FQty ,
                                                            FPrice ,
                                                            FAmount
                                                     FROM   icsaleentry
                                                   ) t8 ON t8.FSourceBillNo = a.FBillNo
                              WHERE     a.fdate BETWEEN @BeginDate AND @EndDate
                                        AND ftrantype = '21'
                                        AND fcancellation = 0
                              GROUP BY  a.fdate ,
                                        b.FEntrySelfB0180 ,
                                        a.fbillno ,
                                        a.fsupplyid ,
                                        c.fnumber ,
                                        c.fname ,
                                        d.fmodel ,
                                        d.fname ,
                                        e.fname ,
                                        b.fnote ,
                                        b.FConsignPrice ,
                                        --b.FSCStockID
                                        t_stock.FName
                            ) v
                            
                            
              -- spk3_2str @sname='icsaleentry'             
                            
----销售出库单 
                  UNION ALL
                  SELECT    a.ffincdate fdate ,
                            ' ' fcontractbillno ,
                            a.fnumber fbillno ,
                            a.fcustomer fcustid ,
                            b.fnumber fcustnumber ,
                            b.fname fcustname ,
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
                            a.famount frecieved ,
                            0 fdiscount ,
                            fexplanation fnote
                  FROM      t_rp_contact a
                            INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                  WHERE     a.fdate BETWEEN @BeginDate AND @EndDate
                            AND ftype = '5'
                            AND frp = '1'
                            
                           -- spk3_2tab @sname='t_rp_contact'
                             -- spk3_2str @sname='t_rp_contact'
---收款单(退款单)           
                  UNION ALL
                  SELECT    a.ffincdate fdate ,
                            ' ' fcontractbillno ,
                            a.fnumber fbillno ,
                            a.fcustomer fcustid ,
                            b.fnumber fcustnumber ,
                            b.fname fcustname ,
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
                            a.famount fdiscount ,
                            fexplanation fnote
                  FROM      t_rp_contact a
                            INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                  WHERE     a.fdate BETWEEN @BeginDate AND @EndDate
                            AND ftype = '1'
                            AND frp = '1'
---其他应收单      
                  
                ) x
        WHERE   fcustnumber BETWEEN @BegCustNo AND @EndCustNo
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
                @EndDate fdate ,
                fcustnumber ,
                '本期合计' fcustname ,
                ' ' fcontractbillno ,
                ' ' fbillno ,
                ' ' fitemname ,
                ' ' stockname ,
                ' ' fmodel ,
                ' ' funitname ,
                '　' fnote ,
                CAST(SUM(ISNULL(sellqty1, 0)) AS DECIMAL(18, 4)) ,
                0 sellprice1 ,
                CAST(SUM(ISNULL(sellamount1, 0)) AS DECIMAL(18, 2)) ,
                CAST(SUM(ISNULL(sellqty, 0)) AS DECIMAL(18, 4)) ,
                0 sellprice ,
                CAST(SUM(ISNULL(sellamount, 0)) AS DECIMAL(18, 2)) ,
                0 AS hookqty ,
                CAST(SUM(fhookprice) AS DECIMAL(18, 4)) AS hookfprice ,
                CAST(SUM(fhookamount) AS DECIMAL(18, 2)) AS hookamount ,
                CAST(SUM(ISNULL(frecieved, 0)) AS DECIMAL(18, 2)) ,
                CAST(SUM(ISNULL(fdiscount, 0)) AS DECIMAL(18, 2)) ,
                CAST(SUM(ISNULL(beginbalance, 0)) + SUM(ISNULL(sellamount1, 0))
                - SUM(ISNULL(frecieved, 0)) + SUM(ISNULL(fdiscount, 0)) AS DECIMAL(18,
                                                              2))
        FROM    ( 
        
          --往来余额表，账期内金额，应收余额表
                  SELECT    DATEADD(day, -1, @BeginDate) fdate ,
                            ' ' fcontractbillno ,
                            ' ' fbillno ,
                            a.fcustomer fcustid ,
                            b.fnumber fcustnumber ,
                            b.fname fcustname ,
                            SUM(ISNULL(a.fendbalance, 0)) beginbalance ,
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
                  FROM      t_rp_contactbal AS a
                            INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                  WHERE     a.fyear = @fYear
                            AND a.fperiod = MONTH(DATEADD(month, -1,
                                                          @BeginDate))
                            AND a.frp = '1'
                  GROUP BY  a.fcustomer ,
                            b.fnumber ,
                            b.fname 
                    
 
 
                   --以下是销售出库未完全钩稽的应收余额情况
                  UNION ALL
                  SELECT    DATEADD(day, -1, @BeginDate) fdate ,
                            ' ' fcontractbillno ,
                            ' ' fbillno ,
                            b.FItemID fcustid ,
                            b.fnumber fcustnumber ,
                            b.fname fcustname ,
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
                            t_stock.FName stockname ,
                            ' ' funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            ' ' fnote
                  FROM      ICStockBillEntry u
                            INNER JOIN ICStockBill v ON v.FInterID = u.FInterID
                            INNER JOIN dbo.t_Organization b ON b.FItemID = v.FSupplyID
                            INNER JOIN t_stock ON u.FDCStockID = t_stock.FItemID
                  WHERE     FDate >= DATEADD(month, -1, @BeginDate)
                            AND FDate <= DATEADD(day, -1, @BeginDate)
                            AND FTranType = 21
                            AND FCancellation = 0
                            AND FAllHookQTY <> FQty
                  GROUP BY  b.FItemID ,
                            b.fnumber ,
                            b.fname ,
                            t_stock.FName
                          --u.fscstockid            
                    
                    
                    
                  ---以上是期初余额表
                  
                  
                  
                  UNION ALL
                  SELECT    v.fdate fdate ,
                            v.fcontractbillno ,
                            v.fbillno ,
                            v.fcustid ,
                            v.fcustnumber ,
                            v.fcustname ,
                            0 beginbalance ,
                             v.sellprice1 ,
                              v.sellqty1 ,
                              v.sellamount1 ,
                            v.sellprice ,
                            v.sellqty ,
                            v.sellamount ,
                            v.fhookqty ,
                            v.fhookprice ,
                            v.FhookAMOUNT ,
                            v.fmodel ,
                            v.fitemname ,
                            v.stockname ,
                            v.funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            v.fnote
                  FROM      ( SELECT    a.fdate fdate ,
                                        b.FEntrySelfB0180 fcontractbillno ,
                                        a.fbillno ,
                                        a.fsupplyid fcustid ,
                                        c.fnumber fcustnumber ,
                                        c.fname fcustname ,
                                        SUM(b.fqty) sellprice1 ,
                                        AVG(b.FConsignPrice)  sellqty1 ,
                                        SUM(b.fconsignamount) sellamount1 ,
                                        0 sellqty ,
                                        0 sellprice ,
                                        0 sellamount ,
                                        0 fhookqty ,
                                        0 fhookprice ,
                                        0 FhookAMOUNT ,                       
                                     
                                        d.fmodel ,
                                        d.fname fitemname ,
                                        t_stock.FName stockname ,
                                        e.fname funitname ,
                                        b.fnote fnote
                              FROM      icstockbill a
                                        INNER JOIN icstockbillentry b ON a.finterid = b.finterid
                                        INNER JOIN t_organization c ON a.fsupplyid = c.fitemid
                                        INNER JOIN t_icitem d ON b.fitemid = d.fitemid
                                        INNER JOIN t_measureunit e ON d.funitid = e.fmeasureunitid
                                        INNER JOIN t_stock ON t_stock.FItemID = b.FDCStockID
                        
                              WHERE     a.fdate BETWEEN @BeginDate AND @EndDate
                                        AND ftrantype = '21'
                                        AND fcancellation = 0
                              GROUP BY  a.fdate ,
                                        b.FEntrySelfB0180 ,
                                        a.fbillno ,
                                        a.fsupplyid ,
                                        c.fnumber ,
                                        c.fname ,
                                        d.fmodel ,
                                        d.fname ,
                                        e.fname ,
                                        b.fnote ,
                                        b.FConsignPrice ,
                                        --b.FSCStockID
                                        t_stock.FName
                            ) v
                            
                            
                            
                            
  --以上是出库的总金额表
                  UNION ALL
                  SELECT    v.fdate fdate ,
                            v.fcontractbillno ,
                            v.fbillno ,
                            v.fcustid ,
                            v.fcustnumber ,
                            v.fcustname ,
                            0 beginbalance ,
                            0 sellprice1 ,
                            0 sellqty1 ,
                            0 sellamount1 ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            v.fhookqty ,
                            v.fhookprice ,
                            v.FhookAMOUNT ,
                            v.fmodel ,
                            v.fitemname ,
                            v.stockname ,
                            v.funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            v.fnote
                  FROM      ( SELECT    a.fdate fdate ,
                                        b.FEntrySelfB0180 fcontractbillno ,
                                        a.fbillno ,
                                        a.fsupplyid fcustid ,
                                        c.fnumber fcustnumber ,
                                        c.fname fcustname ,
                                        SUM(b.fqty - t8.FQty) sellqty ,
                                       --  SUM(b.fconsignamount-t8.FAmount) sellamount ,
                                       -- SUM(b.fconsignamount-t8.FAmount) sellamount ,
                                        SUM(( b.fqty - t8.FQty )
                                            * FConsignPrice) sellamount ,
                                        SUM(t8.FQty) fhookqty ,
                                        AVG(t8.FPrice) fhookprice ,
                                        SUM(t8.FAmount) AS FhookAMOUNT ,
                                --SUM(b.fconsignamount) / SUM(b.fqty) sellprice ,
                                        b.FConsignPrice sellprice ,
                                        d.fmodel ,
                                        d.fname fitemname ,
                                        t_stock.FName stockname ,
                                        e.fname funitname ,
                                        b.fnote fnote
                              FROM      icstockbill a
                                        INNER JOIN icstockbillentry b ON a.finterid = b.finterid
                                        INNER JOIN t_organization c ON a.fsupplyid = c.fitemid
                                        INNER JOIN t_icitem d ON b.fitemid = d.fitemid
                                        INNER JOIN t_measureunit e ON d.funitid = e.fmeasureunitid
                                        INNER JOIN t_stock ON t_stock.FItemID = b.FDCStockID
                                        INNER JOIN ( SELECT FSourceBillNo ,
                                                            FQty ,
                                                            FPrice ,
                                                            FAmount
                                                     FROM   icsaleentry
                                                   ) t8 ON t8.FSourceBillNo = a.FBillNo
                              WHERE     a.fdate BETWEEN @BeginDate AND @EndDate
                                        AND ftrantype = '21'
                                        AND fcancellation = 0
                              GROUP BY  a.fdate ,
                                        b.FEntrySelfB0180 ,
                                        a.fbillno ,
                                        a.fsupplyid ,
                                        c.fnumber ,
                                        c.fname ,
                                        d.fmodel ,
                                        d.fname ,
                                        e.fname ,
                                        b.fnote ,
                                        b.FConsignPrice ,
                                        --b.FSCStockID
                                        t_stock.FName
                            ) v
                            
                            
              -- spk3_2str @sname='icsaleentry'             
                            
----销售出库单 
                  UNION ALL
                  SELECT    a.ffincdate fdate ,
                            ' ' fcontractbillno ,
                            a.fnumber fbillno ,
                            a.fcustomer fcustid ,
                            b.fnumber fcustnumber ,
                            b.fname fcustname ,
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
                            a.famount frecieved ,
                            0 fdiscount ,
                            fexplanation fnote
                  FROM      t_rp_contact a
                            INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                  WHERE     a.fdate BETWEEN @BeginDate AND @EndDate
                            AND ftype = '5'
                            AND frp = '1'
                            
                           -- spk3_2tab @sname='t_rp_contact'
                             -- spk3_2str @sname='t_rp_contact'
---收款单(退款单)           
                  UNION ALL
                  SELECT    a.ffincdate fdate ,
                            ' ' fcontractbillno ,
                            a.fnumber fbillno ,
                            a.fcustomer fcustid ,
                            b.fnumber fcustnumber ,
                            b.fname fcustname ,
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
                            a.famount fdiscount ,
                            fexplanation fnote
                  FROM      t_rp_contact a
                            INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                  WHERE     a.fdate BETWEEN @BeginDate AND @EndDate
                            AND ftype = '1'
                            AND frp = '1'
---其他应收单      
                  
                ) x      
        
        
        WHERE   fcustnumber BETWEEN @BegCustNo AND @EndCustNo
        GROUP BY fcustnumber
        ORDER BY --fcustnumber ,
                fdate ,
                orderNum ,
                stockname

    END