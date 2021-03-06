USE [zhuok]
GO
/****** Object:  StoredProcedure [dbo].[create_k3_Voucher]    Script Date: 05/07/2020 16:51:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[create_k3_Voucher]
 (
    @P_SOURCE          nvarchar (50) = NULL,
    @P_DATE      nvarchar(50) = null
)
as
declare @DBName varchar(50)
declare @sql varchar(4000)
declare @Frob integer --判断红字出货
declare @FStatus int
declare @pp int
declare @nSql nvarchar(4000)

DECLARE @PPeriod varchar(50) --期间
DECLARE @PYear varchar(50) --年份
DECLARE @PINO_ID varchar(50) --凭证号
DECLARE @PROW_NUM varchar(50) --凭证数
DECLARE @PSerialNum varchar(50) --凭证序号：按年份

DECLARE @PVoucherID varchar(50) --凭证主表ID
declare @fvou_id bigint  --记录ID
DECLARE @PDetailID varchar(50) --最大辅助表ID
DECLARE @PISCHECKDATE bigint --判断是否结账
DECLARE @PISBASEINFO varchar(300) = null --判断是否有基础数据没有新增

DECLARE @PISDETAIL varchar(300) = null--

 begin
BEGIN TRANSACTION
        --1.取记录ID：未导入（取消导入或已导入）
         select top 1 @fvou_id=isnull(id_key,0)
          from k3t_gl_voucher where isnull(U8_PZ,0)=0 and S_SOURCE=@P_SOURCE and S_DATE=@P_DATE order by id_key desc;
          
 if @fvou_id <> 0 --有记录-判断开始
   begin  
          --CFARMERS_ID
          --判断是否有基础数据未新增
           select top 1 @PISDETAIL=S_ITEM_NM from K3V_GL_VOUCHER_DETAIL_Item_A
      where ((isnull(ccus_id,'0')<>'0' and f1=0) or (isnull(cdept_id,'0')<>'0' and f3001=0))
       and vou_id=@fvou_id order by S_ITEM_ID,S_ITEM_NM;
      
       if  @PISBASEINFO is null
         begin        
         
           --2.取年份、期间
          select TOP 1 @PYear=isnull(a.FYear,9999),@PPeriod=isnull(a.fperiod,88) from dbo.K3V_t_Voucher a where a.id_key=@fvou_id ;
           
          ---2.1判断是否有辅助明细 没有记录
           select top 1 @PISDETAIL=vou_id from K3V_t_ItemDetail where  vou_id=@fvou_id;
           
           if @PISDETAIL is not null
              begin 
            SELECT @PDetailID=max(FDetailID)+1 FROM test_yxspzhuok.dbo.t_ItemDetail; --获取最大辅助明细ID+1
            
            --设置获取最大辅助明细
            update K3T_GL_VOUCHER_DETAIL set CFARMERS_ID=@PDetailID            
             where vou_id=@fvou_id and ID_KEY in (select id_key from K3V_t_ItemDetail where  vou_id=@fvou_id);

            --插入辅助明细-主表
            insert into test_yxspzhuok.dbo.t_ItemDetail(FDetailID,FDetailCount,F1,F3001)      
              select @PDetailID+b.FEntryID,a.FDetailCount,a.F1,a.F3001
              from K3V_t_ItemDetail  a
              left join K3V_GL_VOUCHER_DETAIL_Item_A b on a.id_key=b.id_key and a.vou_id=b.vou_id
              where  a.vou_id=@fvou_id 
               order by a.F1,a.F3001;
               
             --插入辅助明细 -客户
              insert into test_yxspzhuok.dbo.t_ItemDetailV(FDetailID,FItemClassID,FItemID)
              select CONVERT(INTEGER,CFARMERS_ID)+FEntryID,1,F1 from K3V_GL_VOUCHER_DETAIL_Item_A
               where  vou_id=@fvou_id and isnull(CFARMERS_ID,'0')<>'0' and f1<>0 ;
             
             --插入辅助明细-门店
              insert into test_yxspzhuok.dbo.t_ItemDetailV(FDetailID,FItemClassID,FItemID)
              select CONVERT(INTEGER,CFARMERS_ID)+FEntryID,3001,F3001 from K3V_GL_VOUCHER_DETAIL_Item_A
               where  vou_id=@fvou_id and isnull(CFARMERS_ID,'0')<>'0' and F3001<>0 ;               
             
             --插入日志
             insert into k3t_gl_voucher_log(vou_id,FYear,fPeriod,Z_REMARK,S_SOURCE,S_DATE,z_opt_dt)
              values(@fvou_id,@PYear,@PPeriod,'插入辅助明细'+@PDetailID,@P_SOURCE,@P_DATE,GETDATE());               
             
              end     
          

          --3.取凭证序号：按年份
          SELECT @PSerialNum=max(FSerialNum)+1 FROM test_yxspzhuok.dbo.t_Voucher where fyear=CONVERT(INTEGER,@PYear);
          
          ---4.判断结账
          select @PISCHECKDATE=count(*) from 
           (
           select CurrentYear,CurrentPeriod from 
         (select FValue CurrentYear  from test_yxspzhuok.dbo.t_SystemProfile b
          where FCategory='gl' and FKey='CurrentYear') e, 
          (select FValue CurrentPeriod  from test_yxspzhuok.dbo.t_SystemProfile b
          where FCategory='gl' and FKey='CurrentPeriod') f
           ) h where h.CurrentPeriod<=CONVERT(INTEGER,@PYear) and h.CurrentPeriod<=CONVERT(INTEGER,@PPeriod);
           
          if @PISCHECKDATE>0 --未结账
            begin 
              --4.取凭证号
              select @PINO_ID=max(a.ino_id) +1 ,@PROW_NUM=count(a.ino_id) from
               (select FNumber ino_id, count(FNumber) row_num from test_yxspzhuok.dbo.t_Voucher 
               where FYear=CONVERT(INTEGER,@PYear)  and FPeriod=CONVERT(INTEGER,@PPeriod) group by FYear,FPeriod,FNumber) a ;
               
               --5.1插入凭证主表：
               insert into test_yxspzhuok.dbo.t_Voucher(FApproveID ,FAttachments ,FBrNo ,FCashierID ,FChecked ,FCheckerID ,FCreditTotal ,FDate ,FDebitTotal ,
              FEntryCount ,FExplanation ,FFootNote ,FFrameWorkID ,FGroupID ,FHandler ,FInternalInd ,
              FNumber ,FObjectName ,FOwnerGroupID ,FParameter ,FPeriod ,FPosted ,FPosterID ,FPreparerID ,FReference ,
              FSerialNum ,FTransDate ,FTranType ,FYear)
                (select a.FApproveID ,FAttachments ,FBrNo ,FCashierID ,FChecked ,FCheckerID ,FCreditTotal ,convert(datetime,s_date) FDate ,FDebitTotal ,
              isnull(FEntryCount,0),FExplanation,FFootNote ,FFrameWorkID ,FGroupID ,FHandler ,FInternalInd ,
              @PINO_ID FNumber ,FObjectName ,FOwnerGroupID ,FParameter ,FPeriod ,FPosted ,FPosterID ,FPreparerID ,FReference,
              @PSerialNum FSerialNum ,convert(datetime,s_date) FTransDate ,FTranType,FYear from dbo.K3V_t_Voucher a
               where a.id_key=@fvou_id);

             --5.2 取凭证主表ID
             select @PVoucherID=a.FVoucherID from test_yxspzhuok.dbo.t_Voucher a
                 where FYear=CONVERT(INTEGER,@PYear) and FPeriod=CONVERT(INTEGER,@PPeriod) and FSerialNum=CONVERT(INTEGER,@PSerialNum);
                 
              --5.3 插入凭证细表
              insert into test_yxspzhuok.dbo.t_VoucherEntry(FAccountID ,FAccountID2 ,FAmount ,FAmountFor ,FBrNo ,FCashFlowItem ,FCurrencyID ,FDC ,FDetailID ,
            FEntryID ,FExchangeRate ,FExchangeRateType ,FExplanation ,FInternalInd ,FMeasureUnitID ,FQuantity ,FResourceID ,
            FSettleNo ,FSettleTypeID ,FTaskID ,FTransNo ,FUnitPrice ,FVoucherID)
             (select FAccountID ,FAccountID2 ,FAmount ,FAmountFor ,FBrNo ,FCashFlowItem ,FCurrencyID ,FDC ,FDetailID ,
            FEntryID ,FExchangeRate ,FExchangeRateType ,FExplanation ,FInternalInd ,FMeasureUnitID ,FQuantity ,FResourceID ,
              FSettleNo ,FSettleTypeID ,FTaskID ,FTransNo ,FUnitPrice ,@PVoucherID FVoucherID
              from dbo.K3V_t_VoucherEntry a where a.VOU_ID=@fvou_id ); 
              
             --6.1 更新为已导入 
             update k3t_gl_voucher set U8_PZ=1 where isnull(U8_PZ,0)=0 ;
             
             --6.2 更新凭证号
             update K3T_GL_VOUCHER set s_bill_no=@PINO_ID where id_key=@fvou_id;      
               
             
                --7.插入日志    
             insert into k3t_gl_voucher_log(vou_id,VoucherID,FYear,fPeriod,INO_ID,PROW_NUM,Z_REMARK,S_SOURCE,S_DATE,FSerialNum,z_opt_dt) 
                values(@fvou_id,@PVoucherID,@PYear,@PPeriod,@PINO_ID,@PROW_NUM,'凭证已生成',@P_SOURCE,@P_DATE,@PSerialNum,GETDATE());  
           end 
          else
            begin 
                 insert into k3t_gl_voucher_log(vou_id,FYear,fPeriod,Z_REMARK,S_SOURCE,S_DATE,z_opt_dt) values(@fvou_id,@PYear,@PPeriod,'已结账',@P_SOURCE,@P_DATE,GETDATE());  
            end  
            
    end 
    else 
      begin 
        insert into k3t_gl_voucher_log(vou_id,Z_REMARK,S_SOURCE,S_DATE,z_opt_dt) values(@fvou_id,'基础数据不一致'+@PISBASEINFO,@P_SOURCE,@P_DATE,GETDATE());  
         -- return (0);
      end
                         
   
  end  --有记录-判断结束
  else 
       begin
        ---
        insert into k3t_gl_voucher_log(vou_id,Z_REMARK,S_SOURCE,S_DATE,z_opt_dt) values(0,'无记录',@P_SOURCE,@P_DATE,GETDATE());
       end

  
  IF @@error <> 0  --发生错误
   BEGIN
     ROLLBACK TRANSACTION
     return (0)    
   END
ELSE
   BEGIN
     COMMIT TRANSACTION
      return  (1) 
   END
  
 end;