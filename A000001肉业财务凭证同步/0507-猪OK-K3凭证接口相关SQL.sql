CREATE TABLE [dbo].[K3T_GL_VOUCHER](
	[ID_KEY] [decimal](20, 0) NOT NULL,
	[S_CONTENT] [varchar](420) NOT NULL,
	[MONEY] [decimal](24, 2) NULL,
	[S_ITEM_ID] [varchar](200) NULL,
	[S_ITEM_NM] [varchar](200) NULL,
	[ORG_CODE] [varchar](20) NULL,
	[ORG_NAME] [varchar](80) NULL,
	[S_NO] [varchar](50) NULL,
	[S_BILL_NO] [decimal](10, 0) NULL,
	[U8_PZ] [decimal](1, 0) NULL,
	[ROWGUID] [varchar](100) NULL,
	[S_MONTH] [varchar](7) NULL,
	[S_DATE] [varchar](10) NULL,
	[S_OPT_ID] [decimal](20, 0) NULL,
	[S_OPT_NM] [varchar](20) NULL,
	[S_OPT_DT] [date] NULL,
	[S_SOURCE] [decimal](2, 0) NULL,
	[SN] [varchar](10) NULL,
	[Z_ZC_ID] [varchar](20) NULL,
	[Z_ZC_NM] [varchar](80) NULL,
	[S_TYPE] [decimal](5, 0) NULL,
	[S_TYPE_NM] [varchar](50) NULL,
	[S_JF_MONEY] [decimal](24, 2) NOT NULL,
	[S_DF_MONEY] [decimal](24, 2) NOT NULL,
	[S_REMARK] [varchar](400) NULL,
	[fperiod] [varchar](10) NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[K3T_GL_VOUCHER_DETAIL](
	[ID_KEY] [decimal](20, 0) NOT NULL,
	[VOU_ID] [decimal](20, 0) NULL,
	[REMARK] [varchar](350) NULL,
	[CCODE] [varchar](20) NULL,
	[CCODE_NM] [varchar](250) NULL,
	[CCODE_EQUAL] [varchar](12) NULL,
	[CCODE_EQUAL_NM] [varchar](250) NULL,
	[S_CONTENT] [varchar](420) NULL,
	[MONEY] [decimal](24, 2) NULL,
	[MONEY_F] [decimal](24, 4) NULL,
	[INID] [decimal](5, 0) NULL,
	[BSUP] [decimal](18, 0) NULL,
	[BCUS] [decimal](18, 0) NULL,
	[BPERSON] [decimal](18, 0) NULL,
	[BDEPT] [decimal](18, 0) NULL,
	[BKDEPT] [decimal](3, 0) NULL,
	[BCASHITEM] [decimal](3, 0) NULL,
	[BFARMERS] [decimal](18, 0) NULL,
	[BPIG] [decimal](18, 0) NULL,
	[BCHOOK] [decimal](18, 0) NULL,
	[DEPT_ID] [varchar](200) NULL,
	[DEPT_NM] [varchar](200) NULL,
	[CDEPT_ID] [varchar](200) NULL,
	[CCUS_ID] [varchar](200) NULL,
	[CCUS_NM] [varchar](200) NULL,
	[CSUP_ID] [varchar](200) NULL,
	[CSUP_NM] [varchar](200) NULL,
	[CASHFLOW] [varchar](10) NULL,
	[CASHFLOW_NM] [varchar](100) NULL,
	[CPERSON_ID] [varchar](200) NULL,
	[CPERSON_NM] [varchar](200) NULL,
	[CFARMERS_ID] [varchar](200) NULL,
	[CFARMERS_NM] [varchar](200) NULL,
	[CPIG_ID] [varchar](200) NULL,
	[CPIG_NM] [varchar](200) NULL,
	[CCHOOK_ID] [varchar](200) NULL,
	[CCHOOK_NM] [varchar](200) NULL,
	[CINOUTBUSICLASS_ID] [varchar](100) NULL,
	[CINOUTBUSICLASS_NM] [varchar](300) NULL,
	[S_ITEM_ID] [varchar](200) NULL,
	[S_ITEM_NM] [varchar](200) NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[k3t_gl_voucher_log](
	[vou_id] [varchar](30) NULL,
	[VoucherID] [varchar](100) NULL,
	[S_SOURCE] [varchar](100) NULL,
	[S_DATE] [varchar](100) NULL,
	[FSerialNum] [varchar](100) NULL,
	[INO_ID] [varchar](30) NULL,
	[PROW_NUM] [varchar](30) NULL,
	[FYear] [varchar](30) NULL,
	[fPeriod] [varchar](30) NULL,
	[z_opt_dt] [datetime] NULL,
	[Z_REMARK] [varchar](200) NULL
) ON [PRIMARY];

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[K3V_GL_VOUCHER_DETAIL_Count]'))
DROP VIEW [dbo].[K3V_GL_VOUCHER_DETAIL_Count];

CREATE VIEW [dbo].[K3V_GL_VOUCHER_DETAIL_Count] AS
    select a.VOU_ID,COUNT(*) FEntryCount from K3T_GL_VOUCHER_DETAIL a group by a.VOU_ID;
    
 CREATE VIEW [dbo].[K3V_GL_VOUCHER_DETAIL_Item_A] AS
SELECT a.ID_KEY,a.INID,a.INID-1 FEntryID, a.VOU_ID,a.CCUS_ID,a.CFARMERS_ID,a.CCUS_NM,a.CDEPT_ID,a.DEPT_NM,a.S_ITEM_ID,a.S_ITEM_NM,isnull((select TOP 1 Fitemid from test_yxspzhuok.dbo.t_item
    WHERE  FItemClassID=1 and FNumber=a.CCUS_ID),0) f1,0 f2,0 f3 ,0 f8,
    isnull((select TOP 1 Fitemid from test_yxspzhuok.dbo.t_item
    WHERE  FItemClassID=3001 and FNumber=a.CDEPT_ID),0) f3001
  FROM K3T_GL_VOUCHER_DETAIL a ;
  
CREATE VIEW [dbo].[K3V_GL_VOUCHER_DETAIL_Item_B] AS
  select a.ID_KEY,a.vou_id,a.CCUS_ID,a.CCUS_NM,a.CDEPT_ID,a.DEPT_NM,a.S_ITEM_ID,a.S_ITEM_NM,a.f1,a.f2,a.f3,a.f8,a.f3001,
   c.FDetailCount,c.FDetailID
   from K3V_GL_VOUCHER_DETAIL_Item_A a, test_yxspzhuok.dbo.t_itemdetail c where a.f1<>0 and a.f3001=0
    AND a.f1=c.f1 AND a.f2=c.f2 AND a.f3=c.f3 AND a.f8=c.f8 and a.f3001=c.f3001
    union all 
select a.ID_KEY,a.vou_id,a.CCUS_ID,a.CCUS_NM,a.CDEPT_ID,a.DEPT_NM,a.S_ITEM_ID,a.S_ITEM_NM,a.f1,a.f2,a.f3,a.f8,a.f3001,
   c.FDetailCount,c.FDetailID
   from K3V_GL_VOUCHER_DETAIL_Item_A a, test_yxspzhuok.dbo.t_itemdetail c where a.f1=0 and a.f3001<>0
    AND a.f1=c.f1 AND a.f2=c.f2 AND a.f3=c.f3 AND a.f8=c.f8 and a.f3001=c.f3001
    union all     
   select a.ID_KEY,a.vou_id,a.CCUS_ID,a.CCUS_NM,a.CDEPT_ID,a.DEPT_NM,a.S_ITEM_ID,a.S_ITEM_NM,a.f1,a.f2,a.f3,a.f8,a.f3001,
   c.FDetailCount,c.FDetailID
   from K3V_GL_VOUCHER_DETAIL_Item_A a, test_yxspzhuok.dbo.t_itemdetail c
     where (a.f1<>0 and a.f3001<>0) AND a.f1=c.f1 AND a.f2=c.f2 AND a.f3=c.f3 AND a.f8=c.f8 and a.f3001=c.f3001
   union all 
   select a.ID_KEY,a.vou_id,a.CCUS_ID,a.CCUS_NM,a.CDEPT_ID,a.DEPT_NM,a.S_ITEM_ID,a.S_ITEM_NM,a.f1,a.f2,a.f3,a.f8,a.f3001,
   0 FDetailCount,0 FDetailID
   from K3V_GL_VOUCHER_DETAIL_Item_A a
     where (a.f1=0 and a.f3001=0);
     
 CREATE VIEW [dbo].[K3V_GL_VOUCHER_DETAIL_Account] AS
	select a.ID_KEY,a.vou_id,a.CCODE,a.CCODE_NM, 
	 1 FDC,--余额方向
	 a.INID-1 FEntryID,--分录号
	 isnull((select top 1 FAccountID from test_yxspzhuok.dbo.t_Account t where t.fNumber=a.CCODE),0) FAccountID,--科目内码
	 1086 FAccountID2--对方科目
	 from K3T_GL_VOUCHER_DETAIL a where a.CCODE is not null
	 union all 
    select a.ID_KEY,a.vou_id,a.CCODE_EQUAL CCODE,a.CCODE_EQUAL_nm CCODE_NM, 
	 0 FDC,--余额方向
	 a.INID-1 FEntryID,--分录号
	 isnull((select top 1 FAccountID from test_yxspzhuok.dbo.t_Account t where t.fNumber=a.CCODE_EQUAL),0) FAccountID,--科目内码
	 1710 FAccountID2--对方科目
	 from K3T_GL_VOUCHER_DETAIL a where a.CCODE_EQUAL is not null;
	 
	 
CREATE VIEW [dbo].[K3V_t_Voucher] AS   
    select a.ID_KEY,a.S_DATE,-1 FApproveID     --审批,,
,0 FAttachments   --附件张数,
,0 FBrNo          --公司代码,
,-1 FCashierID     --出纳员,,
,0 FChecked       --是否审核,
,-1 FCheckerID     --审核人,,
,a.S_DF_MONEY FCreditTotal   --贷方金额合计,
,a.S_DATE+' 00:00:00' FDate
--,CONVERT(datetime,a.S_DATE+' 00:00:00',120) FDate          --凭证日期,
,a.S_JF_MONEY FDebitTotal    --借方金额合计,
,b.FEntryCount FEntryCount    --分录数,,
,a.S_CONTENT FExplanation   --备注,,
,'' FFootNote      --批注,,
,-1 FFrameWorkID   --集团组织机构内码
,1 FGroupID       --凭证字内码,
,null FHandler       --会计主管,
,null FInternalInd   --机制凭证,
,null FModifyTime    --修改时间,
,0 FNumber        --凭证号,,
,null FObjectName    --对象接口,
,0 FOwnerGroupID  --制单人所属工作组
,null FParameter     --接口参数,
, CONVERT(INTEGER,right(a.S_MONTH,2)) FPeriod        --会计期间,
,0 FPosted        --是否过账,
,-1 FPosterID      --记账人,,
,16598 FPreparerID    --制单人,,
,null FReference     --参考信息,
,'' FSerialNum     --凭证序号,
,a.S_DATE+' 00:00:00' FTransDate
--,CONVERT(datetime,a.S_DATE+' 00:00:00',120) FTransDate     --业务日期,
,0 FTranType      --单据类型,
,0 FVoucherID     --凭证内码,
,CONVERT(INTEGER,left(a.S_MONTH,4)) FYear          --会计年度,
   from  dbo.K3T_GL_VOUCHER a
    left join K3V_GL_VOUCHER_DETAIL_Count b on a.ID_KEY=b.VOU_ID ;
    
  CREATE VIEW [dbo].[K3V_t_VoucherEntry] AS     
    select c.FAccountID FAccountID,--科目内码
c.FAccountID2 FAccountID2,--对方科目
a.MONEY FAmount	,--本位币金额
isnull(a.MONEY_F,a.MONEY) FAmountFor,--原币金额
0 FBrNo	,--公司代码
0 FCashFlowItem,--现金流量
1 FCurrencyID,--币别
c.FDC FDC	,--余额方向
isnull(b.FDetailID,0) FDetailID,--核算项目
c.FEntryID FEntryID,--分录号
1 FExchangeRate,--汇率
1 FExchangeRateType	,--汇率类型
a.S_CONTENT FExplanation,--摘要
null FInternalInd,--机制凭证
0 FMeasureUnitID,--单位内码
0 FQuantity,--数量
0 FResourceID,--项目资源内码
null FSettleNo,--结算号
0 FSettleTypeID,--结算方式
0 FTaskID	,--项目任务内码
null FTransNo,--业务号
0 FUnitPrice,--单价
0 FVoucherID,--凭证内码
d.f1,d.f3001,a.CFARMERS_ID,a.ID_KEY,a.VOU_ID,a.INID,a.S_ITEM_ID,a.S_ITEM_NM,a.CCUS_ID,a.CCUS_NM,a.DEPT_ID,a.DEPT_NM,a.CDEPT_ID,a.CCODE,a.CCODE_NM
 from K3T_GL_VOUCHER_DETAIL a
  left join K3V_GL_VOUCHER_DETAIL_Item_A d on a.ID_KEY=d.ID_KEY and a.VOU_ID=d.vou_id
  left join K3V_GL_VOUCHER_DETAIL_Item_B b on a.ID_KEY=b.ID_KEY and a.VOU_ID=b.vou_id
  left join K3V_GL_VOUCHER_DETAIL_Account c on a.ID_KEY=c.ID_KEY and a.VOU_ID=c.vou_id  
  ;
  
  
  	 

