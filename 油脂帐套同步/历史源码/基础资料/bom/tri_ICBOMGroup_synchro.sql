 
-- =============================================
-- Author:opco
-- Create date: 2013-04-00
-- Description:	synchro-BOM单组别
-- =============================================
Create TRIGGER [dbo].[tri_ICBOMGroup_synchro] on [dbo].[ICBOMGroup]
for Insert,Update,Delete
AS 
declare @FItemID varchar(10)
declare @FNumber Varchar(100)
declare @DBName varchar(100)
declare @Sql varchar(4000)
declare @IsHere varchar(10)



declare @FParentID varchar(10)
declare @FID Varchar(100)			--代码
declare @FName varchar(50)			--名称
declare @NewFName varchar(50)
declare @NewFID varchar(50)

declare @nSql nvarchar(4000)
declare @pp2 int

BEGIN    
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	if LEN(@DBName) > 0
	begin	
		-----1. 添加    
        IF EXISTS (SELECT * FROM Inserted) and (not EXISTS (SELECT * FROM deleted ) ) 
        BEGIN
			
			select @FNumber=FNumber  from inserted
			
			set @pp2 = 0
			set @nSQL=' select @p2=FInterID from  '+ @DBName+'.dbo.ICBOMGroup where FNumber=' + '''' + @FNumber + ''''
			exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
			

			if @pp2 = 0
			begin
			
				set @nSQL=' exec '+ @DBName+'.dbo.GetICMaxNum ''ICBOMGroup'',@p2 output,1,16394'
				exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output

				set @Sql='Insert into ' +@DBName+'.dbo.ICBOMGroup (FInterID,FNumber,FName,FBootID,FParentID) '+
						 ' select '+ cast(@pp2 as varchar(10))+',FNumber,FName,'+
						 ' isnull((select FInterID from  '+ @DBName+'.dbo.ICBOMGroup where FNumber=(select top 1 FNumber from ICBOMGroup where FInterID=t.FBootID)),0),'+
						 ' isnull((select FInterID from  '+ @DBName+'.dbo.ICBOMGroup where FNumber=(select top 1 FNumber from ICBOMGroup where FInterID=t.FParentID)),0)'+
						 ' from ICBOMGroup t where FNumber='''+ @FNumber + ''''	
				exec (@sql)

			end 
	
        end
        
		-----2.修改
		if EXISTS (SELECT 1 FROM Inserted)  and EXISTS (SELECT 1 FROM deleted )  
		BEGIN    
 			select @FID=FNumber,@FParentID=FParentID from deleted
 			select @NewFID=FNumber,@NewFName=FName from inserted
 				
			set @Sql ='update '+ @DBName+ '.dbo.ICBOMGroup set FNumber='+''''+@NewFID+''''+',FName='''+ @NewFName + ''' where FNumber='''+@FID + ''''
			exec (@sql)
		end
	
		-----3. 删除
		IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
		begin 
			select @FNumber=FNumber from deleted
			
			set @Sql= 'delete from '+@DBName+'.dbo.ICBOMGroup where FNumber='+''''+@FNumber+''''
			exec (@sql)
		end
		
	end
END

