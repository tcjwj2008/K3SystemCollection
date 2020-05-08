Create table t_BOS_Synchro(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FDBName] varchar(100),
	[FK3Name] varchar(100)
)ON [PRIMARY]

insert into t_BOS_Synchro(FDBName,FK3Name)
select 'AIS_Syn2','ÕÊÌ×Í¬²½'