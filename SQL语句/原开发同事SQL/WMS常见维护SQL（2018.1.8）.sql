
--【一：效期问题】1、查询库存表中有效期与货品效期对不上的库存明细
SELECT li.COMPANY,li.ITEM,li.LOT,li.LOCATION,li.OnHandQty,
li.ExpirationDate,DATEDIFF(day,li.MFGdDate,li.ExpirationDate) diff,DaysToExpire FROM LocationInventory li
left JOIN ITEM on li.COMPANY=ITEM.COMPANY AND li.ITEM=ITEM.ITEM
WHERE DATEDIFF(day,li.MFGdDate,li.ExpirationDate)<>DaysToExpire

--2、更新库存有效期
UPDATE LocationInventory
SET ExpirationDate=DATEADD(day,DaysToExpire,li.MFGdDate)
FROM LocationInventory li
left JOIN ITEM on li.COMPANY=ITEM.COMPANY AND li.ITEM=ITEM.ITEM
WHERE DATEDIFF(day,li.MFGdDate,li.ExpirationDate)<>DaysToExpire

--【二：库存异常数据清理】1、清理0库存、负数库存及其他异常数据的数据
--（应当在上架任务全部完成，出库单全部发货完成后，执行以下脚本）
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