object frmAdminDataBaseDetail: TfrmAdminDataBaseDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1041#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 265
  ClientWidth = 575
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
    Width = 575
    Height = 224
    Align = alClient
    TabOrder = 0
    object chbEnabled: TcxCheckBox
      Left = 24
      Top = 182
      Caption = #1042#1082#1083#1102#1095#1077#1085#1072
      TabOrder = 0
      Width = 121
    end
    object edtIdDataBase: TcxTextEdit
      Left = 24
      Top = 82
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 234
    end
    object edtDataBase: TcxTextEdit
      Left = 24
      Top = 144
      TabOrder = 2
      Width = 234
    end
    object cmbServer: TcxComboBox
      Left = 24
      Top = 33
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 3
      Width = 234
    end
    object cxLabel1: TcxLabel
      Left = 24
      Top = 63
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088':'
      Transparent = True
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 14
      Caption = #1057#1077#1088#1074#1077#1088':'
      Transparent = True
    end
    object cxLabel3: TcxLabel
      Left = 24
      Top = 121
      Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093':'
      Transparent = True
    end
    object cxLabel4: TcxLabel
      Left = 296
      Top = 121
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      Transparent = True
    end
    object edtDataBaseName: TcxTextEdit
      Left = 296
      Top = 144
      TabOrder = 8
      Width = 234
    end
    object cxLabel5: TcxLabel
      Left = 296
      Top = 14
      Caption = #1064#1072#1073#1083#1086#1085':'
      Transparent = True
    end
    object cmbTemplate: TcxComboBox
      Left = 296
      Top = 33
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 10
      Width = 234
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 224
    Width = 575
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      575
      41)
    object btnCancel: TButton
      Left = 476
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 380
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 192
    Top = 176
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
    Left = 336
    Top = 88
  end
end
