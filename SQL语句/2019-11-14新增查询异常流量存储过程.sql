--Financial_cash_flow 2019,10
alter PROCEDURE Financial_cash_flow
    @YEAR INT ,
    @PERIOD INT 
AS
    BEGIN
        SELECT  FVoucherID  AS 内码,
		        fdate AS 日期,

                FYear AS 年度,
                FPeriod AS 期间 ,
                FNumber AS 号码,FExplanation AS 摘要
        FROM    dbo.t_Voucher
        WHERE   FVoucherID IN (
                SELECT  A.FVoucherID
                FROM    ( SELECT    FVoucherID ,
                                    FAccountID ,
                                    SUM(Vfamount) Vfamount
                          FROM      ( SELECT    FVoucherID ,
                                                FAccountID ,
                                                SUM(FAmount) * ( -1 ) AS Vfamount
                                      FROM      dbo.t_VoucherEntry
                                      WHERE     1 = 1
                                                AND FDC = 1
		 -- AND FVoucherID = 32394 
                                      GROUP BY  FVoucherID ,
                                                FAccountID
                                      UNION ALL
                                      SELECT    FVoucherID ,
                                                FAccountID ,
                                                SUM(FAmount) AS Vfamount
                                      FROM      dbo.t_VoucherEntry
                                      WHERE     1 = 1
                                                AND FDC = 0
		--  AND FVoucherID = 32394 
                                      GROUP BY  FVoucherID ,
                                                FAccountID
                                    ) C
                          GROUP BY  FVoucherID ,
                                    FAccountID
                        ) A ,
                        ( SELECT    FVoucherID ,
                                    FCashAccountID ,
                                    SUM(FAmount) AS Cfamount
                          FROM      dbo.t_CashFlowBal
                          WHERE     1 = 1  
		       --  AND FVoucherID = 32394 
                          GROUP BY  FVoucherID ,
                                    FCashAccountID
                        ) B
                WHERE   A.FVoucherID = B.FVoucherID
                        AND A.FAccountID = B.FCashAccountID
                        AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
				AND FYear=@YEAR AND FPeriod=@PERIOD 
        ORDER BY FYear ,
                FPeriod,FNumber 

    END;



