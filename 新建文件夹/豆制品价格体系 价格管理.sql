--����������ҵ��ʽ����ִ��

--DROP TABLE #Rui

--1ȡ���ϵͳ��ҵ�ͻ��ķ�����
SELECT a.deliverycode, a.fhclientcode,	a.fhclientname INTO #Rui FROM CON12.yrtzdata.dbo.TZ_XS_delivery2017 a
WHERE a.deliverydate>='2017-12-12 21:00:00' AND a.deliverydate<='2017-12-13 21:00:00' 
AND isdelete=0  AND a.fhclientcode LIKE 'R%'


--SELECT * FROM CON12.yrtzdata.dbo.TZ_XS_deliverydata2017 WHERE deliverycode IN(SELECT deliverycode FROM #Rui)

SELECT * FROM dbo.ICStockBill b WHERE  FTranType=21 AND FDate='2017-12-13' AND FCancellation=0

--2ȡ���ϵͳ������û��д��K3�ĵ���
SELECT  * FROM #Rui WHERE SUBSTRING(fhclientcode,2,LEN(fhclientcode)-1)
NOT in
(
SELECT g.FNumber FROM dbo.ICStockBill b
INNER JOIN dbo.t_Organization g ON b.FSupplyID=g.FItemID
WHERE  FTranType=21 AND FDate='2017-12-13' AND FCancellation=0
)

--3ȡ���ϵͳ��ҵ�ͻ��ķ�������¼
--DROP TABLE #RuiEntry

SELECT a.deliverycode, a.fhclientcode,	a.fhclientname
,b.productcode,b.productname,b.[weight],b.Price,b.[money] INTO #RuiEntry
 FROM CON12.yrtzdata.dbo.TZ_XS_delivery2017 a
INNER JOIN CON12.yrtzdata.dbo.TZ_XS_deliverydata2017 b ON a.deliverycode=b.deliverycode
WHERE a.deliverydate>='2017-12-12 21:00:00' AND a.deliverydate<='2017-12-13 21:00:00'  
AND isdelete=0 AND a.fhclientcode LIKE 'R%'

SELECT * FROM #Rui

SELECT * FROM #RuiEntry WHERE fhclientcode not LIKE 'R09.0004%'  ORDER BY fhclientcode,productcode

----------------------ȡ��ҵ�۸���ϵ�۸�-----------------------------------

--(�ͻ�+����)ȡ���м۸�
SELECT g.FNumber �ͻ�����,g.FName �ͻ�����,t.FNumber ���ϴ���,t.FName ��������,e.FPrice ����,
MAX(FBegDate) ��Ч����,FEndDate ʧЧ���� FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
WHERE FInterID=2  AND FChecked=1 AND FCheckerID>0 
GROUP BY g.FNumber,g.FName,t.FNumber,t.FName,e.FPrice,FEndDate
ORDER BY g.FNumber,t.FNumber


--(�ͻ�+����)ȡ�������Ŀͻ�������
SELECT  g.FNumber �ͻ�����,g.FName �ͻ�����,t.FNumber ���ϴ���,t.FName ��������,
MAX(FBegDate) ��Ч����,MAX(FEndDate) ʧЧ����  FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
 WHERE FInterID=2  AND FChecked=1 AND FCheckerID>0 
 GROUP BY g.FNumber,g.FName,t.FNumber,t.FName
 ORDER BY g.FNumber,t.FNumber
 

--(�ͻ�+����) �����ͬ�ͻ�����ͬ��Ʒ���в�ͬ�۸�ȡ�������ڵļ۸�
 
SELECT t.*,b.���� INTO #tcprice  FROM (
SELECT  g.FNumber �ͻ�����,g.FName �ͻ�����,t.FNumber ���ϴ���,t.FName ��������,
MAX(FBegDate) ��Ч����,MAX(FEndDate) ʧЧ����  FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
WHERE FInterID=2  AND FChecked=1 AND FCheckerID>0 
GROUP BY g.FNumber,g.FName,t.FNumber,t.FName
 )T
INNER JOIN 
 (
SELECT g.FNumber �ͻ�����,g.FName �ͻ�����,t.FNumber ���ϴ���,t.FName ��������,e.FPrice ����,
MAX(FBegDate) ��Ч����,FEndDate ʧЧ���� FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
WHERE FInterID=2  AND FChecked=1 AND FCheckerID>0 
GROUP BY g.FNumber,g.FName,t.FNumber,t.FName,e.FPrice,FEndDate
 ) B ON T.�ͻ�����=B.�ͻ����� AND t.���ϴ���=b.���ϴ��� AND t.��Ч����=b.��Ч���� AND t.ʧЧ����=b.ʧЧ���� 
 ORDER BY t.�ͻ�����,t.���ϴ���


 --�ͻ����+����(��������˵ĵ���) 
SELECT s.FID �ͻ�������,s.FName �ͻ��������, t.FNumber ���ϴ���,t.FName ��������,e.FPrice ����,
FBegDate ��Ч����,FEndDate ʧЧ���� FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
WHERE e.FInterID=3  AND FChecked=1 AND FCheckerID>0 --AND  s.FID='01'
ORDER BY s.FID ,t.FNumber

 --�ͻ����+����(�������)
SELECT  s.FID �ͻ�������,s.FName �ͻ��������, t.FNumber ���ϴ���,t.FName ��������,
MAX(FBegDate) ��Ч����,MAX(FEndDate) ʧЧ����  FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
WHERE e.FInterID=3  AND FChecked=1 AND FCheckerID>0 AND  s.FID='01'
 GROUP BY  s.FID,s.FName,t.FNumber,t.FName
 ORDER BY s.FID,t.FNumber
 
 --(�ͻ����+����) �����ͬ�ͻ�����ͬ��Ʒ���в�ͬ�۸�ȡ�������ڵļ۸�
SELECT T.*,b.���� INTO #tgprice FROM ( 
SELECT  s.FID �ͻ�������,s.FName �ͻ��������, t.FNumber ���ϴ���,t.FName ��������,
MAX(FBegDate) ��Ч����,MAX(FEndDate) ʧЧ����  FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
WHERE e.FInterID=3  AND FChecked=1 AND FCheckerID>0 
GROUP BY  s.FID,s.FName,t.FNumber,t.FName
)T
INNER JOIN 
(
SELECT s.FID �ͻ�������,s.FName �ͻ��������, t.FNumber ���ϴ���,t.FName ��������,e.FPrice ����,
FBegDate ��Ч����,FEndDate ʧЧ���� FROM ICPrcPlyEntry e
INNER JOIN dbo.t_ICItem t ON e.FItemID=t.FItemID
INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
WHERE e.FInterID=3  AND FChecked=1 AND FCheckerID>0 
)B  ON T.�ͻ�������=B.�ͻ������� AND t.���ϴ���=b.���ϴ��� AND t.��Ч����=b.��Ч���� AND t.ʧЧ����=b.ʧЧ����
 ORDER BY t.�ͻ�������,t.���ϴ��� 
 
 ----------------------------------�����۸�--------------------------------------------------
 
 SELECT * INTO #tRuiEntry FROM #RuiEntry WHERE fhclientcode not LIKE 'R09.0004%'  ORDER BY fhclientcode,productcode
 
 SELECT * FROM #tcprice --�ͻ�+����
 
 SELECT * FROM #tgprice --�ͻ����+����
 
 SELECT * FROM #tRuiEntry
 
 
 --��ѯK3�۸������ϵͳ�����Ƿ�һ�£��ͻ�+���ϣ�
 SELECT e.* FROM #tRuiEntry e
 INNER JOIN #tcprice t ON SUBSTRING(e.fhclientcode,2,LEN(e.fhclientcode)-1)=t.�ͻ����� 
 AND e.productcode=t.���ϴ��� AND e.price<>t.����
 
 
  --��ѯK3�۸������ϵͳ�����Ƿ�һ�£��ͻ����+���ϣ�

 --SELECT * FROM #tgprice 
 --SELECT FTypeID FROM dbo.t_Organization 
 
 --SELECT * FROM t_SubMessage WHERE FParentID=501 
 --SELECT * FROM dbo.t_SubMesType WHERE FName='�ͻ�����'
 
 SELECT * FROM #tcprice
 
 SELECT * FROM #tgprice 
 
 
 
 --��ѯK3�۸������ϵͳ�����Ƿ�һ�£��ͻ����+���ϣ�
 SELECT * FROM #tRuiEntry e
 INNER JOIN 
 (
  SELECT p.*,c.FNumber,c.FName FROM #tgprice p
  INNER JOIN dbo.t_SubMessage g ON g.FID=�ͻ������� and g.fname=�ͻ��������
  INNER JOIN dbo.t_Organization c ON c.FTypeID=g.FInterID 
  WHERE c.FDeleted=0 AND c.FNumber NOT LIKE 'X%' 
  AND c.FNumber NOT IN (SELECT �ͻ����� FROM #tcprice) --Ҫ���˵��ͻ�+�������
 ) t ON  SUBSTRING(e.fhclientcode,2,LEN(e.fhclientcode)-1)=t.FNumber 
 AND e.productcode=t.���ϴ��� AND e.price<>t.����
 
 
  SELECT p.*,c.FNumber,c.FName FROM #tgprice p
  INNER JOIN dbo.t_SubMessage g ON g.FID=�ͻ������� and g.fname=�ͻ��������
  INNER JOIN dbo.t_Organization c ON c.FTypeID=g.FInterID 
  WHERE c.FDeleted=0 AND c.FNumber NOT LIKE 'X%'

 









