
/****** Object:  StoredProcedure [dbo].[sp_dzp_CurrentYear_Income_TJ2_csp]    Script Date: 08/28/2019 16:28:42 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROC [dbo].[sp_dzp_CurrentYear_Income_TJ2_csp]
    (
      @begindate DATETIME ,
      @enddate DATETIME
    )
AS
    BEGIN

        DECLARE @BeginYearDate VARCHAR(20);
        SELECT  @BeginYearDate = CAST(YEAR(CAST(@begindate AS DATETIME)) AS VARCHAR)
                + '-01-01';

        SELECT  g.FItemID ,
                g.FNumber ,
                g.FName ,
                d.FName AS fName1 ,
                g.Fcorperate
        INTO    #t
        FROM    dbo.t_Organization g
                INNER JOIN dbo.t_Department d ON g.Fdepartment = d.FItemID
                INNER JOIN t_SubMessage t ON g.FRegionID = t.FInterID
                                             AND t.FInterID > 0
                                             AND t.FDeleted = 0
                                             AND t.FTypeID = 26 
--AND ((t.FInterID >=83557 AND T.FInterID<83566 and t.FInterID<>83563 ) OR (t.FInterID=83566 AND Fcorperate<>'L') OR t.FInterID >83566   )
        WHERE   g.FItemID IN ( SELECT   FSupplyID
                               FROM     dbo.ICStockBill
                               WHERE    FDate BETWEEN @begindate AND @enddate )
--AND (t.FInterID=83566 AND g.Fcorperate )--泉州商超L 过滤
ORDER BY        d.FItemID ,
                g.FItemID;


        ALTER TABLE #t ADD  A FLOAT; --销售出库额
        ALTER TABLE #t ADD B FLOAT; --销售折扣/返利/销帐等
        ALTER TABLE #t ADD C FLOAT; --销售净额（元）
        ALTER TABLE #t ADD D VARCHAR(50); --占比
        ALTER TABLE #t ADD E FLOAT; --本期总占比


        ALTER TABLE #t ADD AA FLOAT;
        ALTER TABLE #t ADD BB FLOAT;
        ALTER TABLE #t ADD CC FLOAT;
        ALTER TABLE #t ADD DD VARCHAR(50);
        ALTER TABLE #t ADD EE FLOAT(50); --本年总占比




        UPDATE  t
        SET     t.A = ISNULL(g.A, 0)
        FROM    #t t
                LEFT  JOIN ( SELECT c.FItemID ,
                                    SUM(b.FConsignAmount
                                        / CASE ISNULL(d.FTaxRate, 0)
                                            WHEN 0 THEN 1
                                            ELSE d.FTaxRate
                                          END) A
                             FROM   dbo.ICStockBill a ,
                                    dbo.ICStockBillEntry b ,
                                    dbo.t_Organization c ,
                                    dbo.t_ICItem d
                             WHERE  a.FInterID = b.FInterID
                                    AND a.FSupplyID = c.FItemID
                                    AND b.FItemID = d.FItemID
                                    AND a.FCancellation = 0
                                    AND a.FTranType = 21
                                    AND a.FDate BETWEEN @begindate AND @enddate
                             GROUP BY c.FItemID
                           ) g ON g.FItemID = t.FItemID;
--取其他应收单(销售折扣/返利/销帐等)B
        UPDATE  t
        SET     t.B = ISNULL(g.B, 0)
        FROM    #t t
                LEFT JOIN ( SELECT  g1.FItemID ,
                                    SUM(FAmountNoTax) B
                            FROM    dbo.t_RP_ARPBill v1
                                    INNER JOIN dbo.t_rp_arpbillEntry u1 ON u1.FBillID = v1.FBillID
                                                              AND FTaxRate > 0
                                    INNER JOIN dbo.t_Organization g1 ON v1.FCustomer = g1.FItemID
                            WHERE   v1.FDate BETWEEN @begindate AND @enddate
                            GROUP BY g1.FItemID
                          ) g ON g.FItemID = t.FItemID;

        UPDATE  #t
        SET     C = ISNULL(A, 0) + ISNULL(B, 0);

        DECLARE @E FLOAT ,
            @EE FLOAT;  
        SELECT  @E = SUM(C)
        FROM    #t; 
 
        UPDATE  #t
        SET     E = @E;
 
        UPDATE  #t
        SET     D = CAST(( CAST(( C * 100 / E ) AS DECIMAL(18, 2)) ) AS VARCHAR(50))
                + '%'
        WHERE   e > 0;
        UPDATE  t
        SET     t.aa = g.AA
        FROM    #t t ,
                ( SELECT    a.FSupplyID ,
                            SUM(b.FAmount) AA
                  FROM      dbo.ICStockBill a ,
                            dbo.ICStockBillEntry b
                  WHERE     a.FInterID = b.FInterID
                            AND a.FTranType = 21
                            AND a.FCancellation = 0
                            AND a.FDate >= @begindate
                            AND a.FDate <= @enddate
                  GROUP BY  a.FSupplyID
                ) g
        WHERE   t.FItemID = g.FSupplyID;
        UPDATE  #t
        SET     BB = c - AA;
        UPDATE  #t
        SET     CC = ( BB / CASE ISNULL(c, 0)
                              WHEN 0 THEN 1
                              ELSE c
                            END );
        SELECT  FItemID ,
                FNumber AS 编号 ,
                FName AS 客户 ,
                fName1 AS 部门 ,
                Fcorperate AS 渠道 ,
                A 本期销售出库额元 ,
                B [本期销售折扣/返利/销帐元] ,
                C 本期销售净额元 ,
                D 本期占比 ,
                AA 销售成本 ,
                BB 毛利 ,
                CC 毛利率
        FROM    #t  -- WHERE FItemID='1146'
        UNION
        SELECT  999999 FItemID ,
                '合计' AS 编号 ,
                '' AS 客户 ,
                '' AS 部门 ,
                '' AS 渠道 ,
                SUM(A) 本期销售出库额元 ,
                SUM(B) [本期销售折扣/返利/销帐元] ,
                SUM(C) 本期销售净额元 ,
                NULL 本期占比 ,
                SUM(AA) 销售成本 ,
                SUM(BB) 毛利 ,
                SUM(CC) 毛利率
        FROM    #t
        ORDER BY FItemID;
    END;
