object frmAdminModuleDetail: TfrmAdminModuleDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1052#1086#1076#1091#1083#1080
  ClientHeight = 310
  ClientWidth = 569
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
    Top = 269
    Width = 569
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      569
      41)
    object btnCancel: TButton
      Left = 470
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 374
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 569
    Height = 269
    Align = alClient
    TabOrder = 1
    object edIdModule: TcxTextEdit
      Left = 24
      Top = 90
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 234
    end
    object edtName: TcxTextEdit
      Left = 24
      Top = 144
      TabOrder = 3
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
      Caption = #1058#1080#1087' '#1084#1086#1076#1091#1083#1103':'
      Transparent = True
    end
    object cmbTypeModule: TcxComboBox
      Left = 24
      Top = 33
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 0
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
      TabOrder = 1
      Width = 234
    end
    object cxLabel4: TcxLabel
      Left = 296
      Top = 121
      Caption = 'GUID:'
      Transparent = True
    end
    object edtGUID: TcxTextEdit
      Left = 296
      Top = 144
      TabOrder = 4
      Width = 234
    end
    object cxLabel6: TcxLabel
      Left = 24
      Top = 169
      Caption = #1060#1072#1081#1083':'
      Transparent = True
    end
    object edtFileName: TcxTextEdit
      Left = 24
      Top = 192
      TabOrder = 5
      Width = 234
    end
    object chbEnabled: TcxCheckBox
      Left = 296
      Top = 192
      Caption = #1042#1082#1083#1102#1095#1077#1085
      TabOrder = 6
      Width = 121
    end
  end
  object ActionList: TActionList
    Left = 32
    Top = 248
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
    Left = 264
    Top = 240
  end
end
