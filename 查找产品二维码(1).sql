
/******�����Ʒ��ά��********/
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
  --��Ʒ��ά��
 --2019-06-14 02:34:04.160
-- UPDATE   TZ_XS_delivery2019 SET deliverydate='2019-06-15 02:34:04.160'
--WHERE   deliverycode = 'FHDH20190614000310'
--2019-06-14 00:19:45.320
SELECT * FROM TZ_XS_delivery2019 WHERE deliverycode='FHDH20190614000052'

  --UPDATE dbo.TZ_XS_delivery2019 SET  deliverydate='2019-06-15 00:19:45.320'
  --WHERE   deliverycode = 'FHDH20190614000052'
/****��ԭ*****/ 
-- UPDATE   TZ_XS_delivery2019 SET deliverydate='2019-06-14 02:34:04.160'
--WHERE   deliverycode = 'FHDH20190614000310' 

  --UPDATE dbo.TZ_XS_delivery2019 SET  deliverydate='2019-06-14 00:19:45.320'
  --WHERE   deliverycode = 'FHDH20190614000052'

/****�������Ų���****/
SELECT  *
FROM    dbo.TZ_XS_deliveryinfo2019 A
        INNER  JOIN dbo.TZ_XS_delivery2019 B ON A.deliverycodE = B.deliverycode
WHERE   B.ordercode = 'DD201906130143'
--'FHDH20190614000319'


/***���˵�����****/
SELECT TOP 100
        *
FROM    TZ_XS_deliveryinfo2019
WHERE   deliverycode = 'FHDH20190614000052'

SELECT TOP 100
        *
FROM    TZ_XS_deliveryinfo2019
WHERE   deliverycode = 'FHDH20190614000343'

/***������ʽ*/  

SELECT  *
FROM    dbo.TZ_XS_deliveryinfo2019 

/******�޸Ķ�ά��*******/
  --UPDATE tz_xs_deliveryinfo2019 SET productscode=  'YXBT20190614008000021' WHERE deliverycode='FHDH20190614000310'
  --UPDATE dbo.TZ_XS_deliveryinfo2019 SET productscode= 'YXBT20190614008000020'
  --WHERE   deliverycode = 'FHDH20190614000052'
/******END*******/   
/****���Ҳ���****/
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
/******�޸Ĵ����Ӧ�Ĳ���*******/
--UPDATE  TZ_CG_register2019
--SET     areaname = '������ƽ��Ӣ��ũ��'
--WHERE   offerdate > '2019-06-13 00:00:00.000'
--        AND offerdate < '2019-06-14 00:00:00.000'
--        AND oneeartag = '04'


SELECT  *
FROM    TZ_CG_register2019
WHERE   offerdate > '2019-06-13 00:00:00.000'
        AND offerdate < '2019-06-14 00:00:00.000'
        AND oneeartag = '07'

--UPDATE  TZ_CG_register2019
--SET     areaname = '���ҳ�͡������ͥũ��'
--WHERE   offerdate > '2019-06-13 00:00:00.000'
--        AND offerdate < '2019-06-14 00:00:00.000'
--        AND oneeartag = '07'


/**���Ұ���*/
SELECT  *
FROM    TZ_CG_register2019 A
WHERE   A.RGID='SZ201906130006'




/*
������ƽ�ж����������̬��ֳ���޹�˾
������ƽ��Ӣ��ũ��
���ҳ�͡������ͥũ��
���������񶫴���˳��ֳ��
�����������Ǹ�����̬ũҵ���޹�˾
����ͬ����ͬ�ֵ���ֳ��
������������������ũ��
������������������ҵ���޹�˾
��������ԭ���ũҵ��̬԰���޹�˾
���ҳ�͡������ҵ��ֳ���޹�˾
��������ԭ���ũҵ��̬԰���޹�˾
*/




   





