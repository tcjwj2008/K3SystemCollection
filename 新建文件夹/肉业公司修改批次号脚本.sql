CREATE TABLE #abc (���ϴ��� VARCHAR(50),������ VARCHAR(50),������ VARCHAR(50), ���� VARCHAR(50))


INSERT into #abc(���ϴ���,������,������) values('8.8.02.02.000380','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000390','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000400','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000410','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000480','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000440','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000470','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000420','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000500','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000460','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000370','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000360','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000350','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000330','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000290','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000280','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000270','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000340','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000260','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000320','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000450','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000300','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000560','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000310','AA','201908');
insert into #abc(���ϴ���,������,������) values('8.8.02.02.000510','AA','201908');



UPDATE a SET ����=b.fitemid 
FROM #abc a,dbo.t_ICItem b
WHERE a.���ϴ���=b.FNumber

SELECT * FROM  #abc a,dbo.t_ICItem b
WHERE a.���ϴ���=b.FNumber


--2222222222222222222222222
UPDATE a set a.fbatchmanager=1 FROM dbo.t_ICItemMaterial a,t_icitem b WHERE FNumber IN(

SELECT ���ϴ��� FROM #abc) AND a.FItemID=b.FItemID

SELECT  a.FBatchManager FROM dbo.t_ICItemMaterial a,t_icitem b WHERE FNumber IN(

SELECT ���ϴ��� FROM #abc) AND a.FItemID=b.FItemID

--

SELECT fbatchmanager FROM t_icitem WHERE FNumber IN(

SELECT ���ϴ��� FROM #abc)

--333333333333333333333333333



--�����ʼ���ݱ��ϼ���������Ϣ

SELECT b.FBatchNo,a.������,a.������ FROM icinvinitial b
INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������
--SELECT * FROM dbo.ICInvInitial WHERE FItemID IN(
--SELECT ���� FROM #abc)
UPDATE b SET b.FBatchNo=a.������ FROM icinvinitial b
INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������

--�ⷿ��������ϼ���������Ϣ
SELECT b.FBatchNo,a.������,a.������ FROM icinvbal b
INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������
--SELECT * FROM dbo.icinvbal WHERE FItemID IN(
--SELECT ���� FROM #abc)
UPDATE b SET b.FBatchNo=a.������ FROM icinvbal b
INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������

--��������ϼ���������Ϣ
SELECT b.FBatchNo,a.������,a.������ FROM icbal b
INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������
--SELECT * FROM dbo.icbal WHERE FItemID IN(
--SELECT ���� FROM #abc)
UPDATE b SET b.FBatchNo=a.������ FROM icbal b
INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������

--��ѯ�����
SELECT b.FBatchNo,a.������,a.������ FROM dbo.ICStockBillEntry b
INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������

UPDATE b SET b.FBatchNo=a.������ FROM ICStockBillEntry b
INNER JOIN #abc a ON b.FItemID=a.����

SELECT b.FBatchNo,a.������,a.������ FROM dbo.icinventory b
INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������
update b  SET b.FBatchNo=a.������ 
FROM dbo.icinventory b
INNER JOIN #abc a ON b.FItemID=a.����



--SELECT b.FBatchNo,a.������,a.������ FROM dbo.ICInvInitialAdj b
--INNER JOIN #abc a ON b.FItemID=a.���� AND b.FBatchNo=a.������
--update b  SET b.FBatchNo=a.������ 
--FROM dbo.icinventory b
--INNER JOIN #abc a ON b.FItemID=a.����
--FBatchNo

