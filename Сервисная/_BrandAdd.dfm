object AddBrand: TAddBrand
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1058#1072#1073#1083#1080#1094#1072' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1081
  ClientHeight = 296
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 307
    Top = 158
    Width = 176
    Height = 13
    Caption = #1041#1088#1077#1085#1076' '#1074' '#1089#1077#1088#1074#1080#1089#1085#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 307
    Top = 220
    Width = 154
    Height = 13
    Caption = #1041#1088#1077#1085#1076' '#1076#1083#1103' '#1089#1086#1087#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 307
    Top = 8
    Width = 44
    Height = 13
    Caption = #1055#1086#1084#1086#1097#1100':'
  end
  object Label4: TLabel
    Left = 307
    Top = 27
    Width = 222
    Height = 13
    Caption = '1) '#1042#1099#1073#1077#1088#1080#1090#1077' '#1080#1079' '#1090#1072#1073#1083#1080#1094#1099' '#1073#1088#1077#1085#1076' '#1074' '#1089#1077#1088#1074#1080#1089#1085#1086#1081
  end
  object Label5: TLabel
    Left = 307
    Top = 74
    Width = 218
    Height = 13
    Caption = '2) '#1042#1087#1080#1096#1080#1090#1077' '#1089#1074#1086#1081' '#1073#1088#1077#1085#1076' '#1076#1083#1103' '#1089#1086#1087#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103
  end
  object Label6: TLabel
    Left = 307
    Top = 93
    Width = 164
    Height = 13
    Caption = '3) '#1053#1072#1078#1084#1080#1090#1077' '#1082#1085#1086#1087#1082#1091' '#1089#1086#1087#1086#1089#1090#1072#1074#1080#1090#1100
  end
  object Label7: TLabel
    Left = 320
    Top = 40
    Width = 253
    Height = 13
    Caption = #1087#1088#1086#1075#1088#1072#1084#1084#1077' ('#1076#1086#1089#1090#1072#1090#1086#1095#1085#1086' '#1090#1086#1083#1100#1082#1086' '#1082#1083#1080#1082#1085#1091#1090#1100' '#1084#1099#1096#1082#1086#1081
  end
  object Label8: TLabel
    Left = 320
    Top = 55
    Width = 134
    Height = 13
    Caption = #1087#1086' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1102' '#1073#1088#1077#1085#1076#1072')'
  end
  object DBGridEh1: TDBGridEh
    Left = 0
    Top = 0
    Width = 301
    Height = 296
    Align = alLeft
    DataSource = DataSource1
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = DBGridEh1CellClick
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Description'
        Footers = <>
        Title.Caption = #1041#1088#1077#1085#1076#1099' '#1074' '#1089#1077#1088#1074#1080#1089#1085#1086#1081
        Width = 277
      end>
  end
  object DBEdit1: TDBEdit
    Left = 307
    Top = 177
    Width = 266
    Height = 21
    DataField = 'serviceBrand'
    DataSource = Data.DS_mapBrand4ImportOrder
    ReadOnly = True
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 467
    Top = 266
    Width = 106
    Height = 25
    Caption = #1057#1086#1087#1086#1089#1090#1072#1074#1080#1090#1100
    TabOrder = 2
    Kind = bkOK
  end
  object DBEdit2: TDBEdit
    Left = 307
    Top = 239
    Width = 266
    Height = 21
    DataField = 'replBrand'
    DataSource = Data.DS_mapBrand4ImportOrder
    TabOrder = 3
  end
  object DataSource1: TDataSource
    DataSet = DBISAMTable1
    Left = 105
    Top = 180
  end
  object DBISAMTable1: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.24 Build 1'
    TableName = '003'
    Left = 155
    Top = 185
  end
end
