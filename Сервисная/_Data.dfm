object Data: TData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 1497
  Width = 877
  object Database: TDBISAMDatabase
    EngineVersion = '4.25 Build 5'
    Connected = True
    DatabaseName = 'DATA'
    KeepTablesOpen = False
    SessionName = 'Default'
    Left = 16
    Top = 8
  end
  object DBEngine: TDBISAMEngine
    Active = True
    EngineVersion = '4.25 Build 5'
    EngineType = etClient
    EngineSignature = 'DBISAM_SIG'
    Functions = <>
    LargeFileSupport = True
    FilterRecordCounts = True
    LockFileName = '999'
    MaxTableDataBufferSize = 32768
    MaxTableDataBufferCount = 8192
    MaxTableIndexBufferSize = 262144
    MaxTableIndexBufferCount = 32768
    MaxTableBlobBufferSize = 32768
    MaxTableBlobBufferCount = 8192
    TableDataExtension = '.1'
    TableIndexExtension = '.2'
    TableBlobExtension = '.3'
    TableDataBackupExtension = '.1_'
    TableIndexBackupExtension = '.2_'
    TableBlobBackupExtension = '.3_'
    TableDataUpgradeExtension = '.1$'
    TableIndexUpgradeExtension = '.2$'
    TableBlobUpgradeExtension = '.3$'
    TableDataTempExtension = '.1~'
    TableIndexTempExtension = '.2~'
    TableBlobTempExtension = '.3~'
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
    ServerConfigFileName = 'ShateMPlus'
    ServerConfigPassword = 'elevatesoft'
    ServerLicensedConnections = 65535
    Left = 41
    Top = 54
  end
  object ParamTable: TDBISAMTable
    AutoDisplayLabels = True
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Tree_mode'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Last_Filt'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Eur_rate'
        DataType = ftCurrency
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Eur_usd_rate'
        DataType = ftCurrency
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Show_mparam'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Currency'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Show_start_info'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Hide_start_info'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Filt_range'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Filt_mode'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sale_backgr'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sale_font'
        DataType = ftString
        Size = 80
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Noquant_backgr'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Noquant_font'
        DataType = ftString
        Size = 80
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'QCell_color'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'SCell_color'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Page'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Net_interv'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Upgrade_level'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Loading'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cli_id_mode'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TCP_direct'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Loading_comp'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ProxySrv'
        DataType = ftString
        Size = 25
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ProxyPort'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ProxyPassword'
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'UseProxy'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'UseProxyAutoresation'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Hide_NewInProg'
        DataType = ftBoolean
        Description = 'Hide_NewInProg'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ToForbidRemovalOrder'
        DataType = ftBoolean
        Description = 'ToForbidRemovalOrder'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ShowMessageAddOrder'
        DataType = ftBoolean
        Description = 'ShowMessageAddOrder'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ProxyUser'
        DataType = ftString
        Size = 20
        Description = 'ProxyUser'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bUnionDetailAnalog'
        DataType = ftBoolean
        Description = 'bUnionDetailAnalog'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bPasiveUpdate'
        DataType = ftBoolean
        Description = 'bPasiveUpdate'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bPasiveUpdateProg'
        DataType = ftBoolean
        Description = 'bPasiveUpdateProg'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bPasiveUpdateData'
        DataType = ftBoolean
        Description = 'bPasiveUpdateData'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bPasiveUpdateQuants'
        DataType = ftBoolean
        Description = 'bPasiveUpdateQuants'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bPasiveUpdateAutoLoad'
        DataType = ftBoolean
        Description = 'bPasiveUpdateAutoLoad'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'iUpdateTypeLoad'
        DataType = ftInteger
        Description = 'iUpdateTypeLoad'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'iUpdateTypeLoadQuants'
        DataType = ftInteger
        Description = 'iUpdateTypeLoadQuants'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bSaveWithPrice'
        DataType = ftBoolean
        Description = 'bSaveWithPrice'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bSortOrderDet'
        DataType = ftBoolean
        Description = 'bSortOrderDet'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bVisibleRunningLine'
        DataType = ftBoolean
        Description = 'bVisibleRunningLine'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'HideTree'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'HideBrand'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'HideName'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'HideOE'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ColorRunString'
        DataType = ftInteger
        CharCase = fcLowerCase
        Compression = 0
      end
      item
        Name = 'UseMemory'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bUpdateKursesWithQuants'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Eur_rub_rate'
        DataType = ftCurrency
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Hide_update_report'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Hide_discountSB'
        DataType = ftBoolean
        Description = 'Hide_discountSB'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AnalogFilterEnabled'
        DataType = ftBoolean
        Description = 'AnalogFilterEnabled'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ShowAllOrders'
        DataType = ftBoolean
        Description = 'ShowAllOrders'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoSwitchCurClient'
        DataType = ftBoolean
        Description = 'AutoSwitchCurClient'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckOrders'
        DataType = ftBoolean
        Description = 'AutoCheckOrders'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckOrdersInt'
        DataType = ftInteger
        Description = 'AutoCheckOrdersInt'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckDiscounts'
        DataType = ftBoolean
        Description = 'AutoCheckDiscounts'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckDiscountsInt'
        DataType = ftInteger
        Description = 'AutoCheckDiscountsInt'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckStatuses'
        DataType = ftBoolean
        Description = 'AutoCheckStatuses'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckStatusesInt'
        DataType = ftInteger
        Description = 'AutoCheckStatusesInt'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Rounding'
        DataType = ftString
        Size = 50
        Description = 'Rounding'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckRss'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckRssInt'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bShowRssOnUpdate'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bWarnOrderLimits'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'SetDateRate'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'LocalMode'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckDirectory'
        DataType = ftBoolean
        Description = 'AutoCheckDirectory'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoCheckDirectoryInt'
        DataType = ftInteger
        Description = 'AutoCheckDirectoryInt'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bCloseDialog'
        DataType = ftBoolean
        Description = 'bCloseDialog'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bReplBrand'
        DataType = ftBoolean
        Description = 'bReplBrand'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bAutoCheckRates'
        DataType = ftBoolean
        DefaultValue = 'True'
        Description = 'bAutoCheckRates'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bCalcOrderWithMargin'
        DataType = ftBoolean
        Description = 'bCalcOrderWithMargin'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bClearPictsTable'
        DataType = ftBoolean
        Description = 'bClearPictsTable'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bNotifyEvent'
        DataType = ftBoolean
        Description = 'bNotifyEvent'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Id'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '001'
    StoreDefs = True
    Left = 152
    Top = 8
    object ParamTableId: TAutoIncField
      FieldName = 'Id'
    end
    object ParamTableTree_mode: TSmallintField
      FieldName = 'Tree_mode'
    end
    object ParamTableLast_Filt: TStringField
      FieldName = 'Last_Filt'
      Size = 50
    end
    object ParamTableEur_rate: TCurrencyField
      FieldName = 'Eur_rate'
      EditFormat = '#.###'
      currency = False
    end
    object ParamTableEur_usd_rate: TCurrencyField
      ConstraintErrorMessage = #1086#1096#1080#1073#1082#1072'!'
      FieldName = 'Eur_usd_rate'
      EditFormat = '#.###'
      currency = False
    end
    object ParamTableShow_mparam: TBooleanField
      FieldName = 'Show_mparam'
    end
    object ParamTableCurrency: TSmallintField
      FieldName = 'Currency'
    end
    object ParamTableShow_start_info: TBooleanField
      FieldName = 'Show_start_info'
    end
    object ParamTableHide_start_info: TBooleanField
      FieldName = 'Hide_start_info'
    end
    object ParamTableFilt_range: TStringField
      FieldName = 'Filt_range'
      Size = 1
    end
    object ParamTableFilt_mode: TIntegerField
      FieldName = 'Filt_mode'
    end
    object ParamTableSale_backgr: TIntegerField
      FieldName = 'Sale_backgr'
    end
    object ParamTableSale_font: TStringField
      FieldName = 'Sale_font'
      Size = 80
    end
    object ParamTableNoquant_backgr: TIntegerField
      FieldName = 'Noquant_backgr'
    end
    object ParamTableNoquant_font: TStringField
      FieldName = 'Noquant_font'
      Size = 80
    end
    object ParamTableCell_color: TBooleanField
      FieldName = 'QCell_color'
    end
    object ParamTableSCell_color: TBooleanField
      FieldName = 'SCell_color'
    end
    object ParamTablePage: TIntegerField
      FieldName = 'Page'
    end
    object ParamTableNet_interv: TIntegerField
      FieldName = 'Net_interv'
    end
    object ParamTableUpgrade_level: TIntegerField
      FieldName = 'Upgrade_level'
    end
    object ParamTableLoading: TBooleanField
      FieldName = 'Loading'
    end
    object ParamTableCli_id_mode: TStringField
      FieldName = 'Cli_id_mode'
      Size = 1
    end
    object ParamTableTCP_direct: TBooleanField
      FieldName = 'TCP_direct'
    end
    object ParamTableLoading_comp: TStringField
      FieldName = 'Loading_comp'
      Size = 50
    end
    object ParamTableHide_NewInProg: TBooleanField
      FieldName = 'Hide_NewInProg'
    end
    object ParamTableToForbidRemovalOrder: TBooleanField
      FieldName = 'ToForbidRemovalOrder'
    end
    object ParamTableShowMessageAddOrder: TBooleanField
      FieldName = 'ShowMessageAddOrder'
    end
    object ParamTableProxySRV: TStringField
      FieldName = 'ProxySRV'
      Size = 25
    end
    object ParamTableProxyPort: TIntegerField
      FieldName = 'ProxyPort'
    end
    object ParamTableProxyUser: TStringField
      FieldName = 'ProxyUser'
    end
    object ParamTableProxyPassword: TStringField
      FieldName = 'ProxyPassword'
    end
    object ParamTableUseProxy: TBooleanField
      FieldName = 'UseProxy'
    end
    object ParamTableUseProxwAutoresation: TBooleanField
      FieldName = 'UseProxyAutoresation'
    end
    object ParamTablebUnionDetailAnalog: TBooleanField
      FieldName = 'bUnionDetailAnalog'
    end
    object ParamTablebPasiveUpdate: TBooleanField
      FieldName = 'bPasiveUpdate'
    end
    object ParamTablebPasiveUpdateProg: TBooleanField
      FieldName = 'bPasiveUpdateProg'
    end
    object ParamTablebPasiveUpdateQuants: TBooleanField
      FieldName = 'bPasiveUpdateQuants'
    end
    object ParamTableiUpdateTypeLoad: TIntegerField
      FieldName = 'iUpdateTypeLoad'
    end
    object ParamTableiUpdateTypeLoadQuants: TIntegerField
      FieldName = 'iUpdateTypeLoadQuants'
    end
    object ParamTablebPasiveUpdateData: TBooleanField
      FieldName = 'bPasiveUpdateData'
    end
    object ParamTablebPasiveUpdateAutoLoad: TBooleanField
      FieldName = 'bPasiveUpdateAutoLoad'
    end
    object ParamTablebSaveWithPrice: TBooleanField
      FieldName = 'bSaveWithPrice'
    end
    object ParamTablebSortOrderDet: TBooleanField
      FieldName = 'bSortOrderDet'
    end
    object ParamTablebVisibleRunningLine: TBooleanField
      FieldName = 'bVisibleRunningLine'
    end
    object ParamTableHideTree: TBooleanField
      FieldName = 'HideTree'
    end
    object ParamTableHideBrand: TBooleanField
      FieldName = 'HideBrand'
    end
    object ParamTableHideName: TBooleanField
      FieldName = 'HideName'
    end
    object ParamTableHideOE: TBooleanField
      FieldName = 'HideOE'
    end
    object ParamTableColorRunString: TIntegerField
      FieldName = 'ColorRunString'
    end
    object ParamTableUseMemory: TBooleanField
      FieldName = 'UseMemory'
    end
    object ParamTablebUpdateKursesWithQuants: TBooleanField
      FieldName = 'bUpdateKursesWithQuants'
    end
    object ParamTableEur_rub_rate: TCurrencyField
      FieldName = 'Eur_rub_rate'
      DisplayFormat = '0.00'
      EditFormat = '##.##'
    end
    object ParamTableHide_update_report: TBooleanField
      FieldName = 'Hide_update_report'
    end
    object ParamTableHide_discountSB: TBooleanField
      FieldName = 'Hide_discountSB'
    end
    object ParamTableAnalogFilterEnabled: TBooleanField
      FieldName = 'AnalogFilterEnabled'
    end
    object ParamTableShowAllOrders: TBooleanField
      FieldName = 'ShowAllOrders'
    end
    object ParamTableAutoSwitchCurClient: TBooleanField
      FieldName = 'AutoSwitchCurClient'
    end
    object ParamTableAutoCheckOrders: TBooleanField
      FieldName = 'AutoCheckOrders'
    end
    object ParamTableAutoCheckOrdersInt: TIntegerField
      FieldName = 'AutoCheckOrdersInt'
    end
    object ParamTableAutoCheckDiscountsInt: TIntegerField
      FieldName = 'AutoCheckDiscountsInt'
    end
    object ParamTableAutoCheckDiscounts: TBooleanField
      FieldName = 'AutoCheckDiscounts'
    end
    object ParamTableAutoCheckStatuses: TBooleanField
      FieldName = 'AutoCheckStatuses'
    end
    object ParamTableAutoCheckStatusesInt: TIntegerField
      FieldName = 'AutoCheckStatusesInt'
    end
    object ParamTableRounding: TStringField
      FieldName = 'Rounding'
      Size = 50
    end
    object ParamTableAutoCheckRss: TBooleanField
      FieldName = 'AutoCheckRss'
    end
    object ParamTableAutoCheckRssInt: TIntegerField
      FieldName = 'AutoCheckRssInt'
    end
    object ParamTablebShowRssOnUpdate: TBooleanField
      FieldName = 'bShowRssOnUpdate'
    end
    object ParamTablebWarnOrderLimits: TBooleanField
      FieldName = 'bWarnOrderLimits'
    end
    object ParamTableSetDateRate: TIntegerField
      FieldName = 'SetDateRate'
    end
    object ParamTableLocalMode: TBooleanField
      FieldName = 'LocalMode'
    end
    object ParamTableAutoCheckDirectory: TBooleanField
      FieldName = 'AutoCheckDirectory'
    end
    object ParamTableAutoCheckDirectoryInt: TIntegerField
      FieldName = 'AutoCheckDirectoryInt'
    end
    object ParamTablebCloseDialog: TBooleanField
      FieldName = 'bCloseDialog'
    end
    object ParamTablebReplBrand: TBooleanField
      FieldName = 'bReplBrand'
    end
    object ParamTablebAutoCheckRate: TBooleanField
      FieldName = 'bAutoCheckRates'
    end
    object ParamTablebCalcOrderWithMargin: TBooleanField
      FieldName = 'bCalcOrderWithMargin'
    end
    object ParamTablebClearPictsTable: TBooleanField
      FieldName = 'bClearPictsTable'
    end
    object ParamTablebNotifyEvent: TBooleanField
      FieldName = 'bNotifyEvent'
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'csv'
    Filter = #1060#1072#1081#1083#1099' CSV|*.CSV'
    Left = 588
    Top = 248
  end
  object CatalogTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = CatalogTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 250
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Group_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Subgroup_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price'
        DataType = ftCurrency
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'T1'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'T2'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Title'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sale'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'New'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Tecdoc_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Mult'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Usa'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Primen'
        DataType = ftMemo
        Description = 'Primen'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'IDouble'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'pict_id'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'typ_tdid'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'param_tdid'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'CatalogTableTableDBISA1'
        Fields = 'Cat_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Code'
        Fields = 'Code'
        Compression = icNone
      end
      item
        Name = 'GrCode'
        Fields = 'T1;Group_id;Subgroup_id;Brand_id;Code'
        Compression = icNone
      end
      item
        Name = 'BrCode'
        Fields = 'T2;Brand_id;Group_id;Subgroup_id;Code'
        Compression = icNone
      end
      item
        Name = 'Code2'
        Fields = 'Code2;Brand_id'
        Compression = icNone
      end
      item
        Name = 'ShortCode'
        Fields = 'ShortCode;Brand_id'
        Compression = icNone
      end
      item
        Name = 'pict'
        Fields = 'pict_id'
        Compression = icNone
      end
      item
        Name = 'typ'
        Fields = 'typ_tdid'
        Compression = icNone
      end
      item
        Name = 'param'
        Fields = 'param_tdid'
        Compression = icNone
      end>
    TableName = '002'
    StoreDefs = True
    Left = 319
    Top = 8
    object CatalogTableCat_id: TIntegerField
      FieldName = 'Cat_id'
      Origin = '002.Cat_id'
    end
    object CatalogTableCode: TStringField
      FieldName = 'Code'
      Origin = '002.Code'
      Size = 50
    end
    object CatalogTableCode2: TStringField
      FieldName = 'Code2'
      Origin = '002.Code2'
      Size = 50
    end
    object CatalogTableName: TStringField
      FieldName = 'Name'
      Origin = '002.Name'
      Size = 100
    end
    object CatalogTableDescription: TStringField
      FieldName = 'Description'
      Origin = '002.Description'
      Size = 250
    end
    object CatalogTableGroup_id: TIntegerField
      FieldName = 'Group_id'
      Origin = '002.Group_id'
    end
    object CatalogTableSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
      Origin = '002.Subgroup_id'
    end
    object CatalogTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
      Origin = '002.Brand_id'
    end
    object CatalogTablePrice: TCurrencyField
      FieldName = 'Price'
      Origin = '002.Price'
    end
    object CatalogTableT1: TSmallintField
      FieldName = 'T1'
      Origin = '002.T1'
    end
    object CatalogTableT2: TSmallintField
      FieldName = 'T2'
      Origin = '002.T2'
    end
    object CatalogTableTitle: TBooleanField
      FieldName = 'Title'
      Origin = '002.Title'
    end
    object CatalogTableSale: TStringField
      FieldName = 'Sale'
      Origin = '002.Sale'
      Size = 1
    end
    object CatalogTableNew: TStringField
      FieldName = 'New'
      Origin = '002.New'
      Size = 1
    end
    object CatalogTableTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
      Origin = '002.Tecdoc_id'
    end
    object CatalogTableMult: TIntegerField
      FieldName = 'Mult'
      Origin = '002.Mult'
    end
    object CatalogTableUsa: TStringField
      FieldName = 'Usa'
      Origin = '002.Usa'
      Size = 1
    end
    object CatalogTablePrimen: TMemoField
      FieldName = 'Primen'
      Origin = '002.Primen'
      BlobType = ftMemo
    end
    object CatalogTableShortCode: TStringField
      FieldName = 'ShortCode'
      Origin = '002.ShortCode'
      Size = 50
    end
    object CatalogTableIDouble: TIntegerField
      FieldName = 'IDouble'
      Origin = '002.IDouble'
    end
    object CatalogTablepict_id: TIntegerField
      DefaultExpression = '0'
      FieldName = 'pict_id'
      Origin = '002.pict_id'
      Required = True
    end
    object CatalogTabletyp_tdid: TIntegerField
      DefaultExpression = '0'
      FieldName = 'typ_tdid'
      Origin = '002.typ_tdid'
      Required = True
    end
    object CatalogTableparam_tdid: TIntegerField
      DefaultExpression = '0'
      FieldName = 'param_tdid'
      Origin = '002.param_tdid'
      Required = True
    end
  end
  object LoadCatTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    FilterOptions = [foNoPartialCompare]
    OnCalcFields = LoadCatTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 250
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Group_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Subgroup_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price'
        DataType = ftCurrency
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'T1'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'T2'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Title'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sale'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'New'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Tecdoc_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Mult'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Usa'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Primen'
        DataType = ftMemo
        Description = 'Primen'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'IDouble'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'pict_id'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'typ_tdid'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'param_tdid'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'LoadCatTableDBISA1'
        Fields = 'Cat_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Code'
        Fields = 'Code'
        Compression = icNone
      end
      item
        Name = 'GrCode'
        Fields = 'T1;Group_id;Subgroup_id;Brand_id;Code'
        Compression = icNone
      end
      item
        Name = 'BrCode'
        Fields = 'T2;Brand_id;Group_id;Subgroup_id;Code'
        Compression = icNone
      end
      item
        Name = 'Code2'
        Fields = 'Code2;Brand_id'
        Compression = icNone
      end
      item
        Name = 'ShortCode'
        Fields = 'ShortCode;Brand_id'
        Compression = icNone
      end
      item
        Name = 'pict'
        Fields = 'pict_id'
        Compression = icNone
      end
      item
        Name = 'typ'
        Fields = 'typ_tdid'
        Compression = icNone
      end
      item
        Name = 'param'
        Fields = 'param_tdid'
        Compression = icNone
      end>
    IndexName = 'Code2'
    TableName = '002'
    StoreDefs = True
    Left = 41
    Top = 200
    object LoadCatTableCat_id: TIntegerField
      FieldName = 'Cat_id'
      Origin = '002.Cat_id'
    end
    object LoadCatTableCode: TStringField
      FieldName = 'Code'
      Origin = '002.Code'
      Size = 50
    end
    object LoadCatTableCode2: TStringField
      FieldName = 'Code2'
      Origin = '002.Code2'
      Size = 50
    end
    object LoadCatTableName: TStringField
      FieldName = 'Name'
      Origin = '002.Name'
      Size = 100
    end
    object LoadCatTableDescription: TStringField
      FieldName = 'Description'
      Origin = '002.Description'
      Size = 250
    end
    object LoadCatTableGroup_id: TIntegerField
      FieldName = 'Group_id'
      Origin = '002.Group_id'
    end
    object LoadCatTableSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
      Origin = '002.Subgroup_id'
    end
    object LoadCatTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
      Origin = '002.Brand_id'
    end
    object LoadCatTablePrice: TCurrencyField
      FieldName = 'Price'
      Origin = '002.Price'
    end
    object LoadCatTableT1: TSmallintField
      FieldName = 'T1'
      Origin = '002.T1'
    end
    object LoadCatTableT2: TSmallintField
      FieldName = 'T2'
      Origin = '002.T2'
    end
    object LoadCatTableTitle: TBooleanField
      FieldName = 'Title'
      Origin = '002.Title'
    end
    object LoadCatTableSale: TStringField
      FieldName = 'Sale'
      Origin = '002.Sale'
      Size = 1
    end
    object LoadCatTableNew: TStringField
      FieldName = 'New'
      Origin = '002.New'
      Size = 1
    end
    object LoadCatTableTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
      Origin = '002.Tecdoc_id'
    end
    object LoadCatTableMult: TIntegerField
      FieldName = 'Mult'
      Origin = '002.Mult'
    end
    object LoadCatTableUsa: TStringField
      FieldName = 'Usa'
      Origin = '002.Usa'
      Size = 1
    end
    object LoadCatTablePrimen: TMemoField
      FieldName = 'Primen'
      Origin = '002.Primen'
      BlobType = ftMemo
    end
    object LoadCatTablesBrand: TStringField
      FieldKind = fkLookup
      FieldName = 'sBrand'
      LookupDataSet = BrandTable
      LookupKeyFields = 'Brand_id'
      LookupResultField = 'Description'
      KeyFields = 'Brand_id'
      Size = 100
      Lookup = True
    end
    object LoadCatTablePriceQuant: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object LoadCatTablePriceItog: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object LoadCatTableSaleQ: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object LoadCatTablesaleQCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'Cat_id'
      Size = 1
      Lookup = True
    end
    object LoadCatTableShortCode: TStringField
      FieldName = 'ShortCode'
      Origin = '002.ShortCode'
      Size = 50
    end
    object LoadCatTableIDouble: TIntegerField
      FieldName = 'IDouble'
      Origin = '002.IDouble'
    end
    object LoadCatTablepict_id: TIntegerField
      FieldName = 'pict_id'
      Origin = '002.pict_id'
      Required = True
    end
    object LoadCatTabletyp_tdid: TIntegerField
      FieldName = 'typ_tdid'
      Origin = '002.typ_tdid'
      Required = True
    end
    object LoadCatTableparam_tdid: TIntegerField
      FieldName = 'param_tdid'
      Origin = '002.param_tdid'
      Required = True
    end
  end
  object BrandTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'My_brand'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Id'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'BrandId'
        Fields = 'Brand_Id'
        Compression = icNone
      end
      item
        Name = 'Descr'
        Fields = 'Description'
        Options = [ixCaseInsensitive]
        Compression = icNone
      end>
    TableName = '003'
    StoreDefs = True
    Left = 398
    Top = 54
    object BrandTableId: TAutoIncField
      FieldName = 'Id'
      Origin = '003.Id'
    end
    object BrandTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
      Origin = '003.Brand_id'
    end
    object BrandTableDescription: TStringField
      FieldName = 'Description'
      Origin = '003.Description'
      Size = 100
    end
    object BrandTableMy_brand: TBooleanField
      FieldName = 'My_brand'
      Origin = '003.My_brand'
    end
  end
  object GroupTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Id'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'GrId'
        Fields = 'Group_id;Subgroup_id'
        Compression = icNone
      end
      item
        Name = 'GrDescr'
        Fields = 'Group_descr;Subgroup_descr'
        Compression = icNone
      end>
    TableName = '004'
    StoreDefs = True
    Left = 490
    Top = 57
    object GroupTableId: TAutoIncField
      FieldName = 'Id'
    end
    object GroupTableGroup_id: TIntegerField
      FieldName = 'Group_id'
    end
    object GroupTableGroup_descr: TStringField
      FieldName = 'Group_descr'
      Size = 100
    end
    object GroupTableSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
    end
    object GroupTableSubgroup_descr: TStringField
      FieldName = 'Subgroup_descr'
      Size = 100
    end
    object GroupTableDiscount: TFloatField
      FieldName = 'Discount'
    end
  end
  object GroupBrandTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Group_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Subgroup_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Id'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'GrBrand'
        Fields = 'Group_id;Subgroup_id;Brand_ID'
        Compression = icNone
      end
      item
        Name = 'BrGroup'
        Fields = 'Brand_ID;Group_id;Subgroup_id'
        Compression = icNone
      end>
    TableName = '005'
    StoreDefs = True
    Left = 587
    Top = 54
    object GroupBrandTableId: TAutoIncField
      FieldName = 'Id'
    end
    object GroupBrandTableGroup_id: TIntegerField
      FieldName = 'Group_id'
    end
    object GroupBrandTableSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
    end
    object GroupBrandTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
    end
  end
  object CatalogDataSource: TDataSource
    DataSet = CatFilterTable
    Left = 398
    Top = 8
  end
  object MyGroupTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Id'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'GrId'
        Fields = 'Group_id;subgroup_id'
        Compression = icNone
      end
      item
        Name = 'GrDescr'
        Fields = 'Group_descr;Subgroup_descr'
        Compression = icNone
      end>
    TableName = '006'
    StoreDefs = True
    Left = 673
    Top = 54
    object MyGroupTableId: TAutoIncField
      FieldName = 'Id'
    end
    object MyGroupTableGroup_id: TIntegerField
      FieldName = 'Group_id'
    end
    object MyGroupTableGroup_descr: TStringField
      FieldName = 'Group_descr'
      Size = 100
    end
    object MyGroupTableSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
    end
    object MyGroupTableSubgroup_descr: TStringField
      FieldName = 'Subgroup_descr'
      Size = 100
    end
  end
  object AnalogTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Locked = 0'
    Filtered = True
    AfterRefresh = AnalogTableAfterRefresh
    OnCalcFields = AnalogTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Locked'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'AnalogTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'AnCode'
        Fields = 'Cat_id;An_code'
        Compression = icNone
      end
      item
        Name = 'AnCode2'
        Fields = 'An_code'
        Compression = icNone
      end
      item
        Name = 'An_ShortCode'
        Fields = 'An_ShortCode'
        Compression = icNone
      end>
    IndexFieldNames = 'An_code'
    MasterFields = 'Cat_id'
    MasterSource = CatalogDataSource
    TableName = '007'
    StoreDefs = True
    Left = 470
    Top = 8
    object AnalogTableId: TAutoIncField
      FieldName = 'Id'
    end
    object AnalogTableCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object AnalogTableAn_code: TStringField
      FieldName = 'An_code'
      Size = 50
    end
    object AnalogTableAn_brand: TStringField
      FieldName = 'An_brand'
      Size = 50
    end
    object AnalogTableAn_id: TIntegerField
      FieldName = 'An_id'
    end
    object AnalogTableDescription: TStringField
      FieldKind = fkLookup
      FieldName = 'Description'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Description'
      KeyFields = 'An_id'
      Size = 150
      Lookup = True
    end
    object AnalogTablePrice: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      currency = False
      Lookup = True
    end
    object AnalogTablePrice_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object AnalogTableAn_group_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_group_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogTableAn_subgroup_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_subgroup_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogTableQuantity: TStringField
      FieldKind = fkLookup
      FieldName = 'Quantity'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 10
      Lookup = True
    end
    object AnalogTableAn_sale: TStringField
      FieldKind = fkLookup
      FieldName = 'An_sale'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogTableAn_new: TStringField
      FieldKind = fkLookup
      FieldName = 'An_new'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'New'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogTableAn_usa: TStringField
      FieldKind = fkLookup
      FieldName = 'An_usa'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Usa'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogTableSale: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sale'
      Size = 1
      Calculated = True
    end
    object AnalogTablenew: TStringField
      FieldKind = fkCalculated
      FieldName = 'New'
      Size = 1
      Calculated = True
    end
    object AnalogTableName: TStringField
      FieldKind = fkLookup
      FieldName = 'Name'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Name'
      KeyFields = 'An_id'
      Size = 100
      Lookup = True
    end
    object AnalogTableName_Descr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 350
      Calculated = True
    end
    object AnalogTableAn_Brand_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_Brand_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogTableMult: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Mult'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Mult'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogTablePrice_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object AnalogTableOrdQuantity: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantity'
      Calculated = True
    end
    object AnalogTableOrdQuantityStr: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 10
      Calculated = True
    end
    object AnalogTablePrice_pro: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object AnalogTableUsa: TStringField
      FieldKind = fkCalculated
      FieldName = 'Usa'
      Size = 1
      Calculated = True
    end
    object AnalogTablesaleQCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogTableSaleQ: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object AnalogTablePriceItog: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object AnalogTablePriceQuant: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogTableLocked: TIntegerField
      FieldName = 'Locked'
    end
    object AnalogTableAn_ShortCode: TStringField
      FieldName = 'An_ShortCode'
      Size = 50
    end
    object AnalogTableAn_brand_repl: TStringField
      FieldKind = fkCalculated
      FieldName = 'An_brand_repl'
      Size = 100
      Calculated = True
    end
    object AnalogTableQuantLatest: TIntegerField
      FieldKind = fkLookup
      FieldName = 'QuantLatest'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Latest'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogTableOrderOnly: TBooleanField
      FieldKind = fkLookup
      FieldName = 'OrderOnly'
      LookupDataSet = OOTable
      LookupKeyFields = 'CAT_ID'
      LookupResultField = 'IsOrder'
      KeyFields = 'An_id'
      Lookup = True
    end
  end
  object LoadAnTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'AnCode'
    TableName = '007'
    Left = 41
    Top = 248
  end
  object AnalogDataSource: TDataSource
    DataSet = AnalogTable
    Left = 587
    Top = 8
  end
  object XCatTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = XCatTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Code2'
    TableName = '002'
    Left = 314
    Top = 101
    object XCatTableCat_id: TIntegerField
      FieldName = 'Cat_id'
      Origin = '002.Cat_id'
    end
    object XCatTableCode: TStringField
      FieldName = 'Code'
      Origin = '002.Code'
      Size = 50
    end
    object XCatTableCode2: TStringField
      FieldName = 'Code2'
      Origin = '002.Code2'
      Size = 50
    end
    object XCatTableDescription: TStringField
      FieldName = 'Description'
      Origin = '002.Description'
      Size = 250
    end
    object XCatTableGroup_id: TIntegerField
      FieldName = 'Group_id'
      Origin = '002.Group_id'
    end
    object XCatTableSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
      Origin = '002.Subgroup_id'
    end
    object XCatTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
      Origin = '002.Brand_id'
    end
    object XCatTablePrice: TCurrencyField
      FieldName = 'Price'
      Origin = '002.Price'
    end
    object XCatTableT1: TSmallintField
      FieldName = 'T1'
      Origin = '002.T1'
    end
    object XCatTableT2: TSmallintField
      FieldName = 'T2'
      Origin = '002.T2'
    end
    object XCatTableTitle: TBooleanField
      FieldName = 'Title'
      Origin = '002.Title'
    end
    object XCatTableSale: TStringField
      FieldName = 'Sale'
      Origin = '002.Sale'
      Size = 1
    end
    object XCatTableNew: TStringField
      FieldName = 'New'
      Origin = '002.New'
      Size = 1
    end
    object XCatTableTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
      Origin = '002.Tecdoc_id'
    end
    object XCatTableName: TStringField
      FieldName = 'Name'
      Origin = '002.Name'
      Size = 100
    end
    object XCatTableBrandDescr: TStringField
      FieldKind = fkLookup
      FieldName = 'BrandDescr'
      LookupDataSet = XBrandTable
      LookupKeyFields = 'Brand_id'
      LookupResultField = 'Description'
      KeyFields = 'Brand_id'
      Size = 50
      Lookup = True
    end
    object XCatTableMult: TIntegerField
      FieldName = 'Mult'
      Origin = '002.Mult'
    end
    object XCatTableUsa: TStringField
      FieldName = 'Usa'
      Origin = '002.Usa'
      Size = 1
    end
    object XCatTablePriceItog: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object XCatTablePriceQuant: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object XCatTablesaleQCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'Cat_id'
      Size = 1
      Lookup = True
    end
    object XCatTableSaleQ: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object XCatTablePrimen: TMemoField
      FieldName = 'Primen'
      Origin = '002.Primen'
      BlobType = ftMemo
    end
    object XCatTableName_Descr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 350
      Calculated = True
    end
    object XCatTablesaleQOptRFCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQOptRFCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'SaleOptRF'
      KeyFields = 'Cat_id'
      Size = 1
      Lookup = True
    end
    object XCatTablePrice_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object XCatTablePriceQuantOptRF: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuantOptRF'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'PriceOptRF'
      KeyFields = 'Cat_id'
      Lookup = True
    end
  end
  object SearchTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Code2'
    TableName = '002'
    Left = 314
    Top = 150
  end
  object XBrandTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'BrandId'
    TableName = '003'
    Left = 398
    Top = 106
  end
  object XGroupTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'GrId'
    TableName = '004'
    Left = 490
    Top = 101
  end
  object FiltTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'FiltTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Cnt'
        DescFields = 'Mode;Cnt'
        Fields = 'Mode;Cnt'
        Options = [ixDescending]
        Compression = icNone
      end
      item
        Name = 'Text'
        Fields = 'Mode;Text'
        Options = [ixCaseInsensitive]
        Compression = icNone
      end>
    IndexName = 'Cnt'
    TableName = '008'
    StoreDefs = True
    Left = 137
    Top = 54
    object FiltTableId: TAutoIncField
      FieldName = 'Id'
    end
    object FiltTableMode: TSmallintField
      FieldName = 'Mode'
    end
    object FiltTableText: TStringField
      FieldName = 'Text'
      Size = 50
    end
    object FiltTableCnt: TIntegerField
      FieldName = 'Cnt'
    end
  end
  object FiltDataSource: TDataSource
    DataSet = FiltTable
    Left = 231
    Top = 54
  end
  object ParamDataSource: TDataSource
    DataSet = ParamTable
    Left = 231
    Top = 8
  end
  object SFiltTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'SFiltTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Cnt'
        DescFields = 'Mode;Cnt'
        Fields = 'Mode;Cnt'
        Options = [ixDescending]
        Compression = icNone
      end
      item
        Name = 'Text'
        Fields = 'Mode;Text'
        Options = [ixCaseInsensitive]
        Compression = icNone
      end>
    IndexName = 'Text'
    TableName = '008'
    StoreDefs = True
    Left = 314
    Top = 54
  end
  object OrderTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    BeforeScroll = OrderTableBeforeScroll
    AfterScroll = OrderTableAfterScroll
    OnCalcFields = OrderTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Order_id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Date'
        DataType = ftDate
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Num'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'State'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Type'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sign'
        DataType = ftString
        Size = 7
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sent'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sent_time'
        DataType = ftDateTime
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Dirty'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'LotusNumber'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Delivery'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Currency'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cli_id'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TcpAnswer'
        DataType = ftBlob
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TcpAnswerZam'
        DataType = ftBlob
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'IsDelivered'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'popular'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Agreement_No'
        DataType = ftString
        Size = 20
        Description = 'Agreement_No'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Addres_Id'
        DataType = ftString
        Size = 20
        Description = 'Addres_Id'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AgrDescr'
        DataType = ftString
        Size = 128
        Description = 'AgrDescr'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 100
        Description = 'Name'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Phone'
        DataType = ftString
        Size = 20
        Description = 'Phone'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'FakeAddresDescr'
        DataType = ftString
        Size = 250
        Description = 'FakeAddresDescr'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AgrGroup'
        DataType = ftString
        Size = 20
        Description = 'AgrGroup'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'NearestDelivery'
        DataType = ftBoolean
        Description = 'NearestDelivery'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Order_id'
        Fields = 'Order_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Date'
        Fields = 'Date;Num'
        Compression = icNone
      end
      item
        Name = 'State'
        Fields = 'State'
        Compression = icNone
      end
      item
        Name = 'Client'
        Fields = 'Cli_id'
        Compression = icNone
      end
      item
        Name = 'Cli_Date'
        Fields = 'Cli_id;Date;Num'
        Compression = icNone
      end>
    TableName = '009'
    StoreDefs = True
    Left = 137
    Top = 101
    object OrderTableOrder_id: TAutoIncField
      FieldName = 'Order_id'
    end
    object OrderTableDate: TDateField
      FieldName = 'Date'
    end
    object OrderTableNum: TIntegerField
      FieldName = 'Num'
    end
    object OrderTableCode: TStringField
      FieldName = 'Code'
      Size = 10
    end
    object OrderTableDescription: TStringField
      FieldName = 'Description'
      Size = 50
    end
    object OrderTableState: TSmallintField
      FieldName = 'State'
    end
    object OrderTableClientInfo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ClientInfo'
      Size = 50
      Calculated = True
    end
    object OrderTableInfo: TStringField
      FieldKind = fkCalculated
      FieldName = 'Info'
      Size = 65
      Calculated = True
    end
    object OrderTablePos: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Pos'
      Calculated = True
    end
    object OrderTableSum: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Sum'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object OrderTableType: TStringField
      FieldName = 'Type'
      Size = 1
    end
    object OrderTableSign: TStringField
      FieldName = 'Sign'
      Size = 7
    end
    object OrderTableSent: TStringField
      FieldName = 'Sent'
      Size = 1
    end
    object OrderTableSent_time: TDateTimeField
      FieldName = 'Sent_time'
    end
    object OrderTableDirty: TBooleanField
      FieldName = 'Dirty'
    end
    object OrderTableLotusNumber: TStringField
      FieldName = 'LotusNumber'
      Size = 10
    end
    object OrderTableDelivery: TIntegerField
      FieldName = 'Delivery'
    end
    object OrderTableCurrency: TIntegerField
      FieldName = 'Currency'
    end
    object OrderTableCli_id: TStringField
      FieldName = 'Cli_id'
      Size = 15
    end
    object OrderTableClientLookup: TStringField
      FieldKind = fkLookup
      FieldName = 'ClientLookup'
      LookupDataSet = ClIDsTable
      LookupKeyFields = 'Client_ID'
      LookupResultField = 'Description'
      KeyFields = 'Cli_id'
      Size = 250
      Lookup = True
    end
    object OrderTablesum_pro: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'sum_pro'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object OrderTableTcpAnswerZam: TBlobField
      FieldName = 'TcpAnswerZam'
    end
    object OrderTableTcpAnswer: TBlobField
      FieldName = 'TcpAnswer'
    end
    object OrderTableIsDelivered: TIntegerField
      FieldName = 'IsDelivered'
    end
    object OrderTableIsDeliveredCalc: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'IsDeliveredCalc'
      Calculated = True
    end
    object OrderTablePopular: TIntegerField
      FieldName = 'Popular'
    end
    object OrderTableAgreement_No: TStringField
      FieldName = 'Agreement_No'
    end
    object OrderTableAddres_Id: TStringField
      FieldName = 'Addres_Id'
    end
    object OrderTableAgrDescr: TStringField
      FieldName = 'AgrDescr'
      Size = 128
    end
    object OrderTablePhone: TStringField
      FieldName = 'Phone'
    end
    object OrderTableName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object OrderTableFakeAddresDescr: TStringField
      FieldName = 'FakeAddresDescr'
      Size = 250
    end
    object OrderTableAgrGroup: TStringField
      FieldName = 'AgrGroup'
    end
    object OrderTableNearestDelivery: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'NearestDelivery'
    end
  end
  object OrderDetTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = OrderDetTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Order_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Pos'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Art_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Quantity'
        DataType = ftFloat
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price'
        DataType = ftCurrency
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'State'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Info'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Names'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Ordered'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TestQuants'
        DataType = ftInteger
        Description = 'TestQuants'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price_pro'
        DataType = ftCurrency
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'OrderDetTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Order'
        Fields = 'Order_id;Pos'
        Compression = icNone
      end
      item
        Name = 'OrderArt'
        Fields = 'Order_id;Code2;Brand'
        Compression = icNone
      end
      item
        Name = 'ArtCode'
        Fields = 'Order_id;Code2'
        Compression = icNone
      end
      item
        Name = 'DArtCode'
        DescFields = 'Order_id;Code2'
        Fields = 'Order_id;Code2'
        Options = [ixDescending]
        Compression = icNone
      end
      item
        Name = 'TestQuants'
        Fields = 'Order_id;TestQuants'
        Compression = icNone
      end>
    IndexName = 'Order'
    MasterFields = 'Order_id'
    MasterSource = OrderDataSource
    TableName = '010'
    StoreDefs = True
    Left = 226
    Top = 101
    object OrderDetTableCheckField: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'CheckField'
      Calculated = True
    end
    object OrderDetTableId: TAutoIncField
      FieldName = 'Id'
      Origin = '010.Id'
    end
    object OrderDetTableOrder_id: TIntegerField
      FieldName = 'Order_id'
      Origin = '010.Order_id'
    end
    object OrderDetTablePos: TSmallintField
      FieldName = 'Pos'
      Origin = '010.Pos'
    end
    object OrderDetTableArt_id: TIntegerField
      FieldName = 'Art_id'
      Origin = '010.Art_id'
    end
    object OrderDetTableCode: TStringField
      FieldName = 'Code2'
      Origin = '010.Code2'
      Size = 50
    end
    object OrderDetTableBrand: TStringField
      FieldName = 'Brand'
      Origin = '010.Brand'
      Size = 50
    end
    object OrderDetTableQuantity: TFloatField
      FieldName = 'Quantity'
      Origin = '010.Quantity'
    end
    object OrderDetTablePrice: TCurrencyField
      FieldName = 'Price'
      Origin = '010.Price'
      currency = False
    end
    object OrderDetTableState: TSmallintField
      FieldName = 'State'
      Origin = '010.State'
    end
    object OrderDetTableArtCode: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtCode'
      Size = 50
      Calculated = True
    end
    object OrderDetTableArtName: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtName'
      Size = 100
      Calculated = True
    end
    object OrderDetTableArtDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtDescr'
      Size = 150
      Calculated = True
    end
    object OrderDetTableArtNameDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtNameDescr'
      ReadOnly = True
      Size = 350
      Calculated = True
    end
    object OrderDetTablePrice_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object OrderDetTableSum: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Sum'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object OrderDetTableArtPrice: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'ArtPrice'
      currency = False
      Calculated = True
    end
    object OrderDetTableArtSale: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtSale'
      Size = 1
      Calculated = True
    end
    object OrderDetTableArtBrandId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtBrandId'
      Calculated = True
    end
    object OrderDetTableArtCodeBrand: TStringField
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'ArtCodeBrand'
      Size = 100
      Calculated = True
    end
    object OrderDetTableInfo: TStringField
      FieldName = 'Info'
      Origin = '010.Info'
      Size = 50
    end
    object OrderDetTableOrdered: TSmallintField
      FieldName = 'Ordered'
      Origin = '010.Ordered'
    end
    object OrderDetTableNames: TStringField
      DisplayWidth = 250
      FieldName = 'Names'
      Size = 15
    end
    object OrderDetTableTestQuants: TIntegerField
      FieldName = 'TestQuants'
    end
    object OrderDetTableCat_id: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Cat_id'
      Calculated = True
    end
    object OrderDetTableArtGroupId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtGroupId'
      Calculated = True
    end
    object OrderDetTableArtSubgroupId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtSubgroupId'
      Calculated = True
    end
    object OrderDetTableprice_pro: TCurrencyField
      FieldName = 'price_pro'
      currency = False
    end
    object OrderDetTableprice_pro_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'price_pro_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object OrderDetTableSum_pro: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Sum_pro'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object OrderDetTableMult: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Mult'
      Calculated = True
    end
    object OrderDetTableBrandRepl: TStringField
      FieldKind = fkCalculated
      FieldName = 'BrandRepl'
      Size = 50
      Calculated = True
    end
    object OrderDetTableArtPriceOptRF: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'ArtPriceOptRF'
      Calculated = True
    end
  end
  object ClIDsTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Client_ID'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Order_type'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Delivery'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ByDefault'
        DataType = ftInteger
        Description = 'ByDefault'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'email'
        DataType = ftString
        Size = 255
        Description = 'email'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Key'
        DataType = ftString
        Size = 22
        Description = 'Key'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'UpdateDisc'
        DataType = ftBoolean
        Description = 'UpdateDisc'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'UseDiffMargin'
        DataType = ftBoolean
        Description = 'UseDiffMargin'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiffMargin'
        DataType = ftString
        Size = 255
        Description = 'DiffMargin'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiscountVersion'
        DataType = ftInteger
        Description = 'DiscountVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiscVersion'
        DataType = ftInteger
        Description = 'DiscVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AddresVersion'
        DataType = ftInteger
        Description = 'AddresVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AgrVersion'
        DataType = ftInteger
        Description = 'AgrVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ContractByDefault'
        DataType = ftString
        Size = 10
        Description = 'ContractByDefault'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Phone'
        DataType = ftString
        Size = 20
        Description = 'Phone'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 100
        Description = 'Name'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AddresByDefault'
        DataType = ftString
        Size = 20
        Description = 'AddresByDefault'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AddresDescrByDefault'
        DataType = ftString
        Size = 256
        Description = 'AddresDescrByDefault'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ClIDsTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Client_ID'
        Fields = 'Client_ID'
        Compression = icNone
      end
      item
        Name = 'Descr'
        Fields = 'Description'
        Options = [ixCaseInsensitive]
        Compression = icNone
      end>
    TableName = '011'
    StoreDefs = True
    Left = 587
    Top = 101
    object ClIDsTableId: TAutoIncField
      FieldName = 'Id'
      Origin = '011.Id'
    end
    object ClIDsTableClient_ID: TStringField
      FieldName = 'Client_ID'
      Origin = '011.Client_ID'
      Size = 15
    end
    object ClIDsTableDescription: TStringField
      FieldName = 'Description'
      Origin = '011.Description'
      Size = 50
    end
    object ClIDsTableDelivery: TIntegerField
      FieldName = 'Delivery'
      Origin = '011.Delivery'
    end
    object ClIDsTableOrder_type: TStringField
      FieldName = 'Order_type'
      Origin = '011.Order_type'
      Size = 1
    end
    object ClIDsTableByDefault: TIntegerField
      FieldName = 'ByDefault'
      Origin = '011.ByDefault'
    end
    object ClIDsTableemail: TStringField
      FieldName = 'email'
      Origin = '011.email'
      Size = 255
    end
    object ClIDsTableKey: TStringField
      FieldName = 'Key'
      Origin = '011.Key'
      Size = 22
    end
    object ClIDsTableUpdateDisc: TBooleanField
      FieldName = 'UpdateDisc'
      Origin = '011.UpdateDisc'
    end
    object ClIDsTableDiscountVersion: TIntegerField
      FieldName = 'DiscountVersion'
      Origin = '011.DiscountVersion'
    end
    object ClIDsTableUseDiffMargin: TBooleanField
      FieldName = 'UseDiffMargin'
      Origin = '011.UseDiffMargin'
    end
    object ClIDsTableDiffMargin: TStringField
      FieldName = 'DiffMargin'
      Origin = '011.DiffMargin'
      Size = 255
    end
    object ClIDsTableDirectoryVersion: TIntegerField
      FieldName = 'DiscVersion'
      Origin = '011.DiscVersion'
    end
    object ClIDsTableAddresVersion: TIntegerField
      FieldName = 'AddresVersion'
      Origin = '011.AddresVersion'
    end
    object ClIDsTableAgrVersion: TIntegerField
      FieldName = 'AgrVersion'
      Origin = '011.AgrVersion'
    end
    object ClIDsTableContractByDefault: TStringField
      FieldName = 'ContractByDefault'
    end
    object ClIDsTablePhone: TStringField
      FieldName = 'Phone'
    end
    object ClIDsTableName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object ClIDsTableAddresByDefault: TStringField
      FieldName = 'AddresByDefault'
    end
    object ClIDsTableAddresDescrByDefault: TStringField
      FieldName = 'AddresDescrByDefault'
      Size = 256
    end
  end
  object OrderDataSource: TDataSource
    DataSet = OrderTable
    Left = 137
    Top = 150
  end
  object OrderDetDataSource: TDataSource
    DataSet = OrderDetTable
    Left = 231
    Top = 150
  end
  object ClIDsDataSource: TDataSource
    DataSet = ClIDsTable
    Left = 587
    Top = 150
  end
  object XClIDsTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = '011'
    Left = 673
    Top = 101
  end
  object XOrderDetTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Order'
    TableName = '010'
    StoreDefs = True
    Left = 231
    Top = 198
  end
  object QuantTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Quantity'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price'
        DataType = ftCurrency
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sale'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'QuantNew'
        DataType = ftString
        Size = 5
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Latest'
        DataType = ftInteger
        Description = 'Latest'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PriceOptRF'
        DataType = ftCurrency
        Description = 'PriceOptRF'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'SaleOptRF'
        DataType = ftString
        Size = 1
        Description = 'SaleOptRF'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'QuantTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Cat_id'
        Fields = 'Cat_id'
        Compression = icNone
      end>
    IndexName = 'Cat_id'
    TableName = '012'
    StoreDefs = True
    Left = 314
    Top = 198
    object QuantTableId: TAutoIncField
      FieldName = 'Id'
      Origin = '012.Id'
    end
    object QuantTableCat_id: TIntegerField
      FieldName = 'Cat_id'
      Origin = '012.Cat_id'
    end
    object QuantTableQuantity: TStringField
      FieldName = 'Quantity'
      Origin = '012.Quantity'
      Size = 10
    end
    object QuantTableSale: TStringField
      FieldName = 'Sale'
      Origin = '012.Sale'
      Size = 1
    end
    object QuantTablePrice: TCurrencyField
      FieldName = 'Price'
      Origin = '012.Price'
    end
    object QuantTableQuantNew: TStringField
      FieldName = 'QuantNew'
      Origin = '012.QuantNew'
      Size = 5
    end
    object QuantTableLatest: TIntegerField
      FieldName = 'Latest'
      Origin = '012.Latest'
    end
    object QuantTablePriceOptRF: TCurrencyField
      FieldName = 'PriceOptRF'
    end
    object QuantTableSaleOptRF: TStringField
      FieldName = 'SaleOptRF'
      Size = 1
    end
  end
  object BrandDataSource: TDataSource
    DataSet = BrandTable
    Left = 398
    Top = 150
  end
  object GroupDataSource: TDataSource
    DataSet = GroupTable
    Left = 490
    Top = 150
  end
  object CatDetTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Tecdoc_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sort'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Param_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Param_value'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'CatDetTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Tecdoc_id'
        Fields = 'Tecdoc_id;Sort'
        Compression = icNone
      end>
    IndexFieldNames = 'Tecdoc_id'
    TableName = '014'
    StoreDefs = True
    Left = 314
    Top = 376
    object CatDetTableId: TAutoIncField
      FieldName = 'Id'
      Origin = '014.Id'
    end
    object CatDetTableTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
      Origin = '014.Tecdoc_id'
    end
    object CatDetTableSort: TSmallintField
      FieldName = 'Sort'
      Origin = '014.Sort'
    end
    object CatDetTableParam_id: TIntegerField
      FieldName = 'Param_id'
      Origin = '014.Param_id'
    end
    object CatDetTableParam_value: TStringField
      FieldName = 'Param_value'
      Origin = '014.Param_value'
      Size = 50
    end
    object CatDetTableParamDescr: TStringField
      FieldKind = fkLookup
      FieldName = 'ParamDescr'
      LookupDataSet = CatParTable
      LookupKeyFields = 'Param_id'
      LookupResultField = 'Description'
      KeyFields = 'Param_id'
      Size = 50
      Lookup = True
    end
  end
  object CatParTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Param_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Descr'
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Type'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Interv'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Param_id2'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Id'
        Fields = 'Param_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Descr'
        Fields = 'Descr'
        Compression = icNone
      end>
    TableName = '015'
    StoreDefs = True
    Left = 398
    Top = 376
    object CatParTableParam_id: TIntegerField
      FieldName = 'Param_id'
      Origin = '015.Param_id'
    end
    object CatParTableDescr: TStringField
      FieldName = 'Descr'
      Origin = '015.Descr'
    end
    object CatParTableDescription: TStringField
      FieldName = 'Description'
      Origin = '015.Description'
      Size = 100
    end
    object CatParTableType: TStringField
      FieldName = 'Type'
      Origin = '015.Type'
      Size = 1
    end
    object CatParTableInterv: TBooleanField
      FieldName = 'Interv'
      Origin = '015.Interv'
    end
    object CatParTableParam_id2: TIntegerField
      FieldName = 'Param_id2'
      Origin = '015.Param_id2'
    end
  end
  object CatDetDataSource: TDataSource
    DataSet = CatDetTable
    Left = 495
    Top = 377
  end
  object OpenZipDialog: TOpenDialog
    DefaultExt = 'zip'
    Filter = #1060#1072#1081#1083#1099' ZIP|*.ZIP'
    Left = 489
    Top = 248
  end
  object TDArtTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Art_Id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Art_look'
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sup_brand'
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'pict_id'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'pict_nr'
        Attributes = [faRequired]
        DataType = ftSmallint
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'typ_id'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'param_id'
        Attributes = [faRequired]
        DataType = ftInteger
        DefaultValue = '0'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'TDArtTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'LOOK'
        Fields = 'Art_look;Sup_brand'
        Compression = icNone
      end
      item
        Name = 'Art'
        Fields = 'Art_Id'
        Compression = icNone
      end
      item
        Name = 'pict'
        Fields = 'pict_id'
        Compression = icNone
      end
      item
        Name = 'typ'
        Fields = 'typ_id'
        Compression = icNone
      end
      item
        Name = 'param'
        Fields = 'param_id'
        Compression = icNone
      end>
    IndexName = 'LOOK'
    TableName = '110'
    StoreDefs = True
    Left = 41
    Top = 376
    object TDArtTableId: TAutoIncField
      FieldName = 'Id'
      Origin = '110.Id'
    end
    object TDArtTableArt_Id: TIntegerField
      FieldName = 'Art_Id'
      Origin = '110.Art_Id'
    end
    object TDArtTableArt_look: TStringField
      DisplayWidth = 20
      FieldName = 'Art_look'
      Origin = '110.Art_look'
    end
    object TDArtTableSup_brand: TStringField
      FieldName = 'Sup_brand'
      Origin = '110.Sup_brand'
    end
    object TDArtTablepict_id: TIntegerField
      DefaultExpression = '0'
      FieldName = 'pict_id'
      Required = True
    end
    object TDArtTablepict_nr: TSmallintField
      DefaultExpression = '0'
      FieldName = 'pict_nr'
      Required = True
    end
    object TDArtTabletyp_id: TIntegerField
      DefaultExpression = '0'
      FieldName = 'typ_id'
      Required = True
    end
    object TDArtTableparam_id: TIntegerField
      DefaultExpression = '0'
      FieldName = 'param_id'
      Required = True
    end
  end
  object OETable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code'
        DataType = ftString
        Size = 25
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 25
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ShortOE'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'SIMB'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Cat_id'
        Fields = 'Cat_id'
        Compression = icNone
      end
      item
        Name = 'Code2'
        Fields = 'Code2'
        Compression = icNone
      end
      item
        Name = 'ShortOE'
        Fields = 'ShortOE'
        Compression = icNone
      end
      item
        Name = 'SIM'
        Fields = 'Simb'
        Compression = icDuplicateByte
      end>
    IndexFieldNames = 'Cat_id'
    MasterFields = 'Cat_id'
    MasterSource = CatalogDataSource
    TableName = '016'
    StoreDefs = True
    Left = 314
    Top = 248
    object OETableId: TAutoIncField
      FieldName = 'Id'
    end
    object OETableCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object OETableCode: TStringField
      FieldName = 'Code'
      Size = 25
    end
    object OETableCode2: TStringField
      FieldName = 'Code2'
      Size = 25
    end
    object OETableShortOE: TStringField
      FieldName = 'ShortOE'
      Size = 50
    end
    object OETableSIMB: TSmallintField
      FieldName = 'SIMB'
    end
  end
  object OESearchTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Code2'
    TableName = '016'
    Left = 137
    Top = 198
    object OESearchTableId: TAutoIncField
      FieldName = 'Id'
    end
    object OESearchTableCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object OESearchTableCode: TStringField
      FieldName = 'Code'
      Size = 25
    end
    object OESearchTableCode2: TStringField
      FieldName = 'Code2'
      Size = 25
    end
    object OESearchTableCatBrand: TIntegerField
      FieldKind = fkLookup
      FieldName = 'CatBrand'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object OESearchTableCatGroup: TIntegerField
      FieldKind = fkLookup
      FieldName = 'CatGroup'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object OESearchTableCatSubgroup: TIntegerField
      FieldKind = fkLookup
      FieldName = 'CatSubgroup'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object OESearchTableShortOE: TStringField
      FieldName = 'ShortOE'
      Size = 50
    end
    object OESearchTableSIMB: TSmallintField
      FieldName = 'SIMB'
    end
  end
  object XOrderDetTable2: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'OrderArt'
    TableName = '010'
    StoreDefs = True
    Left = 223
    Top = 248
  end
  object LoadOETable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = '016'
    Left = 41
    Top = 299
  end
  object LoadQuantTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = '012'
    Left = 137
    Top = 298
  end
  object AnSearchTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexFieldNames = 'An_code'
    TableName = '007'
    Left = 137
    Top = 247
  end
  object Zipper: TVCLZip
    Left = 387
    Top = 248
  end
  object DoubleTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Code2 <> '#39#39
    OnCalcFields = DoubleTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Code2'
    TableName = '002'
    Left = 673
    Top = 150
    object DoubleTableCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object DoubleTableCode: TStringField
      FieldName = 'Code'
      Size = 50
    end
    object DoubleTableCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object DoubleTableName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object DoubleTableDescription: TStringField
      FieldName = 'Description'
      Size = 250
    end
    object DoubleTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
    end
    object DoubleTableBrandName: TStringField
      FieldKind = fkLookup
      FieldName = 'BrandName'
      LookupDataSet = BrandTable
      LookupKeyFields = 'Brand_id'
      LookupResultField = 'Description'
      KeyFields = 'Brand_id'
      Size = 50
      Lookup = True
    end
    object DoubleTableDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Descr'
      Size = 100
      Calculated = True
    end
  end
  object SearchDoubleTimer: TTimer
    Enabled = False
    OnTimer = SearchDoubleTimerTimer
    Left = 673
    Top = 300
  end
  object UnloadQuantTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = '012'
    Left = 587
    Top = 200
    object UnloadQuantTableId: TAutoIncField
      FieldName = 'Id'
    end
    object UnloadQuantTableCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object UnloadQuantTableQuantity: TStringField
      FieldName = 'Quantity'
      Size = 10
    end
    object UnloadQuantTableCatCode: TStringField
      FieldKind = fkLookup
      FieldName = 'CatCode'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Code'
      KeyFields = 'Cat_id'
      Size = 50
      Lookup = True
    end
    object UnloadQuantTableCatBrand: TStringField
      FieldKind = fkLookup
      FieldName = 'CatBrand'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'BrandDescr'
      KeyFields = 'Cat_id'
      Size = 50
      Lookup = True
    end
    object UnloadQuantTableCatPrice: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'CatPrice'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'Cat_id'
      Lookup = True
    end
  end
  object WaitListTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filtered = True
    OnCalcFields = WaitListTableCalcFields
    OnFilterRecord = WaitListTableFilterRecord
    OnNewRecord = WaitListTableNewRecord
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Pos'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Art_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Quantity'
        DataType = ftFloat
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Info'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Data'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Post'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'cli_id'
        DataType = ftString
        Size = 20
        Description = 'cli_id'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DateCreate'
        DataType = ftDate
        Description = 'DateCreate'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'NearestRestocking'
        DataType = ftString
        Size = 64
        Description = 'NearestRestocking'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'WaitListTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'ArtCode'
        Fields = 'Code2'
        Compression = icNone
      end
      item
        Name = 'DArtCode'
        DescFields = 'Code2'
        Fields = 'Code2'
        Options = [ixDescending]
        Compression = icNone
      end
      item
        Name = 'Brand'
        Fields = 'Brand'
        Compression = icNone
      end
      item
        Name = 'DBrand'
        DescFields = 'Brand'
        Fields = 'Brand'
        Options = [ixDescending]
        Compression = icNone
      end
      item
        Name = 'Cli_date'
        Fields = 'cli_id;datecreate'
        Compression = icNone
      end
      item
        Name = 'DateCreate'
        Fields = 'DateCreate'
        Compression = icNone
      end>
    TableName = '017'
    StoreDefs = True
    Left = 41
    Top = 99
    object WaitListTableId: TAutoIncField
      FieldName = 'Id'
    end
    object WaitListTablePos: TIntegerField
      FieldName = 'Pos'
    end
    object WaitListTableArt_id: TIntegerField
      FieldName = 'Art_id'
    end
    object WaitListTableCode: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object WaitListTableBrand: TStringField
      FieldName = 'Brand'
      Size = 50
    end
    object WaitListTableQuantity: TFloatField
      FieldName = 'Quantity'
    end
    object WaitListTableCatCode: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtCode'
      Size = 50
      Calculated = True
    end
    object WaitListTableArtName: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtName'
      Size = 100
      Calculated = True
    end
    object WaitListTableArtDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtDescr'
      Size = 100
      Calculated = True
    end
    object WaitListTableArtNameDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtNameDescr'
      Size = 200
      Calculated = True
    end
    object WaitListTableArtPrice: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'ArtPrice'
      currency = False
      Calculated = True
    end
    object WaitListTableArtBrandId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtBrandId'
      Calculated = True
    end
    object WaitListTablePrice_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.00'
      currency = False
      Calculated = True
    end
    object WaitListTableArtQuant: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtQuant'
      Size = 10
      Calculated = True
    end
    object WaitListTableArtSale: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtSale'
      Size = 1
      Calculated = True
    end
    object WaitListTablePrice_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object WaitListTableInfo: TStringField
      FieldName = 'Info'
      Size = 50
    end
    object WaitListTableData: TStringField
      FieldName = 'Data'
      Size = 10
    end
    object WaitListTablePost: TIntegerField
      FieldName = 'Post'
    end
    object WaitListTableCat_ID: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Cat_ID'
      Calculated = True
    end
    object WaitListTableBrandRepl: TStringField
      FieldKind = fkCalculated
      FieldName = 'BrandRepl'
      Size = 100
      Calculated = True
    end
    object WaitListTableArtGroupId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtGroupId'
      Calculated = True
    end
    object WaitListTableArtSubgroupId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtSubgroupId'
      Calculated = True
    end
    object WaitListTableArtQuantLatest: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtQuantLatest'
      Calculated = True
    end
    object WaitListTablecli_id: TStringField
      FieldName = 'cli_id'
    end
    object WaitListTableDateCreate: TDateField
      FieldName = 'DateCreate'
    end
    object WaitListTableClient_info: TStringField
      FieldKind = fkCalculated
      FieldName = 'ClientInfo'
      Calculated = True
    end
    object WaitListTableClientLookup: TStringField
      FieldKind = fkLookup
      FieldName = 'ClientLookup'
      LookupDataSet = ClIDsTable
      LookupKeyFields = 'Client_ID'
      LookupResultField = 'Description'
      KeyFields = 'cli_id'
      Lookup = True
    end
    object WaitListTablesaleQOptRFCalc: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'saleQOptRFCalc'
      Calculated = True
    end
    object WaitListTablePriceQuantOptRF: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceQuantOptRF'
      Calculated = True
    end
    object WaitListTableNearestRestocking: TStringField
      FieldName = 'NearestRestocking'
      Size = 64
    end
  end
  object WaitListDataSource: TDataSource
    DataSet = WaitListTable
    Left = 41
    Top = 149
  end
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=tcd_error_0;Persist Security Info=Tr' +
      'ue;User ID=tecdoc;Data Source=SHTMP_TECDOC'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 233
    Top = 299
  end
  object ADODataSet: TADODataSet
    Connection = ADOConnection
    CursorLocation = clUseServer
    CursorType = ctOpenForwardOnly
    Parameters = <>
    Left = 314
    Top = 299
  end
  object TextAttrTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = TextAttrTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'TextAttrTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Lo'
        Fields = 'Lo'
        Compression = icNone
      end>
    IndexName = 'Lo'
    TableName = '018'
    StoreDefs = True
    Left = 673
    Top = 197
    object TextAttrTableId: TAutoIncField
      FieldName = 'Id'
    end
    object TextAttrTableLo: TIntegerField
      FieldName = 'Lo'
    end
    object TextAttrTableHi: TIntegerField
      FieldName = 'Hi'
    end
    object TextAttrTableBavkground: TIntegerField
      FieldName = 'Background'
    end
    object TextAttrTableFont: TStringField
      FieldName = 'Font'
      Size = 100
    end
    object TextAttrTableSample: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sample'
      Size = 50
      Calculated = True
    end
    object TextAttrTableLoHi: TStringField
      FieldKind = fkCalculated
      FieldName = 'LoHi'
      Size = 25
      Calculated = True
    end
  end
  object TextAttrDataSource: TDataSource
    DataSet = TextAttrTable
    Left = 673
    Top = 248
  end
  object MTextAttrTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = TextAttrTableCalcFields
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Lo'
    TableName = 'Text_Attr'
    Left = 764
    Top = 240
    object MTextAttrTableId: TAutoIncField
      FieldName = 'Id'
    end
    object MTextAttrTableBackground: TIntegerField
      FieldName = 'Background'
    end
    object MTextAttrTableFont: TStringField
      FieldName = 'Font'
      Size = 100
    end
    object MTextAttrTableLo: TIntegerField
      FieldName = 'Lo'
    end
    object MTextAttrTableHi: TIntegerField
      FieldName = 'Hi'
    end
    object MTextAttrTableLoHi: TStringField
      FieldKind = fkCalculated
      FieldName = 'LoHi'
      Size = 25
      Calculated = True
    end
    object MTextAttrTableSample: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sample'
      Size = 50
      Calculated = True
    end
  end
  object MTextAttrDataSource: TDataSource
    DataSet = MTextAttrTable
    Left = 764
    Top = 293
  end
  object SysParamTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Decimal_sep'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Ign_chars'
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Shate_email'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Update_url'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Load_log'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Tecdoc_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Pict_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Act_period'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Act_warn_period'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Ver_info1'
        DataType = ftString
        Size = 150
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Ver_info2'
        DataType = ftString
        Size = 150
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Host'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Port'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Ord_send_info'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PortIn'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'BackHOST'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TCPHost3'
        DataType = ftString
        Size = 15
        Description = 'TCPHost3'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ITNPort'
        DataType = ftInteger
        Description = 'ITNPort'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'QuestionEmail'
        DataType = ftString
        Size = 50
        Description = 'QuestionEmail'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ReturnDocEmail'
        DataType = ftString
        Size = 50
        Description = 'ReturnDocEmail'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'UpdateMirrors'
        DataType = ftString
        Size = 250
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DeliveryPhone'
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TCPHostOpt'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PortB2B'
        DataType = ftInteger
        Description = 'PortB2B'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PortB2BIn'
        DataType = ftInteger
        Description = 'PortB2BIn'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ITNPortB2B'
        DataType = ftInteger
        Description = 'ITNPortB2B'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'SysParamTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '099'
    StoreDefs = True
    Left = 673
    Top = 8
    object SysParamTableId: TAutoIncField
      FieldName = 'Id'
      Origin = '099.Id'
    end
    object SysParamTableDecimal_sep: TStringField
      FieldName = 'Decimal_sep'
      Origin = '099.Decimal_sep'
      Size = 1
    end
    object SysParamTableIgn_chars: TStringField
      FieldName = 'Ign_chars'
      Origin = '099.Ign_chars'
    end
    object SysParamTableShate_email: TStringField
      FieldName = 'Shate_email'
      Origin = '099.Shate_email'
      Size = 50
    end
    object SysParamTableUpdate_url: TStringField
      FieldName = 'Update_url'
      Origin = '099.Update_url'
      Size = 100
    end
    object SysParamTableLoad_log: TBooleanField
      FieldName = 'Load_log'
      Origin = '099.Load_log'
    end
    object SysParamTableTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
      Origin = '099.Tecdoc_id'
    end
    object SysParamTablePict_id: TIntegerField
      FieldName = 'Pict_id'
      Origin = '099.Pict_id'
    end
    object SysParamTableAct_period: TIntegerField
      FieldName = 'Act_period'
      Origin = '099.Act_period'
    end
    object SysParamTableAct_warn_period: TIntegerField
      FieldName = 'Act_warn_period'
      Origin = '099.Act_warn_period'
    end
    object SysParamTableVer_info1: TStringField
      FieldName = 'Ver_info1'
      Origin = '099.Ver_info1'
      Size = 150
    end
    object SysParamTableVer_info2: TStringField
      FieldName = 'Ver_info2'
      Origin = '099.Ver_info2'
      Size = 150
    end
    object SysParamTableHost: TStringField
      FieldName = 'Host'
      Origin = '099.Host'
      OnChange = SysParamTableHostChange
      Size = 15
    end
    object SysParamTablePort: TIntegerField
      FieldName = 'Port'
      Origin = '099.Port'
    end
    object SysParamTableOrd_send_info: TStringField
      FieldName = 'Ord_send_info'
      Origin = '099.Ord_send_info'
      Size = 100
    end
    object SysParamTablePortIn: TIntegerField
      FieldName = 'PortIn'
      Origin = '099.PortIn'
    end
    object SysParamTableBackHOST: TStringField
      FieldName = 'BackHOST'
      Size = 15
    end
    object SysParamTableTCPHost3: TStringField
      FieldName = 'TCPHost3'
      Size = 15
    end
    object SysParamTableITNPort: TIntegerField
      FieldName = 'ITNPort'
    end
    object SysParamTableQuestionEmail: TStringField
      FieldName = 'QuestionEmail'
      Size = 50
    end
    object SysParamTableReturnDocEmail: TStringField
      FieldName = 'ReturnDocEmail'
      Size = 50
    end
    object SysParamTableUpdateMirrors: TStringField
      FieldName = 'UpdateMirrors'
      Size = 250
    end
    object SysParamTableDeliveryPhone: TStringField
      FieldName = 'DeliveryPhone'
    end
    object SysParamTableTCPHostOpt: TStringField
      FieldName = 'TCPHostOpt'
      Size = 15
    end
    object SysParamTablePortB2B: TIntegerField
      FieldName = 'PortB2B'
    end
    object SysParamTablePortB2BIn: TIntegerField
      FieldName = 'PortB2BIn'
    end
    object SysParamTableITNPortB2B: TIntegerField
      FieldName = 'ITNPortB2B'
    end
  end
  object SysParamDataSource: TDataSource
    DataSet = SysParamTable
    Left = 764
    Top = 8
  end
  object NetTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = NetTimerTimer
    Left = 587
    Top = 300
  end
  object VersionTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ProgVersion'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DataVersion'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'QuantVersion'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'NewsVersion'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiscretNumberVersion'
        DataType = ftInteger
        Description = 'DiscretNumberVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TecdocVersion'
        DataType = ftString
        Size = 10
        Description = 'TecdocVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PictsVersion'
        DataType = ftString
        Size = 512
        Description = 'PictsVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AssemblyVersion'
        DataType = ftString
        Size = 10
        Description = 'AssemblyVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TiresVersion'
        DataType = ftString
        Size = 20
        Description = 'TiresVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TypVersion'
        DataType = ftString
        Size = 20
        Description = 'TypVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'iNewPictsVersion'
        DataType = ftMemo
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'VersionTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '098'
    StoreDefs = True
    Left = 764
    Top = 146
    object VersionTableId: TAutoIncField
      FieldName = 'Id'
    end
    object VersionTableProgVersion: TStringField
      FieldName = 'ProgVersion'
      Size = 10
    end
    object VersionTableDataVersion: TStringField
      FieldName = 'DataVersion'
      Size = 10
    end
    object VersionTableQuantVersion: TStringField
      FieldName = 'QuantVersion'
      Size = 10
    end
    object VersionTableNewsVersion: TStringField
      FieldName = 'NewsVersion'
      Size = 10
    end
    object VersionTableDiscretNumberVersion: TIntegerField
      FieldName = 'DiscretNumberVersion'
    end
    object VersionTableTecdocVersion: TStringField
      FieldName = 'TecdocVersion'
      Size = 10
    end
    object VersionTableAssemblyVersion: TStringField
      FieldName = 'AssemblyVersion'
      Size = 10
    end
    object VersionTableTiresVersion: TStringField
      FieldName = 'TiresVersion'
    end
    object VersionTableTypVersion: TStringField
      FieldName = 'TypVersion'
    end
    object VersionTablePictsVersion: TStringField
      FieldName = 'PictsVersion'
      Size = 512
    end
    object VersionTableiNewPictsVersion: TMemoField
      FieldName = 'iNewPictsVersion'
      BlobType = ftMemo
    end
  end
  object VersionDataSource: TDataSource
    DataSet = VersionTable
    Left = 764
    Top = 195
  end
  object DesTextsTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'DesTextsTableDBISA1'
        Fields = 'Des_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '024'
    StoreDefs = True
    Left = 137
    Top = 376
    object DesTextsTableDes_id: TIntegerField
      FieldName = 'Des_id'
    end
    object DesTextsTableTex_text: TStringField
      FieldName = 'Tex_text'
      Size = 100
    end
  end
  object CdsTextsTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'CdsTextsTableDBISA1'
        Fields = 'Cds_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '025'
    StoreDefs = True
    Left = 231
    Top = 377
    object CdsTextsTableCds_id: TIntegerField
      FieldName = 'Cds_id'
    end
    object CdsTextsTableTex_text: TStringField
      FieldName = 'Tex_text'
      Size = 100
    end
  end
  object ManufacturersTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'ManufacturersTableDBISA1'
        Fields = 'Mfa_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Brand'
        Fields = 'Mfa_brand'
        Compression = icNone
      end>
    TableName = '020'
    StoreDefs = True
    Left = 41
    Top = 426
    object ManufacturersTableMfa_id: TIntegerField
      FieldName = 'Mfa_id'
    end
    object ManufacturersTableMfa_brand: TStringField
      FieldName = 'Mfa_brand'
      Size = 50
    end
    object ManufacturersTableHide: TBooleanField
      FieldName = 'Hide'
    end
  end
  object ModelsTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = ModelsTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'ModelsTableDBISA1'
        Fields = 'Mod_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Mfa'
        Fields = 'Mfa_id;Mod_id'
        Compression = icNone
      end
      item
        Name = 'MfaText'
        Fields = 'Mfa_id;Tex_text'
        Compression = icNone
      end>
    TableName = '021'
    StoreDefs = True
    Left = 137
    Top = 426
    object ModelsTableMod_id: TIntegerField
      FieldName = 'Mod_id'
    end
    object ModelsTableMfa_id: TIntegerField
      FieldName = 'Mfa_id'
    end
    object ModelsTablePcon_start: TIntegerField
      FieldName = 'Pcon_start'
    end
    object ModelsTablePcon_end: TIntegerField
      FieldName = 'Pcon_end'
    end
    object ModelsTableTex_text: TStringField
      FieldName = 'Tex_text'
      Size = 100
    end
    object ModelsTablePconText1: TStringField
      FieldKind = fkCalculated
      FieldName = 'PconText1'
      Size = 10
      Calculated = True
    end
    object ModelsTablePconText2: TStringField
      FieldKind = fkCalculated
      FieldName = 'PconText2'
      Size = 10
      Calculated = True
    end
  end
  object TypesTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = TypesTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'TypesTableDBISA1'
        Fields = 'Typ_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Model'
        Fields = 'Mod_id;Sort'
        Compression = icNone
      end>
    TableName = '022'
    StoreDefs = True
    Left = 216
    Top = 426
    object TypesTableTyp_id: TIntegerField
      FieldName = 'Typ_id'
    end
    object TypesTableCds_id: TIntegerField
      FieldName = 'Cds_id'
    end
    object TypesTableMmt_cds_id: TIntegerField
      FieldName = 'Mmt_cds_id'
    end
    object TypesTableMod_id: TIntegerField
      FieldName = 'Mod_id'
    end
    object TypesTableSort: TIntegerField
      FieldName = 'Sort'
    end
    object TypesTablePcon_start: TIntegerField
      FieldName = 'Pcon_start'
    end
    object TypesTablePcon_end: TIntegerField
      FieldName = 'Pcon_end'
    end
    object TypesTableKw_from: TIntegerField
      FieldName = 'Kw_from'
    end
    object TypesTableKw_upto: TIntegerField
      FieldName = 'Kw_upto'
    end
    object TypesTableHp_from: TIntegerField
      FieldName = 'Hp_from'
    end
    object TypesTableHp_upto: TIntegerField
      FieldName = 'Hp_upto'
    end
    object TypesTableCcm: TIntegerField
      FieldName = 'Ccm'
    end
    object TypesTableCylinders: TSmallintField
      FieldName = 'Cylinders'
    end
    object TypesTableDoors: TSmallintField
      FieldName = 'Doors'
    end
    object TypesTableTank: TSmallintField
      FieldName = 'Tank'
    end
    object TypesTableVoltage_des_id: TIntegerField
      FieldName = 'Voltage_des_id'
    end
    object TypesTableAbs_des_id: TIntegerField
      FieldName = 'Abs_des_id'
    end
    object TypesTableAsr_des_id: TIntegerField
      FieldName = 'Asr_des_id'
    end
    object TypesTableEngine_des_id: TIntegerField
      FieldName = 'Engine_des_id'
    end
    object TypesTableBrake_type_des_id: TIntegerField
      FieldName = 'Brake_type_des_id'
    end
    object TypesTableBrake_syst_des_id: TIntegerField
      FieldName = 'Brake_syst_des_id'
    end
    object TypesTableFuel_des_id: TIntegerField
      FieldName = 'Fuel_des_id'
    end
    object TypesTableCatalyst_des_id: TIntegerField
      FieldName = 'Catalyst_des_id'
    end
    object TypesTableBody_des_id: TIntegerField
      FieldName = 'Body_des_id'
    end
    object TypesTableSteering_des_id: TIntegerField
      FieldName = 'Steering_des_id'
    end
    object TypesTableSteering_side_des_id: TIntegerField
      FieldName = 'Steering_side_des_id'
    end
    object TypesTableMax_weight: TBCDField
      FieldName = 'Max_weight'
    end
    object TypesTableDrive_des_id: TIntegerField
      FieldName = 'Drive_des_id'
    end
    object TypesTableTrans_des_id: TIntegerField
      FieldName = 'Trans_des_id'
    end
    object TypesTableValves: TSmallintField
      FieldName = 'Valves'
    end
    object TypesTableFuel_supply_des_id: TIntegerField
      FieldName = 'Fuel_supply_des_id'
    end
    object TypesTableCdsText: TStringField
      FieldKind = fkLookup
      FieldName = 'CdsText'
      LookupDataSet = CdsTextsTable
      LookupKeyFields = 'Cds_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Cds_id'
      Size = 100
      Lookup = True
    end
    object TypesTableTypeDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'TypeDescr'
      Size = 200
      Calculated = True
    end
    object TypesTableVoltText: TStringField
      FieldKind = fkLookup
      FieldName = 'VoltText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Voltage_des_id'
      Size = 10
      Lookup = True
    end
    object TypesTableAbsText: TStringField
      FieldKind = fkLookup
      FieldName = 'AbsText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Abs_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableAsrText: TStringField
      FieldKind = fkLookup
      FieldName = 'AsrText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Asr_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableEngText: TStringField
      FieldKind = fkLookup
      FieldName = 'EngText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Engine_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableBrTypeText: TStringField
      FieldKind = fkLookup
      FieldName = 'BrTypeText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Brake_type_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableBrSysText: TStringField
      FieldKind = fkLookup
      FieldName = 'BrSysText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Brake_syst_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableCatText: TStringField
      FieldKind = fkLookup
      FieldName = 'CatText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Catalyst_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableFuelText: TStringField
      FieldKind = fkLookup
      FieldName = 'FuelText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Fuel_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTablePconText1: TStringField
      FieldKind = fkCalculated
      FieldName = 'PconText1'
      Size = 10
      Calculated = True
    end
    object TypesTablePconText2: TStringField
      FieldKind = fkCalculated
      FieldName = 'PconText2'
      Size = 10
      Calculated = True
    end
    object TypesTableMfaHide: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'MfaHide'
      Calculated = True
    end
    object TypesTableBodyText: TStringField
      FieldKind = fkLookup
      FieldName = 'BodyText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Body_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableEng_codes: TStringField
      FieldName = 'Eng_codes'
      Size = 100
    end
    object TypesTableMmtCdsText: TStringField
      FieldKind = fkLookup
      FieldName = 'MmtCdsText'
      LookupDataSet = CdsTextsTable
      LookupKeyFields = 'Cds_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Mmt_cds_id'
      Size = 100
      Lookup = True
    end
    object TypesTableTransText: TStringField
      FieldKind = fkLookup
      FieldName = 'TransText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Trans_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableFuelSupplText: TStringField
      FieldKind = fkLookup
      FieldName = 'FuelSupplText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Fuel_supply_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableDriveText: TStringField
      FieldKind = fkLookup
      FieldName = 'DriveText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Drive_des_id'
      Size = 50
      Lookup = True
    end
    object TypesTableSteeringText: TStringField
      FieldKind = fkLookup
      FieldName = 'SteeringText'
      LookupDataSet = DesTextsTable
      LookupKeyFields = 'Des_id'
      LookupResultField = 'Tex_text'
      KeyFields = 'Steering_des_id'
      Size = 50
      Lookup = True
    end
  end
  object ArtTypTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Art_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Typ_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ArtTypTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Art'
        Fields = 'Art_id'
        Compression = icNone
      end
      item
        Name = 'Typ'
        Fields = 'Typ_id'
        Compression = icNone
      end>
    IndexName = 'Art'
    TableName = '023'
    StoreDefs = True
    Left = 46
    Top = 477
    object ArtTypTableId: TAutoIncField
      FieldName = 'Id'
    end
    object ArtTypTableArt_id: TIntegerField
      FieldName = 'Art_id'
    end
    object ArtTypTableTyp_id: TIntegerField
      FieldName = 'Typ_id'
    end
  end
  object XCatDetTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Tecdoc_id'
    TableName = '014'
    Left = 136
    Top = 477
  end
  object _del_CatPictTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'CatPictTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Tecdoc_id'
        Fields = 'Tecdoc_id;Sort'
        Compression = icNone
      end>
    IndexName = 'Tecdoc_id'
    TableName = '026'
    StoreDefs = True
    Left = 312
    Top = 429
    object _del_CatPictTableId: TAutoIncField
      FieldName = 'Id'
    end
    object _del_CatPictTableTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
    end
    object _del_CatPictTableSort: TSmallintField
      FieldName = 'Sort'
    end
    object _del_CatPictTablePict_id: TIntegerField
      FieldName = 'Pict_id'
    end
    object _del_CatPictTablePict_type: TSmallintField
      FieldName = 'Pict_type'
    end
    object _del_CatPictTableTab_nr: TSmallintField
      FieldName = 'Tab_nr'
    end
  end
  object PictTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'PictTableDBISA1'
        Fields = 'Pict_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '027'
    StoreDefs = True
    Left = 400
    Top = 429
    object PictTablePict_id: TIntegerField
      FieldName = 'Pict_id'
    end
    object PictTablePict_data: TBlobField
      FieldName = 'Pict_data'
    end
  end
  object PrimenTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    AfterScroll = PrimenTableAfterScroll
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'PrimenTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Descr'
        Fields = 'Description'
        Compression = icNone
      end>
    IndexName = 'Descr'
    TableName = 'Primen'
    StoreDefs = True
    Left = 584
    Top = 380
    object PrimenTableId: TAutoIncField
      FieldName = 'Id'
    end
    object PrimenTableTyp_id: TIntegerField
      FieldName = 'Typ_id'
    end
    object PrimenTableDescription: TStringField
      FieldName = 'Description'
      Size = 200
    end
    object PrimenTablePcon: TStringField
      FieldName = 'Pcon'
      Size = 25
    end
    object PrimenTableHp: TIntegerField
      FieldName = 'Hp'
    end
    object PrimenTableCylinders: TIntegerField
      FieldName = 'Cylinders'
    end
    object PrimenTableFuel: TStringField
      FieldName = 'Fuel'
      Size = 10
    end
    object PrimenTableEng_codes: TStringField
      FieldName = 'Eng_codes'
      Size = 50
    end
  end
  object PrimenDataSource: TDataSource
    DataSet = PrimenTable
    Left = 569
    Top = 433
  end
  object BrandReplTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'BrandReplTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Brand'
        Fields = 'Brand'
        Compression = icNone
      end>
    IndexName = 'Brand'
    TableName = 'BrandRepl'
    StoreDefs = True
    Left = 680
    Top = 380
    object BrandReplTableId: TAutoIncField
      FieldName = 'Id'
    end
    object BrandReplTableBrand: TStringField
      FieldName = 'Brand'
      Size = 50
    end
    object BrandReplTableRepl_brand: TStringField
      FieldName = 'Repl_brand'
      Size = 50
    end
  end
  object TDBrandTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'TDBrandTableDBISA1'
        Fields = 'Brand_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Descr'
        Fields = 'Brand_descr'
        Compression = icNone
      end
      item
        Name = 'Descr2'
        Fields = 'Descr_orig'
        Compression = icNone
      end>
    TableName = '112'
    StoreDefs = True
    Left = 312
    Top = 476
    object TDBrandTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
    end
    object TDBrandTableBrand_descr: TStringField
      FieldName = 'Brand_descr'
    end
    object TDBrandTableHide: TBooleanField
      FieldName = 'Hide'
    end
    object TDBrandTableDescr_orig: TStringField
      DisplayWidth = 20
      FieldName = 'Descr_orig'
    end
  end
  object LoadArtTypTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Art'
    TableName = '023'
    Left = 40
    Top = 532
  end
  object UnknownBrandsTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'UnknownBrandsTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Brand'
        Fields = 'Brand'
        Compression = icNone
      end>
    TableName = 'UnknownBrands'
    StoreDefs = True
    Left = 577
    Top = 483
    object UnknownBrandsTableId: TAutoIncField
      FieldName = 'Id'
    end
    object UnknownBrandsTableBrand: TStringField
      FieldName = 'Brand'
      Size = 50
    end
  end
  object CatTypDetTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Id'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Tecdoc_id'
        Fields = 'Tecdoc_id;Typ_id;Sort'
        Compression = icNone
      end>
    IndexFieldNames = 'Tecdoc_id'
    TableName = '028'
    StoreDefs = True
    Left = 399
    Top = 478
    object CatTypDetTableId: TAutoIncField
      FieldName = 'Id'
    end
    object CatTypDetTableTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
    end
    object CatTypDetTableTyp_id: TIntegerField
      FieldName = 'Typ_id'
    end
    object CatTypDetTableSort: TIntegerField
      FieldName = 'Sort'
    end
    object CatTypDetTableParam_id: TIntegerField
      FieldName = 'Param_id'
    end
    object CatTypDetTableParam_value: TStringField
      FieldName = 'Param_value'
      Size = 50
    end
    object CatTypDetTableParamDescr: TStringField
      FieldKind = fkLookup
      FieldName = 'ParamDescr'
      LookupDataSet = CatParTable
      LookupKeyFields = 'Param_id'
      LookupResultField = 'Description'
      KeyFields = 'Param_id'
      Size = 50
      Lookup = True
    end
  end
  object XCatTypDetTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Tecdoc_id'
    TableName = '028'
    Left = 400
    Top = 533
  end
  object LoadTimer: TTimer
    Enabled = False
    OnTimer = LoadTimerTimer
    Left = 764
    Top = 345
  end
  object SelectDirectory: TJvSelectDirectory
    Left = 768
    Top = 380
  end
  object WQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 785
    Top = 473
  end
  object XCatParTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Descr'
    TableName = '015'
    Left = 312
    Top = 532
  end
  object CatTypDetDataSource: TDataSource
    DataSet = CatTypDetTable
    Left = 497
    Top = 478
  end
  object ADODataSet2: TADODataSet
    Connection = ADOConnection
    Parameters = <>
    Left = 387
    Top = 299
  end
  object MyBrandTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand_descr'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'MyBrandTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Brand_descr'
        Fields = 'Brand_descr'
        Compression = icNone
      end>
    IndexName = 'Brand_descr'
    TableName = '029'
    StoreDefs = True
    Left = 491
    Top = 200
    object MyBrandTableId: TAutoIncField
      FieldName = 'Id'
    end
    object MyBrandTableBrand_descr: TStringField
      FieldName = 'Brand_descr'
      Size = 100
    end
  end
  object BlockMfaTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Mfa_brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'BlockMfaTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Mfa_brand'
        Fields = 'Mfa_brand'
        Compression = icNone
      end>
    IndexName = 'Mfa_brand'
    TableName = '030'
    StoreDefs = True
    Left = 136
    Top = 532
    object BlockMfaTableId: TAutoIncField
      FieldName = 'Id'
    end
    object BlockMfaTableMfa_brand: TStringField
      FieldName = 'Mfa_brand'
      Size = 50
    end
  end
  object AutoHistTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'AutoHistTableDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'DescId'
        DescFields = 'Id'
        Fields = 'Id'
        Options = [ixDescending]
        Compression = icNone
      end
      item
        Name = 'Typ_id'
        Fields = 'Typ_id'
        Compression = icNone
      end>
    TableName = '031'
    StoreDefs = True
    Left = 577
    Top = 533
    object AutoHistTableId: TAutoIncField
      FieldName = 'Id'
    end
    object AutoHistTableTyp_id: TIntegerField
      FieldName = 'Typ_id'
    end
    object AutoHistTableTypMmtText: TStringField
      FieldKind = fkLookup
      FieldName = 'TypMmtText'
      LookupDataSet = TypesTable
      LookupKeyFields = 'Typ_id'
      LookupResultField = 'MmtCdsText'
      KeyFields = 'Typ_id'
      Size = 100
      Lookup = True
    end
    object AutoHistTableMod_id: TIntegerField
      FieldName = 'Mod_id'
    end
    object AutoHistTableMfa_id: TIntegerField
      FieldName = 'Mfa_id'
    end
  end
  object SeachIdDetail: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    ReadOnly = True
    Left = 392
    Top = 200
  end
  object TestQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    FilterOptions = [foCaseInsensitive]
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    SQL.Strings = (
      'SELECT * FROM [002]')
    Params = <>
    Left = 120
    Top = 584
  end
  object MainQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    SQL.Strings = (
      'SELECT * FROM [002]')
    Params = <>
    Left = 224
    Top = 536
  end
  object TableCarFilter: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Type_ID'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_ID'
        DataType = ftMemo
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Type_ID'
        Fields = 'Type_ID'
        Compression = icNone
      end>
    IndexName = 'Type_ID'
    TableName = '032'
    StoreDefs = True
    Left = 40
    Top = 584
    object TableCarFilterID: TAutoIncField
      FieldName = 'ID'
    end
    object TableCarFilterType_ID: TIntegerField
      FieldName = 'Type_ID'
    end
    object TableCarFilterCatIDS: TMemoField
      FieldName = 'Cat_ID'
      BlobType = ftMemo
    end
  end
  object CarFilterSource: TDataSource
    DataSet = TableCarFilter
    Left = 120
    Top = 632
  end
  object UpdateCatalog: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = 'CATALOG'
    Left = 40
    Top = 632
  end
  object UpdateBrand: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = 'BRAND'
    Left = 40
    Top = 688
  end
  object UpdateTree: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = 'TREE'
    Left = 40
    Top = 752
  end
  object UpdateTreeID: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = 'TREEID'
    Left = 120
    Top = 696
  end
  object UpdateAnalog: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = 'ANALOG'
    Left = 120
    Top = 752
  end
  object UpdateOE: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = 'OE'
    Left = 208
    Top = 696
  end
  object DescriptionTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_ID'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Description'
        DataType = ftMemo
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Cat_id'
        Fields = 'Cat_id'
        Compression = icNone
      end>
    IndexName = 'Cat_id'
    MasterFields = 'Cat_id'
    MasterSource = CatalogDataSource
    TableName = '013'
    StoreDefs = True
    Left = 288
    Top = 802
    object DescriptionTableID: TAutoIncField
      FieldName = 'ID'
    end
    object DescriptionTableCat_ID: TIntegerField
      FieldName = 'Cat_ID'
    end
    object DescriptionTableDescription: TMemoField
      FieldName = 'Description'
      BlobType = ftMemo
    end
  end
  object DescriptionSource: TDataSource
    DataSet = DescriptionTable
    Left = 783
    Top = 587
  end
  object xDescriptionTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Cat_id'
    TableName = '013'
    Left = 373
    Top = 800
  end
  object TabCarMem: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Art_id'
        Fields = 'Art_id'
        Compression = icNone
      end>
    IndexName = 'Art_id'
    TableName = 'TabCarMem'
    StoreDefs = True
    Left = 208
    Top = 752
    object TabCarMemid: TAutoIncField
      FieldName = 'id'
    end
    object TabCarMemArt_id: TIntegerField
      FieldName = 'Art_id'
    end
    object TabCarMemType_ID: TIntegerField
      FieldName = 'Type_ID'
    end
  end
  object UpdatePrimen: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Type_id'
        Fields = 'Type_id'
        Compression = icNone
      end>
    IndexName = 'Type_id'
    TableName = 'Primen'
    StoreDefs = True
    Left = 40
    Top = 808
    object UpdatePrimenID: TAutoIncField
      FieldName = 'ID'
    end
    object UpdatePrimenType_Id: TIntegerField
      FieldName = 'Type_Id'
    end
    object UpdatePrimenCat_id: TMemoField
      FieldName = 'Cat_id'
      BlobType = ftMemo
    end
  end
  object FilterResult: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    AfterScroll = FilterResultAfterScroll
    OnCalcFields = FilterResultCalcFields
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    TableName = 'FilterResult'
    StoreDefs = True
    Left = 32
    Top = 864
    object FilterResultCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object FilterResultCode: TStringField
      FieldKind = fkCalculated
      FieldName = 'Code'
      Size = 50
      Calculated = True
    end
    object FilterResultCode2: TStringField
      FieldKind = fkCalculated
      FieldName = 'Code2'
      Size = 50
      Calculated = True
    end
    object FilterResultName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object FilterResultDescription: TStringField
      FieldName = 'Description'
      Size = 250
    end
    object FilterResultGroup_id: TIntegerField
      FieldName = 'Group_id'
    end
    object FilterResultSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
    end
    object FilterResultBrand_id: TIntegerField
      FieldName = 'Brand_id'
    end
    object FilterResultPrice: TCurrencyField
      FieldName = 'Price'
    end
    object FilterResultT1: TIntegerField
      FieldName = 'T1'
    end
    object FilterResultT2: TIntegerField
      FieldName = 'T2'
    end
    object FilterResultTitle: TBooleanField
      FieldName = 'Title'
    end
    object FilterResultSale: TStringField
      FieldName = 'Sale'
      Size = 1
    end
    object FilterResultNew: TStringField
      FieldName = 'New'
      Size = 1
    end
    object FilterResultTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
    end
    object FilterResultMult: TIntegerField
      FieldName = 'Mult'
    end
    object FilterResultUsa: TStringField
      FieldName = 'Usa'
      Size = 1
    end
    object FilterResultName_Descr: TStringField
      FieldName = 'Name_Descr'
      Size = 250
    end
    object FilterResultGroupInfo: TStringField
      FieldName = 'GroupInfo'
      Size = 250
    end
    object FilterResultQuantity: TStringField
      FieldName = 'Quantity'
      Size = 5
    end
    object FilterResultBrandDescr: TStringField
      FieldName = 'BrandDescr'
      Size = 50
    end
    object FilterResultPrimen: TMemoField
      FieldName = 'Primen'
      BlobType = ftMemo
    end
    object FilterResultPrice_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.00'
      Calculated = True
    end
    object FilterResultPrice_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      DisplayFormat = ',0.00'
      Calculated = True
    end
    object FilterResultPrice_pro: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.00'
      Calculated = True
    end
    object FilterResultOrdQuantityStr: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 5
      Calculated = True
    end
    object FilterResultPriceItog: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object FilterResultPriceQuant: TCurrencyField
      FieldName = 'PriceQuant'
    end
    object FilterResultSaleQ: TStringField
      FieldName = 'SaleQ'
      Size = 5
    end
  end
  object FilterResultFind: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Code2'
        Fields = 'Code2;Brand_id'
        Compression = icNone
      end>
    TableName = 'FilterResult'
    StoreDefs = True
    Left = 112
    Top = 864
    object FilterResultFindCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object FilterResultFindCode: TStringField
      FieldKind = fkCalculated
      FieldName = 'Code'
      Size = 50
      Calculated = True
    end
    object FilterResultFindCode2: TStringField
      FieldKind = fkCalculated
      FieldName = 'Code2'
      Size = 50
      Calculated = True
    end
    object FilterResultFindName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object FilterResultFindDescription: TStringField
      FieldName = 'Description'
      Size = 250
    end
    object FilterResultFindGroup_id: TIntegerField
      FieldName = 'Group_id'
    end
    object FilterResultFindSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
    end
    object FilterResultFindBrand_id: TIntegerField
      FieldName = 'Brand_id'
    end
    object FilterResultFindPrice: TCurrencyField
      FieldName = 'Price'
    end
    object FilterResultFindT1: TIntegerField
      FieldName = 'T1'
    end
    object FilterResultFindT2: TIntegerField
      FieldName = 'T2'
    end
    object FilterResultFindTitle: TBooleanField
      FieldName = 'Title'
    end
    object FilterResultFindSale: TStringField
      FieldName = 'Sale'
      Size = 1
    end
    object FilterResultFindNew: TStringField
      FieldName = 'New'
      Size = 1
    end
    object FilterResultFindTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
    end
    object FilterResultFindMult: TIntegerField
      FieldName = 'Mult'
    end
    object FilterResultFindUsa: TStringField
      FieldName = 'Usa'
      Size = 1
    end
  end
  object FindBrand: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = '003'
    Left = 400
    Top = 736
  end
  object UpdateQuant: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Code'
        Fields = 'sCode;sBrand'
        Compression = icNone
      end>
    TableName = 'Quants'
    StoreDefs = True
    Left = 472
    Top = 736
    object UpdateQuantQuants: TStringField
      FieldName = 'Quants'
      Size = 5
    end
    object UpdateQuantPRICE: TStringField
      FieldName = 'PRICE'
      Size = 10
    end
    object UpdateQuantSALE: TStringField
      FieldName = 'SALE'
      Size = 1
    end
    object UpdateQuantsCode: TStringField
      FieldName = 'sCode'
      Size = 50
    end
    object UpdateQuantsBrand: TStringField
      FieldName = 'sBrand'
      Size = 100
    end
    object UpdateQuantQuantNew: TStringField
      FieldName = 'QuantNew'
      Size = 5
    end
  end
  object _del_NomList: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'sBrand'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Code2'
        Fields = 'Code2;sBrand'
        Compression = icNone
      end>
    TableName = '002_'
    StoreDefs = True
    Left = 528
    Top = 800
    object _del_NomListCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object _del_NomListCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object _del_NomListsBrand: TStringField
      FieldName = 'sBrand'
      Size = 100
    end
  end
  object QuerySelect: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    OnQueryProgress = QuerySelectQueryProgress
    Left = 216
    Top = 624
  end
  object TimerSetCatFilter: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerSetCatFilterTimer
    Left = 572
    Top = 948
  end
  object LockBrand: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Id'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Brand'
        Fields = 'Brand'
        Compression = icNone
      end>
    TableName = 'LockBrand'
    StoreDefs = True
    Left = 783
    Top = 531
    object LockBrandBrand: TStringField
      FieldName = 'Brand'
      Size = 50
    end
    object LockBrandID: TAutoIncField
      FieldName = 'ID'
    end
  end
  object CatFilterTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    FilterOptions = [foCaseInsensitive]
    OnCalcFields = CatFilterTableCalcFields
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Group_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Subgroup_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'T1'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'T2'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Title'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sale'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'New'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Usa'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Cat_id'
        Fields = 'Cat_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = 'CatFilterTable'
    StoreDefs = True
    OnIndexProgress = CatFilterTableIndexProgress
    Left = 416
    Top = 864
    object CatFilterTableCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object CatFilterTableGroup_id: TIntegerField
      FieldName = 'Group_id'
    end
    object CatFilterTableSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
    end
    object CatFilterTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
    end
    object CatFilterTablePrice: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price'
      Calculated = True
    end
    object CatFilterTableT1: TSmallintField
      FieldName = 'T1'
    end
    object CatFilterTableT2: TSmallintField
      FieldName = 'T2'
    end
    object CatFilterTableTitle: TBooleanField
      FieldName = 'Title'
    end
    object CatFilterTableSale: TStringField
      FieldName = 'Sale'
      Size = 1
    end
    object CatFilterTableNew: TStringField
      FieldName = 'New'
      Size = 1
    end
    object CatFilterTableTecdoc_id: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Tecdoc_id'
      Calculated = True
    end
    object CatFilterTableMult: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Mult'
      Calculated = True
    end
    object CatFilterTableUsa: TStringField
      FieldName = 'Usa'
      Size = 1
    end
    object CatFilterTableSaleQ: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object CatFilterTablePrice_pro: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object CatFilterTableName_Descr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 255
      Calculated = True
    end
    object CatFilterTableGroupInfo: TStringField
      FieldKind = fkCalculated
      FieldName = 'GroupInfo'
      Size = 100
      Calculated = True
    end
    object CatFilterTablesaleQCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'Cat_id'
      Size = 5
      Lookup = True
    end
    object CatFilterTablePriceQuant: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object CatFilterTablePriceItog: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object CatFilterTableGroup_descr: TStringField
      FieldKind = fkLookup
      FieldName = 'GroupDescr'
      LookupDataSet = XGroupTable
      LookupKeyFields = 'Group_id'
      LookupResultField = 'Group_descr'
      KeyFields = 'Group_id'
      Size = 255
      Lookup = True
    end
    object CatFilterTableSubgrioupDescr: TStringField
      FieldKind = fkLookup
      FieldName = 'SubgroupDescr'
      LookupDataSet = XGroupTable
      LookupKeyFields = 'Group_id;Subgroup_id'
      LookupResultField = 'Subgroup_descr'
      KeyFields = 'Group_id;Subgroup_id'
      Size = 50
      Lookup = True
    end
    object CatFilterTablePrice_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      DisplayFormat = ',0.00'
      Calculated = True
    end
    object CatFilterTableOrdQuantity: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantity'
      Calculated = True
    end
    object CatFilterTableOrdQuantityStr: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 10
      Calculated = True
    end
    object CatFilterTableQuantity: TStringField
      FieldKind = fkLookup
      FieldName = 'Quantity'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'Cat_id'
      Size = 5
      Lookup = True
    end
    object CatFilterTablePrice_koef: TFloatField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object CatFilterTableDescription: TStringField
      FieldKind = fkCalculated
      FieldName = 'Description'
      Size = 250
      Calculated = True
    end
    object CatFilterTableName: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name'
      Size = 100
      Calculated = True
    end
    object CatFilterTableCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object CatFilterTableCode: TStringField
      FieldName = 'Code'
      Size = 50
    end
    object CatFilterTableBrandDescr: TStringField
      FieldKind = fkLookup
      FieldName = 'BrandDescr'
      LookupDataSet = BrandTable
      LookupKeyFields = 'Brand_id'
      LookupResultField = 'Description'
      KeyFields = 'Brand_id'
      Size = 100
      Lookup = True
    end
    object CatFilterTableShortCode: TStringField
      FieldName = 'ShortCode'
      Size = 50
    end
    object CatFilterTablePrice_koef_usd: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_usd'
      DisplayFormat = ',0.00'
      Calculated = True
    end
    object CatFilterTablePrice_koef_rub: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_rub'
      DisplayFormat = ',0'
      Calculated = True
    end
    object CatFilterTableBrandDescrView: TStringField
      FieldKind = fkCalculated
      FieldName = 'BrandDescrView'
      Size = 100
      Calculated = True
    end
    object CatFilterTableIDouble: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'IDouble'
      Calculated = True
    end
    object CatFilterTableQuantNew: TStringField
      FieldKind = fkLookup
      FieldName = 'QuantNew'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'QuantNew'
      KeyFields = 'Cat_id'
      Size = 5
      Lookup = True
    end
    object CatFilterTablepict_id: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'pict_id'
      Calculated = True
    end
    object CatFilterTabletyp_tdid: TIntegerField
      FieldName = 'typ_tdid'
    end
    object CatFilterTableparam_tdid: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'param_tdid'
      Calculated = True
    end
    object CatFilterTableBrandDescrRepl: TStringField
      FieldKind = fkCalculated
      FieldName = 'BrandDescrRepl'
      Size = 100
      Calculated = True
    end
    object CatFilterTableQuantLatest: TIntegerField
      FieldKind = fkLookup
      FieldName = 'QuantLatest'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Latest'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object CatFilterTableOrderOnly: TBooleanField
      FieldKind = fkLookup
      FieldName = 'OrderOnly'
      LookupDataSet = OOTable
      LookupKeyFields = 'CAT_ID'
      LookupResultField = 'IsOrder'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object CatFilterTablefUsingOptRf: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'fUsingOptRf'
      Calculated = True
    end
    object CatFilterTablesaleQOptRFCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQOptRFCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'SaleOptRF'
      KeyFields = 'Cat_id'
      Lookup = True
    end
    object CatFilterTablePriceQuantOptRF: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuantOptRF'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'PriceOptRF'
      KeyFields = 'cat_id'
      Lookup = True
    end
  end
  object ShortSearchTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexFieldNames = 'ShortCode'
    TableName = '002'
    StoreDefs = True
    Left = 496
    Top = 864
    object ShortSearchTableBrandName: TStringField
      FieldKind = fkLookup
      FieldName = 'BrandName'
      LookupDataSet = BrandTable
      LookupKeyFields = 'Brand_id'
      LookupResultField = 'Description'
      KeyFields = 'Brand_id'
      Size = 100
      Lookup = True
    end
    object ShortSearchTableCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object ShortSearchTableCode: TStringField
      FieldName = 'Code'
      Size = 50
    end
    object ShortSearchTableCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object ShortSearchTableName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object ShortSearchTableDescription: TStringField
      FieldName = 'Description'
      Size = 250
    end
    object ShortSearchTableGroup_id: TIntegerField
      FieldName = 'Group_id'
    end
    object ShortSearchTableSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
    end
    object ShortSearchTableBrand_id: TIntegerField
      FieldName = 'Brand_id'
    end
    object ShortSearchTablePrice: TCurrencyField
      FieldName = 'Price'
    end
    object ShortSearchTableT1: TSmallintField
      FieldName = 'T1'
    end
    object ShortSearchTableT2: TSmallintField
      FieldName = 'T2'
    end
    object ShortSearchTableTitle: TBooleanField
      FieldName = 'Title'
    end
    object ShortSearchTableSale: TStringField
      FieldName = 'Sale'
      Size = 1
    end
    object ShortSearchTableNew: TStringField
      FieldName = 'New'
      Size = 1
    end
    object ShortSearchTableTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
    end
    object ShortSearchTableMult: TIntegerField
      FieldName = 'Mult'
    end
    object ShortSearchTableUsa: TStringField
      FieldName = 'Usa'
      Size = 1
    end
    object ShortSearchTablePrimen: TMemoField
      FieldName = 'Primen'
      BlobType = ftMemo
    end
    object ShortSearchTableShortCode: TStringField
      FieldName = 'ShortCode'
      Size = 50
    end
    object ShortSearchTableDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Descr'
      Size = 250
      Calculated = True
    end
  end
  object DoubleTableShort: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = DoubleTableShortCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'ShortCode'
    TableName = '002'
    Left = 328
    Top = 864
    object DoubleTableShortCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object DoubleTableShortCode: TStringField
      FieldName = 'Code'
      Size = 50
    end
    object DoubleTableShortCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object DoubleTableShortName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object DoubleTableShortDescription: TStringField
      FieldName = 'Description'
      Size = 250
    end
    object DoubleTableShortGroup_id: TIntegerField
      FieldName = 'Group_id'
    end
    object DoubleTableShortSubgroup_id: TIntegerField
      FieldName = 'Subgroup_id'
    end
    object DoubleTableShortBrand_id: TIntegerField
      FieldName = 'Brand_id'
    end
    object DoubleTableShortPrice: TCurrencyField
      FieldName = 'Price'
    end
    object DoubleTableShortT1: TSmallintField
      FieldName = 'T1'
    end
    object DoubleTableShortT2: TSmallintField
      FieldName = 'T2'
    end
    object DoubleTableShortTitle: TBooleanField
      FieldName = 'Title'
    end
    object DoubleTableShortSale: TStringField
      FieldName = 'Sale'
      Size = 1
    end
    object DoubleTableShortNew: TStringField
      FieldName = 'New'
      Size = 1
    end
    object DoubleTableShortTecdoc_id: TIntegerField
      FieldName = 'Tecdoc_id'
    end
    object DoubleTableShortMult: TIntegerField
      FieldName = 'Mult'
    end
    object DoubleTableShortUsa: TStringField
      FieldName = 'Usa'
      Size = 1
    end
    object DoubleTableShortPrimen: TMemoField
      FieldName = 'Primen'
      BlobType = ftMemo
    end
    object DoubleTableShortShortCode: TStringField
      FieldName = 'ShortCode'
      Size = 50
    end
    object DoubleTableShortBrandName: TStringField
      FieldKind = fkLookup
      FieldName = 'BrandName'
      LookupDataSet = BrandTable
      LookupKeyFields = 'Brand_id'
      LookupResultField = 'Description'
      KeyFields = 'Brand_id'
      Size = 50
      Lookup = True
    end
    object DoubleTableShortDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Descr'
      Size = 250
      Calculated = True
    end
  end
  object AssortmentExpansion: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = AssortmentExpansionCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Date'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Amount'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Post'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '033'
    StoreDefs = True
    Left = 400
    Top = 616
    object AssortmentExpansionCode: TStringField
      FieldName = 'Code'
      Size = 50
    end
    object AssortmentExpansionCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object AssortmentExpansionBrand: TStringField
      FieldName = 'Brand'
      Size = 100
    end
    object AssortmentExpansionDate: TStringField
      FieldName = 'Date'
      Size = 10
    end
    object AssortmentExpansionAmount: TIntegerField
      FieldName = 'Amount'
    end
    object AssortmentExpansionNameDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'NameDescr'
      Size = 255
      Calculated = True
    end
    object AssortmentExpansionPrice: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price'
      Calculated = True
    end
    object AssortmentExpansionPrice_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object AssortmentExpansionArtQuant: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtQuant'
      Size = 5
      Calculated = True
    end
    object AssortmentExpansionArtSale: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtSale'
      Calculated = True
    end
    object AssortmentExpansionArtBrandId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtBrandId'
      Calculated = True
    end
    object AssortmentExpansionPrice_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object AssortmentExpansionID: TAutoIncField
      FieldName = 'ID'
    end
    object AssortmentExpansionPost: TIntegerField
      FieldName = 'Post'
    end
    object AssortmentExpansionCat_Id: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Cat_Id'
      Calculated = True
    end
    object AssortmentExpansionBrandRepl: TStringField
      FieldKind = fkCalculated
      FieldName = 'BrandRepl'
      Size = 100
      Calculated = True
    end
    object AssortmentExpansionArtGroupId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtGroupId'
      Calculated = True
    end
    object AssortmentExpansionArtSubgroupId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtSubgroupId'
      Calculated = True
    end
    object AssortmentExpansionArtCode: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtCode'
      Calculated = True
    end
  end
  object AssortmentExpansionDataSource: TDataSource
    DataSet = AssortmentExpansion
    Left = 400
    Top = 664
  end
  object QueryFilter: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    ReadOnly = True
    Left = 529
    Top = 664
  end
  object ColumnView: TDBISAMTable
    AutoDisplayLabels = True
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Code'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'BrandDescrView'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Name_Descr'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price_koef'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price_koef_rub'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price_koef_usd'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price_koef_eur'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Quantity'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'OrdQuantityStr'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'SaleQ'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'New'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Usa'
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'QuantNew'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Price_Pro'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '035'
    StoreDefs = True
    Left = 328
    Top = 928
    object ColumnViewCode: TBooleanField
      FieldName = 'Code'
    end
    object ColumnViewBrandDescrView: TBooleanField
      FieldName = 'BrandDescrView'
    end
    object ColumnViewName_Descr: TBooleanField
      FieldName = 'Name_Descr'
    end
    object ColumnViewPrice_koef: TBooleanField
      FieldName = 'Price_koef'
    end
    object ColumnViewPrice_koef_rub: TBooleanField
      FieldName = 'Price_koef_rub'
    end
    object ColumnViewPrice_koef_usd: TBooleanField
      FieldName = 'Price_koef_usd'
    end
    object ColumnViewPrice_koef_eur: TBooleanField
      FieldName = 'Price_koef_eur'
    end
    object ColumnViewQuantity: TBooleanField
      FieldName = 'Quantity'
    end
    object ColumnViewOrdQuantityStr: TBooleanField
      FieldName = 'OrdQuantityStr'
    end
    object ColumnViewSaleQ: TBooleanField
      FieldName = 'SaleQ'
    end
    object ColumnViewNew: TBooleanField
      FieldName = 'New'
    end
    object ColumnViewUsa: TStringField
      FieldName = 'Usa'
    end
    object ColumnViewID: TAutoIncField
      FieldName = 'ID'
    end
    object ColumnViewQuantNew: TBooleanField
      FieldName = 'QuantNew'
    end
    object ColumnViewPrice_pro: TBooleanField
      FieldName = 'Price_pro'
    end
  end
  object ColumnViewDataSource: TDataSource
    DataSet = ColumnView
    Left = 416
    Top = 928
  end
  object LoadOE: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Code2'
        Fields = 'Code2'
        Compression = icNone
      end>
    TableName = 'LoadOE'
    StoreDefs = True
    Left = 32
    Top = 936
    object LoadOEID: TAutoIncField
      FieldName = 'ID'
    end
    object LoadOECat_ID: TIntegerField
      FieldName = 'Cat_ID'
    end
    object LoadOECode: TStringField
      FieldName = 'Code'
      Size = 25
    end
    object LoadOECode2: TStringField
      FieldName = 'Code2'
      Size = 25
    end
    object LoadOEShortOE: TStringField
      FieldName = 'ShortOE'
      Size = 25
    end
  end
  object _del_OEMap: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'SIM'
        Fields = 'SIM'
        Compression = icNone
      end>
    TableName = '016_'
    StoreDefs = True
    Left = 112
    Top = 936
    object _del_OEMapSIM: TStringField
      FieldName = 'SIM'
      Size = 1
    end
    object _del_OEMapStartID: TIntegerField
      FieldName = 'StartID'
    end
    object _del_OEMapEndID: TIntegerField
      FieldName = 'EndID'
    end
    object _del_OEMapID: TAutoIncField
      FieldName = 'ID'
    end
  end
  object ReturnDocTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    BeforeScroll = ReturnDocTableBeforeScroll
    OnCalcFields = ReturnDocTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Data'
        DataType = ftDate
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Note'
        DataType = ftString
        Size = 255
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cli_id'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Post'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Type'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DataPos'
        DataType = ftDateTime
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Num'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'RetDoc_ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sent_time'
        DataType = ftDateTime
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Sign'
        DataType = ftString
        Size = 7
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'TcpAnswer'
        DataType = ftBlob
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Agreement_No'
        DataType = ftString
        Size = 20
        Description = 'Agreement_No'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AgrDescr'
        DataType = ftString
        Size = 128
        Description = 'AgrDescr'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'fDefect'
        DataType = ftBoolean
        Description = 'fDefect'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'delivery'
        DataType = ftInteger
        Description = 'delivery'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Addres_id'
        DataType = ftString
        Size = 20
        Description = 'Addres_id'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'reason'
        DataType = ftString
        Size = 10
        Description = 'reason'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Phone'
        DataType = ftString
        Size = 20
        Description = 'Phone'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 100
        Description = 'Name'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'FakeAddresDescr'
        DataType = ftString
        Size = 250
        Description = 'FakeAddresDescr'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AgrGroup'
        DataType = ftString
        Size = 20
        Description = 'AgrGroup'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'LotusNumber'
        DataType = ftString
        Size = 10
        Description = 'LotusNumber'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'RetDoc_ID'
        Fields = 'RetDoc_ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Date'
        Fields = 'Data;Num'
        Compression = icNone
      end
      item
        Name = 'Cli_Date'
        Fields = 'Cli_id;Data;Num'
        Compression = icNone
      end>
    TableName = '036'
    StoreDefs = True
    Left = 48
    Top = 1032
    object ReturnDocTableData: TDateField
      FieldName = 'Data'
    end
    object ReturnDocTableNote: TStringField
      FieldName = 'Note'
      Size = 255
    end
    object ReturnDocTablePost: TIntegerField
      FieldName = 'Post'
    end
    object ReturnDocTableType: TStringField
      FieldName = 'Type'
      Size = 1
    end
    object ReturnDocTableDataPos: TDateTimeField
      FieldName = 'DataPos'
    end
    object ReturnDocTableClientName: TStringField
      FieldKind = fkLookup
      FieldName = 'ClientName'
      LookupDataSet = ClIDsTable
      LookupKeyFields = 'Client_ID'
      LookupResultField = 'Description'
      KeyFields = 'Cli_id'
      Size = 50
      Lookup = True
    end
    object ReturnDocTableClientInfo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ClientInfo'
      Size = 50
      Calculated = True
    end
    object ReturnDocTableRetDoc_ID: TAutoIncField
      FieldName = 'RetDoc_ID'
    end
    object ReturnDocTableNum: TIntegerField
      FieldName = 'Num'
    end
    object ReturnDocTableSent_time: TDateTimeField
      FieldName = 'Sent_time'
    end
    object ReturnDocTableSign: TStringField
      FieldName = 'Sign'
      Size = 7
    end
    object ReturnDocTableCli_id: TStringField
      FieldName = 'Cli_id'
      Size = 15
    end
    object ReturnDocTableClientLookup: TStringField
      FieldKind = fkLookup
      FieldName = 'ClientLookup'
      LookupDataSet = ClIDsTable
      LookupKeyFields = 'Client_ID'
      LookupResultField = 'Description'
      KeyFields = 'Cli_id'
      Size = 250
      Lookup = True
    end
    object ReturnDocTableTcpAnswer: TBlobField
      FieldName = 'TcpAnswer'
    end
    object ReturnDocTableAgreement_No: TStringField
      FieldName = 'Agreement_No'
    end
    object ReturnDocTableAgrDescr: TStringField
      FieldName = 'AgrDescr'
      Size = 128
    end
    object ReturnDocTablefDefect: TBooleanField
      FieldName = 'fDefect'
    end
    object ReturnDocTabledelivery: TIntegerField
      FieldName = 'delivery'
    end
    object ReturnDocTableAddres_Id: TStringField
      FieldName = 'Addres_Id'
    end
    object ReturnDocTablereason: TStringField
      FieldName = 'reason'
      Size = 10
    end
    object ReturnDocTablePhone: TStringField
      FieldName = 'Phone'
    end
    object ReturnDocTableName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object ReturnDocTableFakeAddresDescr: TStringField
      FieldName = 'FakeAddresDescr'
      Size = 250
    end
    object ReturnDocTableAgrGroup: TStringField
      FieldName = 'AgrGroup'
    end
    object ReturnDocTableLotusNumber: TStringField
      FieldName = 'LotusNumber'
      Size = 10
    end
  end
  object ReturnDocDetTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = ReturnDocDetTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'RetDoc_ID'
        Fields = 'RetDoc_ID'
        Compression = icNone
      end>
    IndexName = 'RetDoc_ID'
    MasterFields = 'RetDoc_ID'
    MasterSource = ReturnDocDataSource
    TableName = '037'
    StoreDefs = True
    Left = 48
    Top = 1076
    object ReturnDocDetTableID: TAutoIncField
      FieldName = 'ID'
    end
    object ReturnDocDetTableCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object ReturnDocDetTableBrand: TStringField
      FieldName = 'Brand'
      Size = 50
    end
    object ReturnDocDetTableQuantity: TIntegerField
      FieldName = 'Quantity'
    end
    object ReturnDocDetTableNote: TStringField
      FieldName = 'Note'
      Size = 250
    end
    object ReturnDocDetTableCode: TStringField
      FieldKind = fkCalculated
      FieldName = 'Code'
      Size = 50
      Calculated = True
    end
    object ReturnDocDetTableDescription: TStringField
      FieldKind = fkCalculated
      FieldName = 'Description'
      Size = 250
      Calculated = True
    end
    object ReturnDocDetTableRetDoc_ID: TIntegerField
      FieldName = 'RetDoc_ID'
    end
    object ReturnDocDetTableCat_ID: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Cat_ID'
      Calculated = True
    end
    object ReturnDocDetTableOrdered: TSmallintField
      FieldName = 'Ordered'
    end
    object ReturnDocDetTableBrandRepl: TStringField
      FieldKind = fkCalculated
      FieldName = 'BrandRepl'
      Size = 100
      Calculated = True
    end
    object ReturnDocDetTableCheckField: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'CheckField'
      Calculated = True
    end
  end
  object ReturnDocDataSource: TDataSource
    DataSet = ReturnDocTable
    Left = 160
    Top = 1032
  end
  object ReturnDocDetDataSource: TDataSource
    DataSet = ReturnDocDetTable
    Left = 160
    Top = 1096
  end
  object AnalogOrderDet: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Locked = 0'
    Filtered = True
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Locked'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'AnalogOrderDetDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'AnCode'
        Fields = 'Cat_id;An_code'
        Compression = icNone
      end
      item
        Name = 'AnCode2'
        Fields = 'An_code'
        Compression = icNone
      end
      item
        Name = 'An_ShortCode'
        Fields = 'An_ShortCode'
        Compression = icNone
      end>
    IndexFieldNames = 'Cat_id'
    MasterFields = 'Cat_id'
    MasterSource = OrderDetDataSource
    TableName = '007'
    StoreDefs = True
    Left = 270
    Top = 1000
    object AnalogOrderDetId: TAutoIncField
      FieldName = 'Id'
    end
    object AnalogOrderDetCat_id: TIntegerField
      FieldName = 'Cat_id'
    end
    object AnalogOrderDetAn_code: TStringField
      FieldName = 'An_code'
      Size = 50
    end
    object AnalogOrderDetAn_brand: TStringField
      FieldName = 'An_brand'
      Size = 50
    end
    object AnalogOrderDetAn_id: TIntegerField
      FieldName = 'An_id'
    end
    object AnalogOrderDetLocked: TIntegerField
      FieldName = 'Locked'
    end
    object AnalogOrderDetAn_ShortCode: TStringField
      FieldName = 'An_ShortCode'
      Size = 50
    end
    object AnalogOrderDetQuant: TStringField
      FieldKind = fkLookup
      FieldName = 'Quant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 5
      Lookup = True
    end
    object AnalogOrderDetSaleQ: TStringField
      FieldKind = fkLookup
      FieldName = 'SaleQ'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogOrderDetPrice: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogOrderDetBrand_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Brand_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogOrderDetDescr: TStringField
      FieldKind = fkLookup
      FieldName = 'Descr'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Name_Descr'
      KeyFields = 'An_id'
      Size = 255
      Lookup = True
    end
  end
  object adoOLEDB: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Admin;Persist Security Info=False;U' +
      'ser ID=Admin;Initial Catalog=TECDOC;Data Source=AMD'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 755
    Top = 935
  end
  object msQuery: TADOQuery
    Connection = adoOLEDB
    CursorLocation = clUseServer
    CursorType = ctOpenForwardOnly
    Parameters = <>
    Left = 755
    Top = 980
  end
  object UpdateAnalogDel: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = 'ANALOGDEL'
    Left = 120
    Top = 802
  end
  object PriceList: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'sBrand'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'sName'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'sDescr'
        DataType = ftString
        Size = 250
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Code2'
        Fields = 'Code2;sBrand'
        Compression = icNone
      end>
    TableName = 'price'
    StoreDefs = True
    Left = 688
    Top = 960
    object IntegerField1: TIntegerField
      FieldName = 'Cat_id'
    end
    object StringField1: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object StringField2: TStringField
      FieldName = 'sBrand'
      Size = 100
    end
    object PriceListsName: TStringField
      FieldName = 'sName'
      Size = 100
    end
    object PriceListsDescr: TStringField
      FieldName = 'sDescr'
      Size = 250
    end
  end
  object UpdateQuant2: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Code'
        Fields = 'sCode;Brand_id'
        Compression = icNone
      end>
    TableName = 'UpdateQuant2'
    StoreDefs = True
    Left = 347
    Top = 1046
    object StringField4: TStringField
      FieldName = 'Quants'
      Size = 5
    end
    object StringField5: TStringField
      FieldName = 'PRICE'
      Size = 10
    end
    object StringField6: TStringField
      FieldName = 'SALE'
      Size = 1
    end
    object StringField7: TStringField
      FieldName = 'sCode'
      Size = 50
    end
    object StringField9: TStringField
      FieldName = 'QuantNew'
      Size = 5
    end
    object UpdateQuant2brand_id: TIntegerField
      FieldName = 'brand_id'
    end
  end
  object memBrand: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'Descr'
        Fields = 'Description'
        Options = [ixCaseInsensitive]
        Compression = icNone
      end>
    TableName = 'memBrand'
    StoreDefs = True
    Left = 412
    Top = 996
    object memBrandBrand_id: TIntegerField
      FieldName = 'brand_id'
    end
    object memBrandDescription: TStringField
      FieldName = 'Description'
      Size = 100
    end
  end
  object memAnalog: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    AfterScroll = memAnalogAfterScroll
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'memAnalogDBISA1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'QuantDesc'
        DescFields = 'QuantityCalc;Name_Descr'
        Fields = 'QuantityCalc;Name_Descr'
        Options = [ixDescending]
        Compression = icNone
      end>
    TableName = 'memAnalog'
    StoreDefs = True
    Left = 532
    Top = 6
    object memAnalogId: TAutoIncField
      FieldName = 'Id'
    end
    object memAnalogAn_code: TStringField
      FieldName = 'An_code'
      Size = 50
    end
    object memAnalogPrice_koef: TCurrencyField
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
    end
    object memAnalogPrice_pro: TCurrencyField
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
    end
    object memAnalogQuantity: TStringField
      FieldName = 'Quantity'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 10
    end
    object memAnalogQuantityCalc: TIntegerField
      FieldName = 'QuantityCalc'
    end
    object memAnalogNew: TStringField
      FieldName = 'New'
      Size = 1
    end
    object memAnalogName_Descr: TStringField
      FieldName = 'Name_Descr'
      Size = 350
    end
    object memAnalogOrdQuantityStr: TStringField
      FieldName = 'OrdQuantityStr'
      Size = 10
    end
    object memAnalogUsa: TStringField
      FieldName = 'Usa'
      Size = 1
    end
    object memAnalogSaleQ: TStringField
      FieldName = 'SaleQ'
      Size = 1
    end
    object memAnalogAn_brand_repl: TStringField
      FieldName = 'An_brand_repl'
      Size = 100
    end
    object memAnalogQuantLatest: TIntegerField
      FieldName = 'QuantLatest'
    end
    object memAnalogOrderOnly: TBooleanField
      FieldName = 'OrderOnly'
    end
    object memAnalogAn_id: TIntegerField
      FieldName = 'An_id'
    end
    object memAnalogAn_group_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_group_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object memAnalogAn_subgroup_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_subgroup_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object memAnalogAn_Brand_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_Brand_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object memAnalogMult: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Mult'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Mult'
      KeyFields = 'An_id'
      Lookup = True
    end
    object memAnalogPrice_koef_eur: TCurrencyField
      FieldName = 'Price_koef_eur'
    end
    object memAnalogAn_brand: TStringField
      FieldName = 'An_brand'
      Size = 50
    end
    object memAnalogPriceItog: TCurrencyField
      FieldName = 'PriceItog'
    end
    object memAnalogfUsingOptRf: TBooleanField
      FieldName = 'fUsingOptRf'
    end
  end
  object memAnalogDataSource: TDataSource
    DataSet = memAnalog
    Left = 537
    Top = 48
  end
  object DiscountTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'CLI_ID'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'GR_ID'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'SUBGR_ID'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'BRAND_ID'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Discount'
        DataType = ftFloat
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Margin'
        DataType = ftFloat
        Description = 'Margin'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'bDelete'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'UpdateDisc'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PricesGroup'
        DataType = ftInteger
        Description = 'PricesGroup'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'FIX'
        DataType = ftInteger
        Description = 'FIX'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'DiscountTableDBISA1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'CLI_OLD'
        DescFields = 'CLI_ID;GR_ID;SUBGR_ID;BRAND_ID'
        Fields = 'CLI_ID;GR_ID;SUBGR_ID;BRAND_ID'
        Options = [ixDescending]
        Compression = icNone
      end
      item
        Name = 'CLI'
        DescFields = 'CLI_ID;FIX;DISCOUNT'
        Fields = 'CLI_ID;FIX;DISCOUNT'
        Options = [ixDescending]
        Compression = icNone
      end
      item
        Name = 'CLI_MARGIN'
        DescFields = 'CLI_ID;FIX;MARGIN'
        Fields = 'CLI_ID;FIX;MARGIN'
        Options = [ixDescending]
        Compression = icNone
      end>
    IndexName = 'CLI'
    TableName = '038'
    StoreDefs = True
    Left = 496
    Top = 616
    object DiscountTableID: TAutoIncField
      FieldName = 'ID'
    end
    object DiscountTableCLI_ID: TStringField
      FieldName = 'CLI_ID'
      Size = 15
    end
    object DiscountTableGR_ID: TIntegerField
      FieldName = 'GR_ID'
    end
    object DiscountTableSUBGR_ID: TIntegerField
      FieldName = 'SUBGR_ID'
    end
    object DiscountTableBRAND_ID: TIntegerField
      FieldName = 'BRAND_ID'
    end
    object DiscountTableDiscount: TFloatField
      FieldName = 'Discount'
    end
    object DiscountTableMargin: TFloatField
      FieldName = 'Margin'
    end
    object DiscountTablebDelete: TIntegerField
      FieldName = 'bDelete'
    end
    object DiscountTableUpdateDisc: TBooleanField
      FieldName = 'UpdateDisc'
    end
    object DiscountTablePricesGroup: TIntegerField
      FieldName = 'PricesGroup'
    end
    object DiscountTableFIX: TIntegerField
      FieldName = 'FIX'
    end
  end
  object Query: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 706
    Top = 1019
  end
  object Notes: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Date'
        DataType = ftDateTime
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Note'
        DataType = ftMemo
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'NotesDBISA1'
        Fields = 'RecordID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Date'
        Fields = 'Date'
        Compression = icNone
      end>
    IndexName = 'Date'
    TableName = '039'
    StoreDefs = True
    Left = 665
    Top = 1020
    object NotesID: TAutoIncField
      FieldName = 'ID'
    end
    object NotesDate: TDateTimeField
      FieldName = 'Date'
    end
    object NotesNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
    end
  end
  object nom: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    TableName = 'nom'
    StoreDefs = True
    Left = 413
    Top = 1055
    object IntegerField2: TIntegerField
      FieldName = 'Cat_id'
    end
    object StringField3: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object nombrand_id: TIntegerField
      FieldName = 'brand_id'
    end
  end
  object memQuants: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'memQuantsDBISA1'
        Fields = 'CAT_ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = 'memQuants'
    StoreDefs = True
    Left = 467
    Top = 996
    object memQuantsCAT_ID: TIntegerField
      FieldName = 'CAT_ID'
    end
  end
  object memKK: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'GroupBrand'
        Fields = 'Group_Id;SubGroup_Id;Brand_Id'
        Compression = icNone
      end
      item
        Name = 'BrandGroup'
        Fields = 'Brand_Id;Group_Id;SubGroup_Id'
        Compression = icNone
      end>
    TableName = 'memKK'
    StoreDefs = True
    Left = 70
    Top = 1155
    object memKKCat_Id: TIntegerField
      FieldName = 'Cat_Id'
    end
    object memKKBrand_Id: TIntegerField
      FieldName = 'Brand_Id'
    end
    object memKKGroup_Id: TIntegerField
      FieldName = 'Group_Id'
    end
    object memKKSubGroup_Id: TIntegerField
      FieldName = 'SubGroup_Id'
    end
  end
  object KK: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = KKCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code2'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'NotesDBISA1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'LOOK'
        Fields = 'Code2;Brand'
        Compression = icNone
      end>
    TableName = '040'
    StoreDefs = True
    Left = 35
    Top = 1155
    object KKId: TAutoIncField
      FieldName = 'ID'
    end
    object KKCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object KKBrand: TStringField
      FieldName = 'Brand'
      Size = 100
    end
    object KKCode: TStringField
      FieldKind = fkCalculated
      FieldName = 'Code'
      Size = 50
      Calculated = True
    end
    object KKDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Descr'
      Size = 250
      Calculated = True
    end
    object KKPrice: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object KKPrice_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object KKPrice_pro: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object KKCat_Id: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Cat_Id'
      Calculated = True
    end
    object KKBrand_Id: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Brand_Id'
      Calculated = True
    end
    object KKGroup_Id: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Group_Id'
      Calculated = True
    end
    object KKSubGroup_Id: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'SubGroup_Id'
      Calculated = True
    end
    object KKBrandDescrRepl: TStringField
      FieldKind = fkCalculated
      FieldName = 'BrandDescrRepl'
      Calculated = True
    end
  end
  object KKDataSource: TDataSource
    DataSet = KK
    Left = 160
    Top = 1151
  end
  object memProfit: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    TableName = 'memProfit'
    StoreDefs = True
    Left = 470
    Top = 305
    object memProfitPriceFrom: TFloatField
      DisplayLabel = #1062#1077#1085#1072' '#1086#1090', '#8364' ('#1074#1082#1083#1102#1095#1072#1103')'
      FieldName = 'PriceFrom'
    end
    object memProfitPriceTo: TFloatField
      DisplayLabel = #1062#1077#1085#1072' '#1076#1086', '#8364
      FieldName = 'PriceTo'
    end
    object memProfitProfit: TFloatField
      DisplayLabel = #1053#1072#1094#1077#1085#1082#1072', %'
      FieldName = 'Profit'
    end
  end
  object LoadArtTypTableAuto: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'Typ'
    TableName = '023'
    Left = 80
    Top = 532
  end
  object KitTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = KitTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'CAT_ID'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'CHILD_CODE'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'CHILD_BRAND'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'CHILD_ID'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'QUANTITY'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'CAT'
        Fields = 'CAT_ID'
        Compression = icNone
      end>
    IndexFieldNames = 'CAT_ID'
    MasterFields = 'CAT_ID'
    MasterSource = CatalogDataSource
    TableName = '041'
    StoreDefs = True
    Left = 738
    Top = 55
    object KitTableID: TAutoIncField
      FieldName = 'ID'
    end
    object KitTableCAT_ID: TIntegerField
      FieldName = 'CAT_ID'
    end
    object KitTableCHILD_CODE: TStringField
      FieldName = 'CHILD_CODE'
      Size = 50
    end
    object KitTableCHILD_BRAND: TStringField
      FieldName = 'CHILD_BRAND'
      Size = 50
    end
    object KitTableCHILD_ID: TIntegerField
      FieldName = 'CHILD_ID'
    end
    object KitTableQUANTITY: TIntegerField
      FieldName = 'QUANTITY'
    end
    object KitTableDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Descr'
      Size = 150
      Calculated = True
    end
    object KitTablePrice_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object KitTablePrice_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object KitTableprice_koef_sum: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'price_koef_sum'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object KitTableQUANT_CAT: TStringField
      FieldKind = fkCalculated
      FieldName = 'QUANT_CAT'
      Size = 10
      Calculated = True
    end
    object KitTablePriceProEur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceProEur'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object KitTablePriceProEur_sum: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceProEur_sum'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object KitTablePriceEur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceEur'
      Calculated = True
    end
  end
  object KitDataSource: TDataSource
    DataSet = KitTable
    Left = 785
    Top = 75
  end
  object OOTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = OOTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'CAT_ID'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'OOTableDBISA1'
        Fields = 'CAT_ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '042'
    StoreDefs = True
    Left = 738
    Top = 100
    object IntegerField3: TIntegerField
      FieldName = 'CAT_ID'
      Origin = '042.CAT_ID'
    end
    object OOTableIsOrder: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'IsOrder'
      Calculated = True
    end
  end
  object User_Database: TDBISAMDatabase
    EngineVersion = '4.25 Build 5'
    DatabaseName = 'User_DATA'
    Directory = 'E:\Project\service\ServiceAutoUpdate\_out'
    KeepTablesOpen = False
    SessionName = 'Default'
    Left = 80
    Top = 8
  end
  object TiresCarMake: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'mark_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'mark'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'TiresCarMakeDBISA1'
        Fields = 'mark_id'
        Options = [ixPrimary, ixUnique]
        Compression = icFull
      end>
    IndexFieldNames = 'mark_id'
    TableName = '043'
    StoreDefs = True
    Left = 675
    Top = 735
    object TiresCarMakemark_id: TIntegerField
      FieldName = 'mark_id'
      Origin = '043.mark_id'
    end
    object TiresCarMakemark: TStringField
      FieldName = 'mark'
      Origin = '043.mark'
      Size = 100
    end
  end
  object TiresCarModel: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'model_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'model'
        DataType = ftString
        Size = 255
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'mark_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'TiresCarModelDBISA1'
        Fields = 'model_id'
        Options = [ixPrimary, ixUnique]
        Compression = icFull
      end>
    IndexFieldNames = 'model_id'
    TableName = '044'
    StoreDefs = True
    Left = 745
    Top = 735
    object TiresCarModelmodel_id: TIntegerField
      FieldName = 'model_id'
      Origin = '044.model_id'
    end
    object TiresCarModelmodel: TStringField
      FieldName = 'model'
      Origin = '044.model'
      Size = 255
    end
    object TiresCarModelmark_id: TIntegerField
      FieldName = 'mark_id'
      Origin = '044.mark_id'
    end
  end
  object TiresCarEngine: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'engine_id'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Engine'
        DataType = ftString
        Size = 255
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'model_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'TiresCarEngineDBISA1'
        Fields = 'engine_id'
        Options = [ixPrimary, ixUnique]
        Compression = icFull
      end>
    IndexFieldNames = 'engine_id'
    TableName = '045'
    StoreDefs = True
    Left = 675
    Top = 785
    object TiresCarEngineengine_id: TSmallintField
      FieldName = 'engine_id'
      Origin = '045.engine_id'
    end
    object TiresCarEngineEngine: TStringField
      FieldName = 'Engine'
      Origin = '045.Engine'
      Size = 255
    end
    object TiresCarEnginemodel_id: TIntegerField
      FieldName = 'model_id'
      Origin = '045.model_id'
    end
  end
  object TiresDimensions: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'engine_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'dimensions'
        DataType = ftString
        Size = 255
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'unique'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'TiresDimensionsDBISA1'
        Fields = 'id'
        Options = [ixPrimary, ixUnique]
        Compression = icFull
      end>
    IndexFieldNames = 'id'
    TableName = '046'
    StoreDefs = True
    Left = 745
    Top = 785
    object TiresDimensionsid: TIntegerField
      FieldName = 'id'
      Origin = '046.id'
    end
    object TiresDimensionsengine_id: TIntegerField
      FieldName = 'engine_id'
      Origin = '046.engine_id'
    end
    object TiresDimensionsdimensions: TStringField
      FieldName = 'dimensions'
      Origin = '046.dimensions'
      Size = 255
    end
    object TiresDimensionsunique: TSmallintField
      FieldName = 'unique'
      Origin = '046.unique'
    end
  end
  object DS_TiresCarMake: TDataSource
    DataSet = TiresCarMake
    Left = 675
    Top = 840
  end
  object DS_TiresCarModel: TDataSource
    DataSet = TiresCarModel
    Left = 745
    Top = 840
  end
  object DS_TiresCarEngine: TDataSource
    DataSet = TiresCarEngine
    Left = 675
    Top = 890
  end
  object DS_TiresDimensions: TDataSource
    DataSet = TiresDimensions
    Left = 745
    Top = 890
  end
  object DeliveryAddressTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Descr'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Addres'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cli_Id'
        DataType = ftString
        Size = 15
        Description = 'Cli_Id'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Addres_Id'
        DataType = ftString
        Size = 20
        Description = 'Addres_Id'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'DeliveryAddressTableDBISA1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end>
    TableName = '047'
    StoreDefs = True
    Left = 490
    Top = 1115
    object DeliveryAddressTableID: TAutoIncField
      FieldName = 'ID'
    end
    object DeliveryAddressTableAddres_Id: TStringField
      FieldName = 'Addres_Id'
    end
    object DeliveryAddressTableDescr: TStringField
      FieldName = 'Descr'
      Size = 100
    end
    object DeliveryAddressTableAddres: TStringField
      FieldName = 'Addres'
      Size = 100
    end
    object DeliveryAddressTablecli_id: TStringField
      FieldName = 'cli_id'
      Size = 15
    end
  end
  object ContractsCliTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    FilterOptions = [foCaseInsensitive]
    OnCalcFields = ContractsCliTableCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Contract_Id'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ContractDescr'
        DataType = ftString
        Size = 128
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Group'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Currency'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Method_Id'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'MethodDescr'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Payment_id'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PaymentDescr'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PriceList_id'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiscountCliGroup'
        DataType = ftString
        Size = 10
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiscountCliGroupDescr'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'LegalPerson'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Addres_Id'
        DataType = ftString
        Size = 20
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'PriceListDescr'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cli_id'
        DataType = ftString
        Size = 15
        Description = 'Cli_id'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'IS_MULTICURR'
        DataType = ftBoolean
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'RegionCode'
        DataType = ftString
        Size = 5
        Description = 'RegionCode'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ContractsCliTableDBISA1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'CLI'
        Fields = 'CLI_ID'
        Compression = icNone
      end>
    TableName = '048'
    StoreDefs = True
    Left = 600
    Top = 1100
    object ContractsCliTableID: TAutoIncField
      FieldName = 'ID'
    end
    object ContractsCliTableContract_Id: TStringField
      DisplayWidth = 9
      FieldName = 'Contract_Id'
      Origin = '048.Contract_Id'
      Required = True
    end
    object ContractsCliTableContractDescr: TStringField
      DisplayWidth = 100
      FieldName = 'ContractDescr'
      Origin = '048.ContractDescr'
      Size = 128
    end
    object ContractsCliTableGroup: TStringField
      DisplayWidth = 50
      FieldName = 'Group'
      Origin = '048.Group'
      Size = 10
    end
    object ContractsCliTableCurrency: TStringField
      DisplayWidth = 10
      FieldName = 'Currency'
      Origin = '048.Currency'
      Size = 10
    end
    object ContractsCliTableMethod_Id: TStringField
      DisplayWidth = 10
      FieldName = 'Method_Id'
      Origin = '048.Method_Id'
      Size = 10
    end
    object ContractsCliTableMethodDescr: TStringField
      DisplayWidth = 100
      FieldName = 'MethodDescr'
      Origin = '048.MethodDescr'
      Size = 64
    end
    object ContractsCliTablePayment_id: TStringField
      DisplayWidth = 10
      FieldName = 'Payment_id'
      Origin = '048.Payment_id'
      Size = 10
    end
    object ContractsCliTablePaymentDescr: TStringField
      DisplayWidth = 100
      FieldName = 'PaymentDescr'
      Origin = '048.PaymentDescr'
      Size = 64
    end
    object ContractsCliTablePriceList_id: TStringField
      DisplayWidth = 10
      FieldName = 'PriceList_id'
      Origin = '048.PriceList_id'
      Size = 10
    end
    object ContractsCliTableDiscountCliGroup: TStringField
      DisplayWidth = 50
      FieldName = 'DiscountCliGroup'
      Origin = '048.DiscountCliGroup'
      Size = 10
    end
    object ContractsCliTableDiscountCliGroupDescr: TStringField
      DisplayWidth = 10
      FieldName = 'DiscountCliGroupDescr'
      Origin = '048.DiscountCliGroupDescr'
      Size = 64
    end
    object ContractsCliTableLegalPerson: TStringField
      DisplayWidth = 100
      FieldName = 'LegalPerson'
      Origin = '048.LegalPerson'
      Size = 64
    end
    object ContractsCliTableAddres_Id: TStringField
      FieldName = 'Addres_Id'
    end
    object ContractsCliTablecli_id: TStringField
      FieldName = 'cli_id'
      Size = 15
    end
    object ContractsCliTablePriceListDescr: TStringField
      DisplayWidth = 100
      FieldName = 'PriceListDescr'
      Origin = '048.PriceListDescr'
      Size = 64
    end
    object ContractsCliTableIS_MULTICURR: TBooleanField
      FieldName = 'IS_MULTICURR'
    end
    object ContractsCliTableRegionCode: TStringField
      FieldName = 'RegionCode'
      Size = 3
    end
  end
  object DiscountCliTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Group_Id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Subgroup_Id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Brand_Id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'GroupDiscountCli'
        DataType = ftString
        Size = 100
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Discount'
        DataType = ftFloat
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cli_Id'
        DataType = ftInteger
        Description = 'Cli_Id'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'DiscountCliTableDBISA1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'CLI'
        Fields = 'CLI_ID;GROUP_ID;SUBGROUP_ID;BRAND_ID'
        Compression = icNone
      end>
    TableName = '049'
    StoreDefs = True
    Left = 715
    Top = 1115
    object DiscountCliTableID: TAutoIncField
      FieldName = 'ID'
    end
    object DiscountCliTableGroup_Id: TIntegerField
      FieldName = 'Group_Id'
    end
    object DiscountCliTableSubgroup_Id: TIntegerField
      FieldName = 'Subgroup_Id'
    end
    object DiscountCliTableBrand_Id: TIntegerField
      FieldName = 'Brand_Id'
    end
    object DiscountCliTableGroupDiscountCli: TStringField
      FieldName = 'GroupDiscountCli'
      Size = 100
    end
    object DiscountCliTableDiscount: TFloatField
      FieldName = 'Discount'
    end
    object DiscountCliTableCli_Id: TIntegerField
      FieldName = 'Cli_Id'
    end
  end
  object DS_Addres: TDataSource
    DataSet = DeliveryAddressTable
    Left = 490
    Top = 1165
  end
  object DS_Contracts: TDataSource
    DataSet = ContractsCliTable
    Left = 600
    Top = 1158
  end
  object DataSource2: TDataSource
    Left = 765
    Top = 1045
  end
  object DS_Discounts: TDataSource
    DataSet = DiscountCliTable
    Left = 690
    Top = 1163
  end
  object AutoMakerTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        Description = 'ID'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AutoMaker'
        DataType = ftString
        Size = 50
        Description = 'AutoMaker'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'AutoMaker'
        Fields = 'AutoMaker'
        Compression = icNone
      end>
    TableName = '101'
    StoreDefs = True
    Left = 570
    Top = 590
    object AutoMakerTableID: TAutoIncField
      FieldName = 'ID'
    end
    object AutoMakerTableAutoMaker: TStringField
      FieldName = 'AutoMaker'
      FixedChar = True
      Size = 50
    end
  end
  object AnalogIDTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    AfterRefresh = AnalogIDTableAfterRefresh
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'AnalogIDTableDBISA1'
        Fields = 'RecordID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Cat_id'
        Fields = 'Cat_id'
        Compression = icNone
      end
      item
        Name = 'Gen_An_id'
        Fields = 'Gen_An_id'
        Compression = icNone
      end>
    IndexFieldNames = 'Cat_id'
    MasterFields = 'cat_id'
    MasterSource = CatalogDataSource
    TableName = '007_2'
    StoreDefs = True
    Left = 695
    Top = 450
    object AnalogIDTableGen_An_id: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = '007_2.Gen_An_id'
    end
    object AnalogIDTableCat_id: TIntegerField
      FieldName = 'Cat_id'
      Origin = '007_2.Cat_id'
    end
  end
  object AnalogMainTable_1: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Locked = 0'
    Filtered = True
    OnCalcFields = AnalogMainTable_1CalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        Description = 'Gen_An_id'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_code'
        DataType = ftString
        Size = 50
        Description = 'An_code'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_brand'
        DataType = ftString
        Size = 50
        Description = 'An_brand'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_id'
        DataType = ftInteger
        Description = 'An_id'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Locked'
        DataType = ftInteger
        Description = 'Locked'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_ShortCode'
        DataType = ftString
        Size = 50
        Description = 'An_ShortCode'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Gen_An_id'
        Fields = 'Gen_An_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'An_ShortCode'
        Fields = 'An_ShortCode'
        Compression = icNone
      end>
    TableName = '007_1m'
    StoreDefs = True
    Left = 695
    Top = 500
    object AnalogMainTable_1Gen_An_id: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = '007_1m.Gen_An_id'
    end
    object AnalogMainTable_1An_code: TStringField
      FieldName = 'An_code'
      Origin = '007_1m.An_code'
      Size = 50
    end
    object AnalogMainTable_1An_brand: TStringField
      FieldName = 'An_brand'
      Origin = '007_1m.An_brand'
      Size = 50
    end
    object AnalogMainTable_1An_id: TIntegerField
      FieldName = 'An_id'
      Origin = '007_1m.An_id'
    end
    object AnalogMainTable_1Description: TStringField
      FieldKind = fkLookup
      FieldName = 'Description'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Description'
      KeyFields = 'An_id'
      Size = 150
      Lookup = True
    end
    object AnalogMainTable_1Price: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      currency = False
      Lookup = True
    end
    object AnalogMainTable_1Price_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object AnalogMainTable_1An_group_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_group_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_1An_subgroup_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_subgroup_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_1Quantity: TStringField
      FieldKind = fkLookup
      FieldName = 'Quantity'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 10
      Lookup = True
    end
    object AnalogMainTable_1An_sale: TStringField
      FieldKind = fkLookup
      FieldName = 'An_sale'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogMainTable_1An_new: TStringField
      FieldKind = fkLookup
      FieldName = 'An_new'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'New'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogMainTable_1An_usa: TStringField
      FieldKind = fkLookup
      FieldName = 'An_usa'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Usa'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogMainTable_1Sale: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sale'
      Size = 1
      Calculated = True
    end
    object AnalogMainTable_1New: TStringField
      FieldKind = fkCalculated
      FieldName = 'New'
      Size = 1
      Calculated = True
    end
    object AnalogMainTable_1Name: TStringField
      FieldKind = fkLookup
      FieldName = 'Name'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Name'
      KeyFields = 'An_id'
      Size = 100
      Lookup = True
    end
    object AnalogMainTable_1Name_Descr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 350
      Calculated = True
    end
    object AnalogMainTable_1An_Brand_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_Brand_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_1Mult: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Mult'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Mult'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_1Price_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object AnalogMainTable_1OrdQuantity: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantity'
      Calculated = True
    end
    object AnalogMainTable_1OrdQuantityStr: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 10
      Calculated = True
    end
    object AnalogMainTable_1Price_pro: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object AnalogMainTable_1Usa: TStringField
      FieldKind = fkCalculated
      FieldName = 'Usa'
      Size = 1
      Calculated = True
    end
    object AnalogMainTable_1saleQCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogMainTable_1SaleQ: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object AnalogMainTable_1PriceItog: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object AnalogMainTable_1PriceQuant: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_1Locked: TIntegerField
      FieldName = 'Locked'
      Origin = '007_1m.Locked'
    end
    object AnalogMainTable_1An_ShortCode: TStringField
      FieldName = 'An_ShortCode'
      Origin = '007_1m.An_ShortCode'
      Size = 50
    end
    object AnalogMainTable_1An_brand_repl: TStringField
      FieldKind = fkCalculated
      FieldName = 'An_brand_repl'
      Size = 100
      Calculated = True
    end
    object AnalogMainTable_1QuantLatest: TIntegerField
      FieldKind = fkLookup
      FieldName = 'QuantLatest'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Latest'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_1OrderOnly: TBooleanField
      FieldKind = fkLookup
      FieldName = 'OrderOnly'
      LookupDataSet = OOTable
      LookupKeyFields = 'CAT_ID'
      LookupResultField = 'IsOrder'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_1fUsingOptRf: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'fUsingOptRf'
      Calculated = True
    end
    object AnalogMainTable_1SaleQOptRFCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'SaleQOptRFCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'SaleOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_1PriceQuantOptRF: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuantOptRF'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'PriceOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
  end
  object AnalogMainTable_2: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Locked = 0'
    Filtered = True
    OnCalcFields = AnalogMainTable_2CalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Locked'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Gen_An_id'
        Fields = 'Gen_An_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'An_ShortCode'
        Fields = 'An_ShortCode'
        Compression = icNone
      end>
    TableName = '007_2m'
    StoreDefs = True
    Left = 695
    Top = 550
    object IntegerField4: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = '007_2m.Gen_An_id'
    end
    object StringField8: TStringField
      FieldName = 'An_code'
      Origin = '007_2m.An_code'
      Size = 50
    end
    object StringField10: TStringField
      FieldName = 'An_brand'
      Origin = '007_2m.An_brand'
      Size = 50
    end
    object IntegerField5: TIntegerField
      FieldName = 'An_id'
      Origin = '007_2m.An_id'
    end
    object StringField11: TStringField
      FieldKind = fkLookup
      FieldName = 'Description'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Description'
      KeyFields = 'An_id'
      Size = 150
      Lookup = True
    end
    object CurrencyField1: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      currency = False
      Lookup = True
    end
    object CurrencyField2: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object IntegerField6: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_group_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField7: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_subgroup_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object StringField12: TStringField
      FieldKind = fkLookup
      FieldName = 'Quantity'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 10
      Lookup = True
    end
    object StringField13: TStringField
      FieldKind = fkLookup
      FieldName = 'An_sale'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField14: TStringField
      FieldKind = fkLookup
      FieldName = 'An_new'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'New'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField15: TStringField
      FieldKind = fkLookup
      FieldName = 'An_usa'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Usa'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField16: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sale'
      Size = 1
      Calculated = True
    end
    object StringField17: TStringField
      FieldKind = fkCalculated
      FieldName = 'New'
      Size = 1
      Calculated = True
    end
    object StringField18: TStringField
      FieldKind = fkLookup
      FieldName = 'Name'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Name'
      KeyFields = 'An_id'
      Size = 100
      Lookup = True
    end
    object StringField19: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 350
      Calculated = True
    end
    object IntegerField8: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_Brand_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField9: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Mult'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Mult'
      KeyFields = 'An_id'
      Lookup = True
    end
    object CurrencyField3: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object FloatField1: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantity'
      Calculated = True
    end
    object StringField20: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 10
      Calculated = True
    end
    object CurrencyField4: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object StringField21: TStringField
      FieldKind = fkCalculated
      FieldName = 'Usa'
      Size = 1
      Calculated = True
    end
    object StringField22: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField23: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object CurrencyField5: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object CurrencyField6: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField10: TIntegerField
      FieldName = 'Locked'
      Origin = '007_2m.Locked'
    end
    object StringField24: TStringField
      FieldName = 'An_ShortCode'
      Origin = '007_2m.An_ShortCode'
      Size = 50
    end
    object StringField25: TStringField
      FieldKind = fkCalculated
      FieldName = 'An_brand_repl'
      Size = 100
      Calculated = True
    end
    object IntegerField11: TIntegerField
      FieldKind = fkLookup
      FieldName = 'QuantLatest'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Latest'
      KeyFields = 'An_id'
      Lookup = True
    end
    object BooleanField1: TBooleanField
      FieldKind = fkLookup
      FieldName = 'OrderOnly'
      LookupDataSet = OOTable
      LookupKeyFields = 'CAT_ID'
      LookupResultField = 'IsOrder'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_2fUsingOptRf: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'fUsingOptRf'
      Calculated = True
    end
    object AnalogMainTable_2SaleQOptRFCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'SaleQOptRFCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'SaleOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_2PriceQuantOptRF: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuantOptRF'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'PriceOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
  end
  object AnalogMainTable_3: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Locked = 0'
    Filtered = True
    OnCalcFields = AnalogMainTable_3CalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Locked'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Gen_An_id'
        Fields = 'Gen_An_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'An_ShortCode'
        Fields = 'An_ShortCode'
        Compression = icNone
      end>
    TableName = '007_3m'
    StoreDefs = True
    Left = 690
    Top = 610
    object IntegerField12: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = '007_3m.Gen_An_id'
    end
    object StringField26: TStringField
      FieldName = 'An_code'
      Origin = '007_3m.An_code'
      Size = 50
    end
    object StringField27: TStringField
      FieldName = 'An_brand'
      Origin = '007_3m.An_brand'
      Size = 50
    end
    object IntegerField13: TIntegerField
      FieldName = 'An_id'
      Origin = '007_3m.An_id'
    end
    object StringField28: TStringField
      FieldKind = fkLookup
      FieldName = 'Description'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Description'
      KeyFields = 'An_id'
      Size = 150
      Lookup = True
    end
    object CurrencyField7: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      currency = False
      Lookup = True
    end
    object CurrencyField8: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object IntegerField14: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_group_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField15: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_subgroup_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object StringField29: TStringField
      FieldKind = fkLookup
      FieldName = 'Quantity'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 10
      Lookup = True
    end
    object StringField30: TStringField
      FieldKind = fkLookup
      FieldName = 'An_sale'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField31: TStringField
      FieldKind = fkLookup
      FieldName = 'An_new'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'New'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField32: TStringField
      FieldKind = fkLookup
      FieldName = 'An_usa'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Usa'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField33: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sale'
      Size = 1
      Calculated = True
    end
    object StringField34: TStringField
      FieldKind = fkCalculated
      FieldName = 'New'
      Size = 1
      Calculated = True
    end
    object StringField35: TStringField
      FieldKind = fkLookup
      FieldName = 'Name'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Name'
      KeyFields = 'An_id'
      Size = 100
      Lookup = True
    end
    object StringField36: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 350
      Calculated = True
    end
    object IntegerField16: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_Brand_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField17: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Mult'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Mult'
      KeyFields = 'An_id'
      Lookup = True
    end
    object CurrencyField9: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object FloatField2: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantity'
      Calculated = True
    end
    object StringField37: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 10
      Calculated = True
    end
    object CurrencyField10: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object StringField38: TStringField
      FieldKind = fkCalculated
      FieldName = 'Usa'
      Size = 1
      Calculated = True
    end
    object StringField39: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField40: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object CurrencyField11: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object CurrencyField12: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField18: TIntegerField
      FieldName = 'Locked'
      Origin = '007_3m.Locked'
    end
    object StringField41: TStringField
      FieldName = 'An_ShortCode'
      Origin = '007_3m.An_ShortCode'
      Size = 50
    end
    object StringField42: TStringField
      FieldKind = fkCalculated
      FieldName = 'An_brand_repl'
      Size = 100
      Calculated = True
    end
    object IntegerField19: TIntegerField
      FieldKind = fkLookup
      FieldName = 'QuantLatest'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Latest'
      KeyFields = 'An_id'
      Lookup = True
    end
    object BooleanField2: TBooleanField
      FieldKind = fkLookup
      FieldName = 'OrderOnly'
      LookupDataSet = OOTable
      LookupKeyFields = 'CAT_ID'
      LookupResultField = 'IsOrder'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_3fUsingOptRf: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'fUsingOptRf'
      Calculated = True
    end
    object AnalogMainTable_3SaleQOptRFCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'SaleQOptRFCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'SaleOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_3PriceQuantOptRF: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuantOptRF'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'PriceOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
  end
  object AnalogMainTable_4: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Locked = 0'
    Filtered = True
    OnCalcFields = AnalogMainTable_4CalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Locked'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Gen_An_id'
        Fields = 'Gen_An_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'An_ShortCode'
        Fields = 'An_ShortCode'
        Compression = icNone
      end>
    TableName = '007_4m'
    StoreDefs = True
    Left = 690
    Top = 665
    object IntegerField20: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = '007_4m.Gen_An_id'
    end
    object StringField43: TStringField
      FieldName = 'An_code'
      Origin = '007_4m.An_code'
      Size = 50
    end
    object StringField44: TStringField
      FieldName = 'An_brand'
      Origin = '007_4m.An_brand'
      Size = 50
    end
    object IntegerField21: TIntegerField
      FieldName = 'An_id'
      Origin = '007_4m.An_id'
    end
    object StringField45: TStringField
      FieldKind = fkLookup
      FieldName = 'Description'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Description'
      KeyFields = 'An_id'
      Size = 150
      Lookup = True
    end
    object CurrencyField13: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      currency = False
      Lookup = True
    end
    object CurrencyField14: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object IntegerField22: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_group_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField23: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_subgroup_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object StringField46: TStringField
      FieldKind = fkLookup
      FieldName = 'Quantity'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 10
      Lookup = True
    end
    object StringField47: TStringField
      FieldKind = fkLookup
      FieldName = 'An_sale'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField48: TStringField
      FieldKind = fkLookup
      FieldName = 'An_new'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'New'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField49: TStringField
      FieldKind = fkLookup
      FieldName = 'An_usa'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Usa'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField50: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sale'
      Size = 1
      Calculated = True
    end
    object StringField51: TStringField
      FieldKind = fkCalculated
      FieldName = 'New'
      Size = 1
      Calculated = True
    end
    object StringField52: TStringField
      FieldKind = fkLookup
      FieldName = 'Name'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Name'
      KeyFields = 'An_id'
      Size = 100
      Lookup = True
    end
    object StringField53: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 350
      Calculated = True
    end
    object IntegerField24: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_Brand_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField25: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Mult'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Mult'
      KeyFields = 'An_id'
      Lookup = True
    end
    object CurrencyField15: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object FloatField3: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantity'
      Calculated = True
    end
    object StringField54: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 10
      Calculated = True
    end
    object CurrencyField16: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object StringField55: TStringField
      FieldKind = fkCalculated
      FieldName = 'Usa'
      Size = 1
      Calculated = True
    end
    object StringField56: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField57: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object CurrencyField17: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object CurrencyField18: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField26: TIntegerField
      FieldName = 'Locked'
      Origin = '007_4m.Locked'
    end
    object StringField58: TStringField
      FieldName = 'An_ShortCode'
      Origin = '007_4m.An_ShortCode'
      Size = 50
    end
    object StringField59: TStringField
      FieldKind = fkCalculated
      FieldName = 'An_brand_repl'
      Size = 100
      Calculated = True
    end
    object IntegerField27: TIntegerField
      FieldKind = fkLookup
      FieldName = 'QuantLatest'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Latest'
      KeyFields = 'An_id'
      Lookup = True
    end
    object BooleanField3: TBooleanField
      FieldKind = fkLookup
      FieldName = 'OrderOnly'
      LookupDataSet = OOTable
      LookupKeyFields = 'CAT_ID'
      LookupResultField = 'IsOrder'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_4fUsingOptRf: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'fUsingOptRf'
      Calculated = True
    end
    object AnalogMainTable_4SaleQOptRFCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'SaleQOptRFCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'SaleOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_4PriceQuantOptRF: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuantOptRF'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'PriceOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
  end
  object AnalogMainTable_5: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Locked = 0'
    Filtered = True
    OnCalcFields = AnalogMainTable_5CalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Locked'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Gen_An_id'
        Fields = 'Gen_An_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'An_ShortCode'
        Fields = 'An_ShortCode'
        Compression = icNone
      end>
    TableName = '007_5m'
    StoreDefs = True
    Left = 785
    Top = 660
    object IntegerField28: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = '007_5m.Gen_An_id'
    end
    object StringField60: TStringField
      FieldName = 'An_code'
      Origin = '007_5m.An_code'
      Size = 50
    end
    object StringField61: TStringField
      FieldName = 'An_brand'
      Origin = '007_5m.An_brand'
      Size = 50
    end
    object IntegerField29: TIntegerField
      FieldName = 'An_id'
      Origin = '007_5m.An_id'
    end
    object StringField62: TStringField
      FieldKind = fkLookup
      FieldName = 'Description'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Description'
      KeyFields = 'An_id'
      Size = 150
      Lookup = True
    end
    object CurrencyField19: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      currency = False
      Lookup = True
    end
    object CurrencyField20: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object IntegerField30: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_group_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField31: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_subgroup_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object StringField63: TStringField
      FieldKind = fkLookup
      FieldName = 'Quantity'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 10
      Lookup = True
    end
    object StringField64: TStringField
      FieldKind = fkLookup
      FieldName = 'An_sale'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField65: TStringField
      FieldKind = fkLookup
      FieldName = 'An_new'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'New'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField66: TStringField
      FieldKind = fkLookup
      FieldName = 'An_usa'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Usa'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField67: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sale'
      Size = 1
      Calculated = True
    end
    object StringField68: TStringField
      FieldKind = fkCalculated
      FieldName = 'New'
      Size = 1
      Calculated = True
    end
    object StringField69: TStringField
      FieldKind = fkLookup
      FieldName = 'Name'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Name'
      KeyFields = 'An_id'
      Size = 100
      Lookup = True
    end
    object StringField70: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 350
      Calculated = True
    end
    object IntegerField32: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_Brand_id'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField33: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Mult'
      LookupDataSet = XCatTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Mult'
      KeyFields = 'An_id'
      Lookup = True
    end
    object CurrencyField21: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object FloatField4: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantity'
      Calculated = True
    end
    object StringField71: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 10
      Calculated = True
    end
    object CurrencyField22: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object StringField72: TStringField
      FieldKind = fkCalculated
      FieldName = 'Usa'
      Size = 1
      Calculated = True
    end
    object StringField73: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object StringField74: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object CurrencyField23: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object CurrencyField24: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      Lookup = True
    end
    object IntegerField34: TIntegerField
      FieldName = 'Locked'
      Origin = '007_5m.Locked'
    end
    object StringField75: TStringField
      FieldName = 'An_ShortCode'
      Origin = '007_5m.An_ShortCode'
      Size = 50
    end
    object StringField76: TStringField
      FieldKind = fkCalculated
      FieldName = 'An_brand_repl'
      Size = 100
      Calculated = True
    end
    object IntegerField35: TIntegerField
      FieldKind = fkLookup
      FieldName = 'QuantLatest'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Latest'
      KeyFields = 'An_id'
      Lookup = True
    end
    object BooleanField4: TBooleanField
      FieldKind = fkLookup
      FieldName = 'OrderOnly'
      LookupDataSet = OOTable
      LookupKeyFields = 'CAT_ID'
      LookupResultField = 'IsOrder'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_5fUsingOptRf: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'fUsingOptRf'
      Calculated = True
    end
    object AnalogMainTable_5SaleQOptRFCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'SaleQOptRFCalc'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'SaleOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTable_5PriceQuantOptRF: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuantOptRF'
      LookupDataSet = QuantTable
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'PriceOptRF'
      KeyFields = 'An_id'
      Lookup = True
    end
  end
  object OEDescrSearchTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'SIM'
    TableName = '016_1m'
    Left = 207
    Top = 1393
    object OEDescrSearchTablegen_oe_id: TIntegerField
      FieldName = 'Gen_oe_id'
    end
    object StringField77: TStringField
      FieldName = 'Code'
      Size = 25
    end
    object StringField79: TStringField
      FieldName = 'ShortOE'
      Size = 50
    end
    object SmallintField1: TSmallintField
      FieldName = 'SIMB'
    end
  end
  object OEIDTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'gen_oe_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'DBISAMTable1DBISA7'
        Fields = 'RecordID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Cat_id'
        Fields = 'Cat_id'
        Compression = icNone
      end
      item
        Name = 'Gen_oe_id'
        Fields = 'Gen_oe_id'
        Compression = icNone
      end>
    IndexFieldNames = 'Cat_id'
    MasterFields = 'Cat_id'
    MasterSource = CatalogDataSource
    TableName = '016_2'
    StoreDefs = True
    Left = 59
    Top = 1338
    object OEIDTableGen_oe_id: TIntegerField
      FieldName = 'Gen_oe_id'
    end
    object IntegerField36: TIntegerField
      FieldName = 'Cat_id'
    end
  end
  object OEDescrTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_oe_id'
        DataType = ftInteger
        Description = 'Gen_oe_id'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Code'
        DataType = ftString
        Size = 50
        Description = 'Code'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ShortOE'
        DataType = ftString
        Size = 50
        Description = 'ShortOE'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'SIMB'
        DataType = ftSmallint
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'Gen_oe_id'
        Fields = 'Gen_oe_id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'ShortOE'
        Fields = 'ShortOE'
        Compression = icNone
      end
      item
        Name = 'SIM'
        Fields = 'SIMB'
        Compression = icNone
      end>
    IndexFieldNames = 'Gen_oe_id'
    MasterFields = 'Gen_oe_id'
    MasterSource = DS_OE
    TableName = '016_1m'
    StoreDefs = True
    Left = 57
    Top = 1388
    object IntegerField37: TIntegerField
      FieldName = 'Gen_oe_id'
    end
    object StringField78: TStringField
      FieldName = 'Code'
      Size = 25
    end
    object StringField80: TStringField
      FieldName = 'ShortOE'
      Size = 50
    end
    object SmallintField2: TSmallintField
      FieldName = 'SIMB'
    end
  end
  object OEIDSearchTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexFieldNames = 'Gen_oe_id'
    MasterFields = 'Gen_oe_id'
    MasterSource = DS_OESearch
    TableName = '016_2'
    StoreDefs = True
    Left = 209
    Top = 1338
    object IntegerField38: TIntegerField
      FieldName = 'Gen_oe_id'
    end
    object IntegerField39: TIntegerField
      FieldName = 'Cat_id'
    end
  end
  object DS_OESearch: TDataSource
    DataSet = OEDescrSearchTable
    Left = 275
    Top = 1360
  end
  object DS_OE: TDataSource
    DataSet = OEIDTable
    Left = 115
    Top = 1360
  end
  object mapBrand4ImportOrder: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'serviceBrand'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'replBrand'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'ID'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'serviceBrand'
        Fields = 'serviceBrand'
        Compression = icNone
      end>
    TableName = '102'
    StoreDefs = True
    Left = 735
    Top = 1345
    object mapBrand4ImportOrderID: TAutoIncField
      FieldName = 'ID'
    end
    object mapBrand4ImportOrderserviceBrand: TStringField
      FieldName = 'serviceBrand'
      Size = 64
    end
    object mapBrand4ImportOrderreplBrand: TStringField
      FieldName = 'replBrand'
      Size = 64
    end
  end
  object DS_mapBrand4ImportOrder: TDataSource
    DataSet = mapBrand4ImportOrder
    Left = 735
    Top = 1400
  end
  object MemAnalogTest: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    AfterRefresh = AnalogIDTableAfterRefresh
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'AnalogIDTableDBISA1'
        Fields = 'RecordID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Cat_id'
        Fields = 'Cat_id'
        Compression = icNone
      end
      item
        Name = 'Gen_An_id'
        Fields = 'Gen_An_id'
        Compression = icNone
      end>
    TableName = 'MemAnalogTest'
    StoreDefs = True
    Left = 755
    Top = 440
    object IntegerField40: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = 'MemAnalogTest.Gen_An_id'
    end
    object IntegerField41: TIntegerField
      FieldName = 'Cat_id'
      Origin = 'MemAnalogTest.Cat_id'
    end
  end
  object qrDiscount: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 265
    Top = 1205
  end
  object MarginTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'PricesGroup = 0'
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    IndexName = 'CLI_OLD'
    TableName = '038'
    StoreDefs = True
    Left = 596
    Top = 661
    object AutoIncField1: TAutoIncField
      FieldName = 'ID'
    end
    object StringField81: TStringField
      FieldName = 'CLI_ID'
      Size = 15
    end
    object IntegerField42: TIntegerField
      FieldName = 'GR_ID'
    end
    object IntegerField43: TIntegerField
      FieldName = 'SUBGR_ID'
    end
    object IntegerField44: TIntegerField
      FieldName = 'BRAND_ID'
    end
    object FloatField5: TFloatField
      FieldName = 'Discount'
    end
    object FloatField6: TFloatField
      FieldName = 'Margin'
    end
    object IntegerField45: TIntegerField
      FieldName = 'bDelete'
    end
    object BooleanField5: TBooleanField
      FieldName = 'UpdateDisc'
    end
    object MarginTablePricesGroup: TIntegerField
      FieldName = 'PricesGroup'
    end
  end
  object memRetDocTTNInfoTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'idxAddress'
        Fields = 'AdressId'
        Compression = icNone
      end>
    IndexName = 'idxAddress'
    TableName = 'memRetDocTTNInfoTable'
    StoreDefs = True
    Left = 592
    Top = 1344
    object memRetDocTTNInfoTableName: TStringField
      FieldName = 'Name'
      Size = 128
    end
    object memRetDocTTNInfoTableModel: TStringField
      FieldName = 'Model'
      Size = 64
    end
    object memRetDocTTNInfoTableStateNumber: TStringField
      FieldName = 'StateNumber'
      Size = 16
    end
    object memRetDocTTNInfoTableDriverName: TStringField
      FieldName = 'DriverName'
      Size = 64
    end
    object memRetDocTTNInfoTableAdress: TStringField
      FieldName = 'Adress'
      Size = 256
    end
    object memRetDocTTNInfoTableAdressId: TStringField
      FieldName = 'AdressId'
      Size = 3
    end
    object memRetDocTTNInfoTableNo: TStringField
      FieldName = 'No'
      Size = 16
    end
  end
  object DSmemRetDocTTNInfo: TDataSource
    DataSet = memRetDocTTNInfoTable
    Left = 592
    Top = 1400
  end
end
