--����˫������λ  yLD_K3Data_SecUnit

--        1.SQL �����������ϵĸ���������λ�ͻ�����
--        2.SQL ���������ڳ��ĸ���������ICBal��ICInvBal��POInvBal��
--        3.SQL �������±��ڷ������������ݵĸ�������
--        4.SQL �������±��ڷ����ķ��������ݵĸ�������
--        5.SQL У�Լ�ʱ���(����֪ͨ����Ӱ����ֿ��)


--        1.����ϵͳ���Ӹ�����������
--        2.���Ϸ����ʱ���һ��(����������Ϸ��䵽���һ�����ϵ�)
--     ******************************************************************************/  

        --1.�����������ϵĸ���������λ�ͻ�����
 --		dbo.SpK3_2tab @sName = 'ICBal' -- varchar(50)

 SELECT FSecUnitID,FSecCoefficient FROM T_ICItem    --���ϱ�
--�������� 1- �⹺�� 2-���� �� ���ƣ��������ã� ��3- ί��ӹ���4- ��5- �������6-������ ��7- �����ࣻ 8- �滮�ࣻ9- ��װ����
--�������� 1-�޳ɱ�����2-�гɱ�����3-�ޣ�5-�ޣ�6-�ޣ�7-�У�8-�ޣ�9-�ޣ�
SELECT * FROM T_ICItemCore    --���ı�ͨ��FItemID�������������
SELECT * FROM T_ICItemBase    --�������ϱ������˹����ͺţ���λ��
SELECT * FROM T_ICItemMaterial    --�������ϱ������˳ɱ��Ƽ۷����������ƿ�Ŀ
SELECT * FROM T_ICItemPlan    --�ƻ����ϱ������˼ƻ����Ժ͹���·�ߵ�
SELECT * FROM T_ICItemDesign    --������ϱ������˾��أ�ë�أ�����ߵ�
SELECT * FROM T_ICItemStandard    --��׼���ϱ������˱�׼�ɱ�����ʱ��
SELECT * FROM T_ICItemQuality    --�������ϱ���������
SELECT * FROM T_Base_ICItemEntrance    --���������ϱ�Ӣ�����ƣ�HS�����
SELECT * FROM T_ICItemCustom ;         --���������Զ�����ֶα�
?USE test_YXRY20191006;
UPDATE  t1 SET     FSecUnitID = 0 ,        FSecCoefficient = 0
FROM    T_ICItem t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
	--	WHERE t2.FNumber LIKE '7.1.01.04%'


USE test_YXRY20191006;
UPDATE  t1 SET     FSecUnitID = 0 ,        FSecCoefficient = 0
FROM    t_ICItemBase t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
	--	WHERE t2.FNumber LIKE '7.1.01.04%'
 
 --(323 ����Ӱ��)

        --2.���������ڳ��ĸ�������(ICBal)
	--	SELECT t1.*
		UPDATE  t1  SET     t1.FSecBegQty = 0 ,        t1.FSecEndQty = 0,        t1.FSecReceive =0,        t1.FSecSend = 0 ,        t1.FSecYtdReceive = 0 ,        t1.FSecYtdSend = 0
FROM    ICBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
      -- AND t1.FYear = 2019
    --  AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0
 --AND t2.FNumber LIKE '7.1.01.04%'

        --2.���������ڳ��ĸ�������(ICInvBal)
UPDATE  t1
SET     t1.FSecBegQty = 0 ,
        t1.FSecEndQty =0 ,
        t1.FSecReceive =0 ,
        t1.FSecSend =0 ,
        t1.FSecYtdReceive = 0 ,
        t1.FSecYtdSend =0
FROM    ICInvBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
      --  AND t1.FYear = 2018
      --  AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0;


        --2.���������ڳ��ĸ�������(POInvBal)
UPDATE  t1
SET     t1.FSecBegQty =0 ,
        t1.FSecEndQty = 0 ,
        t1.FSecReceive = 0 ,
        t1.FSecSend = 0 ,
        t1.FSecYtdReceive =0 ,
        t1.FSecYtdSend = 0
FROM    POInvBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
    --    AND t1.FYear = 2018
   --     AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0;


        --3.�������±��ڷ������������ݵĸ�������
UPDATE  t1
SET     t1.FSecCoefficient =0,
        t1.FSecQty = 0,
        t1.FSecQtyMust = 0 ,
        t1.FSecCommitQty = 0 ,
        t1.FSecVWInStockQty = 0 ,
        t1.FSecInvoiceQty =0,
        t1.FSecQtyActual = 0 ,
        t1.FOutSecCommitQty = 0
FROM    ICStockBillEntry t1
        --INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
        INNER JOIN ICStockBill t3 ON t3.FInterID = t1.FInterID
WHERE   1 = 1
      --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'
       --                                      AND     '20180931'
        AND t2.FSecCoefficient > 0;


        --4.�������±��ڷ����ķ��������ݵĸ�������
UPDATE  t1
SET     t1.FSecCoefficient = 0 ,
        t1.FSecQty = 0 ,
        t1.FSecCommitQty = 0 ,
        t1.FSecStockQty = 0,
        t1.FSecInvoiceQty = 0 ,
        t1.FSecDeliveryQty = 0
FROM    POOrderEntry t1
       -- INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
        INNER JOIN POOrder t3 ON t3.FInterID = t1.FInterID
WHERE   1 = 1
      --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'
      --                                       AND     '20180931'
        AND t2.FSecCoefficient > 0;


UPDATE  t1
SET     t1.FSecCoefficient = 0,
        t1.FSecQty = 0 ,
        t1.FSecCommitQty = 0 ,
        t1.FSecBackQty = 0 ,
        t1.FSecConCommitQty = 0 ,
        t1.FSecScrapQty = 0 ,
        t1.FSecScrapInCommitQty = 0 ,
        t1.FSecQtyPass = 0 ,
        t1.FSecConPassQty = 0 ,
        t1.FSecNotPassQty = 0,
        t1.FSecSampleBreakQty = 0 ,
        t1.FSecRelateQty =0 ,
        t1.FSecQCheckQty = 0
FROM    POInStockEntry t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
        INNER JOIN POInStock t3 ON t3.FInterID = t1.FInterID
WHERE   1 = 1
      --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'
     --                                        AND     '20180931'
        AND t2.FSecCoefficient > 0;


        --5.У�Լ�ʱ���
EXEC dbo.CheckInventory;