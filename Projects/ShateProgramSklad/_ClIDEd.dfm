inherited ClientIDEdit: TClientIDEdit
  BorderStyle = bsSizeable
  Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1082#1083#1080#1077#1085#1090#1072
  ClientHeight = 503
  ClientWidth = 382
  Constraints.MinHeight = 500
  Constraints.MinWidth = 390
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  ExplicitWidth = 390
  ExplicitHeight = 537
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel [0]
    Left = 0
    Top = 0
    Width = 382
    Height = 168
    Align = alTop
    Shape = bsSpacer
    ExplicitWidth = 453
  end
  object Bevel4: TBevel [1]
    Left = 3
    Top = 3
    Width = 376
    Height = 160
    Anchors = [akLeft, akTop, akRight]
    ExplicitWidth = 377
  end
  object Bevel2: TBevel [2]
    Left = 0
    Top = 471
    Width = 382
    Height = 32
    Align = alBottom
    Shape = bsSpacer
    ExplicitTop = 469
  end
  inherited BtnBevel: TBevel
    Left = -1
    Top = 469
    Width = 375
    Visible = False
    ExplicitLeft = -1
    ExplicitTop = 482
    ExplicitWidth = 361
  end
  object Label1: TLabel [4]
    Left = 4
    Top = 9
    Width = 83
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
  end
  object Label2: TLabel [5]
    Left = 6
    Top = 32
    Width = 81
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  object Label3: TLabel [6]
    Left = 5
    Top = 71
    Width = 82
    Height = 29
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1058#1080#1087' '#1079#1072#1082#1072#1079#1072' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    WordWrap = True
  end
  object Label4: TLabel [7]
    Left = 37
    Top = 101
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1086#1089#1090#1072#1074#1082#1072
  end
  object Label5: TLabel [8]
    Left = 59
    Top = 55
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'E-mail'
  end
  object Label6: TLabel [9]
    Left = 61
    Top = 124
    Width = 26
    Height = 13
    Alignment = taRightJustify
    Caption = #1050#1083#1102#1095
  end
  object lbEditData: TLabel [10]
    Left = 92
    Top = 146
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
  inherited OkBtn: TBitBtn
    Left = 153
    Top = 474
    ModalResult = 0
    TabOrder = 8
    ExplicitLeft = 153
    ExplicitTop = 474
  end
  inherited CancelBtn: TBitBtn
    Left = 279
    Top = 474
    Cancel = False
    TabOrder = 9
    OnClick = CancelBtnClick
    ExplicitLeft = 279
    ExplicitTop = 474
  end
  object ClientIdEd: TDBEdit
    Left = 92
    Top = 6
    Width = 98
    Height = 21
    DataField = 'Client_ID'
    TabOrder = 0
  end
  object DescriptionEd: TDBEdit
    Left = 92
    Top = 29
    Width = 232
    Height = 21
    DataField = 'Description'
    TabOrder = 1
  end
  object TypeComboBox: TJvDBComboBox
    Left = 92
    Top = 75
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
  end
  object DeliveryComboBox: TJvDBComboBox
    Left = 92
    Top = 98
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
    Left = 92
    Top = 52
    Width = 232
    Height = 21
    DataField = 'Email'
    TabOrder = 2
  end
  object Key_Edit: TDBEdit
    Left = 92
    Top = 121
    Width = 232
    Height = 21
    DataField = 'Key'
    PasswordChar = '*'
    TabOrder = 5
    OnKeyDown = Key_EditKeyDown
  end
  object SaveToFile_BitBtn: TBitBtn
    Left = 267
    Top = 74
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
    Left = 294
    Top = 74
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
    Top = 102
    Width = 72
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 10
    Visible = False
    OnClick = cbShowPasswordClick
  end
  object pnDiscounts: TPanel
    Left = 0
    Top = 168
    Width = 382
    Height = 303
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 3
    TabOrder = 11
    DesignSize = (
      382
      303)
    object Bevel3: TBevel
      Left = 5
      Top = 266
      Width = 372
      Height = 32
      Align = alBottom
      Shape = bsSpacer
      ExplicitLeft = 6
      ExplicitTop = 253
      ExplicitWidth = 373
    end
    object Label7: TLabel
      Left = 5
      Top = 5
      Width = 372
      Height = 14
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1082#1080#1076#1086#1082'/'#1085#1072#1094#1077#1085#1086#1082
      Color = clSilver
      ParentColor = False
      Transparent = False
      ExplicitTop = -3
    end
    object Discaunt_Tree: TVirtualStringTree
      Left = 5
      Top = 92
      Width = 372
      Height = 174
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
          Width = 308
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
      Top = 70
      Width = 372
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
      Top = 270
      Width = 105
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1054#1073#1085#1091#1083#1080#1090#1100' '#1085#1072#1094#1077#1085#1082#1080
      TabOrder = 2
      OnClick = UpNullMarginClick
    end
    object UpNullDiscount: TButton
      Left = 112
      Top = 270
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
      Width = 372
      Height = 51
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
        Left = 87
        Top = 27
        Width = 65
        Height = 21
        TabOrder = 0
        OnChange = edDiscGlobalChange
        OnExit = edDiscGlobalExit
      end
      object cbDiscountsMode: TJvDBComboBox
        Left = 87
        Top = 3
        Width = 232
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
    end
    object btLoadDiscount: TBitBtn
      Left = 160
      Top = 44
      Width = 164
      Height = 25
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1082#1080#1076#1082#1080' '#1087#1086' TCP'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1082#1080#1076#1082#1080' '#1087#1086' TCP'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 5
      OnClick = btLoadDiscountClick
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
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'ClientIDEdit\'
    StoredValues = <>
    Left = 342
    Top = 8
  end
  object Query: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.24 Build 1'
    MaxRowCount = -1
    Params = <>
    Left = 273
    Top = 343
  end
  object LoadTree_Timer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = LoadTree_TimerTimer
    Left = 66
    Top = 291
  end
  object SaveDialog: TSaveDialog
    Filter = 'CSV '#1092#1072#1081#1083#1099' (*.csv)|*.csv'
    Left = 190
    Top = 337
  end
  object OpenDialog: TOpenDialog
    Filter = 'CSV '#1092#1072#1081#1083#1099' (*.csv)|*.csv'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 190
    Top = 292
  end
  object mem038: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.24 Build 1'
    IndexName = 'CLI'
    TableName = 'mem038'
    StoreDefs = True
    Left = 68
    Top = 338
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
