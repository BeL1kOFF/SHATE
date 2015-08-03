object RetDocAnswer: TRetDocAnswer
  Left = 0
  Top = 0
  Caption = #1042#1086#1079#1074#1088#1072#1090
  ClientHeight = 293
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 610
    Height = 21
    Align = alTop
    AutoSize = False
    Caption = ' '#1059#1089#1087#1077#1096#1085#1086' '#1091#1095#1090#1077#1085' '#1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1090#1086#1074#1072#1088':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object DBGridEh1: TDBGridEh
    Left = 0
    Top = 21
    Width = 610
    Height = 233
    Align = alTop
    AutoFitColWidths = True
    DataSource = OrderDetDataSource
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    FooterRowCount = 1
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    ReadOnly = True
    SumList.Active = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleLines = 2
    Columns = <
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'ArtCode'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1050#1086#1076
        Width = 65
      end
      item
        EditButtons = <>
        FieldName = 'ArtNameDescr'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 146
      end
      item
        EditButtons = <>
        FieldName = 'RealPriceBY'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1062#1077#1085#1072' '#1088#1091#1073'.'
      end
      item
        EditButtons = <>
        FieldName = 'RealPriceEUR'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1062#1077#1085#1072' EUR'
      end
      item
        EditButtons = <>
        FieldName = 'Quantity'
        Footer.Value = #1048#1090#1086#1075#1086':'
        Footer.ValueType = fvtStaticText
        Footer.WordWrap = True
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1050#1086#1083'-'#1074#1086
      end
      item
        EditButtons = <>
        FieldName = 'Sum'
        Footer.EndEllipsis = True
        Footer.FieldName = 'Sum'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1057#1091#1084#1084#1072
      end
      item
        EditButtons = <>
        FieldName = 'SumEUR'
        Footer.FieldName = 'SumEUR'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1057#1091#1084#1084#1072' EUR'
      end
      item
        EditButtons = <>
        FieldName = 'Ordered'
        Footers = <>
        ImageList = Main.OrderAnswer
        KeyList.Strings = (
          '0'
          '-1'
          '1')
        Title.Alignment = taCenter
        Title.Caption = #1059#1095#1090#1077#1085
        Width = 49
      end>
  end
  object BitBtn1: TBitBtn
    Left = 481
    Top = 260
    Width = 121
    Height = 27
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 1
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object OrderAnswerQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = OrderAnswerQueryCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.24 Build 1'
    MaxRowCount = -1
    SQL.Strings = (
      'SELECT * FROM [037]')
    Params = <>
    ReadOnly = True
    Left = 384
    Top = 63
    object OrderAnswerQueryID: TAutoIncField
      FieldName = 'ID'
    end
    object OrderAnswerQueryCode2: TStringField
      FieldName = 'Code2'
      Size = 50
    end
    object OrderAnswerQueryBrand: TStringField
      FieldName = 'Brand'
      Size = 50
    end
    object OrderAnswerQueryQuantity: TIntegerField
      FieldName = 'Quantity'
    end
    object OrderAnswerQueryNote: TStringField
      FieldName = 'Note'
      Size = 250
    end
    object OrderAnswerQueryRetDoc_ID: TIntegerField
      FieldName = 'RetDoc_ID'
    end
    object OrderAnswerQueryOrdered: TSmallintField
      FieldName = 'Ordered'
    end
    object OrderAnswerQueryArtCode: TStringField
      DisplayWidth = 40
      FieldKind = fkCalculated
      FieldName = 'ArtCode'
      Calculated = True
    end
    object OrderAnswerQueryArtName: TStringField
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'ArtName'
      Size = 100
      Calculated = True
    end
    object OrderAnswerQueryArtDescr: TStringField
      DisplayWidth = 250
      FieldKind = fkCalculated
      FieldName = 'ArtDescr'
      Size = 250
      Calculated = True
    end
    object OrderAnswerQueryArtPrice: TFloatField
      FieldKind = fkCalculated
      FieldName = 'ArtPrice'
      Calculated = True
    end
    object OrderAnswerQueryArtSale: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ArtSale'
      Calculated = True
    end
    object OrderAnswerQueryArtBrandId: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtBrandId'
      Calculated = True
    end
    object OrderAnswerQuerySum: TFloatField
      FieldKind = fkCalculated
      FieldName = 'Sum'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object OrderAnswerQueryArtCodeBrand: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtCodeBrand'
      Calculated = True
    end
    object OrderAnswerQueryArtNameDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'ArtNameDescr'
      Size = 350
      Calculated = True
    end
    object OrderAnswerQueryPrice_koef: TFloatField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      Calculated = True
    end
    object OrderAnswerQueryRealPriceEUR: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'RealPriceEUR'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object OrderAnswerQueryRealPriceBY: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'RealPriceBY'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object OrderAnswerQuerySumEUR: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumEUR'
      DisplayFormat = ',0.##'
      Calculated = True
    end
  end
  object OrderDetDataSource: TDataSource
    DataSet = OrderAnswerQuery
    Left = 383
    Top = 118
  end
end
