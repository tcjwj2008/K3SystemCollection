ALTER  TRIGGER [dbo].[ICStockBill_Update]
            ON [dbo].[ICStockBill]
FOR Update
AS 
declare @DBName varchar(50)
declare @FCheckerID bigint
declare @FInterID varchar(50)

declare @Sql varchar(4000)
declare @pp int
declare @FBillNo varchar(50)
declare @nSql nvarchar(4000)

declare @FTranType int
declare @FSynchroID varchar(50)

declare @msg varchar(50)
declare @FLastChecker bigint 
DECLARE @LastCheckLevel INTEGER
BEGIN  
	BEGIN TRANSACTION  
	SET NOCOUNT ON
--	1	ͬ���⹺��ⵥ1
--2	ͬ���ɹ���Ʊ
--3	ͬ�����
--4	ͬ�����۳��ⵥ21
--5	ͬ�����۷�Ʊ
--6	ͬ���տ
--7	ͬ���������ϵ�24
--8	ͬ����Ʒ��ⵥ2
--9	ͬ��������ⵥ9
--10	ͬ���������ⵥ29
--11	ͬ������ƾ֤


--1	�⹺���
--2	����Ʒ���
--3	�������
--5	ί��ӹ����
--10	�������
--21	���۲�Ʒ
--24	��������
--28	ί��ӹ�����
--29	��������
--40	��ӯ���
--41	�ֿ����
--43	�̿�����
--65	�ƻ��۵���
--70	�ɹ�����
--71	�ɹ�����
--72	�ɹ��ջ�
--73	�ɹ��˻�
--75	������Ʊ
--76	������Ʊ(��ͨ)
--80	���۷�Ʊ
--81	���۶���
--82	�����˻�
--83	���۷���
--84	���۱��۵�
--85	��������
--86	���۷�Ʊ(��ͨ)
--90	ƾ֤
--100	������
--101	�⹺����ݹ�����
--102	ί��ӹ��Ѳ��
--137	���мӹ�����          select * from ictemplate WHERE fid='a01'
--һ��:	FMultiCheckLevel1
--����:	FMultiCheckLevel2
--����:	FMultiCheckLevel3
--����:	FMultiCheckLevel4
--����:	FMultiCheckLevel5
--����:	FMultiCheckLevel6
	--select * from ictranstype  Select top 1 * From t_MultiLevelCheck Where FBillType = 1 order by fchecklevel desc


	select @DBName=FDBName from t_BOS_Synchro where FK3Name='����ͬ��'
	select @FInterID = FInterID,@FCheckerID=isnull(FCheckerID,0),@FTranType=FTranType,@FSynchroID=FSynchroID from inserted  where FTranType in (1,21,10,29,2,24)
    
    Select TOP 1 @LastCheckLevel=ISNULL(FCheckLevel,0) From t_MultiLevelCheck Where FBillType = @FTranType order by fchecklevel DESC
    IF @LastCheckLevel=2 
    	select @FCheckerID=isnull(FMultiCheckLevel2,0) from inserted  where FTranType in (1,21,10,29,2,24)
        IF @LastCheckLevel=3 
    	select @FCheckerID=isnull(FMultiCheckLevel3,0) from inserted  where FTranType in (1,21,10,29,2,24)
    	    IF @LastCheckLevel=4 
    	select @FCheckerID=isnull(FMultiCheckLevel4,0) from inserted  where FTranType in (1,21,10,29,2,24)
    	    IF @LastCheckLevel=5 
    	select @FCheckerID=isnull(FMultiCheckLevel5,0) from inserted  where FTranType in (1,21,10,29,2,24)
    	    IF @LastCheckLevel=6 
    	select @FCheckerID=isnull(FMultiCheckLevel6,0) from inserted  where FTranType in (1,21,10,29,2,24)
    
    
    if @FTranType=1
    SELECT TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=1 AND FChecker=@FCheckerID
    
       if @FTranType=21
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=4 AND FChecker=@FCheckerID
   
            if @FTranType=10
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=9 AND FChecker=@FCheckerID
     
           if @FTranType=24
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=7 AND FChecker=@FCheckerID
               if @FTranType=2
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=8 AND FChecker=@FCheckerID
                  if @FTranType=29
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=10 AND FChecker=@FCheckerID

if @FLastChecker=@FCheckerID
begin
    
	if (len(@DBName) > 0) AND UPDATE(FCurCheckLevel) and @FCheckerID >0  --and UPDATE(FCheckerID)
	begin
		
		
	
	
		--------���ϡ���λ���ֿ�---------------
			set @msg=''
			set @nSQL=' select @p2=t2.FNumber from  ICStockBillEntry t inner join t_ICItem t2 on t.FItemID=t2.FItemID  left join '+ @DBName+'.dbo.t_ICItem t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+ @FinterID
			exec sp_executesql  @nSQL ,N'@p2   Varchar(50)  output ',@msg   output
			if len(@msg)>0
			begin
				set @msg='<���ϣ�' + @msg + '>,�������ײ����ڸ�����,�������!'
				RAISERROR(@msg,18,18)
				ROLLBACK TRAN
			end 
			
			set @nSQL=' select @p2=t2.FNumber from  ICStockBillEntry t inner join t_measureunit t2 on t.FUnitID=t2.FMeasureUnitID  left join '+ @DBName+'.dbo.t_measureunit t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+ @FinterID
			exec sp_executesql  @nSQL ,N'@p2   Varchar(50)  output ',@msg   output
			if len(@msg)>0
			begin
				set @msg='<������λ��' + @msg + '>,�������ײ����ڸü�����λ,�������!'
				RAISERROR(@msg,18,18)
				ROLLBACK TRAN
			end 
			
			set @nSQL=' select @p2=t2.FNumber from  (select FInterID,FDCStockID from ICStockBillEntry union select FInterID,FSCStockID from ICStockBillEntry  ) t 
					inner join t_Stock t2 on t2.FItemID=t.FDCStockID  left join '+ @DBName+'.dbo.t_Stock t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+ @FinterID
			exec sp_executesql  @nSQL ,N'@p2   Varchar(50)  output ',@msg   output
			if len(@msg)>0
			begin
				set @msg='<�ֿ⣺' + @msg + '>,�������ײ����ڸòֿ�,�������!'
				RAISERROR(@msg,18,18)
				ROLLBACK TRAN
			end 
		------------------------
		

		set @pp=0
		set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''ICStockBill'',@p2 output,1,16394'
		exec sp_executesql  @nSql ,N'@p2   int   output ',@pp   output
		
		--set @nSql=' exec '+ @DBName+'.dbo.p_BM_GetBillNo 1,@p2 output' 
		--exec sp_executesql  @nSql ,N'@p2   varchar(50)   output ',@FBillNo   output
	   if @FTranType=1   or @FTranType=10 or @FTranType=2 
	   begin
			set @Sql = 'insert into ' + @DBName + '.dbo.ICStockBill(FBrNo,FInterID,FTranType,FDate,FBillNo,FRefType,
						FSupplyID,FDeptID,FEmpID,FFManagerID,FSManagerID,FManagerID,FAcctID,
						FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,FVchInterID,FRelateBrID,
						FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,FMultiCheckLevel2,FMultiCheckDate2) '+
				'select FBrNo,'+cast(@pp as varchar(10))+',FTranType,FDate,FBillNo,FRefType,
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_supplier where FNumber=(select FNumber from t_supplier where FItemID=t.FSupplyID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_department where FNumber=(select FNumber from t_department where FItemID=t.FDeptID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FFManagerID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FSManagerID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FManagerID)),0),
				isnull((select top 1 FAccountID from ' + @DBName + '.dbo. t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAcctID)),0),
				FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,0,FRelateBrID,
				FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,
				isnull((select top 1 fuserid from ' + @DBName+'.dbo.t_User where FName=(select FName from t_User where fuserid=t.FMultiCheckLevel2)),0), (case when '+CAST(@LastCheckLevel AS VARCHAR)+' =3 then FMultiCheckDate2 else null end) as FMultiCheckDate2  
				from ICStockBill t 
				where t.FinterID='+ @FinterID  
			exec (@Sql)
 
		end																	
		else if @FTranType=21 or @FTranType=29	  or @FTranType=24 		----FBillTypeID,FManagerID,
		begin
			set @Sql = 'insert into ' + @DBName + '.dbo.ICStockBill(FBrNo,FInterID,FTranType,FDate,FBillNo,FRefType,
						FSupplyID,FDeptID,FEmpID,FFManagerID,FSManagerID,FManagerID,FAcctID,
						FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,FVchInterID,FRelateBrID,
						FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,FMultiCheckLevel2,FMultiCheckDate2) '+
				'select FBrNo,'+cast(@pp as varchar(10))+',FTranType,FDate,FBillNo,FRefType,
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_Organization where FNumber=(select FNumber from t_Organization where FItemID=t.FSupplyID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_department where FNumber=(select FNumber from t_department where FItemID=t.FDeptID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FFManagerID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FSManagerID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FManagerID)),0),
				isnull((select top 1 FAccountID from ' + @DBName + '.dbo. t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAcctID)),0),
				FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,0,FRelateBrID,
				FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,
				isnull((select top 1 fuserid from ' + @DBName+'.dbo.t_User where FName=(select FName from t_User where fuserid=t.FMultiCheckLevel2)),0), (case when '+CAST(@LastCheckLevel AS VARCHAR)+' =3 then FMultiCheckDate2 else null end) as FMultiCheckDate2  
				from ICStockBill t 
				where t.FinterID='+ @FinterID  
			exec (@Sql)
 
		end
		
		update  ICStockBill set FSynchroID=@pp where FInterID=@FInterID
		
		
		set @Sql='insert into ' + @DBName + '..ICStockBillEntry(FBrNo,FInterID,FEntryID,FBatchNo,FNote,
				FItemID,FUnitID,FDCStockID,FSCStockID,FPrice,FAuxPrice,FQty,FAuxQty,FQtyMust,FAuxQtyMust,FAmount,FConsignPrice,FConsignAmount,FKFDate,FKFPeriod,FPeriodDate,
				FReProduceType,FSourceTranType,FSourceEntryID,FSourceBillNo,FSourceInterId,FOrderEntryID, FOrderBillNo, FOrderInterID) '+

			'select FBrNo,'+cast(@pp as varchar(10))+',FEntryID,FBatchNo,FNote,
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_ICItem where FNumber=(select FNumber from t_ICItem where FItemID=t.FItemID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_measureunit where FNumber=(select FNumber from t_measureunit where FMeasureUnitID=t.FUnitID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_Stock where FNumber=(select FNumber from t_Stock where FItemID=t.FDCStockID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_Stock where FNumber=(select FNumber from t_Stock where FItemID=t.FSCStockID)),0),
			FPrice,FAuxPrice,FQty,FAuxQty,FQtyMust,FAuxQtyMust,FAmount,FConsignPrice,FConsignAmount,FKFDate,FKFPeriod,FPeriodDate,
			FReProduceType,0,0,'''',0,0, '''', 0
			from ICStockBillEntry t 
			where t.FInterID=' + @FinterID
		  
		exec (@Sql)

		-----------������----------------------
		if @FTranType=1  or @FTranType=10 or @FTranType=2  		-- �⹺��⡢������⡢��Ʒ���
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)

				
			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end 
		else if @FTranType=21 or @FTranType=29	   --���۳��⡢��������
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)
			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1*u1.FQty,-1*u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end 
		else if @FTranType=24		--��������
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)
			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1*u1.FQty,-1*u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end 
		
		
		-----------------------------------------
	end

end

	if (len(@DBName) > 0) AND UPDATE(FCurCheckLevel) and @FCheckerID =0  --and UPDATE(FCheckerID)
	begin
	
	  IF EXISTS(select 1 from AIS_YXYZ_2.dbo.ICStockBill where isnull(FCheckerID,0)>0 and FInterID= @FSynchroID)

  begin
		
		          RAISERROR('��ѡ����Ŀ�����׵���',18,18)
          ROLLBACK TRAN
      end
      
		
		-----------������----------------------
		if @FTranType=1   or @FTranType=10 or @FTranType=2 --�⹺��⡢������⡢��Ʒ���
		begin
		

		
			set @Sql='update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)

			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1 * u1.FQty,-1 * u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end 
		else if @FTranType=21 or @FTranType=29
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)

			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end
		else if @FTranType=24
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)

			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end
		
		-----------------------------------------
		update  ICStockBill set FSynchroID=0 where FInterID=@FInterID
	 
		set @Sql ='update ' + @DBName + '.dbo.ICStockBill set FCheckerID=Null,FStatus=0,FCheckDate=Null  where FInterID=' + @FSynchroID
		exec(@sql) 
		
		set @Sql ='delete from ' + @DBName + '.dbo.ICStockBill where isnull(FCheckerID,0)=0 and FInterID=' + @FSynchroID
		exec(@sql) 
		
	end



	IF (@@error <> 0)  
		ROLLBACK TRANSACTION  
		
	ELSE  
		COMMIT TRANSACTION 

end
