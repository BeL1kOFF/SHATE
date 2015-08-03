object sFileTransferService: TsFileTransferService
  OldCreateOrder = False
  DisplayName = #1060#1072#1081#1083#1086#1074#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090
  ErrorSeverity = esIgnore
  OnContinue = ServiceContinue
  OnPause = ServicePause
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=FileTransfer;Data Source=svbyprissq8'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 32
    Top = 16
  end
end
