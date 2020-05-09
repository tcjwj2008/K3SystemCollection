--测试参考数据
SELECT * FROM dbo.t_Organization where FItemID=7370
SELECT * FROM dbo.t_Item WHERE FItemID=7370


SELECT top 5  * FROM T_ICItem    --物料表
SELECT top 5  * FROM T_ICItemCore    --核心表，通过FItemID与其它表相关联
SELECT top 5 * FROM T_ICItemBase    --基本资料表，包含了规则型号，单位等
SELECT top 5 * FROM T_ICItemMaterial

EXEC spk3_2str 'T_ICItemCore'
EXEC spk3_2str 'T_ICItem'
EXEC spk3_2str 'T_ICItemBase'

SELECT *  INTO Test_dzp2.dbo.bakt_t_Organization_20150708   FROM dbo.t_Organization

SELECT FChkUserID,* FROM t_item WHERE FItemClassID=1


UPDATE   t_item SET FChkUserID=NULL  WHERE FItemClassID=1


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

INSERT INTO tab_uorg(OldNumber,FNumber,FParentNumber,FShortNumber) VALUES('X04.07.0002','05.02.0002','05.02','0002')
INSERT INTO tab_uorg(OldNumber,FNumber,FParentNumber,FShortNumber) VALUES('X05.0010','05.03.0001','05.03','0001')
INSERT INTO tab_uorg(OldNumber,FNumber,FParentNumber,FShortNumber) VALUES('X05.0013','05.03.0002','05.03','0002')
INSERT INTO tab_uorg(OldNumber,FNumber,FParentNumber,FShortNumber) VALUES('X05.0003','05.03.0003','05.03','0003')
INSERT INTO tab_uorg(OldNumber,FNumber,FParentNumber,FShortNumber) VALUES('X03.02.0022','05.03.0004','05.03','0004')



SELECT * FROM t_Item where fitemid='418'
SELECT * FROM t_Item where fnumber='01.99'

SELECT * FROM tab_uorg
SELECT t.FItemID, a.FNumber,t2.FItemID,t2.FLevel+1,t2.FFullName+'_'+t.fname
FROM tab_uorg a 
INNER JOIN dbo.t_Item t ON t.fnumber=a.OldNumber AND t.FItemClassID=1
INNER JOIN dbo.t_Item t2 ON t2.fnumber=a.FParentNumber AND t2.FItemClassID=1

UPDATE tab_uorg 
SET FItemID=t.FItemID,
FFullNumber=a.FNumber,
FParentID=t2.FItemID,
FLevel=t2.FLevel+1,
FFullName=t2.FFullName+'_'+t.fname
FROM tab_uorg a 
INNER JOIN dbo.t_Item t ON t.fnumber=a.OldNumber AND t.FItemClassID=1
INNER JOIN dbo.t_Item t2 ON t2.fnumber=a.FParentNumber AND t2.FItemClassID=1


SELECT * FROM tab_uorg WHERE fnumber IN (SELECT fnumber  FROM dbo.t_Item t WHERE t.FItemClassID=1 )
DELETE tab_uorg WHERE FItemID IS NULL

SELECT * FROM dbo.t_Item t WHERE t.FItemClassID=1 AND FDetail=1 AND fnumber NOT LIKE 'x%'

SELECT t.fnumber,u.fnumber,t.FFullNumber,u.FFullNumber,t.FShortNumber,u.FShortNumber,
t.FParentID,u.FParentID,t.FLevel,u.FLevel,t.FFullName,u.FFullName
FROM dbo.t_Item t
left JOIN tab_uorg  u ON u.FItemID=t.FItemID
WHERE t.FItemClassID=1 AND t.fnumber=u.fnumber

SELECT COUNT(fnumber) ,fnumber
FROM tab_uorg 
GROUP BY fnumber 
HAVING COUNT(fnumber)>1

UPDATE dbo.t_Item 
SET 
fnumber=u.fnumber,
FFullNumber=u.FFullNumber,
FShortNumber=u.FShortNumber,
FParentID=u.FParentID,
FLevel=u.FLevel,
FFullName=u.FFullName
FROM dbo.t_Item t
INNER JOIN tab_uorg  u ON u.FItemID=t.FItemID
WHERE t.FItemClassID=1

EXEC spk3_2str 't_Organization'
SELECT * FROM t_Organization

SELECT k.FNumber,t.fnumber,k.FParentID,t.FParentID,k.FShortNumber,t.FShortNumber

FROM t_Organization k
INNER JOIN dbo.t_Item t  ON t.FItemID=k.FItemID



UPDATE t_Organization 
SET FNumber=t.fnumber,FParentID=t.FParentID,FShortNumber=t.FShortNumber
FROM t_Organization k
INNER JOIN dbo.t_Item t  ON t.FItemID=k.FItemID
WHERE t.FItemClassID=1 AND t.fnumber NOT LIKE 'x%'


-----
select 
--UPDATE dbo.t_Item  SET 
fnumber=u.fnumber,
FFullNumber=u.FFullNumber,
FShortNumber=u.FShortNumber,
FParentID=u.FParentID,
FLevel=u.FLevel,
FFullName=u.FFullName
FROM dbo.t_Item t
INNER JOIN tab_uorg  u ON u.FItemID=t.FItemID
WHERE t.FItemClassID=1