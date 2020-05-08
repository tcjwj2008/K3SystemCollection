Create table t_BOS_Synchro(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FDBName] varchar(100),
	[FK3Name] varchar(100)
)ON [PRIMARY]

insert into t_BOS_Synchro(FDBName,FK3Name)
select 'AIS_YXYZ_2','帐套同步'



--AIS_YXYZ  --源帐套
 --AIS_YXYZ_2  --目标帐套