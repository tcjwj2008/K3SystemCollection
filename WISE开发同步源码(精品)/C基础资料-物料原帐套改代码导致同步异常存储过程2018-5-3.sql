alter procedure pro_HT_MaterialException
as
begin
set nocount on
--ԭ��ͬ�������ϣ��ͻ�������ԭ�����޸ĵ����ϴ���
--��2018-5-3������ΰǿ��ͨ���������ҵ����ԱҪ�����Ʋ��������˵㸴�ƣ�ֱ���޸��ˡ�
--����취����ԭ�����޸ĺ�Ĵ�����µ�������֮ǰͬ�������ϴ���
/*
ͬ������ʱ���ֱ���
ͬ����־������ÿһ��ͬ����¼�������룬ԭ���룬�����ϴ��롣
1.������־���¼��ԭ���룬��ԭ����ȥ��ԭ���ϴ��롣ԭ���ϴ������־��¼�����ϴ��벻һ����  
����ԭ��ԭ����¼�������ϴ��룬��ͬ���������׺�ԭ���׶����ϴ��������޸ġ�


2.����һ�������벻һ����ͬʱ��ԭ���׻���һ������������״���һ�������ϣ����������ֲ�һ��
����ԭ��ԭ����¼�������ϴ��룬��ͬ���������׺�ԭ���׶����ϴ��������޸ġ�ԭ������¼��һ�������ϣ������ͬ��֮ǰ�Ĵ���һ����
*/
--1.1��������������-������t_item���ϴ���
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
and ( t1.FType='����' or t1.FType='������-����')
) t9 on t8.FItemID=t9.FID

--1.2��������������t_icitemcore���ϴ���
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
and ( t1.FType='����' or t1.FType='������-����')
) t9 on t8.FItemID=t9.FID

--1.3���������׳ɱ�����-������t_item���ϴ���
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
and ( t1.FType='����' or t1.FType='������-����')
) t9 on t8.FNumber=t9.FNumber
where t8.FItemClassID=2001

--1.4���������׳ɱ�����cbCostObj���ϴ���
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
and ( t1.FType='����' or t1.FType='������-����')
) t9 on t8.FNumber=t9.FNumber



--2.����ͬ����־��¼�����ϴ���
update t1
set t1.FNumber=t2.FNumber
from t_HT_SyncControl  t1
left join (select * from [192.168.10.5].AIS20090210124856.dbo.t_item where fitemclassid=4) t2 on t1.foid=t2.Fitemid
where t1.FNumber<>t2.fnumber
and ISNULL(t2.FNumber,'')<>''
and ( t1.FType='����' or t1.FType='������-����')

set nocount off
end

--exec pro_HT_MaterialException