select * from t_TableDescription where FDescription like '%价格%'
select * from t_TableDescription where ftablename = 'ICDisPlyEntry'
select * from t_TableDescription where ftablename = 'ICPrcPlyEntry                                                                   '
select * from t_FieldDescription where FTableID=230036


--价格政策方案 或 价格政策表头
select FInterID
From
IcPrcPly
Where  FPlyType='PrcAsm1' And FPri=0 And FInterID<>'2'

INSERT INTO IcPrcPlyEntry
(FIndex,FItemID,FRelatedID,FAuxPropID,FInterID,
FUnitID,FBegQty,FEndQty,FCuryID,FPriceType,
FPrice,FBegDate,FEndDate,FLeadTime,FMainterID,
FMaintDate,FNote,FCheckerID,FCheckDate,Fchecked,FFlagSave) 
Values
(1,39414,42797,0,2,
39275,1,100,1,20004,
100,'2018-05-02','2100-01-01',5,16394,
'2018-05-02','备注字段',16394,'2018-05-02',0,'{432EA0D1-00BB-419C-B058-1C415CB26A0E}')

Update IcPrcPlyEntry Set FChecked=1 Where FFlagSave='{432EA0D1-00BB-419C-B058-1C415CB26A0E}'
                                                                        

