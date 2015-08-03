object RetDocAnswer: TRetDocAnswer
  Left = 0
  Top = 0
  Caption = #1042#1086#1079#1074#1088#1072#1090
  ClientHeight = 285
  ClientWidth = 612
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
    Width = 612
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
    ExplicitWidth = 610
  end
  object DBGridEh1: TDBGridEh
    Left = 0
    Top = 21
    Width = 612
    Height = 229
    Align = alClient
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
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'RealPriceEUR'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1062#1077#1085#1072
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
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'SumEUR'
        Footer.FieldName = 'SumEUR'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1057#1091#1084#1084#1072
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
  object Panel: TPanel
    Left = 0
    Top = 250
    Width = 612
    Height = 35
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      612
      35)
    object BitBtn2: TBitBtn
      Left = 10
      Top = 4
      Width = 123
      Height = 27
      Anchors = [akLeft, akBottom]
      Caption = #1055#1077#1095#1072#1090#1100
      TabOrder = 0
      OnClick = BitBtn2Click
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFB3B1B2FF00FFFF00FFFF00FF9A99999A9999A4A1
        A2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB3B1B2B3B1B2DEDCDCAB
        A9A95553546F6D6EAEACACD2D0D1E0DFDF9A9999FF00FFFF00FFFF00FFFF00FF
        B3B1B2B3B1B2FBFBFBFFFFFFE0DEDFB2B0B05F5E603131333131344F4D4F8180
        819A9999A4A1A2FF00FFA7A4A5B3B1B2F4F2F3FFFFFFF2F0F0D6D5D5B3B1B2A4
        A1A1ACA9AA9E9D9D7E7D7D5655573536383635378D8B8CFF00FFB0ADAEEEEDED
        EBEBEBCCCACAB9B7B7C4C2C2D0CFCFB7B5B5ABA8A9A8A6A6ACA9AAAFADADA4A1
        A28584849A9999FF00FFAAA7A8BFBDBEB7B5B5C1C0C0D5D5D5DCDDDDF1F1F0F4
        F2F4E4E3E3D2D1D1BFBDBDAFADAEA9A6A6ACA9AAA4A1A2FF00FFA7A4A5C0BFC0
        D5D4D4D9D9D9D5D5D5E9E9E9DCDADAB5BDB5CCCBCBD7D9DADFDFDFDDDDDDD3D2
        D2C6C6C6ADACACFF00FFFF00FFB0AEAFDBDCDCDADADAE4E4E4D5D3D3C5C1C4B8
        DCBAC9D1CBD2BAB5BFB7B6BBB9BAC4C2C3D0CFCFBBB9BAFF00FFFF00FFFF00FF
        B0AEAFCFCDCDC0BFBFC2C1C1EAEAEAF8F6F6F2F1F2F1E8E6E4E1E1D8D8D8C4C4
        C4A9A6A7FF00FFFF00FFFF00FFFF00FFFF00FFB0AEAFE1E3E3D6D6D7B1B3B4CA
        CDCFDDDFE0DEE2E2DFDFDFD3D2D3C0BFBFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFCEBE8FAE7DEEED5CCEAD4CCE9D8D4E6DDD9DBD9D8AAA8AAFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD9B3B1FFE6D9FFDACCFF
        D1C0FFC9B6FFC2AEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFD9B3B1FFE5D9FFD8CBFED0C1FFCAB7F9BBA8FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD9B3B1FFE5D9FFD8CBFE
        D0C1FEC8B6FBC1AEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFD9B3B1FBE7DFFFE3D8FFD9CCFFD3C2FDC8B6FABFAEFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD9B3B1D9B3B1D9B3B1D9B3B1F6
        BFB1F6BFB1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    end
    object BitBtn1: TBitBtn
      Left = 478
      Top = 4
      Width = 123
      Height = 27
      Anchors = [akRight, akBottom]
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
  end
  object OrderAnswerQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    OnCalcFields = OrderAnswerQueryCalcFields
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
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
