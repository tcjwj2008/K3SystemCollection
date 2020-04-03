select * from t_TableDescription where FDescription like '%客户%'
select * from t_FieldDescription where FTableID=49 order by FFieldName

INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
VALUES (1,0,1,'测试客户','023',
'023','023',1,'58352B02-0D8D-4EA5-ABAD-C7A79E5E85A4',0)


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
VALUES (NULL,NULL,NULL,1072,1023,
0,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,
1,1057,'17',0,0,
NULL,NULL,NULL,0,0,
0,0,0,0,0,
NULL,0,0,0,0,
0,0,0,NULL,0,
0,'2005-05-03 00:00:00','64435','2005-04-18 00:00:00','34800',
'0','1','1',0,0,
NULL,NULL,NULL,0,0,
'023','023','测试客户',0,39211)

 Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
 select fitemclassid,fuserid,39211 
 from t_useritemclassright 
 where (( FUserItemClassRight &  8)=8) and fitemclassid=1 and fuserid<>16394

 INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),16394,'A00701',5,'新建核算项目:023 核算项目类别:客户','WIN-5579AATH4RN','192.168.6.149')

 Insert Into t_BaseProperty
 (FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate,
  FLastModUser, FDeleteDate, FDeleteUser)
  Values(3, 39211, '2018-04-03 01:35:41', 'administrator', Null, Null, Null, Null)

  Delete from Access_t_Organization where FItemID=39211
 Insert into Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(39211,0,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 update t_Item set FName=FName where FItemID=39211 and FItemClassID=1

 UPDATE t_Organization SET FRegUserID=16394,FRegDate=GETDATE() WHERE FItemID=39211
UPDATE t1 SET t1.FRegDate = t2.FCreateDate FROM t_Organization t1 
INNER JOIN t_BaseProperty t2 ON t1.FItemID = t2.FItemID
WHERE t1.FItemID=39211 AND t2.FTypeID=3