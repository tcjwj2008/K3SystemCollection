CREATE TRIGGER [dbo].[tr_ICClassCheckStatus1000005_Update] ON [dbo].[ICClassCheckStatus1000005]
   FOR INSERT,UPDATE 
AS 
BEGIN
  UPDATE a SET FMultiCheckStatus=FMultiCheckStatus FROM 
  t_RP_NewReceiveBill a,inserted b WHERE   b.FBillID=a.FBillID
 
 
END

GO

alter table t_RP_NewReceiveBill add FMultiCheckStatus int

go