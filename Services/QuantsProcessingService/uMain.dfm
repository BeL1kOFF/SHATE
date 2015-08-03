object ServiceQuantsProcessing: TServiceQuantsProcessing
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  AllowPause = False
  DisplayName = 'ShateM+ QUANTS processing service'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 257
  Width = 362
  object memCodesMap: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.24 Build 1'
    FieldDefs = <
      item
        Name = 'CodeNew'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'CodeOld'
        DataType = ftString
        Size = 64
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'memCodesMapDBISA1'
        Fields = 'RecordID'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'CodeNew'
        Fields = 'CodeNew'
        Compression = icNone
      end>
    TableName = 'MemMap'
    StoreDefs = True
    Left = 155
    Top = 85
    object memCodesMapCodeNew: TStringField
      FieldName = 'CodeNew'
      Origin = 'MemMap.CodeNew'
      Size = 64
    end
    object memCodesMapCodeOld: TStringField
      DisplayWidth = 64
      FieldName = 'CodeOld'
      Origin = 'MemMap.CodeOld'
      Size = 64
    end
  end
  object DBISAMEngine: TDBISAMEngine
    Active = False
    EngineVersion = '4.24 Build 1'
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
    Left = 155
    Top = 35
  end
end
