
--1��ѯt_item

SELECT * FROM dbo.t_Item WHERE FItemClassID IN (2001,4)  ORDER BY FItemID
GO

--2����t_item��



SELECT  *
INTO   t_item20191109
FROM    t_Item
WHERE   FItemClassID = 2001
        AND FNumber NOT IN ( SELECT FNumber
                             FROM   t_Item
                             WHERE  FItemClassID = 4 )
							 AND FDetail=1;
GO
--SELECT * FROM t_item20191109

UPDATE  t_item20191109
SET     fitemid = fitemid - 1;

GO

--3�޸���ʱ��
SELECT t_item.* 
FROM dbo.t_Item  , t_item20191109

WHERE t_item.fitemid=t_item20191109.fitemid
AND t_item.FItemClassID=4

UPDATE t_item20191109 SET 
t_item20191109.fnumber= t_Item.fnumber,
t_item20191109.FFullNumber=t_Item.FFullNumber,
t_item20191109.FShortNumber=t_Item.FShortNumber,
t_item20191109.FParentID=t_Item.FParentID,
t_item20191109.FLevel=t_Item.FLevel,
t_item20191109.FFullName=t_Item.FFullName
FROM dbo.t_Item  , t_item20191109

WHERE t_item.fitemid=t_item20191109.fitemid
AND t_item.FItemClassID=4



--4�޸���ʱ��

UPDATE  t_item20191109
SET     fitemid = fitemid + 1;

--5�޸�t_item��
SELECT t_item.FNumber,dbo.t_item20191109.FNumber
FROM dbo.t_Item  , t_item20191109
WHERE t_item.fitemid=t_item20191109.fitemid
AND dbo.t_item.FItemClassID=2001



UPDATE t_Item SET 
t_Item.fnumber= t_item20191109.fnumber,
t_Item.FFullNumber=t_item20191109.FFullNumber,
t_Item.FShortNumber=t_item20191109.FShortNumber,
t_Item.FParentID=t_item20191109.FParentID,
t_Item.FLevel=t_item20191109.FLevel,
t_Item.FFullName=t_item20191109.FFullName
FROM dbo.t_Item  , t_item20191109
WHERE t_item.fitemid=t_item20191109.fitemid
AND dbo.t_item.FItemClassID=2001




 ---

 --2����ԭ���ĳɱ���Ϣ
UPDATE  cbCostObj
SET     FNumber = t.FNumber ,
        FParentID = t.FParentID ,
        FShortNumber = t.FShortNumber
FROM    dbo.t_Item t
WHERE   t.FItemClassID = 4
        AND cbCostObj.FStdProductID = t.FItemID;
GO



DROP TABLE dbo.t_item20191109