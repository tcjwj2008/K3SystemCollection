--------------------------准备要修改的数据开始----------------------------------------

CREATE TABLE #abc (物料代码 VARCHAR(50),旧批次 VARCHAR(50),新批次 VARCHAR(50))

insert into #abc(物料代码,旧批次,新批次) values('220.010052','20180531生产日期20180528','');
insert into #abc(物料代码,旧批次,新批次) values('220.010060','0001120807','');
insert into #abc(物料代码,旧批次,新批次) values('220.010060','0001120809','');
insert into #abc(物料代码,旧批次,新批次) values('220.010060','0001120818','');
insert into #abc(物料代码,旧批次,新批次) values('220.010060','20120907','');
insert into #abc(物料代码,旧批次,新批次) values('220.010060','20120916','');
insert into #abc(物料代码,旧批次,新批次) values('220.010060','20170310','');
insert into #abc(物料代码,旧批次,新批次) values('220.010060','20171102 生产日期20170901（肉业）','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','0001110303','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','0001110401','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','0001110412','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','0001110515','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','0001110518','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','0001110522','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','0001110714','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','0001120723','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','20130531','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','20150528','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','20150711','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','20150721','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','20171226生产日期20170901（肉业）','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','20180127生产日期20170418(容和盛)','');
insert into #abc(物料代码,旧批次,新批次) values('220.01007','20180530生产日期20180401肉业','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','0001110610','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','0001110710','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','20150309','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','20151224','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','20151225','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','20151231','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','20171226生产日期20171201（肉业）','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','20171226生产日期20171201（肉业TK）','');
insert into #abc(物料代码,旧批次,新批次) values('220.01011','20180127生产日期20170508(容和盛)','');
insert into #abc(物料代码,旧批次,新批次) values('220.01012','0001110504','');
insert into #abc(物料代码,旧批次,新批次) values('220.01012','0001140307','');
insert into #abc(物料代码,旧批次,新批次) values('220.01012','0001140308','');
insert into #abc(物料代码,旧批次,新批次) values('220.01012','0006110612','');
insert into #abc(物料代码,旧批次,新批次) values('220.01012','0006120806','');
insert into #abc(物料代码,旧批次,新批次) values('220.01012','20160313','');
insert into #abc(物料代码,旧批次,新批次) values('220.01012','20161108','');
insert into #abc(物料代码,旧批次,新批次) values('220.01013','0051110421','');
insert into #abc(物料代码,旧批次,新批次) values('220.01013','20121022','');
insert into #abc(物料代码,旧批次,新批次) values('220.01013','20150309','');
insert into #abc(物料代码,旧批次,新批次) values('220.01013','20160201','');
insert into #abc(物料代码,旧批次,新批次) values('220.01014','0001110819','');
insert into #abc(物料代码,旧批次,新批次) values('220.01014','0001111012','');
insert into #abc(物料代码,旧批次,新批次) values('220.01014','0001111103','');
insert into #abc(物料代码,旧批次,新批次) values('220.01014','0001111125','');
insert into #abc(物料代码,旧批次,新批次) values('220.01014','0001111126','');
insert into #abc(物料代码,旧批次,新批次) values('220.010141','20170705 生产日期 20170824 10kg/件','');
insert into #abc(物料代码,旧批次,新批次) values('220.010141','20171226生产日期20170401（肉业）','');
insert into #abc(物料代码,旧批次,新批次) values('220.01015','0000110510','');
insert into #abc(物料代码,旧批次,新批次) values('220.01015','0001110510','');
insert into #abc(物料代码,旧批次,新批次) values('220.01015','0001110511','');
insert into #abc(物料代码,旧批次,新批次) values('220.01015','0001110512','');
insert into #abc(物料代码,旧批次,新批次) values('220.01015','0001110611','');
insert into #abc(物料代码,旧批次,新批次) values('220.01015','0001110612','');
insert into #abc(物料代码,旧批次,新批次) values('220.01016','0006120101','');
insert into #abc(物料代码,旧批次,新批次) values('220.0101842','20180404生产日期20180401 肉业','');
insert into #abc(物料代码,旧批次,新批次) values('220.0101842','20180430生产日期20180401 肉业','');
insert into #abc(物料代码,旧批次,新批次) values('220.0101843','20180418生产日期20180401 肉业','');
insert into #abc(物料代码,旧批次,新批次) values('220.01024','0001110411','');
insert into #abc(物料代码,旧批次,新批次) values('220.01024','0001110514','');
insert into #abc(物料代码,旧批次,新批次) values('220.01024','0001110609','');
insert into #abc(物料代码,旧批次,新批次) values('220.01024','0001110610','');
insert into #abc(物料代码,旧批次,新批次) values('220.01024','0001110617','');
insert into #abc(物料代码,旧批次,新批次) values('220.010261','20161018','');
insert into #abc(物料代码,旧批次,新批次) values('220.010280','20160319','');
insert into #abc(物料代码,旧批次,新批次) values('220.010280','20170617','');
insert into #abc(物料代码,旧批次,新批次) values('220.01029','0005111105','');
insert into #abc(物料代码,旧批次,新批次) values('220.01029','0051110416','');
insert into #abc(物料代码,旧批次,新批次) values('220.01030','0001120320','');
insert into #abc(物料代码,旧批次,新批次) values('220.01030','20121228','');
insert into #abc(物料代码,旧批次,新批次) values('220.010351','20130512','');
insert into #abc(物料代码,旧批次,新批次) values('220.010351','20130513','');
insert into #abc(物料代码,旧批次,新批次) values('220.010351','20130524','');
insert into #abc(物料代码,旧批次,新批次) values('220.01036','0015120602','');
insert into #abc(物料代码,旧批次,新批次) values('220.01037','0010110917','');
insert into #abc(物料代码,旧批次,新批次) values('220.01037','0015120203','');
insert into #abc(物料代码,旧批次,新批次) values('220.01038','0059111117','');
insert into #abc(物料代码,旧批次,新批次) values('220.010409','20130605/15','');
insert into #abc(物料代码,旧批次,新批次) values('220.010409','20130710-21','');
insert into #abc(物料代码,旧批次,新批次) values('220.010556','0058110902','');
insert into #abc(物料代码,旧批次,新批次) values('220.010556','0060120316','');
insert into #abc(物料代码,旧批次,新批次) values('220.010556','20130405','');
insert into #abc(物料代码,旧批次,新批次) values('220.010566','20150911-20151001','');
insert into #abc(物料代码,旧批次,新批次) values('220.010567','20160115','');
insert into #abc(物料代码,旧批次,新批次) values('220.010568','WQ20160219','');
insert into #abc(物料代码,旧批次,新批次) values('220.01058','0037110420','');
insert into #abc(物料代码,旧批次,新批次) values('220.01058','0052110508','');
insert into #abc(物料代码,旧批次,新批次) values('220.01059','0005110428','');
insert into #abc(物料代码,旧批次,新批次) values('220.01059','0009110414','');
insert into #abc(物料代码,旧批次,新批次) values('220.01059','20170708 生产日期 20170705 正太 10kg/件','');
insert into #abc(物料代码,旧批次,新批次) values('220.01062','0009111209','');
insert into #abc(物料代码,旧批次,新批次) values('220.01062','0009111221','');
insert into #abc(物料代码,旧批次,新批次) values('220.01062','20160626','');
insert into #abc(物料代码,旧批次,新批次) values('220.01082','0125111026','');
insert into #abc(物料代码,旧批次,新批次) values('220.01082','0125111110','');
insert into #abc(物料代码,旧批次,新批次) values('220.01082','20131028','');
insert into #abc(物料代码,旧批次,新批次) values('220.01082','20160307','');
insert into #abc(物料代码,旧批次,新批次) values('220.01090','0051110415','');
insert into #abc(物料代码,旧批次,新批次) values('220.01090','0051110417','');
insert into #abc(物料代码,旧批次,新批次) values('220.02008','20180515','');
insert into #abc(物料代码,旧批次,新批次) values('220.02008','20180516','');
insert into #abc(物料代码,旧批次,新批次) values('220.90021','0000121103','');
insert into #abc(物料代码,旧批次,新批次) values('220.90021','0000130228','');
insert into #abc(物料代码,旧批次,新批次) values('220.90021','0001120831','');
insert into #abc(物料代码,旧批次,新批次) values('220.90021','0001130131','');
insert into #abc(物料代码,旧批次,新批次) values('220.90021','0001130331','');
insert into #abc(物料代码,旧批次,新批次) values('220.90021','0001151231','');
insert into #abc(物料代码,旧批次,新批次) values('220.90021','20151231B','');
insert into #abc(物料代码,旧批次,新批次) values('220.90023','20151231B','');
insert into #abc(物料代码,旧批次,新批次) values('220.90024','0001151231','');
insert into #abc(物料代码,旧批次,新批次) values('220.90024','20151231B','');
insert into #abc(物料代码,旧批次,新批次) values('220.90025','0001151231','');
insert into #abc(物料代码,旧批次,新批次) values('220.90025','20151231B','');
insert into #abc(物料代码,旧批次,新批次) values('220.90025','20170105','');
insert into #abc(物料代码,旧批次,新批次) values('220.90026','0001151231','');
insert into #abc(物料代码,旧批次,新批次) values('220.90026','20151231B','');
insert into #abc(物料代码,旧批次,新批次) values('220.90027','0001151231','');
insert into #abc(物料代码,旧批次,新批次) values('220.90027','20151231B','');
insert into #abc(物料代码,旧批次,新批次) values('220.90028','0001151231','');
insert into #abc(物料代码,旧批次,新批次) values('220.90028','20151231B','');
insert into #abc(物料代码,旧批次,新批次) values('220.90029','20170523','');
insert into #abc(物料代码,旧批次,新批次) values('220.90030','0001111130','');
insert into #abc(物料代码,旧批次,新批次) values('220.90030','0001130808','');
insert into #abc(物料代码,旧批次,新批次) values('220.90030','0006111130','');
insert into #abc(物料代码,旧批次,新批次) values('220.90030','0006111231','');
insert into #abc(物料代码,旧批次,新批次) values('220.90030','0006120831','');


ALTER TABLE #abc ADD 内码 INT

--SELECT * FROM #abc a
--INNER JOIN dbo.t_ICItem t ON a.物料代码=t.FNumber

UPDATE a SET 内码=T.fitemid FROM #abc a
INNER JOIN dbo.t_ICItem t ON a.物料代码=t.FNumber


--SELECT * FROM #abc


--------------------------准备要修改的数据结束----------------------------------------




--------------------------处理存货初始数据表开始(表:icinvinitial )----------------------------------------

--SELECT b.* FROM icinvinitial b
--INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

UPDATE b SET b.FBatchNo=a.新批次 FROM icinvinitial b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

--------------------------处理存货初始数据表结束(表:icinvinitial )----------------------------------------




--------------------------处理库房存货开始(表:icinvbal)----------------------------------------
SELECT * INTO #icinvbal FROM icinvbal b  --写入临时数据
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

--删除库房存货数据
DELETE b  FROM icinvbal b  
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

--根据临时表处理插入库房存货数据

UPDATE #icinvbal SET FBatchNo=新批次

--SELECT * FROM #icinvbal

INSERT INTO icinvbal
SELECT FBrNo, FYear,FPeriod,FStockID,FItemID,FBatchNo, 
SUM(FBegQty)FBegQty,
sum(FReceive)FReceive,
sum(FSend)FSend,
sum(FYtdReceive)FYtdReceive,
sum(FYtdSend)FYtdSend,
sum(FEndQty)FEndQty,
sum(FBegBal)FBegBal,
sum(FDebit)FDebit,
sum(FCredit)FCredit,
sum(FYtdDebit)FYtdDebit,
sum(FYtdCredit)FYtdCredit,
sum(FEndBal)FEndBal,
sum(FBegDiff)FBegDiff,
sum(FReceiveDiff)FReceiveDiff,
sum(FSendDiff)FSendDiff,
sum(FEndDiff)FEndDiff,
FBillInterID,FStockPlaceID,FKFPeriod,FKFDate,
sum(FYtdReceiveDiff)FYtdReceiveDiff,
sum(FYtdSendDiff)FYtdSendDiff,
sum(FSecBegQty)FSecBegQty,
sum(FSecReceive)FSecReceive,
sum(FSecSend)FSecSend,
sum(FSecYtdReceive)FSecYtdReceive,
sum(FSecYtdSend)FSecYtdSend,
sum(FSecEndQty)FSecEndQty,
FAuxPropID,
FStockInDate,FMTONo,FSupplyID  FROM dbo.#icinvbal 
GROUP BY 
FBrNo,FYear,FPeriod,FStockID,FItemID,FBatchNo,FBillInterID,FStockPlaceID,FKFPeriod,FKFDate,FAuxPropID,
FStockInDate,FMTONo,FSupplyID 

--------------------------处理库房存货结束(表:icinvbal)----------------------------------------


--------------------------处理存货余额表开始(表:icbal)----------------------------------------

SELECT * INTO #icbal FROM icbal b  --写入临时数据
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

--删除存货余额表数据
DELETE b  FROM icbal b  
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

--根据临时表处理插入库房存货数据

UPDATE #icbal SET FBatchNo=新批次

--SELECT * FROM #icbal

INSERT INTO icbal 
SELECT FBrNo, FYear,FPeriod,FItemID,FBatchNo,
sum(FBegQty)FBegQty,
sum( FReceive) FReceive,
sum( FSend) FSend,
sum( FYtdReceive) FYtdReceive,
sum( FYtdSend) FYtdSend,
sum( FEndQty) FEndQty,
sum( FBegBal) FBegBal,
sum( FDebit) FDebit,
sum( FCredit) FCredit,
sum( FYtdDebit) FYtdDebit,
sum( FYtdCredit) FYtdCredit,
sum( FEndBal) FEndBal,
sum( FBegDiff) FBegDiff,
sum( FReceiveDiff) FReceiveDiff,
sum( FSendDiff) FSendDiff,
sum( FEndDiff) FEndDiff,
FBillInterID,FEntryID,FStockGroupID,
sum( FYtdReceiveDiff) FYtdReceiveDiff,
sum( FYtdSendDiff) FYtdSendDiff,
sum( FSecBegQty) FSecBegQty,
sum( FSecReceive) FSecReceive,
sum( FSecSend) FSecSend,
sum( FSecYtdReceive) FSecYtdReceive,
sum( FSecYtdSend) FSecYtdSend,
sum( FSecEndQty) FSecEndQty,
FStockInDate,FAuxPropID 
from   #icbal
GROUP BY 
FBrNo, FYear,FPeriod,FItemID,FBatchNo,
FBillInterID,FEntryID,FStockGroupID,
FStockInDate,FAuxPropID 

--------------------------处理存货余额表结束(表:icbal)----------------------------------------

--------------------------处理出入库表开始(表:ICStockBillEntry)----------------------------------------

SELECT b.FBatchNo,a.旧批次,a.新批次 FROM dbo.ICStockBillEntry b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次

UPDATE b SET b.FBatchNo=a.新批次 FROM ICStockBillEntry b
INNER JOIN #abc a ON b.FItemID=a.内码 AND b.FBatchNo=a.旧批次
 
--------------------------处理出入库表结束(表:ICStockBillEntry)----------------------------------------

 