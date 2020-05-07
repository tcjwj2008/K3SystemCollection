--豆制品测试环境禁用APP同步触发器

alter table t_Organization disable trigger trgSyn_Organization  --同步客户
alter table t_Item disable trigger trgSyn_T_ICITEM  --同步物料

alter table ICPrcPlyEntry disable trigger trgSyn_Levelprice  --同步客户价格
alter table SEOrderEntry disable trigger trg_UpAppShipNum  --反写销售出库


