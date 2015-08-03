object frmTradeMarkSynonymDetails: TfrmTradeMarkSynonymDetails
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmTradeMarkSynonymDetails'
  ClientHeight = 178
  ClientWidth = 475
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 137
    Width = 475
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      475
      41)
    object btnSave: TButton
      Left = 277
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 373
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 475
    Height = 137
    Align = alClient
    TabOrder = 0
    object cxLabel1: TcxLabel
      Left = 16
      Top = 64
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object edtName: TcxTextEdit
      Left = 16
      Top = 80
      TabOrder = 2
      OnExit = edtNameExit
      Width = 185
    end
    object lbWarning: TcxLabel
      Left = 16
      Top = 99
      Caption = #1057#1080#1085#1086#1085#1080#1084' '#1090#1086#1088#1075#1086#1074#1086#1081' '#1084#1072#1088#1082#1080' '#1091#1078#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1077#1090
      ParentColor = False
      Style.Color = clRed
      Style.TextColor = clWhite
      Visible = False
    end
    object cxLabel4: TcxLabel
      Left = 327
      Top = 16
      Caption = #1042#1077#1088#1089#1080#1103':'
    end
    object edtVersion: TcxTextEdit
      Left = 327
      Top = 32
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 121
    end
    object edtIdTradeMarkSynonym: TcxTextEdit
      Left = 295
      Top = 32
      TabStop = False
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 7
      Visible = False
      Width = 17
    end
    object cxLabel2: TcxLabel
      Left = 16
      Top = 16
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
    end
    object cmbTradeMark: TcxLookupComboBox
      Left = 16
      Top = 37
      Properties.ImmediatePost = True
      Properties.KeyFieldNames = 'Id_TradeMark'
      Properties.ListColumns = <
        item
          Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
          FieldName = 'Id_TradeMark'
        end
        item
          Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
          FieldName = 'Name'
        end
        item
          Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          FieldName = 'FullName'
        end>
      Properties.ListFieldIndex = 1
      Properties.ListSource = dsTradeMark
      TabOrder = 0
      Width = 185
    end
    object cbShowUI: TcxCheckBox
      Left = 295
      Top = 80
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074' UI'
      TabOrder = 3
      Width = 121
    end
  end
  object ActionList: TActionList
    Left = 16
    Top = 122
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
  end
  object dsTradeMark: TDataSource
    DataSet = memTradeMark
    Left = 80
    Top = 120
  end
  object memTradeMark: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 160
    Top = 120
  end
end
