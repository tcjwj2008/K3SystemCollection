/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000
        [id] ,
        [createtime] ,
        [opener] ,
        [trademark] ,
        [kinds] ,
        [code] ,
        [name] ,
        [spec] ,
        [price] ,
        [unit] ,
        [busing] ,
        [imageurl] ,
        [mcode] ,
        [warehouse] ,
        [ordernumber] ,
        [remark] ,
        [taxrate]
FROM    [yinxiang].[dbo].[t_product]
WHERE   name LIKE '%其他%'
        AND code IN ( '8.993', '8.992' );

SELECT  *
FROM    [yinxiang].[dbo].[t_product]
WHERE   id >= 12172;

SELECT  *
FROM    AIS_YXDZP2018.dbo.t_ICItem
WHERE   FItemID >= 12172;


  --DELETE FROM    [yinxiang].[dbo].[t_product]
  --WHERE name LIKE '%其他%' AND code IN( '8.993'  ,'8.992')


  --2更改其他的类型

SELECT  * 
   -- UPDATE AIS_YXDZP2018.dbo.t_item   SET FDetail=0
FROM    AIS_YXDZP2018.dbo.t_Item
WHERE   FNumber = '8.991';






  --客户组
SELECT  *
FROM    ICPrcPlyEntry A
        LEFT JOIN t_SubMessage B ( NOLOCK ) ON A.FRelatedID = B.FInterID
        LEFT JOIN t_ICItem C ( NOLOCK ) ON A.FItemID = C.FItemID
        LEFT JOIN t_MeasureUnit D ( NOLOCK ) ON A.FUnitID = D.FItemID
        LEFT JOIN ICPrcPlyEntrySpec E ( NOLOCK ) ON A.FInterID = E.FInterID
                                                    AND A.FItemID = E.FItemID
                                                    AND A.FRelatedID = E.FRelatedID
        LEFT JOIN ICPrcPly F ( NOLOCK ) ON A.FInterID = F.FInterID
WHERE   F.FNumber = '02'; 
			
					--客户			 
SELECT  *
FROM    yinxiang.dbo.t_levelprice
WHERE   code = '01.01.9999';
GO
	
 
 --客户
SELECT  A.*
FROM    ICPrcPlyEntry A
        LEFT JOIN t_Item B ( NOLOCK ) ON A.FRelatedID = B.FItemID
        LEFT JOIN t_ICItem C ( NOLOCK ) ON A.FItemID = C.FItemID
        LEFT JOIN t_MeasureUnit D ( NOLOCK ) ON A.FUnitID = D.FItemID
        LEFT JOIN ICPrcPlyEntrySpec E ( NOLOCK ) ON A.FInterID = E.FInterID
                                                    AND A.FItemID = E.FItemID
                                                    AND A.FRelatedID = E.FRelatedID
        LEFT JOIN ICPrcPly F ( NOLOCK ) ON A.FInterID = F.FInterID
        INNER JOIN dbo.t_Organization S ON A.FRelatedID = S.FItemID
WHERE   F.FNumber = '01'
        AND B.FItemClassID = 1
        AND S.FNumber = '01.01.9999';
			
			
	SELECT * FROM t_item WHERE Fitemid=12013	
	
	SELECT * FROM  t_product WHERE  id='12170'

SELECT  *
FROM    yinxiang.dbo.t_customerprice
WHERE   1 = 1
        AND storeno = 12013;
GO
	
	
				
SELECT * FROM yinxiang.dbo.t_levelprice WHERE  CODE LIKE'8.991.%'


SELECT * FROM dbo.t_levelprice


dbo.SpK3_2Str @sName = 'ICPrcPlyEntry'; 
-- varchar(50)

GO

dbo.SpK3_2Str @sName = 'ICPrcPly'; -- varchar(50)

-- varchar(50)
GO





SELECT  *
FROM    [yinxiang].[dbo].[t_product]
WHERE   id >= 12170;


SELECT a.id,a.code,b.FItemID,b.FNumber FROM [yinxiang].[dbo].[t_product] a,dbo.t_Item b
WHERE a.id=b.FItemID
AND a.code <>b.FNumber

SELECT *
--UPDATE t_product SET code='8.99.155'
FROM t_product 
WHERE code='8.99.955' AND id=11776



SELECT *
--UPDATE t_product SET code='1.02.0360'
FROM t_product 
WHERE code='1.03.0360' AND id=7173








