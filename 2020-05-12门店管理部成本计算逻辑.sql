USE [YXERP];
GO
/****** Object:  StoredProcedure [dbo].[sp_sel_rsjybmdsl_qiu]    Script Date: 05/12/2020 09:13:33 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER   PROC [dbo].[sp_sel_rsjybmdcb_qiu] -- [sp_sel_rsjybmdcb_qiu] '2020-05-02','10.11'
    (
      @FDate VARCHAR(100) ,   --开始日期            
      @fdepnumber VARCHAR(100)--部门代码  
    )
AS
    BEGIN  
        DECLARE @EndDate2 VARCHAR(100);
        SET @EndDate2 = CONVERT(VARCHAR(100), DATEADD(DAY, 1,
                                                      CONVERT(DATETIME, @FDate)));

        SELECT  CONVERT(VARCHAR(12), v.FDate, 23) 日期 ,
                '10.11' 部门代码 ,
                '门店管理部' 部门名称 ,
                v.FBillNo 单号 ,
                m.FNumber 物料代码 ,
                m.FName 物料名称 ,
                FAuxQty 基本验收数量 ,
                CONVERT(NUMERIC(10, 2), ( p.Fprice ), 2) 单价 ,               
                ( ISNULL(p.Fprice, 0.000) * FAuxQty ) / 0.91 成本 ,
                '出入库0.91' AS 类型系数
        INTO    #t01
        FROM    AIS_YXRY2.dbo.ICStockBill v
                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry e ON v.FInterID = e.FInterID
                INNER JOIN AIS_YXRY2.dbo.t_ICItem m ON e.FItemID = m.FItemID
                INNER JOIN AIS_YXRY2.dbo.t_Department t ON v.FDeptID = t.FItemID
                                                           AND t.FNumber = '10.11'
                LEFT JOIN yx_rs_ysprice p ON p.Fnumber = m.FNumber
                                             AND p.FDATE = v.FDate
        WHERE   v.FDate = @FDate
                AND FTranType = 21
                AND FCancellation = 0
                         --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                AND m.FNumber NOT LIKE '7.1.02%'
                AND m.FNumber NOT LIKE '8.8.02.02%'
                AND m.FNumber NOT LIKE '8.8.03.02%';
            
            --GROUP BY 
            --CONVERT(VARCHAR(12), v.FDate, 23),
            --m.fnumber,
            --m.fname
  
        INSERT  INTO #t01
                SELECT  CONVERT(VARCHAR(100), v.FSubRKDate, 23) AS 日期 ,
                        '10.11' 部门代码 ,
                        '门店管理部' 部门名称 ,
                        v.FBillNo 单号 ,
                        t.FNumber 物料代码 ,
                        t.FName 物料名称 ,
                        ( u.Fcommitqty ) AS 基本验收数量 ,
                        CONVERT(NUMERIC(10, 2), ( p.Fprice ), 2) 单价 ,
                        ROUND(( u.Fcommitqty * ISNULL(p.Fprice, 0.00) / 0.91 ),
                              2) AS 成本 ,
                        '配送单0.91' AS 类型系数
                FROM    AIS_YXSP2.dbo.T_SubRKDEntry u
                        INNER JOIN AIS_YXSP2.dbo.T_SubRKD v ON v.FID = u.FID
                        INNER JOIN AIS_YXSP2.dbo.t_Item t ON t.FItemID = u.FSubRKDItemID
                                                             AND t.FItemClassID = 4
                                                             AND t.FNumber NOT LIKE '%7.1.03.%'
                                                                                                                 --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                                                             AND t.FNumber NOT LIKE '7.1.02%'
                                                             AND t.FNumber NOT LIKE '8.8.02.02%'
                                                             AND t.FNumber NOT LIKE '8.8.03.02%'
                        LEFT JOIN yx_rs_ysprice p ON p.Fnumber = t.FNumber
                                                     AND p.FDATE = v.FSubRKDate
                WHERE   FSubRKDate = @FDate;
            --GROUP BY v.FSubRKDate,
            --              t.FNumber ,
            --                t.FName;  
            
        INSERT  INTO #t01
                SELECT  CONVERT(VARCHAR(100), DATEADD(DAY, 1, v.FDate), 23) AS 日期 ,
                        '10.11' AS 部门代码 ,
                        '门店管理部' 部门名称 ,
                        v.FBillNo 单号 ,
                        t.FNumber 物料代码 ,
                        t.FName 物料名称 ,
                        0 AS 基本验收数量 ,
                        0 单价 ,
                     
                        CONVERT(NUMERIC(10, 2), ROUND(( u.FAmount ), 2)) AS 成本 ,
                        '上日结余0' AS 类型系数
                FROM    AIS_YXSP2.dbo.T_YX_SubInStockEntry u
                        INNER JOIN AIS_YXSP2.dbo.T_YX_SubInStock v ON v.FID = u.FID
                        INNER JOIN AIS_YXSP2.dbo.t_ICItem t ON t.FItemID = u.FItemId
                                                              AND t.FNumber NOT LIKE '%7.1.03.%'   -- 过滤山羊肉 
                                                                                                                      --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                                                              AND t.FNumber NOT LIKE '7.1.02%'
                                                              AND t.FNumber NOT LIKE '8.8.02.02%'
                                                              AND t.FNumber NOT LIKE '8.8.03.02%'
                WHERE   CONVERT(VARCHAR(100), DATEADD(DAY, 1, v.FDate), 23) = @FDate;
                        
           INSERT  INTO #t01
                SELECT  CONVERT(VARCHAR(100),  v.FDate, 23) AS 日期 ,
                        '10.11' AS 部门代码 ,
                        '门店管理部' 部门名称 ,
                        v.FBillNo 单号 ,
                        t.FNumber 物料代码 ,
                        t.FName 物料名称 ,
                        0 AS 基本验收数量 ,
                        0 单价 ,
                     
                        -1*CONVERT(NUMERIC(10, 2), ROUND(( u.FAmount ), 2)) AS 成本 ,
                        '本日结余0' AS 类型系数
                FROM    AIS_YXSP2.dbo.T_YX_SubInStockEntry u
                        INNER JOIN AIS_YXSP2.dbo.T_YX_SubInStock v ON v.FID = u.FID
                        INNER JOIN AIS_YXSP2.dbo.t_ICItem t ON t.FItemID = u.FItemId
                                                              AND t.FNumber NOT LIKE '%7.1.03.%'   -- 过滤山羊肉 
                                                                                                                      --过滤冻品7.1.02……、8.8.02.02……、8.8.03.02
                                                              AND t.FNumber NOT LIKE '7.1.02%'
                                                              AND t.FNumber NOT LIKE '8.8.02.02%'
                                                              AND t.FNumber NOT LIKE '8.8.03.02%'
                WHERE   CONVERT(VARCHAR(100),  v.FDate, 23) = @FDate;    
       
        SELECT  日期,部门代码,部门名称,单号,物料代码,物料名称,基本验收数量,单价,成本,类型系数
        FROM    #t01
        UNION ALL
        select 	日期,'','','','','',SUM(基本验收数量),SUM(成本)/SUM(基本验收数量),SUM(成本),'' FROM #t01 GROUP BY 日期
							 

          
       


  
    END; 

