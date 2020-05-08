Select 1 from t_item where FNumber =  '测试组' And FItemClassID = 7
INSERT INTO t_Item
 (
 FName,FNumber,FItemClassID,FLevel,FParentID,
 FDetail,FFullNumber,FShortNumber) 
 VALUES 
 ('测试组','测试组',7,1,0,
 0,'测试组','测试组')

SELECT FUnitGroupID FROM t_UnitGroup WHERE FName='测试组'


INSERT INTO t_UnitGroup (FUnitGroupID,FName) VALUES (35044,'测试组')

Select * from t_BaseProperty Where FTypeID = 12 And FItemID = 35044

 Select * from t_BaseProperty WHERE 1=2 

 Insert Into t_BaseProperty
 (FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate,
  FLastModUser, FDeleteDate, FDeleteUser)
  Values
  (12, 35044, '2018-03-14 01:41:21', 'administrator', Null, 
  Null, Null, Null)

  INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress)
   VALUES (getdate(),16394,'A00701',5,'新建计量单位组:测试组','WIN-5579AATH4RN','192.168.6.149')


   SELECT FID,FTYPEID,FITEMID,FBarcode,FRemark FROM t_Barcode Where FTypeID =0 order by FBarCode ASC