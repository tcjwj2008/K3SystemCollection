--查询物料代码
SELECT  *
FROM    dbo.t_Item
WHERE   FItemClassID IN ( 2001, 4 )
ORDER BY FItemID;
GO

--查询临时表
SELECT  *
FROM    #t_item20191109
ORDER BY FItemID;


SELECT  *
INTO    #t_item20191109
FROM    t_Item
WHERE   FItemClassID = 2001
        AND FNumber NOT IN ( SELECT FNumber
                             FROM   t_Item
                             WHERE  FItemClassID = 4 )
        AND FDetail = 1;
GO

SELECT  *
FROM    #t_item20191109
ORDER BY FItemID;

UPDATE  #t_item20191109
SET     FItemID = FItemID - 1;
GO

--3修改临时表
SELECT  #t_item20191109.FNumber ,
        t_Item.FNumber ,
        #t_item20191109.FFullNumber ,
        t_Item.FFullNumber ,
        #t_item20191109.FShortNumber ,
        t_Item.FShortNumber ,
        #t_item20191109.FParentID ,
        t_Item.FParentID ,
        #t_item20191109.FLevel ,
        t_Item.FLevel ,
        #t_item20191109.FFullName ,
        t_Item.FFullName
FROM    dbo.t_Item ,
        #t_item20191109
WHERE   t_Item.FItemID = #t_item20191109.FItemID
        AND t_Item.FItemClassID = 4;




UPDATE  #t_item20191109
SET     #t_item20191109.FNumber = t_Item.FNumber ,
        #t_item20191109.FFullNumber = t_Item.FFullNumber ,
        #t_item20191109.FShortNumber = t_Item.FShortNumber ,
        #t_item20191109.FParentID = t_Item.FParentID ,
        #t_item20191109.FLevel = t_Item.FLevel ,
        #t_item20191109.FFullName = t_Item.FFullName
FROM    dbo.t_Item ,
        #t_item20191109
WHERE   t_Item.FItemID = #t_item20191109.FItemID
        AND t_Item.FItemClassID = 4;



--4修改临时表

UPDATE  #t_item20191109
SET     FItemID = FItemID + 1;

UPDATE  #t_item20191109
SET     FParentID = FParentID + 1;
GO

--5修改t_item表
SELECT  t_Item.FNumber AS fnumber1 ,
        #t_item20191109.FNumber ,
        t_Item.FFullNumber AS FFullNumber1 ,
        #t_item20191109.FFullNumber ,
        t_Item.FShortNumber FShortNumber1 ,
        #t_item20191109.FShortNumber ,
        t_Item.FParentID FParentID1 ,
        #t_item20191109.FParentID ,
        t_Item.FLevel FLevel1 ,
        #t_item20191109.FLevel ,
        t_Item.FFullName FFullName1 ,
        #t_item20191109.FFullName ,
        t_Item.FItemClassID ,
        t_Item.FNumber ,
        #t_item20191109.FNumber
FROM    dbo.t_Item ,
        #t_item20191109
WHERE   t_Item.FItemID = #t_item20191109.FItemID
        AND dbo.t_Item.FItemClassID = 2001
        AND t_Item.FItemClassID = #t_item20191109.FItemClassID
        AND t_Item.FNumber <> #t_item20191109.FNumber
        AND #t_item20191109.FNumber NOT IN ( 'MaterielShareID',
                                             'MaterielMakeID' );



UPDATE  t_Item
SET     t_Item.FNumber = #t_item20191109.FNumber ,
        t_Item.FFullNumber = #t_item20191109.FFullNumber ,
        t_Item.FShortNumber = #t_item20191109.FShortNumber ,
        t_Item.FParentID = #t_item20191109.FParentID ,
        t_Item.FLevel = #t_item20191109.FLevel ,
        t_Item.FFullName = #t_item20191109.FFullName
FROM    
        #t_item20191109
WHERE   t_Item.FItemID = #t_item20191109.FItemID
        AND dbo.t_Item.FItemClassID = 2001
        AND t_Item.FItemClassID = #t_item20191109.FItemClassID
        AND t_Item.FNumber <> #t_item20191109.FNumber
        AND #t_item20191109.FNumber NOT IN ( 'MaterielShareID',
                                             'MaterielMakeID' )







UPDATE  t_Item
SET     t_Item.FNumber = #t_item20191109.FNumber ,
        t_Item.FFullNumber = #t_item20191109.FFullNumber ,
        t_Item.FShortNumber = #t_item20191109.FShortNumber ,
        t_Item.FParentID = #t_item20191109.FParentID ,
        t_Item.FLevel = #t_item20191109.FLevel ,
        t_Item.FFullName = #t_item20191109.FFullName
FROM    
        #t_item20191109
WHERE   t_Item.FItemID = #t_item20191109.FItemID
        AND dbo.t_Item.FItemClassID = 2001
        AND t_Item.FItemClassID = #t_item20191109.FItemClassID
        AND t_Item.FNumber <> #t_item20191109.FNumber
        AND #t_item20191109.FNumber NOT IN ( 'MaterielShareID',
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.01.030'


 ---

 --2更新原来的成本信息
UPDATE  cbCostObj
SET     FNumber = t.FNumber ,
        FParentID = t.FParentID ,
        FShortNumber = t.FShortNumber
FROM    dbo.t_Item t
WHERE   t.FItemClassID = 4
        AND cbCostObj.FStdProductID = t.FItemID;
GO

DROP TABLE #t_item20191109;


