--本代码在肉业正式账套执行

--DROP TABLE #Rui

--1取云睿系统肉业客户的发货单
SELECT a.deliverycode, a.fhclientcode,	a.fhclientname INTO #Rui FROM CON12.yrtzdata.dbo.TZ_XS_delivery2017 a
WHERE a.deliverydate>='2017-12-12 21:00:00' AND a.deliverydate<='2017-12-13 21:00:00' 
AND isdelete=0  AND a.fhclientcode LIKE 'R%'


--SELECT * FROM CON12.yrtzdata.dbo.TZ_XS_deliverydata2017 WHERE deliverycode IN(SELECT deliverycode FROM #Rui)

SELECT * FROM dbo.ICStockBill b WHERE  FTranType=21 AND FDate='2017-12-13' AND FCancellation=0

--2取云睿系统发货单没有写入K3的单据
SELECT  * FROM #Rui WHERE SUBSTRING(fhclientcode,2,LEN(fhclientcode)-1)
NOT in
(
SELECT g.FNumber FROM dbo.ICStockBill b
INNER JOIN dbo.t_Organization g ON b.FSupplyID=g.FItemID
WHERE  FTranType=21 AND FDate='2017-12-13' AND FCancellation=0
)

--3取云睿系统肉业客户的发货单分录
--DROP TABLE #RuiEntry

SELECT a.deliverycode, a.fhclientcode,	a.fhclientname
,b.productcode,b.productname,b.[weight],b.Price,b.[money] INTO #RuiEntry
 FROM CON12.yrtzdata.dbo.TZ_XS_delivery2017 a
INNER JOIN CON12.yrtzdata.dbo.TZ_XS_deliverydata2017 b ON a.deliverycode=b.deliverycode
WHERE a.deliverydate>='2017-12-12 21:00:00' AND a.deliverydate<='2017-12-13 21:00:00'  
AND isdelete=0 AND a.fhclientcode LIKE 'R%'

SELECT * FROM #Rui

SELECT * FROM #RuiEntry WHERE fhclientcode not LIKE 'R09.0004%'  ORDER BY fhclientcode,productcode

----------------------取肉业价格体系价格-----------------------------------

--(客户+物料)取所有价格
SELECT g.FNumber 客户代码,g.FName 客户名称,t.FNumber 物料代码,t.FName 物料名称,e.FPrice 报价,
MAX(FBegDate) 生效日期,FEndDate 失效日期 FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
WHERE FInterID=2  AND FChecked=1 AND FCheckerID>0 
GROUP BY g.FNumber,g.FName,t.FNumber,t.FName,e.FPrice,FEndDate
ORDER BY g.FNumber,t.FNumber


--(客户+物料)取日期最大的客户、物料
SELECT  g.FNumber 客户代码,g.FName 客户名称,t.FNumber 物料代码,t.FName 物料名称,
MAX(FBegDate) 生效日期,MAX(FEndDate) 失效日期  FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
 WHERE FInterID=2  AND FChecked=1 AND FCheckerID>0 
 GROUP BY g.FNumber,g.FName,t.FNumber,t.FName
 ORDER BY g.FNumber,t.FNumber
 

--(客户+物料) 如果相同客户、相同的品项有不同价格，取最新日期的价格
 
SELECT t.*,b.报价 INTO #tcprice  FROM (
SELECT  g.FNumber 客户代码,g.FName 客户名称,t.FNumber 物料代码,t.FName 物料名称,
MAX(FBegDate) 生效日期,MAX(FEndDate) 失效日期  FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
WHERE FInterID=2  AND FChecked=1 AND FCheckerID>0 
GROUP BY g.FNumber,g.FName,t.FNumber,t.FName
 )T
INNER JOIN 
 (
SELECT g.FNumber 客户代码,g.FName 客户名称,t.FNumber 物料代码,t.FName 物料名称,e.FPrice 报价,
MAX(FBegDate) 生效日期,FEndDate 失效日期 FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
WHERE FInterID=2  AND FChecked=1 AND FCheckerID>0 
GROUP BY g.FNumber,g.FName,t.FNumber,t.FName,e.FPrice,FEndDate
 ) B ON T.客户代码=B.客户代码 AND t.物料代码=b.物料代码 AND t.生效日期=b.生效日期 AND t.失效日期=b.失效日期 
 ORDER BY t.客户代码,t.物料代码


 --客户类别+物料(所有已审核的单价) 
SELECT s.FID 客户类别代码,s.FName 客户类别名称, t.FNumber 物料代码,t.FName 物料名称,e.FPrice 报价,
FBegDate 生效日期,FEndDate 失效日期 FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
WHERE e.FInterID=3  AND FChecked=1 AND FCheckerID>0 --AND  s.FID='01'
ORDER BY s.FID ,t.FNumber

 --客户类别+物料(最大日期)
SELECT  s.FID 客户类别代码,s.FName 客户类别名称, t.FNumber 物料代码,t.FName 物料名称,
MAX(FBegDate) 生效日期,MAX(FEndDate) 失效日期  FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
WHERE e.FInterID=3  AND FChecked=1 AND FCheckerID>0 AND  s.FID='01'
 GROUP BY  s.FID,s.FName,t.FNumber,t.FName
 ORDER BY s.FID,t.FNumber
 
 --(客户类别+物料) 如果相同客户、相同的品项有不同价格，取最新日期的价格
SELECT T.*,b.报价 INTO #tgprice FROM ( 
SELECT  s.FID 客户类别代码,s.FName 客户类别名称, t.FNumber 物料代码,t.FName 物料名称,
MAX(FBegDate) 生效日期,MAX(FEndDate) 失效日期  FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
WHERE e.FInterID=3  AND FChecked=1 AND FCheckerID>0 
GROUP BY  s.FID,s.FName,t.FNumber,t.FName
)T
INNER JOIN 
(
SELECT s.FID 客户类别代码,s.FName 客户类别名称, t.FNumber 物料代码,t.FName 物料名称,e.FPrice 报价,
FBegDate 生效日期,FEndDate 失效日期 FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
WHERE e.FInterID=3  AND FChecked=1 AND FCheckerID>0 
)B  ON T.客户类别代码=B.客户类别代码 AND t.物料代码=b.物料代码 AND t.生效日期=b.生效日期 AND t.失效日期=b.失效日期
 ORDER BY t.客户类别代码,t.物料代码 
 
 ----------------------------------分析价格--------------------------------------------------
 
 SELECT * INTO #tRuiEntry FROM #RuiEntry WHERE fhclientcode not LIKE 'R09.0004%'  ORDER BY fhclientcode,productcode
 
 SELECT * FROM #tcprice --客户+物料
 
 SELECT * FROM #tgprice --客户类别+物料
 
 SELECT * FROM #tRuiEntry
 
 
 --查询K3价格与云睿系统单价是否一致（客户+物料）
 SELECT e.* FROM #tRuiEntry e
 INNER JOIN #tcprice t ON SUBSTRING(e.fhclientcode,2,LEN(e.fhclientcode)-1)=t.客户代码 
 AND e.productcode=t.物料代码 AND e.price<>t.报价
 
 
  --查询K3价格与云睿系统单价是否一致（客户类别+物料）

 --SELECT * FROM #tgprice 
 --SELECT FTypeID FROM dbo.t_Organization 
 
 --SELECT * FROM t_SubMessage WHERE FParentID=501 
 --SELECT * FROM dbo.t_SubMesType WHERE FName='客户分类'
 
 SELECT * FROM #tcprice
 
 SELECT * FROM #tgprice 
 
 
 
 --查询K3价格与云睿系统单价是否一致（客户类别+物料）
 SELECT * FROM #tRuiEntry e
 INNER JOIN 
 (
  SELECT p.*,c.FNumber,c.FName FROM #tgprice p
  INNER JOIN dbo.t_SubMessage g ON g.FID=客户类别代码 and g.fname=客户类别名称
  INNER JOIN dbo.t_Organization c ON c.FTypeID=g.FInterID 
  WHERE c.FDeleted=0 AND c.FNumber NOT LIKE 'X%' 
  AND c.FNumber NOT IN (SELECT 客户代码 FROM #tcprice) --要过滤到客户+物料情况
 ) t ON  SUBSTRING(e.fhclientcode,2,LEN(e.fhclientcode)-1)=t.FNumber 
 AND e.productcode=t.物料代码 AND e.price<>t.报价
 
 
  SELECT p.*,c.FNumber,c.FName FROM #tgprice p
  INNER JOIN dbo.t_SubMessage g ON g.FID=客户类别代码 and g.fname=客户类别名称
  INNER JOIN dbo.t_Organization c ON c.FTypeID=g.FInterID 
  WHERE c.FDeleted=0 AND c.FNumber NOT LIKE 'X%'

 









