alter procedure pro_HT_CustSync

as
begin
set nocount on
--1.���¿ͻ�
--1.1�ҳ����ǽ��ã��ͻ��ĸ���������,����������
select t1.FItemID,t1.FItemClassID,isnull(t4.FItemID,0) as FParentID,t1.FLevel,t1.FName,t1.FNumber,
t1.FShortNumber,t1.FFullNumber,t1.FDetail,t1.FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
left join (select * from AIS20121023172833.dbo.t_item where fitemclassid=1 and fdetail=0) t3 on t3.FItemID=t1.FParentID
left join (select * from t_item where fitemclassid=1 and fdetail=0) t4 on t3.FNumber=t4.FNumber
where (1=1)
and t1.fitemclassid=1 
and t1.FDetail=1
and t1.FDeleted=0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='������-�ͻ�')

--�ҳ��ͻ�����
select t1.FItemID,t1.FHelpCode,t1.FShortName,t1.FAddress,t1.FStatus,t1.FRegionID,
t1.FTrade,t1.FContact,t1.FPhone,t1.FMobilePhone,t1.FFax,
t1.FPostalCode,t1.FEmail,t1.FBank,t1.FAccount,t1.FTaxNum,
t1.FIsCreditMgr,t1.FSaleMode,t1.FValueAddRate,t1.FProvinceID,t1.FCityID,
t1.FCountry,t1.FHomePage,t1.Fcorperate,t1.FCarryingAOS,t1.FTypeID,
t1.FSaleID,t1.FStockIDKeep,t1.FCoSupplierID,t1.FCyID,t1.FSetID,
t1.FCIQNumber,t1.FARAccountID,t1.FPreAcctID,t1.FOtherARAcctID,t1.FPayTaxAcctID,
t1.FAPAccountID,t1.FPreAPAcctID,t1.FOtherAPAcctID,t1.FfavorPolicy,isnull(t3.FItemID,0) as Fdepartment,
isnull(t5.FItemID,0) as Femployee,t1.FlastTradeDate,t1.FlastTradeAmount,t1.FlastReceiveDate,t1.FlastRPAmount,
t1.FmaxDealAmount,t1.FminForeReceiveRate,t1.FminReserverate,t1.FdebtLevel,t1.FPayCondition,
t1.FNameEN,t1.FAddrEn,t1.FCIQCode,t1.FRegion,t1.FManageType,
t1.FShortNumber,t1.FNumber,t1.FName
into #tmp1
from AIS20121023172833.dbo.t_Organization t1
left join AIS20121023172833.dbo.t_Department t2 on t1.Fdepartment=t2.FItemID
left join t_Department t3 on t2.FNumber=t3.FNumber
left join AIS20121023172833.dbo.t_Emp t4 on t1.Femployee=t4.FItemID
left join t_Emp t5 on t4.FNumber=t5.FNumber
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
declare @FHelpCode varchar(100) 
declare @FShortName varchar(100) --�ͻ����                                                                                                                                                                                                                                                           
declare @FAddress varchar(200) --��ַ                                                                                                                                                                                                                                                             
declare @FStatus bigint --״̬                                                                                                                                                                                                                                                             
declare @FRegionID bigint --�������                                                                                                                                                                                                                                                           
declare @FTrade bigint --��ҵ����                                                                                                                                                                                                                                                           
declare @FContact varchar(100) --��ϵ��                                                                                                                                                                                                                                                            
declare @FPhone varchar(100) --�绰����                                                                                                                                                                                                                                                           
declare @FMobilePhone varchar(100) --�ֻ�����
declare @FFax varchar(100) --�����                                                                                                                                                                                                                                                            
declare @FPostalCode varchar(100)  --�ʱ�                                                                                                                                                                                                                                                             
declare @FEmail varchar(100)
declare @FBank varchar(100) --��������                                                                                                                                                                                                                                                           
declare @FAccount varchar(100) --�����˺�                                                                                                                                                                                                                                                           
declare @FTaxNum varchar(100) --˰��ǼǺ�                                                                                                                                                                                                                                                          
declare @FIsCreditMgr bigint --�Ƿ�������ù���                                                                                                                                                                                                                                                       
declare @FSaleMode bigint --����ģʽ                                                                                                                                                                                                                                                           
declare @FValueAddRate decimal(21,2) --��ֵ˰��                                                                                                                                                                                                                                                           
declare @FProvinceID bigint
declare @FCityID bigint
declare @FCountry varchar(100) --����                                                                                                                                                                                                                                                             
declare @FHomePage varchar(100) --��˾��ҳ                                                                                                                                                                                                                                                           
declare @Fcorperate varchar(100) --���˴���                                                                                                                                                                                                                                                           
declare @FCarryingAOS bigint
declare @FTypeID bigint
declare @FSaleID bigint
declare @FStockIDKeep bigint
declare @FCoSupplierID bigint  --��Ӧ��Ӧ��                                                                                                                                                                                                                                                          
declare @FCyID bigint  --�������                                                                                                                                                                                                                                                           
declare @FSetID bigint --���㷽ʽ                                                                                                                                                                                                                                                           
declare @FCIQNumber varchar(100) --���ش���                                                                                                                                                                                                                                                           
declare @FARAccountID bigint --Ӧ���˿��Ŀ����                                                                                                                                                                                                                                                       
declare @FPreAcctID bigint --Ԥ���˿��Ŀ����                                                                                                                                                                                                                                                       
declare @FOtherARAcctID bigint
declare @FPayTaxAcctID bigint --Ӧ��˰���Ŀ����                                                                                                                                                                                                                                                       
declare @FAPAccountID bigint
declare @FPreAPAcctID bigint
declare @FOtherAPAcctID bigint
declare @FfavorPolicy varchar(100) --�Ż�����                                                                                                                                                                                                                                                           
declare @Fdepartment bigint --�ֹܲ���                                                                                                                                                                                                                                                           
declare @Femployee bigint --רӪҵ��Ա                                                                                                                                                                                                                                                          
declare @FlastTradeDate datetime --���������                                                                                                                                                                                                                                                         
declare @FlastTradeAmount decimal(21,2)
declare @FlastReceiveDate datetime --����տ�����                                                                                                                                                                                                                                                         
declare @FlastRPAmount decimal(21,2) --����տ���                                                                                                                                                                                                                                                         
declare @FmaxDealAmount decimal(21,2) --����׽��                                                                                                                                                                                                                                                         
declare @FminForeReceiveRate decimal(21,2)  --��СԤ�ձ���(%)                                                                                                                                                                                                                                                      
declare @FminReserverate decimal(21,2) --��С�������(%)                                                                                                                                                                                                                                                      
declare @FdebtLevel bigint --��ծ�ȼ�                                                                                                                                                                                                                                                           
declare @FPayCondition bigint --�տ�����                                                                                                                                                                                                                                                           
declare @FNameEN varchar(100) --Ӣ������                                                                                                                                                                                                                                                           
declare @FAddrEn varchar(100) --Ӣ�ĵ�ַ                                                                                                                                                                                                                                                           
declare @FCIQCode varchar(100) --����ע����                                                                                                                                                                                                                                                          
declare @FRegion varchar(100) --�������                                                                                                                                                                                                                                                           
declare @FManageType bigint --��˰�������                                                                                                                                                                                                                                                         
declare @FShortNumber varchar(50)
declare @FNumber varchar(50)
declare @FName varchar(50)
declare mycursor cursor for 
select FItemID,FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
from #tmp0 
open mycursor  
fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
while (@@fetch_status=0) 
begin 
--���븨����-�ͻ�
INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
select @FOItemClassID,@FNParentID,@FOLevel,@FOName,@FONumber,
@FOShortNumber,@FOFullNumber,@FODetail,newid() as UUID,@FODeleted

select @FNItemID=FItemID from t_item where FItemClassID=1  and FNumber=@FONumber

--���ž�����ȡ��
select @FHelpCode=FHelpCode,@FShortName=FShortName,@FAddress=FAddress,@FStatus=FStatus,@FRegionID=FRegionID,
@FTrade=FTrade,@FContact=FContact,@FPhone=FPhone,@FMobilePhone=FMobilePhone,@FFax=FFax,
@FPostalCode=FPostalCode,@FEmail=FEmail,@FBank=FBank,@FAccount=FAccount,@FTaxNum=FTaxNum,
@FIsCreditMgr=FIsCreditMgr,@FSaleMode=FSaleMode,@FValueAddRate=FValueAddRate,@FProvinceID=FProvinceID,@FCityID=FCityID,
@FCountry=FCountry,@FHomePage=FHomePage,@Fcorperate=Fcorperate,@FCarryingAOS=FCarryingAOS,@FTypeID=FTypeID,
@FSaleID=FSaleID,@FStockIDKeep=FStockIDKeep,@FCoSupplierID=FCoSupplierID,@FCyID=FCyID,@FSetID=FSetID,
@FCIQNumber=FCIQNumber,@FARAccountID=FARAccountID,@FPreAcctID=FPreAcctID,@FOtherARAcctID=FOtherARAcctID,@FPayTaxAcctID=FPayTaxAcctID,
@FAPAccountID=FAPAccountID,@FPreAPAcctID=FPreAPAcctID,@FOtherAPAcctID=FOtherAPAcctID,@FfavorPolicy=FfavorPolicy,@Fdepartment=Fdepartment,
@Femployee=Femployee,@FlastTradeDate=FlastTradeDate,@FlastTradeAmount=FlastTradeAmount,@FlastReceiveDate=FlastReceiveDate,@FlastRPAmount=FlastRPAmount,
@FmaxDealAmount=FmaxDealAmount,@FminForeReceiveRate=FminForeReceiveRate,@FminReserverate=FminReserverate,@FdebtLevel=FdebtLevel,@FPayCondition=FPayCondition,
@FNameEN=FNameEN,@FAddrEn=FAddrEn,@FCIQCode=FCIQCode,@FRegion=FRegion,@FManageType=FManageType,
@FShortNumber=FShortNumber,@FNumber=FNumber,@FName=FName
from #tmp1 t1
where t1.FItemID=@FOItemID

--���벿������
INSERT INTO t_Organization 
(FHelpCode,FShortName,FAddress,FStatus,FRegionID,
FTrade,FContact,FPhone,FMobilePhone,FFax,
FPostalCode,FEmail,FBank,FAccount,FTaxNum,
FIsCreditMgr,FSaleMode,FValueAddRate,FProvinceID,FCityID,
FCountry,FHomePage,Fcorperate,FCarryingAOS,FTypeID,
FSaleID,FStockIDKeep,FCoSupplierID,FCyID,FSetID,
FCIQNumber,FARAccountID,FPreAcctID,FOtherARAcctID,FPayTaxAcctID,
FAPAccountID,FPreAPAcctID,FOtherAPAcctID,FfavorPolicy,Fdepartment,
Femployee,FlastTradeDate,FlastTradeAmount,FlastReceiveDate,FlastRPAmount,
FmaxDealAmount,FminForeReceiveRate,FminReserverate,FdebtLevel,FPayCondition,
FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,
FShortNumber,FNumber,FName,FParentID,FItemID) 
VALUES (@FHelpCode,@FShortName,@FAddress,@FStatus,@FRegionID,
@FTrade,@FContact,@FPhone,@FMobilePhone,@FFax,
@FPostalCode,@FEmail,@FBank,@FAccount,@FTaxNum,
@FIsCreditMgr,@FSaleMode,@FValueAddRate,@FProvinceID,@FCityID,
@FCountry,@FHomePage,@Fcorperate,@FCarryingAOS,@FTypeID,
@FSaleID,@FStockIDKeep,@FCoSupplierID,@FCyID,@FSetID,
@FCIQNumber,@FARAccountID,@FPreAcctID,@FOtherARAcctID,@FPayTaxAcctID,
@FAPAccountID,@FPreAPAcctID,@FOtherAPAcctID,@FfavorPolicy,@Fdepartment,
@Femployee,@FlastTradeDate,@FlastTradeAmount,@FlastReceiveDate,@FlastRPAmount,
@FmaxDealAmount,@FminForeReceiveRate,@FminReserverate,@FdebtLevel,@FPayCondition,
@FNameEN,@FAddrEn,@FCIQCode,@FRegion,@FManageType,
@FShortNumber,@FNumber,@FName,@FNParentID,@FNItemID)

--ͬ����¼��
--���ݱ�t_itemͬ����¼�Ǽ�
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'������-�ͻ�',1,0,null,null,
@FOItemID,null,null,null

--���ݱ�t_UnitGroupͬ����¼�Ǽ�
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'�ͻ�',1,0,null,null,
@FOItemID,null,null,null

Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
select fitemclassid,fuserid,@FNItemID 
from t_useritemclassright 
where (( FUserItemClassRight &  8)=8) and fitemclassid=1 and fuserid<>16394

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate,
FLastModUser, FDeleteDate, FDeleteUser)
Values(3, @FNItemID, getdate(), 'administrator', Null, Null, Null, Null)

Delete from Access_t_Organization where FItemID=@FNItemID

Insert into Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
Values(@FNItemID,@FNParentID,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

update t_Item set FName=FName where FItemID=@FNItemID and FItemClassID=1

UPDATE t_Organization SET FRegUserID=16394,FRegDate=GETDATE() WHERE FItemID=@FNItemID

UPDATE t1 SET t1.FRegDate = t2.FCreateDate FROM t_Organization t1 
INNER JOIN t_BaseProperty t2 ON t1.FItemID = t2.FItemID
WHERE t1.FItemID=@FNItemID AND t2.FTypeID=3

fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
end 
close mycursor 
DEALLOCATE mycursor

drop table #tmp0
drop table #tmp1

set nocount off
end 

--exec pro_HT_CustSync

--select * from t_Organization
--select * from t_item where fitemclassid=1 and fdetail=1

--delete from t_Organization
--delete from t_item where fitemclassid=1 and fdetail=1
--delete from t_HT_SyncControl where FType='������-�ͻ�'
--delete from t_HT_SyncControl where FType='�ͻ�'