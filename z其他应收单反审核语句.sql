---1
SELECT  * FROM t_RP_ARPBill WHERE FChecker='16581'

---2
select B.* from t_RP_ARPBill a,t_RP_Contact b
where a.FNumber=b.FNumber and FChecker='16581'

update b set FStatus=0,FToBal=0  
from t_RP_ARPBill a,t_RP_Contact b
where a.FNumber=b.FNumber and FChecker='16581'


UPDATE t_RP_ARPBill set FChecker=0,FStatus=0  ,fcheckdate=null  FROM t_RP_ARPBill WHERE FChecker='16581'

