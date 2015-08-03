object frmAdminModuleReengineering: TfrmAdminModuleReengineering
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1080#1077' - '#1088#1077#1080#1085#1078#1080#1085#1080#1088#1080#1085#1075
  ClientHeight = 238
  ClientWidth = 702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 197
    Width = 702
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnCancel: TButton
      Left = 606
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      TabOrder = 1
    end
    object btnCreate: TButton
      Left = 517
      Top = 6
      Width = 75
      Height = 25
      Action = acCreate
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 702
    Height = 197
    Align = alClient
    TabOrder = 1
    object cxLabel1: TcxLabel
      Left = 24
      Top = 24
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072':'
    end
    object edtProject: TcxTextEdit
      Left = 131
      Top = 22
      Hint = #1055#1088#1080#1084#1077#1088': ERP.Admin.Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Width = 222
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 58
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' Unit:'
    end
    object edtUnit: TcxTextEdit
      Left = 131
      Top = 56
      Hint = #1055#1088#1080#1084#1077#1088': ERP.Admin.UI.AdminTest'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Width = 222
    end
    object cxLabel3: TcxLabel
      Left = 24
      Top = 94
      Caption = #1048#1084#1103' '#1092#1086#1088#1084#1099':'
    end
    object edtForm: TcxTextEdit
      Left = 131
      Top = 92
      Hint = #1055#1088#1080#1084#1077#1088': frmAdminTest'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Width = 222
    end
    object cxLabel4: TcxLabel
      Left = 24
      Top = 126
      Caption = 'GUID '#1084#1086#1076#1091#1083#1103':'
    end
    object cxLabel5: TcxLabel
      Left = 376
      Top = 24
      Caption = #1058#1080#1087' '#1041#1044':'
    end
    object cmbTypeDB: TcxComboBox
      Left = 483
      Top = 22
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 5
      Width = 198
    end
    object cxLabel6: TcxLabel
      Left = 376
      Top = 94
      Caption = #1042#1082#1083#1072#1076#1082#1072':'
    end
    object edtPage: TcxTextEdit
      Left = 483
      Top = 92
      TabOrder = 7
      Width = 198
    end
    object cxLabel7: TcxLabel
      Left = 376
      Top = 126
      Caption = #1043#1088#1091#1087#1087#1072':'
    end
    object edtGroup: TcxTextEdit
      Left = 483
      Top = 124
      TabOrder = 8
      Width = 198
    end
    object cxLabel8: TcxLabel
      Left = 376
      Top = 162
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
    end
    object edtName: TcxTextEdit
      Left = 483
      Top = 161
      TabOrder = 9
      Width = 198
    end
    object cxLabel9: TcxLabel
      Left = 376
      Top = 58
      Caption = #1058#1080#1087' '#1084#1086#1076#1091#1083#1103':'
    end
    object cmbTypeModule: TcxComboBox
      Left = 483
      Top = 56
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 6
      Width = 198
    end
    object edtGUIDModule: TcxButtonEdit
      Left = 131
      Top = 124
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = edtGUIDPropertiesButtonClick
      TabOrder = 3
      Width = 222
    end
    object cxLabel10: TcxLabel
      Left = 24
      Top = 162
      Caption = 'GUID '#1087#1088#1086#1077#1082#1090#1072':'
    end
    object edtGUIDProject: TcxButtonEdit
      Left = 131
      Top = 161
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = edtGUIDProjectPropertiesButtonClick
      TabOrder = 4
      Width = 222
    end
  end
  object ActionList: TActionList
    Left = 88
    Top = 168
    object acCreate: TAction
      Caption = #1057#1086#1079#1076#1072#1090#1100'...'
      OnExecute = acCreateExecute
      OnUpdate = acCreateUpdate
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      OnExecute = acCancelExecute
    end
  end
  object qrQuery: TFDQuery
    Left = 240
    Top = 168
  end
end
