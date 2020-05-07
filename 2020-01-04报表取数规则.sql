/*****
报表系统取数规则
*/

SELECT * FROM t_Balance                                                                       
WHERE FAccountID=1091

SELECT * FROM dbo.t_Account WHERE FNumber='5402'


SELECT * FROM t_Balance                                                                       
WHERE (FAccountID=1093 or FAccountID=1091)
AND  FPeriod=9 AND FYear=2019

SELECT * FROM dbo.t_Account WHERE FNumber='5502'


GO
spk3_2str @sname='t_Balance'


GO

Select FValue From t_SystemProfile Where FCategory ='GL' And FKey = 'PeriodCount'   --12
Select FValue From t_SystemProfile Where FCategory ='GL' And FKey = 'CurrentPeriod' --12
Select FValue From t_SystemProfile Where FCategory ='GL' And FKey = 'CurrentYear' --2019
Select FValue From t_SystemProfile Where FCategory ='GL' And FKey='AdjustPeriodCheck' --0
Select FValue From t_SystemProfile Where FCategory ='GL' And FKey='PeriodCount'   --12
Select FAccountID,FNumber,FParentID,FLevel From t_Account where FNumber = '5402'  --1091	5402	0	1
Select FValue from t_SystemProfile where FCategory='BOS' and FKey='AccessDataUsed'--1
select FUserID from t_Group where FUserID = 16394 and FGroupID = 1  --16394
select z.* from (( Select FAccountID,FNumber FROM t_Account  ) ) z  where z.FNumber='5402'  --1091	5402

SELECT Sum(b.FYtdAmountFor*a.FDC) FValue 
From t_ProfitAndLoss b 
INNER JOIN t_Account a ON a.FAccountID = b.FAccountID Where b.FPeriod >= 12 And b.FPeriod <= 12 And b.FYear = 2019 And b.FDetailID = 0  And a.FNumber = '5402' And b.FCurrencyID = 0

 
 
Select Sum(b.FYtdAmountFor*a.FDC) FValue 
From t_ProfitAndLoss b 
INNER JOIN t_Account a ON a.FAccountID = b.FAccountID Where b.FPeriod >= 12 And b.FPeriod <= 12 And b.FYear = 2019 And b.FDetailID = 0  And a.FNumber = '5502' And b.FCurrencyID = 0


SELECT * FROM t_ProfitAndLoss WHERE FAccountID IN (1091,1093)







