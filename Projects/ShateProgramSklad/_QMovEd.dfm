inherited QuantityMoveEdit: TQuantityMoveEdit
  BorderIcons = [biSystemMenu]
  Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1074' '#1076#1088#1091#1075#1086#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 246
  ClientWidth = 324
  Color = clWindow
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  ExplicitWidth = 330
  ExplicitHeight = 278
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnBevel: TBevel
    Top = 205
    Width = 317
    ExplicitTop = 228
    ExplicitWidth = 320
  end
  object Label3: TLabel [1]
    Left = 11
    Top = 11
    Width = 51
    Height = 13
    Caption = #1080#1079' '#1079#1072#1082#1072#1079#1072
  end
  object Label4: TLabel [2]
    Left = 22
    Top = 39
    Width = 39
    Height = 13
    Caption = #1074' '#1079#1072#1082#1072#1079
  end
  inherited OkBtn: TBitBtn
    Left = 89
    Top = 213
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' (F10)'
    ModalResult = 0
    ExplicitLeft = 89
    ExplicitTop = 213
  end
  inherited CancelBtn: TBitBtn
    Left = 218
    Top = 213
    ExplicitLeft = 218
    ExplicitTop = 213
  end
  object MemoryGrid: TDBGridEh
    Left = 8
    Top = 72
    Width = 305
    Height = 120
    DataSource = MemorySource
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'pos_info'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 195
      end
      item
        EditButtons = <>
        FieldName = 'kol'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Width = 68
      end>
  end
  object OrderInfo1: TEdit
    Left = 72
    Top = 8
    Width = 177
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
  end
  object OrderInfo2: TEdit
    Left = 72
    Top = 36
    Width = 177
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 4
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'QuantityEdit\'
    StoredValues = <>
    Left = 112
    Top = 136
  end
  object FormStyler: TAdvFormStyler
    AutoThemeAdapt = False
    Style = tsOffice2003Blue
    AppStyle = Main.AppStyler
    Left = 48
    Top = 136
  end
  object MemoryTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.24 Build 1'
    TableName = 'MemoryGrid'
    Left = 184
    Top = 136
    object MemoryTablecode2: TStringField
      FieldName = 'code2'
    end
    object MemoryTablebrand: TStringField
      FieldName = 'brand'
    end
    object MemoryTablepos_info: TStringField
      FieldName = 'pos_info'
    end
    object MemoryTableprice: TCurrencyField
      FieldName = 'price'
    end
    object MemoryTablekol: TFloatField
      FieldName = 'kol'
    end
    object MemoryTableID: TIntegerField
      FieldName = 'ID'
    end
    object MemoryTableKolMax: TIntegerField
      FieldName = 'KolMax'
    end
  end
  object MemorySource: TDataSource
    DataSet = MemoryTable
    Left = 256
    Top = 136
  end
  object ReturnDocMemoryTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.24 Build 1'
    TableName = 'RetMemoryGrid'
    Left = 185
    Top = 70
    object ReturnDocMemoryTablecode2: TStringField
      FieldName = 'code2'
    end
    object ReturnDocMemoryTablebrand: TStringField
      FieldName = 'brand'
    end
    object ReturnDocMemoryTablepos_info: TStringField
      FieldName = 'pos_info'
    end
    object ReturnDocMemoryTablekol: TIntegerField
      FieldName = 'kol'
    end
    object ReturnDocMemoryTablekolMax: TIntegerField
      FieldName = 'kolMax'
    end
    object ReturnDocMemoryTableordered: TSmallintField
      FieldName = 'ordered'
    end
    object ReturnDocMemoryTableID: TIntegerField
      FieldName = 'ID'
    end
  end
end
