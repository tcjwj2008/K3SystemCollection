USE test_yxspzhuok;
TRUNCATE TABLE icstockbill;
TRUNCATE TABLE icstockbillentry;
TRUNCATE TABLE seorder;
TRUNCATE TABLE seorderentry;
TRUNCATE TABLE icpurchase;
TRUNCATE TABLE icpurchaseentry;
TRUNCATE TABLE icsale;
TRUNCATE TABLE icsaleentry;
TRUNCATE TABLE poorder;
TRUNCATE TABLE poorderentry;
TRUNCATE TABLE t_rpcontract;
TRUNCATE TABLE t_rpcontractdetail;
TRUNCATE TABLE t_rp_contact;
TRUNCATE TABLE icbal;
--TRUNCATE TABLE icbalance;

USE test_yxspzhuok;
DELETE FROM dbo.t_Voucher WHERE fdate<'2020-03-01';
SELECT * FROM dbo.t_Voucher WHERE fdate<'2020-03-01';
DELETE FROM dbo.t_Voucher WHERE fdate<'2020-03-01';
SELECT * FROM    dbo.t_Voucher ,t_voucherentry WHERE dbo.t_Voucher.FVoucherID=dbo.t_VoucherEntry.FVoucherID
AND fdate<'2020-03-01';

DELETE FROM t_voucherentry  FROM dbo.t_Voucher ,t_voucherentry WHERE dbo.t_Voucher.FVoucherID=dbo.t_VoucherEntry.FVoucherID
AND fdate<='2020-03-01';

SELECT *  FROM t_voucherentry WHERE FVoucherID NOT IN (SELECT FVoucherID FROM t_voucher);
DELETE FROM t_voucherentry WHERE FVoucherID NOT IN (SELECT FVoucherID FROM t_voucher);

/*验证删除情况

SELECT * FROM t_rp_contact;

SELECT * FROM icbal;
SELECT * FROM icbalance;
SELECT * FROM t_rp_contract;
SELECT * FROM t_rpcontract;
SELECT * FROM t_rpcontractdetail;
SELECT * FROM  seorder;
SELECT * FROM icsale;



*/