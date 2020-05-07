 
 select * from ICCreditBill where FSource=0 and FID=78

GO
dbo.SpK3_2tab @sName = 't_BillCodeRule' -- varchar(50)
dbo.SpK3_2tab @sName = 't_RP_Plan_Ar' -- varchar(50)
dbo.SpK3_2tab @sName = 't_RP_Contact' -- varchar(50)
dbo.SpK3_2tab @sName = 't_RP_ARPBill' -- varchar(50)
GO

SELECT * FROM t_RP_ARPBill WHERE FNumber='QTYS000047'

SELECT * FROM t_rp_arpbillEntry WHERE FBillID=1183


SELECT * FROM t_RP_Plan_Ar WHERE FInterID=1183

 
 
 

 
 
 DELETE FROM t_RP_Plan_Ar
 WHERE  FOrgID = ( SELECT   FID
                   FROM     t_RP_Contact
                   WHERE    FRPBillID = 1183
                 );
 DELETE FROM t_rp_arpbillEntry
 WHERE  FBillID = 1183;
 DELETE FROM t_RP_ARPBill
 WHERE  FBillID = 1183;
 DELETE FROM t_RP_Contact
 WHERE  FRPBillID = 1183
        AND FType IN ( 1, 2 ) 