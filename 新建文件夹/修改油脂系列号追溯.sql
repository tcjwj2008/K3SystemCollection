/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [batchno]
  FROM [YXYZ].[dbo].[qx_updateBatchno]
  
  delete from qx_updateBatchno where batchno='047001'
  update serial set serial_no=1000 where table_key='cpxx'
  update serial set serial_no=2480 where table_key='jyxx'