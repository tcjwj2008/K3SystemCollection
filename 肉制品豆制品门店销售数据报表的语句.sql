USE [AIS_YXSP2]
GO
/****** Object:  StoredProcedure [dbo].[yx_SaleReport]    Script Date: 05/08/2020 10:42:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  PROCEDURE [dbo].[yx_SaleReport_QIU] ( @OrderDate DATETIME )
AS
    SET ANSI_NULLS ON;    
    SET NOCOUNT ON;    
    SET ANSI_WARNINGS ON;    
    SELECT  T.*
    FROM    ( SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        u1.FAuxQty AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'RZP' AS 账套
              FROM      AIS_YXRZP2.dbo.ICStockBill v1
                        INNER JOIN AIS_YXRZP2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN AIS_YXRZP2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN AIS_YXRZP2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '01.03.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
           -- AND V1.FStatuS = 1
           
     -------------------------------------------------------------------------------        
              UNION ALL
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        16 AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND t14.FNumber = '8.01.040'  
            
-----------------------------------------------------------------------------
              UNION ALL
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        u1.FAuxQty * 0.5 AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND t14.FNumber IN ( '8.05.010' )
              UNION ALL
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        u1.FAuxQty * 1.5 AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND t14.FNumber IN ( '8.05.021', '8.05.041' )            
            
/*剔除数量是0.0001的赠品 和代码为8.09.031物料*/
              UNION ALL
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        u1.FAuxQty  AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND t14.FNumber IN ( '8.09.031' )

 
                       
           
   -------------------------------------------------------------------------------        
              UNION ALL
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        u1.FAuxQty * 10 AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND t14.FNumber IN ( '8.03.020' )            
            
            
--------------------------------------------------------------------------------            
              UNION ALL
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        u1.FAuxQty * 2 AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND t14.FNumber IN ( '8.03.041', '8.03.051',
                                             '8.03.101' )
              UNION ALL
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        u1.FAuxQty * 18 AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND t14.FNumber = '8.01.050'
			  /*对于赠品数量的处理*/
              UNION ALL
              
         
             
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        FEntrySelfB0159 AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND u1.FAuxQty = 0.0001
              UNION ALL
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        t4.FNumber AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        CONVERT(INT, SUBSTRING(t14.FModel, 1, 2)) * u1.FAuxQty AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND CHARINDEX('板', t14.FModel) > 0
                        AND ISNUMERIC(SUBSTRING(t14.FModel, 1, 2)) = 1
                        AND t14.FNumber NOT IN ( '8.01.050', '8.01.040',
                                                 '8.03.041', '8.03.051',
                                                 '8.03.101', '8.03.020',
                                                 '8.05.010', '8.05.041',
                                                 '8.05.021', '8.09.031' )
              UNION ALL
              /*取规格没有"板"字符的*/
              SELECT    CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                        t4.FName AS 客户名 ,
                        CONVERT(VARCHAR(50), t4.FNumber) AS 客户代码 ,
                        t14.FName AS 品名 ,
                        t14.FNumber AS 品名代码 ,
                        u1.FAuxQty AS 数量 ,
                        t14.FModel AS 规格 ,
                        u1.FConsignPrice AS 单价 ,
                        'DZP' AS 账套
              FROM      CON18.AIS_YXDZP2018.dbo.ICStockBill v1
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                        INNER JOIN CON18.AIS_YXDZP2018.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
              WHERE     1 = 1
                        AND ( v1.FDate = @OrderDate
                              AND ISNULL(t4.FNumber, '') LIKE '05.01.%'
                            )
                        AND ( v1.FTranType = 21
                              AND ( v1.FCancellation = 0 )
                            )
                        AND u1.FAuxQty <> 0.0001
                        AND CHARINDEX('板', t14.FModel) = 0
                        AND t14.FNumber NOT IN ( '8.01.050', '8.01.040',
                                                 '8.03.041', '8.03.051',
                                                 '8.03.101', '8.03.020',
                                                 '8.05.010', '8.05.041',
                                                 '8.05.021', '8.09.031' )
              UNION ALL
              
         
              
              
              
              
              SELECT    CONVERT(VARCHAR(100), T_SubRKD.FSubRKDate, 23) AS 日期 ,
                        dbo.t_Item_3001.FName AS 客户名 ,
                        dbo.t_Item_3001.FNumber AS 客户代码 ,
                        t_ICItem.FName AS 品名 ,
                        t_ICItem.FNumber AS 品名代码 ,
                        T_SubRKDEntry.FSubRKDQty AS 数量 ,
                        t_ICItem.FModel AS 规格 ,
                        T_SubRKDEntry.FSubRKDPrice AS 单价 ,
                        'SP' AS 账套
              FROM      T_SubRKD
                        LEFT JOIN T_SubRKDEntry ON T_SubRKD.FID = T_SubRKDEntry.FID
                        LEFT  JOIN t_Supplier ON T_SubRKD.FSubSupplier = t_Supplier.FItemID
                                                 AND t_Supplier.FItemID <> 0
                        LEFT  JOIN t_Organization ON T_SubRKD.FSubCustomid = t_Organization.FItemID
                                                     AND t_Organization.FItemID <> 0
                        LEFT  JOIN t_Item_3001 ON T_SubRKD.FSubID = t_Item_3001.FItemID
                                                  AND t_Item_3001.FItemID <> 0
                        LEFT  JOIN t_ICItem ON T_SubRKDEntry.FSubRKDItemID = t_ICItem.FItemID
                                               AND t_ICItem.FItemID <> 0
              WHERE     T_SubRKD.FSubRKDate = @OrderDate
                        AND T_SubRKD.FClassTypeID = 200000004
            ) T
    ORDER BY T.账套;
     
