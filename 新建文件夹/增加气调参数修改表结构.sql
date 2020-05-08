alter table t_Item_XS_Base_New add 气调系数 float;
update t_Item_XS_Base_New set 气调系数=1;
alter table t_CustDate_PerMonth add txtMapAccount2 float 
alter table t_CustDate_PerMonth add txtMapAccount1 float
update t_CustDate_PerMonth set txtMapAccount2=0;
update t_CustDate_PerMonth set txtMapAccount1=0;
ALTER TABLE  t_yxryCost ADD CC FLOAT;
ALTER TABLE  t_yxryCost ADD DD FLOAT;
ALTER TABLE  t_yxryCost ADD EE NVARCHAR(MAX);
ALTER TABLE  t_yxryCost ADD FF FLOAT;

SELECT * FROM t_yxryCost


