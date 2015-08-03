object ServiceDiscounts: TServiceDiscounts
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  AllowPause = False
  DisplayName = 'ShateM+ Discounts Service'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 283
  Width = 443
  object DBISAMEngine1: TDBISAMEngine
    Active = True
    EngineVersion = '4.25 Build 5'
    EngineType = etClient
    EngineSignature = 'DBISAM_SIG'
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
    Left = 30
    Top = 15
  end
  object memDiscounts: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'memDiscountsDBISA1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'LOOK'
        Fields = 'CLIENT_ID;CAT_CODE;FIX;PRICE_GROUP'
        Compression = icNone
      end>
    TableName = 'memDiscounts'
    StoreDefs = True
    Left = 30
    Top = 115
    object memDiscountsID: TAutoIncField
      FieldName = 'ID'
    end
    object memDiscountsCLIENT_ID: TStringField
      FieldName = 'CLIENT_ID'
      Size = 15
    end
    object memDiscountsCAT_CODE: TStringField
      FieldName = 'CAT_CODE'
      Size = 32
    end
    object memDiscountsDISCOUNT: TCurrencyField
      FieldName = 'DISCOUNT'
    end
    object memDiscountsUPDATED: TBooleanField
      FieldName = 'UPDATED'
    end
    object memDiscountsFOUND: TBooleanField
      FieldName = 'FOUND'
    end
    object memDiscountsNEW: TBooleanField
      FieldName = 'NEW'
    end
    object memDiscountsFIX: TIntegerField
      FieldName = 'FIX'
    end
    object memDiscountsPRICE_GROUP: TIntegerField
      FieldName = 'PRICE_GROUP'
    end
  end
  object memClients: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'memClientsDBISA1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'LOOK'
        Fields = 'CLIENT_ID'
        Compression = icNone
      end>
    TableName = 'memClients'
    StoreDefs = True
    Left = 30
    Top = 65
    object memClientsID: TAutoIncField
      FieldName = 'ID'
    end
    object memClientsCLIENT_ID: TStringField
      FieldName = 'CLIENT_ID'
      Size = 15
    end
    object memClientsPRIVATE_KEY: TStringField
      FieldName = 'PRIVATE_KEY'
    end
    object memClientsUPDATED: TBooleanField
      FieldName = 'UPDATED'
    end
    object memClientsFOUND: TBooleanField
      FieldName = 'FOUND'
    end
    object memClientsNEW: TBooleanField
      FieldName = 'NEW'
    end
  end
  object InsertCommand: TADOCommand
    Connection = defConnection
    Parameters = <>
    Left = 160
    Top = 115
  end
  object Zipper: TVCLZip
    OverwriteMode = Always
    KeepZipOpen = True
    PackLevel = 9
    Left = 325
    Top = 23
  end
  object Query: TADOQuery
    Connection = defConnection
    Parameters = <>
    Left = 160
    Top = 65
  end
  object defConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Admin;Persist Security Info=True;Us' +
      'er ID=Admin;Initial Catalog=CLIENT_INFO;Data Source=AMD'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 160
    Top = 15
  end
  object memImportDiscount: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    TableName = 'memImportDiscount'
    Left = 50
    Top = 190
    object memImportDiscountDISCOUNT: TCurrencyField
      FieldName = 'DISCOUNT'
    end
    object memImportDiscountGROUP: TIntegerField
      FieldName = 'GROUP'
    end
    object memImportDiscountSUBGROUP: TIntegerField
      FieldName = 'SUBGROUP'
    end
    object memImportDiscountBRAND: TIntegerField
      FieldName = 'BRAND'
    end
    object memImportDiscountFIX: TIntegerField
      FieldName = 'FIX'
    end
    object memImportDiscountGROUP_DIS: TIntegerField
      FieldName = 'GROUP_DIS'
    end
  end
end
