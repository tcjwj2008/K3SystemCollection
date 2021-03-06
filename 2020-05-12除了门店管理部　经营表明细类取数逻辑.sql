USE [YXERP]
GO
/****** Object:  StoredProcedure [dbo].[sp_sel_rsjybmx_new_qiu]    Script Date: 05/14/2020 11:19:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROC [dbo].[sp_sel_rsjybmx_new_qiu] --[sp_sel_rsjybmx_new_qiu] '2020-04-28','10.19'
    (
      @FDate VARCHAR(100) ,   --开始日期            
      @fdepnumber VARCHAR(100)--部门代码  
    )
AS
    BEGIN  
        DECLARE @BegDate1 VARCHAR(100);
        DECLARE @EndDate1 VARCHAR(100);
        SET @EndDate1 = @FDate;
        SET @BegDate1 = @FDate;
           
        SELECT  'R' AS ztname ,
                v.FDate ,
                '销售出库' AS billtype,               
                v.fbillno AS billno,
                w.FNumber AS wnumber ,
                t.FNumber AS dnumber ,
                CASE t.FNumber
                  WHEN '10.12' THEN u.FSecQty
                  WHEN '10.13' THEN u.FSecQty
                  ELSE 0.0000
                END FSecQty ,
                FAuxQty ,
                FConsignPrice ,
                FConsignAmount ,
                ISNULL(p.Fprice, 0.000) AS fCBprice
        INTO    #rsjybmx
        FROM    AIS_YXRY2.dbo.ICStockBillEntry u
                INNER JOIN AIS_YXRY2.dbo.ICStockBill v ON v.FInterID = u.FInterID
                INNER JOIN AIS_YXRY2.dbo.t_Item w ON w.FItemID = u.FItemID
                                                     AND FItemClassID = 4
                LEFT JOIN AIS_YXRY2.dbo.t_Department t ON t.FItemID = v.FDeptID
                LEFT JOIN yx_rs_ysprice p ON p.Fnumber = w.FNumber
                                             AND p.FDATE = v.FDate
                LEFT JOIN AIS_YXRY2.dbo.t_Stock s ON s.FItemID = u.FDCStockID
        WHERE   v.FTranType = 21
                AND v.FCancellation = 0
                AND v.FDate BETWEEN @BegDate1 AND @EndDate1
                AND t.FNumber >= '10.12'
                AND t.FNumber <= '10.18'
                AND t.FNumber <> '10.14'
                AND CHARINDEX('号', s.FName) = 0
                --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                AND w.FNumber NOT LIKE '7.1.02%'
                AND w.FNumber NOT LIKE '8.8.02.02%'
                AND w.FNumber NOT LIKE '8.8.03.02%';    
  
  
--从肉业取数, 加入10.19   
        INSERT  INTO #rsjybmx
                ( ztname ,
                  FDate ,
                  billtype,
                  billno,
                  wnumber ,
                  dnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  FConsignAmount ,
                  fCBprice
                )
                SELECT  'R' AS ztname ,
                        v.FDate ,
                         '销售出库' AS billtype,               
                v.fbillno AS billno,
                        w.FNumber AS wnumber ,
                        t.FNumber AS dnumber ,
                        CASE t.FNumber
                          WHEN '10.12' THEN u.FSecQty
                          WHEN '10.13' THEN u.FSecQty
                          ELSE 0.0000
                        END FSecQty ,
                        FQty ,
                        FConsignPrice ,
                        FConsignAmount ,
                        ISNULL(p.Fprice, 0.000) AS fCBprice
                FROM    AIS_YXRY2.dbo.ICStockBillEntry u
                        INNER JOIN AIS_YXRY2.dbo.ICStockBill v ON v.FInterID = u.FInterID
                        INNER JOIN AIS_YXRY2.dbo.t_Item w ON w.FItemID = u.FItemID
                                                             AND FItemClassID = 4
                        LEFT JOIN AIS_YXRY2.dbo.t_Department t ON t.FItemID = v.FDeptID
                        LEFT JOIN yx_rs_ysprice p ON p.Fnumber = w.FNumber
                                                     AND p.FDATE = v.FDate
                        LEFT JOIN AIS_YXRY2.dbo.t_Stock s ON s.FItemID = u.FDCStockID
                WHERE   v.FTranType = 21
                        AND v.FCancellation = 0
                        AND v.FDate BETWEEN @BegDate1 AND @EndDate1
                        AND t.FNumber = '10.19'
                        AND CHARINDEX('号', s.FName) = 0
                        AND CHARINDEX('小副', t.FName) > 0
            --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                        AND w.FNumber NOT LIKE '7.1.02%'
                        AND w.FNumber NOT LIKE '8.8.02.02%'
                        AND w.FNumber NOT LIKE '8.8.03.02%'; 

--从肉业取数, 加入10.20   
        INSERT  INTO #rsjybmx
                ( ztname ,
                  FDate ,
                  billtype,billno,
                  wnumber ,
                  dnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  FConsignAmount ,
                  fCBprice
                )
                SELECT  'R' AS ztname ,
                        v.FDate ,
                           '销售出库' AS billtype,               
                v.fbillno AS billno,
                        w.FNumber AS wnumber ,
                        t.FNumber AS dnumber ,
                        CASE t.FNumber
                          WHEN '10.12' THEN u.FSecQty
                          WHEN '10.13' THEN u.FSecQty
                          ELSE 0.0000
                        END FSecQty ,
                        FQty ,
                        FConsignPrice ,
                        FConsignAmount ,
                        ISNULL(p.Fprice, 0.000) AS fCBprice
                FROM    AIS_YXRY2.dbo.ICStockBillEntry u
                        INNER JOIN AIS_YXRY2.dbo.ICStockBill v ON v.FInterID = u.FInterID
                        INNER JOIN AIS_YXRY2.dbo.t_Item w ON w.FItemID = u.FItemID
                                                             AND FItemClassID = 4
                        LEFT JOIN AIS_YXRY2.dbo.t_Department t ON t.FItemID = v.FDeptID
                        LEFT JOIN yx_rs_ysprice p ON p.Fnumber = w.FNumber
                                                     AND p.FDATE = v.FDate
                        LEFT JOIN AIS_YXRY2.dbo.t_Stock s ON s.FItemID = u.FDCStockID
                WHERE   v.FTranType = 21
                        AND v.FCancellation = 0
                        AND v.FDate BETWEEN @BegDate1 AND @EndDate1
                        AND t.FNumber = '10.20'
                        AND CHARINDEX('号', s.FName) = 0
                    
            --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                        AND w.FNumber NOT LIKE '7.1.02%'
                        AND w.FNumber NOT LIKE '8.8.02.02%'
                        AND w.FNumber NOT LIKE '8.8.03.02%'; 
                    
                    

--从肉业取数, 加入10.21   
        INSERT  INTO #rsjybmx
                ( ztname ,
                  FDate ,billtype,billno,
                  wnumber ,
                  dnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  FConsignAmount ,
                  fCBprice
                )
                SELECT  'R' AS ztname ,
                        v.FDate ,
                           '销售出库' AS billtype,               
                v.fbillno AS billno,
                        w.FNumber AS wnumber ,
                        t.FNumber AS dnumber ,
                        CASE t.FNumber
                          WHEN '10.12' THEN u.FSecQty
                          WHEN '10.13' THEN u.FSecQty
                          ELSE 0.0000
                        END FSecQty ,
                        FQty ,
                        FConsignPrice ,
                        FConsignAmount ,
                        ISNULL(p.Fprice, 0.000) AS fCBprice
                FROM    AIS_YXRY2.dbo.ICStockBillEntry u
                        INNER JOIN AIS_YXRY2.dbo.ICStockBill v ON v.FInterID = u.FInterID
                        INNER JOIN AIS_YXRY2.dbo.t_Item w ON w.FItemID = u.FItemID
                                                             AND FItemClassID = 4
                                                             AND w.FNumber NOT LIKE '8%'
                        LEFT JOIN AIS_YXRY2.dbo.t_Department t ON t.FItemID = v.FDeptID
                        LEFT JOIN yx_rs_ysprice p ON p.Fnumber = w.FNumber
                                                     AND p.FDATE = v.FDate
                        LEFT JOIN AIS_YXRY2.dbo.t_Stock s ON s.FItemID = u.FDCStockID
                WHERE   v.FTranType = 21
                        AND v.FCancellation = 0
                        AND v.FDate BETWEEN @BegDate1 AND @EndDate1
                        AND t.FNumber = '10.21'
                        AND CHARINDEX('号', s.FName) = 0
              --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                        AND w.FNumber NOT LIKE '7.1.02%'
                        AND w.FNumber NOT LIKE '8.8.02.02%'
                        AND w.FNumber NOT LIKE '8.8.03.02%';
                    

--从食品取数      
        INSERT  INTO #rsjybmx
                ( ztname ,
                  FDate ,billtype,billno,
                  wnumber ,
                  dnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  FConsignAmount ,
                  fCBprice
                )
                SELECT  'S' AS ztname ,
                        v.FDate ,
                           '销售出库' AS billtype,               
                v.fbillno AS billno,
                        w.FNumber AS wnumber ,
                        t.FNumber AS dnumber ,
                        CASE t.FNumber
                          WHEN '10.12' THEN u.FSecQty
                          WHEN '10.13' THEN u.FSecQty
                          ELSE 0.0000
                        END FSecQty ,
                        FAuxQty ,
                        FConsignPrice ,
                        FConsignAmount ,
                        ISNULL(p.Fprice, 0.000) AS fCBprice
                FROM    AIS_YXSP2.dbo.ICStockBillEntry u
                        INNER JOIN AIS_YXSP2.dbo.ICStockBill v ON v.FInterID = u.FInterID
                        INNER JOIN AIS_YXSP2.dbo.t_Item w ON w.FItemID = u.FItemID
                                                             AND FItemClassID = 4
                        LEFT JOIN AIS_YXSP2.dbo.t_Department t ON t.FItemID = v.FDeptID
                        LEFT JOIN yx_rs_ysprice p ON p.Fnumber = w.FNumber
                                                     AND p.FDATE = v.FDate
                        LEFT JOIN AIS_YXSP2.dbo.t_Stock s ON s.FItemID = u.FDCStockID
                WHERE   v.FTranType = 21
                        AND v.FCancellation = 0
                        AND v.FDate BETWEEN @BegDate1 AND @EndDate1
                        AND t.FNumber >= '10.12'
                        AND t.FNumber <= '10.18'
                        AND t.FNumber <> '10.14'
                        AND CHARINDEX('号', s.FName) = 0
             --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                        AND w.FNumber NOT LIKE '7.1.02%'
                        AND w.FNumber NOT LIKE '8.8.02.02%'
                        AND w.FNumber NOT LIKE '8.8.03.02%';  
                      

        INSERT  INTO #rsjybmx
                ( ztname ,
                  FDate ,billtype,billno,
                  wnumber ,
                  dnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  FConsignAmount ,
                  fCBprice
                )
                SELECT  'S' AS ztname ,
                        v.FDate ,   '销售出库' AS billtype,               
                v.fbillno AS billno,
                        w.FNumber AS wnumber ,
                        t.FNumber AS dnumber ,
                        CASE t.FNumber
                          WHEN '10.12' THEN u.FSecQty
                          WHEN '10.13' THEN u.FSecQty
                          ELSE 0.0000
                        END FSecQty ,
                        FAuxQty ,
                        FConsignPrice ,
                        FConsignAmount ,
                        ISNULL(p.Fprice, 0.000) AS fCBprice
                FROM    AIS_YXSP2.dbo.ICStockBillEntry u
                        INNER JOIN AIS_YXSP2.dbo.ICStockBill v ON v.FInterID = u.FInterID
                        INNER JOIN AIS_YXSP2.dbo.t_Item w ON w.FItemID = u.FItemID
                                                             AND FItemClassID = 4
                        LEFT JOIN AIS_YXSP2.dbo.t_Department t ON t.FItemID = v.FDeptID
                        LEFT JOIN yx_rs_ysprice p ON p.Fnumber = w.FNumber
                                                     AND p.FDATE = v.FDate
                        LEFT JOIN AIS_YXSP2.dbo.t_Stock s ON s.FItemID = u.FDCStockID
                WHERE   v.FTranType = 21
                        AND v.FCancellation = 0
                        AND v.FDate BETWEEN @BegDate1 AND @EndDate1
                        AND t.FNumber = '10.20'
                        AND CHARINDEX('号', s.FName) = 0
                    
                    --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                        AND w.FNumber NOT LIKE '7.1.02%'
                        AND w.FNumber NOT LIKE '8.8.02.02%'
                        AND w.FNumber NOT LIKE '8.8.03.02%';    


        INSERT  INTO #rsjybmx
                ( ztname ,
                  FDate ,billtype,billno,
                  wnumber ,
                  dnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  FConsignAmount ,
                  fCBprice
                )
                SELECT  'S' AS ztname ,
                        v.FDate ,
                           '销售出库' AS billtype,               
                v.fbillno AS billno,
                        w.FNumber AS wnumber ,
                        t.FNumber AS dnumber ,
                        CASE t.FNumber
                          WHEN '10.12' THEN u.FSecQty
                          WHEN '10.13' THEN u.FSecQty
                          ELSE 0.0000
                        END FSecQty ,
                        FAuxQty ,
                        FConsignPrice ,
                        FConsignAmount ,
                        ISNULL(p.Fprice, 0.000) AS fCBprice
                FROM    AIS_YXSP2.dbo.ICStockBillEntry u
                        INNER JOIN AIS_YXSP2.dbo.ICStockBill v ON v.FInterID = u.FInterID
                        INNER JOIN AIS_YXSP2.dbo.t_Item w ON w.FItemID = u.FItemID
                                                             AND FItemClassID = 4
                                                             AND w.FNumber NOT LIKE '8.%'
                        LEFT JOIN AIS_YXSP2.dbo.t_Department t ON t.FItemID = v.FDeptID
                        LEFT JOIN yx_rs_ysprice p ON p.Fnumber = w.FNumber
                                                     AND p.FDATE = v.FDate
                        LEFT JOIN AIS_YXSP2.dbo.t_Stock s ON s.FItemID = u.FDCStockID
                WHERE   v.FTranType = 21
                        AND v.FCancellation = 0
                        AND v.FDate BETWEEN @BegDate1 AND @EndDate1
                        AND t.FNumber = '10.21'
                        AND CHARINDEX('号', s.FName) = 0
                    --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                        AND w.FNumber NOT LIKE '7.1.02%'
                        AND w.FNumber NOT LIKE '8.8.02.02%'
                        AND w.FNumber NOT LIKE '8.8.03.02%';  


 
   
        ALTER TABLE #rsjybmx ADD FCBAmount FLOAT;       
      
      
 
         
        INSERT  INTO #rsjybmx
                ( ztname ,
                  dnumber ,
                  billtype,billno,
                  wnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  fCBprice,
                  FDate ,
                  FConsignAmount
                )
                SELECT  'R' ,
                        AIS_YXRY2.dbo.t_Department.FNumber AS 部门代码 ,
                        '其他应收',AIS_YXRY2.dbo.t_RP_ARPBill.FNumber,
                        '其他收入' ,
                        0 ,
                        0 ,
                        0 ,
                        0,
                        CONVERT(VARCHAR(100), AIS_YXRY2.dbo.t_RP_ARPBill.FDate, 23) AS 日期 ,
                        ISNULL(SUM(ROUND(ISNULL(AIS_YXRY2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                0),
                                         AIS_YXRY2.dbo.t_Currency.FScale)),
                               0.00) AS FAmountFor_2
                FROM    AIS_YXRY2.dbo.t_RP_ARPBill
                        LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar ON AIS_YXRY2.dbo.t_RP_ARPBill.FBillID = AIS_YXRY2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXRY2.dbo.t_RP_Plan_Ar.FIsInit = 0
                        LEFT  JOIN AIS_YXRY2.dbo.t_Currency ON AIS_YXRY2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXRY2.dbo.t_Currency.FCurrencyID
                                                              AND AIS_YXRY2.dbo.t_Currency.FCurrencyID <> 0
                        LEFT  JOIN AIS_YXRY2.dbo.t_Department ON AIS_YXRY2.dbo.t_RP_ARPBill.FDepartment = AIS_YXRY2.dbo.t_Department.FItemID
                                                              AND AIS_YXRY2.dbo.t_Department.FItemID <> 0
                WHERE   ( DATEDIFF(DAY, @BegDate1,
                                   AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0
                          AND DATEDIFF(DAY, @EndDate1,
                                       AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0
                          AND AIS_YXRY2.dbo.t_Department.FNumber IN ( '10.12',
                                                              '10.13' )
                        )
                        AND AIS_YXRY2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                GROUP BY AIS_YXRY2.dbo.t_Department.FNumber ,
                        CONVERT(VARCHAR(100), AIS_YXRY2.dbo.t_RP_ARPBill.FDate, 23),AIS_YXRY2.dbo.t_RP_ARPBill.FNumber;
                                        
        INSERT  INTO #rsjybmx
                ( ztname ,
                  dnumber ,billtype,billno,
                  wnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  fCBprice,
                  FDate ,
                  FConsignAmount
                )
                SELECT  'S' ,
                        AIS_YXSP2.dbo.t_Department.FNumber AS 部门代码 ,
                         '其他应收',AIS_YXSP2.dbo.t_RP_ARPBill.FNumber,
                        '其他收入' ,
                        0 ,
                        0 ,
                        0 ,
                        0,
                        CONVERT(VARCHAR(100), AIS_YXSP2.dbo.t_RP_ARPBill.FDate, 23) AS 日期 ,
                        ISNULL(SUM(ROUND(ISNULL(AIS_YXSP2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                0),
                                         AIS_YXSP2.dbo.t_Currency.FScale)),
                               0.00) AS FAmountFor_2
                FROM    AIS_YXSP2.dbo.t_RP_ARPBill
                        LEFT JOIN AIS_YXSP2.dbo.t_RP_Plan_Ar ON AIS_YXSP2.dbo.t_RP_ARPBill.FBillID = AIS_YXSP2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXSP2.dbo.t_RP_Plan_Ar.FIsInit = 0
                        LEFT  JOIN AIS_YXSP2.dbo.t_Currency ON AIS_YXSP2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXSP2.dbo.t_Currency.FCurrencyID
                                                              AND AIS_YXSP2.dbo.t_Currency.FCurrencyID <> 0
                        LEFT  JOIN AIS_YXSP2.dbo.t_Department ON AIS_YXSP2.dbo.t_RP_ARPBill.FDepartment = AIS_YXSP2.dbo.t_Department.FItemID
                                                              AND AIS_YXSP2.dbo.t_Department.FItemID <> 0
                WHERE   ( DATEDIFF(DAY, @BegDate1,
                                   AIS_YXSP2.dbo.t_RP_ARPBill.FDate) >= 0
                          AND DATEDIFF(DAY, @EndDate1,
                                       AIS_YXSP2.dbo.t_RP_ARPBill.FDate) <= 0
                          AND AIS_YXSP2.dbo.t_Department.FNumber IN ( '10.12',
                                                              '10.13' )
                        )
                        AND AIS_YXSP2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                GROUP BY AIS_YXSP2.dbo.t_Department.FNumber ,AIS_YXSP2.dbo.t_RP_ARPBill.FNumber,
                        CONVERT(VARCHAR(100), AIS_YXSP2.dbo.t_RP_ARPBill.FDate, 23);                                      
                                        

        INSERT  INTO #rsjybmx
                ( ztname ,
                  dnumber ,billtype,BILLNO,
                  wnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  fCBprice,
                  FDate ,
                  FConsignAmount
                )
                SELECT  'R' ,
                        AIS_YXRY2.dbo.t_Department.FNumber AS 部门代码 ,
                         '其他应收',AIS_YXRY2.dbo.t_RP_ARPBill.FNumber,
                        '其他收入' ,
                        0 ,
                        0 ,
                        0 ,
                        0,
                        CONVERT(VARCHAR(100), AIS_YXRY2.dbo.t_RP_ARPBill.FDate, 23) AS 日期 ,
                        ISNULL(SUM(ROUND(ISNULL(AIS_YXRY2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                0),
                                         AIS_YXRY2.dbo.t_Currency.FScale)),
                               0.00) AS FAmountFor_2
                FROM    AIS_YXRY2.dbo.t_RP_ARPBill
                        LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar ON AIS_YXRY2.dbo.t_RP_ARPBill.FBillID = AIS_YXRY2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXRY2.dbo.t_RP_Plan_Ar.FIsInit = 0
                        LEFT  JOIN AIS_YXRY2.dbo.t_Currency ON AIS_YXRY2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXRY2.dbo.t_Currency.FCurrencyID
                                                              AND AIS_YXRY2.dbo.t_Currency.FCurrencyID <> 0
                        LEFT  JOIN AIS_YXRY2.dbo.t_Department ON AIS_YXRY2.dbo.t_RP_ARPBill.FDepartment = AIS_YXRY2.dbo.t_Department.FItemID
                                                              AND AIS_YXRY2.dbo.t_Department.FItemID <> 0
                WHERE   ( DATEDIFF(DAY, @BegDate1,
                                   AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0
                          AND DATEDIFF(DAY, @EndDate1,
                                       AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0
                          AND AIS_YXRY2.dbo.t_Department.FNumber IN ( '10.15',
                                                              '10.16', '10.17',
                                                              '10.19', '10.20',
                                                              '10.21' )
                        )
                        AND AIS_YXRY2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                GROUP BY AIS_YXRY2.dbo.t_Department.FNumber ,AIS_YXRY2.dbo.t_RP_ARPBill.FNumber,
                        CONVERT(VARCHAR(100), AIS_YXRY2.dbo.t_RP_ARPBill.FDate, 23);


        INSERT  INTO #rsjybmx
                ( ztname ,
                  dnumber ,billtype,BILLNO,
                  wnumber ,
                  FSecQty ,
                  FAuxQty ,
                  FConsignPrice ,
                  fCBprice,
                  FDate ,
                  FConsignAmount
                )
                SELECT  'S' ,
                        AIS_YXSP2.dbo.t_Department.FNumber AS 部门代码 ,
                        '其他应收',AIS_YXSP2.dbo.t_RP_ARPBill.FNumber,
                        '其他收入' ,
                        0 ,
                        0 ,
                        0 ,
                        0,
                        CONVERT(VARCHAR(100), AIS_YXSP2.dbo.t_RP_ARPBill.FDate, 23) AS 日期 ,
                        ISNULL(SUM(ROUND(ISNULL(AIS_YXSP2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                0),
                                         AIS_YXSP2.dbo.t_Currency.FScale)),
                               0.00) AS FAmountFor_2
                FROM    AIS_YXSP2.dbo.t_RP_ARPBill
                        LEFT JOIN AIS_YXSP2.dbo.t_RP_Plan_Ar ON AIS_YXSP2.dbo.t_RP_ARPBill.FBillID = AIS_YXSP2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXSP2.dbo.t_RP_Plan_Ar.FIsInit = 0
                        LEFT  JOIN AIS_YXSP2.dbo.t_Currency ON AIS_YXSP2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXSP2.dbo.t_Currency.FCurrencyID
                                                              AND AIS_YXSP2.dbo.t_Currency.FCurrencyID <> 0
                        LEFT  JOIN AIS_YXSP2.dbo.t_Department ON AIS_YXSP2.dbo.t_RP_ARPBill.FDepartment = AIS_YXSP2.dbo.t_Department.FItemID
                                                              AND AIS_YXSP2.dbo.t_Department.FItemID <> 0
                WHERE   ( DATEDIFF(DAY, @BegDate1,
                                   AIS_YXSP2.dbo.t_RP_ARPBill.FDate) >= 0
                          AND DATEDIFF(DAY, @EndDate1,
                                       AIS_YXSP2.dbo.t_RP_ARPBill.FDate) <= 0
                          AND AIS_YXSP2.dbo.t_Department.FNumber IN ( '10.15' )
                        )
                        AND AIS_YXSP2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                GROUP BY AIS_YXSP2.dbo.t_Department.FNumber ,AIS_YXSP2.dbo.t_RP_ARPBill.FNumber,
                        CONVERT(VARCHAR(100), AIS_YXSP2.dbo.t_RP_ARPBill.FDate, 23);


ALTER TABLE #rsjybmx ADD billgo VARCHAR(100);

---分类计算收入成本      
--成本和收入列需要计算 
--肉业部门为 10.12 10.13的 收入直接计算 成本/Ｘ         
        UPDATE  #rsjybmx
        SET     FConsignAmount = FConsignAmount ,
                FCBAmount = ROUND(FAuxQty * fCBprice / 0.91, 2),
                billgo='收入系数不变，成本系数除以0.91'
        WHERE   ztname = 'R'
                AND dnumber IN ( '10.12', '10.13' );      
--食品部门为 10.12 10.13的 收入直接计算 成本/Ｘ      
        UPDATE  #rsjybmx
        SET     FConsignAmount = FConsignAmount ,
                FCBAmount = ROUND(FAuxQty * fCBprice / 0.91, 2),
                billgo='收入系数不变，成本系数除以0.91'
        WHERE   ztname = 'S'
                AND dnumber IN ( '10.12', '10.13' );      
--其他 收入/1.13 成本直接计算      
        UPDATE  #rsjybmx
        SET     FConsignAmount = ROUND(FConsignAmount / 1.09, 2) ,
                FCBAmount = ROUND(FAuxQty * fCBprice, 2),
                billgo='收入系数除以1.09，成本系数不变'
        WHERE   dnumber NOT  IN ( '10.12', '10.13' );  
        
        
        UPDATE  #rsjybmx
        SET    
                billgo=''
        WHERE   billtype='其他应收';      
        
        
        
        SELECT  ztname AS 账套m ,
                FDate 日期 ,
                billtype 单据类型,
                billno 单据号,
                wnumber 物料代码 ,
                dnumber AS 部门代码 ,
                FSecQty 头数 ,
                FAuxQty 数量 ,
                FConsignPrice 销售单价 ,
                FConsignAmount 收入,
                fCBprice 成本单价 ,
                fcbamount 成本,
                billgo 系数
               
        FROM    #rsjybmx
        WHERE   dnumber = @fdepnumber
        UNION ALL
        SELECT  '合计' AS 账套m ,
                '' 日期 ,
   '' 单据类型,
                '' 单据号,                '' 物料代码 ,
                '' AS 部门代码 ,
               
                SUM(FSecQty) 头数 ,
                SUM(FAuxQty) 数量 ,
                AVG(FConsignPrice) 销售单价 ,
                SUM(FConsignAmount) 收入,
                AVG(fCBprice) 成本单价 ,
                SUM(fcbamount) 成本,
                '' 系数
        FROM    #rsjybmx
        WHERE   dnumber = @fdepnumber;
        DROP TABLE #rsjybmx;
     
     
     
              
    END; 
   

