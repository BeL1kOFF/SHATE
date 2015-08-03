inherited Param: TParam
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
  ClientHeight = 347
  ClientWidth = 512
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  ExplicitWidth = 518
  ExplicitHeight = 379
  DesignSize = (
    512
    347)
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnBevel: TBevel
    Left = 172
    Top = 307
    Width = 325
    ExplicitLeft = 172
    ExplicitTop = 281
    ExplicitWidth = 335
  end
  object lbTitle: TLabel [1]
    Left = 172
    Top = 8
    Width = 330
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Color = clActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCaptionText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  inherited OkBtn: TBitBtn
    Left = 278
    Top = 315
    TabOrder = 1
    ExplicitLeft = 278
    ExplicitTop = 315
  end
  inherited CancelBtn: TBitBtn
    Left = 404
    Top = 315
    TabOrder = 3
    OnClick = CancelBtnClick
    ExplicitLeft = 404
    ExplicitTop = 315
  end
  object PageListTreeView: TJvPageListTreeView
    Left = 8
    Top = 8
    Width = 154
    Height = 300
    PageDefault = 0
    PageList = Pager
    HideSelection = False
    ShowRoot = False
    Indent = 19
    ParentShowHint = False
    RowSelect = True
    ShowHint = False
    TabOrder = 0
    OnChange = PageListTreeViewChange
    Items.NodeData = {
      0108000000290000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      00081E0441043D043E0432043D044B043504290000000000000000000000FFFF
      FFFFFFFFFFFF0000000000000000082D043B042E003F043E0447044204300437
      0000000000000000000000FFFFFFFFFFFFFFFF00000000000000000F1D043004
      4104420440043E0439043A0438042000500072006F0078007900390000000000
      000000000000FFFFFFFFFFFFFFFF00000000000000001012044B04340435043B
      0435043D0438043504200046043204350442043E043C042D0000000000000000
      000000FFFFFFFFFFFFFFFF00000000000000000A1E0431043D043E0432043B04
      35043D0438044F04350000000000000000000000FFFFFFFFFFFFFFFF00000000
      000000000E24043E043D043E0432044B04350420003704300434043004470438
      04250000000000000000000000FFFFFFFFFFFFFFFF0000000000000000061F04
      40043E04470438043504390000000000000000000000FFFFFFFFFFFFFFFF0000
      000000000000101F0440043E0434043004360438042F0012043E043704320440
      04300442044B04}
    Items.Links = {
      0800000000000000000000000000000000000000000000000000000000000000
      00000000}
  end
  object Pager: TJvPageList
    Left = 172
    Top = 22
    Width = 330
    Height = 285
    ActivePage = OtherPage
    PropagateEnable = False
    ShowDesignCaption = sdcNone
    object MainPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 330
      Height = 285
      Caption = 'MainPage'
      DesignSize = (
        330
        285)
      object Label1: TLabel
        Left = -2
        Top = 14
        Width = 175
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1058#1077#1082#1091#1097#1080#1081' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1082#1083#1080#1077#1085#1090#1072
        WordWrap = True
      end
      object Bevel1: TBevel
        Left = 5
        Top = 38
        Width = 315
        Height = 2
        Anchors = [akLeft, akTop, akRight]
        ExplicitWidth = 323
      end
      object Label2: TLabel
        Left = 9
        Top = 43
        Width = 78
        Height = 13
        Caption = #1050#1091#1088#1089#1099' '#1074#1072#1083#1102#1090
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object Label3: TLabel
        Left = -21
        Top = 70
        Width = 54
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'EUR'
      end
      object Label4: TLabel
        Left = 6
        Top = 100
        Width = 27
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'EUR'
      end
      object Label5: TLabel
        Left = 190
        Top = 70
        Width = 67
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1057#1082#1080#1076#1082#1072', %'
      end
      object Bevel2: TBevel
        Left = 182
        Top = 38
        Width = 2
        Height = 121
      end
      object Label7: TLabel
        Left = 198
        Top = 43
        Width = 82
        Height = 13
        Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1094#1077#1085
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 120
        Top = 70
        Width = 22
        Height = 13
        Caption = 'BYR'
        WordWrap = True
      end
      object Label9: TLabel
        Left = 120
        Top = 100
        Width = 23
        Height = 13
        Caption = 'USD'
      end
      object Bevel3: TBevel
        Left = 8
        Top = 161
        Width = 318
        Height = 2
        Anchors = [akLeft, akTop, akRight]
      end
      object Label17: TLabel
        Left = 190
        Top = 100
        Width = 67
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1053#1072#1094#1077#1085#1082#1072', %'
      end
      object Label19: TLabel
        Left = 26
        Top = 201
        Width = 213
        Height = 13
        Caption = #1087#1086#1079#1080#1094#1080#1080', '#1091#1078#1077' '#1089#1086#1076#1077#1088#1078#1072#1097#1077#1081#1089#1103' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
      end
      object Label26: TLabel
        Left = 10
        Top = 128
        Width = 23
        Height = 13
        Caption = 'EUR'
      end
      object Label27: TLabel
        Left = 120
        Top = 128
        Width = 23
        Height = 13
        Caption = 'RUB'
      end
      object ShowStartCheckBox: TDBCheckBox
        Left = 10
        Top = 167
        Width = 261
        Height = 16
        Caption = #1074#1089#1077#1075#1076#1072' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1088#1080'  '#1089#1090#1072#1088#1090#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        DataField = 'Show_mparam'
        DataSource = Data.ParamDataSource
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object EURRateEd: TDBEdit
        Left = 38
        Top = 67
        Width = 79
        Height = 21
        DataField = 'Eur_rate'
        DataSource = Data.ParamDataSource
        TabOrder = 1
        OnKeyPress = RateEdKeyPress
      end
      object EUR_USDEd: TDBEdit
        Left = 38
        Top = 97
        Width = 79
        Height = 21
        DataField = 'Eur_usd_rate'
        DataSource = Data.ParamDataSource
        TabOrder = 2
        OnKeyPress = RateEdKeyPress
      end
      object DBCheckBox1: TDBCheckBox
        Left = 10
        Top = 187
        Width = 250
        Height = 16
        BiDiMode = bdLeftToRight
        Caption = #1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1087#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077' '#1086' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1080
        DataField = 'ShowMessageAddOrder'
        DataSource = Data.ParamDataSource
        ParentBiDiMode = False
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object BitBtn1: TBitBtn
        Left = 146
        Top = 66
        Width = 28
        Height = 23
        Hint = #1042#1099#1089#1090#1072#1074#1080#1090#1100' '#1082#1091#1088#1089#1099' '#1095#1077#1088#1077#1079' '#1080#1085#1090#1077#1088#1085#1077#1090
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = BitBtn1Click
        Glyph.Data = {
          96030000424D9603000000000000960200002800000010000000100000000100
          08000000000000010000120B0000120B0000980000009800000000000000FFFF
          FF00736F8200F4F3F7006A67720037363900A1A0A300CAC9CC006F6B7200D5D0
          D800A09EA100928F9300766F7800908B9100B5ADB600B4ADB500FF00FF00726C
          7200D3CBD300D3CCD300B5AFB500D9D3D900CFC9CF0088848800817E81002B2A
          2B00393839008482840082808200DCDADC0077767700C5BDC400E1DAE000928C
          9100F4EFF30068636600484546004F4B4C00797474009F979200CBAD8E00B4A9
          9C00F4951700F69C2800E6B77700FFA52200F69F2200FFA62400FFA72900FBBD
          6400FFB54000F4AF3B00FFBB4100FFC15000EFB54B00FFC45200DEAF5800FFCC
          5F00DCB76A00C2AB7B00FFD57300FFD97900FFDC7300FFEB9200A9A38900F7E6
          87009A977B00FFFAA3007A7850005875590046735200768F82004C4F4F005759
          59008E90900030697B0073767700484A4B004E5051005C5E5F00545657006A6C
          6D006365660060626300476983002396FC00187ADE001C87EF001767B7001F80
          DE00647280000D64C2001687FF001573D700146AC7001460B0001F487400224B
          78004D6681004A525B000543900006489800074999000D7AFE000F72E6000D59
          B6000C4EA0000F57AF000E519F0014509A00164681001F528C00355C8A003554
          7A00475C75005A6C8100B1C0D1000353BB00034FB400034EB200034CAA000346
          A1000349A1000452BB000A4EA6000A4CA1000C4187000E458B000E4386000F42
          86001C457A0026559000758CAC008C9DB6008B929E00494A4C004D4E5000F3F4
          F60098A1B7008B8C900036373E008E8F960068686A009C9C9E00555556009F9F
          A0008C8C8C004B4B4B00454545003D3D3D003434340023232300101010101010
          101010109090909010101010108788481010109007060B21251010104D508E11
          4D4D1090938F18232410104D1B5008454B0293292793938C10104D0D1F500C46
          6479602A32312C28261A4D1214504C04817B7765442D2F302B944D160F63716E
          7D6867757A3735342E954D130E616A5E55575C76473D3C3933964D158A6C5659
          5F585B6641433F3E36194D2084695D7F6282785442403B3A38974D22857C6B72
          92736F939393939305104D1D8D806D494F1E8B4D1010101010104D911D707E5A
          4A52534D1010101010104D0189748386171C1C4E101010101010514D01010309
          0A4D4D1010101010101010104D4D4D4D4D101010101010101010}
      end
      object DBCheckBox2: TDBCheckBox
        Left = 10
        Top = 220
        Width = 243
        Height = 17
        Caption = #1054#1073#1098#1077#1076#1080#1085#1103#1090#1100' '#1072#1085#1072#1083#1086#1075#1080' '#1080' '#1087#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080
        DataField = 'bUnionDetailAnalog'
        DataSource = Data.ParamDataSource
        TabOrder = 5
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object ClIDEd: TEdit
        Left = 178
        Top = 10
        Width = 98
        Height = 21
        ReadOnly = True
        TabOrder = 6
      end
      object BitBtn2: TBitBtn
        Left = 300
        Top = 10
        Width = 25
        Height = 22
        Hint = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088#1099' '#1082#1083#1080#1077#1085#1090#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = BitBtn2Click
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00B44A0800C752
          1C00EC614500F7634F00F6654F00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00B64B0B00CD54
          2200F0614800F86F5600F97A5B00F9816A00F76C5800F15B4600A25C2700FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00BD4C1100D456
          2B00F6745800FC886500FC876400FDD3CA00FAA49700E9543B009C592200008F
          000014AE2B0020C050004ECB65005AC558000194000000800000C54F1A00DF61
          3900FE896800FF875F00FFAC9400FFFFFF00FFC9BC00EE66470097561B0011A4
          250032D46E0033D05E00AEF5AE00B2F3B30013A9220000820100FF00FF00DF61
          3900FF8B6400C6705B00ABA2A500C3CACD00ECA18C00FE785600A76528001AB5
          370026C1560044A15300A8C4A50082C9800027BF4900078D1200FF00FF00FF00
          FF005C617F00336AAC002370BD002569A9008C676D00FF00FF00FF00FF000638
          0C0006311100153167001A3380001644570023A74B00FF00FF00FF00FF002080
          B7001A83DC00309FFF00339DFF002B93F6002E81D000FF00FF00020C16000000
          0000081448001342B0000F3FAE000F35A00012418F00FF00FF003282A3003F9A
          D30044ACFF0045AEFF0045AEFD0046AFFF003FACFE002687D100020C12000206
          1100184DA8001F61D1001D5CC4001E5DC7001950C1000727A1003282A30045A4
          E0004BB4FF004AB1FD0047ADF80047ADF9004CB6FF003A96DA00030B0E00030F
          20002269CC002572E0002166CE00226DD7002269D3001C50B4003282A3003282
          A30046A2D30048AAE8004AB1FC004AAFFA004DB6FF00358CD000050C12000507
          0B00206ABA003197FF002F8DF5003091F9002879DE00205EAF003282A3003282
          A3003282A30048A6DD004EB6FE004EB7FF0049B0F600226A9F00060D13002620
          1A00243E57001E69AF00277ECD002D85D4001A4D8A00205EAF00FF00FF003282
          A3003282A3003282A3003282A3003282A3003282A300FF00FF00FF00FF002A28
          26006A66610060605F00202933000713210003081700FF00FF00FF00FF00FF00
          FF003282A3003282A3003282A3003282A300FF00FF00FF00FF00FF00FF00FF00
          FF00525353005C5A5800221E1A0000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object DBCheckBox6: TDBCheckBox
        Left = 10
        Top = 260
        Width = 259
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1072#1084#1103#1090#1100' '#1076#1083#1103' '#1088#1072#1073#1086#1090#1099' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        DataField = 'UseMemory'
        DataSource = Data.ParamDataSource
        TabOrder = 8
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object EUR_RUBEd: TDBEdit
        Left = 38
        Top = 124
        Width = 79
        Height = 21
        DataField = 'Eur_RUB_rate'
        DataSource = Data.ParamDataSource
        TabOrder = 9
        OnKeyPress = RateEdKeyPress
      end
      object Disc_Edit: TEdit
        Left = 272
        Top = 67
        Width = 53
        Height = 21
        TabOrder = 10
        Text = 'Disc_Edit'
        OnKeyPress = Disc_EditKeyPress
      end
      object Profit_edit: TEdit
        Left = 272
        Top = 97
        Width = 53
        Height = 21
        TabOrder = 11
        Text = 'Profit_edit'
        OnKeyPress = Profit_editKeyPress
      end
      object BitBtn4: TBitBtn
        Left = 276
        Top = 10
        Width = 25
        Height = 22
        Hint = #1053#1072#1089#1090#1088#1086#1080#1090#1100' '#1082#1083#1080#1077#1085#1090#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        OnClick = BitBtn4Click
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00767676007676
          76007676760076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0076767600C8C8
          C800A7A7A70076767600FF00FF00676767006767670067676700676767006767
          67006767670067676700676767006767670067676700FF00FF0076767600AEAE
          AE00E1E1E10076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00767676007676
          76007676760076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00767676007676
          76007676760076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0076767600C8C8
          C800A7A7A70076767600FF00FF00676767006767670067676700676767006767
          67006767670067676700676767006767670067676700FF00FF0076767600AEAE
          AE00E1E1E10076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00767676007676
          76007676760076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00767676007676
          76007676760076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0076767600C8C8
          C800A7A7A70076767600FF00FF00676767006767670067676700676767006767
          67006767670067676700676767006767670067676700FF00FF0076767600AEAE
          AE00E1E1E10076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00767676007676
          76007676760076767600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object btConfigRounding: TBitBtn
        Left = 195
        Top = 123
        Width = 130
        Height = 23
        Caption = #1053#1072#1089#1090#1088#1086#1080#1090#1100' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        OnClick = btConfigRoundingClick
      end
      object DBCheckBox20: TDBCheckBox
        Left = 10
        Top = 240
        Width = 306
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1086#1089#1090#1072#1090#1082#1080' '#1074#1089#1077#1093' '#1090#1086#1088#1075#1086#1074#1099#1093' '#1090#1086#1095#1077#1082' '#1074' '#1082#1072#1090#1072#1083#1086#1075#1077
        DataField = 'bQuantsInGrid'
        DataSource = Data.ParamDataSource
        TabOrder = 14
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object EMailPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 330
      Height = 285
      Caption = 'EMailPage'
      object Label6: TLabel
        Left = 24
        Top = 12
        Width = 121
        Height = 28
        AutoSize = False
        Caption = 'Email, '#1085#1072' '#1082#1086#1090'.'#1073#1091#1076#1091#1090' '#1074#1099#1089#1099#1083#1072#1090#1100#1089#1103' '#1079#1072#1082#1072#1079#1099
        WordWrap = True
      end
      object Label39: TLabel
        Left = 24
        Top = 101
        Width = 108
        Height = 26
        Caption = 'Email, '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1086#1074' '#1087#1086#1089#1090#1072#1097#1080#1082#1091
        WordWrap = True
      end
      object Label40: TLabel
        Left = 24
        Top = 133
        Width = 90
        Height = 13
        Caption = 'Email, '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078
      end
      object Label41: TLabel
        Left = 24
        Top = 157
        Width = 102
        Height = 26
        Caption = 'Email, '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082#1083#1080#1077#1085#1090#1072
        WordWrap = True
      end
      object Label42: TLabel
        Left = 24
        Top = 189
        Width = 95
        Height = 13
        Caption = 'Email, '#1076#1083#1103' '#1083#1080#1084#1080#1090#1086#1074
      end
      object ShateEmailEd: TDBAdvEdit
        Left = 152
        Top = 14
        Width = 163
        Height = 21
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        Enabled = True
        TabOrder = 0
        Text = 'ShateEmailEd'
        Visible = True
        Version = '2.8.1.3'
        DataField = 'Shate_email'
        DataSource = Data.SysParamDataSource
      end
      object TCPDirectCheckBox: TDBCheckBox
        Left = 24
        Top = 46
        Width = 271
        Height = 17
        Caption = #1087#1088#1103#1084#1072#1103' '#1086#1090#1087#1088#1072#1074#1082#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1085#1072' TCP-'#1089#1077#1088#1074#1077#1088
        DataField = 'TCP_direct'
        DataSource = Data.ParamDataSource
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object EmaiEmailRetDocEd: TDBAdvEdit
        Left = 152
        Top = 102
        Width = 163
        Height = 21
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        Enabled = True
        TabOrder = 2
        Visible = True
        Version = '2.8.1.3'
        DataField = 'EmailReturn'
        DataSource = Data.SysParamDataSource
      end
      object EmaiSaleOrderEd: TDBAdvEdit
        Left = 152
        Top = 130
        Width = 163
        Height = 21
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        Enabled = True
        TabOrder = 3
        Visible = True
        Version = '2.8.1.3'
        DataField = 'EmailSaleOrder'
        DataSource = Data.SysParamDataSource
      end
      object EmaiRetSaleOrderEd: TDBAdvEdit
        Left = 152
        Top = 158
        Width = 163
        Height = 21
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        Enabled = True
        TabOrder = 4
        Visible = True
        Version = '2.8.1.3'
        DataField = 'EmailRetSaleOrder'
        DataSource = Data.SysParamDataSource
      end
      object EmailLimitEd: TDBAdvEdit
        Left = 152
        Top = 186
        Width = 163
        Height = 21
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        Enabled = True
        TabOrder = 5
        Visible = True
        Version = '2.8.1.3'
        DataField = 'EmailLimit'
        DataSource = Data.SysParamDataSource
      end
    end
    object Proxy: TJvStandardPage
      Left = 0
      Top = 0
      Width = 330
      Height = 285
      Caption = 'Proxy'
      OnShow = ProxyShow
      object Label20: TLabel
        Left = 16
        Top = 48
        Width = 68
        Height = 13
        Caption = 'Proxy '#1089#1077#1088#1074#1077#1088':'
      end
      object Label21: TLabel
        Left = 16
        Top = 75
        Width = 28
        Height = 13
        Caption = #1055#1086#1088#1090':'
      end
      object Label22: TLabel
        Left = 16
        Top = 152
        Width = 73
        Height = 13
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      end
      object Label23: TLabel
        Left = 16
        Top = 187
        Width = 38
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100
      end
      object DBEdit_ProxySRV: TDBEdit
        Left = 100
        Top = 45
        Width = 173
        Height = 21
        DataField = 'ProxySRV'
        DataSource = Data.ParamDataSource
        TabOrder = 0
      end
      object DBCheckBox_UseProxy: TDBCheckBox
        Left = 16
        Top = 17
        Width = 153
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' Proxy'
        DataField = 'UseProxy'
        DataSource = Data.ParamDataSource
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = DBCheckBox_UseProxyClick
      end
      object DBEdit_ProxyPort: TDBEdit
        Left = 100
        Top = 72
        Width = 77
        Height = 21
        DataField = 'ProxyPort'
        DataSource = Data.ParamDataSource
        TabOrder = 2
      end
      object DBCheckBox_UseProxyAutoresation: TDBCheckBox
        Left = 16
        Top = 121
        Width = 217
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1102
        DataField = 'UseProxyAutoresation'
        DataSource = Data.ParamDataSource
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = DBCheckBox_UseProxyAutoresationClick
      end
      object DBEdit_ProxyUser: TDBEdit
        Left = 103
        Top = 149
        Width = 170
        Height = 21
        DataField = 'ProxyUser'
        DataSource = Data.ParamDataSource
        TabOrder = 4
      end
      object DBEdit_ProxyPassword: TDBEdit
        Left = 103
        Top = 184
        Width = 170
        Height = 21
        DataField = 'ProxyPassword'
        DataSource = Data.ParamDataSource
        PasswordChar = '*'
        TabOrder = 5
      end
    end
    object TextAttrPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 330
      Height = 285
      Caption = 'TextAttrPage'
      object Label11: TLabel
        Left = 13
        Top = 19
        Width = 142
        Height = 13
        Caption = #1044#1083#1103' '#1087#1086#1079#1080#1094#1080#1081' "'#1056#1072#1089#1087#1088#1086#1076#1072#1078#1072'"'
        WordWrap = True
      end
      object Label12: TLabel
        Left = 13
        Top = 111
        Width = 135
        Height = 13
        Caption = #1042' '#1079#1072#1074#1080#1089#1080#1084#1086#1089#1090#1080' '#1086#1090' '#1085#1072#1083#1080#1095#1080#1103
      end
      object Label13: TLabel
        Left = 13
        Top = 78
        Width = 151
        Height = 13
        Caption = #1044#1083#1103' '#1087#1086#1079#1080#1094#1080#1081' "'#1053#1077#1090' '#1074' '#1085#1072#1083#1080#1095#1080#1080'"'
        WordWrap = True
      end
      object Bevel4: TBevel
        Left = 13
        Top = 64
        Width = 309
        Height = 2
      end
      object SaleTextEd: TJvComboEdit
        Left = 204
        Top = 16
        Width = 117
        Height = 21
        Alignment = taCenter
        DirectInput = False
        ImageKind = ikEllipsis
        TabOrder = 0
        Text = #1054#1073#1088#1072#1079#1077#1094
        OnButtonClick = SaleTextEdButtonClick
      end
      object TextAttrGrid: TDBGridEh
        Left = 13
        Top = 128
        Width = 225
        Height = 91
        DataSource = Data.MTextAttrDataSource
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghClearSelection, dghDialogFind]
        ReadOnly = True
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnGetCellParams = TextAttrGridGetCellParams
        Columns = <
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'LoHi'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1053#1072#1083#1080#1095#1080#1077
            Width = 80
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'Sample'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1042#1080#1076' '#1090#1077#1082#1089#1090#1072
            Width = 110
          end>
      end
      object AddTextAttrBtn: TBitBtn
        Left = 245
        Top = 128
        Width = 76
        Height = 25
        Action = AddTextAttrAction
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 4
      end
      object DelTextAttrBtn: TBitBtn
        Left = 245
        Top = 156
        Width = 76
        Height = 25
        Action = DelTextAttrAction
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 5
      end
      object EditTextAttrBtn: TBitBtn
        Left = 245
        Top = 184
        Width = 76
        Height = 25
        Action = EditTextAttrAction
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 6
      end
      object NoPresentEd: TJvComboEdit
        Left = 204
        Top = 75
        Width = 117
        Height = 21
        Alignment = taCenter
        DirectInput = False
        ImageKind = ikEllipsis
        TabOrder = 2
        Text = #1054#1073#1088#1072#1079#1077#1094
        OnButtonClick = NoPresentEdButtonClick
      end
      object QCellCheckBox: TDBCheckBox
        Left = 13
        Top = 220
        Width = 260
        Height = 17
        Caption = #1074#1099#1076#1077#1083#1103#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1082#1086#1083#1086#1085#1082#1091' "'#1053#1072#1083#1080#1095#1080#1077'"'
        DataField = 'QCell_color'
        DataSource = Data.ParamDataSource
        TabOrder = 7
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object SCellCheckBox: TDBCheckBox
        Left = 13
        Top = 39
        Width = 211
        Height = 15
        Caption = #1074#1099#1076#1077#1083#1103#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1082#1086#1083#1086#1085#1082#1091' "'#1062#1077#1085#1072'"'
        DataField = 'SCell_color'
        DataSource = Data.ParamDataSource
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        WordWrap = True
      end
      object DBCheckBox21: TDBCheckBox
        Left = 13
        Top = 244
        Width = 260
        Height = 17
        Caption = #1055#1088#1080#1084#1077#1085#1103#1090#1100' '#1082' '#1085#1072#1083#1080#1095#1080#1102' '#1085#1072' '#1089#1082#1083#1072#1076#1077
        DataField = 'bApplyColorQuantsShate'
        DataSource = Data.ParamDataSource
        TabOrder = 8
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox22: TDBCheckBox
        Left = 13
        Top = 261
        Width = 260
        Height = 17
        Caption = #1055#1088#1080#1084#1077#1085#1103#1090#1100' '#1082' '#1085#1072#1083#1080#1095#1080#1102' '#1085#1072' '#1090#1086#1095#1082#1077
        DataField = 'bApplyColorQuantsBase'
        DataSource = Data.ParamDataSource
        TabOrder = 9
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object UpdatePager: TJvStandardPage
      Left = 0
      Top = 0
      Width = 330
      Height = 285
      Caption = 'UpdatePager'
      OnShow = UpdatePagerShow
      object Label24: TLabel
        Left = 80
        Top = 89
        Width = 135
        Height = 13
        Caption = #1045#1089#1083#1080' '#1085#1072#1081#1076#1077#1085#1099' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103
      end
      object PasiveUpdate: TJvDBCheckBox
        Left = 24
        Top = 58
        Width = 265
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077'c'#1082#1080#1081' '#1087#1086#1080#1089#1082' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1081
        DataField = 'bPasiveUpdate'
        DataSource = Data.ParamDataSource
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnChange = PasiveUpdateChange
      end
      object PasiveUpdateProg: TJvDBCheckBox
        Left = 40
        Top = 120
        Width = 97
        Height = 17
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072
        DataField = 'bPasiveUpdateProg'
        DataSource = Data.ParamDataSource
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object PasiveUpdateQuants: TJvDBCheckBox
        Left = 40
        Top = 154
        Width = 97
        Height = 17
        Caption = #1054#1089#1090#1072#1090#1082#1080
        DataField = 'bPasiveUpdateQuants'
        DataSource = Data.ParamDataSource
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object UpdateActions: TJvDBComboBox
        Left = 159
        Top = 118
        Width = 170
        Height = 21
        DataField = 'iUpdateTypeLoad'
        DataSource = Data.ParamDataSource
        ItemHeight = 13
        Items.Strings = (
          #1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1080' '#1086#1073#1085#1086#1074#1080#1090#1100
          #1089#1086#1086#1073#1097#1080#1090#1100)
        TabOrder = 3
        Values.Strings = (
          '0'
          '1')
      end
      object UpdateActionsQuants: TJvDBComboBox
        Left = 160
        Top = 152
        Width = 169
        Height = 21
        DataField = 'iUpdateTypeLoadQuants'
        DataSource = Data.ParamDataSource
        ItemHeight = 13
        Items.Strings = (
          #1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1080' '#1086#1073#1085#1086#1074#1080#1090#1100
          #1089#1086#1086#1073#1097#1080#1090#1100)
        TabOrder = 4
        Values.Strings = (
          '0'
          '1')
      end
      object JvDBCheckBox1: TJvDBCheckBox
        Left = 24
        Top = 24
        Width = 289
        Height = 17
        Caption = #1054#1073#1085#1086#1074#1083#1103#1090#1100' '#1082#1091#1088#1089#1099' '#1074#1072#1083#1102#1090' '#1087#1088#1080' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1080' '#1086#1089#1090#1072#1090#1082#1086#1074
        DataField = 'bUpdateKursesWithQuants'
        DataSource = Data.ParamDataSource
        TabOrder = 5
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object cbHideUpdateReport: TJvDBCheckBox
        Left = 24
        Top = 188
        Width = 265
        Height = 17
        Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1086#1090#1095#1077#1090' '#1086#1073' '#1091#1089#1087#1077#1096#1085#1086#1084' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1080
        DataField = 'Hide_update_report'
        DataSource = Data.ParamDataSource
        TabOrder = 6
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnChange = PasiveUpdateChange
      end
    end
    object TcpPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 330
      Height = 285
      Caption = 'TcpPage'
      object Label16: TLabel
        Left = 30
        Top = 36
        Width = 129
        Height = 13
        Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1087#1088#1086#1074#1077#1088#1082#1080', '#1084#1080#1085':'
      end
      object Label18: TLabel
        Left = 30
        Top = 95
        Width = 129
        Height = 13
        Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1087#1088#1086#1074#1077#1088#1082#1080', '#1084#1080#1085':'
      end
      object Label25: TLabel
        Left = 30
        Top = 153
        Width = 129
        Height = 13
        Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1087#1088#1086#1074#1077#1088#1082#1080', '#1084#1080#1085':'
      end
      object Label28: TLabel
        Left = 165
        Top = 54
        Width = 152
        Height = 12
        Caption = '(0 - '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10640185
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label29: TLabel
        Left = 165
        Top = 113
        Width = 152
        Height = 12
        Caption = '(0 - '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10640185
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label30: TLabel
        Left = 165
        Top = 171
        Width = 152
        Height = 12
        Caption = '(0 - '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10640185
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label31: TLabel
        Left = 30
        Top = 212
        Width = 129
        Height = 13
        Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1087#1088#1086#1074#1077#1088#1082#1080', '#1084#1080#1085':'
      end
      object Label32: TLabel
        Left = 165
        Top = 230
        Width = 152
        Height = 12
        Caption = '(0 - '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10640185
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object DBCheckBox10: TDBCheckBox
        Left = 15
        Top = 72
        Width = 291
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1086#1083#1091#1095#1072#1090#1100' TCP '#1086#1090#1074#1077#1090#1099' '#1087#1086' '#1079#1072#1082#1072#1079#1072#1084
        DataField = 'AutoCheckOrders'
        DataSource = Data.ParamDataSource
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox11: TDBCheckBox
        Left = 15
        Top = 13
        Width = 291
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1086#1083#1091#1095#1072#1090#1100' '#1089#1082#1080#1076#1082#1080' '#1087#1086' TCP'
        DataField = 'AutoCheckDiscounts'
        DataSource = Data.ParamDataSource
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox12: TDBCheckBox
        Left = 15
        Top = 130
        Width = 291
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1088#1086#1074#1077#1088#1103#1090#1100' '#1089#1090#1072#1090#1091#1089#1099' '#1079#1072#1082#1072#1079#1086#1074
        DataField = 'AutoCheckStatuses'
        DataSource = Data.ParamDataSource
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBEdit1: TDBEdit
        Left = 165
        Top = 33
        Width = 79
        Height = 21
        DataField = 'AutoCheckDiscountsInt'
        DataSource = Data.ParamDataSource
        TabOrder = 3
      end
      object DBEdit2: TDBEdit
        Left = 165
        Top = 92
        Width = 79
        Height = 21
        DataField = 'AutoCheckOrdersInt'
        DataSource = Data.ParamDataSource
        TabOrder = 4
      end
      object DBEdit3: TDBEdit
        Left = 165
        Top = 150
        Width = 79
        Height = 21
        DataField = 'AutoCheckStatusesInt'
        DataSource = Data.ParamDataSource
        TabOrder = 5
      end
      object DBCheckBox13: TDBCheckBox
        Left = 15
        Top = 189
        Width = 291
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1086#1083#1091#1095#1072#1090#1100' '#1085#1086#1074#1086#1089#1090#1080
        DataField = 'AutoCheckRss'
        DataSource = Data.ParamDataSource
        TabOrder = 6
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBEdit4: TDBEdit
        Left = 165
        Top = 209
        Width = 79
        Height = 21
        DataField = 'AutoCheckRssInt'
        DataSource = Data.ParamDataSource
        TabOrder = 7
      end
      object DBCheckBox14: TDBCheckBox
        Left = 30
        Top = 241
        Width = 236
        Height = 17
        Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1086#1074#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1086#1083#1091#1095#1077#1085#1080#1080' '#1085#1086#1074#1099#1093
        DataField = 'bShowRssOnUpdate'
        DataSource = Data.ParamDataSource
        TabOrder = 8
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object OtherPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 330
      Height = 285
      Caption = 'OtherPage'
      object Label10: TLabel
        Left = 3
        Top = 21
        Width = 102
        Height = 28
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1055#1088#1080' '#1089#1084#1077#1085#1077' '#1092#1080#1083#1100#1090#1088#1072
        WordWrap = True
      end
      object Label14: TLabel
        Left = 4
        Top = 43
        Width = 101
        Height = 33
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1089#1077#1090#1077#1074#1086#1075#1086' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103', '#1084#1089
        WordWrap = True
      end
      object Label15: TLabel
        Left = 3
        Top = 74
        Width = 102
        Height = 28
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074' '#1082#1072#1090#1072#1083#1086#1075#1077' '#1079#1072#1082#1072#1079#1086#1074
        WordWrap = True
      end
      object lbTvr: TLabel
        Left = 8
        Top = 266
        Width = 113
        Height = 13
        Cursor = crHandPoint
        Caption = #1058#1077#1093#1087#1086#1076#1076#1077#1088#1078#1082#1072' '#1086#1085#1083#1072#1081#1085
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        Visible = False
        OnClick = lbTvrClick
      end
      object Label43: TLabel
        Left = 8
        Top = 251
        Width = 227
        Height = 13
        Caption = #1055#1088#1086#1089#1084#1072#1090#1088#1080#1074#1072#1090#1100' '#1079#1072#1082#1072#1079#1099' '#1079#1072' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1076#1085#1080':'
      end
      object FiltComboBox: TJvDBComboBox
        Left = 111
        Top = 18
        Width = 211
        Height = 21
        DataField = 'Filt_range'
        DataSource = Data.ParamDataSource
        ItemHeight = 13
        Items.Strings = (
          #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1077#1089#1100' '#1082#1072#1090#1072#1083#1086#1075
          #1086#1089#1090#1072#1074#1072#1090#1100#1089#1103' '#1074' '#1074#1077#1090#1074#1080' '#1076#1077#1088#1077#1074#1072)
        TabOrder = 0
        Values.Strings = (
          '0'
          '1')
      end
      object NetIntervEd: TDBEdit
        Left = 111
        Top = 47
        Width = 79
        Height = 21
        DataField = 'Net_interv'
        DataSource = Data.ParamDataSource
        TabOrder = 1
      end
      object CliIdModeComboBox: TJvDBComboBox
        Left = 111
        Top = 77
        Width = 211
        Height = 21
        DataField = 'Cli_id_mode'
        DataSource = Data.ParamDataSource
        ItemHeight = 13
        Items.Strings = (
          #1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1082#1083#1080#1077#1085#1090#1072
          #1086#1087#1080#1089#1072#1085#1080#1077' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088#1072)
        TabOrder = 2
        Values.Strings = (
          '0'
          '1')
      end
      object DBCheckBox3: TDBCheckBox
        Left = 8
        Top = 108
        Width = 281
        Height = 17
        Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1082#1086#1088#1079#1080#1085#1091' '#1089' '#1094#1077#1085#1072#1084#1080
        DataField = 'bSaveWithPrice'
        DataSource = Data.ParamDataSource
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox4: TDBCheckBox
        Left = 8
        Top = 131
        Width = 265
        Height = 17
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086#1079#1080#1094#1080#1080' '#1087#1086' '#1082#1086#1076#1091' '#1074' '#1092#1072#1081#1083#1077' '#1079#1072#1082#1072#1079#1072
        DataField = 'bSortOrderDet'
        DataSource = Data.ParamDataSource
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox5: TDBCheckBox
        Left = 8
        Top = 154
        Width = 168
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1073#1077#1075#1091#1097#1091#1102' '#1089#1090#1088#1086#1082#1091
        DataField = 'bVisibleRunningLine'
        DataSource = Data.ParamDataSource
        TabOrder = 5
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object JvComboEdit1: TJvComboEdit
        Left = 187
        Top = 154
        Width = 117
        Height = 21
        Alignment = taCenter
        DirectInput = False
        ImageKind = ikEllipsis
        TabOrder = 6
        Text = #1094#1074#1077#1090' '#1089#1090#1088#1086#1082#1080
        OnButtonClick = JvComboEdit1ButtonClick
        OnKeyPress = JvComboEdit1KeyPress
      end
      object DBCheckBox7: TDBCheckBox
        Left = 8
        Top = 177
        Width = 265
        Height = 17
        Caption = #1057#1082#1088#1099#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1080#1079' '#1089#1090#1088#1086#1082#1080' '#1089#1090#1072#1090#1091#1089#1072
        DataField = 'Hide_discountSB'
        DataSource = Data.ParamDataSource
        TabOrder = 7
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBCheckBox8: TDBCheckBox
        Left = 8
        Top = 200
        Width = 265
        Height = 17
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074#1089#1077' '#1079#1072#1082#1072#1079#1099' '#1080' '#1074#1086#1079#1074#1088#1072#1090#1099
        DataField = 'ShowAllOrders'
        DataSource = Data.ParamDataSource
        TabOrder = 8
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = DBCheckBox8Click
      end
      object DBCheckBox9: TDBCheckBox
        Left = 26
        Top = 218
        Width = 285
        Height = 26
        Caption = 
          #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1077#1088#1077#1082#1083#1102#1095#1072#1090#1100#1089#1103' '#1085#1072' '#1082#1083#1080#1077#1085#1090#1072' '#1091#1082#1072#1079#1072#1085#1085#1086#1075#1086' '#1074' '#1079#1072#1082#1072#1079#1077'/'#1074#1086#1079#1074#1088 +
          #1072#1090#1077
        DataField = 'AutoSwitchCurClient'
        DataSource = Data.ParamDataSource
        TabOrder = 9
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        WordWrap = True
      end
      object SetDateRate: TDBEdit
        Left = 241
        Top = 248
        Width = 59
        Height = 21
        DataField = 'SetDateRate'
        DataSource = Data.ParamDataSource
        MaxLength = 4
        TabOrder = 10
      end
    end
    object SkladPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 330
      Height = 285
      Caption = 'SkladPage'
      object GroupBox1: TGroupBox
        Left = 10
        Top = 3
        Width = 311
        Height = 162
        Caption = #1042#1099#1076#1077#1083#1077#1085#1080#1077' '#1094#1074#1077#1090#1086#1084
        TabOrder = 0
        object Label33: TLabel
          Left = 15
          Top = 18
          Width = 134
          Height = 13
          Caption = #1054#1082#1085#1086' "'#1047#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'"'
        end
        object Label34: TLabel
          Left = 15
          Top = 41
          Width = 145
          Height = 13
          Caption = #1054#1082#1085#1086' "'#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'"'
        end
        object Label35: TLabel
          Left = 15
          Top = 64
          Width = 128
          Height = 13
          Caption = #1054#1082#1085#1086' "'#1055#1088#1086#1076#1072#1078#1072' '#1082#1083#1080#1077#1085#1090#1091'"'
        end
        object Label36: TLabel
          Left = 15
          Top = 87
          Width = 128
          Height = 13
          Caption = #1054#1082#1085#1086' "'#1042#1086#1079#1074#1088#1072#1090' '#1087#1088#1086#1076#1072#1078#1080'"'
        end
        object Label37: TLabel
          Left = 15
          Top = 109
          Width = 80
          Height = 13
          Caption = #1054#1082#1085#1086' "'#1051#1080#1084#1080#1090#1099'"'
        end
        object Label38: TLabel
          Left = 15
          Top = 135
          Width = 118
          Height = 13
          Caption = #1050#1086#1083#1086#1085#1082#1072' '#1090#1077#1082#1091#1097#1077#1081' '#1073#1072#1079#1099
        end
        object edColorOrder: TJvComboEdit
          AlignWithMargins = True
          Left = 176
          Top = 15
          Width = 120
          Height = 21
          Glyph.Data = {
            4E000000424D4E000000000000003E000000280000000F000000040000000100
            010000000000100000000000000000000000020000000200000000000000FFFF
            FF00FFFE00009CE600009CE60000FFFE0000}
          TabOrder = 0
          OnButtonClick = edColorOrderButtonClick
        end
        object edColorRetdoc: TJvComboEdit
          AlignWithMargins = True
          Left = 176
          Top = 38
          Width = 120
          Height = 21
          Glyph.Data = {
            4E000000424D4E000000000000003E000000280000000F000000040000000100
            010000000000100000000000000000000000020000000200000000000000FFFF
            FF00FFFE00009CE600009CE60000FFFE0000}
          TabOrder = 1
          OnButtonClick = edColorOrderButtonClick
        end
        object edColorSaleOrder: TJvComboEdit
          AlignWithMargins = True
          Left = 176
          Top = 61
          Width = 120
          Height = 21
          Glyph.Data = {
            4E000000424D4E000000000000003E000000280000000F000000040000000100
            010000000000100000000000000000000000020000000200000000000000FFFF
            FF00FFFE00009CE600009CE60000FFFE0000}
          TabOrder = 2
          OnButtonClick = edColorOrderButtonClick
        end
        object edColorSaleRetdoc: TJvComboEdit
          AlignWithMargins = True
          Left = 176
          Top = 84
          Width = 120
          Height = 21
          Glyph.Data = {
            4E000000424D4E000000000000003E000000280000000F000000040000000100
            010000000000100000000000000000000000020000000200000000000000FFFF
            FF00FFFE00009CE600009CE60000FFFE0000}
          TabOrder = 3
          OnButtonClick = edColorOrderButtonClick
        end
        object edColorLimit: TJvComboEdit
          AlignWithMargins = True
          Left = 176
          Top = 107
          Width = 120
          Height = 21
          Glyph.Data = {
            4E000000424D4E000000000000003E000000280000000F000000040000000100
            010000000000100000000000000000000000020000000200000000000000FFFF
            FF00FFFE00009CE600009CE60000FFFE0000}
          TabOrder = 4
          OnButtonClick = edColorOrderButtonClick
        end
        object edColorCurBase: TJvComboEdit
          AlignWithMargins = True
          Left = 176
          Top = 132
          Width = 120
          Height = 21
          Glyph.Data = {
            4E000000424D4E000000000000003E000000280000000F000000040000000100
            010000000000100000000000000000000000020000000200000000000000FFFF
            FF00FFFE00009CE600009CE60000FFFE0000}
          TabOrder = 5
          Text = #1054#1073#1088#1072#1079#1077#1094
          OnButtonClick = edColorCurBaseButtonClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 10
        Top = 170
        Width = 311
        Height = 106
        Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1085#1077#1087#1091#1089#1090#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
        TabOrder = 1
        object DBCheckBox15: TDBCheckBox
          Left = 15
          Top = 16
          Width = 266
          Height = 17
          Caption = #1044#1086#1082#1091#1084#1077#1085#1090' "'#1047#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'"'
          DataField = 'ToForbidRemovalOrder'
          DataSource = Data.ParamDataSource
          TabOrder = 0
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object DBCheckBox16: TDBCheckBox
          Left = 15
          Top = 33
          Width = 266
          Height = 17
          Caption = #1044#1086#1082#1091#1084#1077#1085#1090' "'#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'"'
          DataField = 'ToForbidReturnDocPost'
          DataSource = Data.ParamDataSource
          TabOrder = 1
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object DBCheckBox17: TDBCheckBox
          Left = 15
          Top = 50
          Width = 266
          Height = 17
          Caption = #1044#1086#1082#1091#1084#1077#1085#1090' "'#1055#1088#1086#1076#1072#1078#1072' '#1082#1083#1080#1077#1085#1090#1091'"'
          DataField = 'ToForbidSalelOrder'
          DataSource = Data.ParamDataSource
          TabOrder = 2
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object DBCheckBox18: TDBCheckBox
          Left = 15
          Top = 67
          Width = 266
          Height = 17
          Caption = #1044#1086#1082#1091#1084#1077#1085#1090' "'#1042#1086#1079#1074#1088#1072#1090' '#1087#1088#1086#1076#1072#1078#1080'"'
          DataField = 'ToForbidReturnOrder'
          DataSource = Data.ParamDataSource
          TabOrder = 3
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object DBCheckBox19: TDBCheckBox
          Left = 15
          Top = 84
          Width = 266
          Height = 17
          Caption = #1044#1086#1082#1091#1084#1077#1085#1090' "'#1051#1080#1084#1080#1090'"'
          DataField = 'ToForbidLimit'
          DataSource = Data.ParamDataSource
          TabOrder = 4
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
      end
    end
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'Param\'
    StoredValues = <>
    Left = 40
    Top = 176
  end
  object FormStyler: TAdvFormStyler
    AutoThemeAdapt = False
    Style = tsOffice2003Blue
    AppStyle = Main.AppStyler
    Left = 105
    Top = 173
  end
  object ActionList: TActionList
    Left = 40
    Top = 224
    object AddTextAttrAction: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = TextAttrActionExecute
    end
    object DelTextAttrAction: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = TextAttrActionExecute
    end
    object EditTextAttrAction: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnExecute = TextAttrActionExecute
    end
  end
  object ColorDialog: TColorDialog
    Left = 80
    Top = 224
  end
  object TestQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    FilterOptions = [foCaseInsensitive]
    DatabaseName = 'DATA'
    EngineVersion = '4.24 Build 1'
    MaxRowCount = -1
    SQL.Strings = (
      'SELECT * FROM [002]')
    Params = <>
    Left = 120
    Top = 584
  end
end
