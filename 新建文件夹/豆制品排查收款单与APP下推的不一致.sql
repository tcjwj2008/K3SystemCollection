/****
  排查销售出库单问题处理
***/

select top 100 * from t_RP_NewReceiveBill where  FNumber in ('XSKD213835','XSKD213836')                                                         where fbill
                                                              
                                                              
   select top 100 * from t_rp_Exchange                                                                                                                              
   select * from       t_rp_ARBillOfSH                                                                                                                      
go
select * from t_TableDescription where FDescription like '%收款%'


/****


**/


SELECT * FROM t_RP_NewReceiveBill WHERE fnumber IN ( 'XSKD098288','XSKD098289' ,'XSKD098290')
--350367
--350368
--350370

--DELETE from dbo.t_RP_Contact where isnull(fbillid,0)>0 and FBillID IN(350367,
350368,
350370)
--delete from dbo.t_rp_ARBillOfSH WHERE isnull(fbillid,0)>0 and FBillID
IN(350367,
350368,
350370)


--delete from dbo.t_rp_Exchange where isnull(fbillid,0)>0 and FBillID IN(350367,
350368,
350370)
--delete from dbo.t_RP_NewReceiveBill where isnull(fbillid,0)>0 and FBillID IN(350367,
350368,
350370)


select * from t_TableDescription where FTableName in ('t_RP_Contact','t_RP_NewReceiveBill','t_rp_ARBillOfSH','t_rp_Exchange');


SELECT * FROM t_RP_NewReceiveBill WHERE fnumber IN ( 'XSKD211607','XSKD098289' ,'XSKD098290')
--350367
--350368
--350370

select FPeriod from dbo.t_RP_Contact where isnull(fbillid,0)>0 and FBillID IN(429785,
429787)

select * from dbo.t_rp_ARBillOfSH WHERE isnull(fbillid,0)>0 and FBillID
IN(429785,
429787) 
select * from dbo.t_rp_Exchange where isnull(fbillid,0)>0 and FBillID IN(429785,
429787)
select FPeriod from dbo.t_RP_NewReceiveBill where isnull(fbillid,0)>0 and FBillID IN(429785,
429787)

/****
  查询
***/
select * from dbo.t_RP_NewReceiveBill where abs(FPeriod)<>MONTH(fdate)