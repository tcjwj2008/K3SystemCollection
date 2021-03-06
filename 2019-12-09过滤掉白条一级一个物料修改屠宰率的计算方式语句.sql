USE [AIS_YXRY2];
GO
/****** Object:  StoredProcedure [dbo].[sp_yxryCost_czq_new]    Script Date: 12/09/2019 11:42:30 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

ALTER PROCEDURE [dbo].[sp_yxryCost_czq_new]
    (
      @BeginDate1 VARCHAR(20) ,
      @EndDate1 VARCHAR(20)
    )
AS
    CREATE TABLE #tt
        (
          日期 VARCHAR(20) ,
          屠宰头数 INT ,
          毛重 DECIMAL(18, 2) ,
          肉重 DECIMAL(18, 2) ,
          实际结算金额 DECIMAL(18, 2) ,
          代宰头数 INT ,
          排酸车间领用量 DECIMAL(18, 2) ,
          分割车间领用量 DECIMAL(18, 2) ,
          屠宰车间入库量 DECIMAL(18, 2) ,
          排酸车间入库量 DECIMAL(18, 2) ,
          分割车间入库量 DECIMAL(18, 2) ,
          代宰户大小肠 DECIMAL(18, 2) ,
          屠宰率 VARCHAR(50) ,
          排酸间损耗量 DECIMAL(18, 2) ,
          排酸车间损耗率 VARCHAR(50) ,
          分割车间损耗量 DECIMAL(18, 2) ,
          分割车间损耗率 VARCHAR(50) ,
          毛猪均重 DECIMAL(18, 2) ,
          壳肉均重 DECIMAL(18, 2) ,
          壳肉含税价 DECIMAL(18, 2) ,
          毛猪含税价 DECIMAL(18, 2)
        );

    DECLARE @BeginDate DATETIME ,
            @EndDate DATETIME;
    SELECT  @BeginDate = @BeginDate1 ,
            @EndDate = @EndDate1;

    DECLARE @BeginDate2 DATETIME;
    SELECT  @BeginDate2 = @BeginDate;

    WHILE ( @BeginDate2 <= @EndDate1 )
        BEGIN
            INSERT  INTO #tt
                    ( 日期 )
            VALUES  ( CONVERT(VARCHAR(12), @BeginDate2, 23) );
            SELECT  @BeginDate2 = @BeginDate2 + 1;
        END; 




    CREATE TABLE #t
        (
          killtime DATETIME ,
          clientname VARCHAR(100) ,
          quantity FLOAT ,
          grossweight FLOAT ,
          [weight] FLOAT ,
          settlemoney FLOAT
        );
    
    INSERT  INTO #t
            EXEC CON12.yrtzdata.dbo.bb_se_getsettledata '11', @BeginDate,
                @EndDate;  



    UPDATE  T
    SET     T.屠宰头数 = D.头数 ,
            T.毛重 = D.毛重 ,
            T.肉重 = D.肉重 ,
            T.实际结算金额 = D.实际结算金额
    FROM    #tt T
            INNER JOIN ( SELECT CONVERT(VARCHAR(20), killtime, 23) ButcherDate ,
                                SUM(quantity) 头数 ,
                                SUM(grossweight) 毛重 ,
                                SUM(weight) 肉重 ,
                                SUM(settlemoney) 实际结算金额
                         FROM   #t
                         GROUP BY CONVERT(VARCHAR(20), killtime, 23)
                       ) D ON D.ButcherDate = T.日期; 



 --修改 代宰头数
    UPDATE  T
    SET     T.代宰头数 = D.FDayTZNum
    FROM    #tt T
            INNER JOIN t_CustDate_EveryDay D ON T.日期 = D.FDate;

 --计算 排酸车间领用量 
    UPDATE  t
    SET     t.排酸车间领用量 = D.FQty
    FROM    #tt t
            INNER JOIN ( SELECT CONVERT(VARCHAR(20), FDate, 23) Fdate ,
                                SUM(u1.FQty) FQty
                         FROM   ICStockBill v1
                                INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN t_ICItem t ON u1.FItemID = t.FItemID
                                LEFT OUTER JOIN t_Department t4 ON v1.FDeptID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN t_Stock t8 ON u1.FSCStockID = t8.FItemID
                                                         AND t8.FItemID <> 0
                         WHERE  1 = 1
                                AND ( v1.FDate BETWEEN @BeginDate AND @EndDate
                                      AND ISNULL(t8.FName, '') NOT LIKE '%1%'
                                      AND ISNULL(t4.FName, '') = '排酸车间'
                                    )
                                AND ( v1.FTranType = 24
                                      AND ( v1.FCancellation = 0 )
                                    )
                         GROUP BY Fdate
                       ) D ON t.日期 = D.Fdate;

  --计算 分割车间领用量 
    UPDATE  t
    SET     t.分割车间领用量 = D.FQty
    FROM    #tt t
            INNER JOIN ( SELECT CONVERT(VARCHAR(20), FDate, 23) Fdate ,
                                SUM(u1.FQty) FQty
                         FROM   ICStockBill v1
                                INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN t_ICItem t ON u1.FItemID = t.FItemID
                                LEFT OUTER JOIN t_Department t4 ON v1.FDeptID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN t_Stock t8 ON u1.FSCStockID = t8.FItemID
                                                         AND t8.FItemID <> 0
                         WHERE  1 = 1
                                AND ( v1.FDate BETWEEN @BeginDate AND @EndDate
--  AND  ISNULL(t8.FName,'') NOT LIKE '%1%'
                                      AND ISNULL(t8.FName, '') NOT LIKE '1号肉业库%'  --郑惠婷提出的需求 2019
                                      AND ISNULL(t8.FName, '') NOT LIKE '%五金%'
                                      AND ISNULL(t4.FName, '') = '分割车间'
                                    )
                                AND ( v1.FTranType = 24
                                      AND ( v1.FCancellation = 0 )
                                    )
                         GROUP BY Fdate
                       ) D ON t.日期 = D.Fdate;

--计算 屠宰车间入库量
    UPDATE  T
    SET     T.屠宰车间入库量 = D.屠宰车间
    FROM    #tt T
            INNER JOIN ( SELECT FFDate fdate ,
                                SUM(R) 屠宰车间
                         FROM   t_yxryCost
                         WHERE  FFDate BETWEEN @BeginDate AND @EndDate
                                AND A = '屠宰车间'
                                AND C <> '代宰客户'
                                AND B <> '合计'
                                AND D<>'7.1.01.01.00160'         --郑惠 婷修改逻辑
                         GROUP BY FFDate
                       ) D ON T.日期 = D.fdate;

--计算 排酸车间入库量
    UPDATE  T
    SET     T.排酸车间入库量 = D.排酸车间
    FROM    #tt T
            INNER JOIN ( SELECT FFDate fdate ,
                                SUM(R) 排酸车间
                         FROM   t_yxryCost
                         WHERE  FFDate BETWEEN @BeginDate AND @EndDate
                                AND A = '排酸车间'
                                AND B <> '合计'
                         GROUP BY FFDate
                       ) D ON T.日期 = D.fdate;

--计算 分割车间入库量
    UPDATE  T
    SET     T.分割车间入库量 = D.分割车间
    FROM    #tt T
            INNER JOIN ( SELECT FFDate fdate ,
                                SUM(R) 分割车间
                         FROM   t_yxryCost
                         WHERE  FFDate BETWEEN @BeginDate AND @EndDate
                                AND A = '分割车间'
                                AND B <> '合计'
                         GROUP BY FFDate
                       ) D ON T.日期 = D.fdate;

 --计算 代宰户大小肠 
    UPDATE  #tt
    SET     代宰户大小肠 = 代宰头数 * 2.35;

 --计算 屠宰率= 屠宰车间入库量/(毛重+代宰户大小肠)
    UPDATE  #tt
    SET     屠宰率 = CAST(CAST((屠宰车间入库量- 代宰户大小肠)  * 100 / ( 毛重 ) AS DECIMAL(18, 2)) AS VARCHAR)
            + '%';

--计算 排酸间损耗量＝排酸车间领用量－排酸车间入库量
    UPDATE  #tt
    SET     排酸间损耗量 = 排酸车间领用量 - 排酸车间入库量;

--计算 排酸车间损耗率 ＝排酸间损耗量 / 排酸车间入库量
    UPDATE  #tt
    SET     排酸车间损耗率 = CAST(CAST(排酸间损耗量 * 100 / ( 排酸车间领用量 ) AS DECIMAL(18, 2)) AS VARCHAR)
            + '%'; 

 --计算 分割车间损耗量＝分割车间领用量－分割车间入库量
    UPDATE  #tt
    SET     分割车间损耗量 = 分割车间领用量 - 分割车间入库量;

 --计算 分割车间损耗率 ＝分割间损耗量 / 分割车间入库量
    UPDATE  #tt
    SET     分割车间损耗率 = CAST(CAST(分割车间损耗量 * 100 / ( 分割车间领用量 ) AS DECIMAL(18, 2)) AS VARCHAR)
            + '%'; 

 --计算 毛猪均重
    UPDATE  #tt
    SET     毛猪均重 = 毛重 / 屠宰头数;

--计算 壳肉均重
    UPDATE  #tt
    SET     壳肉均重 = 肉重 / 屠宰头数;


--计算 壳肉含税价
    UPDATE  #tt
    SET     壳肉含税价 = 实际结算金额 / 肉重;

--计算 毛猪含税价
    UPDATE  #tt
    SET     毛猪含税价 = 实际结算金额 / 毛重;

    SELECT  *
    FROM    #tt;
