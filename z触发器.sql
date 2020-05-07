USE [scandb]
GO
/****** Object:  Trigger [dbo].[TRG_Trade_Insert]    Script Date: 2019/9/23 14:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER trigger [dbo].[TRG_Trade_Insert] on [dbo].[Trade]
for insert,update
as 
begin
--获取新增行称重信息
	declare @FTradeNo varchar(20)  --单号
	declare @FOrderNo varchar(20)  --运单号
	declare @FNet decimal(16,2)    --净重
	declare @Truckno varchar(20)   --车牌号
	declare @FTradeID varchar(20)  --内码
	declare @cardno varchar(20)   --称重单号
	select @FTradeID=id,@cardno=cardno, @FTradeNo=ticketno1,@FOrderNo=sparestr2,@FNet=net/1000,@Truckno=truckno from inserted 
    
	Declare @SQL NVarchar(200)   
	Declare @FDBName  varchar(50)
	--set @FDBName='[188.188.1.8].Test_AISDF_DFYX' 
	set @FDBName='[localhost].AISDF_DFYX' 
	--拼接链接数据库存储过程
    SELECT @SQL=N'exec '+@FDBName+'.dbo.pro_TradeToOutStock '''+@FTradeID +''','''+@cardno +''','''+@FTradeNo +''','''+ @FOrderNo+''','+Convert(varchar(10),@FNet)+','''+@Truckno+''''
	--print @SQL
	--执行
	exec sp_executesql @SQL 

end


