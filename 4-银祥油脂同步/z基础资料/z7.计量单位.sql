
-- =============================================
-- Author:opco
-- Create date: 
-- Description:	synchro-计量单位同步
-- =============================================
ALTER TRIGGER [dbo].[yj_t_measureunit] ON [dbo].[t_measureunit]
    FOR INSERT, UPDATE, DELETE
AS
    DECLARE @FItemID VARCHAR(10)
    DECLARE @FNumber VARCHAR(100)
    DECLARE @DBName VARCHAR(100)
    DECLARE @Sql VARCHAR(4000)
    DECLARE @InsertSQL VARCHAR(4000)
    DECLARE @T_ItemSQL VARCHAR(4000)
    DECLARE @FParentID VARCHAR(50)			---- FParentID=FUnitGroupID
    DECLARE @IsHere VARCHAR(10)
    DECLARE @FDetail VARCHAR(10)
    DECLARE @NewFnumber VARCHAR(50)
--declare @FItemidTemp varchar(50)
    DECLARE @nSql NVARCHAR(4000)
    DECLARE @pp2 INT
    BEGIN    
        SELECT  @DBName = FDBName
        FROM    t_BOS_Synchro
        WHERE   FK3Name = '帐套同步'
        IF LEN(@DBName) > 0 
            BEGIN	
                SET @InsertSQL = 'Insert into ' + @DBName
                    + '.dbo.t_measureunit (FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,FUnitGroupID,FParentID,FMeasureUnitID,FItemID) ' 
                SET @T_ItemSQL = 'Insert into ' + @DBName
                    + '.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '

		
		-----1. 添加    
                IF EXISTS ( SELECT  *
                            FROM    Inserted )
                    AND ( NOT EXISTS ( SELECT   *
                                       FROM     deleted )
                        ) 
                    BEGIN

                        SELECT  @FNumber = FNumber ,
                                @FParentID = FParentID
                        FROM    inserted
			
                        SET @pp2 = 0
                        SET @nSQL = ' select @p2=FItemID from  ' + @DBName
                            + '.dbo.t_measureunit where  FNumber=' + ''''
                            + @FNumber + ''''
                        EXEC sp_executesql @nSQL, N'@p2   int   output ',
                            @pp2 OUTPUT

                        IF @pp2 = 0 
                            BEGIN
                                SET @nSQL = ' exec ' + @DBName
                                    + '.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
                                EXEC sp_executesql @nSQL,
                                    N'@p2   int   output ', @pp2 OUTPUT

                                SET @Sql = @T_ItemSQL
                                    + 'select 7,2,FName,FNumber,FShortNumber,FShortNumber,1,UUID,0,isnull((select top 1 FItemID as FParentID from '
                                    + @DBName
                                    + '.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='
                                    + @FParentID + ')),0),'
                                    + CAST(@pp2 AS VARCHAR(10))
                                    + ' from t_measureunit where  FNumber='
                                    + '''' + @FNumber + ''''
                                EXEC (@Sql)  
		  
                                SET @Sql = @InsertSQL
                                    + ' select FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,isnull((select  top 1 FUnitGroupID as FUnitGroupID from '
                                    + @DBName
                                    + '.dbo.t_UnitGroup where FName=(select top 1 FName from t_UnitGroup where FUnitGroupID='
                                    + @FParentID + ')),0),'
                                    + ' isnull((select top 1 FItemID as FParentID from '
                                    + @DBName
                                    + '.dbo.T_Item where FNumber=(select top 1 FNumber from T_Item where FItemID='
                                    + @FParentID + ')),0),'
                                    + CAST(@pp2 AS VARCHAR(10)) + ','
                                    + CAST(@pp2 AS VARCHAR(10))
                                    + ' from t_measureunit where FNumber='
                                    + '''' + @FNumber + ''''	
                                EXEC (@sql)

                                IF NOT EXISTS ( SELECT  *
                                                FROM    t_measureunit
                                                WHERE   FParentID = @FParentID
                                                        AND FNumber <> @FNumber ) 
                                    BEGIN 
                                        SET @Sql = 'update ' + @DBName
                                            + '.dbo.t_measureunit set FStandard=1  where FNumber='
                                            + '''' + @FNumber + ''''
                                        EXEC (@sql)
                                    END
                            END
	
                    END
        
		-----2.修改
                IF EXISTS ( SELECT  1
                            FROM    Inserted )
                    AND EXISTS ( SELECT 1
                                 FROM   deleted ) 
                    BEGIN    
                        SELECT  @FItemID = FItemID ,
                                @FNumber = FNumber ,
                                @FParentID = FParentID
                        FROM    deleted
		
                        SELECT  @FParentID = FParentID ,
                                @FDetail = FDetail
                        FROM    t_Item
                        WHERE   FItemID = @FItemID
                        IF @FDetail = '1' --插入到t_measureunit和t_item
                            BEGIN
			
                                SET @pp2 = 0
                                SET @nSQL = ' select @p2=FItemID from  '
                                    + @DBName
                                    + '.dbo.t_measureunit where  FNumber='
                                    + '''' + @FNumber + ''''
                                EXEC sp_executesql @nSQL,
                                    N'@p2   int   output ', @pp2 OUTPUT
	
                                IF @pp2 > 0 
                                    BEGIN
					------删除
                                        SET @Sql = 'delete from ' + @DBName
                                            + '.dbo.T_Item where  FItemID='
                                            + CAST(@pp2 AS VARCHAR(10))
                                        EXEC (@sql)

                                        SET @Sql = 'delete from ' + @DBName
                                            + '.dbo.t_measureunit where FItemID='
                                            + CAST(@pp2 AS VARCHAR(10))
                                        EXEC (@sql)
			  
					-------插入
                                        SET @InsertSQL = 'Insert into '
                                            + @DBName
                                            + '.dbo.t_measureunit (FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,FUnitGroupID,FParentID,FMeasureUnitID,FItemID,FDeleted) ' 
                                        SET @Sql = @T_ItemSQL
                                            + 'select 7,2,FName,FNumber,FShortNumber,FShortNumber,1,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '
                                            + @DBName
                                            + '.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='
                                            + @FParentID + ')),0),'
                                            + CAST(@pp2 AS VARCHAR(10))
                                            + ' from t_measureunit where  FItemID='
                                            + @FItemID
                                        EXEC (@Sql)

                                        SET @Sql = @InsertSQL
                                            + ' select FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,isnull((select  top 1 FUnitGroupID as FUnitGroupID from '
                                            + @DBName
                                            + '.dbo.t_UnitGroup where FName=(select top 1 FName from t_UnitGroup where FUnitGroupID='
                                            + @FParentID + ')),0),'
                                            + ' isnull((select top 1 FItemID as FParentID from '
                                            + @DBName
                                            + '.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='
                                            + @FParentID + ')),0),'
                                            + CAST(@pp2 AS VARCHAR(10)) + ','
                                            + CAST(@pp2 AS VARCHAR(10))
                                            + ',FDeleted  from t_measureunit where FItemID='
                                            + @FItemID
                                        EXEC (@sql)
                                    END
				
                            END

			
                    END
	
		-----3. 删除
                IF EXISTS ( SELECT  *
                            FROM    Deleted )
                    AND ( NOT EXISTS ( SELECT   *
                                       FROM     Inserted )
                        ) 
                    BEGIN 
                        SELECT  @FItemID = FItemID ,
                                @FNumber = FNumber
                        FROM    deleted
		
                        SET @Sql = 'delete from ' + @DBName
                            + '.dbo.t_measureunit where Fnumber=' + ''''
                            + @FNumber + ''''
                        EXEC (@sql)
			
                    END
		
            END
    END

