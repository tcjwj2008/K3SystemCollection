SELECT * FROM dbo.t_TableDescription WHERE FDescription LIKE '%¿¨Æ¬%'

SELECT * FROM t_FACard    WHERE FAlterId=1491  

SELECT * FROM t_FABalCard                                                                                                                                       

SELECT * FROM CIP_AssetsApplication
GO
dbo.SpK3_2Str @sName = 't_favoucher' -- varchar(50)

GO
dbo.SpK3_2tab @sName = 't_favoucher ' -- varchar(50)

GO

--UPDATE t_favoucher SET fvoucherid=''  where FAlterID=1491


SELECT * FROM t_favoucher

select fv.* from t_favoucher fv inner join t_Voucher v on fv.FVoucherID=v.FVoucherID where fv.FAlterID=1491



