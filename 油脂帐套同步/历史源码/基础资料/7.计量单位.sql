
-- =============================================
-- Author:opco
-- Create date: 
-- Description:	synchro-计量单位同步
-- =============================================
ALTER TRIGGER [dbo].[yj_t_measureunit] on [dbo].[t_measureunit]
for Insert,Update,Delete
AS 
declare @FItemID varchar(10)
declare @FNumber Varchar(100)
declare @DBName varchar(100)
declare @Sql varchar(max)
declare @InsertSQL varchar(4000)
declare @T_ItemSQL varchar(4000)
declare @FParentID varchar(50)			---- FParentID=FUnitGroupID
declare @IsHere varchar(10)
declare @FDetail varchar(10)
declare @NewFnumber varchar(50)
--declare @FItemidTemp varchar(50)
declare @nSql nvarchar(4000)
declare @pp2 int
BEGIN    
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	if LEN(@DBName) > 0
	begin	
		set @InsertSQL='Insert into ' +@DBName+'.dbo.t_measureunit (FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,FUnitGroupID,FParentID,FMeasureUnitID,FItemID) ' 
		set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '

		
		-----1. 添加    
        IF EXISTS (SELECT * FROM Inserted) and (not EXISTS (SELECT * FROM deleted ) ) 
        BEGIN

			select @FNumber=FNumber,@FParentID = FParentID from inserted
			
			set @pp2=0
			set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_measureunit where  FNumber='+''''+@FNumber+''''
			exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output

			if @pp2 = 0
			begin
				set @nSQL=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
				exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output

				set @Sql=@T_ItemSQL + 'select 7,2,FName,FNumber,FShortNumber,FShortNumber,1,UUID,0,isnull((select top 1 FItemID as FParentID from '+
					@DBName+'.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='+@FParentID+')),0),'+cast(@pp2 as varchar(10))+' from t_measureunit where  FNumber='	+''''+@FNumber	+''''
				exec (@Sql)  
		  
				set @Sql = @InsertSQL + ' select FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,isnull((select  top 1 FUnitGroupID as FUnitGroupID from '+
							@DBName+'.dbo.t_UnitGroup where FName=(select top 1 FName from t_UnitGroup where FUnitGroupID='+@FParentID+')),0),'+
							' isnull((select top 1 FItemID as FParentID from ' +
							@DBName+'.dbo.T_Item where FNumber=(select top 1 FNumber from T_Item where FItemID='+@FParentID+')),0),'+
							cast(@pp2 as varchar(10))+ ',' + cast(@pp2 as varchar(10)) +' from t_measureunit where FNumber='+''''+@FNumber	+''''	
				exec (@sql)

				IF  not  EXISTS(select * from t_measureunit where FParentID=@FParentID and FNumber<>@FNumber)
				begin 
					set @Sql = 'update '+ @DBName + '.dbo.t_measureunit set FStandard=1  where FNumber='+''''+@FNumber	+''''
					exec (@sql)
				end
			end
	
        end
        
		-----2.修改
		if EXISTS (SELECT 1 FROM Inserted)  and EXISTS (SELECT 1 FROM deleted )  
		BEGIN    
			select @FItemID = FItemID,@FNumber=FNumber,@FParentID = FParentID from deleted
		
			select @FParentID=FParentID, @FDetail=FDetail from t_Item where FItemID=@FItemID
			if @FDetail = '1' --插入到t_measureunit和t_item
			begin
			
				set @pp2=0
				set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_measureunit where  FNumber='+''''+@FNumber+''''
				exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
	
				if @pp2 > 0 
				begin
					------删除
					set @Sql= 'delete from '+@DBName+'.dbo.T_Item where  FItemID=' + cast(@pp2 as varchar(10))
					exec (@sql)

					set @Sql= 'delete from '+@DBName+'.dbo.t_measureunit where FItemID=' + cast(@pp2 as varchar(10))
					exec (@sql)
			  
					-------插入
					set @InsertSQL='Insert into ' +@DBName+'.dbo.t_measureunit (FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,FUnitGroupID,FParentID,FMeasureUnitID,FItemID,FDeleted) ' 
					set @Sql=@T_ItemSQL + 'select 7,2,FName,FNumber,FShortNumber,FShortNumber,1,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+
							@DBName+'.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='+@FParentID+')),0),'+cast(@pp2 as varchar(10))+' from t_measureunit where  FItemID='+@FItemID
					exec (@Sql)

					set @Sql = @InsertSQL + ' select FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,isnull((select  top 1 FUnitGroupID as FUnitGroupID from '+
							@DBName+'.dbo.t_UnitGroup where FName=(select top 1 FName from t_UnitGroup where FUnitGroupID='+@FParentID+')),0),'+
							' isnull((select top 1 FItemID as FParentID from ' +
							@DBName+'.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='+@FParentID+')),0),'+
							cast(@pp2 as varchar(10))+ ',' + cast(@pp2 as varchar(10)) +',FDeleted  from t_measureunit where FItemID='+@FItemID
					exec (@sql)
				end
				
			end

			
		end
	
		-----3. 删除
		IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
		begin 
			select @FItemID = FItemID,@FNumber=FNumber from deleted
		
			set @Sql= 'delete from '+@DBName+'.dbo.t_measureunit where Fnumber=' + '''' + @FNumber + ''''
			exec (@sql)
			
		end
		
	end
END

