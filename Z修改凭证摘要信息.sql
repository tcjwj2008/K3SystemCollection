
select  *
from t_Voucherentry  
where 

1=1
and FExplanation like '%�¸�����%' 

and FVoucherID not in (
select FVoucherID
from t_Voucherentry  
where 
 FExplanation   like '%��%')   and   FVoucherID not in(
 select FVoucherID
from t_Voucherentry  
where FExplanation   like '%��%')
 


select t_VoucherEntry.* 
from t_voucher,t_VoucherEntry
where 
t_VoucherEntry.FVoucherID=t_voucher.FVoucherID and 
1=1

 
 and FNumber=31 
 and FDate='2009-01-31 00:00:00.000'
 
 
select * from t_VoucherEntry
----------

select  CHARINDEX('�¸���',FExplanation),* 
from t_voucherentry  
where 
(charindex('(',fexplanation)>0 or charindex('��',fexplanation)>0)and 
(charindex('��',fexplanation)>0 or charindex(')',fexplanation)>0) and 
1=1
and CHARINDEX('�¸�����',FExplanation)>0

order by FVoucherID

-------------------------------------------------------------
update t_voucherentry  
set fexplanation='�¸�����'
where 
(charindex('(',fexplanation)>0 or charindex('��',fexplanation)>0)and 
(charindex('��',fexplanation)>0 or charindex(')',fexplanation)>0) and 
1=1
and CHARINDEX('�¸�����',FExplanation)>0

order by FVoucherID

------


select *
from t_voucher

where

 CHARINDEX('�¸�����',FExplanation)>0 and 

(CHARINDEX('(',fexplanation)>0 )and 
(CHARINDEX(')',fexplanation)>0)  



------
select *
from t_voucher

where

 CHARINDEX('�¸�����',FExplanation)>0 and 

(CHARINDEX('��',fexplanation)>0 )and 
(CHARINDEX('��',fexplanation)>0)  

---
select *
from t_voucher

where

 CHARINDEX('�¸�����',FExplanation)>0 and 

(CHARINDEX('��',fexplanation)>0 )and 
(CHARINDEX(')',fexplanation)>0)


select *
from t_voucher

where

 CHARINDEX('�¸�����',FExplanation)>0 and 

(CHARINDEX('(',fexplanation)>0 )and 
(CHARINDEX('��',fexplanation)>0)