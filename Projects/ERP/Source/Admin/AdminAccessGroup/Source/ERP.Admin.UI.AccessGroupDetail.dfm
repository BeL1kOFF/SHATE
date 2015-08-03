object frmAccessGroupDetail: TfrmAccessGroupDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1043#1088#1091#1087#1087#1099' '#1076#1086#1089#1090#1091#1087#1072
  ClientHeight = 272
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 299
    Height = 231
    Align = alClient
    TabOrder = 0
    object edtIdProfileGroup: TcxTextEdit
      Left = 24
      Top = 42
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 234
    end
    object edtName: TcxTextEdit
      Left = 24
      Top = 96
      TabOrder = 1
      Width = 234
    end
    object cxLabel1: TcxLabel
      Left = 24
      Top = 23
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088':'
      Transparent = True
    end
    object cxLabel3: TcxLabel
      Left = 24
      Top = 73
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      Transparent = True
    end
    object cxLabel4: TcxLabel
      Left = 24
      Top = 129
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      Transparent = True
    end
    object edtDescription: TcxTextEdit
      Left = 24
      Top = 152
      TabOrder = 5
      Width = 234
    end
    object chbEnabled: TcxCheckBox
      Left = 24
      Top = 190
      Caption = #1042#1082#1083#1102#1095#1077#1085#1072
      TabOrder = 6
      Width = 121
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 231
    Width = 299
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      299
      41)
    object btnCancel: TButton
      Left = 194
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 98
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 248
    Top = 128
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      OnExecute = acCancelExecute
    end
  end
end
