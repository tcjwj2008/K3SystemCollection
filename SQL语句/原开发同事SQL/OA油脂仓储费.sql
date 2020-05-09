USE [ecology]
GO

/****** Object:  Trigger [dbo].[Test_Insert]    Script Date: 11/23/2017 09:02:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<hjc>
-- Create date: <2017/8/28>
-- Description:	<test>
-- =============================================
CREATE TRIGGER [dbo].[Test_Insert]
   ON  [dbo].[formtable_main_96]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @days int; --天数
	declare @hetongsl decimal(10,2); --合同数量
	declare @hetongpx int; --合同品项
	declare @multiple int; --倍数
	declare @remainder int; --余数
	declare @sum decimal(10,2); --超期费用
	declare @sum1 decimal(10,2);
	declare @sum2 decimal(10,2);
	
	select @days=DATEDIFF(day,tihuoqz,jiezhirq) From inserted;
	if (@days < 0)
	begin
	    set @days = 0;
	end
	select @hetongsl=hetongsl From inserted;
	select @hetongpx=hetongpx From inserted;
	
	print('日期间隔:'+CAST (@days AS varchar(50)));
	print('合同数量:'+CAST (@hetongsl AS varchar(50)));
	print('合同品项:'+CAST (@hetongpx AS varchar(50)));
	
	if(@hetongpx = 1) 
	begin
		set @multiple = @days / 15;
		set @remainder = @days % 15;
		set @sum1 = cast((1 + 1 + (@multiple - 1) * 1) AS FLOAT) / 2 * (@multiple * 15);
        set @sum2 = (1 + @multiple * 1) * @remainder;
        set @sum = (@sum1 + @sum2) * @hetongsl;
	end
	else if (@hetongpx = 0) 
	begin
        set @sum = 1 * @days * @hetongsl;
	end
	else if (@hetongpx = 7) 
	begin
		set @multiple = @days / 60;
		set @remainder = @days % 60;
		set @sum1 = cast((1 + 1 + (@multiple - 1) * 1) AS FLOAT) / 2 * (@multiple * 60);
        set @sum2 = (1 + @multiple * 1) * @remainder;
        set @sum = (@sum1 + @sum2) * @hetongsl;
	end
	declare @id int;
	set @id = (select id from inserted);
	UPDATE formtable_main_96 SET ChaoQinFY = @sum where id = @id;
	print('超期费用:'+CAST (@sum AS varchar(50)));
	print('id:'+CAST (@id AS varchar(50)));
END

GO

