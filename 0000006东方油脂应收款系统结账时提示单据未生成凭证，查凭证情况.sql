SELECT * FROM t_voucher,dbo.t_VoucherEntry WHERE 
t_voucher.FVoucherID=t_voucherentry.FVoucherID 
AND FNumber='214'
GO

dbo.SpK3_2Str @sName = 't_voucher' -- varchar(50)
 


 