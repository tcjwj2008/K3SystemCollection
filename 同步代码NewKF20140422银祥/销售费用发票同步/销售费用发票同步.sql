--USE AIS_YZy_Test
--���۷��÷�Ʊ
--ICExpenses
--ICExpensesEntry
SELECT * FROM  t_rp_contact

--EXEC SPK3_2STR 'ICExpenses'
---- һ ����ֶ� ���������������׵Ĺ�����ϵ
--ALTER TABLE ICExpenses ADD FSynchroID varchar(50) NULL
---- �� ���ͬ��������
USE AIS_YXYZ

DROP   TRIGGER [dbo].[TR_ICExpenses_Update]
            ON [dbo].[ICExpenses]
FOR Update
AS 
declare @DBName varchar(50)
declare @FCheckerID bigint
declare @FInterID varchar(50)
DECLARE @FRecBillInterID BIGINT 
declare @FTranType varchar(50)		--�������� 77-���÷�Ʊ��78�����۷��÷�Ʊ                                                                                                                                                                                                                                              
declare @FSynchroID varchar(50)
DECLARE @FCurCheckLevel INT --��ǰ��˼���
declare @sql varchar(4000)
declare @SFinterid INT  --�µ�����
declare @SFBillNo varchar(50)--�µ��ݺ�
declare @nSql nvarchar(4000)
DECLARE @FStatus INT 
declare @FLastChecker bigint --Ҫͬ���������
DECLARE @LastCheckLevel INTEGER --��ߵ���˼���
begin 
 	BEGIN TRANSACTION --����ʼ 
	SET NOCOUNT ON
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='����ͬ��'
	select @FInterID =FInterID,@FTranType=FTranType,@FCurCheckLevel=FCurCheckLevel,@FRecBillInterID=FRecBillInterID ,@FStatus=FStatus,@FSynchroID=ISNULL(FSynchroID,'0') from inserted  where FTranType =78
	--�õ�Ҫͬ���������
	  --select *  from t_YXSetEntry
	select @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=14
	--�õ���ߵ���˼���
	--Select ISNULL(FMaxCheckLevel,0) from t_MultiCheckOption where FBillType=78
	Select @LastCheckLevel=ISNULL(FMaxCheckLevel,0) from t_MultiCheckOption where FBillType=@FTranType
	IF @LastCheckLevel=2
	SELECT @FCheckerID=ISNULL(FMultiCheckLevel2,0)  FROM ICExpenses WHERE FInterID=@FInterID
	IF @LastCheckLevel=3
	SELECT @FCheckerID=ISNULL(FMultiCheckLevel3,0)  FROM ICExpenses WHERE FInterID=@FInterID
	IF @LastCheckLevel=4
	SELECT @FCheckerID=ISNULL(FMultiCheckLevel4,0)  FROM ICExpenses WHERE FInterID=@FInterID
	IF @LastCheckLevel=5
	SELECT @FCheckerID=ISNULL(FMultiCheckLevel5,0)  FROM ICExpenses WHERE FInterID=@FInterID
	IF @LastCheckLevel=6
	SELECT @FCheckerID=ISNULL(FMultiCheckLevel6,0)  FROM ICExpenses WHERE FInterID=@FInterID
	--SELECT FCurCheckLevel FROM 	ICExpenses WHERE FInterID=1043
	--���ͬ�����ײ�Ϊ�� ���Ҹ�����˼���Ϊ��߼����������=ͬ����
	--�����ͬ�����ײ������
	if (len(@DBName) > 0) and UPDATE(FCurCheckLevel) 
    and @FCheckerID >0 and @FStatus=1  AND  @FSynchroID='0'
	and  @FLastChecker=@FCheckerID AND @FCurCheckLevel=@LastCheckLevel
	begin 
       --ȡ�ñ��--ȡ������
      SET  @SFinterid=0  --�µ�����
      SET  @SFBillNo=''--�µ��ݺ�
      --EXEC  GetICMaxNum 'ICExpenses',@FInterID output,1,16394
      --EXEC p_GetICBillNo '78',@FBillNo OUTPUT 
      declare @BNoSql nvarchar(300)
        set @BNoSql =' exec '+ @DBName+'.dbo.p_GetICBillNo  ''78'',@FBillNo OUTPUT '
		exec sp_executesql  @BNoSql ,N'@FBillNo  nvarchar(50)   output ',@SFBillNo   output
		set @BNoSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''ICExpenses'',@FInterID output,1,16394'
		exec sp_executesql  @BNoSql ,N'@FInterID   int   output ',@SFinterid OUTPUT
		--����
		set @sql = 
			' insert into ' + @DBName + '.dbo.ICExpensesEntry (FInterID,FEntryID,FBrNo,FSourceEntryID,FItemID,FUnitID,FAuxQty,FAuxPrice,FAmount,FStdAmount,FTaxRate,FTaxAmount,FStdTaxAmount,FNote) '+
            ' SELECT '+CONVERT(VARCHAR(100),@SFinterid)+',FEntryID,FBrNo,FSourceEntryID,FItemID,FUnitID,FAuxQty,FAuxPrice,FAmount,FStdAmount,FTaxRate,FTaxAmount,FStdTaxAmount,FNote '+
            ' FROM ICExpensesEntry  WHERE FInterID='+CONVERT(VARCHAR(100),@FInterID)
             --VALUES (1043,1,'0',0,576,'��',0,0,100,100,6,6,6,'') 
         SET @sql=@sql +' insert into ' + @DBName + '.dbo.ICExpenses(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FVchInterID,FROB,FDate,FInvType,FSaleStyle,FPOStyle,FCustID,FSupplyID,FCurrencyID,FExchangeRate,FAcctID,FRSCBillInterID,FDeptID,FEmpID,FCheckDate,FYearPeriod,FBillerID,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FPayBillInterID,FRecBillInterID,FInvoiceInterID,FCussentAcctID,FSettleDate,FCheckerID) '+
             ' SELECT '+CONVERT(VARCHAR(100),@SFinterid)+','''+@SFBillNo+''',FBrNo,FTranType,FCancellation,FStatus,FVchInterID,FROB,FDate,FInvType,FSaleStyle,FPOStyle,FCustID,FSupplyID,FCurrencyID,FExchangeRate,FAcctID,FRSCBillInterID,FDeptID,FEmpID,FCheckDate,FYearPeriod,FBillerID,null,null,null,null,null,null,null,null,null,null,null,null,FPayBillInterID,0,FInvoiceInterID,FCussentAcctID,FSettleDate,FMultiCheckLevel1 '+
                ' from   ICExpenses WHERE FInterID='+CONVERT(VARCHAR(100),@FInterID)
         --VALUES (1043,'XEXPENSE000019','0',78,0,0,0,1,'2014-06-12',12521,101,0,195,0,1,1,0,'',1858,645,Null,'',16394,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,0,0,'',1162,'2014-06-12')
         exec(@sql)--���������¼
         ---- ����t_RP_ARPBill
           --ȡ�ñ��--ȡ������
           DECLARE @PFinterid BIGINT
           DECLARE  @PFBillNo varchar(100)
      SET  @PFinterid=0  --�µ�����
      SET  @PFBillNo=''--�µ��ݺ�
      --EXEC  GetICMaxNum 'ICExpenses',@FInterID output,1,16394
      --EXEC p_GetICBillNo '78',@FBillNo OUTPUT 
     -- declare @BNoSql nvarchar(300)
        set @BNoSql =' exec '+ @DBName+'.dbo.p_GetICBillNo  ''1000021'',@FBillNo OUTPUT '
		exec sp_executesql  @BNoSql ,N'@FBillNo  nvarchar(50)   output ',@PFBillNo   output
		set @BNoSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''t_RP_ARPBill'',@FInterID output,1,16394'
		exec sp_executesql  @BNoSql ,N'@FInterID   int   output ',@PFinterid OUTPUT
		--����t_RP_ARPBill
		SET @Sql=' insert into ' + @DBName + '.dbo.'+
		't_RP_ARPBill (FRP,FYear,FPeriod,FDate,FBillID,FNumber,FBillType,FCustomer,FDepartment,FEmployee,FAccountID,FCurrencyID,FExchangeRate,FAmount,FAmountFor,FExplanation,FRPDate,FPreparer,FAdjustExchangeRate,FSource,FSourceID,FItemClassID,FfincDate,FClassTypeID,FRemainAmountFor,FRemainAmount) '+
		' SELECT FRP,FYear,FPeriod,FDate,'+CONVERT(VARCHAR(100),@PFinterid)+','''+@PFBillNo+''',FBillType,FCustomer,FDepartment,FEmployee,FAccountID,FCurrencyID,FExchangeRate,FAmount,FAmountFor,''���Ϊ��'+@SFBillNo+'���ķ��÷�Ʊ'',FRPDate,FPreparer,FAdjustExchangeRate,FSource,'+CONVERT(VARCHAR(100),@SFinterid)+',FItemClassID,FfincDate,FClassTypeID,FRemainAmountFor,FRemainAmount '+
		' FROM t_RP_ARPBill WHERE FBillID='+CONVERT(VARCHAR(100),@FRecBillInterID)
		SET @Sql=@Sql+' INSERT INTO ' + @DBName + '.dbo.t_rp_arpbillEntry (FBillID,FEntryID,FAmount,FAmountFor,FRemainAmountFor,FRemainAmount,FCheckAmountFor,FCheckAmount)'+
		' SELECT '+CONVERT(VARCHAR(100),@PFinterid)+',FEntryID,FAmount,FAmountFor,FRemainAmountFor,FRemainAmount,FCheckAmountFor,FCheckAmount FROM t_rp_arpbillEntry WHERE FBillID='+CONVERT(VARCHAR(100),@FRecBillInterID)
		exec(@sql)--���������¼��
		--
		SET @Sql= ' insert into ' + @DBName +
		'.dbo.t_RP_Contact (FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FCustomer,FDepartment,FEmployee,FCurrencyID,FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPBillID,FBillID,FRPDate,FBillType,finvoicetype,FItemClassID,FExplanation,FPreparer)'+ 
        ' SELECT FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FCustomer,FDepartment,FEmployee,FCurrencyID,FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,'+CONVERT(VARCHAR(100),@PFinterid)+',FBillID,FRPDate,FBillType,finvoicetype,FItemClassID,''���Ϊ��'+@SFBillNo+'���ķ��÷�Ʊ'',FPreparer '+
        ' FROM t_RP_Contact WHERE FRPBillID='+ CONVERT(VARCHAR(100),@FRecBillInterID)
		exec(@sql)--����
        SET @Sql= ' insert into ' + @DBName +
		'.dbo.t_RP_Plan_Ar (FBillID,FEntryID,FOrgID,FDate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FRP) '+ 
        ' SELECT '+CONVERT(VARCHAR(100),@PFinterid)+',FEntryID,FOrgID=(SELECT fid FROM '+@DBName+'.dbo.t_RP_Contact WHERE FRPBillID='+CONVERT(VARCHAR(100),@PFinterid)+')'+
        ',FDate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FRP FROM t_RP_Plan_Ar WHERE  FBillID='+CONVERT(VARCHAR(100),@FRecBillInterID)
         
         exec(@sql)--����
         SET @Sql= ' UPDATE ' + @DBName +'.dbo.ICExpenses SET FRecBillInterID='+CONVERT(VARCHAR(100),@PFinterid) +' WHERE FInterID='+CONVERT(VARCHAR(100),@SFinterid)
         exec(@sql)
        UPDATE ICExpenses SET FSynchroID=CONVERT(VARCHAR(50),@SFinterid) WHERE finterid=CONVERT(INT,@FInterID)
       
       --���
       
--       Update ICExpenses Set FMultiCheckLevel1 = FMultiCheckLevel1, FMultiCheckDate1 = FMultiCheckDate1, FCurCheckLevel = (Case When 1 < FCurCheckLevel Then FCurCheckLevel Else 1 End)  Where FInterID = 1043 And FTranType =78
--       update t_RP_ARPBill set FChecker=16394 ,fcheckdate=getdate()  ,FStatus=FStatus | 1 where FBillID=1945; 
--       update t_RP_Contact set FStatus=FStatus | 1,FToBal=1  where FRPBillID=1945
     END 
     if (len(@DBName) > 0) and UPDATE(FCurCheckLevel) 
    AND @FSynchroID<>'0'
	AND @FCurCheckLevel<@LastCheckLevel
	BEGIN
	  --SET @sql=' UPDATE '+ @DBName +'.dbo.ICExpenses SET FCheckerID=NULL WHERE FInterID='+@FSynchroID
	  SET @sql='IF EXISTS(SELECT 1 FROM '+ @DBName +'.dbo.ICExpenses where FInterID='+@FSynchroID+' and isnull(FCheckerID,0)=0  ) begin '
	  SET @sql=@sql+' DELETE ' + @DBName +'.dbo.t_RP_Plan_Ar WHERE FBillID=(SELECT FRecBillInterID FROM ' + @DBName +'.dbo.ICExpenses WHERE finterid='+@FSynchroID+') '
	  SET @sql=@sql+' DELETE ' + @DBName +'.dbo.t_RP_Contact WHERE FRPBillID<>0 and FRPBillID=(SELECT FRecBillInterID FROM ' + @DBName +'.dbo.ICExpenses WHERE finterid='+@FSynchroID+') '
	  SET @sql=@sql+' DELETE ' + @DBName +'.dbo.t_RP_ARPBill WHERE FSourceID='+@FSynchroID
	  SET @sql=@sql+' DELETE ' + @DBName +'.dbo.ICExpenses WHERE FInterID='+@FSynchroID
	  SET @sql=@sql+' UPDATE ICExpenses SET FSynchroID=NULL WHERE FInterID='+@FInterID
	  
	  SET @sql=@sql+ ' end '
	 exec(@sql)
	 
	
	END 

	IF (@@error <> 0)  
		ROLLBACK TRANSACTION  
		
	ELSE  
		COMMIT TRANSACTION 
end