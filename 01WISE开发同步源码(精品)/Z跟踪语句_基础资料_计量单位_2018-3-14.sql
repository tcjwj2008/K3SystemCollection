Select * from t_UnitGroup Where FName = '999'

SELECT FMeasureUnitID FROM t_MeasureUnit WHERE FUnitGroupID=217 AND FName='Вс'

INSERT INTO t_MeasureUnit 
(FName,FNumber,FAuxClass,FCoefficient,FConversation,
FNameEn,FNameEnPlu,FUnitGroupID,FPrecision,FShortNumber,FParentID) 
VALUES
 ('Вс','999',' ',1,1,
 NULL,NULL,217,0,'999',217)

 Insert Into t_Item
(FItemID,FItemClassID,FDetail,FLevel,FParentID,
FNumber,FName,FShortNumber,FFullNumber,FDeleted) 
Values
(2610,7,1,2,217,
'999','Вс','999','999',0)

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, 
FLastModUser, FDeleteDate, FDeleteUser)
Values
(7, 2610, '2018-03-14 18:38:04', 'administrator', Null,
 Null, Null, Null)