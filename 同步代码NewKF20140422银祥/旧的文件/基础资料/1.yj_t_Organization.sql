
-- =============================================
-- Author:opco
-- Create date: 2012-09
-- Description:	客户同步
-- =============================================
CREATE TRIGGER [dbo].[yj_t_Organization] on [dbo].[t_Organization]
for Insert,update,delete
AS 
declare @DBName varchar(100)
declare @FItemID varchar(10)
declare @FNumber Varchar(100)

declare @Sql varchar(4000)
declare @InsertSQL varchar(4000)
declare @T_ItemSQL varchar(4000)
declare @IsHere varchar(10)
declare @FDetail varchar(10)
declare @FParentID varchar(50)
declare @isSynchro int
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
        
			set @InsertSQL='Insert into ' +@DBName+'.dbo.t_Organization (FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+
			'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FIsCreditMgr,FSaleMode,FValueAddRate,FCountry,FHomePage,'+
			'Fcorperate,FCarryingAOS,FTypeID,FSaleID,FStockIDKeep,FCyID,FSetID,FCIQNumber,'+
			'FARAccountID,FAPAccountID,FOtherAPAcctID,FOtherARAcctID,FPayTaxAcctID,FpreAcctID,FPreAPAcctID,'+
			'FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+
			'FminForeReceiveRate,FminReserverate,FdebtLevel,FPayCondition,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,FShortNumber,FNumber,FName,'+
			'FParentID,FItemID) '  
			set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '

			select @FItemID = FItemID,@FNumber=FNumber from inserted
			select @FParentID=FParentID, @FDetail=FDetail from t_Item where FNumber=@FNumber
	
			
			set @pp2=0
			set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_Organization where  FNumber='+''''+@FNumber+''''
			exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
		
			if @pp2=0 
			begin
			
				set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
				exec sp_executesql  @nSql ,N'@p2   int   output ',@pp2   output

				set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+
					@DBName+'.dbo.T_Item where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID='+@FParentID+')),0),'+cast(@pp2 as varchar(10))+' from T_Item where FITemID='+@FItemID
				exec (@SQL)	

				set @Sql = @InsertSQL + ' select FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,FMobilePhone,FFax,FPostalCode,FEmail,'+
					'FBank,FAccount,FTaxNum,FIsCreditMgr,FSaleMode,FValueAddRate,FCountry,FHomePage,Fcorperate,FCarryingAOS,FTypeID,FSaleID,'+
					'FStockIDKeep,FCyID,FSetID,FCIQNumber,'+

					'ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FARAccountID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FAPAccountID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FOtherAPAcctID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FOtherARAcctID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FPayTaxAcctID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FpreAcctID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FPreAPAcctID)),0),
					'+
					'FfavorPolicy,0,0,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,FminForeReceiveRate,FminReserverate,'+
					'FdebtLevel,FPayCondition,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,FShortNumber,FNumber,FName,'+
					'isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+
					cast(@pp2 as varchar(10))+' from t_Organization t where FItemID='+@FItemID		
				exec (@sql) 
					
				set @Sql='IF not exists(Select * from '+ @DBName+'.dbo.Access_t_Organization where FItemID='+ cast(@pp2 as varchar(10))+')' +
					'Insert into '+ @DBName+'.dbo.Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
					select '+ cast(@pp2 as varchar(10))+',isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item 
					where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200))
					from t_item t where FItemID='+@FItemID	 
				exec (@sql)	


				set @Sql=' update  '+ @DBName+'..t_Item set FName=FName where FItemID=' + cast(@pp2 as varchar(10))
				exec (@sql)
				
				set @Sql='IF not exists(Select * from '+ @DBName+'.dbo.Access_t_Organization where FItemID='+ cast(@pp2 as varchar(10))+')' +
					'Insert into '+ @DBName+'.dbo.Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
					select '+ cast(@pp2 as varchar(10))+',isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item 
					where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200))
					from t_item t where FItemID='+@FItemID	 
				exec (@sql)	
				
			end

		end
		-----1. 添加 end ----
		
		-----2.修改 ----
		if EXISTS (SELECT 1 FROM Inserted)  and EXISTS (SELECT 1 FROM deleted )  
		BEGIN 
			set @InsertSQL='Insert into ' +@DBName+'.dbo.t_Organization (FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+
			'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FIsCreditMgr,FSaleMode,FValueAddRate,FCountry,FHomePage,'+
			'Fcorperate,FCarryingAOS,FTypeID,FSaleID,FStockIDKeep,FCyID,FSetID,FCIQNumber,'+
			'FARAccountID,FAPAccountID,FOtherAPAcctID,FOtherARAcctID,FPayTaxAcctID,FpreAcctID,FPreAPAcctID,'+
			'FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+
			'FminForeReceiveRate,FminReserverate,FdebtLevel,FPayCondition,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,FShortNumber,FNumber,FName,'+
			'FParentID,FItemID) ' 
			set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '
			
			select @FItemID = FItemID,@FNumber=FNumber,@FParentID=FParentID from deleted
			select @NewFNumber=FNumber from inserted
			
			set @pp2=0
			set @nSQL=' select @p2=FItemID from  '+ @DBName+'.dbo.t_Organization where  FNumber='+''''+@FNumber+''''
			exec sp_executesql  @nSQL ,N'@p2   int   output ',@pp2   output
	
			if @pp2 > 0
			begin 
			
				set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=1 and FItemID=' + cast(@pp2 as varchar(10))
				exec (@sql)

				set @Sql= 'delete from '+@DBName+'.dbo.t_Organization where FItemID=' + cast(@pp2 as varchar(10))
				exec (@sql)
			  
			  
				set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+
					@DBName+'.dbo.T_Item where FItemClassID=1 and Fnumber=(select FNumber from T_Item where FItemID='+@FParentID+')),0),'+ cast(@pp2 as varchar(10)) + ' from T_Item where FITemID='+@FItemID
				exec (@SQL)	

				set @Sql = @InsertSQL + ' select FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,FMobilePhone,FFax,FPostalCode,FEmail,'+
					'FBank,FAccount,FTaxNum,FIsCreditMgr,FSaleMode,FValueAddRate,FCountry,FHomePage,Fcorperate,FCarryingAOS,FTypeID,FSaleID,'+
					'FStockIDKeep,FCyID,FSetID,FCIQNumber,'+

					'ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FARAccountID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FAPAccountID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FOtherAPAcctID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FOtherARAcctID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FPayTaxAcctID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FpreAcctID)),0),
					 ISNULL((select FAccountID from '+ @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FPreAPAcctID)),0),
					'+
					'FfavorPolicy,0,0,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,FminForeReceiveRate,FminReserverate,'+
					'FdebtLevel,FPayCondition,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,FShortNumber,FNumber,FName,'+
					'isnull((select top 1 FItemID as FParentID from '+
					@DBName+'.dbo.T_Item where FItemClassID=1 and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+ cast(@pp2 as varchar(10)) +
					' from t_Organization t where FItemID='+@FItemID		
				
				exec (@sql) 

				set @Sql=' update  '+ @DBName+'..t_Item set FName=FName where FItemID=' + cast(@pp2 as varchar(10))
				exec (@sql)
			
				set @Sql='IF not exists(Select * from '+ @DBName+'.dbo.Access_t_Organization where FItemID='+ cast(@pp2 as varchar(10))+')' +
					'Insert into '+ @DBName+'.dbo.Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
					select '+ cast(@pp2 as varchar(10))+',isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item 
					where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200))
					from t_item t where FItemID='+@FItemID	 
				exec (@sql)	
				
			end
		end
		-----2.修改 end ----
		
		
		-----3. 删除----
		IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
		begin 
			select @FItemID = FItemID,@FNumber=FNumber from deleted
				
			set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=1 and  FNumber=''' + @FNumber + ''''
			exec (@sql)
			set @Sql= 'delete from '+@DBName+'.dbo.t_Organization where FNumber=''' + @FNumber + ''''
			exec (@sql)
			
		end
		-----3. 删除 End ----

	


		end
		
END

