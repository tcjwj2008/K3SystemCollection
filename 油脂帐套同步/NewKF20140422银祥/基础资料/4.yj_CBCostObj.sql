-- =============================================
-- Author:
-- Last Modify: 2013-03
-- Description:	成本对象
-- =============================================
 
Create TRIGGER [dbo].yj_CBCostObj on [dbo].t_item
for Insert,update,delete
AS 
declare @DBName varchar(100)
declare @FDetail varchar(10)
--declare @FItemClassID varchar(50)

declare @FItemID varchar(10)
declare @FNumber Varchar(100)
declare @OldFnumber varchar(100)
declare @FName varchar(100)
declare @FShortNumber varchar(100)
declare @FParentID int

declare @Sql varchar(4000)
declare @T_ItemSQL varchar(4000)
declare @nSql nvarchar(4000)
declare @pp2 int
declare @P1 int,@P3 varchar(50),@P4 varchar(50)
BEGIN    

	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	select @FDetail=FDetail from inserted where  FItemClassID=2001 and  FDetail=1
	select @FDetail=FDetail from deleted where  FItemClassID=2001 and  FDetail=1
	
	if (LEN(@DBName) > 0) and @FDetail=1
	begin
	
		-----1. 添加    -----
        IF EXISTS (SELECT * FROM Inserted) and (not EXISTS (SELECT * FROM deleted ) ) 
        BEGIN
			select @FItemID =FItemID,@FNumber=FNumber from inserted 
			
			set @pp2=0
			set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_item where FItemClassID=2001 and FNumber='+''''+@FNumber+''''
			exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output

			if @pp2 = 0
			begin
			
				set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
				exec sp_executesql  @nSql ,N'@p2   int   output ',@pp2   output
				
				set @Sql='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ' +
						 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+
						@DBName+'.dbo.T_Item where FItemClassID=2001 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+
						cast(@pp2 as varchar(10))+' from T_Item t where FITemID='+@FItemID
				exec (@Sql)	
				
				set @sql='insert into ' +@DBName+'.dbo.CBCostObj (FItemID,FNumber,FName,FStdID,FStdSubID,FParentID,FShortNumber,FUnUsed,FCalculateType,FStdProductID,FBatchNo,FBomID,
							FEditable,FSBillNo,FDeleted,FStdSubItemID)
						 select t.FItemID,t.FNumber,t.FName,0,0,t.FParentID,t.FShortNumber,0,906,t2.FItemID,'''',0,0,'''',0,0
						 from ' +@DBName+'.dbo.t_item  t 
						 left join ' +@DBName+'.dbo.t_Item t2 on t2.FNumber=t.FNumber and t2.FItemClassID=4
						 where t.FItemID='+ cast(@pp2 as varchar(10))
				exec (@Sql)	
				
				set @sql='insert into ' +@DBName+'.dbo.CB_CostObj_Product(FCostObjID,FProductID,FQuotiety,FIsStand,FIsDeputy)
						select '+ cast(@pp2 as varchar(10)) + ',FItemID,1,1,0
						from ' +@DBName+'.dbo.t_Item where FItemClassID=4 and FNumber=''' + @FNumber + ''''
				exec (@Sql)	
				
			end
			
				

		end

		
		-----2.修改 ----- 
		if EXISTS (SELECT 1 FROM Inserted)  and EXISTS (SELECT 1 FROM deleted )  
		BEGIN 
			IF (( UPDATE (FName))  or (update(FNumber))) 
			begin 
			
				select @FItemID = FItemID,@FNumber=FNumber,@FShortNumber=FShortNumber,@FName=FName  from inserted
				select @OldFnumber=FNumber from deleted 

				set @pp2=0
				set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_item where FItemClassID=2001 and FNumber='+''''+@OldFnumber+''''
				exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output

				---- 1.不存在，新增  ----
				if @pp2 = 0
				begin
					set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
					exec sp_executesql  @nSql ,N'@p2   int   output ',@pp2   output
					
					set @Sql='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ' +
							 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+
							@DBName+'.dbo.T_Item where FItemClassID=2001 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+
							cast(@pp2 as varchar(10))+' from T_Item t where FITemID='+@FItemID
					exec (@Sql)	
					
					set @sql='insert into ' +@DBName+'.dbo.CBCostObj (FItemID,FNumber,FName,FStdID,FStdSubID,FParentID,FShortNumber,FUnUsed,FCalculateType,FStdProductID,FBatchNo,FBomID,
								FEditable,FSBillNo,FDeleted,FStdSubItemID)
							 select t.FItemID,t.FNumber,t.FName,0,0,t.FParentID,t.FShortNumber,0,906,t2.FItemID,'''',0,0,'''',0,0,0
							 from ' +@DBName+'.dbo.t_item  t 
							 left join ' +@DBName+'.dbo.t_Item t2 on t2.FNumber=t.FNumber and t2.FItemClassID=4
							 where t.FItemID='+ cast(@pp2 as varchar(10))
					exec (@Sql)		
					
					set @sql='insert into ' +@DBName+'.dbo.CB_CostObj_Product(FCostObjID,FProductID,FQuotiety,FIsStand,FIsDeputy)
							select '+ cast(@pp2 as varchar(10)) + ',FItemID,1,1,0
							from ' +@DBName+'.dbo.t_Item where FItemClassID=4 and FNumber=''' + @FNumber + ''''
					exec (@Sql)						
				end
				else
				begin
					set @FParentID=0
					set @nSQL=' select @p2=isnull((select top 1 FItemID as FParentID from ' + @DBName + '.dbo.T_Item 
								where FItemClassID= 2001 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0)
								from T_Item t where FItemID='+ @FItemID
					exec sp_executesql  @nSQL ,N'@p2   int   output ',@FParentID output

				
					set @Sql='update   '+@DBName+'..T_Item  set FName='+''''+@FName+''''+',FNumber='+''''+@FNumber+''''+
							' ,FFullNumber='+''''+@FNumber+''''+',FShortNumber='+''''+@FShortNumber+''''+',FParentID='+ cast(@FParentID as varchar(10)) +
							'  where FItemID='+ cast(@pp2 as varchar(10))
					exec (@Sql)	
		
					set @Sql='update   '+@DBName+'..CBCostObj  set FNumber='+''''+@FNumber+''''+',FName='+''''+@FName+''''+
							',FShortNumber='+''''+@FShortNumber+''''+',FParentID='+ cast(@FParentID as varchar(10)) +
							'  where FItemID='+ cast(@pp2 as varchar(10))
					exec (@Sql)			
								
				
					--select * from CBCostObj order by FItemID desc 
				end
				

				
				
			end
		END
		
			
		------ 3. 删除 -----
		IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
		begin 
			select @FNumber=FNumber  from deleted
			
			set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=2001 and FNumber='+''''+@FNumber+''''
			exec (@sql)
			
			set @Sql= 'delete from '+@DBName+'.dbo.CBCostObj where FNumber='+''''+@FNumber+''''
			exec (@sql)
		end
		-----
		
	end
	
	
	
		
END

