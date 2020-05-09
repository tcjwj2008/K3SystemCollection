alter procedure pro_HT_EmpSync
as
begin
set nocount on
--1.����ְԱ
--1.1�ҳ����ǽ��ã�ְԱ�ĸ���������,����������
select t1.FItemID,t1.FItemClassID,isnull(t4.FItemID,0) as FParentID,t1.FLevel,t1.FName,t1.FNumber,
t1.FShortNumber,t1.FFullNumber,t1.FDetail,t1.FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
left join (select * from AIS20121023172833.dbo.t_item where fitemclassid=3 and fdetail=0) t3 on t3.FItemID=t1.FParentID
left join (select * from t_item where fitemclassid=3 and fdetail=0) t4 on t3.FNumber=t4.FNumber
where (1=1)
and t1.fitemclassid=3 
and t1.FDetail=1
and t1.FDeleted=0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='������-ְԱ')

--�ҳ�ְԱ����
select t1.FItemID,t1.FEmpGroup,t3.FItemID as FDepartmentID,t1.FGender,t1.FDegree,t1.FPhone,
t1.FMobilePhone,t1.FID,t1.FDuty,t1.FAccountName,t1.FPersonalBank,
t1.FBankAccount,t1.FProvinceID,t1.FCityID,t1.FAddress,t1.FEmail,
t1.FNote,t1.FIsCreditMgr,t1.FProfessionalGroup,t1.FJobTypeID,t1.FAllotPercent,
t1.FOperationGroup,t1.FOtherARAcctID,t1.FPreARAcctID,t1.FOtherAPAcctID,t1.FPreAPAcctID,
t1.FAllotWeight,t1.FShortNumber,t1.FNumber,t1.FName
into #tmp1
from AIS20121023172833.dbo.t_Emp t1 
left join AIS20121023172833.dbo.t_Department t2 on t1.FDepartmentID=t2.FItemID
left join t_Department t3 on t2.FNumber=t3.FNumber
where t1.FDeleted=0

--��������t_Item��һ����select���뱨��
declare @FOItemClassID bigint
declare @FOParentID bigint 
declare @FOLevel bigint
declare @FOName varchar(100)
declare @FONumber varchar(100)
declare @FOShortNumber varchar(100)
declare @FOFullNumber varchar(100)
declare @FODetail bigint 
declare @FODeleted bigint
declare @FOItemID bigint
declare @FNItemID bigint
declare @FNParentID bigint 
declare @FNEmpGroup bigint --ְԱ������                                                                                                                                                                                                                                                          
declare @FNDepartmentID bigint --��������                                                                                                                                                                                                                                                           
declare @FNGender bigint --�Ա�                                                                                                                                                                                                                                                             
declare @FNDegree bigint --�Ļ��̶�                                                                                                                                                                                                                                                           
declare @FNPhone varchar(50) --�绰                                                                                                                                                                                                                                                             
declare @FNMobilePhone varchar(50) --�ֻ�����                                                                                                                                                                                                                                                           
declare @FNID varchar(50) --���֤����                                                                                                                                                                                                                                                          
declare @FNDuty bigint --ְ��                                                                                                                                                                                                                                                             
declare @FNAccountName varchar(100)
declare @FNPersonalBank varchar(100)
declare @FNBankAccount varchar(100)
declare @FNProvinceID bigint
declare @FNCityID bigint
declare @FNAddress varchar(200)
declare @FNEmail varchar(100)
declare @FNNote varchar(500)
declare @FNIsCreditMgr bigint --�Ƿ�������ù���                                                                                                                                                                                                                                                       
declare @FNProfessionalGroup bigint --����                                                                                                                                                                                                                                                            
declare @FNJobTypeID bigint --����                                                                                                                                                                                                                                                             
declare @FNAllotPercent float --������                                                                                                                                                                                                                                                            
declare @FNOperationGroup bigint --ҵ����                                                                                                                                                                                                                                                            
declare @FNOtherARAcctID bigint --����Ӧ���˿��Ŀ����                                                                                                                                                                                                                                                     
declare @FNPreARAcctID bigint --Ԥ���˿��Ŀ����                                                                                                                                                                                                                                                       
declare @FNOtherAPAcctID bigint --����Ӧ���˿��Ŀ����                                                                                                                                                                                                                                                     
declare @FNPreAPAcctID bigint --Ԥ���˿��Ŀ����                                                                                                                                                                                                                                                       
declare @FNAllotWeight varchar(50)
declare @FNShortNumber varchar(50)
declare @FNNumber varchar(50)
declare @FNName varchar(50)
declare mycursor cursor for 
select FItemID,FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
from #tmp0 
open mycursor  
fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
while (@@fetch_status=0) 
begin 
--���븨����-ְԱ
INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
select @FOItemClassID,@FNParentID,@FOLevel,@FOName,@FONumber,
@FOShortNumber,@FOFullNumber,@FODetail,newid() as UUID,@FODeleted

select @FNItemID=FItemID from t_item where FItemClassID=3  and FNumber=@FONumber

--ְԱ������ȡ��
select @FNEmpGroup=FEmpGroup,@FNDepartmentID=FDepartmentID,@FNGender=FGender,@FNDegree=FDegree,@FNPhone=FPhone,
@FNMobilePhone=FMobilePhone,@FNID=FID,@FNDuty=FDuty,@FNAccountName=FAccountName,@FNPersonalBank=FPersonalBank,
@FNBankAccount=FBankAccount,@FNProvinceID=FProvinceID,@FNCityID=FCityID,@FNAddress=FAddress,@FNEmail=FEmail,
@FNNote=FNote,@FNIsCreditMgr=FIsCreditMgr,@FNProfessionalGroup=FProfessionalGroup,@FNJobTypeID=FJobTypeID,@FNAllotPercent=FAllotPercent,
@FNOperationGroup=FOperationGroup,@FNOtherARAcctID=FOtherARAcctID,@FNPreARAcctID=FPreARAcctID,@FNOtherAPAcctID=FOtherAPAcctID,@FNPreAPAcctID=FPreAPAcctID,
@FNAllotWeight=FAllotWeight,@FNShortNumber=FShortNumber,@FNNumber=FNumber,@FNName=FName
from #tmp1 t1
where t1.FItemID=@FOItemID

--����ְԱ����
--FJobTypeID�ݲ���ͬ��
--FProfessionalGroup�ݲ���ͬ��
--FOperationGroup�ݲ���ͬ��
INSERT INTO t_Emp 
(FEmpGroup,FDepartmentID,FGender,FDegree,FPhone,
FMobilePhone,FID,FDuty,FAccountName,FPersonalBank,
FBankAccount,FProvinceID,FCityID,FAddress,FEmail,
FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,FAllotPercent,
FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,
FAllotWeight,FShortNumber,FNumber,FName,FParentID,FItemID) 
VALUES (@FNEmpGroup,@FNDepartmentID,@FNGender,@FNDegree,@FNPhone,
@FNMobilePhone,@FNID,@FNDuty,@FNAccountName,@FNPersonalBank,
@FNBankAccount,@FNProvinceID,@FNCityID,@FNAddress,@FNEmail,
@FNNote,@FNIsCreditMgr,@FNProfessionalGroup,@FNJobTypeID,@FNAllotPercent,
@FNOperationGroup,@FNOtherARAcctID,@FNPreARAcctID,@FNOtherAPAcctID,@FNPreAPAcctID,
@FNAllotWeight,@FNShortNumber,@FNNumber,@FNName,@FNParentID,@FNItemID) 

--ͬ����¼��
--���ݱ�t_itemͬ����¼�Ǽ�
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'������-ְԱ',1,0,null,null,
@FOItemID,null,null,null

--���ݱ�t_Empͬ����¼�Ǽ�
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'ְԱ',1,0,null,null,
@FOItemID,null,null,null

Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
select fitemclassid,fuserid,@FNItemID 
from t_useritemclassright 
where (( FUserItemClassRight &  8)=8) and fitemclassid=3 and fuserid<>16394

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, 
FLastModUser, FDeleteDate, FDeleteUser)
Values(3, @FNItemID, getdate(),  'administrator',Null, Null, Null, Null)

Delete from Access_t_Emp where FItemID=@FNItemID

Insert into Access_t_Emp(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
Values(@FNItemID,@FNParentID,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

update t_Item set FName=FName where FItemID=@FNItemID and FItemClassID=3

fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
end 
close mycursor 
DEALLOCATE mycursor

drop table #tmp0
drop table #tmp1
set nocount off
end 

--exec pro_HT_EmpSync

--select * from t_Emp
--select * from t_item where fitemclassid=3 and fdetail=1

--delete from t_Emp
--delete from t_item where fitemclassid=3 and fdetail=1
--delete from t_HT_SyncControl where FType='������-ְԱ'
--delete from t_HT_SyncControl where FType='ְԱ'
