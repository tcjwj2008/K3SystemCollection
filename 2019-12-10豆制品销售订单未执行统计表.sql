USE [AIS_YXDZP2018]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER    PROC [dbo].[sp_DzpYsTJ_qiu]
    @year_begin VARCHAR(10) ,   
    @month_begin VARCHAR(10) ,   
    @year_end VARCHAR(10) ,   --年月份
    @month_end VARCHAR(10) ,  --年月份    
    @fcur VARCHAR(100) ,
    @isALL INT ,
    @pq VARCHAR(100)
AS
   --定义时间变量
    DECLARE 
            @year1_begin VARCHAR(10) ,
			@month1_begin VARCHAR(10) ,            
			@year1_end VARCHAR(10) ,
			@month1_end VARCHAR(10) ,
			@fcur1 VARCHAR(100) ,
			@isALL1 INT ,
			@pq1 VARCHAR(100); 
    SELECT      
            @year1_begin = @year_begin ,
            @month1_begin = @month_begin ,    
            @year1_end = @year_end ,
            @month1_end = @month_end ,
            @fcur1 = @fcur ,
            @isALL1 = @isALL ,
            @pq1 = @pq;
   
   --查询日期基本信息 
   DECLARE  
            @begdate_begin DATETIME ,   
			@enddate_begin DATETIME ,            
            @begdate_end DATETIME ,   
			@enddate_end DATETIME ,
			@fdate_end DATETIME,   
			@fdate_begin DATETIME;    
  
        
	SET @fdate_begin = @year1_begin + '-' + @month1_begin + '-01';  
	SELECT  @begdate_begin = DATEADD(mm, DATEDIFF(mm, 0, @fdate_begin), 0); --开始时间月初      
	SELECT  @enddate_begin = DATEADD(ms, -3,
						   DATEADD(mm, DATEDIFF(m, 0, @fdate_begin) + 1, 0)); --开始时间月末         

	SET @fdate_end = @year1_end + '-' + @month1_end + '-01';          
	SELECT  @begdate_end = DATEADD(mm, DATEDIFF(mm, 0, @fdate_end), 0); --结束时间月初      
	SELECT  @enddate_end = DATEADD(ms, -3,
						   DATEADD(mm, DATEDIFF(m, 0, @fdate_end) + 1, 0)); --结束时间月末     
						   
						   
	--关于查询期间基本信息					   
    DECLARE @EndFARCurPeriod INT;      --系统当前期间 
    DECLARE @dARCurPeriod_Begin INT;   --查询开始期间 
    DECLARE @dARCurPeriod_End INT;     --查询结束期间  
    SELECT  @EndFARCurPeriod = ( SELECT    FValue
                              FROM      t_RP_SystemProfile
                              WHERE     FKey = 'FARCurYEAR'
                            ) * 12 + ( SELECT   FValue
                                       FROM     t_RP_SystemProfile
                                       WHERE    FKey = 'FARCurPeriod'
                                     );   
     
    SELECT  @dARCurPeriod_Begin = CONVERT(INT, @year1_begin) * 12 + CONVERT(INT, @month1_begin);  
    SELECT  @dARCurPeriod_End =   CONVERT(INT, @year1_end)   * 12 + CONVERT(INT, @month1_end);  
  
    IF @dARCurPeriod_End > @EndFARCurPeriod
        SET @EndFARCurPeriod = @EndFARCurPeriod;  
    ELSE
        SET @EndFARCurPeriod = @dARCurPeriod_End - 1;  
        						    
  
    
    CREATE TABLE #tab_dzp_receivable
        (
          FID INT IDENTITY(1, 1) ,
          FcurID INT ,--客户内码      
          Fcuinumber VARCHAR(50) ,--客户代码      
          FcurAdd VARCHAR(50) ,--片区      
          FcurName VARCHAR(500) ,--客户名称      
          Fbegbalance FLOAT ,--期初余额      
          FchBan FLOAT ,--出货      
          FthBan FLOAT ,--退货      
          FhkBan FLOAT ,--回款      
          FtkBan FLOAT ,--退款      
          FWSBan FLOAT ,--物料销售      
          FqkkkBan FLOAT ,--扣款      
          FxzBan FLOAT ,--销账      
          FflBan FLOAT ,--返利      
          FqtBan FLOAT ,--其他      
          FendBalance FLOAT,--期末余额      
      
        );      
      
--写入客户  

    IF ( LEN(@pq1) > 0 )
        BEGIN      
            INSERT  INTO #tab_dzp_receivable
                    ( FcurID ,
                      Fcuinumber ,
                      FcurAdd ,
                      FcurName ,
                      Fbegbalance ,
                      FchBan ,
                      FthBan ,
                      FhkBan ,
                      FtkBan ,
                      FWSBan ,
                      FqkkkBan ,
                      FxzBan ,
                      FflBan ,
                      FqtBan ,
                      FendBalance
                    )
                    SELECT  t.FItemID ,
                            t.FNumber ,
                            t.Fcorperate ,
                            t.FName ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0
                    FROM    dbo.t_Organization t
                    WHERE   t.Fcorperate <> '无'
                            AND t.FNumber + t.FName LIKE '%' + @fcur1 + '%'
                            AND t.Fcorperate = @pq1
                    ORDER BY t.FNumber; 

        END;  

    ELSE
        BEGIN
      
            INSERT  INTO #tab_dzp_receivable
                    ( FcurID ,
                      Fcuinumber ,
                      FcurAdd ,
                      FcurName ,
                      Fbegbalance ,
                      FchBan ,
                      FthBan ,
                      FhkBan ,
                      FtkBan ,
                      FWSBan ,
                      FqkkkBan ,
                      FxzBan ,
                      FflBan ,
                      FqtBan ,
                      FendBalance
                    )
                    SELECT  t.FItemID ,
                            t.FNumber ,
                            t.Fcorperate ,
                            t.FName ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0 ,
                            0
                    FROM    dbo.t_Organization t
                    WHERE   t.Fcorperate <> '无'
                            AND t.FNumber + t.FName LIKE '%' + @fcur1 + '%'
                    ORDER BY t.FNumber; 

        END;    
      
 
    
-- 更新期初 Fbegbalance      
  
    CREATE TABLE #TempInitForSubTable
        (
          FYear INT DEFAULT ( 0 ) ,
          FMustRPAmountFor DECIMAL(28, 4) DEFAULT ( 0 ) ,
          FMustRPAmount DECIMAL(28, 4) DEFAULT ( 0 ) ,
          FRPAmountFor DECIMAL(28, 4) DEFAULT ( 0 ) ,
          FRPAmount DECIMAL(28, 4) DEFAULT ( 0 ) ,
          FEndBalanceFor DECIMAL(28, 4) DEFAULT ( 0 ) ,
          FEndBalance DECIMAL(28, 4) DEFAULT ( 0 ) ,
          FCurrencyID INT NULL ,
          FCustomer INT DEFAULT ( 0 ) ,
          FDepartment INT DEFAULT ( 0 ) ,
          FEmployee INT DEFAULT ( 0 )
        );  
  
  
    INSERT  INTO #TempInitForSubTable
            ( FYear ,
              FCustomer ,
              FDepartment ,
              FEmployee ,
              FMustRPAmountFor ,
              FMustRPAmount ,
              FRPAmountFor ,
              FRPAmount ,
              FEndBalanceFor ,
              FEndBalance ,
              FCurrencyID
            )
            SELECT  FYear ,
                    FCustomer ,
                    FDepartment ,
                    FEmployee ,
                    SUM(FYtdDebitFor) ,
                    SUM(FYtdDebit) ,
                    SUM(FYtdCreditFor) ,
                    SUM(FYtdCredit) ,
                    SUM(FEndBalanceFor) ,
                    SUM(FEndBalance) ,
                    b.FCurrencyID
            FROM    t_RP_ContactBal b
                    JOIN t_Item k ON b.FCustomer = k.FItemID
                    LEFT JOIN t_Item d ON b.FDepartment = d.FItemID
                    LEFT JOIN t_Item e ON b.FEmployee = e.FItemID
                    LEFT JOIN t_Account t ON b.FAccountID = t.FAccountID
            WHERE   b.FRP = 1
                    AND b.FItemClassID = 1
                    AND b.FCurrencyID = 1
                    AND b.FYear * 12 + b.FPeriod =@dARCurPeriod_Begin                                 --@EndFARCurPeriod
            GROUP BY b.FYear ,
                    b.FCustomer ,
                    FDepartment ,
                    FEmployee ,
                    b.FCurrencyID
            UNION ALL
            SELECT  FYear ,
                    FCustomer ,
                    FDepartment ,
                    FEmployee ,
                    SUM(CASE WHEN FType = 9 THEN -FAmountFor
                             ELSE FAmountFor
                        END) ,
                    SUM(CASE WHEN FType = 9 THEN -FAmount
                             ELSE FAmount
                        END) ,
                    0 ,
                    0 ,
                    SUM(CASE WHEN FType = 9 THEN -FAmountFor
                             ELSE FAmountFor
                        END) ,
                    SUM(CASE WHEN FType = 9 THEN -FAmount
                             ELSE FAmount
                        END) ,
                    b.FCurrencyID
            FROM    ( SELECT    b.FDate ,
                                b.FFincDate ,
                                b.FAmount ,
                                b.FAmountFor ,
                                b.FIsInit ,
                                b.FType ,
                                b.FCustomer ,
                                b.FEmployee ,
                                b.FInvoiceType ,
                                b.FDepartment ,
                                b.FRP ,
                                b.FPeriod ,
                                b.FYear ,
                                b.FStatus ,
                                b.FItemClassID ,
                                b.FCurrencyID ,
                                ( CASE b.FIsInit
                                    WHEN 1 THEN s1.FAccountID
                                    ELSE ( CASE WHEN b.FType >= 1
                                                     AND b.FType <= 2
                                                THEN s2.FAccountID
                                                WHEN b.FType = 3
                                                THEN s3.FCussentAcctID
                                                WHEN b.FType = 4
                                                THEN s3.FCussentAcctID
                                                ELSE b.FAccountID
                                           END )
                                  END ) FAccountID
                      FROM      t_RP_Contact b
                                LEFT JOIN t_rp_BegData s1 ON b.FBegID = s1.FInterID
                                                             AND b.FIsInit = 1
                                LEFT JOIN t_RP_ARPBill s2 ON b.FRPBillID = s2.FBillID
                                                             AND b.FType = 1
                                LEFT JOIN ICSale s3 ON b.FInvoiceID = s3.FInterID
                                                       AND b.FType = 3
                      WHERE     b.FRP = 1
                                AND b.FType IN ( 1, 3, 11, 13, 9 )
                                AND ISNULL(s3.FCancellation, 0) <> 1
                    ) b
                    JOIN t_Item k ON b.FCustomer = k.FItemID
                    LEFT JOIN t_Item d ON b.FDepartment = d.FItemID
                    LEFT JOIN t_Item e ON b.FEmployee = e.FItemID
                    LEFT JOIN t_Account t ON b.FAccountID = t.FAccountID
            WHERE   b.FRP = 1
                    AND b.FItemClassID = 1
                    AND b.FCurrencyID = 1
                    AND b.FInvoiceType NOT IN ( 3, 4 )
                    AND b.FType IN ( 1, 3, 9 )
                    AND ( ( b.FYear * 12 + b.FPeriod > @dARCurPeriod_Begin                   -- @EndFARCurPeriod
                            AND b.FYear * 12 + b.FPeriod < @dARCurPeriod_End   
                            AND b.FStatus & 1 = 1
                            AND b.FStatus & 16 = 0
                          )
                          OR ( b.FYear * 12 + b.FPeriod < @dARCurPeriod_End   
                               AND b.FStatus = 0
                               AND b.FStatus & 16 = 0
                             )
                        )
            GROUP BY b.FYear ,
                    b.FCustomer ,
                    FDepartment ,
                    FEmployee ,
                    b.FCurrencyID
            UNION ALL
            SELECT  FYear ,
                    FCustomer ,
                    FDepartment ,
                    FEmployee ,
                    SUM(CASE b.FIsBad
                          WHEN 1 THEN ISNULL(tb.FAmountFor, 0)
                          ELSE 0
                        END) AS FAmountFor ,
                    SUM(CASE b.FIsBad
                          WHEN 1 THEN ISNULL(tb.FAmount, 0)
                          ELSE 0
                        END) AS FAmount ,
                    SUM(b.FAmountFor) AS ReceiveAmountFor ,
                    SUM(b.FAmount) AS ReceiveAmount ,
                    SUM(CASE b.FIsBad
                          WHEN 1 THEN ISNULL(tb.FAmountFor, 0)
                          ELSE 0
                        END - ( b.FAmountFor )) FEndBalanceFor ,
                    SUM(CASE b.FIsBad
                          WHEN 1 THEN ISNULL(tb.FAmount, 0)
                          ELSE 0
                        END - ( b.FAmount )) FEndBalance ,
                    b.FCurrencyID
            FROM    ( SELECT    b.FClassTypeID ,
                                b.FBillID AS FInterID ,
                                0 AS FID ,
                                b.FYear ,
                                b.FPeriod ,
                                b.FRP AS FRP ,
                                ( CASE WHEN b.FRP = 0 THEN 6
                                       ELSE 5
                                  END ) AS FType ,
                                b.FDate AS FDate ,
                                ISNULL(b.FFincDate, b.FDate) AS FFincDate ,
                                b.FNumber AS FNumber ,
                                b.FPre ,
                                b.FCustomer AS FCustomer ,
                                b.FDepartment AS FDepartment ,
                                b.FEmployee AS FEmployee ,
                                b.FCurrencyID ,
                                b.FExchangeRate ,
                                b.FContractNo ,
                                CASE WHEN b.FPre = -1
                                     THEN ( -1 ) * ( ISNULL(a.FSettleAmount, 0)
                                                     + ISNULL(a.FDiscount, 0) )
                                     ELSE ISNULL(a.FSettleAmount, 0)
                                          + ISNULL(a.FDiscount, 0)
                                END FAmount ,
                                CASE WHEN b.FPre = -1
                                     THEN ( -1 ) * ( ISNULL(a.FSettleAmountFor,
                                                            0)
                                                     + ISNULL(a.FDiscountFor,
                                                              0) )
                                     ELSE ISNULL(a.FSettleAmountFor, 0)
                                          + ISNULL(a.FDiscountFor, 0)
                                END FAmountFor ,
                                CASE WHEN b.FPre = -1
                                     THEN ( -1 ) * a.FRemainAmount
                                     ELSE a.FRemainAmount
                                END FRemainAmount ,
                                CASE WHEN b.FPre = -1
                                     THEN ( -1 ) * a.FRemainAmountFor
                                     ELSE a.FRemainAmountFor
                                END FRemainAmountFor ,
                                ISNULL(ct.FIsBad, 0) AS FIsBad ,
                                b.FVoucherID AS FVoucherID ,
                                v.FGroupID AS FGroupID ,
                                a.FAccountID AS FAccountID ,
                                0 AS FIsInit ,
                                b.FStatus AS FStatus ,
                                b.FBillType AS FDetailBillType ,
                                c1.FName AS FDetailBillTypeName ,
                                0 AS FInvoiceType ,
                                b.FItemClassID ,
                                b.FExplanation FExplanation ,
                                b.FSubSystemID ,
                                0 AS FTranType ,
                                CAST(v1.FName AS NVARCHAR(30)) + '-'
                                + CAST(v.FNumber AS NVARCHAR(30)) AS FVoucherNo ,
                                bt.FName AS FBillTypeName ,
                                '' AS FJSBillNo ,
                                s.FName AS FSettleName ,
                                b.FSettleNo AS FSettleNo
                      FROM      t_RP_NewReceiveBill b
                                JOIN t_RP_Contact ct ON ct.FBillID = b.FBillID
                                                        AND ct.FType = 5
                                JOIN t_rp_ARBillOfSH a ON b.FBillID = a.FBillID
                                LEFT JOIN t_rp_BillType bt ON b.FClassTypeID = bt.FID
                                LEFT JOIN t_Voucher v ON b.FVoucherID = v.FVoucherID
                                LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                                LEFT JOIN t_RP_SystemEnum c1 ON b.FBillType = c1.FItemID
                                LEFT JOIN t_Settle s ON b.FSettle = s.FItemID
                      WHERE     ( b.FSubSystemID = 0
                                  OR ( b.FSubSystemID = 1
                                       AND FConfirm = 1
                                     )
                                )
                                AND b.FRP = 1
                    ) b
                    JOIN t_Item k ON b.FCustomer = k.FItemID
                    LEFT JOIN t_Item d ON b.FDepartment = d.FItemID
                    LEFT JOIN t_Item e ON b.FEmployee = e.FItemID
                    LEFT JOIN t_Account t ON b.FAccountID = t.FAccountID
                    LEFT JOIN ( SELECT  FReContactID ,
                                        SUM(FAmount) AS FAmount ,
                                        SUM(FAmountFor) AS FAmountFor
                                FROM    t_RP_NewBadDebt
                                WHERE   ISNULL(FType, 0) = 0
                                        AND FReContactID > 0
                                GROUP BY FReContactID
                              ) tb ON b.FInterID = tb.FReContactID
            WHERE   b.FRP = 1
                    AND b.FItemClassID = 1
                    AND b.FCurrencyID = 1
                    AND ( ( b.FYear * 12 + b.FPeriod >  @dARCurPeriod_Begin                                    
                            AND b.FYear * 12 + b.FPeriod < @dARCurPeriod_End
                            AND b.FStatus & 1 = 1
                            AND b.FStatus & 16 = 0
                          )
                          OR ( b.FYear * 12 + b.FPeriod < @dARCurPeriod_End      
                               AND b.FStatus = 0
                               AND b.FStatus & 16 = 0
                             )
                        )
            GROUP BY b.FYear ,
                    b.FCustomer ,
                    FDepartment ,
                    FEmployee ,
                    b.FCurrencyID;  
  

    UPDATE  #tab_dzp_receivable
    SET     Fbegbalance = b.FBeginBalance
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT FCustomer ,
                                SUM(FEndBalanceFor) AS FBeginBalance
                         FROM   #TempInitForSubTable
                         GROUP BY FCustomer
                       ) b ON a.FcurID = b.FCustomer;      
    DROP TABLE  #TempInitForSubTable;  
    
	--更新 “出货”取当日产成品范围内的篮字销售出库单的数据--FchBan FLOAT,--出货   
	   
    UPDATE  #tab_dzp_receivable
    SET     FchBan = b.FConsignAmount
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT v1.FSupplyID ,
                                SUM(ISNULL(u1.FConsignAmount, 0)) FConsignAmount
                         FROM   dbo.ICStockBillEntry u1
                                INNER JOIN dbo.ICStockBill v1 ON v1.FInterID = u1.FInterID
                                INNER JOIN t_ICItem t ON t.FItemID = u1.FItemID
                         WHERE  v1.FDate  BETWEEN @begdate_begin AND @enddate_end                                                 
                         --BETWEEN @begdate_end AND @enddate_end       
                                AND v1.FCancellation = 0
                                AND v1.FROB = 1
                         GROUP BY v1.FSupplyID
                       ) b ON b.FSupplyID = a.FcurID;      
      
    --FthBan FLOAT,--退货 --“退货”取当日产成品范围内红字销售出库单的数据      
      
    UPDATE  #tab_dzp_receivable
    SET     FthBan = ISNULL(b.FConsignAmount, 0) * -1
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT v1.FSupplyID ,
                                SUM(ISNULL(u1.FConsignAmount, 0)) FConsignAmount
                         FROM   dbo.ICStockBillEntry u1
                                INNER JOIN dbo.ICStockBill v1 ON v1.FInterID = u1.FInterID
                                INNER JOIN t_ICItem t ON t.FItemID = u1.FItemID
                         WHERE  v1.FDate BETWEEN @begdate_begin AND @enddate_end  --@begdate_end
                                -- v1.FDate BETWEEN @begdate_end AND @enddate_end --日期      
                                AND v1.FCancellation = 0
                                AND t.FNumber >= '8.01.001'
                                AND t.FNumber < '9' --产成品      
                                AND v1.FROB = -1
                         GROUP BY v1.FSupplyID
                       ) b ON b.FSupplyID = a.FcurID;      
  
     
	--“物料销售”取非产成品的销售出库数据（含篮字、红字） --FWSBan FLOAT,--物料销售      

    UPDATE  #tab_dzp_receivable
    SET     FWSBan = b.FConsignAmount
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT v1.FSupplyID ,
                                SUM(ISNULL(v1.FROB * u1.FConsignAmount, 0)) FConsignAmount
                         FROM   dbo.ICStockBillEntry u1
                                INNER JOIN dbo.ICStockBill v1 ON v1.FInterID = u1.FInterID
                                INNER JOIN t_ICItem t ON t.FItemID = u1.FItemID
                         WHERE  v1.FDate BETWEEN @begdate_begin AND @enddate_end   --@begdate_end    
                                AND v1.FCancellation = 0
                                AND t.FNumber < '8'
                                AND t.FNumber >= '1' --非产成品      
                         GROUP BY v1.FSupplyID
                       ) b ON b.FSupplyID = a.FcurID;      
      
 -- --  “物料销售”这列，如果客户基础资料中分管部门属于“80.30.01、80.30.02、80.30.03”的就不统计物料销售出库数据   

 
    UPDATE  #tab_dzp_receivable
    SET     FWSBan = 0
    FROM    #tab_dzp_receivable a
            INNER JOIN dbo.t_Organization t ON a.FcurID = t.FItemID
            INNER JOIN dbo.t_Department d ON t.Fdepartment = d.FItemID
    WHERE   d.FNumber IN ( '80.30.01', '80.30.02', '80.30.03' );  
   

      
-- “回款”取当日收款单的数据 --FhkBan FLOAT,--回款        
      
    UPDATE  #tab_dzp_receivable
    SET     FhkBan = b.FAmountFor
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT u.FCustomer ,
                                SUM(u.FAmountFor) AS FAmountFor
                         FROM   t_RP_NewReceiveBill u             
                         WHERE  (
                         
                             u.FYear * 12 + u.FPeriod >  @dARCurPeriod_Begin                                    
                             AND u.FYear * 12 + u.FPeriod < @dARCurPeriod_End                         
                         
                               --   ISNULL(u.FPeriod, 0) = @month1_end    AND ISNULL(u.FYear, 0) = @year1_end
                            )
                                AND u.FClassTypeID = 1000005--收款单      
                                AND ( u.FSubSystemID <> 1
                                      OR u.FConfirm = 1
                                    )
                         GROUP BY u.FCustomer
                       ) b ON b.FCustomer = a.FcurID;      
      
--“退款”取当月退款单的数据      
      
      
    UPDATE  #tab_dzp_receivable
    SET     FtkBan = b.FAmountFor
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT u.FCustomer ,
                                SUM(u.FAmountFor) AS FAmountFor
                         FROM   t_RP_NewReceiveBill u
                         WHERE  ( 
                         
                             u.FYear * 12 + u.FPeriod >  @dARCurPeriod_Begin                                    
                             AND u.FYear * 12 + u.FPeriod < @dARCurPeriod_End     
                            --ISNULL(u.FYear, 0) = @year1_end     AND ISNULL(u.FPeriod, 0) = @month1_end
                                )
                                AND u.FClassTypeID = 1000015
                                AND ( (FSubSystemID <> 1
                                      OR FConfirm = 1 )
                                    )
                         GROUP BY u.FCustomer
                       ) b ON b.FCustomer = a.FcurID;      
      
      
      
--FqkkkBan FLOAT,--欠筐扣款      
      
--“扣款”取其他应收单中摘要包含“欠筐”的数据（按月统计）      
--“欠筐扣款”列改为：“扣款（欠筐及罚金等）”取其他应收单摘要包含“欠筐或处罚”。  --所制的表中“客户”如为片区建议精确到片区全部代码。 --增加：在返利列后面增加“其他调整”列，取其他应收单总额扣除“返利、销帐、扣款”列的数据。      
      
    UPDATE  #tab_dzp_receivable
    SET     FqkkkBan = b.famountFor
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT v.FCustomer ,
                                SUM(u.famountFor) famountFor
                         FROM   dbo.t_rp_arpbillEntry u
                                INNER JOIN dbo.t_RP_ARPBill v ON v.FBillID = u.FBillID
                         WHERE  v.FClassTypeID = 1000021
                               
                               
                         AND  FYear * 12 +  FPeriod >  @dARCurPeriod_Begin                                    
                             AND  FYear * 12 +  FPeriod < @dARCurPeriod_End                           
                               
                               -- AND FYear = @year1_end        AND FPeriod = @month1_end
                                AND v.FDelete = 0
                                AND ( v.FExplanation LIKE '%欠筐%'
                                      OR v.FExplanation LIKE '%处罚%'
                                    )
                         GROUP BY v.FCustomer
                       ) b ON b.FCustomer = a.FcurID;      
      
      
--FxzBan FLOAT,--销账      
      
--“销账”取其他应收单中摘要包含“销账”的数据（按月统计）      
      
    UPDATE  #tab_dzp_receivable
    SET     FxzBan = ISNULL(b.famountFor, 0)
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT v.FCustomer ,
                                SUM(u.famountFor) famountFor
                         FROM   dbo.t_rp_arpbillEntry u
                                INNER JOIN dbo.t_RP_ARPBill v ON v.FBillID = u.FBillID
                         WHERE  v.FClassTypeID = 1000021
                         
                            AND  FYear * 12 +  FPeriod >  @dARCurPeriod_Begin                                    
                             AND  FYear * 12 +  FPeriod < @dARCurPeriod_End                          
                               -- AND FYear = @year1_end                            AND FPeriod = @month1_end
                                AND v.FDelete = 0
                                AND ( v.FExplanation LIKE '%销账%'
                                      OR v.FExplanation LIKE '%销帐%'
                                    )
                         GROUP BY v.FCustomer
                       ) b ON b.FCustomer = a.FcurID;      
      
--FflBan FLOAT,--返利      
      
--“返利”取其他应收单中摘要包含“返利”的数据（按月统计）  
      
      
    UPDATE  #tab_dzp_receivable
    SET     FflBan = ISNULL(b.famountFor, 0)
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT v.FCustomer ,
                                SUM(u.famountFor) famountFor
                         FROM   dbo.t_rp_arpbillEntry u
                                INNER JOIN dbo.t_RP_ARPBill v ON v.FBillID = u.FBillID
                         WHERE  v.FClassTypeID = 1000021
                                  AND  FYear * 12 +  FPeriod >  @dARCurPeriod_Begin                                    
                             AND  FYear * 12 +  FPeriod < @dARCurPeriod_End    
                             ---   AND FYear = @year1_end                              AND FPeriod = @month1_end
                                AND v.FDelete = 0
                                AND v.FExplanation LIKE '%返利%'
                         GROUP BY v.FCustomer
                       ) b ON b.FCustomer = a.FcurID;      
      
------其他       
    UPDATE  #tab_dzp_receivable
    SET     FqtBan = ISNULL(b.famountFor, 0)
    FROM    #tab_dzp_receivable a
            INNER JOIN ( SELECT v.FCustomer ,
                                SUM(u.famountFor) famountFor
                         FROM   dbo.t_rp_arpbillEntry u
                                INNER JOIN dbo.t_RP_ARPBill v ON v.FBillID = u.FBillID
                         WHERE  v.FClassTypeID = 1000021
                                                  AND  FYear * 12 +  FPeriod >  @dARCurPeriod_Begin                                    
                             AND  FYear * 12 +  FPeriod < @dARCurPeriod_End    
                             --   AND FYear = @year1_end                                AND FPeriod = @month1_end
                                AND v.FDelete = 0
                                AND v.FExplanation NOT LIKE '%返利%'
                                AND v.FExplanation NOT LIKE '%销账%'
                                AND v.FExplanation NOT LIKE '%销帐%'
                                AND v.FExplanation NOT LIKE '%欠筐%'
                                AND v.FExplanation NOT LIKE '%处罚%'
                         GROUP BY v.FCustomer
                       ) b ON b.FCustomer = a.FcurID;      
      

--“期未余额”即当月期初余额+本月销售-本月退货-本月回款+物料销售+欠筐扣款-本月销账-本月返利      
--期初余额+出货-退货-回款-退款+物料+欠筐-销账-返利+其他      
      
      
      
      
      
    UPDATE  #tab_dzp_receivable
    SET     FendBalance = CONVERT(DECIMAL(18, 2), ROUND(( Fbegbalance + FchBan
                                                          - FthBan - FhkBan
                                                          - FtkBan + FWSBan
                                                          + FqkkkBan + FxzBan
                                                          + FflBan + FqtBan ),
                                                        2));      
      
    IF @isALL1 <> 1
        BEGIN  
      
            SELECT  FcurID AS 客户内码 ,
                    Fcuinumber AS 客户代码 ,
                    FcurAdd AS 片区 ,
                    FcurName AS 客户名称 ,
                    Fbegbalance 期初余额 ,
                    FchBan 出货 ,
                    FthBan 退货 ,
                    FhkBan 回款 ,
                    FtkBan 退款 ,
                    FWSBan 物料销售 ,
                    FqkkkBan 欠筐扣款 ,
                    FxzBan * -1 销账 ,
                    FflBan * -1 返利 ,
                    FqtBan 其他 ,
                    FendBalance 期末余额
            FROM    #tab_dzp_receivable
            WHERE   FcurID IN ( SELECT DISTINCT
                                        FSupplyID
                                FROM    ICStockBill
                                WHERE   FDate BETWEEN @begdate_end AND @enddate_end )   --FchBan>0    
            UNION ALL
            SELECT  0 AS 客户内码 ,
                    '' AS 客户代码 ,
                    '' AS 片区 ,
                    '合计：' AS 客户名称 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(Fbegbalance), 2)) 期初余额 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FchBan), 2)) 出货 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FthBan), 2)) 退货 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FhkBan), 2)) 回款 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FtkBan), 2)) 退款 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FWSBan), 2)) 物料销售 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FqkkkBan), 2)) 欠筐扣款 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FxzBan * -1), 2)) 销账 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FflBan * -1), 2)) 返利 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FqtBan), 2)) 其他 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FendBalance), 2)) 期末余额
            FROM    #tab_dzp_receivable
            WHERE   FcurID IN ( SELECT DISTINCT
                                        FSupplyID
                                FROM    ICStockBill
                                WHERE   FDate BETWEEN @begdate_end AND @enddate_end );  
--FchBan>0     
      
--ORDER BY Fcuinumber      
        END;
    ELSE
        BEGIN  
            SELECT  FcurID AS 客户内码 ,
                    Fcuinumber AS 客户代码 ,
                    FcurAdd AS 片区 ,
                    FcurName AS 客户名称 ,
                    Fbegbalance 期初余额 ,
                    FchBan 出货 ,
                    FthBan 退货 ,
                    FhkBan 回款 ,
                    FtkBan 退款 ,
                    FWSBan 物料销售 ,
                    FqkkkBan 欠筐扣款 ,
                    FxzBan * -1 销账 ,
                    FflBan * -1 返利 ,
                    FqtBan 其他 ,
                    FendBalance 期末余额
            FROM    #tab_dzp_receivable
            UNION ALL
            SELECT  0 AS 客户内码 ,
                    '' AS 客户代码 ,
                    '' AS 片区 ,
                    '合计：' AS 客户名称 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(Fbegbalance), 2)) 期初余额 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FchBan), 2)) 出货 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FthBan), 2)) 退货 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FhkBan), 2)) 回款 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FtkBan), 2)) 退款 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FWSBan), 2)) 物料销售 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FqkkkBan), 2)) 欠筐扣款 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FxzBan * -1), 2)) 销账 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FflBan * -1), 2)) 返利 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FqtBan), 2)) 其他 ,
                    CONVERT(DECIMAL(18, 2), ROUND(SUM(FendBalance), 2)) 期末余额
            FROM    #tab_dzp_receivable;    
      
--ORDER BY Fcuinumber    
     
        END;      
    DROP TABLE #tab_dzp_receivable;      
  
  