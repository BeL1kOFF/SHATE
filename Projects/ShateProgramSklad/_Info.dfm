object Info: TInfo
  Left = 0
  Top = 0
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
  ClientHeight = 531
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  DesignSize = (
    716
    531)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 499
    Width = 716
    Height = 32
    Align = alBottom
    ExplicitTop = 500
  end
  object Browser: TWebBrowser
    Left = 0
    Top = 0
    Width = 716
    Height = 499
    Align = alClient
    TabOrder = 0
    OnVisible = BrowserVisible
    ExplicitWidth = 713
    ExplicitHeight = 498
    ControlData = {
      4C000000004A0000933300000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object BitBtn1: TBitBtn
    Left = 636
    Top = 503
    Width = 76
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&'#1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object HideCheckBox: TDBCheckBox
    Left = 8
    Top = 507
    Width = 233
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1085#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    DataField = 'Hide_start_info'
    DataSource = Data.ParamDataSource
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
    Visible = False
  end
  object HideNewInProg: TDBCheckBox
    Left = 8
    Top = 507
    Width = 233
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1085#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    DataField = 'Hide_NewInProg'
    DataSource = Data.ParamDataSource
    TabOrder = 3
    ValueChecked = 'True'
    ValueUnchecked = 'False'
    Visible = False
  end
  object Button1: TButton
    Left = 527
    Top = 505
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    Visible = False
    OnClick = Button1Click
  end
  object JvFormStorage1: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'Info\'
    StoredValues = <>
    Left = 272
    Top = 168
  end
end
