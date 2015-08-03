object frmAdminProfileDetail: TfrmAdminProfileDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1092#1080#1083#1080
  ClientHeight = 323
  ClientWidth = 285
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
  object Panel1: TPanel
    Left = 0
    Top = 282
    Width = 285
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      285
      41)
    object btnCancel: TButton
      Left = 204
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnSave: TButton
      Left = 100
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 285
    Height = 282
    Align = alClient
    TabOrder = 0
    object editIdProfile: TcxTextEdit
      Left = 24
      Top = 94
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 234
    end
    object editName: TcxTextEdit
      Left = 24
      Top = 144
      TabOrder = 2
      Width = 234
    end
    object cxLabel1: TcxLabel
      Left = 24
      Top = 71
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088':'
      Transparent = True
    end
    object cxLabel3: TcxLabel
      Left = 24
      Top = 121
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      Transparent = True
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 14
      Caption = #1043#1088#1091#1087#1087#1072' '#1087#1088#1086#1092#1080#1083#1103':'
      Transparent = True
    end
    object chbEnabled: TcxCheckBox
      Left = 24
      Top = 224
      Caption = #1042#1082#1083#1102#1095#1077#1085
      TabOrder = 4
      Width = 121
    end
    object cmbProfilesGroups: TcxComboBox
      Left = 24
      Top = 37
      BeepOnEnter = False
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 0
      Width = 234
    end
    object editDescription: TcxTextEdit
      Left = 24
      Top = 194
      TabOrder = 3
      Width = 234
    end
    object cxLabel4: TcxLabel
      Left = 24
      Top = 171
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    end
  end
  object ActionList: TActionList
    Left = 136
    Top = 216
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
  object qrQuery: TFDQuery
    Left = 192
    Top = 216
  end
end
