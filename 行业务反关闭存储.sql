SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**
���¶�����ҵ�񷴹رչ��� QIU
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
	
	SELECT 1 AS ���³ɹ�
END
