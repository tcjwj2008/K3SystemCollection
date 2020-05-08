alter procedure pro_HT_UnitGroupSync
as
begin
set nocount on
--1.���¼�����λ���
--1.1�ҳ�������λ�ķ������ݣ��ǽ��ã�,����������
--����ͬ����¼��Ǽǵļ�¼�������ظ�д��
select FItemID,FName,FNumber,FItemClassID,FLevel,FParentID,
 FDetail,FFullNumber,FShortNumber,FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
where (1=1)
and t1.fitemclassid=7 
and t1.FDetail=0
and t1.FDeleted=0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='������-������λ���')

--��������t_Item��һ����select���뱨��
declare @FOName varchar(100)
declare @FONumber varchar(100)
declare @FOItemClassID bigint
declare @FOLevel bigint
declare @FOParentID bigint 
declare @FODetail bigint 
declare @FOFullNumber varchar(100)
declare @FOShortNumber varchar(100)
declare @FODeleted bigint
declare @FOItemID bigint
declare @FNItemID bigint
declare mycursor cursor for 
select FItemID,FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
from #tmp0 
open mycursor  
fetch next from mycursor into @FOItemID,@FOItemClassID,@FOParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
while (@@fetch_status=0) 
begin 

--���������λ���
INSERT INTO t_Item
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
select @FOItemClassID,@FOParentID,@FOLevel,@FOName,@FONumber,
@FOShortNumber,@FOFullNumber,@FODetail,newid() as UUID,@FODeleted

select @FNItemID=FItemID from t_item where FItemClassID=7 and FNumber=@FONumber

INSERT INTO t_UnitGroup (FUnitGroupID,FName) VALUES (@FNItemID,@FOName)

--ͬ����¼��
--���ݱ�t_itemͬ����¼�Ǽ�
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'������-������λ���',1,0,null,null,
@FOItemID,null,null,null

--���ݱ�t_UnitGroupͬ����¼�Ǽ�
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'������λ���',1,0,null,null,
@FOItemID,null,null,null


Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate,
FLastModUser, FDeleteDate, FDeleteUser)
Values
(12, @FNItemID, getdate(), 'administrator', Null, 
Null, Null, Null)

fetch next from mycursor into @FOItemID,@FOItemClassID,@FOParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
end 
close mycursor 
DEALLOCATE mycursor 

drop table #tmp0
set nocount off
end

--exec pro_HT_UnitGroupSync

--delete from t_item where fitemclassid=7 and fdetail=0


--select * from t_item where fitemclassid=7
--select * from t_UnitGroup
--select * from t_MeasureUnit
--select * from t_HT_SyncControl

--delete from t_UnitGroup
--delete from t_item where fitemclassid=7 and fdetail=0
--delete from t_HT_SyncControl where FType='������-������λ���'
--delete from t_HT_SyncControl where FType='������λ���'