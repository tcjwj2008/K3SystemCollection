--添加t_Voucher字段

ALTER TABLE t_Voucher ADD FSynchroID VARCHAR(50) NULL

 
             --添加t_VoucherBlankout字段

ALTER TABLE t_VoucherBlankout ADD FSynchroID VARCHAR(50) NULL

--添加t_VoucherAdjust字段因为没这个表省了

--ALTER TABLE t_VoucherAdjust ADD FSynchroID varchar(50) null

