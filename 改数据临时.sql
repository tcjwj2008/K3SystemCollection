

SELECT * FROM yx_rs_ysprice WHERE fdate >='2019-08-23' AND Fnumber='7.1.01.01.00685'/*
update yx_rs_ysprice SET fprice=27.9792 WHERE fdate ='2019-08-23' AND Fnumber='7.1.01.01.00685'
--SELECT * FROM yx_rs_ysprice WHERE fdate ='2019-08-24' AND Fnumber='7.1.01.01.00685'
INSERT INTO yx_rs_ysprice(fnumber,fdate,fprice,fusername) VALUES('7.1.01.01.00685','2019-08-24','27.9792','admin')
--SELECT * FROM yx_rs_ysprice WHERE fdate ='2019-08-25' AND Fnumber='7.1.01.01.00685'
INSERT INTO yx_rs_ysprice(fnumber,fdate,fprice,fusername) VALUES('7.1.01.01.00685','2019-08-25','27.9792','admin')
--SELECT * FROM yx_rs_ysprice WHERE fdate ='2019-08-26' AND Fnumber='7.1.01.01.00685'
INSERT INTO yx_rs_ysprice(fnumber,fdate,fprice,fusername) VALUES('7.1.01.01.00685','2019-08-26','28.1965','admin')
--SELECT * FROM yx_rs_ysprice

ROLLBACK*/