SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**
更新订单行业务反关闭功能 QIU
*/
ALTER procedure [dbo].[yxdzp_OrderMrpCloseUpdate] 
@SeOrder VARCHAR(100)
as
BEGIN
	
	UPDATE SEOrderEntry set FMrpClosed=0 WHERE  FInterID in
	(
	SELECT FInterID FROM SEOrder s WHERE FBillNo =@SeOrder
	)
	AND FMrpClosed=1
	
	SELECT 1 AS 更新成功
END
