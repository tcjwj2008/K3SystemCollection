IF OBJECT_ID('sp_ysyf_df')IS NOT NULL DROP  PROC sp_ysyf_df
go
CREATE  PROC dbo.sp_ysyf_df(@FNumber VARCHAR(20),@type INT )
AS
	DECLARE @sql VARCHAR(8000)
	IF @type = 1
		SELECT ISNULL(ABS(SUM(t.FEndCreditLocal)),0) FROM ( SELECT SUM(FEndCreditLocal) AS FEndCreditLocal FROM t_sl 
		WHERE FNumber =@FNumber OR FNumber LIKE ''+@FNumber+'.%'
		GROUP BY FItemNumber)t WHERE t.FEndCreditLocal>0 
	IF @type = -1
		SELECT ISNULL(ABS(SUM(t.FEndCreditLocal)),0) FROM ( SELECT SUM(FEndCreditLocal) AS FEndCreditLocal FROM t_sl
		WHERE  FNumber =@FNumber OR FNumber LIKE''+@FNumber+'.%'
		GROUP BY FItemNumber)t WHERE t.FEndCreditLocal<0