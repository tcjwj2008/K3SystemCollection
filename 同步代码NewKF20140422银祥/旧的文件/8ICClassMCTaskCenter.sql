
CREATE TABLE [dbo].[ICClassMCTaskCenter](
	[FID] [int] IDENTITY(1,1) NOT NULL,
	[FCheckRecordID] [int] NOT NULL,
	[FClassTypeID] [int] NOT NULL,
	[FBillID] [int] NOT NULL,
	[FReaded] [bit] NOT NULL,
	[FSenderID] [int] NOT NULL,
	[FContent] [nvarchar](255) NOT NULL,
	[FDate] [datetime] NOT NULL,
	[FUpdateDate] [datetime] NOT NULL,
	[FStatus] [tinyint] NULL,
	[FNextLevelTag] [int] NOT NULL,
	[FTaskType] [int] NOT NULL,
	[FProcessUserID] [int] NOT NULL,
	[FBillWidth] [int] NOT NULL,
	[FBillHeight] [int] NOT NULL,
 CONSTRAINT [Idx_ICClassMCTaskCenter] PRIMARY KEY CLUSTERED 
(
	[FUpdateDate] DESC,
	[FID] ASC
)
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ICClassMCTaskCenter] ADD  DEFAULT ((0)) FOR [FReaded]
GO

ALTER TABLE [dbo].[ICClassMCTaskCenter] ADD  DEFAULT ((0)) FOR [FTaskType]
GO

ALTER TABLE [dbo].[ICClassMCTaskCenter] ADD  DEFAULT ((-2)) FOR [FProcessUserID]
GO

ALTER TABLE [dbo].[ICClassMCTaskCenter] ADD  DEFAULT ((0)) FOR [FBillWidth]
GO

ALTER TABLE [dbo].[ICClassMCTaskCenter] ADD  DEFAULT ((0)) FOR [FBillHeight]
GO