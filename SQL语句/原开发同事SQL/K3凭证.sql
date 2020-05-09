select isnull(max(FNumber),0)+1 as FNumber from t_Voucher where FNumber < 200 and FYear='2018' and FPeriod='12' and FGroupID='1'


select * from t_Voucher 
where FYear='2018' and FPeriod='2' and FGroupID='1' and FSynchroID=1
order by FDate desc

select * from t_Voucher 
where FYear='2018' and FPeriod='1' and FGroupID='1' and FSynchroID=1
order by FNumber asc


select * from t_Voucher 
where FYear='2018' and FPeriod='2' and FGroupID='1' 
order by FNumber asc


select * from t_Voucher 
where FYear='2018' and FPeriod='2' and FGroupID='1' 
order by FNumber asc

--delete from t_Voucher
--where FYear='2018' and FPeriod='1' and FGroupID='1' and FVoucherID=20497