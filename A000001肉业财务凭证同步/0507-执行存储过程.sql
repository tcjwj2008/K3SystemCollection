USE [zhuok]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[create_k3_Voucher]
		@P_SOURCE = N'60',
		@P_DATE = N'2020-04-30'

SELECT	'Return Value' = @return_value

GO
