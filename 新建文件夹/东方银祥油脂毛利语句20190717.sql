USE [Test_AISDF_DFYX]
GO
/****** Object:  StoredProcedure [dbo].[Sp_SummaryOfGrossProfitOnSale_Qiu]    Script Date: 07/17/2019 13:36:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /******销售毛利汇总表存储qiu*/
 ALTER PROC [dbo].[Sp_SummaryOfGrossProfitOnSale_Qiu] @fyear INT, @fmonth INT
 AS
    BEGIN	 	    
        SET NOCOUNT ON
	 
	    DECLARE @p3 DATETIME
        DECLARE @p4 DATETIME
        EXEC GetPeriodStartEnd @fyear, @fmonth, @p3 OUTPUT, @p4 OUTPUT

	
		SELECT      V1.FBillNo ,
		            V1.FInterID,
		            V2.FEntryID,
		            V2.FDCStockID,	
		            t_Stock.fnumber as stockNo,
		            t_stock.fname AS stockName,	            
			        v2.FItemID ,
			        t1.fnumber as itemNo,
			        t1.fname as itemName,
					v1.FSupplyID ,
				    t2.fnumber,
				    t2.fname,			
					t8.FHookQty ,
					(v2.FAmount * CASE WHEN v2.FQty = 0 THEN 0
									  ELSE ( CAST(t8.FHookQty AS DECIMAL(28, 10))
											 / CAST(v2.FQty AS DECIMAL(28, 10)) )
								 END ) AS FAMOUNT
					
					INTO #TEMPDATA1
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
					) t8,
					t_Stock
					
			WHERE   v1.FInterID = v2.FInterID
					AND v1.FStatus > 0
					AND v1.FCancelLation = 0
					AND v2.FItemID = t1.FItemID
					AND v1.FSupplyID = t2.FItemID
				    and t_stock.FItemID=v2.fdcstockid
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
						
						
						
						
					ORDER BY FBillNo 	
						
		--	SELECT * FROM #TEMPDATA1	ORDER BY FBillNo,FEntryID	
								
				SELECT 
				   v2.fsourceentryid,
				   V2.FSourceBillNo, 
				   V1.FInterID,
				   V2.FEntryID,
				   v2.FItemID ,
					v1.FCustID ,
					v1.FDeptID ,
					v1.FEmpID ,
					t8.FHookQty ,
					(ROUND(CASE v1.FTranType
							WHEN 80 THEN v2.FStdAmount
							ELSE ( v2.FStdAmount - v2.FStdTaxAmount )
						  END, 2) * CASE WHEN v2.FQty = 0 THEN 0
										 ELSE ( CAST(t8.FHookQty AS DECIMAL(28, 10))
												/ CAST(v2.FQty AS DECIMAL(28, 10)) )
									END ) AS fAMOUNT,
					v2.FMTONo
					INTO #TEMPDATA2
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
					AND v1.FCancelLation = 0
					AND v1.FSubSystemID <> 1				
					AND v2.FItemID = t1.FItemID
					AND v1.FCustID = t2.FItemID				
					ORDER BY FSourceBillNo 	
  --  SELECT * FROM #TEMPDATA2			
					
	SELECT A.FBillNo as 单据编号,A.stockNo 仓库编号,A.stockname as 仓库名称,A.itemNo as 货品编号,
	A.itemName as 货品名称,
	A.fnumber 客户代码,
	A.fname 客户名称,
	a.fhookqty as 成本数量,
	a.famount as  '成本金额(勾稽)',
	b.fhookqty as 销售数量,
	b.famount as '销售金额(勾稽)',
	b.famount-a.famount as 收益金额,
	round((CASE WHEN a.famount = 0 THEN 0
									  ELSE (b.famount-a.famount)
											 / b.famount
								 END ),2) AS 收益率 FROM #TEMPDATA1 A,#TEMPDATA2 B WHERE 	A.FBillNo=B.FSourceBillNo 
	AND A.fitemid=B.fitemid		and fcustid=fsupplyid	and b.fsourceentryid=a.fentryid
	order by a.stockNo,a.itemNo,a.fnumber
	
	DROP TABLE #TEMPDATA1
	DROP TABLE #TEMPDATA2
	
    END