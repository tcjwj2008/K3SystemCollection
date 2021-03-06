USE [YXERP]
GO
/****** Object:  StoredProcedure [dbo].[ICSale_fgc]    Script Date: 12/19/2019 15:40:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--参数为勾稽序号(支持多个序号进行勾稽)
ALTER PROCEDURE [dbo].[ICSale_fgc] ( @saleno VARCHAR(100) )
AS
    DECLARE @saleno1 VARCHAR(100)
    DECLARE @FYear1 VARCHAR(20)
    DECLARE @FPeriod1 VARCHAR(20)
    DECLARE @saledate1 VARCHAR(20)
    DECLARE @checkcount int
    

    --定义销售组号
    SELECT  @saleno1 = @saleno 
        --判断能否钩稽发票(参数弃用)
    
	--    SELECT @checkcount=COUNT(*) FROM ICHookRelations WHERE  FIBTag=0 and FGroupNo=@saleno1
	--and FHookType=1

	--    IF @checkcount>0
	--    BEGIN
	--     --RAISERROR ('Can not do it backwards', 16, 1)
	--     RETURN;
	--    END   
    --查找单据日期
    SELECT  @saledate1 = MAX(FDate)
    FROM    ICHookRelations
    WHERE   FIBTag = 0
            AND FGroupNO = @saleno1   
    --查找单据会计日期              
    SELECT  @FPeriod1 = FPeriod ,
            @FYear1 = FYear
    FROM    T_PeriodDate
    WHERE   @saledate1 >= FStartDate
            AND @saledate1 <= FEndDate
    
  

	
    SET XACT_ABORT ON -- 打开全部回滚标志
    BEGIN TRANSACTION
     
    --插入临时表  反勾数基础数据生成  fibtag=0单据
    SELECT  FIBInterID FInterID ,
            FHookQty * ( -1 ) FHookQty ,
            FEntryID ,
            FYear ,
            FPeriod
    INTO    #tmpInterID
    FROM    ICHookRelations
    WHERE   FIBTag = 0
            AND FGroupNo = @saleno1
    SELECT  FIBInterID FInterID ,  --fibtag=1发票
            FHookQty * ( -1 ) FHookQty ,
            FEntryID ,
            FYear ,
            FPeriod
    INTO    #tmpSTInterID
    FROM    ICHookRelations
    WHERE   FIBTag = 1
            AND FGroupNo = @saleno1        
     --1恢复原始状态 对于费用数据清空原始状态  FIBTAG=2 费用单据
    UPDATE  t1
    SET     FDistribute = 0 ,
            FHookInterID = 0 ,
            FHookerID = 0 ,
            FYearPeriod = ''
    FROM    ICExpenses t1 ,
            ICHookRelations t2
    WHERE   t1.FInterID = t2.FIBInterID
            AND t2.FIBTag = 2
            AND t2.FGroupNo = @saleno1
        
     --2修改单据明细勾数!!! 
    UPDATE  u1
    SET     u1.FAllHookQTY = u1.FAllHookQTY + t2.FHookQty ,
            u1.FStdAllHookAmount = ( CASE WHEN u1.FAllHookQTY + t2.FHookQty
                                               - u1.FQty = 0
                                          THEN ( u1.FStdAmount
                                                 - ( CASE WHEN v1.FTranType IN (
                                                              76, 86 )
                                                          THEN u1.FStdTaxAmount
                                                          ELSE 0
                                                     END ) )
                                          WHEN u1.FAllHookQTY + t2.FHookQty = 0
                                          THEN 0
                                          ELSE u1.FStdAllHookAmount
                                               + CAST(( u1.FStdAmount
                                                        - ( CASE
                                                              WHEN v1.FTranType IN (
                                                              76, 86 )
                                                              THEN u1.FStdTaxAmount
                                                              ELSE 0
                                                            END ) )
                                               * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                     END ) ,
            u1.FAllHookAmount = ( CASE WHEN u1.FAllHookQTY + t2.FHookQty
                                            - u1.FQty = 0
                                       THEN ( u1.FAmount
                                              - ( CASE WHEN v1.FTranType IN (
                                                            76, 86 )
                                                       THEN u1.FTaxAmount
                                                       ELSE 0
                                                  END ) )
                                       WHEN u1.FAllHookQTY + t2.FHookQty = 0
                                       THEN 0
                                       ELSE u1.FAllHookAmount
                                            + CAST(( u1.FAmount
                                                     - ( CASE WHEN v1.FTranType IN (
                                                              76, 86 )
                                                              THEN u1.FTaxAmount
                                                              ELSE 0
                                                         END ) )
                                            * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                  END )
    FROM    #tmpInterID t2
            INNER JOIN ICSaleEntry u1 ON t2.FInterID = u1.FInterID
                                         AND t2.FEntryID = u1.FEntryID
            INNER JOIN ICSale v1 ON v1.FInterID = u1.FInterID
                
                
                
--3修改明细单据
    UPDATE  u1
    SET     u1.FCurrentHookQTY = u1.FCurrentHookQTY + t2.FHookQty ,
            u1.FStdCurrentHookAmount = ( CASE WHEN u1.FCurrentHookQTY
                                                   + t2.FHookQty = u1.FQty
                                              THEN u1.FStdAmount
                                                   - ( CASE WHEN v1.FTranType IN (
                                                              76, 86 )
                                                            THEN u1.FStdTaxAmount
                                                            ELSE 0
                                                       END )
                                              WHEN u1.FAllHookQTY = 0 THEN 0
                                              ELSE u1.FStdCurrentHookAmount
                                                   + CAST(( u1.FStdAmount
                                                            - ( CASE
                                                              WHEN v1.FTranType IN (
                                                              76, 86 )
                                                              THEN u1.FStdTaxAmount
                                                              ELSE 0
                                                              END ) )
                                                   * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                         END ) ,
            u1.FCurrentHookAmount = ( CASE WHEN u1.FCurrentHookQTY
                                                + t2.FHookQty = u1.FQty
                                           THEN u1.FAmount
                                                - ( CASE WHEN v1.FTranType IN (
                                                              76, 86 )
                                                         THEN u1.FTaxAmount
                                                         ELSE 0
                                                    END )
                                           WHEN u1.FAllHookQTY = 0 THEN 0
                                           ELSE u1.FCurrentHookAmount
                                                + CAST(( u1.FAmount
                                                         - ( CASE
                                                              WHEN v1.FTranType IN (
                                                              76, 86 )
                                                              THEN u1.FTaxAmount
                                                              ELSE 0
                                                             END ) )
                                                * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                      END )
    FROM    #tmpInterID t2
            INNER JOIN ICSaleEntry u1 ON t2.FInterID = u1.FInterID
                                         AND t2.FEntryID = u1.FEntryID
            INNER JOIN ICSale v1 ON v1.FInterID = u1.FInterID
    WHERE   t2.FYear = @FYear1
            AND t2.FPeriod = @FPeriod1
            
            
    --4修改发票单据上数据  (关联了对应的FGROUPID)      
    UPDATE  t1
    SET     t1.FHookInterID = 0 ,
            t1.FHookerID = 0 ,
            t1.FYearPeriod = '' ,
            t1.FHookStatus = ( CASE WHEN ABS(v1.FSumHookQTY) = ABS(v1.FSumQty)
                                    THEN 2
                                    WHEN v1.FSumHookQTY = 0 THEN 0
                                    ELSE 1
                               END )
    FROM    ICSale t1
            INNER JOIN ( SELECT FInterID ,
                                SUM(FQty) FSumQty ,
                                SUM(FAllHookQTY) FSumHookQTY
                         FROM   ICSaleEntry
                         GROUP BY FInterID
                       ) v1 ON t1.FInterID = v1.FInterID
            INNER JOIN ( SELECT DISTINCT
                                FInterID
                         FROM   #tmpInterID
                       ) t2 ON t2.FInterID = v1.FInterID         
            
       
       
       
    --5对应类型单据的修改--------------------------------------------------
    
    UPDATE  u2
    SET     u2.FStdAllHookAmount = ( CASE WHEN u1.FAllHookQTY - u1.FQty = 0
                                          THEN ( u2.FStdAmount
                                                 - ( CASE WHEN v2.FTranType IN (
                                                              76, 86 )
                                                          THEN u2.FStdTaxAmount
                                                          ELSE 0
                                                     END ) )
                                          WHEN u1.FAllHookQTY = 0 THEN 0
                                          ELSE u2.FStdAllHookAmount
                                               + CAST(( u2.FStdAmount
                                                        - ( CASE
                                                              WHEN v2.FTranType IN (
                                                              76, 86 )
                                                              THEN u2.FStdTaxAmount
                                                              ELSE 0
                                                            END ) )
                                               * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                     END ) ,
            u2.FAllHookAmount = ( CASE WHEN u1.FAllHookQTY - u1.FQty = 0
                                       THEN ( u2.FAmount
                                              - ( CASE WHEN v2.FTranType IN (
                                                            76, 86 )
                                                       THEN u2.FTaxAmount
                                                       ELSE 0
                                                  END ) )
                                       WHEN u1.FAllHookQTY = 0 THEN 0
                                       ELSE u2.FAllHookAmount
                                            + CAST(( u2.FAmount
                                                     - ( CASE WHEN v2.FTranType IN (
                                                              76, 86 )
                                                              THEN u2.FTaxAmount
                                                              ELSE 0
                                                         END ) )
                                            * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                  END )
    FROM    #tmpInterID t2
            INNER JOIN ICSaleEntry u1 ON t2.FInterID = u1.FInterID
                                         AND t2.FEntryID = u1.FEntryID
            INNER JOIN ICSale v1 ON v1.FInterID = u1.FInterID
            INNER JOIN ICSaleEntry u2 ON u2.FSourceInterID = u1.FInterID
                                         AND u2.FSourceEntryID = u1.FEntryID
                                         AND u2.FSourceTranType = 1007140
            INNER JOIN ICSale v2 ON v2.FInterID = u2.FInterID
    WHERE   v1.FClassTypeID = 1007140  
    UPDATE  u2
    SET     u2.FStdCurrentHookAmount = ( CASE WHEN u1.FCurrentHookQTY = u1.FQty
                                              THEN u2.FStdAmount
                                                   - ( CASE WHEN v2.FTranType IN (
                                                              76, 86 )
                                                            THEN u2.FStdTaxAmount
                                                            ELSE 0
                                                       END )
                                              WHEN u1.FAllHookQTY = 0 THEN 0
                                              ELSE u2.FStdCurrentHookAmount
                                                   + CAST(( u2.FStdAmount
                                                            - ( CASE
                                                              WHEN v2.FTranType IN (
                                                              76, 86 )
                                                              THEN u2.FStdTaxAmount
                                                              ELSE 0
                                                              END ) )
                                                   * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                         END ) ,
            u2.FCurrentHookAmount = ( CASE WHEN u1.FAllHookQTY = u1.FQty
                                           THEN u2.FAmount
                                                - ( CASE WHEN v2.FTranType IN (
                                                              76, 86 )
                                                         THEN u2.FTaxAmount
                                                         ELSE 0
                                                    END )
                                           WHEN u1.FAllHookQTY = 0 THEN 0
                                           ELSE u2.FCurrentHookAmount
                                                + CAST(( u2.FAmount
                                                         - ( CASE
                                                              WHEN v2.FTranType IN (
                                                              76, 86 )
                                                              THEN u2.FTaxAmount
                                                              ELSE 0
                                                             END ) )
                                                * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                      END )
    FROM    #tmpInterID t2
            INNER JOIN ICSaleEntry u1 ON t2.FInterID = u1.FInterID
                                         AND t2.FEntryID = u1.FEntryID
            INNER JOIN ICSale v1 ON v1.FInterID = u1.FInterID
            INNER JOIN ICSaleEntry u2 ON u2.FSourceInterID = u1.FInterID
                                         AND u2.FSourceEntryID = u1.FEntryID
                                         AND u2.FSourceTranType = 1007140
            INNER JOIN ICSale v2 ON v2.FInterID = u2.FInterID
    WHERE   v1.FClassTypeID = 1007140
            AND t2.FYear = @FYear1
            AND t2.FPeriod = @FPeriod1
    UPDATE  v2
    SET     v2.FHookInterID = v1.FHookInterID ,
            v2.FHookerID = v1.FHookerID ,
            v2.FYearPeriod = v1.FYearPeriod ,
            v2.FHookStatus = v1.FHookStatus
    FROM    ICSale v1
            INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID
            INNER JOIN #tmpInterID t1 ON t1.FInterID = u1.FInterID
                                         AND t1.FEntryID = u1.FEntryID
            INNER JOIN ICSaleEntry u2 ON u2.FSourceInterID = u1.FInterID
                                         AND u2.FSourceEntryID = u1.FEntryID
                                         AND u2.FSourceTranType = 1007140
            INNER JOIN ICSale v2 ON v2.FInterID = u2.FInterID
    WHERE   v1.FClassTypeID = 1007140 
    
    
    --66666666666666--------
    
    UPDATE  u1
    SET     u1.FAllHookQTY = u1.FAllHookQTY + t2.FHookQty
    FROM    #tmpSTInterID t2
            INNER JOIN ICStockBillEntry u1 ON t2.FInterID = u1.FInterID
                                              AND t2.FEntryID = u1.FEntryID
                                              
                                              
    --7777777777777777--------
    
    UPDATE  u1
    SET     u1.FCurrentHookQTY = u1.FCurrentHookQTY + t2.FHookQty
    FROM    #tmpSTInterID t2
            INNER JOIN ICStockBill v1 ON t2.FInterID = v1.FInterID
            INNER JOIN ICStockBillEntry u1 ON t2.FInterID = u1.FInterID
                                              AND t2.FEntryID = u1.FEntryID
                                              AND t2.FYear = @FYear1
                                              AND t2.FPeriod =@FPeriod1
                                              
                                              
     ---8888888888888888888----
     
    UPDATE  u1
    SET     u1.FAllHookAmount = ( CASE WHEN u1.FAllHookQTY = u1.FQty
                                       THEN u1.FAmount
                                       WHEN u1.FAllHookQTY = 0 THEN 0
                                       ELSE u1.FAllHookAmount
                                            + CAST(u1.FAmount * ( t2.FHookQty
                                                              / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                  END )
    FROM    #tmpSTInterID t2
            INNER JOIN ICStockBill v1 ON t2.FInterID = v1.FInterID
            INNER JOIN ICStockBillEntry u1 ON t2.FInterID = u1.FInterID
                                              AND t2.FEntryID = u1.FEntryID
    WHERE   v1.FTranType = 1
    
    
    
    ----999999999999999999999---
    UPDATE  u1
    SET     u1.FCurrentHookAmount = ( CASE WHEN u1.FCurrentHookQTY = u1.FQty
                                           THEN u1.FAmount
                                           WHEN u1.FAllHookQTY = 0 THEN 0
                                           ELSE u1.FCurrentHookAmount
                                                + CAST(u1.FAmount
                                                * ( t2.FHookQty / u1.FQty ) AS DECIMAL(18,
                                                              2))
                                      END )
    FROM    #tmpSTInterID t2
            INNER JOIN ICStockBill v1 ON t2.FInterID = v1.FInterID
            INNER JOIN ICStockBillEntry u1 ON t2.FInterID = u1.FInterID
                                              AND t2.FEntryID = u1.FEntryID
    WHERE   v1.FTranType = 1
            AND t2.FYear = @FYear1
            AND t2.FPeriod = @FPeriod1
            
    -----------------1010101010101010-------------------------------------------------
            
            
    UPDATE  t1
    SET     t1.FHookInterID = 0 ,
            t1.FHookStatus = ( CASE WHEN ABS(v1.FSumHookQTY) = ABS(v1.FSumQty)
                                    THEN 2
                                    WHEN v1.FSumHookQTY = 0 THEN 0
                                    ELSE 1
                               END ) ,
            FYearPeriod = ''
    FROM    ICStockBill t1
            INNER JOIN ( SELECT FInterID ,
                                SUM(FQty) FSumQty ,
                                SUM(FAllHookQTY) FSumHookQTY
                         FROM   ICStockBillEntry
                         GROUP BY FInterID
                       ) v1 ON t1.FInterID = v1.FInterID
            INNER JOIN ( SELECT DISTINCT
                                FInterID
                         FROM   #tmpSTInterID
                       ) t2 ON t2.FInterID = v1.FInterID
                       
                       
------------------111111111111111111111111111111111111111111111111--------------------------------------------
                       
    SET NOCOUNT ON                   
    UPDATE  b
    SET     FEntryQtyPara3 = FEntryQtyPara3 - a.FQty
    FROM    ( SELECT    e.FInterID ,
                        e.FItemID ,
                        SUM(CASE d.FGroupID
                              WHEN 2
                              THEN ( ( CASE WHEN a.FHookQty >= 0 THEN 1
                                            ELSE -1
                                       END )
                                     * ( CASE WHEN ABS(ROUND(c.FCheckQty
                                                             * f.FCoefficient,
                                                             g.FQtyDecimal)) < ABS(c.FAllHookQty
                                                              + a.FHookQty)
                                              THEN ABS(ROUND(c.FCheckQty
                                                             * f.FCoefficient,
                                                             g.FQtyDecimal))
                                              ELSE ABS(c.FAllHookQty
                                                       + a.FHookQty)
                                         END
                                         - CASE WHEN ABS(ROUND(c.FCheckQty
                                                              * f.FCoefficient,
                                                              g.FQtyDecimal)) < ABS(c.FAllHookQty)
                                                THEN ABS(ROUND(c.FCheckQty
                                                              * f.FCoefficient,
                                                              g.FQtyDecimal))
                                                ELSE ABS(c.FAllHookQty)
                                           END ) )
                              WHEN 3 THEN a.FHookQty
                            END) AS FQty
              FROM      ( SELECT    FIBInterID AS FInterID ,
                                    FEntryID ,
                                    FItemID ,
                                    FHookAmount ,
                                    FHookQty ,
                                    FIBTag
                          FROM      ICHookRelations
                          WHERE     FGroupNo = 629708
                                    AND FIBTag IN ( 1, 0 )
                                    AND FTranType NOT IN ( 75, 76 )
                        ) a
                        INNER JOIN ICSale b ON a.FIBTag = 0
                                               AND a.FInterID = b.FInterID
                        INNER JOIN ICSaleEntry c ON a.FInterID = c.FInterID
                                                    AND a.FEntryID = c.FEntryID
                        INNER JOIN ICCreditInstant d ON d.FItemID IN (
                                                        b.FCustID, b.FEmpID,
                                                        b.FDeptID )
                                                        AND d.FGroupID IN ( 3,
                                                              2 )
                                                        AND d.FStatus = CASE
                                                              WHEN d.FGroupID = 3
                                                              THEN ( CASE
                                                              WHEN b.FSaleStyle = 100
                                                              THEN 1
                                                              ELSE 0
                                                              END )
                                                              ELSE 0
                                                              END
                        INNER JOIN ICCreditInstantEntry e ON d.FInterID = e.FInterID
                                                             AND a.FItemID = e.FItemID
                        INNER JOIN t_MeasureUnit f ON c.FUnitID = f.FMeasureUnitID
                        INNER JOIN t_ICItem g ON c.FItemID = g.FItemID
              GROUP BY  e.FInterID ,
                        e.FItemID
            ) a
            INNER JOIN ICCreditInstantEntry b ON b.FInterID = a.FInterID
                                                 AND b.FItemID = a.FItemID

    UPDATE  ICCreditInstant
    SET     FMainAmtPara3 = FMainAmtPara3 - a.FAmt
    FROM    ( SELECT    d.FInterID ,
                        SUM(CONVERT(NUMERIC(18, 2), CASE WHEN c.FQty = 0
                                                         THEN 0
                                                         ELSE a.FHookQty
                                                              / c.FQty
                                                              * FConsignAmount
                                                    END)) AS FAmt
              FROM      ( SELECT    FIBInterID AS FInterID ,
                                    FEntryID ,
                                    FItemID ,
                                    FHookAmount ,
                                    FHookQty ,
                                    FIBTag
                          FROM      ICHookRelations
                          WHERE     FGroupNo = 629708
                                    AND FIBTag IN ( 1, 0 )
                                    AND FTranType NOT IN ( 75, 76 )
                        ) a
                        INNER JOIN ICStockBill b ON a.FIBTag = 1
                                                    AND a.FInterID = b.FInterID
                        INNER JOIN ICStockBillEntry c ON a.FInterID = c.FInterID
                                                         AND a.FEntryID = c.FEntryID
                        INNER JOIN ICCreditInstant d ON d.FItemID IN (
                                                        b.FSupplyID, b.FEmpID,
                                                        b.FDeptID )
                                                        AND d.FGroupID = 2
                                                        AND d.FStatus = ( CASE
                                                              WHEN b.FROB = 1
                                                              THEN 0
                                                              ELSE 1
                                                              END )
              GROUP BY  d.FInterID
            ) a
    WHERE   ICCreditInstant.FInterID = a.FInterID                  
                                         
                                              
                                              
 -----删除原始数据-----
 
    DELETE  FROM ICHookRelations
    WHERE   FGroupNo = @saleno1
 
 
 -----------
 
    DROP TABLE #tmpInterID
    DROP TABLE #tmpSTInterID    
       
    COMMIT TRANSACTION
