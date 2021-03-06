USE [AISDF_DFYX];
GO
/****** Object:  StoredProcedure [dbo].[Sp_SummaryOfGrossProfitOnSale_Qiu]    Script Date: 2019-12-02 11:44:26 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
 /******销售毛利汇总表存储qiu*/
ALTER PROC [dbo].[Sp_SummaryOfGrossProfitOnSale_Qiu] @fyear INT, @fmonth INT
AS
    BEGIN	 	    
        SET NOCOUNT ON;
	 
        DECLARE @p3 DATETIME;
        DECLARE @p4 DATETIME;
        EXEC GetPeriodStartEnd @fyear, @fmonth, @p3 OUTPUT, @p4 OUTPUT;

	
        SELECT  v1.FBillNo ,
                v1.FDate ,
                v1.FInterID ,
                v2.FEntryID ,
                v2.FDCStockID ,
                t_Stock.FNumber AS stockNo ,
                t_Stock.FName AS stockName ,
                v2.FItemID ,
                t1.FNumber AS itemNo ,
                t1.FName AS itemName ,
                v1.FSupplyID ,
                t2.FNumber ,
                t2.FName ,
                t8.FHookQty ,
                ( v2.FAmount * CASE WHEN v2.FQty = 0 THEN 0
                                    ELSE ( CAST(t8.FHookQty AS DECIMAL(28, 10))
                                           / CAST(v2.FQty AS DECIMAL(28, 10)) )
                               END ) AS FAMOUNT
        INTO    #TEMPDATA1
        FROM    ICStockBill v1 ,
                ICStockBillEntry v2 ,
                t_ICItem t1 ,
                t_Organization t2 ,
                ( SELECT    SUM(FHookQty) AS FHookQty ,
                            FIBInterID ,
                            FEntryID
                  FROM      ICHookRelations
                  WHERE     FHookType = 1
                            AND FIBTag = 1
                            AND FYear = @fyear
                            AND FPeriod = @fmonth
                  GROUP BY  FIBInterID ,
                            FEntryID
                ) t8 ,
                t_Stock
        WHERE   v1.FInterID = v2.FInterID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v2.FItemID = t1.FItemID
                AND v1.FSupplyID = t2.FItemID
                AND t_Stock.FItemID = v2.FDCStockID
                AND t8.FIBInterID = v1.FInterID
                AND t8.FEntryID = v2.FEntryID
                AND ( ( EXISTS ( SELECT FItemID
                                 FROM   t_Stock
                                 WHERE  FItemID = v2.FSCStockID
                                        AND FIncludeAccounting = 1 ) )
                      OR ( EXISTS ( SELECT  FItemID
                                    FROM    t_Stock
                                    WHERE   FItemID = v2.FDCStockID
                                            AND FIncludeAccounting = 1 ) )
                    )
        ORDER BY FBillNo; 	
						
	
								
        SELECT  v2.FSourceEntryID ,
                v2.FSourceInterId ,
                v1.FInterID ,
                v2.FEntryID ,
                v2.FItemID ,
                v1.FCustID ,
                v1.FDeptID ,
                v1.FEmpID ,
                t8.FHookQty ,
                ( ROUND(CASE v1.FTranType
                          WHEN 80 THEN v2.FStdAmount
                          ELSE ( v2.FStdAmount - v2.FStdTaxAmount )
                        END, 2) * CASE WHEN v2.FQty = 0 THEN 0
                                       ELSE ( CAST(t8.FHookQty AS DECIMAL(28,
                                                              10))
                                              / CAST(v2.FQty AS DECIMAL(28, 10)) )
                                  END ) AS fAMOUNT ,
                v2.FMTONo
        INTO    #TEMPDATA2
        FROM    ICSale v1 ,
                ICSaleEntry v2 ,
                t_ICItem t1 ,
                t_Organization t2 ,
                ( SELECT    SUM(FHookQty) AS FHookQty ,
                            FIBInterID ,
                            FEntryID
                  FROM      ICHookRelations
                  WHERE     FHookType = 1
                            AND FIBTag = 0
                            AND FYear = @fyear
                            AND FPeriod = @fmonth
                  GROUP BY  FIBInterID ,
                            FEntryID
                ) t8
        WHERE   v1.FInterID = v2.FInterID
                AND v1.FInterID = t8.FIBInterID
                AND v2.FEntryID = t8.FEntryID
                AND v1.FStatus > 0
                AND v1.FCancellation = 0
                AND v1.FSubSystemID <> 1
                AND v2.FItemID = t1.FItemID
                AND v1.FCustID = t2.FItemID
                AND v1.FDate BETWEEN @p3 AND @p4
        ORDER BY FSourceBillNo; 	
  --  SELECT * FROM #TEMPDATA2			
					
        SELECT  1 flag,CONVERT(VARCHAR(20), A.FDate, 23) AS 单据日期 ,
                A.FBillNo AS 单据编号 ,
                A.stockNo 仓库编号 ,
                A.stockName AS 仓库名称 ,
                A.itemNo AS 货品编号 ,
                A.itemName AS 货品名称 ,
                A.FNumber 客户代码 ,
                A.FName 客户名称 ,
                CAST(A.FHookQty AS DECIMAL(18, 4)) AS 成本数量 ,
                CAST(A.FAMOUNT AS DECIMAL(18, 2)) AS '成本金额(勾稽)' ,
                CAST(B.FHookQty AS DECIMAL(18, 4)) AS 销售数量 ,
                CAST(B.fAMOUNT AS DECIMAL(18, 2)) AS '销售收入(勾稽)' ,
                CAST(B.fAMOUNT - A.FAMOUNT AS DECIMAL(18, 2)) AS 收益金额 ,
                CAST(( CASE WHEN A.FAMOUNT = 0 THEN 0
                            ELSE ( B.fAMOUNT - A.FAMOUNT ) / B.fAMOUNT
                       END ) AS DECIMAL(18, 2)) AS 收益率

					   INTO #tempdata3
        FROM    #TEMPDATA1 A ,
                #TEMPDATA2 B
        WHERE   A.FInterID = B.FSourceInterId
                AND A.FItemID = B.FItemID
                AND FCustID = FSupplyID
                AND B.FSourceEntryID = A.FEntryID
    


				INSERT INTO #tempdata3
		      SELECT 2 flag,'合计' AS 单据日期 ,
                '' AS 单据编号 ,
               '' 仓库编号 ,
               '' AS 仓库名称 ,
                '' AS 货品编号 ,
               '' AS 货品名称 ,
                '' 客户代码 ,
              '' 客户名称 ,
               SUM( CAST(A.FHookQty AS DECIMAL(18, 4))) AS 成本数量 ,
                SUM(  CAST(A.FAMOUNT AS DECIMAL(18, 2))) AS '成本金额(勾稽)' ,
                SUM(  CAST(B.FHookQty AS DECIMAL(18, 4))) AS 销售数量 ,
               SUM(   CAST(B.fAMOUNT AS DECIMAL(18, 2))) AS '销售收入(勾稽)' ,
                SUM(  CAST(B.fAMOUNT - A.FAMOUNT AS DECIMAL(18, 2))) AS 收益金额 ,
               SUM(   CAST(( CASE WHEN A.FAMOUNT = 0 THEN 0
                            ELSE ( B.fAMOUNT - A.FAMOUNT ) / B.fAMOUNT
                       END ) AS DECIMAL(18, 2))) AS 收益率
        FROM    #TEMPDATA1 A ,
                #TEMPDATA2 B
        WHERE   A.FInterID = B.FSourceInterId
                AND A.FItemID = B.FItemID
                AND FCustID = FSupplyID
                AND B.FSourceEntryID = A.FEntryID
      
	

	SELECT * FROM #tempdata3
	    ORDER BY flag,单据日期 ,
               单据编号 ,
               仓库编号,
               货品编号 ,
                客户代码; 

        DROP TABLE #TEMPDATA1;
        DROP TABLE #TEMPDATA2;
		DROP TABLE #tempdata3;
	
    END;