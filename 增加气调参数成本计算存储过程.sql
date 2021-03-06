USE [AIS_YXRY2]
GO
/*
A:标签页标识 代表各个操作部门，显示不同部门成本数据
B:产品类别C:产品细类D：产品代码E：产品名称F：规格型号
G：基本计量单位H:辅助计量单位I:肉品系数J:肉品分摊标准数量
K:肉品分摊率=CAST(CAST((J/@J_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%'
L:人工系数
M:人工分摊标准数量
N:人工分摊率=CAST(CAST((M/@M_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%'
O：包装分摊：屠宰为1
P: 包装分摊数量
Q: 包装分摊率：CAST(CAST((P/@P_Sun)*100 AS DECIMAL(18,2))+'%'
R:完工数量
S:单位成本（总完工金额/完工数量）
T：完工金额（气调费用+制造费用+人工费用+包装费用+其他费用+屠宰费用+代宰费用+屠宰暂存库+每日调节金额）
U:生猪领用 CAST( (J/@J_Sun) *@U_Sun AS DECIMAL(18,2) )|||@U_Sun=@QHC+@DZNum+@FTZMoney
V:物质采购金额
W:屠宰暂存库
X:包装物（包装费用）=CAST( (P/@P_Sun)*@X_Sun  AS DECIMAL(18,2) )
Y:其他
Z:材料成本小计
AA:直接人工
AB:制造费用
CC:气调系数
DD:气调分摊标准数量
EE:气调分摊率=CAST(CAST((DD/@DD_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%'
FF:气调费用
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[sp_TuZaiFengGeCost_NEW]
(
 @FDate VARCHAR(20)
)
AS 
CREATE TABLE #t
(
A nvarchar(MAX),B nvarchar(MAX),C nvarchar(MAX),D nvarchar(MAX),E nvarchar(MAX),F nvarchar(MAX),
G nvarchar(MAX),H nvarchar(MAX),I FLOAT,J FLOAT,K nvarchar(MAX),L FLOAT,M FLOAT,N nvarchar(MAX),O FLOAT,P FLOAT,Q nvarchar(MAX),
R FLOAT,S FLOAT,T FLOAT,U FLOAT,V FLOAT,W FLOAT,X FLOAT,Y FLOAT,Z FLOAT,AA FLOAT,AB FLOAT,CC FLOAT,DD FLOAT
,EE nvarchar(MAX),FF FLOAT,FOrderBy FLOAT
)
--------------------------------------处理 屠宰车间-------------------------------------------------------------------------------------------

INSERT INTO #t(A,B,C,D,E,F,G,H,I,L,R,FOrderBy,CC)
SELECT '屠宰车间' A, t3.FName B,t2.FName C,t.FNumber D,T.FName E, t1.FModel F,U1.FName G,U2.FName H,
肉品系数 I,人工系数 L,T.FQty R ,OrderID FOrderBy,气调系数 CC FROM 
(SELECT   T.FNumber,T.FName,SUM(FQty) AS FQty,p.OrderID,肉品系数,人工系数 ,P.气调系数   FROM dbo.ICStockBillEntry E 
INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID AND b.FCancellation=0
INNER JOIN t_Department t4 ON     b.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN dbo.t_ICItem T ON E.FItemID=T.FItemID
INNER JOIN t_Item_XS_Base_New P ON T.FNumber=P.产品代码 
WHERE B.FDate=@FDate AND B.FTranType=2 and ISNULL(t4.FName,'') = '屠宰车间' 
GROUP BY T.FNumber,T.FName,p.OrderID,肉品系数,人工系数 ,P.气调系数 
)t
INNER JOIN dbo.t_ICItem T1 ON T.FNumber=t1.FNumber
INNER JOIN dbo.t_Item T2 ON T1.FParentID=t2.FItemID
INNER JOIN dbo.t_Item T3 ON T2.FParentID=t3.FItemID
LEFT JOIN T_MeasureUnit    U1 ON U1.FItemID=t1.FUnitID
LEFT JOIN T_MeasureUnit u2 on  u2.FItemID=t1.FSecUnitID
ORDER BY OrderID

--代宰客户
INSERT INTO #t(A,B,C,D,E,F,G,H,I,L,R,FOrderBy,CC)
SELECT '屠宰车间' A,'' B,'代宰客户' C, '7.9.99.99.99999'  D,'代宰业务(头数)' E,'' F,'' G,FDayTZNum H,
肉品系数 I,人工系数 L,FDayTZNum*93 R,OrderID FOrderBy,1 
FROM t_CustDate_EveryDay  t
INNER JOIN t_Item_XS_Base_New b ON b.产品代码='7.9.99.99.99999'
WHERE FDate=@FDate

--计算分摊标准数量 J=I*R
UPDATE #t SET J=I*R,M=L*R,DD=CC*R WHERE A='屠宰车间'
DECLARE @J_Sun  float --计算J列总和
DECLARE @M_Sun  float --计算M列总和
DECLARE @DD_Sun float --计算DD列总和
SELECT @J_Sun=SUM(J),@M_Sun=SUM(M),@DD_Sun=SUM(DD) FROM #T WHERE A='屠宰车间'


UPDATE #t SET 
K=CAST(CAST((J/@J_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%',  --肉品分摊率
N=CAST(CAST((M/@M_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%',  --人工分摊率
EE=CAST(CAST((DD/@DD_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%'--增加气调分摊率
 WHERE A='屠宰车间'
 
--处理包装费用
UPDATE #t SET O=1,p=1*R WHERE B='冻品'
DECLARE @P_Sun  float --计算P列总和
SELECT @P_Sun=SUM(P) FROM #T WHERE A='屠宰车间' AND B='冻品'
UPDATE #t SET Q=CAST(CAST((P/@P_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%' WHERE A='屠宰车间' AND B='冻品'

--计算U列汇总
DECLARE @U_Sun FLOAT
DECLARE @QHC FLOAT,@DZNum FLOAT

CREATE TABLE #tg (
      killtime DATETIME,
      clientname VARCHAR(100),
      quantity FLOAT ,
      grossweight FLOAT ,
      [weight] FLOAT ,
      settlemoney FLOAT 
    )    
INSERT INTO #tg EXEC con12.yrtzdata.dbo.bb_se_getsettledata '11',@FDate,@FDate 

SELECT @QHC= ROUND(SUM(settlemoney)*0.9,2)  FROM #tg 
DECLARE @FTZXS INT 
select @FTZXS=FTZXS  FROM t_CustDate_EveryDay WHERE FDate=@FDate--调整系数
--2代宰客户  代宰头数*36
SELECT  @DZNum= H*@FTZXS FROM #t WHERE A='屠宰车间' AND C='代宰客户'
--3调整数据
DECLARE @FTZMoney FLOAT 
select @FTZMoney=FTZMoney  FROM t_CustDate_EveryDay WHERE FDate=@FDate 
SELECT @U_Sun=@QHC+@DZNum+@FTZMoney
UPDATE #t SET U=CAST( (J/@J_Sun) *@U_Sun AS DECIMAL(18,2) )   WHERE A='屠宰车间'

DECLARE @V_Sun FLOAT  --物质采购金额
DECLARE @X_Sun FLOAT  --屠宰包装金额
DECLARE @AA_Sun FLOAT --屠宰直接人工金额
DECLARE @AB_Sun FLOAT --屠宰制造费用金额
DECLARE @FF_Sun FLOAT --屠宰气调费用金额

SELECT 
@V_Sun =FPurchaseAmount, 
@X_Sun =FCartonAmount,   
@AA_Sun=FWorkerAmount, 
@AB_Sun=FProduceAmount, 
@FF_Sun=txtMapAccount1  
FROM  t_CustDate_PerMonth WHERE FDate=SUBSTRING(@FDate,1,7)

--计算V列--物资采购费用
UPDATE #t SET V=CAST( (J/@J_Sun) *@V_Sun AS DECIMAL(18,2) )       WHERE A='屠宰车间'
--计算FF列--屠宰气调费用
UPDATE #t SET FF=CAST( (DD/@DD_Sun) *@FF_Sun AS DECIMAL(18,2) )   WHERE A='屠宰车间'
--计算W列--屠宰暂存库
UPDATE #t SET W=0.00   WHERE A='屠宰车间'
--计算X列--包装物（包装费用）
UPDATE #t SET X=CAST( (P/@P_Sun)*@X_Sun  AS DECIMAL(18,2) ) WHERE A='屠宰车间'  AND B='冻品'
--计算Y列 --其他
UPDATE #t SET Y=0.00   WHERE A='屠宰车间'
--计算Z列 --材料成本小计（物资采购金额+云睿屠宰数据+日代宰金额+日调整金额+屠宰暂存库+包装费用+其他费用）
UPDATE #t SET Z=ISNULL(U,0) +ISNULL(V,0)+ISNULL(W,0)+ISNULL(X,0)+ISNULL(Y,0) WHERE A='屠宰车间'
--计算AA,AB列
UPDATE #t SET AA=CAST( (M/@M_Sun)*@AA_Sun  AS DECIMAL(18,2) ),AB=CAST( (M/@M_Sun)*@AB_Sun  AS DECIMAL(18,2) ) WHERE A='屠宰车间' 
--计算T列 增加了气调费用+直接人工费用+制造费用
UPDATE #t SET T=ISNULL(Z,0) +ISNULL(AA,0)+ISNULL(AB,0)+ISNULL(FF,0) WHERE A='屠宰车间'
--计算S列
UPDATE #t SET S=CAST( (T/CASE WHEN R=0 THEN 1 ELSE R end) AS DECIMAL(18,2)) WHERE A='屠宰车间'			

---------------------处理排酸车间----------------------------------------
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
--计算分摊标准数量 J=I*R 肉品系数
UPDATE #t SET J=I*R WHERE A='排酸车间'

SELECT @J_Sun=SUM(J) FROM #T WHERE A='排酸车间'

--计算K列
UPDATE #t SET 
K=CAST(CAST((J/@J_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%' WHERE A='排酸车间'

UPDATE #t SET 
L=NULL,M=0,N='0.00%',O=0,P=0,Q='0.00%',CC=0,DD=0,EE='0.00%' WHERE A='排酸车间'

Select  t.FNumber,u1.FQty , 'n' AS stockid   INTO #t_PS 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON   v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_icitem t ON u1.FItemID=t.FItemID
LEFT OUTER JOIN t_Department t4 ON  v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN t_Stock t8 ON   u1.FSCStockID = t8.FItemID   AND t8.FItemID <>0 
 where 1=1
 AND u1.FSCStockID<>240 
 AND 
 (     
  v1.Fdate =  @FDate 
  AND  ISNULL(t8.FName,'') NOT LIKE '%1%'
  AND  ISNULL(t4.FName,'') = '排酸车间'
 )  
 AND (v1.FTranType=24 AND (v1.FCancellation = 0))
--分外购和内产两种,以下为外购进来的单价计算
INSERT INTO #t_PS 
Select  t.FNumber,u1.FQty , 'w' AS stockid  
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON   v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_icitem t ON u1.FItemID=t.FItemID
LEFT OUTER JOIN t_Department t4 ON  v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN t_Stock t8 ON   u1.FSCStockID = t8.FItemID   AND t8.FItemID <>0 
 where 1=1
 AND u1.FSCStockID=240 
 AND 
 (     
  v1.Fdate =  @FDate 
  AND  ISNULL(t8.FName,'') NOT LIKE '%1%'
  AND  ISNULL(t4.FName,'') = '排酸车间'
 )  
 AND (v1.FTranType=24 AND (v1.FCancellation = 0))
 
ALTER TABLE #t_PS add FPrice float --金额
 
UPDATE P SET p.FPrice=t.S FROM #t_PS P
INNER JOIN #t t ON p.FNumber=t.D AND T.A='屠宰车间' AND p.stockid='n'

--外购单价计算逻辑开始,增加临时表#t_WGprice
DECLARE @BegDate  VARCHAR(100) --开始日期   -- 取本月第一天
set @BegDate=CONVERT(VARCHAR(10),DATEPART(YEAR,GETDATE()))+'-'+CONVERT(VARCHAR(10),DATEPART(month,GETDATE()))
       +'-01'
SELECT 
        t13.FNumber ,
        SUM(u1.fqty) AS sumFqty ,
        SUM(u1.Famount) AS sumFamount  ,
        CASE  SUM(u1.fqty) WHEN 0 THEN 0 ELSE SUM(u1.Famount)/SUM(u1.fqty) END AS rate 
        into   #t_WGprice
        
FROM    ICStockBill v1
        INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                          AND u1.FInterID <> 0
        INNER JOIN t_ICItem t13 ON u1.FItemID = t13.FItemID
                                   AND t13.FItemID <> 0
WHERE   1 = 1
        AND ( v1.Fdate >= @BegDate) AND V1.FDate<=GETDATE()
        AND ( v1.FTranType = 1 )
        AND V1.FCancellation = 0            --未作废单据
        AND V1.FStatus = 1                --己审核单据
GROUP BY t13.FNumber

UPDATE P SET p.FPrice=Wg.rate FROM #t_PS P
INNER JOIN  #t_WGprice Wg ON p.FNumber=Wg.FNumber  AND p.stockid='w'

--外购单价计算逻辑结束

--计算U列
SELECT @U_Sun=SUM(FPrice*fQTY) FROM #t_PS
UPDATE #t SET FF=0   WHERE A='排酸车间'
UPDATE #t SET U= CAST( (@U_Sun*(J/@J_Sun)) AS DECIMAL(18,2) ) WHERE A='排酸车间'

DROP TABLE #t_PS

--计算Z列
UPDATE #t SET Z=U,T=U WHERE A='排酸车间'

--计算S列
UPDATE #t SET S=CAST( (T/CASE WHEN R=0 THEN 1 ELSE R end) AS DECIMAL(18,2)) WHERE A='排酸车间'	

----------------------------------------处理分割车间-------------------------------------------------------
INSERT INTO #t(A,B,C,D,E,F,G,H,I,L,R,FOrderBy,CC)
SELECT '分割车间' A, t3.FName B,t2.FName C,t.FNumber D,T.FName E, t1.FModel F,U1.FName G,U2.FName H,
肉品系数 I,人工系数 L,T.FQty R ,OrderID FOrderBy ,气调系数 CC FROM 
(SELECT   T.FNumber,T.FName,SUM(FQty) AS FQty,p.OrderID,肉品系数,人工系数,气调系数    FROM dbo.ICStockBillEntry E 
INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID AND b.FCancellation=0
INNER JOIN t_Department t4 ON     b.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN dbo.t_ICItem T ON E.FItemID=T.FItemID
INNER JOIN t_Item_XS_Base_New P ON T.FNumber=P.产品代码 
WHERE B.FDate=@FDate AND B.FTranType=2 and ISNULL(t4.FName,'') = '分割车间' 
GROUP BY T.FNumber,T.FName,p.OrderID,肉品系数,人工系数,P.气调系数 
)t
INNER JOIN dbo.t_ICItem T1 ON T.FNumber=t1.FNumber
INNER JOIN dbo.t_Item T2 ON T1.FParentID=t2.FItemID
INNER JOIN dbo.t_Item T3 ON T2.FParentID=t3.FItemID
LEFT JOIN T_MeasureUnit    U1 ON U1.FItemID=t1.FUnitID
LEFT JOIN T_MeasureUnit u2 on  u2.FItemID=t1.FSecUnitID
ORDER BY OrderID

--计算分摊标准数量 J=I*R
UPDATE #t SET J=I*R,M=L*R,DD=CC*R WHERE A='分割车间'
SELECT @J_Sun=SUM(J),@M_Sun=SUM(M),@DD_Sun=SUM(DD)  FROM #T WHERE A='分割车间'

UPDATE #t SET 
K=CAST(CAST((J/@J_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%',
N=CAST(CAST((M/@M_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%',
EE=CAST(CAST((DD/@DD_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%'

 WHERE A='分割车间'
 
 --处理包装类
UPDATE #t SET O=1,p=1*R WHERE B='冻品'
SELECT @P_Sun=SUM(P) FROM #T WHERE A='分割车间' AND B='冻品'
UPDATE #t SET Q=CAST(CAST((P/@P_Sun)*100 AS DECIMAL(18,2)) AS VARCHAR)+'%' WHERE A='分割车间' AND B='冻品'

Select  t.FNumber,u1.FQty,u1.FPrice ,'n' AS stockid INTO #t_FG 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON   v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_icitem t ON u1.FItemID=t.FItemID
LEFT OUTER JOIN t_Department t4 ON  v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN t_Stock t8 ON   u1.FSCStockID = t8.FItemID   AND t8.FItemID <>0 
 where 1=1 
 AND u1.FSCStockID<> 240
 AND 
 (     
  v1.Fdate =  @FDate 
  AND  ISNULL(t8.FName,'') NOT LIKE '%1%'
  AND  ISNULL(t4.FName,'') = '分割车间'
 )  
 AND (v1.FTranType=24 AND (v1.FCancellation = 0))
 
INSERT INTO #t_FG
Select  t.FNumber,u1.FQty,u1.FPrice  ,'w' AS stockid  
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON   v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_icitem t ON u1.FItemID=t.FItemID
LEFT OUTER JOIN t_Department t4 ON  v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN t_Stock t8 ON   u1.FSCStockID = t8.FItemID   AND t8.FItemID <>0 
 where 1=1 
 AND u1.FSCStockID=240
 AND 
 (     
  v1.Fdate =  @FDate 
  AND  ISNULL(t8.FName,'') NOT LIKE '%1%'
  AND  ISNULL(t4.FName,'') = '分割车间'
 )  
 AND (v1.FTranType=24 AND (v1.FCancellation = 0))

--内产的直接更新领料单价 20190524
UPDATE P SET p.FPrice=t.S FROM #t_FG P
INNER JOIN #t t ON p.FNumber=t.D AND T.A='排酸车间' AND  p.stockid='n'
--内产的直接更新领料单价 20190524
UPDATE P SET p.FPrice=t.S FROM #t_FG P
INNER JOIN #t t ON p.FNumber=t.D AND T.A='屠宰车间' AND  p.stockid='n'

--外购单价计算逻辑开始,增加临时表#t_WGprice1
DECLARE @BegDate1  VARCHAR(100) --开始日期   -- 取本月第一天
set @BegDate1=CONVERT(VARCHAR(10),DATEPART(YEAR,GETDATE()))+'-'+CONVERT(VARCHAR(10),DATEPART(month,GETDATE()))
       +'-01'
SELECT 
        t13.FNumber ,
        SUM(u1.fqty) AS sumFqty ,
        SUM(u1.Famount) AS sumFamount  ,
        CASE  SUM(u1.fqty) WHEN 0 THEN 0 ELSE SUM(u1.Famount)/SUM(u1.fqty) END AS rate 
        into   #t_WGprice1
        
FROM    ICStockBill v1
        INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                          AND u1.FInterID <> 0
        INNER JOIN t_ICItem t13 ON u1.FItemID = t13.FItemID
                                   AND t13.FItemID <> 0
WHERE   1 = 1
        AND ( v1.Fdate >= @BegDate1) AND V1.FDate<=GETDATE()
        AND ( v1.FTranType = 1 )
        AND V1.FCancellation = 0          --未作废单据
        AND V1.FStatus = 1                --己审核单据
GROUP BY t13.FNumber

UPDATE P SET p.FPrice=Wg1.rate FROM #t_FG P
INNER JOIN  #t_WGprice1 Wg1 ON p.FNumber=Wg1.FNumber  AND p.stockid='w'

SELECT @U_Sun=SUM(FPrice*fQTY) FROM #t_FG
UPDATE #t SET U= CAST( (@U_Sun*(J/@J_Sun)) AS DECIMAL(18,2) ) WHERE A='分割车间'
DROP TABLE #t_FG
--计算Z列
UPDATE #t SET Z= ISNULL(U,0)+ISNULL(X,0) WHERE A='分割车间'

SELECT
@AA_Sun=FWorkerAmount2, 
@AB_Sun=FProduceAmount2, 
@X_Sun =FWeaveAmount,    
@FF_Sun=txtMapAccount2    
FROM  t_CustDate_PerMonth WHERE FDate=SUBSTRING(@FDate,1,7)

--计算X列
UPDATE #t SET X=CAST( (P/@P_Sun)*@X_Sun  AS DECIMAL(18,2) ) WHERE A='分割车间'  AND B='冻品'
--计算FF列--屠宰气调费用
UPDATE #t SET FF=CAST( (DD/@DD_Sun)*@FF_Sun AS DECIMAL(18,2) )   WHERE A='分割车间'
UPDATE #t SET Z= ISNULL(U,0)+ISNULL(X,0) WHERE A='分割车间'         
--计算AA,AB列
UPDATE #t SET AA=CAST( (M/@M_Sun)*@AA_Sun  AS DECIMAL(18,2) ),AB=CAST( (M/@M_Sun)*@AB_Sun  AS DECIMAL(18,2) ) WHERE A='分割车间' 

--计算T列 增加气调费用
UPDATE #t SET T=ISNULL(Z,0) +ISNULL(AA,0)+ISNULL(AB,0)+ISNULL(FF,0) WHERE A='分割车间'
--计算S列
UPDATE #t SET S=CAST( (T/CASE WHEN R=0 THEN 1 ELSE R end) AS DECIMAL(18,2)) WHERE A='分割车间'


--结果
DELETE FROM t_yxryCost  WHERE FFDate=@FDate
INSERT INTO t_yxryCost
(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S ,T,U,V,W,X,Y,Z,AA,AB,
FOrderBy,CC,DD,EE,FF,FFDate)


SELECT A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S ,T,U,V,W,X,Y,Z,AA,AB,
FOrderBy,CC,DD,EE,FF,@FDate from #t

INSERT INTO t_yxryCost
        ( A , B , R ,T ,U , V , W , X ,Y ,Z ,AA , AB,FF ,FFDate,FOrderBy  )
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
        CAST(SUM(ISNULL(AB,0)) AS DECIMAL(18,2)) AB,
        CAST(SUM(ISNULL(FF,0)) AS DECIMAL(18,2)) FF,
         @FDate FFDate,9997
        FROM #t WHERE A='屠宰车间'

INSERT INTO t_yxryCost
        ( A , B , R ,T ,U , V , W , X ,Y ,Z ,AA , AB,FF ,FFDate,FOrderBy   )
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
        CAST(SUM(ISNULL(AB,0)) AS DECIMAL(18,2)) AB,
          CAST(SUM(ISNULL(FF,0)) AS DECIMAL(18,2)) FF,    
        
         @FDate FFDate,9998
        FROM #t WHERE A='排酸车间'        
   
INSERT INTO t_yxryCost
        ( A , B , R ,T ,U , V , W , X ,Y ,Z ,AA , AB ,FF,FFDate,FOrderBy   )
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
        CAST(SUM(ISNULL(AB,0)) AS DECIMAL(18,2)) AB, 
       CAST(SUM(ISNULL(FF,0)) AS DECIMAL(18,2)) FF,       
        @FDate FFDate,9999
        FROM #t WHERE A='分割车间'    

SELECT * FROM t_yxryCost WHERE FFDate=@FDate ORDER BY FOrderBY





