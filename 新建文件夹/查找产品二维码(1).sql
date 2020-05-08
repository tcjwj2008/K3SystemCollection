
/******浏览产品二维码********/
USE yxceshi;
SELECT  *
FROM    TZ_XS_deliverydata2019
WHERE   deliverycode = 'FHDH20190614000310'
SELECT  *
FROM    TZ_XS_delivery2019
WHERE   deliverycode = 'FHDH20190614000310'
SELECT TOP 100
        *
FROM    TZ_XS_deliveryinfo2019
WHERE   deliverycode = 'FHDH20190614000310'
  --产品二维码
 --2019-06-14 02:34:04.160
-- UPDATE   TZ_XS_delivery2019 SET deliverydate='2019-06-15 02:34:04.160'
--WHERE   deliverycode = 'FHDH20190614000310'
--2019-06-14 00:19:45.320
SELECT * FROM TZ_XS_delivery2019 WHERE deliverycode='FHDH20190614000052'

  --UPDATE dbo.TZ_XS_delivery2019 SET  deliverydate='2019-06-15 00:19:45.320'
  --WHERE   deliverycode = 'FHDH20190614000052'
/****还原*****/ 
-- UPDATE   TZ_XS_delivery2019 SET deliverydate='2019-06-14 02:34:04.160'
--WHERE   deliverycode = 'FHDH20190614000310' 

  --UPDATE dbo.TZ_XS_delivery2019 SET  deliverydate='2019-06-14 00:19:45.320'
  --WHERE   deliverycode = 'FHDH20190614000052'

/****按订单号查找****/
SELECT  *
FROM    dbo.TZ_XS_deliveryinfo2019 A
        INNER  JOIN dbo.TZ_XS_delivery2019 B ON A.deliverycodE = B.deliverycode
WHERE   B.ordercode = 'DD201906130143'
--'FHDH20190614000319'


/***按运单查找****/
SELECT TOP 100
        *
FROM    TZ_XS_deliveryinfo2019
WHERE   deliverycode = 'FHDH20190614000052'

SELECT TOP 100
        *
FROM    TZ_XS_deliveryinfo2019
WHERE   deliverycode = 'FHDH20190614000343'

/***关联方式*/  

SELECT  *
FROM    dbo.TZ_XS_deliveryinfo2019 

/******修改二维码*******/
  --UPDATE tz_xs_deliveryinfo2019 SET productscode=  'YXBT20190614008000021' WHERE deliverycode='FHDH20190614000310'
  --UPDATE dbo.TZ_XS_deliveryinfo2019 SET productscode= 'YXBT20190614008000020'
  --WHERE   deliverycode = 'FHDH20190614000052'
/******END*******/   
/****查找产地****/
SELECT TOP 100
        *
FROM    TZ_CG_register2019
WHERE   offerdate > '2019-06-13 00:00:00.000'
        AND offerdate < '2019-06-14 00:00:00.000'
        AND oneeartag = '04'

SELECT  areacode ,
        areaname
FROM    TZ_CG_register2019

SELECT  *
FROM    TZ_CG_register2019
WHERE   LEN(areaname) > 4
/******修改刺青对应的产地*******/
--UPDATE  TZ_CG_register2019
--SET     areaname = '龙岩漳平市英华农场'
--WHERE   offerdate > '2019-06-13 00:00:00.000'
--        AND offerdate < '2019-06-14 00:00:00.000'
--        AND oneeartag = '04'


SELECT  *
FROM    TZ_CG_register2019
WHERE   offerdate > '2019-06-13 00:00:00.000'
        AND offerdate < '2019-06-14 00:00:00.000'
        AND oneeartag = '07'

--UPDATE  TZ_CG_register2019
--SET     areaname = '龙岩长汀寿生家庭农场'
--WHERE   offerdate > '2019-06-13 00:00:00.000'
--        AND offerdate < '2019-06-14 00:00:00.000'
--        AND oneeartag = '07'


/**查找磅单*/
SELECT  *
FROM    TZ_CG_register2019 A
WHERE   A.RGID='SZ201906130006'




/*
龙岩漳平市东洋村益民生态养殖有限公司
龙岩漳平市英华农场
龙岩长汀寿生家庭农场
龙岩永定振东村旺顺养殖场
龙岩连城连城更旺生态农业有限公司
厦门同安大同街道养殖场
龙岩永定永定区呈祥农场
龙岩连城龙岩振沣牧业有限公司
漳州龙海原大禾农业生态园有限公司
龙岩长汀天蓬牧业养殖有限公司
漳州龙海原大禾农业生态园有限公司
*/




   





