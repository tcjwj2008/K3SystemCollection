alter procedure pro_HT_MaterialException
as
begin
set nocount on
--原来同步的物料，客户可能在原帐套修改掉物料代码
--按2018-5-3，跟方伟强沟通，这可能是业务人员要做复制操作，忘了点复制，直接修改了。
--处理办法：把原帐套修改后的代码更新掉新帐套之前同步的物料代码
/*
同步物料时出现报错：
同步日志表保存有每一条同步记录的新内码，原内码，和物料代码。
1.根据日志表记录的原内码，到原帐套去查原物料代码。原物料代码和日志记录的物料代码不一样。  
怀疑原因：原帐套录入了物料代码，被同步到新帐套后，原帐套对物料代码做了修改。


2.内码一样，代码不一样，同时，原帐套还有一个代码跟新帐套代码一样的物料，但是内码又不一样
怀疑原因：原帐套录入了物料代码，被同步到新帐套后，原帐套对物料代码做了修改。原帐套又录入一条新物料，代码跟同步之前的代码一样。
*/
--1.1更新新帐套物料-辅助表t_item物料代码
update t8
set t8.FNumber=t9.FONumber,t8.FShortNumber=t9.foshortnumber,t8.FFullNumber=t9.fofullnumber
from t_Item t8 
inner join 
(
select t1.* ,t2.fitemid,t2.fnumber as FONumber,t2.fshortnumber as foshortnumber,t2.ffullnumber as fofullnumber
from t_HT_SyncControl  t1
left join (select * from [192.168.10.5].AIS20090210124856.dbo.t_item where fitemclassid=4) t2 on t1.foid=t2.Fitemid
where t1.FNumber<>t2.fnumber
and ISNULL(t2.FNumber,'')<>''
and ( t1.FType='物料' or t1.FType='辅助表-物料')
) t9 on t8.FItemID=t9.FID

--1.2更新新帐套物料t_icitemcore物料代码
update t8
set t8.FNumber=t9.FONumber,t8.FShortNumber=t9.foshortnumber
from t_ICItemCore t8 
inner join 
(
select t1.* ,t2.fitemid,t2.fnumber as FONumber,t2.fshortnumber as foshortnumber,t2.ffullnumber as fofullnumber
from t_HT_SyncControl  t1
left join (select * from [192.168.10.5].AIS20090210124856.dbo.t_item where fitemclassid=4) t2 on t1.foid=t2.Fitemid
where t1.FNumber<>t2.fnumber
and ISNULL(t2.FNumber,'')<>''
and ( t1.FType='物料' or t1.FType='辅助表-物料')
) t9 on t8.FItemID=t9.FID

--1.3更新新帐套成本对象-辅助表t_item物料代码
update t8
set t8.FNumber=t9.FONumber,t8.FShortNumber=t9.foshortnumber,t8.FFullNumber=t9.fofullnumber
from t_Item t8 
inner join 
(
select t1.* ,t2.fitemid,t2.fnumber as FONumber,t2.fshortnumber as foshortnumber,t2.ffullnumber as fofullnumber
from t_HT_SyncControl  t1
left join (select * from [192.168.10.5].AIS20090210124856.dbo.t_item where fitemclassid=4) t2 on t1.foid=t2.Fitemid
where t1.FNumber<>t2.fnumber
and ISNULL(t2.FNumber,'')<>''
and ( t1.FType='物料' or t1.FType='辅助表-物料')
) t9 on t8.FNumber=t9.FNumber
where t8.FItemClassID=2001

--1.4更新新帐套成本对象cbCostObj物料代码
update t8
set t8.FNumber=t9.FONumber,t8.FShortNumber=t9.foshortnumber
from cbCostObj t8 
inner join 
(
select t1.* ,t2.fitemid,t2.fnumber as FONumber,t2.fshortnumber as foshortnumber,t2.ffullnumber as fofullnumber
from t_HT_SyncControl  t1
left join (select * from [192.168.10.5].AIS20090210124856.dbo.t_item where fitemclassid=4) t2 on t1.foid=t2.Fitemid
where t1.FNumber<>t2.fnumber
and ISNULL(t2.FNumber,'')<>''
and ( t1.FType='物料' or t1.FType='辅助表-物料')
) t9 on t8.FNumber=t9.FNumber



--2.更新同步日志记录的物料代码
update t1
set t1.FNumber=t2.FNumber
from t_HT_SyncControl  t1
left join (select * from [192.168.10.5].AIS20090210124856.dbo.t_item where fitemclassid=4) t2 on t1.foid=t2.Fitemid
where t1.FNumber<>t2.fnumber
and ISNULL(t2.FNumber,'')<>''
and ( t1.FType='物料' or t1.FType='辅助表-物料')

set nocount off
end

--exec pro_HT_MaterialException