USE [AISDF_DFYX]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Forwards_Qiu]    Script Date: 03/30/2020 09:55:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /******销售毛利汇总表存储qiu*/
ALTER PROC [dbo].[Sp_Forwards_Qiu] @fyear INT, @fmonth INT --[Sp_Forwards_Qiu] 2020,1
AS
    BEGIN	 	    
        SET NOCOUNT ON;
        BEGIN TRAN;
	 
	 
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
                               END ) AS FAMOUNT ,
                v2.FEntrySelfB0180 AS hth
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
						
	--SELECT * FROM #TEMPDATA1;
								
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
                v2.FMTONo ,
                '' AS hth
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
 
        SELECT  1 flag ,
                A.hth ,
                CONVERT(VARCHAR(20), A.FDate, 23) AS 单据日期 ,
                A.FBillNo AS 单据编号 ,
                A.stockNo 仓库编号 ,
                A.stockName AS 仓库名称 ,
                A.itemNo AS 货品编号 ,
                A.itemName AS 货品名称 ,
                A.FNumber 客户代码 ,
                A.FName 客户名称 ,
                CAST(A.FHookQty AS DECIMAL(18, 4)) AS 成本数量 ,
                CAST(A.FAMOUNT AS DECIMAL(18, 2)) AS '成本金额' ,
                CAST(B.FHookQty AS DECIMAL(18, 4)) AS 销售数量 ,
                CAST(B.fAMOUNT AS DECIMAL(18, 2)) AS '销售收入' ,
                CAST(B.fAMOUNT - A.FAMOUNT AS DECIMAL(18, 2)) AS 收益金额 ,
                CAST(( CASE WHEN A.FAMOUNT = 0 THEN 0
                            ELSE ( B.fAMOUNT - A.FAMOUNT ) / B.fAMOUNT
                       END ) AS DECIMAL(18, 2)) AS 收益率
        INTO    #tempdata3
        FROM    #TEMPDATA1 A ,
                #TEMPDATA2 B
        WHERE   A.FInterID = B.FSourceInterId
                AND A.FItemID = B.FItemID
                AND FCustID = FSupplyID
                AND B.FSourceEntryID = A.FEntryID;
      


        INSERT  INTO #tempdata3
                SELECT  2 flag ,
                        '' hth ,
                        '合计' AS 单据日期 ,
                        '' AS 单据编号 ,
                        '' 仓库编号 ,
                        '' AS 仓库名称 ,
                        '' AS 货品编号 ,
                        '' AS 货品名称 ,
                        '' 客户代码 ,
                        '' 客户名称 ,
                        SUM(CAST(A.FHookQty AS DECIMAL(18, 4))) AS 成本数量 ,
                        SUM(CAST(A.FAMOUNT AS DECIMAL(18, 2))) AS '成本金额' ,
                        SUM(CAST(B.FHookQty AS DECIMAL(18, 4))) AS 销售数量 ,
                        SUM(CAST(B.fAMOUNT AS DECIMAL(18, 2))) AS '销售收入' ,
                        SUM(CAST(B.fAMOUNT - A.FAMOUNT AS DECIMAL(18, 2))) AS 收益金额 ,
                        SUM(CAST(( CASE WHEN A.FAMOUNT = 0 THEN 0
                                        ELSE ( B.fAMOUNT - A.FAMOUNT )
                                             / B.fAMOUNT
                                   END ) AS DECIMAL(18, 2))) AS 收益率
                FROM    #TEMPDATA1 A ,
                        #TEMPDATA2 B
                WHERE   A.FInterID = B.FSourceInterId
                        AND A.FItemID = B.FItemID
                        AND FCustID = FSupplyID
                        AND B.FSourceEntryID = A.FEntryID;
      
	

        SELECT  flag ,
                @fyear * 12 + @fmonth AS 期间核对值 ,
                @fyear AS 年度 ,
                @fmonth AS 期间 ,
                hth AS 合同号 ,
                       -- 单据日期 ,
                       -- 单据编号 ,
                仓库编号 ,
                仓库名称 ,
                货品编号 ,
                货品名称 ,
                客户代码 ,
                客户名称 ,
                SUM(成本数量) AS 成本数量 ,
                SUM(成本金额) AS 成本金额 ,
                SUM(销售数量) AS 销售数量 ,
                SUM(销售收入) AS 销售收入 ,
                SUM(收益金额) AS 收益金额 ,
                AVG(收益率) AS 收益率
        INTO    #tempdata4
        FROM    #tempdata3
        GROUP BY flag ,
                hth ,
                仓库编号 ,
                仓库名称 ,
                货品编号 ,
                货品名称 ,
                客户代码 ,
                客户名称; 
        --ORDER BY flag ,                        
        --        --单据日期 ,
        --        --单据编号 ,
        --        仓库编号 ,
        --        货品编号 ,
        --        客户代码; 
        
        
        ALTER TABLE #tempdata4 ADD 期货当期平仓数量 FLOAT;
        ALTER TABLE #tempdata4 ADD 期货盈亏    FLOAT;
        ALTER TABLE #tempdata4 ADD 期货手续费    FLOAT;        
        ALTER TABLE #tempdata4 ADD 本期确认期货盈亏    FLOAT;
                
        ALTER TABLE #tempdata4 ADD 核销数量 FLOAT;
        ALTER TABLE #tempdata4 ADD 核销金额    FLOAT;
        ALTER TABLE #tempdata4 ADD 转下期确认期货数量    FLOAT;        
        ALTER TABLE #tempdata4 ADD 转下期确认期货盈亏    FLOAT;
        
        


-----------------------------期货当期平仓数量-----------------------------------------


        UPDATE  #tempdata4
        SET     期货当期平仓数量 = ISNULL(cc.FDecimal3,0)
      
     --SELECT
        FROM    #tempdata4
                INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                INNER JOIN ( SELECT fyear1,fmonth1,fstock, ftext1 ,FBase5,FBase2,SUM(FDecimal3) AS FDecimal3
                             FROM   dbo.t_forwardEntry  GROUP BY fyear1,fmonth1,fstock, ftext1 ,FBase5,FBase2
                           ) cc ON #tempdata4.年度 = cc.fyear1
                                   AND #tempdata4.期间 = cc.fmonth1
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.FText1
                                   AND cc.FBase5 = t_ICItem.FItemID
                                   AND cc.FBase2 = dbo.t_Organization.FItemID;
       
           
           
    
           
      
-----------------------------期货盈亏----------------------------------------------

        UPDATE  #tempdata4
        SET     期货盈亏 = ISNULL(cc.FDecimal2,0)      
     --SELECT      
        FROM    #tempdata4
                INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                INNER JOIN ( SELECT fyear1,fmonth1,fstock, ftext1 ,FBase5,FBase2,SUM(FDecimal2) AS FDecimal2
                             FROM   dbo.t_forwardEntry  GROUP BY fyear1,fmonth1,fstock, ftext1 ,FBase5,FBase2
                           ) cc ON #tempdata4.年度 = cc.fyear1
                                   AND #tempdata4.期间 = cc.fmonth1
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.FText1
                                   AND cc.FBase5 = t_ICItem.FItemID
                                   AND cc.FBase2 = dbo.t_Organization.FItemID;


-----------------------------期货手续费----------------------------------------------
    
     
        UPDATE  #tempdata4
        SET     期货手续费 = ISNULL(cc.Fsxmoney,0)      
     --SELECT      
        FROM    #tempdata4
                INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                INNER JOIN ( SELECT fyear1,fmonth1,fstock, ftext1 ,FBase5,FBase2,SUM(Fsxmoney) AS Fsxmoney
                             FROM   dbo.t_forwardEntry  GROUP BY fyear1,fmonth1,fstock, ftext1 ,FBase5,FBase2
                           
                           ) cc ON #tempdata4.年度 = cc.fyear1
                                   AND #tempdata4.期间 = cc.fmonth1
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.FText1
                                   AND cc.FBase5 = t_ICItem.FItemID
                                   AND cc.FBase2 = dbo.t_Organization.FItemID;  
           
           
      



-----------------------------核销数量----------------------------------------------

        UPDATE  #tempdata4
        SET     核销数量 = ISNULL(cc.fhxsl,0)      
        --SELECT      
        FROM    #tempdata4
                INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                INNER JOIN ( SELECT *
                             FROM   dbo.t_forwardEntry
                           ) cc ON #tempdata4.年度 = cc.fyear1
                                   AND #tempdata4.期间 = cc.fmonth1
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.FText1
                                   AND cc.FBase5 = t_ICItem.FItemID
                                   AND cc.FBase2 = dbo.t_Organization.FItemID;
           
-----------------------------核销金额----------------------------------------------

        UPDATE  #tempdata4
        SET     核销金额 = ISNULL(cc.fhxje,0)      
     --SELECT      
        FROM    #tempdata4
             INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                INNER JOIN ( SELECT *
                             FROM   dbo.t_forwardEntry
                           ) cc ON #tempdata4.年度 = cc.fyear1
                                   AND #tempdata4.期间 = cc.fmonth1
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.FText1
                                   AND cc.FBase5 = t_ICItem.FItemID
                                   AND cc.FBase2 = dbo.t_Organization.FItemID;

           
/*
-----------------------------核销数量----------------------------------------------

        UPDATE  #tempdata4
        SET     核销数量 = cc.FDecimal1      
        --SELECT      
        FROM    #tempdata4
                INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                INNER JOIN ( SELECT *
                             FROM   dbo.t_BOS200000002Entry2
                           ) cc ON #tempdata4.期间核对值 = cc.fyearmonth
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.ffcontent
                                   AND cc.fnumber = t_ICItem.FItemID
                                   AND cc.FBase4 = dbo.t_Organization.FItemID; 
           
-----------------------------核销金额----------------------------------------------

        UPDATE  #tempdata4
        SET     核销金额 = cc.fmoney      
     --SELECT      
        FROM    #tempdata4
                INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                INNER JOIN ( SELECT *
                             FROM   dbo.t_BOS200000002Entry2
                           ) cc ON #tempdata4.期间核对值 = cc.fyearmonth
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.ffcontent
                                   AND cc.fnumber = t_ICItem.FItemID
                                   AND cc.FBase4 = dbo.t_Organization.FItemID;  
           

*/           
           
-----------------------------转下期确认期货数量----------------------------------------------
        --调试用
        --SELECT * FROM      #tempdata4
        --        INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
        --        INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
        --        INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
        --        left JOIN ( SELECT *
        --                     FROM   dbo.t_BOS200000002Entry2
        --                   ) cc ON #tempdata4.期间核对值 = cc.fyearmonth + 1
        --                           AND cc.fstock = t_Stock.FItemID
        --                           AND #tempdata4.合同号 = cc.ffcontent
        --                           AND cc.fnumber = t_ICItem.FItemID
        --                           AND cc.FBase4 = dbo.t_Organization.FItemID;  
        --RETURN;
        UPDATE  #tempdata4
        SET     转下期确认期货数量 = ISNULL(cc.FDecimal,0)      
    --SELECT      
        FROM    #tempdata4
                INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                left JOIN ( SELECT *
                             FROM   dbo.t_BOS200000002Entry2
                           ) cc ON #tempdata4.期间核对值+ 1 = cc.fyearmonth 
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.ffcontent
                                   AND cc.fnumber = t_ICItem.FItemID
                                   AND cc.FBase4 = dbo.t_Organization.FItemID;  
           

      
           
-----------------------------转下期确认期货盈亏----------------------------------------------

        UPDATE  #tempdata4
        SET     转下期确认期货盈亏 = ISNULL(cc.fdecimal3,0)      
     --SELECT      
        FROM    #tempdata4
                INNER JOIN dbo.t_Stock ON #tempdata4.仓库编号 = dbo.t_Stock.FNumber
                INNER JOIN t_ICItem ON t_ICItem.FNumber = #tempdata4.货品编号
                INNER JOIN dbo.t_Organization ON t_Organization.FNumber = #tempdata4.客户代码
                left JOIN ( SELECT *
                             FROM   dbo.t_BOS200000002Entry2
                           ) cc ON #tempdata4.期间核对值+ 1 = cc.fyearmonth 
                                   AND cc.fstock = t_Stock.FItemID
                                   AND #tempdata4.合同号 = cc.ffcontent
                                   AND cc.fnumber = t_ICItem.FItemID
                                   AND cc.FBase4 = dbo.t_Organization.FItemID;  
           

-----------------------------本期确认期货盈亏----------------------------------------------

       
     --  UPDATE #tempdata4 SET 本期确认期货盈亏=cc.Fsxmoney      
     ----SELECT      
     -- FROM #tempdata4 INNER JOIN dbo.t_Stock 
     -- ON #tempdata4.仓库编号=dbo.t_Stock.FNumber
     -- INNER JOIN t_icitem ON t_icitem.FNumber=#tempdata4.货品编号
     -- INNER JOIN dbo.t_Organization ON t_organization.FNumber=#tempdata4.客户代码
     -- INNER joinvvvvvvvvvvvv
     --      cc
     --      ON #tempdata4.年度=cc.fyear AND #tempdata4.期间=cc.fmonth           
     --      AND cc.fstock=t_Stock.FItemID
     --      AND #tempdata4.合同号=cc.FText1
     --      AND cc.FBase5=t_icitem.FItemID
     --      AND cc.FBase2=dbo.t_Organization.FItemID 
     
     
   
     
            
        --UPDATE  #tempdata4
        --SET     本期确认期货盈亏 = ( ISNULL(#tempdata4.转下期确认期货盈亏,0)   + ISNULL(#tempdata4.期货盈亏,0)   )
        --        / ( CASE WHEN ( ( ISNULL(#tempdata4.转下期确认期货数量,0)   + ISNULL(#tempdata4.期货当期平仓数量,0)   )
        --                        * ISNULL(#tempdata4.销售数量,0)   ) <> 0
        --                 THEN ( ISNULL(#tempdata4.转下期确认期货数量,0)   + ISNULL(#tempdata4.期货当期平仓数量,0)   )
        --                      * ISNULL(#tempdata4.销售数量,0)  
        --                 ELSE 1
        --            END );   
        
        
        --   UPDATE  #tempdata4
        --SET     本期确认期货盈亏 = ( ISNULL(#tempdata4.转下期确认期货盈亏,0)   + ISNULL(#tempdata4.期货盈亏,0)   ) 
        --        / ( CASE WHEN ( ( ISNULL(#tempdata4.转下期确认期货数量,0)   + ISNULL(#tempdata4.期货当期平仓数量,0)   )*ISNULL(#tempdata4.销售数量,0) 
        --                        ) <> 0
        --                 THEN ( ISNULL(#tempdata4.转下期确认期货数量,0)   + ISNULL(#tempdata4.期货当期平仓数量,0)   )*  ISNULL(#tempdata4.销售数量,0) 
                            
        --                 ELSE 1
        --            END );       
        
        --   UPDATE  #tempdata4
        --SET     本期确认期货盈亏 = ( ISNULL(#tempdata4.期货盈亏,0)   ) 
        --        / ( CASE WHEN ( ( ISNULL(#tempdata4.期货当期平仓数量,0)   )*ISNULL(#tempdata4.销售数量,0) 
        --                        ) <> 0
        --                 THEN ( ISNULL(#tempdata4.期货当期平仓数量,0)   )*  ISNULL(#tempdata4.销售数量,0) 
                            
        --                 ELSE 1
        --            END );   
        
                   UPDATE  #tempdata4
        SET     本期确认期货盈亏 = ( ISNULL(#tempdata4.期货盈亏,0)   )   / CASE WHEN ( ISNULL(#tempdata4.期货当期平仓数量,0)   )=0 THEN 1 ELSE ( ISNULL(#tempdata4.期货当期平仓数量,0)   ) END  *ISNULL(#tempdata4.销售数量,0) 
                               
                  
                          
  
     ALTER TABLE #tempdata4 ADD 最终收益    FLOAT;
          UPDATE  #tempdata4
          SET     最终收益 =ISNULL(收益金额,0)-ISNULL(期货手续费,0)+ISNULL(本期确认期货盈亏,0)+ISNULL(核销金额,0)
  


   
  
        SELECT  *
        FROM    #tempdata4
        WHERE   1 = 1
        ORDER BY flag ,
                仓库编号 ,
                货品编号 ,
                客户代码; 

        DROP TABLE #TEMPDATA1;
        DROP TABLE #TEMPDATA2;
        DROP TABLE #tempdata3;
        DROP TABLE #tempdata4;	
        
        COMMIT;
    END;
