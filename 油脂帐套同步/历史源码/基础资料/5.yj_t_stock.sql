 
create  TRIGGER [dbo].[yj_t_stock] on [dbo].[t_Stock]
for insert,update,Delete
AS 
declare @FItemID varchar(10)
declare @FNumber Varchar(100)
declare @DBName varchar(100)
declare @Sql varchar(max)
declare @InsertSQL varchar(2000)
declare @T_ItemSQL varchar(2000)
declare @nSQL nvarchar(max)
declare @pp2 int
declare @NewFnumber varchar(50)
BEGIN    

	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	if LEN(@DBName) > 0
	begin
	
		-----  1. 添加   ---- 
        IF EXISTS (SELECT * FROM Inserted) and (not EXISTS (SELECT * FROM deleted ) ) 
        BEGIN
			set @InsertSQL='Insert into ' +@DBName+'.dbo.t_stock (FEmpID,FAddress,FPhone,FProperty,FTypeID,FMRPAvail,FIsStockMgr,FSPGroupID,FShortNumber,FNumber,FName,FParentID,FItemID) '
			set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,FParentID,FItemID) '
				
			select @FItemID = FItemID,@FNumber=FNumber from inserted

			set @pp2=0
			set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_Stock where Fnumber='''+ @FNumber + ''''
			exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
				
			if @pp2 = 0
			begin

				set @nSQL=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
				exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
				
				set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,isnull((select FItemID as FParentID from '+
						@DBName+'.dbo.T_Item where FItemClassID=t.FItemClassID and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+cast(@pp2 as varchar(10))+' from T_Item t where FITemID='+@FItemID
				exec (@SQL)

				
				set @Sql = @InsertSQL + ' select '+
							'isnull((select FItemID from '+@DBName+'.dbo.t_emp where Fnumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),'+
							'FAddress,FPhone,FProperty,FTypeID,FMRPAvail,FIsStockMgr,FSPGroupID,FShortNumber,FNumber,FName,
							isnull((select FItemID as FParentID from '+ @DBName+'.dbo.T_Item where FItemClassID=5 and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+
							cast(@pp2 as varchar(10))+' from t_stock t where FItemID='+@FItemID	
				exec (@sql)

				set @Sql=' update  '+ @DBName+'..t_Item set FName=FName where FItemID=' + cast(@pp2 as varchar(10))
				exec (@sql)
			end
				

		end
		
		
		---- 2.修改----
		if EXISTS (SELECT 1 FROM Inserted)  and EXISTS (SELECT 1 FROM deleted )  
		BEGIN    
			set @InsertSQL='Insert into ' +@DBName+'.dbo.t_stock (FEmpID,FAddress,FPhone,FProperty,FTypeID,FMRPAvail,FIsStockMgr,FSPGroupID,FShortNumber,FNumber,FName,FParentID,FItemID) '
			set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,FParentID,FItemID) '

			select @FItemID = FItemID,@FNumber=FNumber from deleted
			
			set @pp2=0
			set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_stock where Fnumber='''+ @FNumber + ''''
			exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
	
			if @pp2>0
			begin
				set @Sql= 'delete from '+@DBName+'.dbo.T_Item where  FItemID=' + cast(@pp2 as varchar(10))
				exec (@sql)

				set @Sql= 'delete from '+@DBName+'.dbo.t_stock where FItemID=' + cast(@pp2 as varchar(10))
				exec (@sql)
			
			
				set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,isnull((select FItemID as FParentID from '+
						@DBName+'.dbo.T_Item where FItemClassID=t.FItemClassID and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+cast(@pp2 as varchar(10))+' from T_Item t where FITemID='+@FItemID
				exec (@SQL)
				
				set @Sql = @InsertSQL + ' select '+
							'isnull((select FItemID from '+@DBName+'.dbo.t_emp where Fnumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),'+
							'FAddress,FPhone,FProperty,FTypeID,FMRPAvail,FIsStockMgr,FSPGroupID,FShortNumber,FNumber,FName,
							isnull((select FItemID as FParentID from '+ @DBName+'.dbo.T_Item where FItemClassID=5 and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+
							cast(@pp2 as varchar(10))+' from t_stock t where FItemID='+@FItemID	
				exec (@sql)

				set @Sql=' update  '+ @DBName+'..t_Item set FName=FName where FItemID=' + cast(@pp2 as varchar(10))
				exec (@sql)
				
			end


			
			
		end
		
		
		-----  3. 删除 ----
		IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
		begin
			select @FItemID = FItemID,@FNumber=FNumber from deleted
			set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=5 and  FNumber=''' + @FNumber + ''''
			exec (@sql)
			set @Sql= 'delete from '+@DBName+'.dbo.t_stock where  FNumber=''' + @FNumber + ''''
			exec (@sql)
		end 

	end
	
			
END
