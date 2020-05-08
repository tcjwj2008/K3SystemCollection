USE [YXERP]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--肉业成本自动获取导入
ALTER PROC [dbo].[sp_yxryCostAutoImport_qiu]
(
@Fdate varchar(20),
@FuserName varchar(50)
)
AS
DECLARE @fdate1 VARCHAR(20);
DELETE yx_rs_ysprice_CHECK WHERE FuserName=@FuserName    --删除临时数据
DELETE yx_rs_DayHeadNum_Check WHERE FuserName=@FuserName --删除临时数据
/*郑惠婷新增外购入库单价*/
SELECT @fdate1=CONVERT(VARCHAR(20),DATEADD(DAY,-60,CONVERT(DATETIME,@Fdate)))





/*郑惠婷新增外购入库单价*/

--处理当天成本
 INSERT INTO yx_rs_ysprice_CHECK(Fnumber,Fprice,FDATE,FuserName) 
 SELECT D,S,@Fdate,@FuserName FROM AIS_YXRY2.dbo.t_yxryCost WHERE ffdate=@Fdate  AND B<> '合计' AND c<>'代宰客户'
--处理当天屠宰头数 



CREATE TABLE #t (
      killtime DATETIME,
      clientname VARCHAR(100),
      quantity FLOAT ,
      grossweight FLOAT ,
      [weight] FLOAT ,
      settlemoney FLOAT 
    )
    
INSERT INTO #t EXEC con12.yrtzdata.dbo.bb_se_getsettledata '11',@Fdate,@Fdate 
DECLARE @sumquantity float
SELECT @sumquantity=ISNULL(SUM(quantity),0) FROM #t

INSERT INTO yx_rs_DayHeadNum_Check(FDayHeadNum,FDATE,FuserName) SELECT @sumquantity,@Fdate,@FuserName


-- 以下是原取青花瓷的数据

--INSERT INTO yx_rs_DayHeadNum_Check(FDayHeadNum,FDATE,FuserName)
--SELECT SUM([Butcher_Number]) 头数 ,@Fdate,@FuserName
--from  con110.[B2-Butchery].dbo.Butchery_ZiYuan_ButcherSettlementAnalys_View  WHERE [ButcherDate] =@Fdate

  
  