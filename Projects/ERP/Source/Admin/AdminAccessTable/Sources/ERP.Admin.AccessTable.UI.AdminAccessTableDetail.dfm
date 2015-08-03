object frmAdminAccessTableDetail: TfrmAdminAccessTableDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1058#1072#1073#1083#1080#1094#1099' '#1076#1086#1089#1090#1091#1087#1072
  ClientHeight = 272
  ClientWidth = 529
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
    Top = 231
    Width = 529
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      529
      41)
    object btnCancel: TButton
      Left = 440
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 352
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
    Width = 529
    Height = 231
    Align = alClient
    TabOrder = 1
    object cxLabel1: TcxLabel
      Left = 32
      Top = 16
      Caption = #1064#1072#1073#1083#1086#1085' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093':'
    end
    object cmbTemplateDB: TcxComboBox
      Left = 32
      Top = 39
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 0
      Width = 201
    end
    object cxLabel2: TcxLabel
      Left = 296
      Top = 16
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088':'
    end
    object edtId: TcxTextEdit
      Left = 296
      Top = 39
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 201
    end
    object cxLabel3: TcxLabel
      Left = 32
      Top = 73
      Caption = #1058#1072#1073#1083#1080#1094#1072':'
    end
    object edtTableName: TcxTextEdit
      Left = 32
      Top = 96
      Hint = #1048#1084#1103' '#1090#1072#1073#1083#1080#1094#1099' '#1074' SQL'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Width = 201
    end
    object cxLabel4: TcxLabel
      Left = 32
      Top = 126
      Caption = #1055#1086#1083#1077' - '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088':'
    end
    object edtFieldId: TcxTextEdit
      Left = 32
      Top = 149
      TabOrder = 5
      Width = 201
    end
    object cxLabel5: TcxLabel
      Left = 296
      Top = 181
      Caption = #1050#1086#1076':'
    end
    object edtCode: TcxTextEdit
      Left = 296
      Top = 204
      TabOrder = 4
      Width = 201
    end
    object cxLabel6: TcxLabel
      Left = 296
      Top = 73
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1072#1073#1083#1080#1094#1099':'
    end
    object edtTableCaption: TcxTextEdit
      Left = 296
      Top = 96
      Hint = #1054#1090#1086#1073#1088#1072#1078#1072#1077#1084#1086#1077' '#1080#1084#1103' '#1090#1072#1073#1083#1080#1094#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Width = 201
    end
    object cxLabel7: TcxLabel
      Left = 296
      Top = 126
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1086#1083#1103':'
    end
    object edtFieldCaption: TcxTextEdit
      Left = 296
      Top = 149
      Hint = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
      Width = 201
    end
    object cxLabel8: TcxLabel
      Left = 32
      Top = 181
      Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1077#1084#1086#1075#1086' '#1087#1086#1083#1103':'
    end
    object edtFieldName: TcxTextEdit
      Left = 32
      Top = 204
      Hint = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      Width = 201
    end
  end
  object ActionList: TActionList
    Left = 24
    Top = 221
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
