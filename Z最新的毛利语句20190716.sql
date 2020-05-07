	    DECLARE @fyear INT 
	    DECLARE @fmonth INT  
	    SET @fyear=2019 
	    SET @fmonth=6
	    DECLARE @p3 DATETIME
        DECLARE @p4 DATETIME
        EXEC GetPeriodStartEnd @fyear, @fmonth, @p3 OUTPUT, @p4 OUTPUT

	
		SELECT      V1.FBillNo ,
		            V1.FInterID,
		            V2.FEntryID,
		            V2.FDCStockID,		            
			        v2.FItemID ,
					v1.FSupplyID ,
				    t2.fnumber,
				    t2.fname,
					v1.FDeptID ,
					v1.FEmpID ,
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
					) t8
			WHERE   v1.FInterID = v2.FInterID
					AND v1.FStatus > 0
					AND v1.FCancelLation = 0
					AND v2.FItemID = t1.FItemID
					AND v1.FSupplyID = t2.FItemID
				
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
						
			SELECT * FROM #TEMPDATA1	ORDER BY FBillNo,FEntryID	
								
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
    SELECT * FROM #TEMPDATA2			
					
	SELECT A.*,B.* FROM #TEMPDATA1 A,#TEMPDATA2 B WHERE 	A.FBillNo=B.FSourceBillNo 
	AND A.fitemid=B.fitemid		and fcustid=fsupplyid	and b.fsourceentryid=a.fentryid
	
	
	DROP TABLE #TEMPDATA1
	DROP TABLE #TEMPDATA2
	
	
	
					