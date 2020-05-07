USE [AIS_YXDZP2018]
GO
/****** Object:  StoredProcedure [dbo].[sp_dzp_chechibanzhuang_tj_czq]    Script Date: 2019-11-22 8:53:08 
验证 exec sp_dzp_chechibanzhuang_tj_czq '2019-11-21'
1097	8.01.010	水豆腐   8.01.010
1101	8.01.020	卤水老豆腐  8.01.020
1548	8.01.030	发菜豆腐  8.01.040
1573	8.01.040	家常豆腐  8.02.040
1105	8.01.050	本地豆干  8.02.030
10442	8.01.060	韧豆腐    8.01.076
10264	8.01.900	盐卤老豆腐 8.01.075
1756	8.09.032	仙草冻    8.11.051
******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--车次板装统计
ALTER PROC [dbo].[sp_dzp_chechibanzhuang_tj_czq]
(
  @Fdate1 varchar(20)
)

AS

DECLARE @Fdate varchar(20) 
SELECT @Fdate=@Fdate1


SELECT 日期,车次 INTO #t FROM (
SELECT CONVERT(VARCHAR(12),t1.fdate,23) AS 日期,t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as 总板数量
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( t4.FItemID IN ('1097',
'1101',
'1548',
'1573',
'1105',
'10442',
'10264',
'1756') )
group BY t1.fdate, t3.f_102 
)T ORDER BY CAST(车次 AS int)



ALTER TABLE #t ADD 水豆腐 FLOAT    --1097
ALTER TABLE #t ADD 卤水老豆腐 FLOAT   --1101
ALTER TABLE #t ADD 本地豆干 FLOAT     --1105
ALTER TABLE #t ADD 发菜豆腐 FLOAT    --1548
ALTER TABLE #t ADD 家常豆腐 FLOAT    --1573
ALTER TABLE #t ADD 仙草冻 FLOAT     --1756

ALTER TABLE #t ADD 盐卤老豆腐 FLOAT  --10264 
ALTER TABLE #t ADD 韧豆腐 FLOAT      --10442

ALTER TABLE #t ADD  总板数量 FLOAT

-------------------------------------------------------------

UPDATE t SET 水豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.fitemid=1097 )
group BY  t3.f_102
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)

-------------------------------------------------------------
--8.01.020 卤水老豆腐
UPDATE t SET 卤水老豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.fitemid=1101 )
group BY  t3.f_102
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)

-------------------------------------------------------------
--8.02.030	本地豆干
UPDATE t SET 本地豆干=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=1105 )
group BY  t3.f_102
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)

-------------------------------------------------------------
--8.01.040	发菜豆腐
UPDATE t SET 发菜豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.fitemid=1548 )
group BY  t3.f_102
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)

-------------------------------------------------------------
--8.02.040	家常豆腐
UPDATE t SET 家常豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=1573)
group BY  t3.f_102
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)

-------------------------------------------------------------
--8.11.051	仙草冻
UPDATE t SET 仙草冻=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=1756 )
group BY  t3.f_102
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)

-------------------------------------------------------------
--10264	8.01.075	盐卤老豆腐
UPDATE t SET 盐卤老豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=10264 )
group BY  t3.f_102
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)

-------------------------------------------------------------
--10442	8.01.076	韧豆腐
UPDATE t SET 韧豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=10442 )
group BY  t3.f_102
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)



UPDATE #t SET 总板数量=ISNULL(水豆腐,0)+ISNULL(卤水老豆腐,0)+ISNULL(本地豆干,0)
+ISNULL(发菜豆腐,0)+ISNULL(家常豆腐,0)+ISNULL(仙草冻,0)
++ISNULL(盐卤老豆腐,0)+ISNULL(韧豆腐,0)

			


SELECT * FROM #t
UNION ALL
SELECT '合计' 日期,NULL 车次,NULL 水豆腐,NULL 卤水老豆腐,NULL 
本地豆干,NULL 发菜豆腐,NULL 家常豆腐,NULL 仙草冻 ,NULL 盐卤老豆腐,NULL 韧豆腐,
SUM(总板数量) FROM #t


--ALTER TABLE #t ADD 水豆腐 FLOAT    --1097
--ALTER TABLE #t ADD 卤水老豆腐 FLOAT   --1101
--ALTER TABLE #t ADD 本地豆干 FLOAT     --1105
--ALTER TABLE #t ADD 发菜豆腐 FLOAT    --1548
--ALTER TABLE #t ADD 家常豆腐 FLOAT    --1573
--ALTER TABLE #t ADD 仙草冻 FLOAT     --1756

--ALTER TABLE #t ADD  总板数量 FLOAT





