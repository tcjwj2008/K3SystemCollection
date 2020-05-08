
USE AIS_YXYZ_2
go 
create  procedure Pro_BosBillNo ( @BillNoTitle nvarchar(50),@BillType int,  @BillNo varchar(50) output)
as
begin
declare @DateFormat varchar(8)
declare @TmpBillNo varchar(50)
declare @FNumMax int
declare @i int
declare @FID varchar(3)
set @BillNo = ''
select @DateFormat = replace(CONVERT(varchar(10),getdate(),121),'-','')
select @FNumMax= FNumMax + 1 from t_billcodeby where FBillTypeID = @BillType and FFormatChar=@BillNoTitle + @DateFormat
--if EXISTS (select FBillTypeID from t_billcodeby where FBillTypeID = @BillType and FFormatChar=@BillNoTitle + @DateFormat)
if @FNumMax > 0
begin
    update t_billcodeby set FNumMax = FNumMax + 1 where FBillTypeID = @BillType and FFormatChar=@BillNoTitle + @DateFormat
    if len(@FNumMax) < 3
    begin	  
		set @i = len(@FNumMax)
		set @FID = ''
		while @i < 3
		begin
		  set @FID = @FID + '0'  
		  set @i = @i + 1
		end
		set @FID = @FID + CAST(@FNumMax as varchar(3))
		set @BillNo = @BillNoTitle + @DateFormat + @FID
    end
    else
        set @BillNo = @BillNoTitle + @DateFormat + CAST(@FNumMax as varchar(3))
    
end
else
begin
	insert into t_billcodeby (FBillTypeID,FFormatChar,FProjectVal,FNumMax) values (@BillType,@BillNoTitle + @DateFormat,'yyyymmdd',1)
	set @BillNo = @BillNoTitle + @DateFormat + '001'
end
 
end
