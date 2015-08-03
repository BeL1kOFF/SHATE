object ShateUniversalExportService: TShateUniversalExportService
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'Shate-M '#1057#1083#1091#1078#1073#1072' '#1091#1085#1080#1074#1077#1088#1089#1072#1083#1100#1085#1086#1075#1086' '#1101#1082#1089#1087#1086#1088#1090#1072
  AfterInstall = ServiceAfterInstall
  BeforeUninstall = ServiceBeforeUninstall
  OnContinue = ServiceContinue
  OnPause = ServicePause
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
  object ADODataSet1: TADODataSet
    Parameters = <>
    Left = 32
    Top = 16
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1200000
    OnTimer = Timer1Timer
    Left = 176
    Top = 8
  end
  object IdSMTP1: TIdSMTP
    SASLMechanisms = <>
    Left = 176
    Top = 56
  end
end
