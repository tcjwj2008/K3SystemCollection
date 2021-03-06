USE [AIS_YXSP2];
GO
/****** Object:  StoredProcedure [dbo].[SPK3_2GetEndBalance_czq]    Script Date: 04/26/2020 09:26:01 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/****** 获取前日累欠金额*/
ALTER    PROC [dbo].[SPK3_2GetEndBalance_czq] @date DATETIME
AS
    DECLARE @year INT;         
    DECLARE @month INT;         
    DECLARE @FPeriodsum INT;         
    SELECT  @year = DATEPART(YEAR, @date);        
    SELECT  @month = DATEPART(MONTH, @date);        
    SELECT  @FPeriodsum = @year * 12 + @month;   
    DECLARE @dPeriodsum INT; 
    SELECT  @dPeriodsum = ( SELECT  FValue
                            FROM    t_RP_SystemProfile
                            WHERE   FKey = 'FARCurYEAR'
                          ) * 12 + ( SELECT FValue
                                     FROM   t_RP_SystemProfile
                                     WHERE  FKey = 'FARCurPeriod'
                                   );           
    IF @FPeriodsum > @dPeriodsum
        BEGIN
            SET @FPeriodsum = @dPeriodsum;
        END; 
       
    IF EXISTS ( SELECT  1
                FROM    tempdb.dbo.sysobjects
                WHERE   id = OBJECT_ID(N'tempdb..#tempSubTable')
                        AND type = 'U' )
        DROP TABLE #tempSubTable;        
    IF EXISTS ( SELECT  1
                FROM    tempdb.dbo.sysobjects
                WHERE   id = OBJECT_ID(N'tempdb..#TempInitForSubTable')
                        AND type = 'U' )
        DROP TABLE #TempInitForSubTable;        
    IF EXISTS ( SELECT  1
                FROM    tempdb.dbo.sysobjects
                WHERE   id = OBJECT_ID(N'tempdb..#MyTempSubTable')
                        AND type = 'U' )
        DROP TABLE #MyTempSubTable;        
        
    CREATE TABLE #tempSubTable
        (
          FDate DATETIME ,
          FFincDate DATETIME ,
          FBillType VARCHAR(355) ,
          FNumber VARCHAR(355) ,
          FSubBillType VARCHAR(355) ,
          FVoucherNo VARCHAR(355) ,
          FJSBillNo VARCHAR(355) ,
          FAccountName VARCHAR(355) ,
          FExplanation VARCHAR(510) ,
          FContractNo VARCHAR(355) ,
          FDepartment INT DEFAULT ( 0 ) ,
          FDeptName VARCHAR(355) ,
          FClassTypeID INT DEFAULT ( 0 ) ,
          FTranType INT DEFAULT ( 0 ) ,
          FInterID INT DEFAULT ( 0 ) ,
          FImport INT DEFAULT ( 0 ) ,
          FEmployee INT DEFAULT ( 0 ) ,
          FEmpName VARCHAR(355) ,
          FMustRPAmountFor DECIMAL(28, 4) ,
          FMustRPAmount DECIMAL(28, 4) ,
          FRPAmountFor DECIMAL(28, 4) ,
          FRPAmount DECIMAL(28, 4) ,
          FDiscountAmountFor DECIMAL(28, 4) ,
          FDiscountAmount DECIMAL(28, 4) ,
          FSumSort INT DEFAULT ( 0 ) ,
          FEndBalanceFor DECIMAL(28, 4) ,
          FEndBalance DECIMAL(28, 4) ,
          FBillID INT DEFAULT ( 0 ) ,
          FType INT DEFAULT ( 0 ) ,
          FPre INT DEFAULT ( 0 ) ,
          FYear INT DEFAULT ( 0 ) ,
          FPeriod INT DEFAULT ( 0 ) ,
          FCurrencyID INT NULL ,
          FCurrencyName VARCHAR(355) ,
          FCustomer VARCHAR(355)
        );        
        
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
        
        
    CREATE TABLE #MyTempSubTable
        (
          FDate DATETIME ,
          FFincDate DATETIME ,
          FBillType VARCHAR(355) ,
          FNumber VARCHAR(355) ,
          FSubBillType VARCHAR(355) ,
          FVoucherNo VARCHAR(355) ,
          FJSBillNo VARCHAR(355) ,
          FAccountName VARCHAR(355) ,
          FExplanation VARCHAR(510) ,
          FContractNo VARCHAR(355) ,
          FDepartment INT DEFAULT ( 0 ) ,
          FDeptName VARCHAR(355) ,
          FClassTypeID INT DEFAULT ( 0 ) ,
          FTranType INT DEFAULT ( 0 ) ,
          FInterID INT DEFAULT ( 0 ) ,
          FImport INT DEFAULT ( 0 ) ,
          FEmployee INT DEFAULT ( 0 ) ,
          FEmpName VARCHAR(355) ,
          FMustRPAmountFor DECIMAL(28, 4) ,
          FMustRPAmount DECIMAL(28, 4) ,
          FRPAmountFor DECIMAL(28, 4) ,
          FRPAmount DECIMAL(28, 4) ,
          FDiscountAmountFor DECIMAL(28, 4) ,
          FDiscountAmount DECIMAL(28, 4) ,
          FSumSort INT DEFAULT ( 0 ) ,
          FEndBalanceFor DECIMAL(28, 4) ,
          FEndBalance DECIMAL(28, 4) ,
          FBillID INT DEFAULT ( 0 ) ,
          FType INT DEFAULT ( 0 ) ,
          FPre INT DEFAULT ( 0 ) ,
          FYear INT DEFAULT ( 0 ) ,
          FPeriod INT DEFAULT ( 0 ) ,
          FCurrencyID INT NULL ,
          FCurrencyName VARCHAR(355) ,
          FCustomer VARCHAR(355) ,
          RowNum INT NULL ,
          FAmountDecimal INT DEFAULT ( 2 )
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
                    SUM(FYtdDebitFor - FDebitFor) ,
                    SUM(FYtdDebit - FDebit) ,
                    SUM(FYtdCreditFor - FCreditFor) ,
                    SUM(FYtdCredit - FCredit) ,
                    SUM(FBeginBalanceFor) ,
                    SUM(FBeginBalance) ,
                    b.FCurrencyID
            FROM    t_RP_ContactBal b
                    JOIN t_Item k ON b.FCustomer = k.FItemID         
                    LEFT JOIN t_Item d ON b.FDepartment = d.FItemID
                    LEFT JOIN t_Item e ON b.FEmployee = e.FItemID
                    LEFT JOIN t_Account t ON b.FAccountID = t.FAccountID
            WHERE   b.FRP = 1
                    AND b.FItemClassID = 1
                    AND b.FCurrencyID = 1               
                    AND b.FYear * 12 + b.FPeriod = @FPeriodsum
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
                    AND ( ( b.FFincDate < @date
                            AND b.FStatus = 0
                            AND b.FStatus & 16 = 0
                          )
                          OR ( b.FYear * 12 + b.FPeriod >= @FPeriodsum
                               AND b.FFincDate < @date
                               AND b.FStatus & 1 = 1
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
                                '' AS FJSBillNo
                      FROM      t_RP_NewReceiveBill b
                                JOIN t_RP_Contact ct ON ct.FBillID = b.FBillID
                                                        AND ct.FType = 5
                                JOIN t_rp_ARBillOfSH a ON b.FBillID = a.FBillID
                                LEFT JOIN t_rp_BillType bt ON b.FClassTypeID = bt.FID
                                LEFT JOIN t_Voucher v ON b.FVoucherID = v.FVoucherID
                                LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                                LEFT JOIN t_RP_SystemEnum c1 ON b.FBillType = c1.FItemID
                      WHERE     ( b.FSubSystemID = 0
                                  OR ( b.FSubSystemID = 1
                                       AND FConfirm = 1
                                     )
                                )
                                AND b.FRP = 1
                    ) b
                    JOIN t_Item k ON b.FCustomer = k.FItemID --and k.FName like '%%'        
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
 --and k.FNumber >= '03.1001' and k.FNumber <= '03.1001'        
                    AND ( ( b.FFincDate < @date
                            AND b.FStatus = 0
                            AND b.FStatus & 16 = 0
                          )
                          OR ( b.FYear * 12 + b.FPeriod >= @FPeriodsum
                               AND b.FFincDate < @date
                               AND b.FStatus & 1 = 1
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
                    SUM(FAmountFor) ,
                    SUM(FAmount) ,
                    SUM(CASE WHEN b.FInvoiceType IN ( 3, 4 ) THEN FAmountFor
                             ELSE 0
                        END) ,
                    SUM(CASE WHEN b.FInvoiceType IN ( 3, 4 ) THEN FAmount
                             ELSE 0
                        END) ,
                    SUM(CASE WHEN b.FInvoiceType IN ( 3, 4 ) THEN 0
                             ELSE FAmountFor
                        END) ,
                    SUM(CASE WHEN b.FInvoiceType IN ( 3, 4 ) THEN 0
                             ELSE FAmount
                        END) ,
                    b.FCurrencyID
            FROM    t_RP_Contact b
                    JOIN t_Item k ON b.FCustomer = k.FItemID --and k.FName like '%%'        
                    LEFT JOIN t_Item d ON b.FDepartment = d.FItemID
                    LEFT JOIN t_Item e ON b.FEmployee = e.FItemID
                    LEFT JOIN t_Account t ON b.FAccountID = t.FAccountID
            WHERE   b.FRP = 1
                    AND b.FItemClassID = 1
                    AND b.FCurrencyID = 1        
 --and k.FNumber >= '03.1001' and k.FNumber <= '03.1001'        
                    AND b.FInvoiceType IN ( 3, 4 )
                    AND b.FType IN ( 1, 3 )
                    AND ( b.FFincDate < @date
                          AND b.FYear = @year
                          AND b.FStatus & 16 = 0
                        )
            GROUP BY b.FYear ,
                    b.FCustomer ,
                    FDepartment ,
                    FEmployee ,
                    b.FCurrencyID;        
         
    INSERT  INTO #tempSubTable
            ( FDate ,
              FFincDate ,
              FBillType ,
              FNumber ,
              FSubBillType ,
              FVoucherNo ,
              FAccountName ,
              FExplanation ,
              FContractNo ,
              FDeptName ,
              FClassTypeID ,
              FTranType ,
              FInterID ,
              FImport ,
              FEmpName ,
              FMustRPAmountFor ,
              FMustRPAmount ,
              FRPAmountFor ,
              FRPAmount ,
              FDiscountAmountFor ,
              FDiscountAmount ,
              FSumSort ,
              FEndBalanceFor ,
              FEndBalance ,
              FBillID ,
              FType ,
              FPre ,
              FYear ,
              FPeriod ,
              FCurrencyName ,
              FCustomer
            )
            SELECT  NULL ,
                    NULL ,
                    '' ,
                    '' ,
                    '' ,
                    '' ,
                    '' ,
                    '期初余额' ,
                    '' ,
                    '' ,
                    0 ,
                    0 ,
                    0 ,
                    0 ,
                    '' ,
                    0 ,
                    0 ,
                    0 ,
                    0 ,
                    0 ,
                    0 ,
                    100 ,
                    ISNULL(SUM(k.FEndBalanceFor), 0) ,
                    ISNULL(SUM(k.FEndBalance), 0) ,
                    0 ,
                    0 ,
                    0 ,
                    2014 ,
                    0 ,
                    1 ,
                    k.FCustomer
            FROM    #TempInitForSubTable k
            GROUP BY k.FCustomer;        
         
         



    IF EXISTS ( SELECT  1
                FROM    tempdb.dbo.sysobjects
                WHERE   id = OBJECT_ID(N'tempdb..#tempSubTable2')
                        AND type = 'U' )
        DROP TABLE #tempSubTable2; 
      
      


--以下代码是修改后的代码

    SELECT  a.K3代码 ,
            ISNULL(SUM(b.FEndBalance), 0) AS FEndBalance
    INTO    #tempSubTable2
    FROM    YXERP.dbo.BTSKBM_B_czq a
            LEFT  JOIN ( SELECT t1.FNumber ,
                                ISNULL(SUM(a.FEndBalance), 0) AS FEndBalance
                         FROM   #tempSubTable a
                                INNER  JOIN dbo.t_Organization t1 ON a.FCustomer = t1.FItemID
                         GROUP BY t1.FNumber
                       ) b ON b.FNumber = a.K3代码
                              AND a.标记 = '明细' 
GROUP BY    a.K3代码;      
      
      
      
      
    UPDATE  YXERP.dbo.BTSKBM_B_czq
    SET     前日累欠 = ISNULL(前日累欠, 0) + b.FEndBalance
    FROM    YXERP.dbo.BTSKBM_B_czq a
            INNER JOIN #tempSubTable2 b ON b.K3代码 = a.K3代码
    WHERE   a.标记 = '明细'; 