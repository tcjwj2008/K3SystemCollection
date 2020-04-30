USE [AIS_YXDZP2018]
GO

/****** Object:  Table [dbo].[k3_2APPORDER]    Script Date: 03/24/2020 10:45:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[k3_2APPORDER]')
                    AND OBJECTPROPERTY(id, 'IsTable') = 1 )
                    DROP TABLE [k3_2APPORDER];
USE [AIS_YXDZP2018]
GO

/****** Object:  Table [dbo].[k3_2APPORDER]    Script Date: 03/24/2020 14:26:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[k3_2APPORDER](
	[ID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[opener] [VARCHAR](50) NULL,
	[ordertime] [VARCHAR](50) NULL,
	[remarks] [VARCHAR](50) NULL,
	[state] [VARCHAR](50) NULL,
	[isread] [VARCHAR](50) NULL,
	[storeid] [VARCHAR](50) NULL,
	[storeno] [VARCHAR](50) NULL,
	[amount] [FLOAT] NULL,
	[orderno] [VARCHAR](50) NULL,
	[productno] [VARCHAR](50) NULL,
	[productno1] [VARCHAR](50) NULL,
	[num1] [FLOAT] NULL,
	[price1] [FLOAT] NULL,
	[amount1] [FLOAT] NULL,
	[kind] [VARCHAR](50) NULL,
	[product] [VARCHAR](50) NULL,
	[spec] [VARCHAR](50) NULL,
	[cmoney] [FLOAT] NULL,
	[cunit] [VARCHAR](50) NULL,
	[aigo] [VARCHAR](50) NULL,
	[remarks1] [VARCHAR](50) NULL,
	[FNAME] [VARCHAR](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING ON
GO




GO

SET ANSI_PADDING ON
GO


