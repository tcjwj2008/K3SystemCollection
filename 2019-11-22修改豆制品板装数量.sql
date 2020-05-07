USE [AIS_YXDZP2018]
GO
/****** Object:  StoredProcedure [dbo].[sp_dzp_chechibanzhuang_tj_czq]    Script Date: 2019-11-22 8:53:08 
��֤ exec sp_dzp_chechibanzhuang_tj_czq '2019-11-21'
1097	8.01.010	ˮ����   8.01.010
1101	8.01.020	±ˮ�϶���  8.01.020
1548	8.01.030	���˶���  8.01.040
1573	8.01.040	�ҳ�����  8.02.040
1105	8.01.050	���ض���  8.02.030
10442	8.01.060	�Ͷ���    8.01.076
10264	8.01.900	��±�϶��� 8.01.075
1756	8.09.032	�ɲݶ�    8.11.051
******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--���ΰ�װͳ��
ALTER PROC [dbo].[sp_dzp_chechibanzhuang_tj_czq]
(
  @Fdate1 varchar(20)
)

AS

DECLARE @Fdate varchar(20) 
SELECT @Fdate=@Fdate1


SELECT ����,���� INTO #t FROM (
SELECT CONVERT(VARCHAR(12),t1.fdate,23) AS ����,t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as �ܰ�����
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( t4.FItemID IN ('1097',
'1101',
'1548',
'1573',
'1105',
'10442',
'10264',
'1756') )
group BY t1.fdate, t3.f_102 
)T ORDER BY CAST(���� AS int)



ALTER TABLE #t ADD ˮ���� FLOAT    --1097
ALTER TABLE #t ADD ±ˮ�϶��� FLOAT   --1101
ALTER TABLE #t ADD ���ض��� FLOAT     --1105
ALTER TABLE #t ADD ���˶��� FLOAT    --1548
ALTER TABLE #t ADD �ҳ����� FLOAT    --1573
ALTER TABLE #t ADD �ɲݶ� FLOAT     --1756

ALTER TABLE #t ADD ��±�϶��� FLOAT  --10264 
ALTER TABLE #t ADD �Ͷ��� FLOAT      --10442

ALTER TABLE #t ADD  �ܰ����� FLOAT

-------------------------------------------------------------

UPDATE t SET ˮ����=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.fitemid=1097 )
group BY  t3.f_102
) p ON  ISNULL(p.����,0) = ISNULL(t.����,0)

-------------------------------------------------------------
--8.01.020 ±ˮ�϶���
UPDATE t SET ±ˮ�϶���=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.fitemid=1101 )
group BY  t3.f_102
) p ON  ISNULL(p.����,0) = ISNULL(t.����,0)

-------------------------------------------------------------
--8.02.030	���ض���
UPDATE t SET ���ض���=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=1105 )
group BY  t3.f_102
) p ON  ISNULL(p.����,0) = ISNULL(t.����,0)

-------------------------------------------------------------
--8.01.040	���˶���
UPDATE t SET ���˶���=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.fitemid=1548 )
group BY  t3.f_102
) p ON  ISNULL(p.����,0) = ISNULL(t.����,0)

-------------------------------------------------------------
--8.02.040	�ҳ�����
UPDATE t SET �ҳ�����=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=1573)
group BY  t3.f_102
) p ON  ISNULL(p.����,0) = ISNULL(t.����,0)

-------------------------------------------------------------
--8.11.051	�ɲݶ�
UPDATE t SET �ɲݶ�=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=1756 )
group BY  t3.f_102
) p ON  ISNULL(p.����,0) = ISNULL(t.����,0)

-------------------------------------------------------------
--10264	8.01.075	��±�϶���
UPDATE t SET ��±�϶���=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=10264 )
group BY  t3.f_102
) p ON  ISNULL(p.����,0) = ISNULL(t.����,0)

-------------------------------------------------------------
--10442	8.01.076	�Ͷ���
UPDATE t SET �Ͷ���=ISNULL(FauxQty,0) FROM #t t
INNER JOIN (
SELECT t3.f_102 as ����,SUM(isnull(t2.FauxQty,0)) as FauxQty
from ICStockBill as t1 
inner join ICStockBillEntry as t2 on t1.finterid = t2.finterid 
inner join t_icitem as t4 on t2.fitemid = t4.fitemid
inner join t_Organization t3 ON t1.FSupplyID = t3.FItemID
where t1.fdate = @Fdate   AND t1.fcancellation='0' 
AND ( T4.FItemID=10442 )
group BY  t3.f_102
) p ON  ISNULL(p.����,0) = ISNULL(t.����,0)



UPDATE #t SET �ܰ�����=ISNULL(ˮ����,0)+ISNULL(±ˮ�϶���,0)+ISNULL(���ض���,0)
+ISNULL(���˶���,0)+ISNULL(�ҳ�����,0)+ISNULL(�ɲݶ�,0)
++ISNULL(��±�϶���,0)+ISNULL(�Ͷ���,0)

			


SELECT * FROM #t
UNION ALL
SELECT '�ϼ�' ����,NULL ����,NULL ˮ����,NULL ±ˮ�϶���,NULL 
���ض���,NULL ���˶���,NULL �ҳ�����,NULL �ɲݶ� ,NULL ��±�϶���,NULL �Ͷ���,
SUM(�ܰ�����) FROM #t


--ALTER TABLE #t ADD ˮ���� FLOAT    --1097
--ALTER TABLE #t ADD ±ˮ�϶��� FLOAT   --1101
--ALTER TABLE #t ADD ���ض��� FLOAT     --1105
--ALTER TABLE #t ADD ���˶��� FLOAT    --1548
--ALTER TABLE #t ADD �ҳ����� FLOAT    --1573
--ALTER TABLE #t ADD �ɲݶ� FLOAT     --1756

--ALTER TABLE #t ADD  �ܰ����� FLOAT





