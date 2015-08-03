object ConfigDiffProfitForm: TConfigDiffProfitForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1085#1072#1094#1077#1085#1086#1082
  ClientHeight = 229
  ClientWidth = 257
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
  object Label6: TLabel
    Left = 0
    Top = 30
    Width = 257
    Height = 1
    Align = alTop
    AutoSize = False
    Color = clSilver
    ParentColor = False
    Transparent = False
    ExplicitLeft = -89
    ExplicitTop = 35
    ExplicitWidth = 413
  end
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 257
    Height = 30
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 
      #1047#1076#1077#1089#1100' '#1074#1099' '#1084#1086#1078#1077#1090#1077' '#1085#1072#1089#1090#1088#1086#1080#1090#1100' '#1074#1072#1096#1091' '#1085#1072#1094#1077#1085#1082#1091' '#1085#1072' '#1090#1086#1074#1072#1088'  '#1074' '#1079#1072#1074#1080#1089#1080#1084#1086#1089#1090#1080' '#1086 +
      #1090' '#1077#1075#1086' '#1094#1077#1085#1099' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInfoText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 263
  end
  object btCancel: TButton
    Left = 174
    Top = 197
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 0
  end
  object btOK: TButton
    Left = 93
    Top = 197
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btOKClick
  end
  object Grid: TDBGridEh
    Left = 8
    Top = 37
    Width = 241
    Height = 153
    DataSource = dsMemProfit
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    FrozenCols = 1
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    UseMultiTitle = True
    VTitleMargin = 3
    OnDrawColumnCell = GridDrawColumnCell
    OnKeyDown = GridKeyDown
    Columns = <
      item
        Color = clBtnFace
        EditButtons = <>
        FieldName = 'RecNum'
        Footers = <>
        MaxWidth = 25
        MinWidth = 25
        ReadOnly = True
        Width = 25
      end
      item
        EditButtons = <>
        FieldName = 'PriceFrom'
        Footers = <>
        Title.Caption = #1062#1077#1085#1099' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#8364' | '#1054#1090'  ('#1074#1082#1083#1102#1095#1072#1103')'
        Width = 68
      end
      item
        EditButtons = <>
        FieldName = 'PriceTo'
        Footers = <>
        Title.Caption = #1062#1077#1085#1099' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#8364' |'#1044#1086
      end
      item
        EditButtons = <>
        FieldName = 'Profit'
        Footers = <>
        Width = 59
      end>
  end
  object memProfit: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = memProfitCalcFields
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    TableName = 'memProfitTemp'
    StoreDefs = True
    Left = 130
    Top = 100
    object memProfitRecNum: TIntegerField
      DisplayLabel = #8470
      FieldKind = fkCalculated
      FieldName = 'RecNum'
      Calculated = True
    end
    object memProfitPriceFrom: TFloatField
      DisplayLabel = #1062#1077#1085#1072'* '#1054#1058', '#8364' ('#1074#1082#1083#1102#1095#1072#1103')'
      FieldName = 'PriceFrom'
    end
    object memProfitPriceTo: TFloatField
      DisplayLabel = #1062#1077#1085#1072'* '#1044#1054', '#8364
      FieldName = 'PriceTo'
    end
    object memProfitProfit: TFloatField
      DisplayLabel = #1053#1072#1094#1077#1085#1082#1072', %'
      FieldName = 'Profit'
    end
  end
  object dsMemProfit: TDataSource
    DataSet = memProfit
    Left = 60
    Top = 100
  end
end
