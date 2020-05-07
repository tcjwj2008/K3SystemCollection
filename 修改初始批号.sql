CREATE TABLE #abc (物料代码 VARCHAR(50),旧批次 VARCHAR(50),新批次 VARCHAR(50), 内码 VARCHAR(50))


INSERT into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000380','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000390','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000400','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000410','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000480','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000440','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000470','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000420','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000500','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000460','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000370','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000360','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000350','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000330','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000290','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000280','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000270','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000340','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000260','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000320','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000450','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000300','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000560','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000310','AA','201908');
insert into #abc(物料代码,旧批次,新批次) values('8.8.02.02.000510','AA','201908');



UPDATE a SET 内码=b.fitemid 
FROM #abc a,dbo.t_ICItem b
WHERE a.物料代码=b.FNumber

SELECT * FROM  #abc a,dbo.t_ICItem b
WHERE a.物料代码=b.FNumber


--2222222222222222222222222
UPDATE a set a.fbatchmanager=1 FROM dbo.t_ICItemMaterial a,t_icitem b WHERE FNumber IN(

SELECT 物料代码 FROM #abc) AND a.FItemID=b.FItemID

SELECT  a.FBatchManager FROM dbo.t_ICItemMaterial a,t_icitem b WHERE FNumber IN(

SELECT 物料代码 FROM #abc) AND a.FItemID=b.FItemID

--

SELECT fbatchmanager FROM t_icitem WHERE FNumber IN(

SELECT 物料代码 FROM #abc)

--333333333333333333333333333



--存货初始数据表上加上批号信息

SELECT b.FBatchNo,a.旧批次,a.新批次 FROM icinvinitial b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次
--SELECT * FROM dbo.ICInvInitial WHERE FItemID IN(
--SELECT 内码 FROM #abc)
UPDATE b SET b.FBatchNo=a.新批次 FROM icinvinitial b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

--库房存货余额表上加上批号信息
SELECT b.FBatchNo,a.旧批次,a.新批次 FROM icinvbal b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次
--SELECT * FROM dbo.icinvbal WHERE FItemID IN(
--SELECT 内码 FROM #abc)
UPDATE b SET b.FBatchNo=a.新批次 FROM icinvbal b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

--存货余额表上加上批号信息
SELECT b.FBatchNo,a.旧批次,a.新批次 FROM icbal b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次
--SELECT * FROM dbo.icbal WHERE FItemID IN(
--SELECT 内码 FROM #abc)
UPDATE b SET b.FBatchNo=a.新批次 FROM icbal b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

--查询出入库
SELECT b.FBatchNo,a.旧批次,a.新批次 FROM dbo.ICStockBillEntry b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

UPDATE b SET b.FBatchNo=a.新批次 FROM ICStockBillEntry b
INNER JOIN #abc a ON b.FItemID=a.内码

SELECT b.FBatchNo,a.旧批次,a.新批次 FROM dbo.icinventory b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次
update b  SET b.FBatchNo=a.新批次 
FROM dbo.icinventory b
INNER JOIN #abc a ON b.FItemID=a.内码



--SELECT b.FBatchNo,a.旧批次,a.新批次 FROM dbo.ICInvInitialAdj b
--INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次
--update b  SET b.FBatchNo=a.新批次 
--FROM dbo.icinventory b
--INNER JOIN #abc a ON b.FItemID=a.内码
--FBatchNo

