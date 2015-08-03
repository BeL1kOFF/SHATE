object frmMDMArticleDetail: TfrmMDMArticleDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmMDMArticleDetail'
  ClientHeight = 423
  ClientWidth = 472
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 472
    Height = 382
    Align = alClient
    TabOrder = 0
    object edtVersion: TcxTextEdit
      Left = 327
      Top = 32
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 121
    end
    object cxLabel4: TcxLabel
      Left = 327
      Top = 16
      Caption = #1042#1077#1088#1089#1080#1103':'
    end
    object lbWarning: TcxLabel
      Left = 24
      Top = 105
      Caption = #1058#1072#1082#1086#1081' '#1072#1088#1090#1080#1082#1091#1083' '#1091#1078#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1077#1090
      ParentColor = False
      Style.Color = clRed
      Style.TextColor = clWhite
      Visible = False
    end
    object edtIdArticle: TcxTextEdit
      Left = 295
      Top = 32
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
    object cmbTradeMark: TcxLookupComboBox
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
      Properties.ListSource = dsTradeMark
      TabOrder = 5
      Width = 233
    end
    object edtNumber: TcxTextEdit
      Left = 24
      Top = 82
      TabOrder = 6
      OnExit = edtNumberExit
      Width = 233
    end
    object edtNumberShort: TcxTextEdit
      Left = 24
      Top = 148
      TabOrder = 7
      Width = 233
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 59
      Caption = #1053#1086#1084#1077#1088':'
    end
    object cxLabel3: TcxLabel
      Left = 24
      Top = 125
      Caption = #1050#1086#1088#1086#1090#1082#1080#1081' '#1085#1086#1084#1077#1088':'
    end
    object cxLabel5: TcxLabel
      Left = 24
      Top = 175
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object edtName: TcxTextEdit
      Left = 24
      Top = 198
      TabOrder = 11
      Width = 233
    end
    object cxLabel6: TcxLabel
      Left = 24
      Top = 225
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
    end
    object mDescription: TcxMemo
      Left = 24
      Top = 248
      Properties.ScrollBars = ssVertical
      TabOrder = 13
      Height = 113
      Width = 424
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 382
    Width = 472
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      472
      41)
    object btnCancel: TButton
      Left = 370
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 274
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 72
    Top = 304
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
  object memTradeMark: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 144
    Top = 304
  end
  object dsTradeMark: TDataSource
    DataSet = memTradeMark
    Left = 240
    Top = 304
  end
end
