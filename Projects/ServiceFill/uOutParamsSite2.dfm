object OutParamsSiteForm2: TOutParamsSiteForm2
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1074#1099#1075#1088#1091#1079#1082#1080
  ClientHeight = 348
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btOK: TButton
    Left = 255
    Top = 315
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btOKClick
  end
  object cbZipAll: TCheckBox
    Left = 8
    Top = 241
    Width = 167
    Height = 17
    Caption = #1059#1087#1072#1082#1086#1074#1072#1090#1100' '#1076#1083#1103' shate-mag.by'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = cbZipAllClick
  end
  object edZipName: TEdit
    Left = 195
    Top = 239
    Width = 135
    Height = 21
    TabOrder = 2
    Text = 'all.zip'
  end
  object cbZipEach: TCheckBox
    Left = 8
    Top = 293
    Width = 208
    Height = 17
    Caption = #1059#1087#1072#1082#1086#1074#1072#1090#1100' '#1082#1072#1078#1076#1099#1081' '#1092#1072#1081#1083' '#1086#1090#1076#1077#1083#1100#1085#1086
    TabOrder = 3
    OnClick = cbZipEachClick
  end
  object DBGridEh1: TDBGridEh
    Left = 7
    Top = 50
    Width = 323
    Height = 171
    DataSource = DS_Params
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind]
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'CAPTION'
        Footers = <>
        ReadOnly = True
        Width = 177
      end
      item
        EditButtons = <>
        FieldName = 'UP_F'
        Footers = <>
        Width = 58
      end
      item
        EditButtons = <>
        FieldName = 'UP_D'
        Footers = <>
        Width = 58
      end>
  end
  object rbAll_full: TRadioButton
    Left = 8
    Top = 8
    Width = 123
    Height = 17
    Caption = #1055#1086#1083#1085#1086#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077
    TabOrder = 5
    OnClick = rbAll_fullClick
  end
  object rbAll_discret: TRadioButton
    Left = 8
    Top = 26
    Width = 138
    Height = 17
    Caption = #1063#1072#1089#1090#1080#1095#1085#1086#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077
    Checked = True
    TabOrder = 6
    TabStop = True
    OnClick = rbAll_discretClick
  end
  object cbZip_shateby: TCheckBox
    Left = 8
    Top = 265
    Width = 157
    Height = 17
    Caption = #1059#1087#1072#1082#1086#1074#1072#1090#1100' '#1076#1083#1103' shate-m.by'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = cbZipEachClick
  end
  object edZipName_shateby: TEdit
    Left = 195
    Top = 263
    Width = 135
    Height = 21
    TabOrder = 8
    Text = '18.10.2012_1.zip'
  end
  object memParams: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    TableName = 'PARAMS'
    Left = 109
    Top = 75
    object memParamsID: TAutoIncField
      FieldName = 'ID'
    end
    object memParamsCAPTION: TStringField
      DisplayLabel = #1058#1080#1087' '#1076#1072#1085#1085#1099#1093
      FieldName = 'CAPTION'
      Size = 50
    end
    object memParamsUP_F: TBooleanField
      DisplayLabel = #1055#1086#1083#1085#1086#1077
      FieldName = 'UP_F'
      OnChange = memParamsUP_FChange
    end
    object memParamsUP_D: TBooleanField
      DisplayLabel = #1063#1072#1089#1090#1080#1095#1085#1086#1077
      FieldName = 'UP_D'
      OnChange = memParamsUP_DChange
    end
  end
  object DS_Params: TDataSource
    DataSet = memParams
    Left = 109
    Top = 125
  end
end
