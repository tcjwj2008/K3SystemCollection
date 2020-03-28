select * from t_TableDescription where FDescription like '%单位%'

select * from t_FieldDescription where FTableID=17 order by FFieldName

select FSampStdCritical   from AIS20140120174606.dbo.t_ICItem

select * from t_Item where FItemClassID=2003
select *  from t_icitem 
select FCubicMeasure                                                                    from t_icitem group by FAcctID
select FNumber from t_Account

select *  from t_ItemClass

select  t1.fitemid,t2.FItemID,t1.FItemClassID,0 as FParentID,t1.FLevel,t1.FName,t1.FNumber,
t1.FShortNumber,t1.FFullNumber,t1.FDetail,t1.FDeleted
from AIS20140120174606.dbo.t_item t1
left join AIS20140120174606.dbo.t_ICItem t2 on t1.fnumber =t2.FNumber
where (1=1)
and t1.fitemclassid=4 
and t1.FDetail=1
and t1.FDeleted=0
and t2.FErpClsID=1


select * from t_gr_itemcontrol

---删除物料
/**
delete from t_ICItem
delete from t_item where FItemClassID=4 
delete from t_item where FItemClassID=2001
delete from cbcostobj where FNumber<>'MaterielShareID' and FNumber<>'MaterielMakeID'

                                                                                                                           
**/
--删除单位
--delete from t_UnitGroup   
--delete from t_MeasureUnit 
--delete from t_item where fitemclassid=7         
select * from t_ItemClass
select * from t_item where fitemclassid=2001 and fdetail=1 order by fitemid
select fnext from t_Identity where fname='t_item'

select t1.FFullName , t2.FFullName FROM t_ICItemBase t1 INNER JOIN t_Item t2 ON t1.FItemID = t2.FItemID AND t2.FItemID =936

select ffullname from t_item where FItemClassID=4 and FDetail=0

select FName,* from t_Item where FItemID=936 and FItemClassID=4

FAcctID --存货科目
FCostAcctID  --销售成本科目
FSaleAcctID       --销售收入科目

select FAcctID,FTrack,* from t_ICItem where fnumber= '1.01.000.00002'
select fnumber,* from t_account where FAccountID=1014
declare @FAcctID int
select @FAcctID=FAccountID from t_Account where FNumber='1243'
select isnull(@FAcctID,0)


select * from t_item where fitemclassid in (4,2001) and fnumber='1.01.01.003' 31742
31744

select * from cb_CostObj_Product where FProductID=31742 and FCostObjID=31744

 SELECT  t1.FItemID, t1.FNumber,t1.FName, t1.FCalculateType, t1.FBatchNo,t1.FSBillNo,t1.FStdProductID,t1.FBomID as FBomID,t1.FStandardBomID,IsNull(t2.FBomNumber,'')  as FBomNumber,IsNull(t3.FBomNumber,'') as FStandardBomNumber  FROM cbCostobj t1 left join ICBom t2 ON(t1.FBomID=t2.FInterID)  left join ICBom t3 ON(t1.FStandardBomID=t3.FinterID) WHERE t1.FItemID = 31744 and t1.FNumber not in ('MaterielShareID','MaterielMakeID')

SELECT i.FNumber, i.FName, i.FModel,i.FUnitID, --m.FName AS FUnitName,
 c.FQuotiety, c.FIsStand,c.FIsDeputy, i.FItemID, c.FCostObjID, i.FItemID as FFlag,i.FErpClsID 
 FROM CB_CostObj_Product c  
 INNER JOIN t_ICItem i ON c.FProductID=i.FItemID  
 --INNER JOIN t_MeasureUnit m ON m.FItemID=i.FUnitID 
  WHERE FCostObjID =31744 ORDER BY i.FNumber
                                                                         