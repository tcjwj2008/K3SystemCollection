USE [AIS_YXRY2]
GO
/****** Object:  StoredProcedure [dbo].[sp_TuZaiFengGeCost_NEW]    Script Date: 05/14/2020 09:33:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_TuZaiFengGeCost_NEW_New_qiu] ( @FDate VARCHAR(20) ) --[sp_TuZaiFengGeCost_NEW] '2020-02-23'
AS
    CREATE TABLE #t
        (
          A NVARCHAR(MAX) ,
          B NVARCHAR(MAX) ,
          C NVARCHAR(MAX) ,
          D NVARCHAR(MAX) ,
          E NVARCHAR(MAX) ,
          F NVARCHAR(MAX) ,
          G NVARCHAR(MAX) ,
          H NVARCHAR(MAX) ,
          I FLOAT ,
          J FLOAT ,
          K NVARCHAR(MAX) ,
          L FLOAT ,
          M FLOAT ,
          N NVARCHAR(MAX) ,
          O FLOAT ,
          P FLOAT ,
          Q NVARCHAR(MAX) ,
          R FLOAT ,
          S FLOAT ,
          T FLOAT ,
          U FLOAT ,
          V FLOAT ,
          W FLOAT ,
          X FLOAT ,
          Y FLOAT ,
          Z FLOAT ,
          AA FLOAT ,
          AB FLOAT ,
          CC FLOAT ,
          DD FLOAT ,
          EE NVARCHAR(MAX) ,
          FF FLOAT ,
          FOrderBy FLOAT
        );
--------------------------------------处理 屠宰车间-------------------------------------------------------------------------------------------
    --屠宰车间产品入库数据
    INSERT  INTO #t
            ( A ,
              B ,
              C ,
              D ,
              E ,
              F ,
              G ,
              H ,
              I ,
              L ,
              R ,
              FOrderBy ,
              CC
            )
            SELECT  '屠宰车间' A ,
                    T3.FName B ,
                    T2.FName C ,
                    t.FNumber D ,
                    t.FName E ,
                    T1.FModel F ,
                    U1.FName G ,
                    u2.FName H ,
                    肉品系数 I ,
                    人工系数 L ,
                    t.FQty R ,
                    OrderID FOrderBy ,
                    气调系数 CC
            FROM    ( SELECT    t.FNumber ,
                                t.FName ,
                                SUM(FQty) AS FQty ,
                                P.OrderID ,
                                肉品系数 ,
                                人工系数 ,
                                P.气调系数
                      FROM      dbo.ICStockBillEntry E
                                INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID
                                                              AND B.FCancellation = 0
                                INNER JOIN t_Department t4 ON B.FDeptID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN dbo.t_ICItem t ON E.FItemID = t.FItemID
                                INNER JOIN t_Item_XS_Base_New P ON t.FNumber = P.产品代码
                      WHERE     B.FDate = @FDate
                                AND B.FTranType = 2
                                AND ISNULL(t4.FName, '') = '屠宰车间'
                      GROUP BY  t.FNumber ,
                                t.FName ,
                                P.OrderID ,
                                肉品系数 ,
                                人工系数 ,
                                P.气调系数
                    ) t
                    INNER JOIN dbo.t_ICItem T1 ON t.FNumber = T1.FNumber
                    INNER JOIN dbo.t_Item T2 ON T1.FParentID = T2.FItemID
                    INNER JOIN dbo.t_Item T3 ON T2.FParentID = T3.FItemID
                    LEFT JOIN t_MeasureUnit U1 ON U1.FItemID = T1.FUnitID
                    LEFT JOIN t_MeasureUnit u2 ON u2.FItemID = T1.FSecUnitID
            ORDER BY OrderID;

    --代宰客户
    INSERT  INTO #t
            ( A ,
              B ,
              C ,
              D ,
              E ,
              F ,
              G ,
              H ,
              I ,
              L ,
              R ,
              FOrderBy ,
              CC
            )
            SELECT  '屠宰车间' A ,
                    '' B ,
                    '代宰客户' C ,
                    '7.9.99.99.99999' D ,
                    '代宰业务(头数)' E ,
                    '' F ,
                    '' G ,
                    FDayTZNum H ,
                    肉品系数 I ,
                    人工系数 L ,
                    FDayTZNum * 93 R ,
                    OrderID FOrderBy ,
                    1
            FROM    t_CustDate_EveryDay t
                    INNER JOIN t_Item_XS_Base_New b ON b.产品代码 = '7.9.99.99.99999'
            WHERE   FDate = @FDate;

--计算分摊标准数量 J=I*R
    UPDATE  #t
    SET     J = I * R ,
            M = L * R ,
            DD = CC * R
    WHERE   A = '屠宰车间';
    DECLARE @J_Sun FLOAT; --计算J列总和
    DECLARE @M_Sun FLOAT; --计算M列总和
    DECLARE @DD_Sun FLOAT; --计算DD列总和
    SELECT  @J_Sun = SUM(J) ,
            @M_Sun = SUM(M) ,
            @DD_Sun = SUM(DD)
    FROM    #t
    WHERE   A = '屠宰车间';


    IF @DD_Sun = 0
        SET @DD_Sun = 0.000000000000000001;

    UPDATE  #t
    SET     K = CAST(CAST(( J / @J_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%' ,  --肉品分摊率
            N = CAST(CAST(( M / @M_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%'  --人工分摊率
            ,
            EE = CAST(CAST(( DD / @DD_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%'--增加气调分摊率
    WHERE   A = '屠宰车间';
 
--处理包装费用
    UPDATE  #t
    SET     O = 1 ,
            P = 1 * R
    WHERE   B = '冻品';
    DECLARE @P_Sun FLOAT; --计算P列总和
    SELECT  @P_Sun = SUM(P)
    FROM    #t
    WHERE   A = '屠宰车间'
            AND B = '冻品';
    UPDATE  #t
    SET     Q = CAST(CAST(( P / @P_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%'
    WHERE   A = '屠宰车间'
            AND B = '冻品';

--计算U列汇总
    DECLARE @U_Sun FLOAT;
    DECLARE @QHC FLOAT ,
            @DZNum FLOAT;

    CREATE TABLE #tg
        (
          killtime DATETIME ,
          clientname VARCHAR(100) ,
          quantity FLOAT ,
          grossweight FLOAT ,
          [weight] FLOAT ,
          settlemoney FLOAT
        );    
    INSERT  INTO #tg
            EXEC CON12.yrtzdata.dbo.bb_se_getsettledata_new_qiu '11', @FDate,
                @FDate;
   
   
--INSERT INTO #tg    SELECT * FROM con12.yrtzdata.dbo.tmp_20200101 
--成本由原来的0.9 在2019年09月26日 
--生猪结算单上的结算金额之和乘以系数０.９１

    SELECT  @QHC = ROUND(SUM(settlemoney) * 0.91, 2)
    FROM    #tg; 
    DECLARE @FTZXS INT; 
    SELECT  @FTZXS = FTZXS
    FROM    t_CustDate_EveryDay
    WHERE   FDate = @FDate;--调整系数
--2代宰客户  代宰头数*36
    SELECT  @DZNum = H * @FTZXS
    FROM    #t
    WHERE   A = '屠宰车间'
            AND C = '代宰客户';
--3调整数据
    DECLARE @FTZMoney FLOAT; 
    SELECT  @FTZMoney = FTZMoney
    FROM    t_CustDate_EveryDay
    WHERE   FDate = @FDate; 
    SELECT  @U_Sun = @QHC + @DZNum + @FTZMoney;
    UPDATE  #t
    SET     U = CAST(( J / @J_Sun ) * @U_Sun AS DECIMAL(18, 2))
    WHERE   A = '屠宰车间';

    DECLARE @V_Sun FLOAT;  --物质采购金额
    DECLARE @X_Sun FLOAT;  --屠宰包装金额
    DECLARE @AA_Sun FLOAT; --屠宰直接人工金额
    DECLARE @AB_Sun FLOAT; --屠宰制造费用金额
    DECLARE @FF_Sun FLOAT; --屠宰气调费用金额

    SELECT  @V_Sun = FPurchaseAmount ,
            @X_Sun = FCartonAmount ,
            @AA_Sun = FWorkerAmount ,
            @AB_Sun = FProduceAmount ,
            @FF_Sun = txtMapAccount1
    FROM    t_CustDate_PerMonth
    WHERE   FDate = SUBSTRING(@FDate, 1, 7);

--计算V列--物资采购费用
    UPDATE  #t
    SET     V = CAST(( J / @J_Sun ) * @V_Sun AS DECIMAL(18, 2))
    WHERE   A = '屠宰车间';
--计算FF列--屠宰气调费用
    UPDATE  #t
    SET     FF = CAST(( DD / @DD_Sun ) * @FF_Sun AS DECIMAL(18, 2))
    WHERE   A = '屠宰车间';
--计算W列--屠宰暂存库
    UPDATE  #t
    SET     W = 0.00
    WHERE   A = '屠宰车间';
--计算X列--包装物（包装费用）
    UPDATE  #t
    SET     X = CAST(( P / @P_Sun ) * @X_Sun AS DECIMAL(18, 2))
    WHERE   A = '屠宰车间'
            AND B = '冻品';
--计算Y列 --其他
    UPDATE  #t
    SET     Y = 0.00
    WHERE   A = '屠宰车间';
--计算Z列 --材料成本小计（物资采购金额+云睿屠宰数据+日代宰金额+日调整金额+屠宰暂存库+包装费用+其他费用）
    UPDATE  #t
    SET     Z = ISNULL(U, 0) + ISNULL(V, 0) + ISNULL(W, 0) + ISNULL(X, 0)
            + ISNULL(Y, 0)
    WHERE   A = '屠宰车间';
--计算AA,AB列
    UPDATE  #t
    SET     AA = CAST(( M / @M_Sun ) * @AA_Sun AS DECIMAL(18, 2)) ,
            AB = CAST(( M / @M_Sun ) * @AB_Sun AS DECIMAL(18, 2))
    WHERE   A = '屠宰车间'; 
--计算T列 增加了气调费用+直接人工费用+制造费用
    UPDATE  #t
    SET     T = ISNULL(Z, 0) + ISNULL(AA, 0) + ISNULL(AB, 0) + ISNULL(FF, 0)
    WHERE   A = '屠宰车间';
--计算S列
    UPDATE  #t
    SET     S = CAST(( T / CASE WHEN R = 0 THEN 1
                                ELSE R
                           END ) AS DECIMAL(18, 2))
    WHERE   A = '屠宰车间';			



   
    DELETE  FROM t_tzprice
    WHERE   D IN ( SELECT   D
                   FROM     #t
                   WHERE    S > 0 );
    INSERT  INTO t_tzprice
            ( A ,
              D ,
              E ,
              S ,
              fdate
            )
            SELECT  A ,
                    D ,
                    E ,
                    S ,
                    @FDate
            FROM    #t
            WHERE   S > 0;	
   	

---------------------处理排酸车间----------------------------------------

--插入排酸部门产品入库单20200226
    INSERT  INTO #t
            ( A ,
              B ,
              C ,
              D ,
              E ,
              F ,
              G ,
              H ,
              I ,
              L ,
              R ,
              FOrderBy
            )
            SELECT  '排酸车间' A ,
                    T3.FName B ,
                    T2.FName C ,
                    t.FNumber D ,
                    t.FName E ,
                    T1.FModel F ,
                    U1.FName G ,
                    u2.FName H ,
                    肉品系数 I ,
                    人工系数 L ,
                    t.FQty R ,
                    OrderID FOrderBy
            FROM    ( SELECT    t.FNumber ,
                                t.FName ,
                                SUM(FQty) AS FQty ,
                                P.OrderID ,
                                肉品系数 ,
                                人工系数
                      FROM      dbo.ICStockBillEntry E
                                INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID
                                                              AND B.FCancellation = 0
                                INNER JOIN t_Department t4 ON B.FDeptID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN dbo.t_ICItem t ON E.FItemID = t.FItemID
                                INNER JOIN t_Item_XS_Base_New P ON t.FNumber = P.产品代码
                      WHERE     B.FDate = @FDate
                                AND B.FTranType = 2
                                AND ISNULL(t4.FName, '') = '排酸车间'
                      GROUP BY  t.FNumber ,
                                t.FName ,
                                P.OrderID ,
                                肉品系数 ,
                                人工系数
                    ) t
                    INNER JOIN dbo.t_ICItem T1 ON t.FNumber = T1.FNumber
                    INNER JOIN dbo.t_Item T2 ON T1.FParentID = T2.FItemID
                    INNER JOIN dbo.t_Item T3 ON T2.FParentID = T3.FItemID
                    LEFT JOIN t_MeasureUnit U1 ON U1.FItemID = T1.FUnitID
                    LEFT JOIN t_MeasureUnit u2 ON u2.FItemID = T1.FSecUnitID
            ORDER BY OrderID;
            
--计算分摊标准数量 J=I*R 肉品系数 （肉品分摊数量 2020）

    UPDATE  #t
    SET     J = I * R
    WHERE   A = '排酸车间';
    
--修改特殊物料对应的肉品分推数量2020-02-26
    UPDATE  #t
    SET     J = 0
    WHERE   A = '排酸车间'
            AND D IN ( '7.1.01.01.00685', '8.8.01.00020' );
    
--计算肉品分摊数量和 J列汇总 2020

    SELECT  @J_Sun = SUM(J)
    FROM    #t
    WHERE   A = '排酸车间';

--计算K列
    UPDATE  #t
    SET     K = CAST(CAST(( J / @J_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%'
    WHERE   A = '排酸车间';

    UPDATE  #t
    SET     L = NULL ,
            M = 0 ,
            N = '0.00%' ,
            O = 0 ,
            P = 0 ,
            Q = '0.00%' ,
            CC = 0 ,
            DD = 0 ,
            EE = '0.00%'
    WHERE   A = '排酸车间';

    SELECT  t.FNumber ,
            u1.FQty ,
            'n' AS stockid
    INTO    #t_PS
    FROM    ICStockBill v1
            INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                              AND u1.FInterID <> 0
            INNER JOIN t_ICItem t ON u1.FItemID = t.FItemID
            LEFT OUTER JOIN t_Department t4 ON v1.FDeptID = t4.FItemID
                                               AND t4.FItemID <> 0
            INNER JOIN t_Stock t8 ON u1.FSCStockID = t8.FItemID
                                     AND t8.FItemID <> 0
    WHERE   1 = 1
            AND u1.FSCStockID <> 240
            AND ( v1.FDate = @FDate 
  --AND  ISNULL(t8.FName,'') NOT LIKE '%1%'        -- 20190919去除过滤1.开头仓库
                  AND ISNULL(t4.FName, '') = '排酸车间'
                )
            AND ( v1.FTranType = 24
                  AND ( v1.FCancellation = 0 )
                );
  
  
  --分外购和内产两种,以下为外购进来的单价计算
    INSERT  INTO #t_PS
            SELECT  t.FNumber ,
                    u1.FQty ,
                    'w' AS stockid
            FROM    ICStockBill v1
                    INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                      AND u1.FInterID <> 0
                    INNER JOIN t_ICItem t ON u1.FItemID = t.FItemID
                    LEFT OUTER JOIN t_Department t4 ON v1.FDeptID = t4.FItemID
                                                       AND t4.FItemID <> 0
                    INNER JOIN t_Stock t8 ON u1.FSCStockID = t8.FItemID
                                             AND t8.FItemID <> 0
            WHERE   1 = 1
  
  -- AND u1.FSCStockID=240 
                    AND ( v1.FDate = @FDate 
  -- AND  ISNULL(t8.FName,'') NOT LIKE '%1%'         --20190919去除过滤1.开头仓库
                          AND ISNULL(t4.FName, '') = '排酸车间'
                        )
                    AND ( v1.FTranType = 24
                          AND ( v1.FCancellation = 0 )
                        );
 
    ALTER TABLE #t_PS ADD FPrice FLOAT; --金额
 
    UPDATE  P
    SET     P.FPrice = t.S
    FROM    #t_PS P
            INNER JOIN #t t ON P.FNumber = t.D
                               AND t.A = '屠宰车间'
                               AND P.stockid = 'n';

--外购单价计算逻辑开始,增加临时表#t_WGprice
    DECLARE @BegDate VARCHAR(100); --开始日期   -- 取本月第一天
    SET @BegDate = CONVERT(VARCHAR(10), DATEPART(YEAR, GETDATE())) + '-'
        + CONVERT(VARCHAR(10), DATEPART(MONTH, GETDATE())) + '-01';
       
    SET @BegDate = CONVERT(VARCHAR(100), CONVERT(DATETIME, @FDate) - 3);       
    SELECT  t13.FNumber ,
            SUM(u1.FQty) AS sumFqty ,
            SUM(u1.FAmount) AS sumFamount ,
            CASE SUM(u1.FQty)
              WHEN 0 THEN 0
              ELSE SUM(u1.FAmount) / SUM(u1.FQty)
            END AS rate
    INTO    #t_WGprice
    FROM    ICStockBill v1
            INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                              AND u1.FInterID <> 0
            INNER JOIN t_ICItem t13 ON u1.FItemID = t13.FItemID
                                       AND t13.FItemID <> 0
    WHERE   1 = 1
            AND ( v1.FDate >= @BegDate )
            AND v1.FDate <= GETDATE()
            AND ( v1.FTranType = 1 )
            AND v1.FCancellation = 0            --未作废单据
            AND v1.FStatus = 1                  --己审核单据
GROUP BY    t13.FNumber;

    UPDATE  P
    SET     P.FPrice = Wg.rate
    FROM    #t_PS P
            INNER JOIN #t_WGprice Wg ON P.FNumber = Wg.FNumber
                                        AND P.stockid = 'w';
  --外购单价计算逻辑结束




  ---针对排酸成本价从暂存库领出没有单价作出的修改 

                                      
                                        
   
    UPDATE  P
    SET     P.FPrice = t_tzprice.S
    FROM    #t_PS P
            INNER JOIN t_tzprice ON P.FNumber = t_tzprice.D
                                    AND P.FPrice = 0;    




--20200226因业务核算问题，需信息部支持，对于每日排酸成品仓入库的冷鲜带蹄白条A级（代码7.1.01.01.00685）和冷鲜带蹄黑猪A级（代码8.8.01.00020）的单位成本，取数于每日外购产品仓入库的冷鲜白条1级（代码8.8.01.00030）和冷鲜黑猪白条1级（8.8.01.00040）的平均单价

    DECLARE @zhtprice1 FLOAT;
    DECLARE @zhtprice2 FLOAT;
    SELECT  @zhtprice2 = rate
    FROM    #t_WGprice Wg
    WHERE   Wg.FNumber = '8.8.01.00040';
    SELECT  @zhtprice1 = rate
    FROM    #t_WGprice Wg
    WHERE   Wg.FNumber = '8.8.01.00030';
    UPDATE  #t_PS
    SET     FPrice = @zhtprice1
    WHERE   FNumber = '7.1.01.01.00685';
    UPDATE  #t_PS
    SET     FPrice = @zhtprice2
    WHERE   FNumber = '8.8.01.00020';                                   


--20200226因业务核算问题，需信息部支持，对于每日排酸成品仓入库的冷鲜带蹄白条A级（代码7.1.01.01.00685）和冷鲜带蹄黑猪A级（代码8.8.01.00020）的单位成本，取数于每日外购产品仓入库的冷鲜白条1级（代码8.8.01.00030）和冷鲜黑猪白条1级（8.8.01.00040）的平均单价





--计算U列
    SELECT  @U_Sun = SUM(FPrice * FQty)
    FROM    #t_PS
    
--排除两个特殊物料2020-02-26
    WHERE   FNumber NOT IN ( '8.8.01.00030', '8.8.01.00040' );
    
    UPDATE  #t
    SET     FF = 0
    WHERE   A = '排酸车间';
    
    UPDATE  #t
    SET     U = CAST(( @U_Sun * ( J / @J_Sun ) ) AS DECIMAL(18, 2))
    WHERE   A = '排酸车间';

    DROP TABLE #t_PS;

--计算Z列
    UPDATE  #t
    SET     Z = U ,
            T = U
    WHERE   A = '排酸车间';
    
    
    

--计算S列
    UPDATE  #t
    SET     S = CAST(( T / CASE WHEN R = 0 THEN 1
                                ELSE R
                           END ) AS DECIMAL(18, 2))
    WHERE   A = '排酸车间';	
    
    
--计算特殊的S列2020-02-26
 
    UPDATE  #t
    SET     S = CAST(@zhtprice1 AS DECIMAL(18, 2))
    WHERE   A = '排酸车间'
            AND D = '7.1.01.01.00685';   
    
    UPDATE  #t
    SET     S = CAST(@zhtprice2 AS DECIMAL(18, 2))
    WHERE   A = '排酸车间'
            AND D = '8.8.01.00020';   
    
    
    UPDATE  #t
    SET     T = CAST(R * S AS DECIMAL(18, 2))
    WHERE   A = '排酸车间'
            AND D = '7.1.01.01.00685';   
    
    UPDATE  #t
    SET     T = CAST(R * S AS DECIMAL(18, 2))
    WHERE   A = '排酸车间'
            AND D = '8.8.01.00020';  
----------------------------------------处理分割车间-------------------------------------------------------
    INSERT  INTO #t
            ( A ,
              B ,
              C ,
              D ,
              E ,
              F ,
              G ,
              H ,
              I ,
              L ,
              R ,
              FOrderBy ,
              CC
            )
            SELECT  '分割车间' A ,
                    T3.FName B ,
                    T2.FName C ,
                    t.FNumber D ,
                    t.FName E ,
                    T1.FModel F ,
                    U1.FName G ,
                    u2.FName H ,
                    肉品系数 I ,
                    人工系数 L ,
                    t.FQty R ,
                    OrderID FOrderBy ,
                    气调系数 CC
            FROM    ( SELECT    t.FNumber ,
                                t.FName ,
                                SUM(FQty) AS FQty ,
                                P.OrderID ,
                                肉品系数 ,
                                人工系数 ,
                                气调系数
                      FROM      dbo.ICStockBillEntry E
                                INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID
                                                              AND B.FCancellation = 0
                                INNER JOIN t_Department t4 ON B.FDeptID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN dbo.t_ICItem t ON E.FItemID = t.FItemID
                                INNER JOIN t_Item_XS_Base_New P ON t.FNumber = P.产品代码
                      WHERE     B.FDate = @FDate
                                AND B.FTranType = 2
                                AND ISNULL(t4.FName, '') = '分割车间'
                      GROUP BY  t.FNumber ,
                                t.FName ,
                                P.OrderID ,
                                肉品系数 ,
                                人工系数 ,
                                P.气调系数
                    ) t
                    INNER JOIN dbo.t_ICItem T1 ON t.FNumber = T1.FNumber
                    INNER JOIN dbo.t_Item T2 ON T1.FParentID = T2.FItemID
                    INNER JOIN dbo.t_Item T3 ON T2.FParentID = T3.FItemID
                    LEFT JOIN t_MeasureUnit U1 ON U1.FItemID = T1.FUnitID
                    LEFT JOIN t_MeasureUnit u2 ON u2.FItemID = T1.FSecUnitID
            ORDER BY OrderID;

    --计算分摊标准数量 J=I*R
    UPDATE  #t
    SET     J = I * R ,
            M = L * R ,
            DD = CC * R
    WHERE   A = '分割车间';
    
    SELECT  @J_Sun = SUM(J) ,
            @M_Sun = SUM(M) ,
            @DD_Sun = SUM(DD)
    FROM    #t
    WHERE   A = '分割车间';

    IF @DD_Sun = 0
        SET @DD_Sun = 0.000000000000000001;

    UPDATE  #t
    SET     K = CAST(CAST(( J / @J_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%' ,
            N = CAST(CAST(( M / @M_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%' ,
            EE = CAST(CAST(( DD / @DD_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%'
    WHERE   A = '分割车间';
 
    --处理包装类
    UPDATE  #t
    SET     O = 1 ,
            P = 1 * R
    WHERE   B = '冻品';
    SELECT  @P_Sun = SUM(P)
    FROM    #t
    WHERE   A = '分割车间'
            AND B = '冻品';
    UPDATE  #t
    SET     Q = CAST(CAST(( P / @P_Sun ) * 100 AS DECIMAL(18, 2)) AS VARCHAR)
            + '%'
    WHERE   A = '分割车间'
            AND B = '冻品';

    SELECT  t.FNumber ,
            u1.FQty ,
            u1.FPrice ,
            'n' AS stockid
    INTO    #t_FG
    FROM    ICStockBill v1
            INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                              AND u1.FInterID <> 0
            INNER JOIN t_ICItem t ON u1.FItemID = t.FItemID
            LEFT OUTER JOIN t_Department t4 ON v1.FDeptID = t4.FItemID
                                               AND t4.FItemID <> 0
            INNER JOIN t_Stock t8 ON u1.FSCStockID = t8.FItemID
                                     AND t8.FItemID <> 0
    WHERE   1 = 1
            AND u1.FSCStockID <> 240                          --非外购仓库仓库生产领料
            AND ( v1.FDate = @FDate 
            --AND  ISNULL(t8.FName,'') NOT LIKE '%1%'         --20190919去除过滤1.开头仓库
                  AND ISNULL(t4.FName, '') = '分割车间'
                )
            AND ( v1.FTranType = 24
                  AND ( v1.FCancellation = 0 )
                );
 --SELECT *FROM #t_FG;
    INSERT  INTO #t_FG
            SELECT  t.FNumber ,
                    u1.FQty ,
                    u1.FPrice ,
                    'w' AS stockid
            FROM    ICStockBill v1
                    INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                      AND u1.FInterID <> 0
                    INNER JOIN t_ICItem t ON u1.FItemID = t.FItemID
                    LEFT OUTER JOIN t_Department t4 ON v1.FDeptID = t4.FItemID
                                                       AND t4.FItemID <> 0
                    INNER JOIN t_Stock t8 ON u1.FSCStockID = t8.FItemID
                                             AND t8.FItemID <> 0
            WHERE   1 = 1
                    AND u1.FSCStockID = 240                         -- 20190919 外购仓的生产领料 去除掉外购仓计算标准
                    AND ( v1.FDate = @FDate 
                    --AND  ISNULL(t8.FName,'') NOT LIKE '%1%'       -- 20190919去除过滤1.开头仓库
                          AND ISNULL(t4.FName, '') = '分割车间'
                        )
                    AND ( v1.FTranType = 24
                          AND ( v1.FCancellation = 0 )
                        );

--内产的直接更新领料单价 20190524
    UPDATE  P
    SET     P.FPrice = t.S
    FROM    #t_FG P
            INNER JOIN #t t ON P.FNumber = t.D
                               AND t.A = '排酸车间'
                               AND P.stockid = 'n'
                               AND t.s IS NOT null;--排除800行转码时带ＮＵＬＬ单价错误
--内产的直接更新领料单价 20190524
    UPDATE  P
    SET     P.FPrice = t.S
    FROM    #t_FG P
            INNER JOIN #t t ON P.FNumber = t.D
                               AND t.A = '屠宰车间'
                               AND P.stockid = 'n'
                               AND t.s IS NOT null;--排除800行转码时带ＮＵＬＬ单价错误
                              

--外购单价计算逻辑开始,增加临时表#t_WGprice1
    DECLARE @BegDate1 VARCHAR(100); --开始日期   -- 取本月第一天
--开始日期不取本月第一天，取查询日期前三天
--SET @BegDate1 = CONVERT(VARCHAR(10), DATEPART(YEAR, GETDATE())) + '-'
--    + CONVERT(VARCHAR(10), DATEPART(MONTH, GETDATE())) + '-01'
       
       
    SET @BegDate1 = CONVERT(VARCHAR(100), CONVERT(DATETIME, @FDate) - 3);     
    SELECT  t13.FNumber ,
            SUM(u1.FQty) AS sumFqty ,
            SUM(u1.FAmount) AS sumFamount ,
            CASE SUM(u1.FQty)
              WHEN 0 THEN 0
              ELSE SUM(u1.FAmount) / SUM(u1.FQty)
            END AS rate
    INTO    #t_WGprice1
    FROM    ICStockBill v1
            INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                              AND u1.FInterID <> 0
            INNER JOIN t_ICItem t13 ON u1.FItemID = t13.FItemID
                                       AND t13.FItemID <> 0
    WHERE   1 = 1
            AND ( v1.FDate >= @BegDate1 )
            AND v1.FDate <= GETDATE()
            AND ( v1.FTranType = 1 )
            AND v1.FCancellation = 0          --未作废单据
            AND v1.FStatus = 1                --己审核单据
GROUP BY    t13.FNumber;

    UPDATE  P
    SET     P.FPrice = Wg1.rate
    FROM    #t_FG P
            INNER JOIN #t_WGprice1 Wg1 ON P.FNumber = Wg1.FNumber
                                          AND P.stockid = 'w';
--SELECT * FROM #t_WGprice1


----对于外购入到非外购仓时，需要更新单价
    UPDATE  P
    SET     P.FPrice = Wg1.rate
    FROM    #t_FG P
            INNER JOIN #t_WGprice1 Wg1 ON P.FNumber = Wg1.FNumber
                                          AND P.FPrice = 0;
------对于外购入到非外购仓时，需要更新单价



--20200226因业务核算问题，需信息部支持，对于每日排酸成品仓入库的冷鲜带蹄白条A级（代码7.1.01.01.00685）和冷鲜带蹄黑猪A级（代码8.8.01.00020）的单位成本，取数于每日外购产品仓入库的冷鲜白条1级（代码8.8.01.00030）和冷鲜黑猪白条1级（8.8.01.00040）的平均单价

    DECLARE @zhtprice3 FLOAT;
    DECLARE @zhtprice4 FLOAT;
    SELECT  @zhtprice4 = rate
    FROM    #t_WGprice Wg
    WHERE   Wg.FNumber = '8.8.01.00040';
    SELECT  @zhtprice3 = rate
    FROM    #t_WGprice Wg
    WHERE   Wg.FNumber = '8.8.01.00030';
   IF @zhtprice3 IS NOT NULL 
    begin
		UPDATE  #t_FG
		SET     FPrice = @zhtprice3
		WHERE   FNumber = '7.1.01.01.00685';
    END
    IF @zhtprice4 IS NOT NULL
    begin
		UPDATE  #t_FG
		SET     FPrice = @zhtprice4
		WHERE   FNumber = '8.8.01.00020';                                   
    END;                                  


--20200226因业务核算问题，需信息部支持，对于每日排酸成品仓入库的冷鲜带蹄白条A级（代码7.1.01.01.00685）和冷鲜带蹄黑猪A级（代码8.8.01.00020）的单位成本，取数于每日外购产品仓入库的冷鲜白条1级（代码8.8.01.00030）和冷鲜黑猪白条1级（8.8.01.00040）的平均单价





--SELECT * FROM #t_FG
    SELECT  @U_Sun = SUM(FPrice * FQty)
    FROM    #t_FG;
    UPDATE  #t
    SET     U = CAST(( @U_Sun * ( J / @J_Sun ) ) AS DECIMAL(18, 2))
    WHERE   A = '分割车间';
--SELECT * FROM #t_FG
    DROP TABLE #t_FG;
--计算Z列
    UPDATE  #t
    SET     Z = ISNULL(U, 0) + ISNULL(X, 0)
    WHERE   A = '分割车间';

    SELECT  @AA_Sun = FWorkerAmount2 ,
            @AB_Sun = FProduceAmount2 ,
            @X_Sun = FWeaveAmount ,
            @FF_Sun = txtMapAccount2
    FROM    t_CustDate_PerMonth
    WHERE   FDate = SUBSTRING(@FDate, 1, 7);

--计算X列
    UPDATE  #t
    SET     X = CAST(( P / @P_Sun ) * @X_Sun AS DECIMAL(18, 2))
    WHERE   A = '分割车间'
            AND B = '冻品';
--计算FF列--屠宰气调费用
    UPDATE  #t
    SET     FF = CAST(( DD / @DD_Sun ) * @FF_Sun AS DECIMAL(18, 2))
    WHERE   A = '分割车间';
    UPDATE  #t
    SET     Z = ISNULL(U, 0) + ISNULL(X, 0)
    WHERE   A = '分割车间';         
--计算AA,AB列
    UPDATE  #t
    SET     AA = CAST(( M / @M_Sun ) * @AA_Sun AS DECIMAL(18, 2)) ,
            AB = CAST(( M / @M_Sun ) * @AB_Sun AS DECIMAL(18, 2))
    WHERE   A = '分割车间'; 

--计算T列 增加气调费用
    UPDATE  #t
    SET     T = ISNULL(Z, 0) + ISNULL(AA, 0) + ISNULL(AB, 0) + ISNULL(FF, 0)
    WHERE   A = '分割车间';
--计算S列
    UPDATE  #t
    SET     S = CAST(( T / CASE WHEN R = 0 THEN 1
                                ELSE R
                           END ) AS DECIMAL(18, 2))
    WHERE   A = '分割车间';


--结果
    DELETE  FROM t_yxryCost
    WHERE   FFDate = @FDate;
    INSERT  INTO t_yxryCost
            ( A ,
              B ,
              C ,
              D ,
              E ,
              F ,
              G ,
              H ,
              I ,
              J ,
              K ,
              L ,
              M ,
              N ,
              O ,
              P ,
              Q ,
              R ,
              S ,
              T ,
              U ,
              V ,
              W ,
              X ,
              Y ,
              Z ,
              AA ,
              AB ,
              FOrderBy ,
              CC ,
              DD ,
              EE ,
              FF ,
              FFDate
            )
            SELECT  A ,
                    B ,
                    C ,
                    D ,
                    E ,
                    F ,
                    G ,
                    H ,
                    I ,
                    J ,
                    K ,
                    L ,
                    M ,
                    N ,
                    O ,
                    P ,
                    Q ,
                    R ,
                    S ,
                    T ,
                    U ,
                    V ,
                    W ,
                    X ,
                    Y ,
                    Z ,
                    AA ,
                    AB ,
                    FOrderBy ,
                    CC ,
                    DD ,
                    EE ,
                    FF ,
                    @FDate
            FROM    #t;

    INSERT  INTO t_yxryCost
            ( A ,
              B ,
              R ,
              T ,
              U ,
              V ,
              W ,
              X ,
              Y ,
              Z ,
              AA ,
              AB ,
              FF ,
              FFDate ,
              FOrderBy  
            )
            SELECT  '屠宰车间' A ,
                    '合计' B ,
                    CAST(SUM(ISNULL(R, 0)) AS DECIMAL(18, 2)) R ,
                    CAST(SUM(ISNULL(T, 0)) AS DECIMAL(18, 2)) T ,
                    CAST(SUM(ISNULL(U, 0)) AS DECIMAL(18, 2)) U ,
                    CAST(SUM(ISNULL(V, 0)) AS DECIMAL(18, 2)) V ,
                    CAST(SUM(ISNULL(W, 0)) AS DECIMAL(18, 2)) W ,
                    CAST(SUM(ISNULL(X, 0)) AS DECIMAL(18, 2)) X ,
                    CAST(SUM(ISNULL(Y, 0)) AS DECIMAL(18, 2)) Y ,
                    CAST(SUM(ISNULL(Z, 0)) AS DECIMAL(18, 2)) Z ,
                    CAST(SUM(ISNULL(AA, 0)) AS DECIMAL(18, 2)) AA ,
                    CAST(SUM(ISNULL(AB, 0)) AS DECIMAL(18, 2)) AB ,
                    CAST(SUM(ISNULL(FF, 0)) AS DECIMAL(18, 2)) FF ,
                    @FDate FFDate ,
                    9997
            FROM    #t
            WHERE   A = '屠宰车间';

    INSERT  INTO t_yxryCost
            ( A ,
              B ,
              R ,
              T ,
              U ,
              V ,
              W ,
              X ,
              Y ,
              Z ,
              AA ,
              AB ,
              FF ,
              FFDate ,
              FOrderBy   
            )
            SELECT  '排酸车间' A ,
                    '合计' B ,
                    CAST(SUM(ISNULL(R, 0)) AS DECIMAL(18, 2)) R ,
                    CAST(SUM(ISNULL(T, 0)) AS DECIMAL(18, 2)) T ,
                    CAST(SUM(ISNULL(U, 0)) AS DECIMAL(18, 2)) U ,
                    CAST(SUM(ISNULL(V, 0)) AS DECIMAL(18, 2)) V ,
                    CAST(SUM(ISNULL(W, 0)) AS DECIMAL(18, 2)) W ,
                    CAST(SUM(ISNULL(X, 0)) AS DECIMAL(18, 2)) X ,
                    CAST(SUM(ISNULL(Y, 0)) AS DECIMAL(18, 2)) Y ,
                    CAST(SUM(ISNULL(Z, 0)) AS DECIMAL(18, 2)) Z ,
                    CAST(SUM(ISNULL(AA, 0)) AS DECIMAL(18, 2)) AA ,
                    CAST(SUM(ISNULL(AB, 0)) AS DECIMAL(18, 2)) AB ,
                    CAST(SUM(ISNULL(FF, 0)) AS DECIMAL(18, 2)) FF ,
                    @FDate FFDate ,
                    9998
            FROM    #t
            WHERE   A = '排酸车间';        
   
    INSERT  INTO t_yxryCost
            ( A ,
              B ,
              R ,
              T ,
              U ,
              V ,
              W ,
              X ,
              Y ,
              Z ,
              AA ,
              AB ,
              FF ,
              FFDate ,
              FOrderBy   
            )
            SELECT  '分割车间' A ,
                    '合计' B ,
                    CAST(SUM(ISNULL(R, 0)) AS DECIMAL(18, 2)) R ,
                    CAST(SUM(ISNULL(T, 0)) AS DECIMAL(18, 2)) T ,
                    CAST(SUM(ISNULL(U, 0)) AS DECIMAL(18, 2)) U ,
                    CAST(SUM(ISNULL(V, 0)) AS DECIMAL(18, 2)) V ,
                    CAST(SUM(ISNULL(W, 0)) AS DECIMAL(18, 2)) W ,
                    CAST(SUM(ISNULL(X, 0)) AS DECIMAL(18, 2)) X ,
                    CAST(SUM(ISNULL(Y, 0)) AS DECIMAL(18, 2)) Y ,
                    CAST(SUM(ISNULL(Z, 0)) AS DECIMAL(18, 2)) Z ,
                    CAST(SUM(ISNULL(AA, 0)) AS DECIMAL(18, 2)) AA ,
                    CAST(SUM(ISNULL(AB, 0)) AS DECIMAL(18, 2)) AB ,
                    CAST(SUM(ISNULL(FF, 0)) AS DECIMAL(18, 2)) FF ,
                    @FDate FFDate ,
                    9999
            FROM    #t
            WHERE   A = '分割车间';    

    SELECT  *
    FROM    t_yxryCost
    WHERE   FFDate = @FDate
    ORDER BY FOrderBy;





