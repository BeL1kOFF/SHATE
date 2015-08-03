object DM: TDM
  OldCreateOrder = False
  Height = 236
  Width = 248
  object DBISAMEngine: TDBISAMEngine
    Active = True
    EngineVersion = '4.24 Build 1'
    EngineType = etClient
    EngineSignature = 'DBISAM_SIG_IMP'
    Functions = <>
    LargeFileSupport = True
    FilterRecordCounts = True
    LockFileName = 'dbisam.lck'
    MaxTableDataBufferSize = 32768
    MaxTableDataBufferCount = 8192
    MaxTableIndexBufferSize = 65536
    MaxTableIndexBufferCount = 8192
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
    ServerConfigFileName = 'dbsrvr.scf'
    ServerConfigPassword = 'elevatesoft'
    ServerLicensedConnections = 65535
    Left = 25
    Top = 15
  end
  object Database: TDBISAMDatabase
    EngineVersion = '4.24 Build 1'
    DatabaseName = 'SERVICE'
    KeepTablesOpen = False
    SessionName = 'Default'
    Left = 20
    Top = 70
  end
  object DBITable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'SERVICE'
    EngineVersion = '4.24 Build 1'
    TableName = '003'
    Left = 115
    Top = 45
  end
end
