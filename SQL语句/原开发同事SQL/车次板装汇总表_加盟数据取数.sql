USE [Test_dzp]
GO
/****** Object:  StoredProcedure [dbo].[sp_dzp_chechibanzhuang_tjmxjm_hjc]    Script Date: 08/22/2017 15:25:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<hjc>
-- Create date: <2017/8/22>
-- Description:	<车次板装汇总表_加盟>
-- =============================================
ALTER PROCEDURE [dbo].[sp_dzp_chechibanzhuang_tjmxjm_hjc] (
	@Fdate1 varchar(20)
)
AS

DECLARE @Fdate varchar(20) 
SELECT @Fdate=@Fdate1


SELECT 日期,车次,客户代码,客户名称 INTO #t FROM (
SELECT CONVERT(VARCHAR(12),t1.fdate,23) AS 日期,t3.f_102 as 车次,t3.fnumber '客户代码',t3.fname '客户名称', SUM(isnull(t2.FauxQty,0)) as 总板数量
from SEOrder as t1 
inner join SEOrderEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FCustID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
--AND ( T4.FNumber='8.01.001' 
--OR T4.FNumber='8.01.015' OR T4.FNumber='8.01.016' OR T4.FNumber='8.01.004' 
--OR T4.FNumber='8.01.007' OR T4.FNumber='8.06.007' )
AND ((t3.FNumber >='01.01.0001' AND t3.FNumber <'02.01.0000') OR  t3.FNumber >='04.01.0001'    )

group BY t1.fdate, t3.f_102 ,t3.fnumber,t3.fname
)T ORDER BY CAST(车次 AS int),客户代码

ALTER TABLE #t ADD 水豆腐 FLOAT    --1097
ALTER TABLE #t ADD 卤水老豆腐 FLOAT   --1101
ALTER TABLE #t ADD 本地豆干 FLOAT     --1105
ALTER TABLE #t ADD 发菜豆腐 FLOAT    --1548
ALTER TABLE #t ADD 家常豆腐 FLOAT    --1573
ALTER TABLE #t ADD 仙草冻 FLOAT     --1756

ALTER TABLE #t ADD  总板数量 FLOAT

-------------------------------------------------------------
--8.01.010 水豆腐
UPDATE t SET 水豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,t3.FNumber '客户代码',t3.fname '客户名称',SUM(isnull(t2.FauxQty,0)) as FauxQty
from SEOrder as t1 
inner join SEOrderEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FCustID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FNumber='8.01.010' )
group BY  t3.f_102,t3.fnumber,t3.fname
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)  AND p.客户代码=t.客户代码

-------------------------------------------------------------
--8.01.020 卤水老豆腐
UPDATE t SET 卤水老豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,t3.FNumber '客户代码',t3.fname '客户名称',SUM(isnull(t2.FauxQty,0)) as FauxQty
from SEOrder as t1 
inner join SEOrderEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FCustID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FNumber='8.01.020' )
group BY  t3.f_102,t3.fnumber,t3.fname
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)  AND p.客户代码=t.客户代码

-------------------------------------------------------------
--8.02.030	本地豆干
UPDATE t SET 本地豆干=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,t3.FNumber '客户代码',t3.fname '客户名称',SUM(isnull(t2.FauxQty,0)) as FauxQty
from SEOrder as t1 
inner join SEOrderEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FCustID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FNumber='8.02.030' )
group BY  t3.f_102,t3.fnumber,t3.fname
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)  AND p.客户代码=t.客户代码

-------------------------------------------------------------
--8.01.040	发菜豆腐
UPDATE t SET 发菜豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,t3.FNumber '客户代码',t3.fname '客户名称',SUM(isnull(t2.FauxQty,0)) as FauxQty
from SEOrder as t1 
inner join SEOrderEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FCustID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FNumber='8.01.040' )
group BY  t3.f_102,t3.fnumber,t3.fname
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)  AND p.客户代码=t.客户代码

-------------------------------------------------------------
--8.02.040	家常豆腐
UPDATE t SET 家常豆腐=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,t3.FNumber '客户代码',t3.fname '客户名称',SUM(isnull(t2.FauxQty,0)) as FauxQty
from SEOrder as t1 
inner join SEOrderEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FCustID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FNumber='8.02.040' )
group BY  t3.f_102,t3.fnumber,t3.fname
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)  AND p.客户代码=t.客户代码

-------------------------------------------------------------
--8.11.051	仙草冻
UPDATE t SET 仙草冻=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as 车次,t3.FNumber '客户代码',t3.fname '客户名称',SUM(isnull(t2.FauxQty,0)) as FauxQty
from SEOrder as t1 
inner join SEOrderEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FCustID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FNumber='8.11.051' )
group BY  t3.f_102,t3.fnumber,t3.fname
) p ON  ISNULL(p.车次,0) = ISNULL(t.车次,0)  AND p.客户代码=t.客户代码

UPDATE #t SET 总板数量=ISNULL(水豆腐,0)+ISNULL(卤水老豆腐,0)+ISNULL(本地豆干,0)+ISNULL(发菜豆腐,0)+ISNULL(家常豆腐,0)+ISNULL(仙草冻,0)

			


SELECT * FROM #t
UNION ALL
SELECT '合计' 日期,NULL 车次,NULL 客户代码,NULL 客户名称,NULL 水豆腐,NULL 卤水老豆腐,NULL 本地豆干,NULL 发菜豆腐,NULL 家常豆腐,NULL 仙草冻 ,SUM(总板数量) FROM #t
