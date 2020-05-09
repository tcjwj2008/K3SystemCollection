select c.*  from ( select v.FVoucherID,v.FDate,Convert(VarChar,FYear) + '.' + Convert(VarChar,FPeriod) FPeriod1,g.FName + '-' + Convert(VarChar,v.FNumber) FNumber,e.FExplanation,e.FEntryID, a.FNumber FAcctNumber,     a.FFullName FAcctName,e.FDC, e.FAmountFor,e.FAmount,e.FDetailID, c.FItemID, c.FSubItemID,r.FName FCurrency, case when c.FItemID <=0 and c.FSubitemID <=0 then null else c.FAmount end FCashAmount,     c.FCashNumber + c.FCashName FCashItem,c.FCashSubNumber + c.FCashSubName FCashSubItem  from t_voucherentry e left join (select t.FVoucherID,t.FEntryID, t.FItemID, t.FSubItemID,i.FNumber FCashNumber,i.FName FCashName,i1.FNumber FCashSubNumber,i1.FName FCashSubName,t.FAmount,t.FCurrencyID from t_cashflowbal t left join t_item i on t.FItemID=i.FItemID and i.FItemID <> 0 left join t_item i1 on t.FSubItemID=i1.FItemID and i1.FItemID <> 0,(Select 
FBrNo,FvoucherID,FDate,FYear,FPeriod, 
FGroupID,FNumber,FReference,FExplanation,FAttachments, 
FEntryCount,FDebitTotal,FCreditTotal,FInternalInd,FChecked, 
FPosted,FPreparerID,FCheckerID,FPosterID,FCashierID, 
FHandler,FOwnerGroupID,FObjectName,FParameter,FSerialNum, 
FTranType,FTransDate,FFrameWorkID,FApproveID,FFootNote, 
UUID , FMODIFYTIME 
From t_Voucher 
Union All 
Select 
FBrNo,FvoucherID,FDate,FYear,FPeriod, 
FGroupID,FNumber,FReference,FExplanation,FAttachments, 
FEntryCount,FDebitTotal,FCreditTotal,FInternalInd,FChecked, 
FPosted,FPreparerID,FCheckerID,FPosterID,FCashierID, 
FHandler,FOwnerGroupID,FObjectName,FParameter,FSerialNum, 
FTranType,FTransDate,FFrameWorkID,FApproveID,FFootNote, 
UUID , FMODIFYTIME 
From t_VoucherAdjust)  v where t.FVoucherID = v.FVoucherID and  v.FYear*100+v.FPeriod>=201909 and v.FYear*100+v.FPeriod<=201909) c on e.FVoucherID=c.FVoucherID and e.FEntryID=c.FEntryID , t_account a ,(Select 
FBrNo,FvoucherID,FDate,FYear,FPeriod, 
FGroupID,FNumber,FReference,FExplanation,FAttachments, 
FEntryCount,FDebitTotal,FCreditTotal,FInternalInd,FChecked, 
FPosted,FPreparerID,FCheckerID,FPosterID,FCashierID, 
FHandler,FOwnerGroupID,FObjectName,FParameter,FSerialNum, 
FTranType,FTransDate,FFrameWorkID,FApproveID,FFootNote, 
UUID , FMODIFYTIME 
From t_Voucher 
Union All 
Select 
FBrNo,FvoucherID,FDate,FYear,FPeriod, 
FGroupID,FNumber,FReference,FExplanation,FAttachments, 
FEntryCount,FDebitTotal,FCreditTotal,FInternalInd,FChecked, 
FPosted,FPreparerID,FCheckerID,FPosterID,FCashierID, 
FHandler,FOwnerGroupID,FObjectName,FParameter,FSerialNum, 
FTranType,FTransDate,FFrameWorkID,FApproveID,FFootNote, 
UUID , FMODIFYTIME 
From t_VoucherAdjust)  v, t_vouchergroup g ,t_currency r where  v.FYear*100+v.FPeriod>=201909 and v.FYear*100+v.FPeriod<=201909 and e.FCurrencyID=1 and e.FVoucherID=v.FVoucherID and  e.FAccountID = a.FAccountID and v.FGroupID=g.FGroupID and e.FCurrencyID=r.FCurrencyID ) as c 



select distinct fnumber from  #Cashflow1436199 where (fcashitem is not null or fcashsubitem is not null)order by fnumber

drop table   #Cashflow1436199