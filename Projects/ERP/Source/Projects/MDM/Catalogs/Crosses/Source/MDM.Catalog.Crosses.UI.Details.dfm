object frmMDMCrossesDetail: TfrmMDMCrossesDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmMDMCrossesDetail'
  ClientHeight = 272
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 231
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 472
    ExplicitHeight = 382
    object edtVersion: TcxTextEdit
      Left = 432
      Top = 136
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 121
    end
    object cxLabel4: TcxLabel
      Left = 432
      Top = 113
      Caption = #1042#1077#1088#1089#1080#1103':'
    end
    object lbWarning: TcxLabel
      Left = 216
      Top = 113
      Caption = #1058#1072#1082#1086#1081' '#1082#1088#1086#1089#1089' '#1091#1078#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1077#1090
      ParentColor = False
      Style.Color = clRed
      Style.TextColor = clWhite
      Visible = False
    end
    object edtIdCross: TcxTextEdit
      Left = 215
      Top = 152
      TabStop = False
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 3
      Visible = False
      Width = 17
    end
    object cxLabel1: TcxLabel
      Left = 24
      Top = 16
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
    end
    object cmbTradeMark1: TcxLookupComboBox
      Left = 24
      Top = 32
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
      Properties.ListSource = dsTradeMark1
      Properties.OnChange = cmbTradeMark1PropertiesChange
      TabOrder = 5
      Width = 233
    end
    object cxLabel3: TcxLabel
      Left = 320
      Top = 16
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
    end
    object cmbTradeMark2: TcxLookupComboBox
      Left = 320
      Top = 32
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
      Properties.ListSource = dsTradeMark2
      Properties.OnChange = cmbTradeMark2PropertiesChange
      TabOrder = 7
      Width = 233
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 62
      Caption = #1040#1088#1090#1080#1082#1091#1083':'
    end
    object cmbArticle1: TcxLookupComboBox
      Left = 24
      Top = 78
      Properties.ImmediatePost = True
      Properties.KeyFieldNames = 'Id_Article'
      Properties.ListColumns = <
        item
          Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
          FieldName = 'Id_Article'
        end
        item
          Caption = #1040#1088#1090#1080#1082#1091#1083
          FieldName = 'Number'
        end
        item
          Caption = #1053#1053
          FieldName = 'Name'
        end>
      Properties.ListFieldIndex = 1
      Properties.ListSource = dsArticle1
      Properties.OnChange = cmbArticle1PropertiesChange
      TabOrder = 9
      Width = 233
    end
    object cxLabel5: TcxLabel
      Left = 320
      Top = 62
      Caption = #1040#1088#1090#1080#1082#1091#1083':'
    end
    object cmbArticle2: TcxLookupComboBox
      Left = 320
      Top = 78
      Properties.ImmediatePost = True
      Properties.KeyFieldNames = 'Id_Article'
      Properties.ListColumns = <
        item
          Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
          FieldName = 'Id_Article'
        end
        item
          Caption = #1040#1088#1090#1080#1082#1091#1083
          FieldName = 'Number'
        end
        item
          Caption = #1053#1053
          FieldName = 'Name'
        end>
      Properties.ListFieldIndex = 1
      Properties.ListSource = dsArticle2
      Properties.OnChange = cmbArticle2PropertiesChange
      TabOrder = 11
      Width = 233
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 231
    Width = 645
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 382
    ExplicitWidth = 472
    DesignSize = (
      645
      41)
    object btnCancel: TButton
      Left = 543
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 370
    end
    object btnSave: TButton
      Left = 447
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
      ExplicitLeft = 274
    end
  end
  object ActionList: TActionList
    Left = 32
    Top = 112
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
  object memTradeMark1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 32
    Top = 176
  end
  object dsTradeMark1: TDataSource
    DataSet = memTradeMark1
    Left = 32
    Top = 224
  end
  object memTradeMark2: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 136
    Top = 176
  end
  object dsTradeMark2: TDataSource
    DataSet = memTradeMark2
    Left = 136
    Top = 224
  end
  object memArticle1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 248
    Top = 176
  end
  object memArticle2: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 360
    Top = 176
  end
  object dsArticle1: TDataSource
    DataSet = memArticle1
    Left = 248
    Top = 224
  end
  object dsArticle2: TDataSource
    DataSet = memArticle2
    Left = 360
    Top = 224
  end
end
