
-- =============================================
-- Author:opco
-- Create date: 
-- Description:	synchro-计量单位(组)同步
-- =============================================
ALTER TRIGGER [dbo].[yj_t_UnitGroup] on [dbo].[t_UnitGroup]
for Insert,Update,Delete
AS 
declare @FItemID varchar(10)
declare @FNumber Varchar(100)
declare @DBName varchar(100)
declare @Sql varchar(4000)
declare @IsHere varchar(10)
declare @NewFnumber varchar(50)
declare @FItemidTemp varchar(50)
BEGIN    
	BEGIN TRANSACTION  
	SET NOCOUNT ON
	
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	if LEN(@DBName) > 0
	begin	
		-----1. 添加    
        IF EXISTS (SELECT * FROM Inserted) and (not EXISTS (SELECT * FROM deleted ) ) 
        BEGIN

			select @FNumber=FName,@FItemID=FUnitGroupID from inserted

			--IF  EXISTS (SELECT * FROM tempdb.sys.objects WHERE object_id = OBJECT_ID(N'tempdb..TongBuTemp') AND type in (N'U'))
			--	drop table TongBuTemp
			--Create table TongBuTemp (TempID varchar(10))
                        delete from TongBuTemp

			set @sql= 'insert into  TongBuTemp (TempID) select FitemID from ' +@DBName+'.dbo.t_item where FItemClassID=7 and FNumber='+''''+@FNumber+''''
			exec (@sql)
			
			set @IsHere='0'
			select @IsHere =tempID from  TongBuTemp

			if @IsHere > 0
			begin
				set @Sql='Insert into ' +@DBName+'.dbo.t_UnitGroup (FUnitGroupID,FName) '
				set @Sql = @Sql + ' select '+ cast(@IsHere as varchar(10))+',FName from t_UnitGroup where FUnitGroupID='+@FItemID	
				exec (@sql)
			end
	
        end
        
		-----2.修改(只修改名称FName)
		if EXISTS (SELECT 1 FROM Inserted)  and EXISTS (SELECT 1 FROM deleted )  
		BEGIN    
				
			select @FItemID = FUnitGroupID,@FNumber=FName from deleted
			select @NewFNumber=FName from inserted
			
			--set @Sql = 'update '+ @DBName+'.dbo.T_Item set FNumber='+''''+@NewFNumber+''''+' where FItemClassID=7 and FNumber='+ ''''+@FNumber+''''
			--exec (@sql) 
			set @Sql = 'update '+ @DBName+'.dbo.t_UnitGroup set FName='+''''+@NewFNumber+''''+' where FName='+ ''''+@FNumber+''''
			exec (@sql) 
	
		end
	
		-----3. 删除
		IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
		begin 
			
			select @FItemID = FUnitGroupID,@FNumber=Fname from deleted
			set @Sql= '  delete from '+@DBName+'.dbo.T_Item where FItemClassID=7 and  FParentID IN (select FUnitGroupID as FParentID from '+@DBName+'.dbo.t_UnitGroup where FName='+''''+@FNumber+''''+')'
 			exec (@sql)
 			
			set @Sql= 'delete from '+@DBName+'.dbo.t_UnitGroup where FName='+''''+@FNumber+''''
			exec (@sql)
			
 			set @Sql= '  delete from '+@DBName+'.dbo.T_Item where FItemClassID=7 and  FNumber='+''''+@FNumber+''''
 			exec (@sql)
			

			
		end
		
	end
	
	IF (@@error <> 0)  
		ROLLBACK TRANSACTION  
	ELSE  
		COMMIT TRANSACTION 
		
END

