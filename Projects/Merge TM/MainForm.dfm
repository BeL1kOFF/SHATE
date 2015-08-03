object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #1042#1099#1088#1072#1074#1085#1080#1074#1072#1085#1080#1077' '#1079#1072#1087#1095#1072#1089#1090#1077#1081
  ClientHeight = 417
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 732
    Height = 88
    Align = alTop
    TabOrder = 0
    object lbConnect: TLabel
      Left = 32
      Top = 40
      Width = 82
      Height = 13
      Caption = #1053#1077#1090' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
    end
    object lbConnectRus: TLabel
      Left = 32
      Top = 59
      Width = 82
      Height = 13
      Caption = #1053#1077#1090' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
    end
    object btnConnect: TButton
      Left = 32
      Top = 9
      Width = 113
      Height = 25
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
      TabOrder = 0
      OnClick = btnConnectClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 368
    Width = 732
    Height = 49
    Align = alBottom
    TabOrder = 1
    object lbCount: TLabel
      Left = 384
      Top = 8
      Width = 32
      Height = 13
      Caption = #1042#1089#1077#1075#1086':'
    end
    object btnGo: TButton
      Left = 32
      Top = 14
      Width = 113
      Height = 25
      Action = acExec
      TabOrder = 0
    end
    object pbExecute: TProgressBar
      Left = 384
      Top = 24
      Width = 328
      Height = 17
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 88
    Width = 732
    Height = 280
    Align = alClient
    TabOrder = 2
    object Label1: TLabel
      Left = 32
      Top = 16
      Width = 61
      Height = 13
      Caption = #1043#1083#1072#1074#1085#1099#1081' '#1058#1052
    end
    object Label2: TLabel
      Left = 32
      Top = 62
      Width = 54
      Height = 13
      Caption = #1055#1088#1086#1095#1080#1077' '#1058#1052
    end
    object cbMainTm: TComboBox
      Left = 32
      Top = 35
      Width = 337
      Height = 22
      Style = csOwnerDrawFixed
      TabOrder = 0
    end
    object lbTm: TListBox
      Left = 32
      Top = 81
      Width = 337
      Height = 176
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
      OnDblClick = lbTmDblClick
    end
    object lbTmChecked: TListBox
      Left = 375
      Top = 81
      Width = 337
      Height = 176
      ItemHeight = 13
      Sorted = True
      TabOrder = 2
      OnDblClick = lbTmCheckedDblClick
    end
    object chbDoublePart: TCheckBox
      Left = 384
      Top = 37
      Width = 249
      Height = 17
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1091#1073#1083#1080' '#1087#1072#1088#1090#1086#1074' '#1074' '#1074#1099#1073#1088#1072#1085#1086#1084' '#1041#1088#1077#1085#1076#1077
      TabOrder = 3
    end
  end
  object ADOConnection: TADOConnection
    LoginPrompt = False
    Left = 32
    Top = 280
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 120
    Top = 288
  end
  object ActionList: TActionList
    Left = 232
    Top = 360
    object acExec: TAction
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
      OnExecute = acExecExecute
      OnUpdate = acExecUpdate
    end
  end
  object ADOConnectionRus: TADOConnection
    Left = 216
    Top = 169
  end
  object qrDeletePartRus: TADOQuery
    Connection = ADOConnectionRus
    Parameters = <>
    Left = 552
    Top = 257
  end
  object qrDeletePart: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 464
    Top = 248
  end
end
