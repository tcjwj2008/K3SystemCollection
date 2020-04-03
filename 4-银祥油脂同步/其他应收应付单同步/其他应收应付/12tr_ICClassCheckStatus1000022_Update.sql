CREATE TRIGGER [dbo].[tr_ICClassCheckStatus1000022_Update] ON [dbo].ICClassCheckStatus1000022
   FOR INSERT,UPDATE 
AS 
BEGIN
  UPDATE a SET FMultiCheckStatus=FMultiCheckStatus FROM 
  t_RP_ARPBill a,inserted b WHERE   b.FBillID=a.FBillID
 
 
END

GO
