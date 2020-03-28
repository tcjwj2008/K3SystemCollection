select * from t_TableDescription where FDescription like '%职员%'
select * from t_FieldDescription where FTableID=19

INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
VALUES (3,0,1,'测试','097',
'097','097',1,'647BC1A8-D989-4492-B5BF-BA2C26F9DC95',0)

INSERT INTO t_Emp 
(FEmpGroup,FDepartmentID,FGender,FDegree,FPhone,
FMobilePhone,FID,FDuty,FAccountName,FPersonalBank,
FBankAccount,FProvinceID,FCityID,FAddress,FEmail,
FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,FAllotPercent,
FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,
FAllotWeight,FShortNumber,FNumber,FName,FParentID,FItemID) 
VALUES (0,0,1069,0,'0755-26975792',
NULL,NULL,0,NULL,NULL,
NULL,0,0,NULL,NULL,
NULL,0,0,0,'0',
0,0,0,0,0,
'30','097','097','测试',0,35638)

 Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
 select fitemclassid,fuserid,35638 
 from t_useritemclassright 
 where (( FUserItemClassRight &  8)=8) and fitemclassid=3 and fuserid<>16394

INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) 
VALUES (getdate(),16394,'A00701',5,'新建核算项目:097 核算项目类别:职员','WIN-5579AATH4RN','192.168.6.149')

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, 
FLastModUser, FDeleteDate, FDeleteUser)
Values(3, 35638, '2018-04-02 16:03:14', 'administrator', Null, Null, Null, Null)

Delete from Access_t_Emp where FItemID=35638
 Insert into Access_t_Emp(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(35638,0,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 update t_Item set FName=FName where FItemID=35638 and FItemClassID=3