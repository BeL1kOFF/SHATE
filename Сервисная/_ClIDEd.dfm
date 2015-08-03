inherited ClientIDEdit: TClientIDEdit
  Width = 403
  Height = 800
  AutoScroll = True
  BorderStyle = bsSizeable
  Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1082#1083#1080#1077#1085#1090#1072
  Constraints.MinHeight = 500
  Constraints.MinWidth = 390
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  ExplicitWidth = 403
  ExplicitHeight = 800
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel4: TBevel [0]
    Left = 2
    Top = 3
    Width = 380
    Height = 284
    Anchors = [akLeft, akTop, akRight]
  end
  object Bevel1: TBevel [1]
    Left = 0
    Top = 0
    Width = 387
    Height = 289
    Align = alTop
    Shape = bsSpacer
    ExplicitTop = 1
  end
  object Bevel2: TBevel [2]
    Left = 0
    Top = 725
    Width = 387
    Height = 37
    Align = alBottom
    Shape = bsSpacer
    ExplicitWidth = 383
  end
  inherited BtnBevel: TBevel
    Left = -1
    Top = 727
    Width = 380
    Height = 0
    Visible = False
    ExplicitLeft = -1
    ExplicitTop = 727
    ExplicitWidth = 376
    ExplicitHeight = 0
  end
  object Label1: TLabel [4]
    Left = 4
    Top = 11
    Width = 83
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
  end
  object Label2: TLabel [5]
    Left = 6
    Top = 34
    Width = 81
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  object Label3: TLabel [6]
    Left = 30
    Top = 411
    Width = 82
    Height = 29
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1058#1080#1087' '#1079#1072#1082#1072#1079#1072' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    Visible = False
    WordWrap = True
  end
  object Label4: TLabel [7]
    Left = 34
    Top = 82
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1086#1089#1090#1072#1074#1082#1072
  end
  object Label5: TLabel [8]
    Left = 56
    Top = 57
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'E-mail'
  end
  object Label6: TLabel [9]
    Left = 58
    Top = 105
    Width = 26
    Height = 13
    Alignment = taRightJustify
    Caption = #1050#1083#1102#1095
  end
  object Label11: TLabel [10]
    Left = 57
    Top = 131
    Width = 27
    Height = 13
    Caption = #1060#1048#1054
  end
  object Label12: TLabel [11]
    Left = 39
    Top = 154
    Width = 45
    Height = 13
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object Label13: TLabel [12]
    Left = 86
    Top = 146
    Width = 7
    Height = 24
    Hint = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
    Caption = '*'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label14: TLabel [13]
    Left = 86
    Top = 122
    Width = 7
    Height = 24
    Hint = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
    Caption = '*'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label15: TLabel [14]
    Left = 86
    Top = 49
    Width = 7
    Height = 24
    Hint = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
    Caption = '*'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label16: TLabel [15]
    Left = 86
    Top = 3
    Width = 7
    Height = 24
    Hint = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
    Caption = '*'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object lbEditData: TLabel [16]
    Left = 117
    Top = 255
    Width = 146
    Height = 13
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    Visible = False
    OnClick = lbEditDataClick
  end
  object Label10: TLabel [17]
    Left = 8
    Top = 196
    Width = 76
    Height = 26
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' '#1087#1086' '#13#10'    '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    FocusControl = btConfigProfit
  end
  object Label17: TLabel [18]
    Left = 28
    Top = 230
    Width = 56
    Height = 26
    Caption = #1040#1076#1088#1077#1089' '#1087#1086#13#10#1091#1084#1086#1083#1095#1072#1085#1080#1102
    FocusControl = btConfigProfit
  end
  object Label18: TLabel [19]
    Left = 86
    Top = 223
    Width = 7
    Height = 24
    Hint = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
    Caption = '*'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  inherited OkBtn: TBitBtn
    Left = 155
    Top = 733
    ModalResult = 0
    TabOrder = 8
    ExplicitLeft = 155
    ExplicitTop = 733
  end
  inherited CancelBtn: TBitBtn
    Left = 284
    Top = 733
    Cancel = False
    TabOrder = 9
    OnClick = CancelBtnClick
    ExplicitLeft = 284
    ExplicitTop = 733
  end
  object ClientIdEd: TDBEdit
    Left = 92
    Top = 8
    Width = 266
    Height = 21
    DataField = 'Client_ID'
    TabOrder = 0
    OnExit = ClientIdEdExit
  end
  object DescriptionEd: TDBEdit
    Left = 92
    Top = 31
    Width = 266
    Height = 21
    DataField = 'Description'
    TabOrder = 1
    OnExit = DescriptionEdExit
  end
  object TypeComboBox: TJvDBComboBox
    Left = 118
    Top = 414
    Width = 169
    Height = 21
    DataField = 'Order_type'
    ItemHeight = 13
    Items.Strings = (
      #1086#1089#1085#1086#1074#1085#1086#1081
      #1076#1086#1087#1086#1083#1085#1080#1090'.')
    TabOrder = 3
    Values.Strings = (
      'A'
      'B')
    Visible = False
  end
  object DeliveryComboBox: TJvDBComboBox
    Left = 92
    Top = 79
    Width = 169
    Height = 21
    DataField = 'Delivery'
    ItemHeight = 13
    Items.Strings = (
      #1076#1086#1089#1090#1072#1074#1082#1072
      #1089#1072#1084#1086#1074#1099#1074#1086#1079
      #1089#1087#1088#1072#1096#1080#1074#1072#1090#1100)
    TabOrder = 4
    Values.Strings = (
      '1'
      '2'
      '3')
  end
  object Email_Edit: TDBEdit
    Left = 93
    Top = 56
    Width = 265
    Height = 21
    DataField = 'Email'
    TabOrder = 2
    OnExit = Email_EditExit
  end
  object Key_Edit: TDBEdit
    Left = 92
    Top = 102
    Width = 266
    Height = 21
    DataField = 'Key'
    PasswordChar = '*'
    TabOrder = 5
    OnExit = Key_EditExit
    OnKeyDown = Key_EditKeyDown
  end
  object SaveToFile_BitBtn: TBitBtn
    Left = 292
    Top = 414
    Width = 28
    Height = 25
    Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Visible = False
    OnClick = SaveToFile_BitBtnClick
    Glyph.Data = {
      AA030000424DAA03000000000000360000002800000011000000110000000100
      1800000000007403000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF97433F97433FB59A9B
      B59A9BB59A9BB59A9BB59A9BB59A9BB59A9B93303097433FFFFFFFFFFFFFFFFF
      FF00FFFFFFFFFFFF97433FD66868C66060E5DEDF92292A92292AE4E7E7E0E3E6
      D9DFE0CCC9CC8F201FAF464697433FFFFFFFFFFFFF00FFFFFFFFFFFF97433FD0
      6566C25F5FE9E2E292292A92292AE2E1E3E2E6E8DDE2E4CFCCCF8F2222AD4646
      97433FFFFFFFFFFFFF00FFFFFFFFFFFF97433FD06565C15D5DECE4E492292A92
      292ADFDDDFE1E6E8E0E5E7D3D0D28A1E1EAB444497433FFFFFFFFFFFFF00FFFF
      FFFFFFFF97433FD06565C15B5CEFE6E6EDE5E5E5DEDFE0DDDFDFE0E2E0E1E3D6
      D0D2962A2AB24A4A97433FFFFFFFFFFFFF00FFFFFFFFFFFF97433FCD6263C860
      60C96767CC7272CA7271C66969C46464CC6D6CCA6667C55D5DCD656597433FFF
      FFFFFFFFFF00FFFFFFFFFFFF97433FB65553C27B78D39D9CD7A7A5D8A7A6D8A6
      A5D7A09FD5A09FD7A9A7D8ABABCC666797433FFFFFFFFFFFFF00FFFFFFFFFFFF
      97433FCC6667F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9
      F9CC666797433FFFFFFFFFFFFF00FFFFFFFFFFFF97433FCC6667F9F9F9F9F9F9
      F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9CC666797433FFFFFFFFFFF
      FF00FFFFFFFFFFFF97433FCC6667F9F9F9CDCDCDCDCDCDCDCDCDCDCDCDCDCDCD
      CDCDCDCDCDCDF9F9F9CC666797433FFFFFFFFFFFFF00FFFFFFFFFFFF97433FCC
      6667F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9CC6667
      97433FFFFFFFFFFFFF00FFFFFFFFFFFF97433FCC6667F9F9F9CDCDCDCDCDCDCD
      CDCDCDCDCDCDCDCDCDCDCDCDCDCDF9F9F9CC666797433FFFFFFFFFFFFF00FFFF
      FFFFFFFF97433FCC6667F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9
      F9F9F9F9F9CC666797433FFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF97433FF9F9
      F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F997433FFFFFFFFF
      FFFFFFFFFF00FFFFFFFFFFFFFFFFFFCD6263CD6263CD6263CD6263CD6263CD62
      63CD6263CD6263CD6263CD6263CD6263FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF00}
  end
  object LoadFromFile_BitBtn: TBitBtn
    Left = 319
    Top = 414
    Width = 28
    Height = 25
    Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Visible = False
    OnClick = LoadFromFile_BitBtnClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00C058
      5900A5787800CBBEBC00F1EEEB00E5E6E500A3575600A53F3F00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00C4716D00CD64
      6400A46868009D454400E5D9D800FFFFFF00A9585700A63B3A00B55C5D00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00C3726E00CB60
      6100B57A7A009F555400B1A1A000F1EDEB0005720A0005720A00087F0F000572
      0A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00C16F6B00C559
      5A00C8717100CB807F00C3727200CA787800C76D6D00C865650005720A000C99
      18000A90140005720A00FF00FF00FF00FF00FF00FF00FF00FF00B6635E00D09C
      9A00EEDCDC00EEDCDA00EFDAD800EED8D700EFE3E100D38D8C00AE4E4F000572
      0A000FA31B000A92150005720A00FF00FF00FF00FF00FF00FF00B6635D00E6CC
      CA00F3F8F700EAE8E800EBEAE900EBEBEA00F2F6F500D28F8E00AD4C4D00B781
      830005720A0011A9200005720A00B7818300B7818300B7818300B6635E00E4C5
      C400E6E7E600DBD7D700DDD9D900DBD9D800E8E9E900D28E8E00AD4C4D00FAE7
      C60005720A001FB6350005720A00F3D29800F9DB9B00B7818300B7645E00E6C7
      C700EFEFEE00E4E1E000E6E2E100E5E2E100F0EFEE00D5918F0005720A000572
      0A0005720A0033C5520005720A0005720A0005720A00B7818300FF00FF00D2B6
      B500E6E7E700E2DCDC00E2DDDD00E2DDDE00E5E5E400C285840005720A0034B3
      510053DB800046D16C002BBB45001EA5300005720A00B7818300FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CAA39800FDFAF7000572
      0A0048CB700060ED940030B34B0005720A00F6DBAC00B7818300FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00D1A69300FEFDFC00FEF9
      F50005720A003CBB5D0005720A00F5DDC100FBE2BA00B7818300FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00E2B89800FEFDFD00FFFF
      FF00FEF9F50005720A00F9EAD900FDEDD500F4E6C700B7818300FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00E7BD9C00FEFDFD00FFFF
      FF00FFFFFE00FDF9F500FCF3E800B5837800B5837800B7818300FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EBC39F00FFFEFE00FFFF
      FF00FFFFFF00FFFFFF00FAF7F400B5837800E8AA6100CD8C6200FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00F0C8A100FCF7F300FCF7
      F400FCF7F400FBF8F600F6F0EF00B5837800D59E7D00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EDC49A00DDAE9400E0B3
      9600DCA88700DCA88700DCA88700B5837800FF00FF00FF00FF00}
  end
  object cbShowPassword: TCheckBox
    Left = 268
    Top = 83
    Width = 72
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 10
    Visible = False
    OnClick = cbShowPasswordClick
  end
  object pnDiscounts: TPanel
    Left = 0
    Top = 289
    Width = 387
    Height = 436
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 3
    TabOrder = 11
    DesignSize = (
      387
      436)
    object Bevel3: TBevel
      Left = 5
      Top = 399
      Width = 377
      Height = 32
      Align = alBottom
      Shape = bsSpacer
      ExplicitTop = 309
      ExplicitWidth = 372
    end
    object Label7: TLabel
      Left = 5
      Top = 5
      Width = 377
      Height = 14
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1082#1080#1076#1086#1082'/'#1085#1072#1094#1077#1085#1086#1082
      Color = clSilver
      ParentColor = False
      Transparent = False
      ExplicitTop = -3
      ExplicitWidth = 372
    end
    object Discaunt_Tree: TVirtualStringTree
      Left = 5
      Top = 121
      Width = 377
      Height = 278
      Align = alClient
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      PopupMenu = pmTree
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      OnCompareNodes = Discaunt_TreeCompareNodes
      OnDblClick = Discaunt_TreeDblClick
      OnFreeNode = Discaunt_TreeFreeNode
      OnGetText = Discaunt_TreeGetText
      OnKeyPress = Discaunt_TreeKeyPress
      OnMeasureItem = Discaunt_TreeMeasureItem
      Columns = <
        item
          Position = 0
          Width = 313
          WideText = #1043#1088#1091#1087#1087#1072'\'#1055#1086#1076#1075#1088#1091#1087#1087#1072'\'#1041#1088#1077#1085#1076
        end
        item
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus]
          Position = 1
          Width = 60
          WideText = #1057#1082#1080#1076#1082#1072
        end
        item
          Position = 2
          Width = 60
          WideText = #1053#1072#1094#1077#1085#1082#1072
        end>
      WideDefaultText = ''
    end
    object TabView: TTabControl
      Left = 5
      Top = 99
      Width = 377
      Height = 22
      Align = alTop
      MultiLine = True
      TabOrder = 1
      Tabs.Strings = (
        #1055#1086' '#1075#1088#1091#1087#1087#1072#1084
        #1055#1086' '#1073#1088#1077#1085#1076#1072#1084)
      TabIndex = 0
      OnChange = TabViewChange
    end
    object UpNullMargin: TButton
      Left = 7
      Top = 403
      Width = 105
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1054#1073#1085#1091#1083#1080#1090#1100' '#1085#1072#1094#1077#1085#1082#1080
      TabOrder = 2
      OnClick = UpNullMarginClick
    end
    object UpNullDiscount: TButton
      Left = 118
      Top = 403
      Width = 98
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1054#1073#1085#1091#1083#1080#1090#1100' '#1089#1082#1080#1076#1082#1080
      TabOrder = 3
      OnClick = UpNullDiscountClick
    end
    object Panel1: TPanel
      Left = 5
      Top = 19
      Width = 377
      Height = 80
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
      object Label8: TLabel
        Left = 8
        Top = 30
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1073#1097#1072#1103' '#1089#1082#1080#1076#1082#1072
        Visible = False
      end
      object Label9: TLabel
        Left = 8
        Top = 6
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = #1056#1077#1078#1080#1084' '#1089#1082#1080#1076#1086#1082
      end
      object edDiscGlobal: TEdit
        Left = 92
        Top = 27
        Width = 78
        Height = 21
        TabOrder = 0
        Visible = False
        OnChange = edDiscGlobalChange
        OnExit = edDiscGlobalExit
      end
      object cbDiscountsMode: TJvDBComboBox
        Left = 92
        Top = 3
        Width = 264
        Height = 21
        DataField = 'UpdateDisc'
        ItemHeight = 13
        Items.Strings = (
          #1057#1082#1080#1076#1082#1080' '#1064#1072#1090#1077'-'#1052
          #1054#1073#1097#1072#1103' '#1089#1082#1080#1076#1082#1072)
        TabOrder = 1
        Values.Strings = (
          'False'
          'True')
        OnChange = cbDiscountsModeChange
      end
      object btConfigProfit: TBitBtn
        Left = 267
        Top = 56
        Width = 89
        Height = 25
        Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1082#1080#1076#1082#1080' '#1087#1086' TCP'
        Caption = #1053#1072#1089#1090#1088#1086#1080#1090#1100
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        OnClick = btConfigProfitClick
        Glyph.Data = {
          FA020000424DFA02000000000000FA0100002800000010000000100000000100
          08000000000000010000120B0000120B0000710000007100000000000000FFFF
          FF003733470024232500FF00FF0038343500413B3B00484343002D2A2A00413D
          3D005A5757005B5959005F5E5E008957540089575300AD706B00B4766D00BB7D
          6E007E5F58005C4742004D494800C4866F00CA8C7200F6EBE600D19373008280
          7F00D79F8000D19D8000D7997400D8A18100DA9D7500F8EEE700E7AB7900AC8C
          6F00F8CBA1009C7F66009A7E6500F7CBA300F6CBA300E1CAB500E2CCB8009184
          7800C6B6A700F6CA9D00EEC29800F6CBA000F3C99F00F3CFAA00F7D5B200F6D5
          B500F6DCC200F4DAC000E1CBB500E1CBB600C1AF9D00E2CFBC00E1CEBB00D4C2
          B100E7D5C400D4B79700F3D7B800F3D9BC00EED5BA00E1CBB400F6E2CC00E1D4
          C600E7D5BD00EDDECA00EFE1CE00EFE3D300F2E6D700FBF7F200EDDDC700F7EF
          E300EDDEC700F6E7CE00918B8000F8EEDD00F0E3CB00F3E6CE00FAF6EE00D1C9
          B700F7F3EA00FBFBFA008FE2F000BCEAF300B4E5F30062B4E0007FB1CE0053AF
          ED0053ACEA004399E5004398E3004397E2004F7EAF003481DC00787D83004074
          B70041628E003B57810024428300273F73008890A40021346A002A3B69003B52
          8E0045465B0076767700FBFBFC00FEFEFE00EDEDED00737373003A3A3A000404
          04040404040404040404040404040E0E0D0E0E0E0E0E0E0E0404040404040E3A
          3728343F2735420E0404040404040F4D46454443484A4B0E0404040404041049
          3022252D2B2F4F0E04040404040411524032333D3C3E4E0E0404040404041550
          312E26222C3B510E0404040404041647412A393836294C120404040404041853
          6624232163626A130404040908081C6D6363196357636802046B700903061E01
          6355635763576365676B6009050620016C6355635763575C5F6B6E091407201F
          1F17635463575A5D5F6B6E090A0B201A1D1D1B635856595B646B6E096F6F0404
          04040404045E6169046B6B096F0C04040404040404040404040404090909}
      end
      object cbDiffProfit: TDBCheckBox
        Left = 10
        Top = 56
        Width = 251
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1076#1080#1092#1092#1077#1088#1077#1085#1094#1080#1088#1086#1074#1072#1085#1085#1091#1102' '#1085#1072#1094#1077#1085#1082#1091
        DataField = 'UseDiffMargin'
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = cbDiffProfitClick
      end
    end
  end
  object Name: TDBEdit
    Left = 93
    Top = 126
    Width = 265
    Height = 21
    DataField = 'Name'
    TabOrder = 12
    OnExit = NameExit
    OnKeyPress = NameKeyPress
  end
  object Phone1: TDBEdit
    Left = 11
    Top = 123
    Width = 44
    Height = 21
    DataField = 'Phone'
    TabOrder = 13
    Visible = False
    OnExit = Phone1Exit
    OnKeyPress = Phone1KeyPress
  end
  object edIdExample: TEdit
    Left = 93
    Top = 7
    Width = 265
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 14
    Text = #1050#1086#1076' '#1082#1083#1080#1077#1085#1090#1072' '#1076#1083#1103' '#1089#1077#1088#1074#1080#1089#1085#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    OnClick = edIdExampleClick
  end
  object edDescrExample: TEdit
    Left = 93
    Top = 31
    Width = 265
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 15
    Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080' ('#1085#1077' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1086')'
    OnClick = edDescrExampleClick
  end
  object edEMailExample: TEdit
    Left = 93
    Top = 56
    Width = 265
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 16
    Text = #1055#1086#1095#1090#1072' '#1076#1083#1103' '#1086#1090#1074#1077#1090#1086#1074' '#1087#1086' '#1079#1072#1082#1072#1079#1072#1084'\'#1074#1086#1079#1074#1088#1072#1090#1072#1084
    OnClick = edEMailExampleClick
  end
  object edKeyExample: TEdit
    Left = 92
    Top = 102
    Width = 265
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 17
    Text = #1055#1072#1088#1086#1083#1100' ('#1073#1099#1083' '#1074#1099#1089#1083#1072#1085' '#1085#1072' '#1087#1086#1095#1090#1091')'
    OnClick = edKeyExampleClick
  end
  object edNameExample: TEdit
    Left = 93
    Top = 126
    Width = 265
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 18
    Text = #1060#1086#1088#1084#1072#1090': '#1048#1074#1072#1085#1086#1074' '#1048'.'#1048'.'
    OnClick = edNameExampleClick
  end
  object edPhoneExample: TEdit
    Left = 8
    Top = 101
    Width = 47
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 19
    Text = #1060#1086#1088#1084#1072#1090': +375297776655'
    Visible = False
    OnClick = edPhoneExampleClick
  end
  object ContractMaskEd: TEdit
    Left = 93
    Top = 201
    Width = 242
    Height = 21
    ReadOnly = True
    TabOrder = 21
    OnExit = ContractMaskEdExit
  end
  object SetContractBt: TButton
    Left = 337
    Top = 203
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 22
    OnClick = SetContractBtClick
  end
  object ClearAgrBtn: TAdvGlowButton
    Left = 357
    Top = 203
    Width = 22
    Height = 24
    Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1077' "'#1050#1083#1080#1077#1085#1090'"'
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clWindowText
    NotesFont.Height = -11
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    Picture.Data = {
      424D380300000000000036000000280000001000000010000000010018000000
      000000000000120B0000120B00000000000000000000FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      0732DE0732DEFF00FF0732DE0732DEFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FF0732DE0732DEFF00FFFF00FF0732DE0732DE07
      32DEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0732DE0732DE
      FF00FFFF00FFFF00FF0732DE0732DD0732DE0732DEFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FF0732DE0732DEFF00FFFF00FFFF00FFFF00FFFF00FF0534ED07
      32DF0732DE0732DEFF00FFFF00FFFF00FFFF00FF0732DE0732DEFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0732DE0732DE0732DDFF00FF0732
      DD0732DE0732DEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FF0732DD0633E60633E60633E90732DCFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0633E30732E30534
      EFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FF0732DD0534ED0533E90434EF0434F5FF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0434F40534EF0533EBFF00FFFF00
      FF0434F40335F8FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF03
      35FC0534EF0434F8FF00FFFF00FFFF00FFFF00FF0335FC0335FBFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF0335FB0335FB0335FCFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FF0335FB0335FBFF00FFFF00FFFF00FFFF00FF0335FB0335FB03
      35FBFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0335FB
      FF00FFFF00FF0335FB0335FB0335FBFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0335FB0335FBFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
    ShowCaption = False
    Transparent = True
    ShowHint = True
    TabOrder = 23
    OnClick = ClearAgrBtnClick
    Appearance.ColorTo = clSilver
    Appearance.ColorChecked = 16111818
    Appearance.ColorCheckedTo = 16367008
    Appearance.ColorDisabled = 15921906
    Appearance.ColorDisabledTo = 15921906
    Appearance.ColorDown = clSilver
    Appearance.ColorDownTo = clSilver
    Appearance.ColorHot = clWhite
    Appearance.ColorHotTo = clWhite
    Appearance.ColorMirrorHot = clWhite
    Appearance.ColorMirrorHotTo = 16775412
    Appearance.ColorMirrorDown = clSilver
    Appearance.ColorMirrorDownTo = clSilver
    Appearance.ColorMirrorChecked = 16102556
    Appearance.ColorMirrorCheckedTo = 16768988
    Appearance.ColorMirrorDisabled = 11974326
    Appearance.ColorMirrorDisabledTo = 15921906
  end
  object edContrExample: TEdit
    Left = 93
    Top = 201
    Width = 242
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 20
    Text = #1057#1085#1072#1095#1072#1083#1072' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    OnClick = edContrExampleClick
  end
  object Phone: TDBAdvMaskEdit
    Left = 93
    Top = 151
    Width = 257
    Height = 21
    Color = clWindow
    Enabled = True
    EditMask = '+999999999999999999'
    MaxLength = 19
    TabOrder = 24
    Text = '+                  '
    Visible = True
    AutoFocus = False
    AutoTab = False
    Flat = False
    FlatLineColor = clBlack
    FlatParentColor = True
    ShowModified = False
    FocusColor = clWindow
    FocusBorder = False
    FocusFontColor = clBlack
    LabelAlwaysEnabled = False
    LabelPosition = lpLeftTop
    LabelMargin = 4
    LabelTransparent = False
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    ModifiedColor = clRed
    SelectFirstChar = False
    Version = '2.8.1.3'
    DataField = 'Phone'
  end
  object btLoadDir: TBitBtn
    Left = 194
    Top = 173
    Width = 164
    Height = 24
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    TabOrder = 25
    OnClick = btLoadDirClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDD77
      77DDDDD777DDD788777DDD777777D777777DD7777737787770DD778777333EE8
      887078877733337EEEE778873333933EEEE0788333B3B3788EE0788333333388
      88E07F733373377788807F7337773777770D7873377777DDDDDD7783377777DD
      DDDD7FF8377777DDDDDD77FFF8877DDDDDDDDD77777DDDDDDDDD}
  end
  object BtSetAdr: TButton
    Left = 337
    Top = 230
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 26
    OnClick = BtSetAdrClick
  end
  object edAddresDescrByDefault: TDBEdit
    Left = 94
    Top = 230
    Width = 241
    Height = 21
    DataField = 'AddresDescrByDefault'
    TabOrder = 27
    OnExit = edAddresDescrByDefaultExit
    OnKeyPress = edAddresDescrByDefaultKeyPress
  end
  object edAddresExample: TEdit
    Left = 93
    Top = 230
    Width = 243
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 28
    Text = #1057#1085#1072#1095#1072#1083#1072' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    OnClick = edAddresExampleClick
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'ClientIDEdit\'
    StoredValues = <>
    Left = 357
    Top = 20
  end
  object Query: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 273
    Top = 343
  end
  object LoadTree_Timer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = LoadTree_TimerTimer
    Left = 46
    Top = 271
  end
  object SaveDialog: TSaveDialog
    Filter = 'CSV '#1092#1072#1081#1083#1099' (*.csv)|*.csv'
    Left = 190
    Top = 337
  end
  object OpenDialog: TOpenDialog
    Filter = 'CSV '#1092#1072#1081#1083#1099' (*.csv)|*.csv'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 210
    Top = 407
  end
  object pmTree: TPopupMenu
    Left = 135
    Top = 295
    object miTreeExpand: TMenuItem
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1074#1089#1077
      OnClick = miTreeExpandClick
    end
    object miTreeCollapse: TMenuItem
      Caption = #1057#1074#1077#1088#1085#1091#1090#1100' '#1074#1089#1077
      OnClick = miTreeCollapseClick
    end
  end
end
