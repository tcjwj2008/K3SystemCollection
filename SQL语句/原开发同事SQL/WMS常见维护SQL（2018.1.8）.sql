
--��һ��Ч�����⡿1����ѯ��������Ч�����ƷЧ�ڶԲ��ϵĿ����ϸ
SELECT li.COMPANY,li.ITEM,li.LOT,li.LOCATION,li.OnHandQty,
li.ExpirationDate,DATEDIFF(day,li.MFGdDate,li.ExpirationDate) diff,DaysToExpire FROM LocationInventory li
left JOIN ITEM on li.COMPANY=ITEM.COMPANY AND li.ITEM=ITEM.ITEM
WHERE DATEDIFF(day,li.MFGdDate,li.ExpirationDate)<>DaysToExpire

--2�����¿����Ч��
UPDATE LocationInventory
SET ExpirationDate=DATEADD(day,DaysToExpire,li.MFGdDate)
FROM LocationInventory li
left JOIN ITEM on li.COMPANY=ITEM.COMPANY AND li.ITEM=ITEM.ITEM
WHERE DATEDIFF(day,li.MFGdDate,li.ExpirationDate)<>DaysToExpire

--����������쳣��������1������0��桢������漰�����쳣���ݵ�����
--��Ӧ�����ϼ�����ȫ����ɣ����ⵥȫ��������ɺ�ִ�����½ű���
update LocationInventory set OnHandQty=0 where OnHandQty<0
update LocationInventory set AllocatedQty=0 where AllocatedQty<0
update LocationInventory set InTransitQty=0 where InTransitQty<0
update LocationInventory set SuspenseQty=0 where SuspenseQty<0

delete FROM LocationInventory
where InTransitQty=0 AND OnHandQty=0 and AllocatedQty=0 AND SuspenseQty=0

update location set LocationSts='Empty' where location not in
(select location from LocationInventory )
update LocationInventory set QtyUm='EA' WHERE QtyUm IS NULL
update LocationInventory set InventorySts='Available' WHERE InventorySts IS NULL