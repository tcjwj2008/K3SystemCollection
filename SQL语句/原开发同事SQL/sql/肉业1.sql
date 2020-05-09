IF OBJECT_ID('sp_ysyf_dzp')IS NOT NULL DROP  PROC sp_ysyf_dzp
go
CREATE PROC dbo.sp_ysyf_dzp(@Datetime DATETIME )
AS
BEGIN
	DECLARE @Year INT 
	DECLARE @Month INT
	DECLARE @FPeriod INT,@type INT
	DECLARE @FItemNumber VARCHAR(200)
	SET @type =1
	SET @Year = DATEPART(YEAR,@Datetime)
	SET @Month = DATEPART(MONTH,@Datetime)
	SET @FPeriod = @Year*100 + @Month
	IF OBJECT_ID('t_sl') IS NOT NULL DROP TABLE t_sl
	IF OBJECT_ID('t_by') IS NOT NULL DROP TABLE t_by
	SELECT t.*,@FItemNumber AS FItemNumber Into t_sl FROM
	(Select 0 FBalanceTotal,a.FAccountID,a.FNumber ,
	CONVERT(varchar(800),a.FName) FName,a.FLevel,a.FDC,a.FDetail,a.FParentID,a.FRootID,
	ISNULL(b.FDetailID,0) FDetailID,ISNULL(FBeginBalanceFor,0) FBeginBalanceFor, 
	ISNULL(FBeginBalance,0) FBeginBalanceLocal, ISNULL(FEndBalanceFor,0) FEndBalanceFor, ISNULL(FEndBalance,0)
	FEndBalanceLocal, ISNULL(FDebitFor,0) FDebit, ISNULL(FDebit,0) FDebitLocal, ISNULL(FCreditFor,0) FCredit, 
	ISNULL(FCredit,0) FCreditLocal, ISNULL(FYtdDebitFor,0) FYtdDebit, ISNULL(FYtdDebit,0) FYtdDebitLocal,
	ISNULL(FYtdCreditFor,0) FYtdCredit, ISNULL(FYtdCredit,0) FYtdCreditLocal, ISNULL(CASE WHEN FDC > 0
	THEN FBeginBalanceFor END,0) FBeginDebit, ISNULL(CASE WHEN FDC > 0 THEN FBeginBalance END,0) FBeginDebitLocal,
	ISNULL(CASE WHEN FDC < 0 THEN -FBeginBalanceFor END,0) FBeginCredit, ISNULL(CASE WHEN FDC < 0 THEN -FBeginBalance END,0) 
	FBeginCreditLocal, ISNULL(CASE WHEN FDC> 0 THEN FEndBalanceFor END,0) FEndDebit, 
	ISNULL(CASE WHEN FDC> 0 THEN FEndBalance END,0) FEndDebitLocal, ISNULL(CASE WHEN FDC < 0 THEN -FEndBalanceFor END,0) FEndCredit, 
	ISNULL(CASE WHEN FDC < 0 THEN -FEndBalance END,0) FEndCreditLocal  
	FROM t_Account a  LEFT OUTER JOIN   
	( Select * From t_Balance  WHERE  FCurrencyID=1 And  FYear*100+FPeriod ='201808'  ) b On a.FAccountID = b.FAccountID  WHERE 1=1    ) t 
	
	DELETE b from t_sl b where b.FBeginCredit=0 and b.FBeginDebit=0 and FBeginCreditLocal=0 and b.FBeginDebitLocal=0 and b.FDebit=0 and b.FCredit=0 and b.FDebitLocal=0 and b.FCreditLocal=0 and b.FYtdDebit=0 and b.FYtdCredit=0 and b.FYtdDebitLocal=0 and b.FYtdCreditLocal=0 and b.FEndBalanceFor=0 and b.FEndBalanceLocal=0 
	
	UPDATE t_sl SET  FName=Space(Flevel*2-2) + FName  where len(isnull(FNumber,'')) >0 and FDetailID=0  
	
	
	SELECT t1.FDetailID,convert(nvarchar(800), '') FName,convert(nvarchar(800), '') FNumber  Into t_by From t_ItemDetail as t1 Inner join  ( Select Distinct FDetailID From t_sl Where FDetailID >0) as t2 On t1.FDetailID=t2.FDetailID   Where t1.FDetailID>0 
	
	UPDATE t_by Set FName =Left(FName +'/'+ IsNull(t.FN,''),800),FNumber =Left(FNumber +'/'+ IsNull(t.FNum,''),800)  From (Select  FDetailID F1,  '['+FNumber+']'+FName FN,FNumber FNum From t_Itemdetail a, t_item b where b.FitemID>0 And b.FitemID=a.f3005 ) t  Where FDetailID=t.F1
	
	UPDATE t_by Set FName =Left(FName +'/'+ IsNull(t.FN,''),800),FNumber =Left(FNumber +'/'+ IsNull(t.FNum,''),800)  From (Select  FDetailID F1,  '['+FNumber+']'+FName FN,FNumber FNum From t_Itemdetail a, t_item b where b.FitemID>0 And b.FitemID=a.f1 ) t  Where FDetailID=t.F1
	
	UPDATE t_by Set FName =Left(FName +'/'+ IsNull(t.FN,''),800),FNumber =Left(FNumber +'/'+ IsNull(t.FNum,''),800)  From (Select  FDetailID F1,  '['+FNumber+']'+FName FN,FNumber FNum From t_Itemdetail a, t_item b where b.FitemID>0 And b.FitemID=a.f2 ) t  Where FDetailID=t.F1
	
	UPDATE t_by Set FName =Left(FName +'/'+ IsNull(t.FN,''),800),FNumber =Left(FNumber +'/'+ IsNull(t.FNum,''),800)  From (Select  FDetailID F1,  '['+FNumber+']'+FName FN,FNumber FNum From t_Itemdetail a, t_item b where b.FitemID>0 And b.FitemID=a.f3 ) t  Where FDetailID=t.F1
	
	UPDATE t_by Set FName =Left(FName +'/'+ IsNull(t.FN,''),800),FNumber =Left(FNumber +'/'+ IsNull(t.FNum,''),800)  From (Select  FDetailID F1,  '['+FNumber+']'+FName FN,FNumber FNum From t_Itemdetail a, t_item b where b.FitemID>0 And b.FitemID=a.f8 ) t  Where FDetailID=t.F1
	
	UPDATE t_by Set FName =Left(FName +'/'+ IsNull(t.FN,''),800),FNumber =Left(FNumber +'/'+ IsNull(t.FNum,''),800)  From (Select  FDetailID F1,  '['+FNumber+']'+FName FN,FNumber FNum From t_Itemdetail a, t_item b where b.FitemID>0 And b.FitemID=a.f3001 ) t  Where FDetailID=t.F1
	
	UPDATE t_by Set FName =STUFF(FName, 1, 1, ''),FNumber=STUFF(FNumber, 1, 1, '') 
	
	UPDATE t_sl Set  FName=Space(Flevel*2-2 +4) + t1.n1  ,FItemNumber = left(t1.FNumber,200)  From (Select FDetailID d1 ,FName  n1,FNumber From (Select * From dbo.T_by ) t2  ) t1 Where FDetailID>0 AND FDetailID=t1.d1
	
	DELETE FROM t_sl WHERE ISNULL(FItemNumber,'')=''
	SELECT  FNumber AS '科目编码',FName AS 名称,FBeginDebitLocal AS '期初借方',FBeginCredit AS '期初贷方',
	FYtdDebitLocal AS 本年累计借方,FYtdCreditLocal 本年累计贷方,FEndDebitLocal 期末借方,FEndCreditLocal AS 期末贷方
	FROM dbo.t_sl 

END