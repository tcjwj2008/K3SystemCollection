--编号
use YXYZ;
SELECT TOP 1000 [table_key]
      ,[serial_no]
      ,[remark]
  FROM [YXYZ].[dbo].[serial]
  
--update serial set serial_no=837 where table_key='scxx'  

use XMYX_DB;
--交易信息
select * from qx_OilDepart order by Autoid desc

--生产信息
select * from qx_OilInAndOut order by Autoid desc;
