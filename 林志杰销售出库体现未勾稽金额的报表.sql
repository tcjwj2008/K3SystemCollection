USE [AIS_YXRZP2]
GO
/****** Object:  StoredProcedure [dbo].[SP_StockBillOut_Unbilled_qiu]    Script Date: 08/21/2019 08:59:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--- Author:Qiu
-- =============================================
ALTER PROCEDURE [dbo].[SP_StockBillOut_Unbilled_qiu]
    @BegDate DATE ,
    @EndDate DATE
AS
    BEGIN
        SET NOCOUNT ON;

     SELECT TOP 600000
          -- u1.*,
                CONVERT(VARCHAR(100), v1.FDate, 23) AS 日期 ,
                v1.FBillNo AS 单据编号 ,
                t4.FNumber AS 购货单位编码 ,
                t4.FName AS 购货单位名称 ,
                t14.FNumber AS 物料编码 ,
                t14.FName AS 物料名称 ,
                t14.FModel AS 规格 ,
                t30.FName AS 基本单位 ,
                t17.FName AS 单位 ,
                CONVERT(DECIMAL(18, 6), CASE WHEN ( REPLACE(t17.FName, '袋', '') = '' )
                                             THEN 0
                                             WHEN ( REPLACE(t17.FName, '袋', '') = 0 )
                                             THEN 0
                                             ELSE     ( u1.FQty - u1.FAllHookQTY ) 
                                                  / ( REPLACE(t17.FName, '袋',
                                                              '') * 1000 )
                                        END) AS 未开票数量 ,
                                        
                                      --   u1.FQty - u1.FAllHookQTY,
                CONVERT(DECIMAL(18, 4), u1.FConsignPrice) AS 销售单价 ,
                CONVERT(DECIMAL(18, 6), ( CONVERT(DECIMAL(18, 6), CASE
                                                              WHEN ( REPLACE(t17.FName,
                                                              '袋', '') = '' )
                                                              THEN 0
                                                              WHEN ( REPLACE(t17.FName,
                                                              '袋', '') = 0 )
                                                              THEN 0
                                                              ELSE ( u1.FQty - u1.FAllHookQTY )
                                                              / ( REPLACE(t17.FName,
                                                              '袋', '') * 1000 )
                                                              END) )
                * ( CONVERT(DECIMAL(18, 4), u1.FConsignPrice) )) AS 未开票金额
        FROM    ICStockBill v1
                INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                  AND u1.FInterID <> 0
                INNER JOIN t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                AND t4.FItemID <> 0
                LEFT OUTER JOIN t_SubMessage t7 ON v1.FSaleStyle = t7.FInterID
                                                   AND t7.FInterID <> 0
                INNER JOIN t_ICItem t14 ON u1.FItemID = t14.FItemID
                                           AND t14.FItemID <> 0
                INNER JOIN t_MeasureUnit t30 ON t14.FUnitID = t30.FItemID
                                                AND t30.FItemID <> 0
                INNER JOIN t_MeasureUnit t17 ON u1.FUnitID = t17.FItemID
                                                AND t17.FItemID <> 0
        WHERE   -- v1.FBillNo = 'XOUT085916' AND
                ( v1.FDate BETWEEN @BegDate AND @EndDate )
                AND ( v1.FTranType = 21 )
                AND t14.FNumber LIKE '8.08%'
                
                ORDER BY v1.FDate,v1.FBillNo

    END;
