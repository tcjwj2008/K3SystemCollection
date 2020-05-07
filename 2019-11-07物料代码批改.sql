--1创建临时表

CREATE TABLE #tab_uorg
    (
      FItemID INT ,
      OldNumber VARCHAR(255) ,
      FNumber VARCHAR(255) ,
      FFullNumber VARCHAR(255) ,
      FShortNumber VARCHAR(255) ,
      FParentNumber VARCHAR(255) ,
      FParentID INT ,
      FLevel INT ,
      FFullName VARCHAR(255),
	  FParentID2001 INT
    );


--2插入临时表数据
INSERT  INTO #tab_uorg
        ( OldNumber ,
          FNumber ,
          FParentNumber ,
          FShortNumber

        )
VALUES  ( '8.12.107' ,
          '8.991.107' ,
          '8.991' ,
          '107'
        );



--3修改临时表值
SELECT a.FItemID ,t.FItemID ,
        a.FFullNumber, a.FNumber ,
       a. FParentID , t2.FItemID ,
        a.FLevel , t2.FLevel + 1 ,
       a. FFullName , t2.FFullName + '_' + t.FName
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t ON t.FNumber = a.OldNumber
                                   AND t.FItemClassID = 4
        INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 4;

UPDATE  #tab_uorg
SET     FItemID = t.FItemID ,
        FFullNumber = a.FNumber ,
        FParentID = t2.FItemID ,
        FLevel = t2.FLevel + 1 ,
        FFullName = t2.FFullName + '_' + t.FName
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t ON t.FNumber = a.OldNumber
                                   AND t.FItemClassID = 4
        INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 4;


--4修改临时表值FParentid2001

SELECT   a.FParentID2001 , t2.FItemID 
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 2001;
--SELECT   * FROM    #tab_uorg a
--SELECT * FROM t_Item WHERE FNumber='8.12.107'
--SELECT * FROM t_Item WHERE FNumber='8.991'
--SELECT * FROM dbo.t_Item WHERE FNumber='8.12'
--SELECT * FROM dbo.t_Item WHERE FNumber='8'
--5修改项目
UPDATE  #tab_uorg
SET   
        FParentID2001 = t2.FItemID 
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 2001;


--SELECT   * FROM    #tab_uorg a
--SELECT * FROM t_Item WHERE FNumber='8.12.107'
--SELECT * FROM t_Item WHERE FNumber='8.991'
--SELECT * FROM dbo.t_Item WHERE FNumber='8.12'
--SELECT * FROM dbo.t_Item WHERE FNumber='8'
--5修改项目
--4修改t_item项目
SELECT  t.FNumber , u.FNumber ,
        t.FFullNumber , u.FFullNumber ,
        t.FShortNumber , u.FShortNumber ,
        t.FParentID, u.FParentID ,
        t.FLevel , u.FLevel ,
        t.FFullName , u.FFullName 
FROM    dbo.t_Item t
        INNER JOIN #tab_uorg u ON u.FItemID = t.FItemID
WHERE   t.FItemClassID = 4;



--SELECT   * FROM    #tab_uorg a
--SELECT * FROM t_Item WHERE FNumber='8.12.107'
--SELECT * FROM t_Item WHERE FNumber='8.991'
--SELECT * FROM dbo.t_Item WHERE FNumber='8.12'
--SELECT * FROM dbo.t_Item WHERE FNumber='8'
--5修改项目
UPDATE  dbo.t_Item
SET     FNumber = u.FNumber ,
        FFullNumber = u.FFullNumber ,
        FShortNumber = u.FShortNumber ,
        FParentID = u.FParentID ,
        FLevel = u.FLevel ,
        FFullName = u.FFullName
FROM    dbo.t_Item t
        INNER JOIN #tab_uorg u ON u.FItemID = t.FItemID
WHERE   t.FItemClassID = 4;

--SELECT   * FROM    #tab_uorg a
--SELECT * FROM t_Item WHERE FNumber='8.12.107'
--SELECT * FROM t_Item WHERE FNumber='8.991'
--SELECT * FROM dbo.t_Item WHERE FNumber='8.12'
--SELECT * FROM dbo.t_Item WHERE FNumber='8'
--5修改项目
SELECT t.FNumber , u.FNumber ,
        t.FFullNumber , u.FFullNumber ,
       t. FShortNumber , u.FShortNumber ,
       t. FParentID , u.FParentID2001 ,
       t. FLevel , u.FLevel ,
       t. FFullName , u.FFullName
FROM    dbo.t_Item t
        INNER JOIN #tab_uorg u ON u.OldNumber = t.FNumber 
WHERE   t.FItemClassID = 2001;

UPDATE  dbo.t_Item
SET     FNumber = u.FNumber ,
        FFullNumber = u.FFullNumber ,
        FShortNumber = u.FShortNumber ,
        FParentID = u.FParentID2001 ,
        FLevel = u.FLevel ,
        FFullName = u.FFullName
FROM    dbo.t_Item t
        INNER JOIN #tab_uorg u ON u.OldNumber = t.FNumber 
WHERE   t.FItemClassID = 2001;




--SELECT * FROM  t_item where fnumber ='8.12.770'--存在成本对象详细信息
SELECT  cbCostObj.FNumber , t.FNumber ,
        cbCostObj.FParentID , t.FParentID ,
       cbCostObj. FShortNumber , t.FShortNumber
FROM    dbo.t_Item t,cbCostObj
WHERE   t.FItemClassID = 4
        AND cbCostObj.FStdProductID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID );


UPDATE  cbCostObj
SET     FNumber = t.FNumber ,
        FParentID = t.FParentID ,
        FShortNumber = t.FShortNumber
FROM    dbo.t_Item t
WHERE   t.FItemClassID = 4
        AND cbCostObj.FStdProductID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID );

SELECT  cbCostObj.FNumber ,
        t.FNumber ,
        cbCostObj.FParentID ,
        t.FParentID ,
        dbo.cbCostObj.FShortNumber ,
        t.FShortNumber
FROM    dbo.t_Item t ,
        cbCostObj
WHERE   t.FItemClassID = 4
        AND cbCostObj.FStdProductID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID );



UPDATE  t_ICItemCore
SET     FNumber = t.FNumber ,
        FParentID = t.FParentID ,
        FShortNumber = t.FShortNumber
FROM    dbo.t_Item t
WHERE   t.FItemClassID = 4
        AND t_ICItemCore.FItemID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID );



UPDATE  t_ICItemBase
SET     FFullName = t.FFullName
FROM    dbo.t_Item t
WHERE   t.FItemClassID = 4
        AND t_ICItemBase.FItemID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID );





--删除表
DROP TABLE #tab_uorg;

