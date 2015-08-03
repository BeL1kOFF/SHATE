CREATE TABLE [dbo].[Contact](
	[Id_Contact] [int] IDENTITY(1,1) NOT NULL,
	[Number] [varchar](9) NOT NULL,
	[Description] [varchar](128) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Type] [tinyint] NOT NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[Id_Contact] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)