CREATE TRIGGER [dbo].[tr_ICClassCheckStatus1000021_Update] ON [dbo].ICClassCheckStatus1000021
    FOR INSERT, UPDATE
AS
    BEGIN
        UPDATE  a
        SET     FMultiCheckStatus = FMultiCheckStatus
        FROM    t_RP_ARPBill a ,
                inserted b
        WHERE   b.FBillID = a.FBillID
 
 
    END

GO

dbo.SpK3_2tab @sName = 'ICClassCheckStatus1000021' -- varchar(50)
