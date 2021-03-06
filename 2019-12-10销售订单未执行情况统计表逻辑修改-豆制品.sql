USE [AIS_YXDZP2018];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
--说明 销售订单未执行统计表

ALTER PROC [dbo].[sp_Dzp_SEORDER_WTJ_czq]
    (
      @FBeginDate DATETIME ,
      @FEndDate DATETIME
    )
AS ------------------------------------------
    --1.获取订单明细
    SELECT  FItemID ,
            FAuxQty ,
            FInterID AS FOrderInterID
    INTO    #订单
    FROM    dbo.SEOrderEntry R
    WHERE   1 = 1
            AND FAuxQty <> 0.0001
            AND EXISTS ( SELECT *
                         FROM   dbo.SEOrder T
                         WHERE  R.FInterID = T.FInterID
                                AND FDate BETWEEN @FBeginDate AND @FEndDate
                                AND FCancellation = 0 )
    ORDER BY FItemID;
------------------------------------------
    --2.创建临时表，获取订单符合条件1的内码
    CREATE TABLE #订单号
        (
          FOrderInterID INT ,
          ZID INT IDENTITY(1, 1)
        );

    INSERT  #订单号
            ( FOrderInterID
            )
            SELECT DISTINCT
                    FOrderInterID
            FROM    #订单; 
------------------------------------------
--3循环 读取销售出库单的明细
    DECLARE @FOrderInterID INT ,
        @ZID INT ,
        @CountNum INT;

    SELECT  @CountNum = COUNT(*)
    FROM    #订单号;
    SELECT  @ZID = 1;

    WHILE ( @ZID <= @CountNum )
        BEGIN

            SELECT  @FOrderInterID = FOrderInterID
            FROM    #订单号
            WHERE   ZID = @ZID;

            INSERT  #订单
                    ( FItemID ,
                      FAuxQty ,
                      FOrderInterID
                    )
                    SELECT  FItemID ,
                            -SUM(FAuxQty) ,
                            @FOrderInterID FOrderInterID
                    FROM    dbo.ICStockBillEntry
                    WHERE   FInterID IN (
                            SELECT DISTINCT
                                    FInterID
                            FROM    dbo.ICStockBillEntry E
                            WHERE   FOrderInterID IN ( @FOrderInterID )
                                    AND FInterID IN (
                                    SELECT  FInterID
                                    FROM    dbo.ICStockBill
                                    WHERE   FTranType = 21
                                            AND FROB = 1
                                            AND FCancellation = 0 ) --增加行
)
                            AND FAuxQty <> 0.0001
                    GROUP BY FItemID ,
                            FOrderInterID;



            SELECT  @ZID = @ZID + 1;

        END;

------------------------------------------
--4 创建表
    CREATE TABLE #OrderDiff
        (
          订单内码 INT ,
          出库单内码 INT ,
          产品内码 INT ,
          出库日期 VARCHAR(20) ,
          订单编号 VARCHAR(30) ,
          订单日期 VARCHAR(20) ,
          订单额 MONEY ,
          出库单号 VARCHAR(30) ,
          出库额 MONEY ,
          总差异额 MONEY ,
          客户代码 VARCHAR(100) ,                             
          客户 VARCHAR(500) ,
          产品代码 VARCHAR(50) ,
          产品名称 VARCHAR(200) ,
          规格型号 VARCHAR(50) ,
          单位 VARCHAR(50) ,
          订单量 FLOAT ,
          出库量 FLOAT ,
          差异量 FLOAT ,
          单价 MONEY ,
          明细差异额 MONEY ,
          订单单价 MONEY ,
          出库单价 MONEY ,
          单价差额 MONEY
        );

--写入数据
    INSERT  #OrderDiff
            ( 订单内码 ,
              订单编号 ,
              订单日期 ,
              产品内码 ,
              产品名称 ,
              产品代码 ,
              规格型号 ,
              单位
            )
            SELECT  t.FOrderInterID ,
                    R.FBillNo ,
                    CONVERT(VARCHAR(12), R.FDate, 23) ,
                    t.FItemID ,
                    W.FName ,
                    W.FNumber ,
                    W.FModel ,
                    U.FName
            FROM    ( SELECT    FItemID ,
                                SUM(FAuxQty) FAuxQty ,
                                FOrderInterID
                      FROM      #订单
                      GROUP BY  FItemID ,
                                FOrderInterID
                      HAVING    ( SUM(FAuxQty) <> 0 )
                    ) t
                    INNER JOIN dbo.SEOrder R ON t.FOrderInterID = R.FInterID
                    INNER JOIN dbo.t_ICItem W ON W.FItemID = t.FItemID
                    INNER JOIN dbo.t_MeasureUnit U ON U.FItemID = W.FUnitID;

    UPDATE  #OrderDiff
    SET     订单量 = 0 ,
            出库量 = 0 ,
            差异量 = 0 ,
            单价 = 0 ,
            明细差异额 = 0;

--从订单取客户信息(新增下列语句2016-12-09 czq)

    UPDATE  r
    SET     客户 = g.FName,r.客户代码=g.FNumber
    FROM    #OrderDiff r
            INNER JOIN dbo.SEOrder a ON a.FInterID = r.订单内码
            INNER JOIN dbo.t_Organization g ON a.FCustID = g.FItemID;



------------------------------------------
--5删除临时表
    DROP TABLE #订单; 
    DROP TABLE #订单号; 

------------------------------------------
--更新 出库单内码
    UPDATE  #OrderDiff
    SET     出库单内码 = t.FInterID
    FROM    ( SELECT DISTINCT
                        FInterID ,
                        FOrderInterID
              FROM      dbo.ICStockBillEntry
              WHERE     EXISTS ( SELECT *
                                 FROM   #OrderDiff
                                 WHERE  FOrderInterID = 订单内码 )
                        AND FSourceBillNo <> ''
            ) t
            INNER JOIN #OrderDiff G ON G.订单内码 = t.FOrderInterID;

--更新 出库日期，出库单号
    UPDATE  #OrderDiff
    SET     出库日期 = CONVERT(VARCHAR(12), B.FDate, 23) ,
            出库单号 = B.FBillNo ,
            客户 = K.FName
    FROM    dbo.ICStockBill B
            INNER JOIN #OrderDiff G ON B.FInterID = G.出库单内码
            INNER JOIN dbo.t_Organization K ON B.FSupplyID = K.FItemID;





--更新 订单金额 FAllAmount
    UPDATE  #OrderDiff
    SET     订单额 = FAllAmount
    FROM    ( SELECT    FInterID ,
                        SUM(FAuxQty * FAuxTaxPrice) FAllAmount
              FROM      dbo.SEOrderEntry E
                        INNER JOIN ( SELECT DISTINCT
                                            订单内码
                                     FROM   #OrderDiff
                                   ) G ON E.FInterID = G.订单内码
              GROUP BY  FInterID
            ) T
    WHERE   #OrderDiff.订单内码 = FInterID;

--更新 出库单金额 FConsignPrice
    UPDATE  #OrderDiff
    SET     出库额 = FAllAmount
    FROM    ( SELECT    FInterID ,
                        SUM(FAuxQty * FConsignPrice) FAllAmount
              FROM      dbo.ICStockBillEntry E
                        INNER JOIN ( SELECT DISTINCT
                                            出库单内码
                                     FROM   #OrderDiff
                                   ) G ON E.FInterID = G.出库单内码
              GROUP BY  FInterID
            ) T
    WHERE   #OrderDiff.出库单内码 = FInterID;



    SELECT  订单内码 ,
            出库单内码 ,
            COUNT(*) 数量
    INTO    #tcount
    FROM    #OrderDiff
    GROUP BY 订单内码 ,
            出库单内码;

    ALTER TABLE #OrderDiff ADD FCount INT;
    ALTER TABLE #OrderDiff ADD 总差异额2 MONEY;

    UPDATE  a
    SET     FCount = b.数量
    FROM    #OrderDiff a
            INNER JOIN #tcount b ON b.出库单内码 = a.出库单内码
                                    AND b.订单内码 = a.订单内码;




--更新 总差异额
    UPDATE  #OrderDiff
    SET     总差异额 = ( 订单额 - 出库额 ) ,
            总差异额2 = ( 订单额 - 出库额 ) / FCount;


    UPDATE  #OrderDiff
    SET     订单量 = E.FAuxQty ,
            单价 = FAuxTaxPrice ,
            订单单价 = FAuxTaxPrice
    FROM    #OrderDiff G
            INNER JOIN dbo.SEOrderEntry E ON G.订单内码 = E.FInterID
                                             AND G.产品内码 = E.FItemID;



    UPDATE  #OrderDiff
    SET     出库量 = fAuxQty ,
            单价 = FConsignPrice
    FROM    #OrderDiff G
            INNER JOIN ( SELECT FInterID ,
                                FItemID ,
                                SUM(FAuxQty) AS fAuxQty ,
                                FConsignPrice
                         FROM   ICStockBillEntry E
                         WHERE  EXISTS ( SELECT *
                                         FROM   #OrderDiff G
                                         WHERE  G.出库单内码 = E.FInterID
                                                AND G.产品内码 = E.FItemID )
                         GROUP BY FInterID ,
                                FItemID ,
                                FConsignPrice
                       ) E ON G.出库单内码 = E.FInterID
                              AND G.产品内码 = E.FItemID;

    UPDATE  #OrderDiff
    SET     出库单价 = FConsignPrice
    FROM    #OrderDiff G
            INNER JOIN dbo.ICStockBillEntry E ON G.出库单内码 = E.FInterID
                                                 AND G.产品内码 = E.FItemID;




    UPDATE  #OrderDiff
    SET     出库量 = 0
    WHERE   出库量 IS NULL;

    UPDATE  #OrderDiff
    SET     差异量 = 订单量 - 出库量 ,
            明细差异额 = ( 订单量 - 出库量 ) * 单价 ,
            单价差额 = ABS(ISNULL(订单单价, 0) - ISNULL(出库单价, 0));

------------------------------------------
--查询结果
    SELECT  出库日期 ,
            订单编号 ,
            订单日期 ,
            订单额 ,
            出库单号 ,
            出库额 ,
            总差异额 ,
            客户代码,
            客户 ,
            产品代码 ,
            产品名称 ,
            规格型号 ,
            单位 ,
            订单量 ,
            出库量 ,
            差异量 ,
            单价 ,
            明细差异额 ,
            订单单价 ,
            出库单价 ,
            单价差额
    FROM    #OrderDiff
    UNION
    SELECT  '合计' 出库日期 ,
            NULL 订单编号 ,
            NULL 订单日期 ,
            SUM(订单额) 订单额 ,
            NULL 出库单号 ,
            SUM(出库额) 出库额 ,
            SUM(总差异额2) 总差异额 ,
            NULL 客户代码,
            NULL 客户 ,
            NULL 产品代码 ,
            NULL 产品名称 ,
            NULL 规格型号 ,
            NULL 单位 ,
            SUM(订单量) 订单量 ,
            SUM(出库量) 出库量 ,
            SUM(差异量) 差异量 ,
            NULL 单价 ,
            SUM(明细差异额) 明细差异额 ,
            NULL 订单单价 ,
            NULL 出库单价 ,
            NULL 单价差额
    FROM    #OrderDiff
    ORDER BY 出库日期;
 