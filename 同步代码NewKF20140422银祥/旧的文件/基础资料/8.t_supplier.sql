-- =============================================
-- Author:Lyman
-- Create date: 
-- Description:	供应商同步
-- =============================================
ALTER TRIGGER [dbo].[yj_t_supplier] on [dbo].[t_supplier]
for insert,update,Delete
AS 
declare @FItemID varchar(10)
declare @FNumber Varchar(100)
declare @DBName varchar(100)
declare @Sql varchar(4000)
declare @InsertSQL varchar(2000)
declare @T_ItemSQL varchar(2000)

declare @nSql nvarchar(4000)
declare @pp2 int
declare @NewFNumber varchar(50)
BEGIN    

select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
if LEN(@DBName) > 0
begin
	
	---- 1. 添加 ----    
    IF EXISTS (SELECT * FROM Inserted) and (not EXISTS (SELECT * FROM deleted ) ) 
    BEGIN
    
		set @InsertSQL='Insert into ' +@DBName+'.dbo.t_supplier (FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+
		  'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FValueAddRate,FCountry,FProvince,Fcorperate,FDiscount,FTypeID,'+
		  'FStockIDAssignee,FBr,FRegmark,FLicence,FCyID,FSetID,FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,'+
		  'FARAccountID,FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+
		  'FminForeReceiveRate,FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,'+
			'FShortNumber,FNumber,FName,FParentID,FItemID)  '
		set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,FParentID,FItemID) '
		
		select @FItemID = FItemID,@FNumber=FNumber from inserted

		set @pp2=0
		set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_supplier where  FNumber='+''''+@FNumber+''''
		exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output

		if @pp2=0
		begin
		
			set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
				exec sp_executesql  @nSql ,N'@p2   int   output ',@pp2   output		
				
			set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,isnull((select FItemID as FParentID from '+
				@DBName+'.dbo.T_Item where FItemClassID=8  and  Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+cast(@pp2 as varchar(10))+
				' from T_Item t where FITemID='+@FItemID
			exec (@Sql)


			set @Sql = @InsertSQL + ' select FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+
				'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FValueAddRate,FCountry,FProvince,Fcorperate,FDiscount,FTypeID,'+
				'FStockIDAssignee,FBr,FRegmark,FLicence,FCyID,FSetID,FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,'+
				'FARAccountID,FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+
				'FminForeReceiveRate,FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,'+
				'FShortNumber,FNumber,FName,isnull((select FItemID as FParentID from '+
				@DBName+'.dbo.T_Item where FItemClassID=8  and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+cast(@pp2 as varchar(10))+
				' from t_supplier t where FItemID='+@FItemID	

			exec (@Sql)

			set @Sql=' update  '+ @DBName+'..t_Item set FName=FName where FItemID=' + cast(@pp2 as varchar(10))
			exec (@sql)	
		end	
		
    end
	-----1. 添加 end ----
	
	-----2.修改 ----
	if EXISTS (SELECT 1 FROM Inserted)  and EXISTS (SELECT 1 FROM deleted )  
	BEGIN 
	
		set @InsertSQL='Insert into ' +@DBName+'.dbo.t_supplier (FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+
			'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FValueAddRate,FCountry,FProvince,Fcorperate,FDiscount,FTypeID,'+
			'FStockIDAssignee,FBr,FRegmark,FLicence,FCyID,FSetID,FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,'+
			'FARAccountID,FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+
			'FminForeReceiveRate,FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,'+
			'FShortNumber,FNumber,FName,FParentID,FItemID)  '
		set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,FParentID,FItemID) '
		
		select @FItemID = FItemID,@FNumber=FNumber from deleted
		select   @NewFNumber=FNumber from inserted
			
		set @pp2=0
		set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_supplier where  FNumber='+''''+@FNumber+''''
		exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
  
		if @pp2 > 0
		begin

			set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemID=' + cast(@pp2 as varchar(10))
			exec (@sql)

			set @Sql= 'delete from '+@DBName+'.dbo.t_supplier where FItemID=' + cast(@pp2 as varchar(10))
			exec (@sql)
		  
			set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted, FFullName,isnull((select FItemID as FParentID from '+
				@DBName+'.dbo.T_Item where FItemClassID=8 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+
				cast(@pp2 as varchar(10))+	' from T_Item t where FITemID='+@FItemID
			exec (@sql)	
     
			set @Sql = @InsertSQL + ' select FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+
				'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FValueAddRate,FCountry,FProvince,Fcorperate,FDiscount,FTypeID,'+
				'FStockIDAssignee,FBr,FRegmark,FLicence,FCyID,FSetID,FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,'+
				'FARAccountID,FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+
				'FminForeReceiveRate,FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,'+
				'FShortNumber,FNumber,FName,isnull((select FItemID as FParentID from '+
				@DBName+'.dbo.T_Item where FItemClassID=8 and  Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+
				cast(@pp2 as varchar(10))+' from t_supplier t where FItemID='+@FItemID	

			exec (@sql) 
		 
			
			set @Sql=' update  '+ @DBName+'..t_Item set FName=FName where FItemID=' + cast(@pp2 as varchar(10))
			exec (@sql)	
		end
	
	end	
	-----2.修改 end----		
	
	-----3. 删除----
	IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
	begin 
		select @FItemID = FItemID,@FNumber=FNumber from deleted

		set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=8 and  FNumber=''' + @FNumber + ''''
		exec (@sql)
		set @Sql= 'delete from '+@DBName+'.dbo.t_supplier where FNumber=''' + @FNumber + ''''
		exec (@sql)
		
	end
	-----3. 删除 End ----
		 
	
END
END
