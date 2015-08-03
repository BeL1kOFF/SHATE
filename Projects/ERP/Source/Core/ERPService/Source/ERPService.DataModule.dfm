object ERPServer: TERPServer
  OldCreateOrder = False
  AllowPause = False
  DisplayName = #1057#1077#1088#1074#1080#1089' ERP'
  Password = '<evf;rf123'
  ServiceStartName = 'SHATE\TestServiceUser'
  AfterInstall = ServiceAfterInstall
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end
