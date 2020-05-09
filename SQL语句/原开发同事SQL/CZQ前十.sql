--销量前十名客户统计

ALTER PROC sp_CustSaleTop10_czq
(
@FBeginDate varchar(20), --开始时间
@FEndDate varchar(20),   --结束时间
@FDepart varchar(20)     --部门代码
)


AS

--临时表，取所有客户类别


declare @FBeginDate varchar(20) = '2017-07-01'; --开始时间
declare @FEndDate varchar(20) = '2017-07-31';   --结束时间
declare @FDepart varchar(20) = '10.16';			--部门代码

SELECT * INTO #c FROM(
SELECT FNumber, REPLACE(FName,'[分组]','') FName FROM AIS_YXRY2.dbo.t_Item WHERE FItemClassID=1 AND FDetail=0 AND SUBSTRING(FNumber,1,1)<>'X'
UNION
SELECT FNumber, REPLACE(FName,'[分组]','') FName FROM AIS_YXSP2.dbo.t_Item WHERE FItemClassID=1 AND FDetail=0 AND SUBSTRING(FNumber,1,1)<>'X'
)c

--部门代码： 10.12	白条批发部  10.13	加盟开发部  10.14	冻品销售部  10.15	厦门办事处  10.16	福州办事处 10.17	驻外办事处

--1取肉业
SELECT g.FNumber,g.FName,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
SUM(FAuxQty) SumFAuxQty  ,SUM(FConsignAmount) SumFConsignAmount, '肉业'标记 INTO #t FROM AIS_YXRY2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXRY2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXRY2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXRY2.dbo.t_Department d ON b.FDeptID=d.FItemID
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
GROUP BY  g.FNumber,g.FName

--2取食品
INSERT INTO #t
SELECT g.FNumber,g.FName,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
SUM(FAuxQty) SumFAuxQty ,SUM(FConsignAmount) SumFConsignAmount,'食品'标记 FROM AIS_YXSP2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXSP2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXSP2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXSP2.dbo.t_Department d ON b.FDeptID=d.FItemID
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
GROUP BY  g.FNumber,g.FName

--SELECT * FROM #t


--取前10名数据
SELECT TOP 10 ParentNum, SUM(SumFAuxQty)SumFAuxQty,SUM(SumFConsignAmount) SumFConsignAmount INTO #tResult FROM #t t
GROUP BY ParentNum ORDER BY SumFAuxQty DESC

--计算折扣 临时表 #t2
ALTER TABLE #tResult ADD 折扣 FLOAT

--折扣(财务会计-应收账款-其他应收单 金额)
SELECT CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
SUM(SumFamount) SumFamount INTO #t2 FROM (
SELECT g.fnumber,SUM(v.famount) SumFamount FROM AIS_YXRY2.dbo.t_RP_ARPBill b
INNER JOIN AIS_YXRY2.dbo.t_RP_ARPBillEntry v ON v.FBillID = b.FBillID
INNER JOIN AIS_YXRY2.dbo.t_Organization g ON b.FCustomer=g.FItemID
WHERE b.frp=1 AND b.FDate>=@FBeginDate AND b.FDate<=@FEndDate AND b.FChecker >0
AND b.FBase IN( SELECT FItemID FROM AIS_YXRY2.dbo.t_Item WHERE FItemClassID=3002 AND fname='折扣'  )
GROUP BY g.fnumber

UNION ALL

SELECT g.fnumber,SUM(v.famount) SumFamount FROM AIS_YXSP2.dbo.t_RP_ARPBill b
INNER JOIN AIS_YXSP2.dbo.t_RP_ARPBillEntry v ON v.FBillID = b.FBillID
INNER JOIN AIS_YXSP2.dbo.t_Organization g ON b.FCustomer=g.FItemID
WHERE b.frp=1 AND b.FDate>=@FBeginDate AND b.FDate<=@FEndDate AND b.FChecker >0
AND b.Fdisctype IN( SELECT FItemID FROM AIS_YXSP2.dbo.t_Item WHERE FItemClassID=3003 AND fname='折扣'  )
GROUP BY  g.fnumber

)g
GROUP BY CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END


UPDATE t SET t.折扣=abs(c.SumFamount/1.11) FROM #tResult t
INNER JOIN #t2 c ON t.ParentNum=c.ParentNum

--计算成本 临时表 #t3
ALTER TABLE #tResult ADD 成本 FLOAT

IF(@FDepart='10.12' OR @FDepart='10.13')
BEGIN --部门为 '10.12' '10.13'
SELECT SUM(FAuxQty *ISNULL(Fprice,0)) 成本,ParentNum INTO #t3 FROM (
--1取肉业
SELECT b.fdate,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FAuxQty ,p.Fprice, c.FNumber   FROM AIS_YXRY2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXRY2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXRY2.dbo.t_ICItem c ON v.FItemID=c.FItemID
INNER JOIN AIS_YXRY2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXRY2.dbo.t_Department d ON b.FDeptID=d.FItemID
LEFT JOIN YXERP.dbo.yx_rs_ysprice p ON b.fdate=p.fdate AND p.Fnumber = c.FNumber
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)

--2取食品
UNION ALL

SELECT b.fdate,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FAuxQty ,p.Fprice, c.FNumber   FROM AIS_YXSP2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXSP2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXSP2.dbo.t_ICItem c ON v.FItemID=c.FItemID
INNER JOIN AIS_YXSP2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXSP2.dbo.t_Department d ON b.FDeptID=d.FItemID
LEFT JOIN YXERP.dbo.yx_rs_ysprice p ON b.fdate=p.fdate AND p.Fnumber = c.FNumber
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)
)G GROUP BY ParentNum

UPDATE t SET t.成本=c.成本 FROM #tResult t
INNER JOIN #t3 c ON t.ParentNum=c.ParentNum
END  --部门为 '10.12' '10.13'
ELSE
BEGIN --其他部门

SELECT SUM(FAuxQty *ISNULL(FAuxPrice,0)) 成本,ParentNum INTO #t33 FROM (
--1取肉业
SELECT b.fdate,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FAuxQty , FAuxPrice, c.FNumber   FROM AIS_YXRY2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXRY2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXRY2.dbo.t_ICItem c ON v.FItemID=c.FItemID
INNER JOIN AIS_YXRY2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXRY2.dbo.t_Department d ON b.FDeptID=d.FItemID

WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)

--2取食品
UNION ALL

SELECT b.fdate,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FAuxQty ,FAuxPrice, c.FNumber   FROM AIS_YXSP2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXSP2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXSP2.dbo.t_ICItem c ON v.FItemID=c.FItemID
INNER JOIN AIS_YXSP2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXSP2.dbo.t_Department d ON b.FDeptID=d.FItemID

WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)
)G GROUP BY ParentNum

UPDATE t SET t.成本=c.成本 FROM #tResult t
INNER JOIN #t33 c ON t.ParentNum=c.ParentNum


END   --其他部门

--计算损耗成本 临时表 #t4
ALTER TABLE #tResult ADD 损耗成本 FLOAT

--食品账套与肉业账套-供应链-仓存管理-领料发货-其他出库 FTranType=29

SELECT SUM(FConsignAmount) 损耗成本,ParentNum INTO #t4 FROM (
--1取肉业
SELECT
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FConsignAmount   FROM AIS_YXRY2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXRY2.dbo.ICStockBill b		ON v.FInterID=b.FInterID
INNER JOIN AIS_YXRY2.dbo.t_ICItem c			ON v.FItemID=c.FItemID
INNER JOIN AIS_YXRY2.dbo.t_Organization g	ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXRY2.dbo.t_Department d ON b.FDeptID=d.FItemID
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=29
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)

--2取食品
UNION ALL

SELECT
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FConsignAmount   FROM AIS_YXSP2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXSP2.dbo.ICStockBill b		ON v.FInterID=b.FInterID
INNER JOIN AIS_YXSP2.dbo.t_ICItem c			ON v.FItemID=c.FItemID
INNER JOIN AIS_YXSP2.dbo.t_Organization g	ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXSP2.dbo.t_Department d		ON b.FDeptID=d.FItemID
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=29
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)
)G GROUP BY ParentNum

UPDATE t SET t.损耗成本=c.损耗成本 FROM #tResult t
INNER JOIN #t4 c ON t.ParentNum=c.ParentNum


--最后修改名称
ALTER TABLE #tResult ADD FName VARCHAR(50)

UPDATE t SET t.FName=c.FName FROM #tResult t
INNER JOIN #c c ON t.ParentNum=c.FNumber

UPDATE t SET t.FName=c.FName FROM #tResult t
INNER JOIN #t c ON t.ParentNum=c.FNumber
WHERE t.FName IS NULL


--查询结果

ALTER TABLE #tResult ADD 排名 INT IDENTITY(1,1)

ALTER TABLE #tResult ADD 毛利 FLOAT

ALTER TABLE #tResult ADD 毛利率 FLOAT
ALTER TABLE #tResult ADD 吨均毛利 FLOAT

UPDATE #tResult SET 毛利=(SumFConsignAmount/1.11)-ISNULL(折扣,0)-ISNULL(成本,0)-ISNULL(损耗成本,0)

UPDATE #tResult SET 毛利率=((SumFConsignAmount/1.11)-ISNULL(折扣,0)-ISNULL(成本,0)-ISNULL(损耗成本,0))/((SumFConsignAmount/1.11)-ISNULL(折扣,0))

UPDATE #tResult set 吨均毛利=毛利/SumFAuxQty


SELECT 排名, FName 客户, ROUND(SumFAuxQty/1000,2) [销量(吨)],
ROUND(SumFConsignAmount/10000,2) [金额(万)],
ROUND(SumFConsignAmount/(1.11* 10000),2) [收入(万)],
ROUND(折扣/(10000),2) [折扣(万)],
ROUND(成本/(10000),2) [成本(万)],
ROUND(损耗成本/(10000),2) [损耗成本(万)],
ROUND(毛利/(10000),2) [毛利(万)],
CAST(ROUND(毛利率*100,2) AS varchar)+'%' 毛利率,
ROUND(吨均毛利*1000,2) 吨均毛利



FROM #tResult