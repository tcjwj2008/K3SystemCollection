 
ALTER TRIGGER [dbo].[trg_t_Emp_InsUptDel] ON [dbo].[t_Emp]
    INSTEAD OF INSERT, UPDATE, DELETE
AS
    DECLARE @FItemID VARCHAR(10)
    DECLARE @FNumber VARCHAR(100)
    DECLARE @DBName VARCHAR(100)
    DECLARE @Sql VARCHAR(4000)
    DECLARE @InsertSQL VARCHAR(2000)
    DECLARE @T_ItemSQL VARCHAR(2000)
    DECLARE @IsHere VARCHAR(10)
    DECLARE @FDetail VARCHAR(10)
    DECLARE @FParentID VARCHAR(50)
    DECLARE @FItemidTemp VARCHAR(50)
 
    DECLARE @NewFNumber VARCHAR(50)
    DECLARE @FDepartmentID VARCHAR(50)
    DECLARE @nSql NVARCHAR(4000)
    DECLARE @pp2 INT


        
    BEGIN
        BEGIN TRANSACTION  
        SET NOCOUNT ON
        DECLARE @ERROR INT
        SET @ERROR = 0
        IF EXISTS ( SELECT  1
                    FROM    Deleted ) 
            BEGIN
                DELETE  t_Base_Emp
                FROM    t_Base_Emp
                        INNER JOIN Deleted ON t_Base_Emp.FItemID = Deleted.FItemID
                SET @ERROR = @ERROR + @@ERROR
                DELETE  HR_Base_Emp
                FROM    HR_Base_Emp
                        INNER JOIN ( SELECT FItemID
                                     FROM   Deleted
                                     WHERE  NOT EXISTS ( SELECT
                                                              FItemID
                                                         FROM Inserted
                                                         WHERE
                                                              Deleted.FItemID = Inserted.FItemID )
                                   ) t1 ON HR_Base_Emp.FItemID = t1.FItemID
                SET @ERROR = @ERROR + @@ERROR
                UPDATE  HR_Base_User
                SET     FEmpID = NULL
                WHERE   FEmpID NOT IN ( SELECT  EM_ID
                                        FROM    HR_Base_Emp )
                SET @ERROR = @ERROR + @@ERROR
            END
        IF EXISTS ( SELECT  1
                    FROM    Inserted ) 
            BEGIN
                INSERT  INTO t_Base_Emp
                        ( FItemID ,
                          FAddress ,
                          FAllotPercent ,
                          FBankAccount ,
                          FBankID ,
                          FBirthday ,
                          FBrNO ,
                          FCreditAmount ,
                          FCreditDays ,
                          FCreditLevel ,
                          FCreditPeriod ,
                          FDegree ,
                          FDeleted ,
                          FDepartmentID ,
                          FDuty ,
                          FEmail ,
                          FEmpGroup ,
                          FEmpGroupID ,
                          FGender ,
                          FHireDate ,
                          FID ,
                          FIsCreditMgr ,
                          FItemDepID ,
                          FJobTypeID ,
                          FLeaveDate ,
                          FMobilePhone ,
                          FName ,
                          FNote ,
                          FNumber ,
                          FOperationGroup ,
                          FOtherAPAcctID ,
                          FOtherARAcctID ,
                          FParentID ,
                          FPhone ,
                          FPreAPAcctID ,
                          FPreARAcctID ,
                          FProfessionalGroup ,
                          FShortNumber
                        )
                        SELECT  FItemID ,
                                FAddress ,
                                ISNULL(FAllotPercent, 0) ,
                                FBankAccount ,
                                ISNULL(FBankID, 0) ,
                                FBirthday ,
                                ISNULL(FBrNO, '0') ,
                                FCreditAmount ,
                                FCreditDays ,
                                ISNULL(FCreditLevel, 0) ,
                                ISNULL(FCreditPeriod, 0) ,
                                FDegree ,
                                ISNULL(FDeleted, 0) ,
                                FDepartmentID ,
                                FDuty ,
                                FEmail ,
                                FEmpGroup ,
                                ISNULL(FEmpGroupID, 0) ,
                                ISNULL(FGender, 1068) ,
                                FHireDate ,
                                FID ,
                                ISNULL(FIsCreditMgr, 0) ,
                                ISNULL(FItemDepID, 0) ,
                                ISNULL(FJobTypeID, 0) ,
                                FLeaveDate ,
                                FMobilePhone ,
                                FName ,
                                FNote ,
                                FNumber ,
                                ISNULL(FOperationGroup, 0) ,
                                ISNULL(FOtherAPAcctID, 0) ,
                                ISNULL(FOtherARAcctID, 0) ,
                                FParentID ,
                                FPhone ,
                                ISNULL(FPreAPAcctID, 0) ,
                                ISNULL(FPreARAcctID, 0) ,
                                ISNULL(FProfessionalGroup, 0) ,
                                FShortNumber
                        FROM    Inserted
                INSERT  INTO Access_t_emp
                        ( FItemID ,
                          FParentIDX ,
                          FDataAccessDelete ,
                          FDataAccessEdit ,
                          FDataAccessView
                        )
                        SELECT  t1.FItemID ,
                                0 ,
                                t3.FDataAccessDelete ,
                                t3.FDataAccessEdit ,
                                t3.FDataAccessView
                        FROM    Inserted t1
                                LEFT JOIN Access_t_emp t2 ON t1.FItemiD = t2.FItemID
                                LEFT JOIN Access_t_emp t3 ON t3.FItemID = 0
                        WHERE   t2.FItemID IS NULL
                SET @ERROR = @ERROR + @@ERROR
                UPDATE  HR_Base_Emp
                SET     Name = Inserted.FName ,
                        Sex = CASE Inserted.FGender
                                WHEN 1068 THEN 1
                                WHEN 1069 THEN 2
                                ELSE 0
                              END ,
                        Birthday = Inserted.FBirthDay ,
                        Mobile = Inserted.FMobilePhone ,
                        IDCardID = Inserted.FID ,
                        EMail = Inserted.FEMail
                FROM    HR_Base_Emp ,
                        Inserted
                WHERE   HR_Base_Emp.FItemID = Inserted.FItemID
                        AND Inserted.FItemID IN (
                        SELECT  Inserted.FItemID
                        FROM    Deleted ,
                                Inserted
                        WHERE   Deleted.FItemID = Inserted.FItemID )
                SET @ERROR = @ERROR + @@ERROR
                INSERT  INTO HR_Base_Emp
                        ( FItemID ,
                          Name ,
                          Sex ,
                          Birthday ,
                          Mobile ,
                          IDCardID ,
                          EMail ,
                          EM_ID
                        )
                        SELECT  FItemID ,
                                FName ,
                                CASE FGender
                                  WHEN 1068 THEN 1
                                  WHEN 1069 THEN 2
                                  ELSE 0
                                END ,
                                FBirthDay ,
                                FMobilePhone ,
                                FID ,
                                FEMail ,
                                NEWID()
                        FROM    Inserted
                        WHERE   FItemID NOT IN (
                                SELECT  Inserted.FItemID
                                FROM    Deleted ,
                                        Inserted
                                WHERE   Deleted.FItemID = Inserted.FItemID )
                SET @ERROR = @ERROR + @@ERROR
            END
            
            
            
            
          ---- 1. 添加 ----      
        IF EXISTS ( SELECT  1
                    FROM    Inserted )
            AND ( NOT EXISTS ( SELECT   1
                               FROM     deleted )
                ) 
            BEGIN    
                SELECT  @DBName = FDBName
                FROM    t_BOS_Synchro
                WHERE   FK3Name = '帐套同步'
                IF LEN(@DBName) > 0 
                    BEGIN
                        SET @InsertSQL = 'Insert into ' + @DBName
                            + '.dbo.t_Emp (FEmpGroup,FGender,FBirthDay,FDegree,FPhone,FMobilePhone,FID,FDuty,'
                            + 'FHireDate,FLeaveDate,FBankAccount,FAddress,FEmail,FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,'
                            + 'FAllotPercent,FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,FDepartmentID,FParentID,FItemID)  ' 
                        SET @T_ItemSQL = 'Insert into ' + @DBName
                            + '.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '
			
                        SELECT  @FItemID = FItemID ,
                                @FNumber = FNumber ,
                                @FDepartmentID = FDepartmentID
                        FROM    inserted
                        SELECT  @FParentID = FParentID ,
                                @FDetail = FDetail
                        FROM    t_Item
                        WHERE   FNumber = @FNumber
		 
		 
                        SET @pp2 = 0
                        SET @nSQL = ' select @p2=FItemID from  ' + @DBName
                            + '.dbo.t_Emp where  FNumber=' + '''' + @FNumber
                            + ''''
                        EXEC sp_executesql @nSQL, N'@p2   int   output ',
                            @pp2 OUTPUT
			
                        IF @pp2 = 0			--插入到t_Emp和t_item
                            BEGIN

                                SET @nSql = ' exec ' + @DBName
                                    + '.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
                                EXEC sp_executesql @nSql,
                                    N'@p2   int   output ', @pp2 OUTPUT
				
                                SET @Sql = 'Insert into ' + @DBName
                            + '.dbo.t_item (FFullName,FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '
                                    + 'select FName as FFullName,FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '
                                    + @DBName
                                    + '.dbo.T_Item where FItemClassID=3 and Fnumber=(select top 1 FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0),'
                                    + CAST(@pp2 AS VARCHAR(10))
                                    + ' from T_Item  t where FITemID='
                                    + @FItemID
                                EXEC (@SQL)	
			  
                                SET @Sql = @InsertSQL
                                    + ' select  FEmpGroup,FGender,FBirthDay,FDegree,FPhone,FMobilePhone,FID,FDuty,'
                                    + 'FHireDate,FLeaveDate,FBankAccount,FAddress,FEmail,FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,'
                                    + 'FAllotPercent,FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,'
                                    + 'isnull((select FItemID from ' + @DBName
                                    + '.dbo.t_department where Fnumber=(select FNumber from t_department where FItemID=t.FDepartmentID)),0),'
                                    + 'isnull((select FItemID as FParentID from '
                                    + @DBName
                                    + '.dbo.T_Item where FItemClassID=3 and Fnumber=(select FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0),'
                                    + CAST(@pp2 AS VARCHAR(10))
                                    + ' from t_Emp t where FItemID='
                                    + @FItemID		
                                EXEC (@sql) 
                                
                                
                    --                                           SET @Sql = 'update ' + @DBName
                    --+ '.dbo.T_Item set FFullName=FName where FItemClassID=3 and   FITemID='
                    --                + @FItemID
                    --EXEC (@sql)   
                            END
			
			
                    END

            END
	
	
	-----2.修改 ----
        IF EXISTS ( SELECT  1
                    FROM    Inserted )
            AND EXISTS ( SELECT 1
                         FROM   deleted ) 
            BEGIN    
                SELECT  @DBName = FDBName
                FROM    t_BOS_Synchro
                WHERE   FK3Name = '帐套同步'
                IF LEN(@DBName) > 0 
                    BEGIN
                        SET @InsertSQL = 'Insert into ' + @DBName
                            + '.dbo.t_Emp (FEmpGroup,FGender,FBirthDay,FDegree,FPhone,FMobilePhone,FID,FDuty,'
                            + 'FHireDate,FLeaveDate,FBankAccount,FAddress,FEmail,FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,'
                            + 'FAllotPercent,FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,FDepartmentID,FParentID,FItemID)  ' 
                        SET @T_ItemSQL = 'Insert into ' + @DBName
                            + '.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '

                        SET @T_ItemSQL = 'Insert into ' + @DBName
                            + '.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '
		
                        SELECT  @FItemID = FItemID ,
                                @FNumber = FNumber
                        FROM    deleted
                        SELECT  @NewFNumber = FNumber ,
                                @FDepartmentID = FDepartmentID
                        FROM    inserted
		
			 
                        SET @pp2 = 0
                        SET @nSQL = ' select @p2=FItemID from  ' + @DBName
                            + '.dbo.t_Emp where  FNumber=' + '''' + @FNumber
                            + ''''
                        EXEC sp_executesql @nSQL, N'@p2   int   output ',
                            @pp2 OUTPUT
		

                        IF @pp2 > 0 
                            BEGIN
                                SET @Sql = 'delete from ' + @DBName
                                    + '.dbo.T_Item where FItemClassID=3 and FItemID='
                                    + CAST(@pp2 AS VARCHAR(10))
                                EXEC (@sql)
			
                                SET @Sql = 'delete from ' + @DBName
                                    + '.dbo.t_Emp where  FItemID='
                                    + CAST(@pp2 AS VARCHAR(10))
                                EXEC (@sql)

                                SET @Sql = 'Insert into ' + @DBName
                            + '.dbo.t_item (FFullName,FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '
                                    + 'select FFullName,FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '
                                    + @DBName
                                    + '.dbo.T_Item where FItemClassID=3 and Fnumber=(select FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0),'
                                    + CAST(@pp2 AS VARCHAR(10))
                                    + ' from T_Item  t where FITemID='
                                    + @FItemID
                                EXEC (@SQL)	

                                SET @Sql = @InsertSQL
                                    + ' select  FEmpGroup,FGender,FBirthDay,FDegree,FPhone,FMobilePhone,FID,FDuty,'
                                    + 'FHireDate,FLeaveDate,FBankAccount,FAddress,FEmail,FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,'
                                    + 'FAllotPercent,FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,'
                                    + 'isnull((select FItemID from ' + @DBName
                                    + '.dbo.t_department where Fnumber=(select FNumber from t_department where FItemID=t.FDepartmentID)),0),'
                                    + 'isnull((select FItemID as FParentID from '
                                    + @DBName
                                    + '.dbo.T_Item where FItemClassID=3 and Fnumber=(select FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0),'
                                    + CAST(@pp2 AS VARCHAR(10))
                                    + ' from t_Emp t where FItemID='
                                    + @FItemID		
                                EXEC (@sql) 
                                
                    --                          SET @Sql = 'update ' + @DBName
                    --+ '.dbo.T_Item set FFullName=FName where FItemClassID=3 and   FITemID='
                    --                + @FItemID
                    --EXEC (@sql)  
					   
                            END
		
                    END	
           
            END
	           
        
				
		-----3. 删除 ----
        IF EXISTS ( SELECT  *
                    FROM    Deleted )
            AND ( NOT EXISTS ( SELECT   *
                               FROM     Inserted )
                ) 
            BEGIN 
                            SELECT  @DBName = FDBName
                FROM    t_BOS_Synchro
                WHERE   FK3Name = '帐套同步'
                
                SELECT  @FItemID = FItemID ,
                        @FNumber = FNumber
                FROM    deleted
		 
		 
                SET @Sql = 'delete from ' + @DBName
                    + '.dbo.T_Item where FItemClassID=3 and  FNumber='''
                    + @FNumber + ''''
                
                EXEC (@sql)
                SET @Sql = 'delete from ' + @DBName
                    + '.dbo.t_Emp where FNumber=''' + @FNumber + ''''
             
                EXEC (@sql)
                
          
		
            END
		-----3. 删除 End ----
		
		            
            
            
            
        IF ( @ERROR <> 0 ) 
            ROLLBACK TRANSACTION
        ELSE 
        
            COMMIT TRANSACTION
                
                
    END
    
 