--Ìí¼ÓBOM×Ö¶Î
ALTER TABLE ICStockBill ADD FSynchroID varchar(50) NULL
go 
ALTER TABLE ICSale ADD FSynchroID varchar(50) NULL
go 
ALTER TABLE ICPurchase ADD FSynchroID varchar(50) NULL
go 
ALTER TABLE t_RP_NewReceiveBill ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICBOM ADD FSynchroID varchar(50) NULL
go 
ALTER TABLE ICStockBill_1 ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICStockBill_2 ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICStockBill_21 ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICStockBill_10 ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICStockBill_24 ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICStockBill_28 ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICStockBill_29 ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICStockBill_41 ADD FSynchroID varchar(50) NULL
go
ALTER TABLE ICStockBill_5 ADD FSynchroID varchar(50) null




--select * from ICTemplate where FCaption like '%Synchro%'
--select * from ICClassTableinfo where FCaption_CHS like '%Synchro%'
--select * from ICChatBillTitle where  FColCaption like '%Synchro%'

--update ICTemplate set FFieldName='FSynchroID' where  FCaption='FSynchroID' and FID='A01'
--update ICChatBillTitle set FColName='FSynchroID' where FColCaption='FSynchroID$'  and FTableName='ICStockBill'
--update ICClassTableinfo set FFieldName='FSynchroID' where FCaption_CHS='Synchro'
	Create table TongBuTemp (TempID varchar(10))