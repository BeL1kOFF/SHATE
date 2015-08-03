object FormMain: TFormMain
  Left = 221
  Top = 123
  Caption = #1057#1073#1086#1088#1082#1072' '#1089#1077#1088#1074#1080#1089#1085#1086#1081' ['#169' Krizia]'
  ClientHeight = 400
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    814
    400)
  PixelsPerInch = 96
  TextHeight = 13
  object lbProgressInfo: TLabel
    Left = 36
    Top = 362
    Width = 12
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '---'
    ExplicitTop = 363
  end
  object lbProgressPercent: TLabel
    Left = 8
    Top = 362
    Width = 12
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '---'
  end
  object pb: TProgressBar
    Left = 0
    Top = 385
    Width = 814
    Height = 15
    Align = alBottom
    Step = 1
    TabOrder = 0
  end
  object btAbort: TButton
    Left = 731
    Top = 354
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Abort'
    TabOrder = 1
    OnClick = btAbortClick
  end
  object btFill_Des: TButton
    Left = 8
    Top = 301
    Width = 40
    Height = 25
    Caption = 'Des'
    TabOrder = 2
    OnClick = btFill_DesClick
  end
  object pnConnect: TPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 36
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvNone
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 58
      Height = 13
      Caption = 'Connection:'
    end
    object rbConnectionLocal: TRadioButton
      Left = 72
      Top = 7
      Width = 49
      Height = 17
      Caption = 'Local'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbConnectionServer: TRadioButton
      Left = 127
      Top = 7
      Width = 124
      Height = 17
      Caption = 'Work (Server: AMD)'
      TabOrder = 1
    end
    object btTestConnectMS: TButton
      Left = 424
      Top = 6
      Width = 137
      Height = 24
      Caption = #1058#1077#1089#1090' MSSQL Connection'
      TabOrder = 2
      OnClick = btTestConnectMSClick
    end
    object btConnect: TButton
      Left = 262
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 3
      OnClick = btConnectClick
    end
    object btDisconnect: TButton
      Left = 343
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 4
      OnClick = btDisconnectClick
    end
  end
  object pnData: TPanel
    Left = 0
    Top = 36
    Width = 814
    Height = 215
    Align = alTop
    TabOrder = 4
    Visible = False
    DesignSize = (
      814
      215)
    object Bevel1: TBevel
      Left = 4
      Top = 47
      Width = 802
      Height = 129
      Anchors = [akLeft, akTop, akRight]
    end
    object lbStatusCatalog: TLabel
      Left = 71
      Top = 62
      Width = 75
      Height = 13
      Caption = #1085#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbStatusAnalog: TLabel
      Left = 71
      Top = 87
      Width = 75
      Height = 13
      Caption = #1085#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbStatusOE: TLabel
      Left = 71
      Top = 112
      Width = 75
      Height = 13
      Caption = #1085#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 9
      Width = 125
      Height = 13
      Caption = #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1089#1073#1086#1088#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 33
      Width = 96
      Height = 13
      Caption = #1058#1077#1082#1091#1097#1072#1103' '#1089#1073#1086#1088#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 10
      Top = 62
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1050#1072#1090#1072#1083#1086#1075':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 10
      Top = 87
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1040#1085#1072#1083#1086#1075#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 10
      Top = 112
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1054#1045':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object cbLoadCatalog: TCheckBox
      Left = 173
      Top = 61
      Width = 73
      Height = 17
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 0
      OnClick = cbLoadCatalogClick
    end
    object cbLoadAnalog: TCheckBox
      Left = 173
      Top = 86
      Width = 73
      Height = 17
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 1
      OnClick = cbLoadAnalogClick
    end
    object cbLoadOE: TCheckBox
      Left = 173
      Top = 111
      Width = 73
      Height = 17
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 2
      OnClick = cbLoadOEClick
    end
    object edFileCatalog: TEdit
      Left = 252
      Top = 59
      Width = 521
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      Text = 'c:\borland\work\_Shate\'#1085#1072#1082#1072#1095#1082#1072'\'#1058#1086#1074#1072#1088#1099'31.csv'
      Visible = False
    end
    object btOpenFileCatalog: TButton
      Left = 773
      Top = 59
      Width = 21
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 4
      Visible = False
      OnClick = btOpenFileCatalogClick
    end
    object edFileAnalog: TEdit
      Left = 252
      Top = 84
      Width = 521
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      Text = 'c:\borland\work\_Shate\'#1085#1072#1082#1072#1095#1082#1072'\'#1040#1085#1072#1083#1086#1075#1080'21.csv'
      Visible = False
    end
    object btOpenFileAnalog: TButton
      Left = 773
      Top = 84
      Width = 21
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 6
      Visible = False
      OnClick = btOpenFileAnalogClick
    end
    object edFileOE: TEdit
      Left = 252
      Top = 109
      Width = 521
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
      Text = 'c:\borland\work\_Shate\'#1085#1072#1082#1072#1095#1082#1072'\OE_2011_08_08.csv'
      Visible = False
    end
    object btOpenFileOE: TButton
      Left = 773
      Top = 109
      Width = 21
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 8
      Visible = False
      OnClick = btOpenFileOEClick
    end
    object cbPrevRelease: TComboBox
      Left = 139
      Top = 6
      Width = 667
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ItemHeight = 13
      ParentFont = False
      TabOrder = 9
    end
    object btMoveToRelease: TButton
      Left = 606
      Top = 142
      Width = 188
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1074' '#1075#1086#1090#1086#1074#1099#1077' '#1089#1073#1086#1088#1082#1080
      TabOrder = 10
      OnClick = btMoveToReleaseClick
    end
    object Button6: TButton
      Left = 4
      Top = 182
      Width = 92
      Height = 25
      Caption = 'Start'
      TabOrder = 11
      OnClick = Button6Click
    end
    object Button8: TButton
      Left = 115
      Top = 182
      Width = 75
      Height = 25
      Caption = 'cache CAT'
      TabOrder = 12
      OnClick = Button8Click
    end
    object Button7: TButton
      Left = 196
      Top = 182
      Width = 75
      Height = 25
      Caption = 'cache AN'
      TabOrder = 13
      OnClick = Button7Click
    end
  end
  object MemoCreateTemplate: TMemo
    Left = 89
    Top = 272
    Width = 92
    Height = 79
    Lines.Strings = (
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      'CREATE TABLE [dbo].[#OE#]('
      #9'[ID] [int] IDENTITY(1,1) NOT NULL,'
      
        #9'[CAT_ID] [int] NOT NULL CONSTRAINT [DF_#OE#_CAT_ID]  DEFAULT ((' +
        '0)),'
      #9'[CODE] [varchar](25) NULL,'
      #9'[CODE2] [varchar](25) NULL,'
      #9'[SHORTOE] [varchar](50) NULL,'
      ' CONSTRAINT [PK_#OE#] PRIMARY KEY CLUSTERED'
      '('
      #9'[ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      ''
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      'CREATE TABLE [dbo].[#CATALOG#]('
      #9'[ID] [int] IDENTITY(1,1) NOT NULL,'
      
        #9'[CAT_ID] [int] NOT NULL CONSTRAINT [DF_#CATALOG#_CAT_ID]  DEFAU' +
        'LT ((0)),'
      #9'[BRAND_ID] [int] NULL,'
      #9'[GROUP_ID] [int] NULL,'
      #9'[SUBGROUP_ID] [int] NULL,'
      #9'[CODE] [varchar](50) NULL,'
      #9'[CODE2] [varchar](50) NULL,'
      #9'[SHORTCODE] [varchar](50) NULL,'
      #9'[NAME] [varchar](100) NULL,'
      #9'[DESCRIPTION] [varchar](250) NULL,'
      #9'[PRICE] [float] NULL,'
      #9'[T1] [smallint] NULL,'
      #9'[T2] [smallint] NULL,'
      #9'[NEW] [smallint] NULL,'
      #9'[SALE] [smallint] NULL,'
      #9'[MULT] [smallint] NULL,'
      #9'[USA] [smallint] NULL,'
      #9'[TITLE] [smallint] NULL,'
      #9'[IDOUBLE] [int] NULL,'
      #9'[PRIMEN] [text] NULL,'
      
        #9'[TECDOC_ID] [int] NOT NULL CONSTRAINT [DF_#CATALOG#_TECDOC_ID] ' +
        ' DEFAULT ((0)),'
      
        #9'[PICT_ID] [int] NOT NULL CONSTRAINT [DF_#CATALOG#_PICT_ID]  DEF' +
        'AULT ((0)),'
      
        #9'[TYP_TDID] [int] NOT NULL CONSTRAINT [DF_#CATALOG#_TYP_TDID]  D' +
        'EFAULT ((0)),'
      
        #9'[PARAM_TDID] [int] NOT NULL CONSTRAINT [DF_#CATALOG#_PARAM_TDID' +
        ']  DEFAULT ((0)),'
      ' CONSTRAINT [PK_#CATALOG#] PRIMARY KEY CLUSTERED'
      '('
      #9'[ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]'
      ''
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [Brand] ON [dbo].[#CATALOG#]'
      '('
      #9'[BRAND_ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [CAT_ID] ON [dbo].[#CATALOG#]'
      '('
      #9'[CAT_ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [Code2] ON [dbo].[#CATALOG#]'
      '('
      #9'[CODE2] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      'CREATE TABLE [dbo].[#BRANDS#]('
      #9'[ID] [int] IDENTITY(1,1) NOT NULL,'
      #9'[BRAND_ID] [int] NULL,'
      #9'[DESCRIPTION] [varchar](100) NULL,'
      #9'[DISCOUNT] [float] NULL,'
      #9'[MY_BRAND] [smallint] NULL,'
      ' CONSTRAINT [PK_#BRANDS#] PRIMARY KEY CLUSTERED'
      '('
      #9'[ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      ''
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [BrandId] ON [dbo].[#BRANDS#]'
      '('
      #9'[BRAND_ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [Descr] ON [dbo].[#BRANDS#]'
      '('
      #9'[DESCRIPTION] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      'CREATE TABLE [dbo].[#GROUPS#]('
      #9'[ID] [int] IDENTITY(1,1) NOT NULL,'
      #9'[GROUP_ID] [int] NULL,'
      #9'[GROUP_DESCR] [varchar](100) NULL,'
      #9'[SUBGROUP_ID] [int] NULL,'
      #9'[SUBGROUP_DESCR] [varchar](100) NULL,'
      #9'[DISCOUNT] [float] NULL,'
      ' CONSTRAINT [PK_#GROUPS#] PRIMARY KEY CLUSTERED'
      '('
      #9'[ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      ''
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [GrDescr] ON [dbo].[#GROUPS#]'
      '('
      #9'[GROUP_DESCR] ASC,'
      #9'[SUBGROUP_DESCR] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [GrId] ON [dbo].[#GROUPS#]'
      '('
      #9'[GROUP_ID] ASC,'
      #9'[SUBGROUP_ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      'CREATE TABLE [dbo].[#GROUPBRAND#]('
      #9'[ID] [int] IDENTITY(1,1) NOT NULL,'
      #9'[GROUP_ID] [int] NULL,'
      #9'[SUBGROUP_ID] [int] NULL,'
      #9'[BRAND_ID] [int] NULL,'
      ' CONSTRAINT [PK_#GROUPBRAND#] PRIMARY KEY CLUSTERED'
      '('
      #9'[ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      ''
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [BrGroup] ON [dbo].[#GROUPBRAND#]'
      '('
      #9'[BRAND_ID] ASC,'
      #9'[GROUP_ID] ASC,'
      #9'[SUBGROUP_ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [GrBrand] ON [dbo].[#GROUPBRAND#]'
      '('
      #9'[GROUP_ID] ASC,'
      #9'[SUBGROUP_ID] ASC,'
      #9'[BRAND_ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      'SET ANSI_NULLS ON'
      'GO'
      'SET QUOTED_IDENTIFIER ON'
      'GO'
      'CREATE TABLE [dbo].[#ANALOG#]('
      #9'[ID] [int] IDENTITY(1,1) NOT NULL,'
      
        #9'[CAT_ID] [int] NOT NULL CONSTRAINT [DF_#ANALOG#_CAT_ID]  DEFAUL' +
        'T ((0)),'
      #9'[AN_CODE] [varchar](50) NULL,'
      #9'[AN_BRAND] [varchar](50) NULL,'
      #9'[AN_ID] [nchar](10) NULL,'
      #9'[LOCKED] [smallint] NULL,'
      #9'[AN_SHORTCODE] [varchar](50) NULL,'
      ' CONSTRAINT [PK_#ANALOG#] PRIMARY KEY CLUSTERED'
      '('
      #9'[ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      ') ON [PRIMARY]'
      ''
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [AN_CODE] ON [dbo].[#ANALOG#]'
      '('
      #9'[AN_CODE] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
      'GO'
      ''
      'CREATE NONCLUSTERED INDEX [CAT_ID] ON [dbo].[#ANALOG#]'
      '('
      #9'[CAT_ID] ASC'
      ')WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]')
    TabOrder = 5
    Visible = False
    WordWrap = False
  end
  object connService: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=Admin;Initial Catalog=SERVICE;Data Source=KRIBO' +
      'OK\SQLEXPRESS'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 490
    Top = 255
  end
  object insertQuery: TADOCommand
    Connection = connService
    Parameters = <>
    Left = 460
    Top = 305
  end
  object msQuery: TADOQuery
    Connection = connService
    CursorLocation = clUseServer
    CursorType = ctOpenForwardOnly
    Parameters = <>
    Left = 515
    Top = 305
  end
  object _Brand: TADOTable
    Connection = connService
    CursorType = ctStatic
    MarshalOptions = moMarshalModifiedOnly
    IndexName = 'BrandId'
    TableName = 'BRANDS'
    Left = 265
    Top = 285
  end
  object _Group: TADOTable
    Connection = connService
    MarshalOptions = moMarshalModifiedOnly
    TableName = 'GROUPS'
    Left = 305
    Top = 285
  end
  object _GroupBrand: TADOTable
    Connection = connService
    MarshalOptions = moMarshalModifiedOnly
    TableName = 'GROUPBRAND'
    Left = 355
    Top = 285
  end
  object GroupBrand: TADODataSet
    Connection = connService
    CommandText = 
      'SELECT * FROM GROUPBRAND'#13#10'ORDER BY GROUP_ID, SUBGROUP_ID, BRAND_' +
      'ID'
    Parameters = <>
    Left = 250
    Top = 335
  end
  object Brand: TADODataSet
    Connection = connService
    CommandText = 'SELECT * FROM BRANDS'
    Parameters = <>
    Left = 310
    Top = 335
  end
  object Group: TADODataSet
    Connection = connService
    CommandText = 'SELECT * FROM GROUPS'
    Parameters = <>
    Left = 360
    Top = 335
  end
  object DBISAMEngine: TDBISAMEngine
    Active = False
    EngineVersion = '4.25 Build 5'
    EngineType = etClient
    EngineSignature = 'DBISAM_SIG_LOCAL'
    Functions = <>
    LargeFileSupport = False
    FilterRecordCounts = True
    LockFileName = 'dbisam.lck'
    MaxTableDataBufferSize = 32768
    MaxTableDataBufferCount = 8192
    MaxTableIndexBufferSize = 65536
    MaxTableIndexBufferCount = 8192
    MaxTableBlobBufferSize = 32768
    MaxTableBlobBufferCount = 8192
    TableDataExtension = '.dat'
    TableIndexExtension = '.idx'
    TableBlobExtension = '.blb'
    TableDataBackupExtension = '.dbk'
    TableIndexBackupExtension = '.ibk'
    TableBlobBackupExtension = '.bbk'
    TableDataUpgradeExtension = '.dup'
    TableIndexUpgradeExtension = '.iup'
    TableBlobUpgradeExtension = '.bup'
    TableDataTempExtension = '.dat'
    TableIndexTempExtension = '.idx'
    TableBlobTempExtension = '.blb'
    CreateTempTablesInDatabase = False
    TableFilterIndexThreshhold = 1
    TableReadLockWaitTime = 3
    TableReadLockRetryCount = 32768
    TableWriteLockWaitTime = 3
    TableWriteLockRetryCount = 32768
    TableTransLockWaitTime = 3
    TableTransLockRetryCount = 32768
    TableMaxReadLockCount = 100
    ServerName = 'DBSRVR'
    ServerDescription = 'DBISAM Database Server'
    ServerMainPort = 12005
    ServerMainThreadCacheSize = 10
    ServerAdminPort = 12006
    ServerAdminThreadCacheSize = 1
    ServerEncryptedOnly = False
    ServerEncryptionPassword = 'elevatesoft'
    ServerConfigFileName = 'dbsrvr.scf'
    ServerConfigPassword = 'elevatesoft'
    ServerLicensedConnections = 65535
    Left = 645
    Top = 255
  end
  object memCatalog: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'memCatalogDBISA1'
        Fields = 'CAT_ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'CODEBRAND'
        Fields = 'CODE2;BRAND_ID'
        Compression = icNone
      end>
    TableName = 'CATALOG'
    StoreDefs = True
    Left = 585
    Top = 305
    object memCatalogCAT_ID: TIntegerField
      FieldName = 'CAT_ID'
    end
    object memCatalogCODE2: TStringField
      FieldName = 'CODE2'
      Size = 50
    end
    object memCatalogBRAND_ID: TIntegerField
      FieldName = 'BRAND_ID'
    end
  end
  object memAnalog: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'CAT_ID'
        Fields = 'CAT_ID'
        Compression = icNone
      end
      item
        Name = 'IDCODE'
        Fields = 'CAT_ID;AN_CODE'
        Compression = icNone
      end>
    TableName = 'ANALOG'
    StoreDefs = True
    Left = 760
    Top = 305
    object IntegerField1: TIntegerField
      FieldName = 'CAT_ID'
    end
    object memAnalogAN_CODE: TStringField
      FieldName = 'AN_CODE'
      Size = 50
    end
  end
  object memBrand: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'BRAND_ID'
        Fields = 'BRAND_ID'
        Compression = icNone
      end
      item
        Name = 'DESCR'
        Fields = 'DESCRIPTION'
        Compression = icNone
      end>
    TableName = 'BRANDS'
    StoreDefs = True
    Left = 700
    Top = 305
    object memBrandBRAND_ID: TIntegerField
      FieldName = 'BRAND_ID'
    end
    object memBrandDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Size = 100
    end
  end
  object memGroup: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'GrDescr'
        Fields = 'GROUP_DESCR;SUBGROUP_DESCR'
        Compression = icNone
      end
      item
        Name = 'GrId'
        Fields = 'GROUP_ID;SUBGROUP_ID'
        Compression = icNone
      end>
    TableName = 'GROUPS'
    StoreDefs = True
    Left = 645
    Top = 305
    object memGroupGROUP_ID: TIntegerField
      FieldName = 'GROUP_ID'
    end
    object memGroupGROUP_DESCR: TStringField
      FieldName = 'GROUP_DESCR'
      Size = 100
    end
    object memGroupSUBGROUP_ID: TIntegerField
      FieldName = 'SUBGROUP_ID'
    end
    object memGroupSUBGROUP_DESCR: TStringField
      FieldName = 'SUBGROUP_DESCR'
      Size = 100
    end
  end
  object OD: TOpenDialog
    Left = 630
    Top = 5
  end
end
