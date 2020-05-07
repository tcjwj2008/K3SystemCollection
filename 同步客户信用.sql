USE [test_yxrzp]
GO
/****** Object:  StoredProcedure [dbo].[SP_CorrectionOfCustomerCredi_qiu]    Script Date: 08/03/2019 16:25:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[SP_CorrectionOfCustomerCredi_qiu] 
as
begin
    begin tran
	update t_SystemProfile set FValue=0  where FCategory='IC' and FKey='CreditEnable'
	EXEC Prc_synchronizationData 21,'',0
	exec p_IC_InitCreditInstantData
	update t_SystemProfile set FValue=1  where FCategory='IC' and FKey='CreditEnable'
	select '1' as 结果
	commit
	
end
