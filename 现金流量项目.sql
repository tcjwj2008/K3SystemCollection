/****
现金流量项目
***/


select * from t_Voucher                                                                                                                                          
go
spk3_2tab @sname='t_Voucher'    
go                                                           
spk3_2str @sname='t_Voucher' 

go
spk3_2str @sname='t_VoucherEntry'

select * from t_TableDescription where FDescription like '%凭证%'


select a.* from t_Voucher a,t_VoucherEntry b
where a.FVoucherID=b.FVoucherID
and FYear=2019 and FPeriod=7 and b.FCashFlowItem=1