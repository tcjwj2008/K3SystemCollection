USE [AISDF_DFYX]
GO
/****** Object:  StoredProcedure [dbo].[Sp_SummaryOfGrossProfitOnSale_Qiu]    Script Date: 08/08/2019 11:34:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /******销售出库存储qiu*/
 Alter  PROC [dbo].[Sp_OutboundDelivery_Qiu] @BeginDate INT, @EndDate INT
 AS
	BEGIN	 	    
	SET NOCOUNT ON
	SELECT     
		CONVERT(VARCHAR(20),v1.fdate,23) AS 单据日期, 
		V1.FBillNo as 单据编号,
		t_Stock.fnumber 仓库编号,
		t_stock.fname as 仓库名称,
		t1.fnumber as 货品编号,
		t1.fname as 货品名称,
		t2.fnumber 客户代码,
		t2.fname 客户名称,
		CAST(v2.FAuxQty AS DECIMAL(18,4)) as 销售数量,	
		CAST(v2.FAmount  AS DECIMAL(18,2)) as  '成本金额',			
		CAST(v2.FConsignPrice  AS DECIMAL(18,4))   as 销售单价,
		CAST(v2.FConsignAmount   AS DECIMAL(18,2))as '销售收入',
		CAST(v2.FConsignAmount -v2.FAmount AS DECIMAL(18,2))as 收益金额,
		CAST((CASE WHEN v2.FConsignAmount = 0 THEN 0
		ELSE (v2.FConsignAmount -v2.FAmount )
			 /v2.FConsignAmount 
		END) AS DECIMAL(18,2)) AS 收益率     
		
	FROM    ICStockBill v1 ,
			ICStockBillEntry v2 ,
			t_ICItem t1 ,
			t_Organization t2 ,
			t_Stock
			
	WHERE   v1.FInterID = v2.FInterID
			AND v1.FStatus > 0
			AND v1.FCancelLation = 0
			AND v2.FItemID = t1.FItemID
			AND v1.FSupplyID = t2.FItemID
			and t_stock.FItemID=v2.fdcstockid			
			AND ( ( EXISTS ( SELECT FItemID
							 FROM   t_Stock
							 WHERE  FItemID = v2.FSCStockID
									AND FIncludeAccounting = 1 ) )
				  OR ( EXISTS ( SELECT  FItemID
								FROM    t_Stock
								WHERE   FItemID = v2.FDCStockID
										AND FIncludeAccounting = 1 ) )
				) 
				and v1.FDate between @BeginDate and @EndDate
				and FAmount<>0 	
						
			ORDER BY FBillNo ,FDate	
	END