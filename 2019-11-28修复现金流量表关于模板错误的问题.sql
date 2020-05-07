	SELECT  a.*
	FROM    t_VoucherTemplate b ,
	t_VoucherEntryTemplate a
	WHERE   a.FVoucherTempID = b.FVoucherTempID
	--   AND a.FVoucherTempID = 72 
	AND a.FExplanation = '计提员工餐费补助-产业采购部';
    											
    									
    									
	SELECT  a.*
	FROM    t_VoucherTemplate b ,
	t_VoucherEntryTemplate a
	WHERE   a.FVoucherTempID = b.FVoucherTempID
	AND a.FVoucherTempID = 146;  		
	SELECT  A.*
	FROM    t_VoucherTemplate b ,
	t_VoucherEntryTemplate a
	WHERE   a.FVoucherTempID = b.FVoucherTempID
	AND a.FVoucherTempID = 133;  

	
	SELECT * FROM dbo.t_VoucherTemplate WHERE FVoucherTempID=147  
	 
	SELECT  FVoucherTempID ,
	COUNT(*)
	FROM    dbo.t_VoucherEntryTemplate
	GROUP BY FVoucherTempID
	HAVING  COUNT(*) = 24;
    SELECT * FROM dbo.t_VoucherTemplate
    
	SELECT  FIsBank ,
	FIsCash ,
	FIsCashFlow
	FROM    dbo.t_Account
	WHERE   FAccountID = 1530;

   go                                             
	dbo.SpK3_2Str @sName = 't_account'; -- varchar(50);


	SELECT * INTO t_VoucherEntryTemplate20191128 FROM t_VoucherEntryTemplate

	UPDATE dbo.t_VoucherEntryTemplate SET FCashFlowItem=(CASE WHEN t_account.FIsCash=1 THEN 1 WHEN t_account.FIsBank=1 THEN 1 WHEN t_account.FIsCashFlow=1 THEN 1 ELSE 0 END ) FROM 
	t_VoucherEntryTemplate,t_account WHERE t_VoucherEntryTemplate.FAccountID=t_account.FAccountID
	AND dbo.t_VoucherEntryTemplate.FVoucherTempID=133



	SELECT * FROM 



	SELECT dbo.t_Account.FAccountID, CASE WHEN t_account.FIsCash=1 THEN 1 WHEN t_account.FIsBank=1 THEN 1 WHEN t_account.FIsCashFlow=1 THEN 1 ELSE 0 END  FROM 
	t_VoucherEntryTemplate ,t_account WHERE t_VoucherEntryTemplate.FAccountID=t_account.FAccountID
	AND dbo.t_VoucherEntryTemplate.FVoucherTempID=133
 