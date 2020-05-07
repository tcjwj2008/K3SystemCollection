
select  *
from t_Voucherentry  
where 

1=1
and FExplanation like '%麻腦矨質遴%' 

and FVoucherID not in (
select FVoucherID
from t_Voucherentry  
where 
 FExplanation   like '%遜%')   and   FVoucherID not in(
 select FVoucherID
from t_Voucherentry  
where FExplanation   like '%喳%')
 


select t_VoucherEntry.* 
from t_voucher,t_VoucherEntry
where 
t_VoucherEntry.FVoucherID=t_voucher.FVoucherID and 
1=1

 
 and FNumber=31 
 and FDate='2009-01-31 00:00:00.000'
 
 
select * from t_VoucherEntry
----------

select  CHARINDEX('麻腦矨',FExplanation),* 
from t_voucherentry  
where 
(charindex('(',fexplanation)>0 or charindex('ㄗ',fexplanation)>0)and 
(charindex('ㄘ',fexplanation)>0 or charindex(')',fexplanation)>0) and 
1=1
and CHARINDEX('麻腦矨質遴',FExplanation)>0

order by FVoucherID

-------------------------------------------------------------
update t_voucherentry  
set fexplanation='麻腦矨質遴'
where 
(charindex('(',fexplanation)>0 or charindex('ㄗ',fexplanation)>0)and 
(charindex('ㄘ',fexplanation)>0 or charindex(')',fexplanation)>0) and 
1=1
and CHARINDEX('麻腦矨質遴',FExplanation)>0

order by FVoucherID

------


select *
from t_voucher

where

 CHARINDEX('麻腦矨質遴',FExplanation)>0 and 

(CHARINDEX('(',fexplanation)>0 )and 
(CHARINDEX(')',fexplanation)>0)  



------
select *
from t_voucher

where

 CHARINDEX('麻腦矨質遴',FExplanation)>0 and 

(CHARINDEX('ㄗ',fexplanation)>0 )and 
(CHARINDEX('ㄘ',fexplanation)>0)  

---
select *
from t_voucher

where

 CHARINDEX('麻腦矨質遴',FExplanation)>0 and 

(CHARINDEX('ㄗ',fexplanation)>0 )and 
(CHARINDEX(')',fexplanation)>0)


select *
from t_voucher

where

 CHARINDEX('麻腦矨質遴',FExplanation)>0 and 

(CHARINDEX('(',fexplanation)>0 )and 
(CHARINDEX('ㄘ',fexplanation)>0)