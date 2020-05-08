CREATE TRIGGER [dbo].[tr_ICClassCheckStatus1000016_Update] ON [dbo].[ICClassCheckStatus1000016]
   FOR INSERT,UPDATE 
AS 
BEGIN
  UPDATE a SET FMultiCheckStatus=FMultiCheckStatus FROM 
  t_RP_NewReceiveBill a,inserted b WHERE   b.FBillID=a.FBillID
 
 
END

GO
 