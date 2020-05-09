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
--SELECT  FITEMCLASSID,FNUMBER FROM #t_item20191109 GROUP BY FITEMCLASSID,FNUMBER HAVING COUNT(*)>1

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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.01.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.030'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X01.010'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X01.011'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X01.012'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X01.013'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X01.014'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.01.040'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.01.016'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X01.018'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.01.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.01.050'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.050'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X02.002'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.070'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X02.005'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.010'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.011'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X02.008'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.080'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.060'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.090'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.02.012'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.150'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.100'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.140'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X02.016'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X02.017'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X02.018'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X02.019'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.074'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.021'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.016'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.017'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.061'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.071'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.081'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.110'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.141'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.120'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.130'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.022'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.054'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.101'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.180'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.013'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.012'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.052'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.072'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.023'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.170'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.030'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X03.002'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.040'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X03.004'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.050'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X03.006'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X03.008'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X03.010'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.060'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X03.012'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.070'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.061'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.031'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.051'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.041'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.010'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.011'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.042'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.001'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.002'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.010'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.004'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.030'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.006'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.050'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.008'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.091'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.011'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.012'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.013'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.040'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.100'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.016'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.017'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.018'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.019'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.014'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.071'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.080'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.082'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.041'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.030'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X04.031'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.032'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.101'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.013'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.012'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.04.092'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.080'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X05.003'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.081'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.083'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.084'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.11.051'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.03.090'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.11.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.11.011'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.11.040'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.02.190'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X07.003'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X07.004'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X07.005'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X07.006'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X07.007'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.011'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.021'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.031'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.040'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.050'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.060'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.010'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.030'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.05.070'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.010'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.002'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.021'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.006'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.007'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.030'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.040'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.011'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.012'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.060'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.013'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.016'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.017'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.018'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.019'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X09.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.062'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.050'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.061'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.12.051'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X10.001'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.010'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X10.003'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X10.005'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X10.006'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X10.007'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X10.008'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.030'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X10.011'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X10.013'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.09.040'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0012'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0013'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0014'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0016'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0017'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0019'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0020'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0021'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0022'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0023'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0024'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='X8.12.0025'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.040'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.080'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.050'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.060'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.070'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.090'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.100'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.110'
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
                                             'MaterielMakeID' )AND #t_item20191109.fnumber  ='8.10.120'



