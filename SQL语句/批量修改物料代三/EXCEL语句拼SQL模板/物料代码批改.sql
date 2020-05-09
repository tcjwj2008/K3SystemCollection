--����һ��ʱ��
--DECLARE tab_uorg TABLE 
--(FItemID INT ,
--OldNumber VARCHAR(255),
--FNumber VARCHAR(255),
--FFullNumber VARCHAR(255),
--FShortNumber VARCHAR(255),
--FParentNumber VARCHAR(255),
--FParentID INT , 
--FLevel INT ,
--FFullName VARCHAR(255)
--)

--SELECT * FROM  T_Item WHERE FItemID IN (2840)
--SELECT * FROM  cbCostObj WHERE FItemID IN (2840)
--SELECT * FROM T_ICItem WHERE FItemID IN (2840)
--SELECT * FROM T_ICItemCore WHERE FItemID IN (2840)
--SELECT * FROM T_ICItemBase WHERE FItemID IN (2840)

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tab_uorg]') AND type IN (N'U'))
DROP TABLE tab_uorg

CREATE TABLE tab_uorg(
FItemID INT ,
OldNumber VARCHAR(255),
FNumber VARCHAR(255),
FFullNumber VARCHAR(255),
FShortNumber VARCHAR(255),
FParentNumber VARCHAR(255),
FParentID INT , 
FLevel INT ,
FFullName VARCHAR(255)
)

INSERT INTO tab_uorg(OldNumber,FNumber,FParentNumber,FShortNumber) 
VALUES
('01.026','05.001','05','001')

SELECT t.FItemID, a.FNumber,t2.FItemID,t2.FLevel+1,t2.FFullName+'_'+t.fname
FROM tab_uorg a 
INNER JOIN dbo.T_Item t ON t.fnumber=a.OldNumber AND t.FItemClassID=4
INNER JOIN dbo.T_Item t2 ON t2.fnumber=a.FParentNumber AND t2.FItemClassID=4

UPDATE tab_uorg 
SET FItemID=t.FItemID,
FFullNumber=a.FNumber,
FParentID=t2.FItemID,
FLevel=t2.FLevel+1,
FFullName=t2.FFullName+'_'+t.fname
FROM tab_uorg a 
INNER JOIN dbo.T_Item t ON t.fnumber=a.OldNumber AND t.FItemClassID=4
INNER JOIN dbo.T_Item t2 ON t2.fnumber=a.FParentNumber AND t2.FItemClassID=4


--SELECT *  FROM tab_uorg


--SELECT * FROM  T_Item
UPDATE dbo.t_Item 
SET 
fnumber=u.fnumber,
FFullNumber=u.FFullNumber,
FShortNumber=u.FShortNumber,
FParentID=u.FParentID,
FLevel=u.FLevel,
FFullName=u.FFullName
FROM dbo.T_Item t
INNER JOIN tab_uorg  u ON u.FItemID=t.FItemID
WHERE t.FItemClassID=4
PRINT('1')

--SELECT * FROM  cbCostObj --���ڳɱ�������ϸ��Ϣ
UPDATE cbCostObj
SET 
FNumber=t.FNumber,
FParentID=t.FParentID,
FShortNumber=t.FShortNumber
FROM dbo.t_Item t
WHERE t.FItemClassID=4 AND cbCostObj.FItemID=t.FItemID
AND EXISTS(SELECT * FROM tab_uorg WHERE FItemID=t.FItemID )
PRINT('2')

--SELECT * FROM T_ICItemCore  --���ı�ͨ��FItemID�������������
UPDATE T_ICItemCore
SET 
FNumber=t.FNumber,
FParentID=t.FParentID,
FShortNumber=t.FShortNumber
FROM dbo.t_Item t
WHERE t.FItemClassID=4 AND T_ICItemCore.FItemID=t.FItemID
AND EXISTS(SELECT * FROM tab_uorg WHERE FItemID=t.FItemID )
PRINT('3')

--SELECT * FROM T_ICItemBase   --�������ϱ������˹����ͺţ���λ��
UPDATE T_ICItemBase
SET 
FFullName=t.FFullName
FROM dbo.t_Item t
WHERE t.FItemClassID=4 AND T_ICItemBase.FItemID=t.FItemID
AND EXISTS(SELECT * FROM tab_uorg WHERE FItemID=t.FItemID )
PRINT('4')



