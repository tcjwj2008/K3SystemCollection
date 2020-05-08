--付款条件看怎么同步？
alter procedure pro_HT_SupplierSync

as
begin
set nocount on
--1.更新供应商
--1.1找出（非禁用）供应商的辅助表数据,插入新帐套
select t1.FItemID,t1.FItemClassID,isnull(t4.FItemID,0) as FParentID,t1.FLevel,t1.FName,t1.FNumber,
t1.FShortNumber,t1.FFullNumber,t1.FDetail,t1.FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
left join (select * from AIS20121023172833.dbo.t_item where fitemclassid=8 and fdetail=0) t3 on t3.FItemID=t1.FParentID
left join (select * from t_item where fitemclassid=8 and fdetail=0) t4 on t3.FNumber=t4.FNumber
where (1=1)
and t1.fitemclassid=8 
and t1.FDetail=1
and t1.FDeleted=0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='辅助表-供应商')

--找出供应商主表
select t1.FItemID,t1.FHelpCode,t1.FShortName,t1.FAddress,t1.FStatus,t1.FRegionID,
t1.FTrade,t1.FContact,t1.FPhone,t1.FMobilePhone,t1.FFax,
t1.FPostalCode,t1.FEmail,t1.FBank,t1.FAccount,t1.FTaxNum,
t1.FValueAddRate,t1.FCountry,t1.FProvinceID,t1.FCityID,t1.Fcorperate,
t1.FDiscount,t1.FTypeID,t1.FPOMode,t1.FVMIStockID,t1.FStockIDAssignee,
t1.FBr,t1.FRegmark,t1.FLicence,t1.FCyID,t1.FSetID,
t1.FAPAccountID,t1.FPreAcctID,t1.FOtherAPAcctID,t1.FPayTaxAcctID,t1.FARAccountID,
t1.FPreARAcctID,t1.FOtherARAcctID,t1.FfavorPolicy,isnull(t3.FItemID,0) as Fdepartment,isnull(t5.FItemID,0) as Femployee,
t1.FlastTradeDate,t1.FlastTradeAmount,t1.FlastRPAmount,t1.FmaxDealAmount,t1.FminForeReceiveRate,
t1.FCreditDays,t1.FNameEN,t1.FAddrEn,t1.FCIQCode,t1.FRegion,
t1.FManageType,t1.FRegsterDate,t1.FAbateDate,t1.FSupplyGrade,FLastReceiveDate,
t1.FSupplyType,t1.FCompanyType,t1.FAutoCreateMR,t1.FAutoValidateOrderFlag,t1.FSupplierCoroutineFlag,
t1.FAPFrozenFlag,t1.FShortNumber,t1.FNumber,t1.FName
into #tmp1
from AIS20121023172833.dbo.t_Supplier t1
left join AIS20121023172833.dbo.t_Department t2 on t1.Fdepartment=t2.FItemID
left join t_Department t3 on t2.FNumber=t3.FNumber
left join AIS20121023172833.dbo.t_Emp t4 on t1.Femployee=t4.FItemID
left join t_Emp t5 on t4.FNumber=t5.FNumber
where t1.FDeleted=0

--逐条插入t_Item，一次性select插入报错
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
declare @FShortName varchar(100)
declare @FAddress varchar(200)
declare @FStatus bigint --状态,1072-使用,1073-未使用,1074-冻结
declare @FRegionID bigint  --区域代码
declare @FTrade bigint --行业代码 
declare @FContact varchar(100) --联系人
declare @FPhone varchar(50)
declare @FMobilePhone varchar(50)
declare @FFax varchar(50)  
declare @FPostalCode varchar(50) --邮编 
declare @FEmail varchar(50)  --邮箱
declare @FBank varchar(100) 
declare @FAccount varchar(100) --银行账号
declare @FTaxNum varchar(100) --税务登记号                                                                                                                                                                                                                                                          
declare @FValueAddRate decimal(21,2)  --增值税率 
declare @FCountry varchar(50)  --国家
declare @FProvinceID bigint
declare @FCityID bigint
declare @Fcorperate varchar(100) --法人代表
declare @FDiscount decimal(21,10)
declare @FTypeID bigint
declare @FPOMode bigint --采购模式 
declare @FVMIStockID bigint --VMI仓
declare @FStockIDAssignee bigint
declare @FBr bigint
declare @FRegmark varchar(100)
declare @FLicence varchar(100)
declare @FCyID bigint --结算币种
declare @FSetID bigint --结算方式 
declare @FAPAccountID bigint --应付账款科目代码  
declare @FPreAcctID bigint --预付账款科目代码
declare @FOtherAPAcctID bigint
declare @FPayTaxAcctID bigint --应交税金科目代码  
declare @FARAccountID bigint --应交税金科目代码  
declare @FPreARAcctID bigint 
declare @FOtherARAcctID bigint
declare @FfavorPolicy varchar(100) --优惠政策   
declare @Fdepartment bigint --分管部门 
declare @Femployee bigint --专营业务员 
declare @FlastTradeDate datetime --最后交易日期 
declare @FlastTradeAmount decimal(21,2) --最后交易金额 
declare @FlastRPAmount decimal(21,2) --最后付款金额  
declare @FmaxDealAmount decimal(21,2) --最大交易金额 
declare @FminForeReceiveRate decimal(21,2)  --最小预收比率(%)
declare @FCreditDays bigint --信用期限     
declare @FNameEN varchar(100) --英文名称  
declare @FAddrEn varchar(200) --英文地址   
declare @FCIQCode varchar(100) --海关注册码  
declare @FRegion bigint --国别地区 
declare @FManageType bigint --保税监管类型  
declare @FRegsterDate datetime
declare @FAbateDate datetime 
declare @FLastReceiveDate datetime --最后付款日期
declare @FSupplyGrade bigint
declare @FSupplyType bigint
declare @FCompanyType bigint
declare @FAutoCreateMR bigint
declare @FAutoValidateOrderFlag bigint
declare @FSupplierCoroutineFlag bigint --启用供应商协同
declare @FAPFrozenFlag bigint 
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
--插入辅助表-供应商
INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
select @FOItemClassID,@FNParentID,@FOLevel,@FOName,@FONumber,
@FOShortNumber,@FOFullNumber,@FODetail,newid() as UUID,@FODeleted

select @FNItemID=FItemID from t_item where FItemClassID=8  and FNumber=@FONumber

--供应商旧帐套取数
select @FHelpCode=FHelpCode,@FShortName=FShortName,@FAddress=FAddress,@FStatus=FStatus,@FRegionID=FRegionID,
@FTrade=FTrade,@FContact=FContact,@FPhone=FPhone,@FMobilePhone=FMobilePhone,@FFax=FFax,
@FPostalCode=FPostalCode,@FEmail=FEmail,@FBank=FBank,@FAccount=FAccount,@FTaxNum=FTaxNum,
@FValueAddRate=FValueAddRate,@FCountry=FCountry,@FProvinceID=FProvinceID,@FCityID=FCityID,@Fcorperate=Fcorperate,
@FDiscount=FDiscount,@FTypeID=FTypeID,@FPOMode=FPOMode,@FVMIStockID=FVMIStockID,@FStockIDAssignee=FStockIDAssignee,
@FBr=FBr,@FRegmark=FRegmark,@FLicence=FLicence,@FCyID=FCyID,@FSetID=FSetID,
@FAPAccountID=FAPAccountID,@FPreAcctID=FPreAcctID,@FOtherAPAcctID=FOtherAPAcctID,@FPayTaxAcctID=FPayTaxAcctID,@FARAccountID=FARAccountID,
@FPreARAcctID=FPreARAcctID,@FOtherARAcctID=FOtherARAcctID,@FfavorPolicy=FfavorPolicy,@Fdepartment=Fdepartment,@Femployee=Femployee,
@FlastTradeDate=FlastTradeDate,@FlastTradeAmount=FlastTradeAmount,@FlastRPAmount=FlastRPAmount,@FmaxDealAmount=FmaxDealAmount,@FminForeReceiveRate=FminForeReceiveRate,
@FCreditDays=FCreditDays,@FNameEN=FNameEN,@FAddrEn=FAddrEn,@FCIQCode=FCIQCode,@FRegion=FRegion,
@FManageType=FManageType,@FRegsterDate=FRegsterDate,@FAbateDate=FAbateDate,@FSupplyGrade=FSupplyGrade,@FLastReceiveDate=FLastReceiveDate,
@FSupplyType=FSupplyType,@FCompanyType=FCompanyType,@FAutoCreateMR=FAutoCreateMR,@FAutoValidateOrderFlag=FAutoValidateOrderFlag,@FSupplierCoroutineFlag=FSupplierCoroutineFlag,
@FAPFrozenFlag=FAPFrozenFlag,@FShortNumber=FShortNumber,@FNumber=FNumber,@FName=FName
from #tmp1 t1
where t1.FItemID=@FOItemID

--插入供应商主表
INSERT INTO t_Supplier 
(FHelpCode,FShortName,FAddress,FStatus,FRegionID,
FTrade,FContact,FPhone,FMobilePhone,FFax,
FPostalCode,FEmail,FBank,FAccount,FTaxNum,
FValueAddRate,FCountry,FProvinceID,FCityID,Fcorperate,
FDiscount,FTypeID,FPOMode,FVMIStockID,FStockIDAssignee,
FBr,FRegmark,FLicence,FCyID,FSetID,
FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,FARAccountID,
FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,
FlastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,FminForeReceiveRate,
FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,
FManageType,FRegsterDate,FAbateDate,FSupplyGrade,FLastReceiveDate,
FSupplyType,FCompanyType,FAutoCreateMR,FAutoValidateOrderFlag,FSupplierCoroutineFlag,
FAPFrozenFlag,FShortNumber,FNumber,FName,FParentID,FItemID) 
VALUES (@FHelpCode,@FShortName,@FAddress,@FStatus,@FRegionID,
@FTrade,@FContact,@FPhone,@FMobilePhone,@FFax,
@FPostalCode,@FEmail,@FBank,@FAccount,@FTaxNum,
@FValueAddRate,@FCountry,@FProvinceID,@FCityID,@Fcorperate,
@FDiscount,@FTypeID,@FPOMode,@FVMIStockID,@FStockIDAssignee,
@FBr,@FRegmark,@FLicence,@FCyID,@FSetID,
@FAPAccountID,@FPreAcctID,@FOtherAPAcctID,@FPayTaxAcctID,@FARAccountID,
@FPreARAcctID,@FOtherARAcctID,@FfavorPolicy,@Fdepartment,@Femployee,
@FlastTradeDate,@FlastTradeAmount,@FlastRPAmount,@FmaxDealAmount,@FminForeReceiveRate,
@FCreditDays,@FNameEN,@FAddrEn,@FCIQCode,@FRegion,
@FManageType,@FRegsterDate,@FAbateDate,@FSupplyGrade,@FLastReceiveDate,
@FSupplyType,@FCompanyType,@FAutoCreateMR,@FAutoValidateOrderFlag,@FSupplierCoroutineFlag,
@FAPFrozenFlag,@FShortNumber,@FNumber,@FName,@FNParentID,@FNItemID)

--同步记录表
--数据表t_item同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'辅助表-供应商',1,0,null,null,
@FOItemID,null,null,null

--数据表t_Supplier同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'供应商',1,0,null,null,
@FOItemID,null,null,null

Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
select fitemclassid,fuserid,@FNItemID 
from t_useritemclassright 
where (( FUserItemClassRight &  8)=8) and fitemclassid=8 and fuserid<>16394

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate,
FLastModUser, FDeleteDate, FDeleteUser)
Values(3, @FNItemID, getdate(), 'administrator', Null, Null, Null, Null)

Delete from Access_t_Supplier where FItemID=@FNItemID

Insert into Access_t_Supplier(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
Values(@FNItemID,@FNParentID,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

delete from  t_gr_itemcontrol where FItemID=@FNItemID and FItemClassID=8

insert into t_gr_itemcontrol(FFrameWorkID,FItemClassID,FItemID,FCanUse,FCanAdd,FCanModi,FCanDel)
select FFrameWorkID,FItemClassID,@FNItemID,FCanUse,FCanAdd,FCanModi,FCanDel
from t_gr_itemcontrol where FItemID=@FNParentID and FItemClassID=8

update t_Item set FName=FName where FItemID=@FNItemID and FItemClassID=8

fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
end 
close mycursor 
DEALLOCATE mycursor

drop table #tmp0
drop table #tmp1

set nocount off
end 

--exec pro_HT_SupplierSync

--select * from t_Supplier
--select * from t_item where fitemclassid=8 and fdetail=1

--delete from t_Supplier
--delete from t_item where fitemclassid=8 and fdetail=1
--delete from t_HT_SyncControl where FType='辅助表-供应商'
--delete from t_HT_SyncControl where FType='供应商'