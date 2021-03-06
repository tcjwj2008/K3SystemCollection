USE [AIS_YXRY2]
GO
/****** Object:  StoredProcedure [dbo].[sp_TuZaiFengGeCost_NEW]    Script Date: 05/29/2019 09:21:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_TuZaiFengGeCost_NEW]
(
 @FDate VARCHAR(20)
)
AS 

--临时表结构
CREATE TABLE #t
(
A nvarchar(MAX),B nvarchar(MAX),C nvarchar(MAX),D nvarchar(MAX),E nvarchar(MAX),F nvarchar(MAX),
G nvarchar(MAX),H nvarchar(MAX),
I FLOAT,J FLOAT,K nvarchar(MAX),
L FLOAT,M FLOAT,N nvarchar(MAX),
O FLOAT,P FLOAT,Q nvarchar(MAX),
R FLOAT,S FLOAT,T FLOAT,U FLOAT,V FLOAT,W FLOAT,X FLOAT,Y FLOAT,Z FLOAT,AA FLOAT,AB FLOAT,FOrderBy FLOAT
)
-----------------------------------------------------------------------------------------------------------

--处理 屠宰车间
INSERT INTO #t(A,B,C,D,E,F,G,H,I,L,R,FOrderBy)
SELECT '屠宰车间' A, t3.FName B,t2.FName C,t.FNumber D,T.FName E, t1.FModel F,U1.FName G,U2.FName H,
肉品系数 I,人工系数 L,T.FQty R ,OrderID FOrderBy FROM 
(SELECT   T.FNumber,T.FName,SUM(FQty) AS FQty,p.OrderID,肉品系数,人工系数    FROM dbo.ICStockBillEntry E 
INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID AND b.FCancellation=0
INNER JOIN t_Department t4 ON     b.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN dbo.t_ICItem T ON E.FItemID=T.FItemID
INNER JOIN t_Item_XS_Base_New P ON T.FNumber=P.产品代码 
WHERE B.FDate=@FDate AND B.FTranType=2 and ISNULL(t4.FName,'') = '屠宰车间' 
GROUP BY T.FNumber,T.FName,p.OrderID,肉品系数,人工系数 
)t
INNER JOIN dbo.t_ICItem T1 ON T.FNumber=t1.FNumber
INNER JOIN dbo.t_Item T2 ON T1.FParentID=t2.FItemID
INNER JOIN dbo.t_Item T3 ON T2.FParentID=t3.FItemID
LEFT JOIN T_MeasureUnit    U1 ON U1.FItemID=t1.FUnitID
LEFT JOIN T_MeasureUnit u2 on  u2.FItemID=t1.FSecUnitID
ORDER BY OrderID

--处理 代宰客户

INSERT INTO #t(A,B,C,D,E,F,G,H,I,L,R,FOrderBy)
SELECT '屠宰车间' A,'' B,'代宰客户' C, '7.9.99.99.99999'  D,'代宰业务(头数)' E,'' F,'' G,FDayTZNum H,
肉品系数 I,人工系数 L,FDayTZNum*93 R,OrderID FOrderBy
FROM t_CustDate_EveryDay  t
INNER JOIN t_Item_XS_Base_New b ON b.产品代码='7.9.99.99.99999'
WHERE FDate=@FDate

-----------------------------------------------------------------------------------------------------

--计算分摊标准数量 J=I*R
UPDATE #t SET J=I*R,M=L*R WHERE A='屠宰车间'

DECLARE @J_Sun  float --计算J列总和
DECLARE @M_Sun  float --计算M列总和
SELECT @J_Sun=SUM(J),@M_Sun=SUM(M) FROM #T WHERE A='屠宰车间'


--SELECT K=CAST(CAST((J/@J_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%' FROM #t WHERE A='屠宰车间'
--计算分摊率 K=J9/$J$92

UPDATE #t SET 
K=CAST(CAST((J/@J_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%',
N=CAST(CAST((M/@M_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%'
 WHERE A='屠宰车间'
 
--处理包装类
UPDATE #t SET O=1,p=1*R WHERE B='冻品'
DECLARE @P_Sun  float --计算P列总和
SELECT @P_Sun=SUM(P) FROM #T WHERE A='屠宰车间' AND B='冻品'

UPDATE #t SET Q=CAST(CAST((P/@P_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%' WHERE A='屠宰车间' AND B='冻品'


--计算U列汇总
DECLARE @U_Sun FLOAT

--1青花瓷数据*0.87 -> 2017-07-04 czq修改成0.89   0.9(20180518)
DECLARE @QHC FLOAT,@DZNum FLOAT


--这是原取青花瓷的数据

--SELECT @QHC= ROUND(SUM([Money])*0.9,2)  FROM  con110.[B2-Butchery].dbo.Butchery_ZiYuan_ButcherSettlementAnalys_View 
--where ButcherDate=@FDate 


--这是修改后的取数
CREATE TABLE #tg (
      killtime DATETIME,
      clientname VARCHAR(100),
      quantity FLOAT ,
      grossweight FLOAT ,
      [weight] FLOAT ,
      settlemoney FLOAT 
    )    
INSERT INTO #tg EXEC con12.yrtzdata.dbo.bb_se_getsettledata '11',@FDate,@FDate 

SELECT @QHC= ROUND(SUM(settlemoney)*0.91,2)  FROM #tg 

--调整系数
DECLARE @FTZXS INT 
select @FTZXS=FTZXS  FROM t_CustDate_EveryDay WHERE FDate=@FDate

--2代宰客户  代宰头数*36
SELECT @DZNum= H*@FTZXS FROM #t WHERE A='屠宰车间' AND C='代宰客户'

--3调整数据
DECLARE @FTZMoney FLOAT 
select @FTZMoney=FTZMoney  FROM t_CustDate_EveryDay WHERE FDate=@FDate 

SELECT @U_Sun=@QHC+@DZNum+@FTZMoney

--计算U列=$U$95*K9
UPDATE #t SET U=CAST( (J/@J_Sun) *@U_Sun AS DECIMAL(18,2) )   WHERE A='屠宰车间'

--计算V列 
DECLARE @V_Sun FLOAT  --物质采购金额
DECLARE @X_Sun FLOAT  --屠宰包装金额
DECLARE @AA_Sun FLOAT --屠宰直接人工金额
DECLARE @AB_Sun FLOAT --屠宰制造费用金额

--DECLARE
--@FPurchaseAmount FLOAT,	-- 物质采购金额 1248.3
--@FWorkerAmount	FLOAT,	-- 屠宰直接人工金额 11626.98
--@FProduceAmount	FLOAT,	-- 屠宰制造费用金额 17748.7
--@FCartonAmount FLOAT,	--	133.33 屠宰包装金额

--@FWeaveAmount	FLOAT,	--  259.33 分割包装金额
--@FWorkerAmount2 FLOAT,	--	7608.32 分割直接人工金额
--@FProduceAmount2 FLOAT  --  5208.2  分割制造费用金额

SELECT 
@V_Sun =FPurchaseAmount, --物质采购金额
@X_Sun =FCartonAmount, --屠宰包装金额
@AA_Sun=FWorkerAmount, --屠宰直接人工金额
@AB_Sun=FProduceAmount --屠宰制造费用金额
FROM  t_CustDate_PerMonth WHERE FDate=SUBSTRING(@FDate,1,7)

--计算V列
UPDATE #t SET V=CAST( (J/@J_Sun) *@V_Sun AS DECIMAL(18,2) )   WHERE A='屠宰车间'

--计算W列 
UPDATE #t SET W=0.00   WHERE A='屠宰车间'

--计算X列
UPDATE #t SET X=CAST( (P/@P_Sun)*@X_Sun  AS DECIMAL(18,2) ) WHERE A='屠宰车间'  AND B='冻品'

--计算Y列 
UPDATE #t SET Y=0.00   WHERE A='屠宰车间'

--计算Z列
UPDATE #t SET Z=ISNULL(U,0) +ISNULL(V,0)+ISNULL(W,0)+ISNULL(X,0)+ISNULL(Y,0) WHERE A='屠宰车间'

--计算AA,AB列
UPDATE #t SET AA=CAST( (M/@M_Sun)*@AA_Sun  AS DECIMAL(18,2) ),AB=CAST( (M/@M_Sun)*@AB_Sun  AS DECIMAL(18,2) ) WHERE A='屠宰车间' 

--计算T列
UPDATE #t SET T=ISNULL(Z,0) +ISNULL(AA,0)+ISNULL(AB,0) WHERE A='屠宰车间'

--计算S列
UPDATE #t SET S=CAST( (T/CASE WHEN R=0 THEN 1 ELSE R end) AS DECIMAL(18,2)) WHERE A='屠宰车间'					


--SELECT * FROM #t WHERE A='屠宰车间' 

-------------------------------------------------------------
INSERT INTO #t(A,B,C,D,E,F,G,H,I,L,R,FOrderBy)
SELECT '排酸车间' A, t3.FName B,t2.FName C,t.FNumber D,T.FName E, t1.FModel F,U1.FName G,U2.FName H,
肉品系数 I,人工系数 L,T.FQty R ,OrderID FOrderBy FROM 
(SELECT   T.FNumber,T.FName,SUM(FQty) AS FQty,p.OrderID,肉品系数,人工系数    FROM dbo.ICStockBillEntry E 
INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID AND b.FCancellation=0
INNER JOIN t_Department t4 ON     b.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN dbo.t_ICItem T ON E.FItemID=T.FItemID
INNER JOIN t_Item_XS_Base_New P ON T.FNumber=P.产品代码 
WHERE B.FDate=@FDate AND B.FTranType=2 and ISNULL(t4.FName,'') = '排酸车间' 
GROUP BY T.FNumber,T.FName,p.OrderID,肉品系数,人工系数 
)t
INNER JOIN dbo.t_ICItem T1 ON T.FNumber=t1.FNumber
INNER JOIN dbo.t_Item T2 ON T1.FParentID=t2.FItemID
INNER JOIN dbo.t_Item T3 ON T2.FParentID=t3.FItemID
LEFT JOIN T_MeasureUnit    U1 ON U1.FItemID=t1.FUnitID
LEFT JOIN T_MeasureUnit u2 on  u2.FItemID=t1.FSecUnitID
ORDER BY OrderID

--计算分摊标准数量 J=I*R
UPDATE #t SET J=I*R WHERE A='排酸车间'

SELECT @J_Sun=SUM(J) FROM #T WHERE A='排酸车间'

--计算K列
UPDATE #t SET 
K=CAST(CAST((J/@J_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%' WHERE A='排酸车间'

UPDATE #t SET 
L=NULL,M=0,N='0.00%',O=0,P=0,Q='0.00%' WHERE A='排酸车间'

--创建临时表 #t_PS

Select  t.FNumber,u1.FQty   INTO #t_PS 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON   v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_icitem t ON u1.FItemID=t.FItemID
LEFT OUTER JOIN t_Department t4 ON  v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN t_Stock t8 ON   u1.FSCStockID = t8.FItemID   AND t8.FItemID <>0 
 where 1=1 
 AND 
 (     
  v1.Fdate =  @FDate 
  AND  ISNULL(t8.FName,'') NOT LIKE '%1%'
  AND  ISNULL(t4.FName,'') = '排酸车间'
 )  
 AND (v1.FTranType=24 AND (v1.FCancellation = 0))
 
ALTER TABLE #t_PS add FPrice float --金额
 
UPDATE P SET p.FPrice=t.S FROM #t_PS P
INNER JOIN #t t ON p.FNumber=t.D AND T.A='屠宰车间'

--计算U列
SELECT @U_Sun=SUM(FPrice*fQTY) FROM #t_PS

UPDATE #t SET U= CAST( (@U_Sun*(J/@J_Sun)) AS DECIMAL(18,2) ) WHERE A='排酸车间'

DROP TABLE #t_PS

--计算Z列
UPDATE #t SET Z=U,T=U WHERE A='排酸车间'

--计算S列
UPDATE #t SET S=CAST( (T/CASE WHEN R=0 THEN 1 ELSE R end) AS DECIMAL(18,2)) WHERE A='排酸车间'	

----------------------------------------------------------------------
INSERT INTO #t(A,B,C,D,E,F,G,H,I,L,R,FOrderBy)
SELECT '分割车间' A, t3.FName B,t2.FName C,t.FNumber D,T.FName E, t1.FModel F,U1.FName G,U2.FName H,
肉品系数 I,人工系数 L,T.FQty R ,OrderID FOrderBy FROM 
(SELECT   T.FNumber,T.FName,SUM(FQty) AS FQty,p.OrderID,肉品系数,人工系数    FROM dbo.ICStockBillEntry E 
INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID AND b.FCancellation=0
INNER JOIN t_Department t4 ON     b.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN dbo.t_ICItem T ON E.FItemID=T.FItemID
INNER JOIN t_Item_XS_Base_New P ON T.FNumber=P.产品代码 
WHERE B.FDate=@FDate AND B.FTranType=2 and ISNULL(t4.FName,'') = '分割车间' 
GROUP BY T.FNumber,T.FName,p.OrderID,肉品系数,人工系数 
)t
INNER JOIN dbo.t_ICItem T1 ON T.FNumber=t1.FNumber
INNER JOIN dbo.t_Item T2 ON T1.FParentID=t2.FItemID
INNER JOIN dbo.t_Item T3 ON T2.FParentID=t3.FItemID
LEFT JOIN T_MeasureUnit    U1 ON U1.FItemID=t1.FUnitID
LEFT JOIN T_MeasureUnit u2 on  u2.FItemID=t1.FSecUnitID
ORDER BY OrderID

--计算分摊标准数量 J=I*R
UPDATE #t SET J=I*R,M=L*R WHERE A='分割车间'

SELECT @J_Sun=SUM(J),@M_Sun=SUM(M) FROM #T WHERE A='分割车间'

UPDATE #t SET 
K=CAST(CAST((J/@J_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%',
N=CAST(CAST((M/@M_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%'
 WHERE A='分割车间'
 
 --处理包装类
UPDATE #t SET O=1,p=1*R WHERE B='冻品'

SELECT @P_Sun=SUM(P) FROM #T WHERE A='分割车间' AND B='冻品'

UPDATE #t SET Q=CAST(CAST((P/@P_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%' WHERE A='分割车间' AND B='冻品'

Select  t.FNumber,u1.FQty,u1.FPrice   INTO #t_FG 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON   v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_icitem t ON u1.FItemID=t.FItemID
LEFT OUTER JOIN t_Department t4 ON  v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN t_Stock t8 ON   u1.FSCStockID = t8.FItemID   AND t8.FItemID <>0 
 where 1=1 
 AND 
 (     
  v1.Fdate =  @FDate 
  AND  ISNULL(t8.FName,'') NOT LIKE '%1%'
  AND  ISNULL(t4.FName,'') = '分割车间'
 )  
 AND (v1.FTranType=24 AND (v1.FCancellation = 0))

 
UPDATE P SET p.FPrice=t.S FROM #t_FG P
INNER JOIN #t t ON p.FNumber=t.D AND T.A='排酸车间'
--新修改2016-08-26 czq(价格有部分取屠宰车间)
UPDATE P SET p.FPrice=t.S FROM #t_FG P
INNER JOIN #t t ON p.FNumber=t.D AND T.A='屠宰车间'

--计算U列
SELECT @U_Sun=SUM(FPrice*fQTY) FROM #t_FG

UPDATE #t SET U= CAST( (@U_Sun*(J/@J_Sun)) AS DECIMAL(18,2) ) WHERE A='分割车间'

DROP TABLE #t_FG

--计算Z列

UPDATE #t SET Z= ISNULL(U,0)+ISNULL(X,0) WHERE A='分割车间'

--计算AA,AB列
--SELECT
--@AA_Sun=FWorkerAmount2, --分割直接人工金额
--@AB_Sun=FProduceAmount2 --分割制造费用金额
--FROM  t_CustDate_PerMonth WHERE FDate=SUBSTRING(@FDate,1,7)

SELECT
@AA_Sun=FWorkerAmount2, --分割直接人工金额
@AB_Sun=FProduceAmount2, --分割制造费用金额
@X_Sun =FWeaveAmount     --分割包装金额
FROM  t_CustDate_PerMonth WHERE FDate=SUBSTRING(@FDate,1,7)


--计算X列
UPDATE #t SET X=CAST( (P/@P_Sun)*@X_Sun  AS DECIMAL(18,2) ) WHERE A='分割车间'  AND B='冻品'

UPDATE #t SET Z= ISNULL(U,0)+ISNULL(X,0) WHERE A='分割车间'

--计算AA,AB列
UPDATE #t SET AA=CAST( (M/@M_Sun)*@AA_Sun  AS DECIMAL(18,2) ),AB=CAST( (M/@M_Sun)*@AB_Sun  AS DECIMAL(18,2) ) WHERE A='分割车间' 

--计算T列
UPDATE #t SET T=ISNULL(Z,0) +ISNULL(AA,0)+ISNULL(AB,0) WHERE A='分割车间'

--计算S列
UPDATE #t SET S=CAST( (T/CASE WHEN R=0 THEN 1 ELSE R end) AS DECIMAL(18,2)) WHERE A='分割车间'



--结果
DELETE FROM t_yxryCost  WHERE FFDate=@FDate

INSERT INTO t_yxryCost SELECT *,@FDate from #t

INSERT INTO t_yxryCost
        ( A , B , R ,T ,U , V , W , X ,Y ,Z ,AA , AB ,FFDate,FOrderBy  )
        select '屠宰车间' A,'合计' B, 
        CAST(SUM(ISNULL(R,0)) AS DECIMAL(18,2)) R, 
        CAST(SUM(ISNULL(T,0)) AS DECIMAL(18,2)) T, 
        CAST(SUM(ISNULL(U,0)) AS DECIMAL(18,2)) U, 
        CAST(SUM(ISNULL(V,0)) AS DECIMAL(18,2)) V, 
        CAST(SUM(ISNULL(W,0)) AS DECIMAL(18,2)) W, 
        CAST(SUM(ISNULL(X,0)) AS DECIMAL(18,2)) X, 
        CAST(SUM(ISNULL(Y,0)) AS DECIMAL(18,2)) Y, 
        CAST(SUM(ISNULL(Z,0)) AS DECIMAL(18,2)) Z, 
        CAST(SUM(ISNULL(AA,0)) AS DECIMAL(18,2)) AA, 
        CAST(SUM(ISNULL(AB,0)) AS DECIMAL(18,2)) AB, @FDate FFDate,9997
        FROM #t WHERE A='屠宰车间'

INSERT INTO t_yxryCost
        ( A , B , R ,T ,U , V , W , X ,Y ,Z ,AA , AB ,FFDate,FOrderBy   )
        select '排酸车间' A,'合计' B, 
        CAST(SUM(ISNULL(R,0)) AS DECIMAL(18,2)) R, 
        CAST(SUM(ISNULL(T,0)) AS DECIMAL(18,2)) T, 
        CAST(SUM(ISNULL(U,0)) AS DECIMAL(18,2)) U, 
        CAST(SUM(ISNULL(V,0)) AS DECIMAL(18,2)) V, 
        CAST(SUM(ISNULL(W,0)) AS DECIMAL(18,2)) W, 
        CAST(SUM(ISNULL(X,0)) AS DECIMAL(18,2)) X, 
        CAST(SUM(ISNULL(Y,0)) AS DECIMAL(18,2)) Y, 
        CAST(SUM(ISNULL(Z,0)) AS DECIMAL(18,2)) Z, 
        CAST(SUM(ISNULL(AA,0)) AS DECIMAL(18,2)) AA, 
        CAST(SUM(ISNULL(AB,0)) AS DECIMAL(18,2)) AB, @FDate FFDate,9998
        FROM #t WHERE A='排酸车间'        
   
INSERT INTO t_yxryCost
        ( A , B , R ,T ,U , V , W , X ,Y ,Z ,AA , AB ,FFDate,FOrderBy   )
        select '分割车间' A,'合计' B, 
        CAST(SUM(ISNULL(R,0)) AS DECIMAL(18,2)) R, 
        CAST(SUM(ISNULL(T,0)) AS DECIMAL(18,2)) T, 
        CAST(SUM(ISNULL(U,0)) AS DECIMAL(18,2)) U, 
        CAST(SUM(ISNULL(V,0)) AS DECIMAL(18,2)) V, 
        CAST(SUM(ISNULL(W,0)) AS DECIMAL(18,2)) W, 
        CAST(SUM(ISNULL(X,0)) AS DECIMAL(18,2)) X, 
        CAST(SUM(ISNULL(Y,0)) AS DECIMAL(18,2)) Y, 
        CAST(SUM(ISNULL(Z,0)) AS DECIMAL(18,2)) Z, 
        CAST(SUM(ISNULL(AA,0)) AS DECIMAL(18,2)) AA, 
        CAST(SUM(ISNULL(AB,0)) AS DECIMAL(18,2)) AB, @FDate FFDate,9999
        FROM #t WHERE A='分割车间'    

SELECT * FROM t_yxryCost WHERE FFDate=@FDate ORDER BY FOrderBY





