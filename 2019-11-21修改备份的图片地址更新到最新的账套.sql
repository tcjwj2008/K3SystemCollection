/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [id]
      ,[createtime]
      ,[opener]
      ,[trademark]
      ,[kinds]
      ,[code]
      ,[name]
      ,[spec]
      ,[price]
      ,[unit]
      ,[busing]
      ,[imageurl]
      ,[mcode]
      ,[warehouse]
      ,[ordernumber]
      ,[remark]
      ,[taxrate]
  FROM [yinxiang].[dbo].[t_product]


  SELECT A.*
 -- UPDATE B SET B.IMAGEURL=A.IMAGEURL  
  
  FROM [test_yinxiang20191121].[dbo].[t_product] A ,[yinxiang].[dbo].[t_product] B WHERE  
  A.ID=B.ID


  SELECT * FROM AIS_YXDZP2018.dbo.t_item WHERE FNumber='8.20.020'

  SELECT * FROM yinxiang.dbo.t_product WHERE code='8.20.020'

  --验证价格与备份是否一样
  
  SELECT * FROM [yinxiang].[dbo].t_customerprice a,  [test_yinxiang20191121].[dbo].t_customerprice b
  WHERE a.id=b.id 

  SELECT * FROM [yinxiang].[dbo].t_levelprice a,  [test_yinxiang20191121].[dbo].t_levelprice b
  WHERE a.id=b.id AND a.price=b.price
  SELECT * FROM [yinxiang].[dbo].t_levelprice WHERE 1=1  AND kinds LIKE '%加盟-厦门%' ORDER BY kinds ,code
  SELECT * FROM  [test_yinxiang20191121].[dbo].t_levelprice WHERE 1=1 AND  kinds LIKE '%加盟-厦门%' ORDER BY kinds ,code
   UPDATE a SET a.code=b.code 
 FROM  [yinxiang].[dbo].t_customerprice a,  [test_yinxiang20191121].[dbo].t_customerprice b
  WHERE a.id=b.id 

     UPDATE a SET a.code=b.code 
 FROM [yinxiang].[dbo].t_levelprice a,  [test_yinxiang20191121].[dbo].t_levelprice b
  WHERE a.id=b.id


    SELECT  * FROM [yinxiang].[dbo].t_levelprice  ORDER BY id


   SELECT * FROM [test_yinxiang20191121].[dbo].t_levelprice  ORDER BY id
 SELECT  * FROM [yinxiang].[dbo].t_product WHERE LEN(CODE) IN (3,4,5)-- LIKE '8.X%' ORDER BY ID

    SELECT  * FROM [yinxiang].[dbo].t_product WHERE ID   IN(


   SELECT ID FROM [test_yinxiang20191121].[dbo].t_product  WHERE 1=1) -- code='8.X99' ORDER BY id



      SELECT  * FROM [yinxiang].[dbo].t_product  A,

	     [test_yinxiang20191121].[dbo].t_product B WHERE A.ID=B.ID


     SELECT  * FROM [yinxiang].[dbo].t_product  A,

	     [test_yinxiang20191121].[dbo].t_product B WHERE A.ID=B.ID

SELECT * FROM t_item WHERE f
     SELECT  * FROM [yinxiang].[dbo].t_product  A,

	     [test_yinxiang20191121].[dbo].t_product B WHERE A.ID=B.ID



        UPDATE a SET a.opener=b.opener 
 FROM [yinxiang].[dbo].t_product a,  [test_yinxiang20191121].[dbo].t_product b
  WHERE a.id=b.id


 SELECT  * FROM [yinxiang].[dbo].t_product  WHERE len