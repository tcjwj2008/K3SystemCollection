SELECT  *
FROM    dbo.t_Voucher
WHERE   dbo.t_Voucher.FNumber = 230
        AND FPeriod = 9
        AND FYear = 2019;


SELECT  A.FVoucherID ,
        A.AFAMOUNT ,
        ABS(B.Cfamount) ABSBC ,
        A.AFAMOUNT - ABS(B.Cfamount)
FROM    ( SELECT    C.FVoucherID ,
                    ABS(C.Vfamount0 - D.Vfamount1) AS AFAMOUNT
          FROM      ( SELECT    FVoucherID ,
                                SUM(FAmount) AS Vfamount0
                      FROM      dbo.t_VoucherEntry
                      WHERE     FVoucherID = 29395
                                AND FDC = 0
                                AND FCashFlowItem = 1
                      GROUP BY  FVoucherID
                    ) C ,
                    ( SELECT    FVoucherID ,
                                SUM(FAmount) AS Vfamount1
                      FROM      dbo.t_VoucherEntry
                      WHERE     FVoucherID = 29395
                                AND FDC = 1
                                AND FCashFlowItem = 1
                      GROUP BY  FVoucherID
                    ) D
          WHERE     C.FVoucherID = D.FVoucherID
        ) A ,
        ( SELECT    FVoucherID ,
                    SUM(FAmount) AS Cfamount
          FROM      dbo.t_CashFlowBal
          WHERE     1 = 1
                    AND FVoucherID = 29395
          GROUP BY  FVoucherID
        ) B
WHERE   A.FVoucherID = B.FVoucherID
        AND A.AFAMOUNT - ABS(B.Cfamount) <> 0;


SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 29395;

SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 29395;





SELECT  A.FVoucherID ,
        A.Vfamount ,
        A.FEntryID ,
        B.Cfamount ,
        ABS(A.Vfamount) - ABS(B.Cfamount)
FROM    ( SELECT    FVoucherID ,
                    FEntryID ,
                    SUM(FAmount) AS Vfamount
          FROM      dbo.t_VoucherEntry
          WHERE     1 = 1 
		          -- AND  FVoucherID = 29395 
		       
                  --  AND FCashFlowItem = 1
          GROUP BY  FVoucherID ,
                    FEntryID
        ) A ,
        ( SELECT    FVoucherID ,
                    FEntryID ,
                    SUM(FAmount) AS Cfamount
          FROM      dbo.t_CashFlowBal
          WHERE     1 = 1  
		      --     AND FVoucherID = 29395 
          GROUP BY  FVoucherID ,
                    FEntryID
        ) B
WHERE   A.FVoucherID = B.FVoucherID
        AND A.FEntryID = B.FEntryID
        AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0;





GO
dbo.SpK3_2Str @sName = 't_CashFlowBal' 
-- varchar(50)


;

SELECT  A.FVoucherID ,
        A.Vfamount ,
        A.FEntryID ,
        B.Cfamount ,
        ABS(A.Vfamount) - ABS(B.Cfamount)
FROM    ( SELECT    FVoucherID ,
                    FEntryID ,
                    SUM(FAmount) AS Vfamount
          FROM      dbo.t_VoucherEntry
          WHERE     1 = 1
                    AND FVoucherID = 29395 
		       
                  --  AND FCashFlowItem = 1
          GROUP BY  FVoucherID ,
                    FEntryID
        ) A ,
        ( SELECT    FVoucherID ,
                    FFEntryID ,
                    SUM(FAmount) AS Cfamount
          FROM      dbo.t_CashFlowBal
          WHERE     1 = 1
                    AND FVoucherID = 29395
          GROUP BY  FVoucherID ,
                    FFEntryID
        ) B
WHERE   A.FVoucherID = B.FVoucherID
        AND A.FEntryID = B.FFEntryID
        AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0;

--

SELECT  A.FVoucherID ,
        A.Vfamount ,
        A.FEntryID ,
        B.Cfamount ,
        ABS(A.Vfamount) - ABS(B.Cfamount)
FROM    ( SELECT    FVoucherID ,
                    FEntryID ,
                    SUM(FAmount) AS Vfamount
          FROM      dbo.t_VoucherEntry
          WHERE     1 = 1 
		        --  AND  FVoucherID = 27706 
		       
                  --  AND FCashFlowItem = 1
          GROUP BY  FVoucherID ,
                    FEntryID
        ) A ,
        ( SELECT    FVoucherID ,
                    FFEntryID ,
                    SUM(FAmount) AS Cfamount
          FROM      dbo.t_CashFlowBal
          WHERE     1 = 1  
		        --  AND FVoucherID = 27706 
          GROUP BY  FVoucherID ,
                    FFEntryID
        ) B
WHERE   A.FVoucherID = B.FVoucherID
        AND A.FEntryID = B.FFEntryID
        AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0;



--以上为参考逻辑，正确逻辑如下：


SELECT  DISTINCT
        A.FVoucherID
FROM    ( SELECT    FVoucherID ,
                    FEntryID ,
                    SUM(FAmount) AS Vfamount
          FROM      dbo.t_VoucherEntry
          WHERE     1 = 1 
		        --  AND  FVoucherID = 27706 
		       
                  --  AND FCashFlowItem = 1
          GROUP BY  FVoucherID ,
                    FEntryID
        ) A ,
        ( SELECT    FVoucherID ,
                    FFEntryID ,
                    SUM(FAmount) AS Cfamount
          FROM      dbo.t_CashFlowBal
          WHERE     1 = 1  
		        --  AND FVoucherID = 27706 
          GROUP BY  FVoucherID ,
                    FFEntryID
        ) B
WHERE   A.FVoucherID = B.FVoucherID
        AND A.FEntryID = B.FFEntryID
        AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0;


SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  DISTINCT
                                A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		        --  AND  FVoucherID = 27706 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FFEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 27706 
                                  GROUP BY  FVoucherID ,
                                            FFEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FFEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber;


SELECT  *
FROM    t_VoucherEntry
WHERE   FVoucherID = 27706;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 27706;
SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 29395;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 29395;
SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 32317;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 32317;
SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 26957;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 26957;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 26957;

SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 32590;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 32590;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 32590;

SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 28030;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 28030;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 28030;
SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 32576;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 32576;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 32576;
SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 32448;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 32448;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 32448;
SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 32544;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 32544;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 32544;
SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 32590;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 32590;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 32590;

SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 32550;
SELECT  FVoucherID ,
        FEntryID ,
        FAccountID ,
        FDC ,
        FAmount ,
        FCashFlowItem
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 32550
        AND FCashFlowItem = 1;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 32550;

GO



SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 32298;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 32298;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 32298;


SELECT  *
FROM    dbo.t_VoucherEntry
WHERE   FVoucherID = 29935;
SELECT  *
FROM    dbo.t_CashFlowBal
WHERE   FVoucherID = 29935;
SELECT  *
FROM    dbo.t_Voucher
WHERE   FVoucherID = 29935;

SELECT  A.FVoucherID ,
        A.Vfamount ,
        A.FEntryID ,
        B.Cfamount ,
        ABS(A.Vfamount) - ABS(B.Cfamount)
FROM    ( SELECT    FVoucherID ,
                    FEntryID ,
                    SUM(FAmount) AS Vfamount
          FROM      dbo.t_VoucherEntry
          WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
          GROUP BY  FVoucherID ,
                    FEntryID
        ) A ,
        ( SELECT    FVoucherID ,
                    FFEntryID ,
                    SUM(FAmount) AS Cfamount
          FROM      dbo.t_CashFlowBal
          WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
          GROUP BY  FVoucherID ,
                    FFEntryID
        ) B
WHERE   A.FVoucherID = B.FVoucherID
        AND A.FEntryID = B.FFEntryID
        AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0;


---
SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FFEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FFEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FFEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 



----


SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FDEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FDEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FDEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 




SELECT  FVoucherID ,
        SUM(FAmount) ,
        SUM(FFAmount) ,
        SUM(ABS(FAmount)) - SUM(ABS(FFAmount))
FROM    dbo.t_CashFlowBal
WHERE   FSubItemID > 0
GROUP BY FVoucherID;




SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FSideEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FSideEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FDEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FDEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FSideEntryID = B.FDEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 


SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FSideEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FSideEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FSideEntryID = B.FEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 


SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FSideEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FSideEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FFEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FFEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FSideEntryID = B.FFEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 



SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FFEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FFEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FFEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 



SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 


SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FDEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FDEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FDEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 












SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  --  AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 





SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     FCashFlowItem = 1
                                  GROUP BY  FVoucherID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1
                                  GROUP BY  FVoucherID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 




SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
                                            AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FFEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FFEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FFEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 



SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FEntryID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1 
		         -- AND  FVoucherID = 32576 
		       
                  -- AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FEntryID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FDEntryID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1  
		        --  AND FVoucherID = 32576 
                                  GROUP BY  FVoucherID ,
                                            FDEntryID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FEntryID = B.FDEntryID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 




SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
FROM    dbo.t_Voucher
WHERE   FVoucherID IN ( SELECT  A.FVoucherID
                        FROM    ( SELECT    FVoucherID ,
                                            FAccountID ,
                                            SUM(FAmount) AS Vfamount
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1
                                            AND FVoucherID = 32394  
		       
                  -- AND FCashFlowItem = 1
                                  GROUP BY  FVoucherID ,
                                            FAccountID
                                ) A ,
                                ( SELECT    FVoucherID ,
                                            FCashAccountID ,
                                            SUM(FAmount) AS Cfamount
                                  FROM      dbo.t_CashFlowBal
                                  WHERE     1 = 1
                                            AND FVoucherID = 32394
                                  GROUP BY  FVoucherID ,
                                            FCashAccountID
                                ) B
                        WHERE   A.FVoucherID = B.FVoucherID
                                AND A.FAccountID = B.FCashAccountID
                                AND ABS(A.Vfamount) - ABS(B.Cfamount) <> 0 )
ORDER BY FYear ,
        FPeriod ,
        FNumber; 


SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
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
ORDER BY FYear ,
        FPeriod ,
        FNumber; 




SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
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
ORDER BY FYear ,
        FPeriod ,
        FNumber; 




SELECT  FVoucherID ,
        FYear ,
        FPeriod ,
        FNumber
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
ORDER BY FYear ,
        FPeriod ,
        FNumber; 
