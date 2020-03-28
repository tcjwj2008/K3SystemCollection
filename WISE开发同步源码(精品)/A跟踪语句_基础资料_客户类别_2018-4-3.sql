INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
VALUES (1,0,1,'测试','3',
'3','3',0,'E35A52EC-3D2D-4DBE-9C25-B3A05CEE57E7',0)

 Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
 select fitemclassid,fuserid,39210 
 from t_useritemclassright 
 where (( FUserItemClassRight &  8)=8) and fitemclassid=1 and fuserid<>16394

 INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),16394,'A00701',5,'新建核算项目:3 核算项目类别:客户','WIN-5579AATH4RN','192.168.6.149')

 Insert Into t_BaseProperty
 (FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, 
 FLastModUser, FDeleteDate, FDeleteUser)
 Values(3, 39210, '2018-04-03 01:13:15', 'administrator', Null, Null, Null, Null)

 Delete from Access_t_Organization where FItemID=39210
 Insert into Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(39210,0,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 update t_Item set FName=FName where FItemID=39210 and FItemClassID=1

 UPDATE t_Organization SET FRegUserID=16394,FRegDate=GETDATE() WHERE FItemID=39210
UPDATE t1 SET t1.FRegDate = t2.FCreateDate FROM t_Organization t1 
INNER JOIN t_BaseProperty t2 ON t1.FItemID = t2.FItemID
WHERE t1.FItemID=39210 AND t2.FTypeID=3