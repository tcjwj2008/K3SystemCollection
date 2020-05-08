 
CREATE TRIGGER [dbo].[yj_t_item] on [dbo].[t_Item]
for Insert,update,delete
AS 
declare @DBName varchar(100)
declare @FDetail varchar(10)
declare @FItemClassID varchar(50)

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
BEGIN    
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='����ͬ��'
	select @FDetail=FDetail from inserted where FItemClassID in (1,2,3,4,5,7,8,2001)
	select @FDetail=FDetail from deleted where FItemClassID in (1,2,3,4,5,7,8,2001)
	
	if (LEN(@DBName) > 0) and (@FDetail = 0)
	begin
	
		-----1. ���    -----
        IF EXISTS (SELECT * FROM Inserted) and (not EXISTS (SELECT * FROM deleted ) ) 
        BEGIN
			set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '

			select @FItemID =FItemID,@FNumber=FNumber,@FItemClassID=FItemClassID from inserted
			
			set @pp2=0
			set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_item where FItemClassID='+ @FItemClassID +' and FNumber='+''''+@FNumber+''''
			exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output

			if @pp2 = 0
			begin
			
				set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
				exec sp_executesql  @nSql ,N'@p2   int   output ',@pp2   output
				

				set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+
						@DBName+'.dbo.T_Item where FItemClassID= t.FItemClassID and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+
						cast(@pp2 as varchar(10))+' from T_Item t where FItemClassID= '+''''+@FItemClassID+''''+' and FNumber='+''''+@FNumber+''''
				exec (@SQL)	
			end
				

		end

		
		-----2.�޸� (��Ӧ���״�����ͬĿ¼����ͬ��)----- 
		if EXISTS (SELECT 1 FROM Inserted)  and EXISTS (SELECT 1 FROM deleted )  
		BEGIN 
			IF (( UPDATE (FName))  or (update(FNumber))) 
			begin 
			
				select @FItemID = FItemID,@FNumber=FNumber,@FShortNumber=FShortNumber,@FName=FName,@FItemClassID=FItemClassID  from inserted
				select @OldFnumber=FNumber from deleted 

				set @pp2=0
				set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_item where FItemClassID='+ @FItemClassID +' and FNumber='+''''+@OldFnumber+''''
				exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
		
						---- 1.�����ڣ�����  ----
				if @pp2 = 0
				begin

					set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
					exec sp_executesql  @nSql ,N'@p2   int   output ',@pp2   output
					
					set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '

					set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+
							@DBName+'.dbo.T_Item where FItemClassID= t.FItemClassID and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+
							cast(@pp2 as varchar(10))+' from T_Item t where FItemClassID= '+''''+@FItemClassID+''''+' and FNumber='+''''+@FNumber+''''
					exec (@SQL)	
				end
				
				
						---- 2.�޸�	----
				if @pp2 > 0
				begin
					
					set @FParentID=0
					set @nSQL=' select @p2=isnull((select top 1 FItemID as FParentID from ' + @DBName + '.dbo.T_Item 
								where FItemClassID= t.FItemClassID and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0)
								from T_Item t where FItemID='+ @FItemID
					exec sp_executesql  @nSQL ,N'@p2   int   output ',@FParentID output

				
					set @Sql='update   '+@DBName+'..T_Item  set FName='+''''+@FName+''''+',FNumber='+''''+@FNumber+''''+
							' ,FFullNumber='+''''+@FNumber+''''+',FShortNumber='+''''+@FShortNumber+''''+',FParentID='+ cast(@FParentID as varchar(10)) +
							'  where FItemID='+ cast(@pp2 as varchar(10))
					exec (@Sql)	
					
					update T_Item set FFullName=FFullName where FNumber like @FNumber+'.%'
					
					
				end	
			end
			
			
		END
		
			
		-----3. ɾ�� -----
		IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
		begin 
			select @FNumber=FNumber,@FItemClassID=FItemClassID from deleted
			
			set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemClassID='+ @FItemClassID +' and FNumber='+''''+@FNumber+''''
			exec (@sql)
		end
		-----
		
	end
END

----1-�ͻ� t_organization��
----2-���� t_department;
----3-ְԱ t_emp;
----4-��Ʒ t_icitem;
----5-��λ t_stock;
----7-��λ t_measureunit��
----8-��Ӧ�� t_supplier