--修改应付管理的账期
Update t_RP_SystemProfile Set FValue = '11' Where FCategory = 'ARP' And FKey = 'FAPCurPeriod';
--Update t_RP_SystemProfile Set FValue = '2017' Where FCategory = 'ARP' And FKey ='FAPCurYear';
--删除应付管理的 6-12 月往来余额数据。
--只要大于 2017 年 5 期的应付往来余额数据都要删除
Delete from t_RP_ContactBal Where FYear = 2019 And FPeriod = 12 and FRP=0