

INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
VALUES (3,0,1,'销售部','001',
'001','001',0,'3B4ACEE5-E9E7-40CC-A74D-500A79FD69CA',0)

 Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
 select fitemclassid,fuserid,35639 
 from t_useritemclassright 
 where (( FUserItemClassRight &  8)=8) and fitemclassid=3 and fuserid<>16394

 INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),16394,'A00701',5,'新建核算项目:001 核算项目类别:职员','WIN-5579AATH4RN','192.168.6.149')

 Insert Into t_BaseProperty
 (FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, 
 FLastModUser, FDeleteDate, FDeleteUser)
 Values(3, 35639, '2018-04-02 16:24:47', 'administrator', Null, Null, Null, Null)

 Delete from Access_t_Emp where FItemID=35639
 Insert into Access_t_Emp(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(35639,0,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 update t_Item set FName=FName where FItemID=35639 and FItemClassID=3