object ReturnDocED: TReturnDocED
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1086#1079#1074#1088#1072#1090
  ClientHeight = 289
  ClientWidth = 421
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    421
    289)
  PixelsPerInch = 96
  TextHeight = 13
  object BtnBevel: TBevel
    Left = 2
    Top = 258
    Width = 416
    Height = 2
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
    ExplicitTop = 187
    ExplicitWidth = 401
  end
  object Label1: TLabel
    Left = 52
    Top = 10
    Width = 26
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1044#1072#1090#1072
  end
  object Label2: TLabel
    Left = 182
    Top = 10
    Width = 23
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #8470
  end
  object Label3: TLabel
    Left = 22
    Top = 168
    Width = 55
    Height = 11
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  object lbNameCli: TLabel
    Left = 41
    Top = 92
    Width = 37
    Height = 13
    Caption = #1050#1083#1080#1077#1085#1090
  end
  object Label5: TLabel
    Left = 261
    Top = 10
    Width = 23
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1058#1080#1087
    Visible = False
  end
  object Label8: TLabel
    Left = 17
    Top = 64
    Width = 60
    Height = 13
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  end
  object Label6: TLabel
    Left = 13
    Top = 37
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1044#1086#1089#1090#1072#1074#1082#1072
  end
  object Label9: TLabel
    Left = 13
    Top = 115
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1040#1076#1088#1077#1089
  end
  object lbDefect: TLabel
    Left = 2
    Top = 179
    Width = 76
    Height = 13
    Caption = #1085#1077#1080#1089#1087#1088#1072#1074#1085#1086#1089#1090#1080
  end
  object lbReason: TLabel
    Left = 247
    Top = 38
    Width = 43
    Height = 13
    Caption = #1055#1088#1080#1095#1080#1085#1072
  end
  object lbRedStar: TLabel
    Left = 81
    Top = 166
    Width = 6
    Height = 13
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 81
    Top = 60
    Width = 6
    Height = 13
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label12: TLabel
    Left = 11
    Top = 202
    Width = 169
    Height = 11
    Anchors = [akRight, akBottom]
    Caption = '* - '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1077' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1086#1083#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitLeft = 8
    ExplicitTop = 234
  end
  object lbRedStarReason: TLabel
    Left = 288
    Top = 35
    Width = 6
    Height = 13
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbMobile: TLabel
    Left = 37
    Top = 143
    Width = 44
    Height = 13
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object lbFIO: TLabel
    Left = 55
    Top = 92
    Width = 23
    Height = 13
    Caption = #1060#1048#1054
  end
  object lbRedStarPhone: TLabel
    Left = 81
    Top = 139
    Width = 6
    Height = 13
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbRedStarAdr: TLabel
    Left = 81
    Top = 113
    Width = 6
    Height = 13
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbRedStarCli: TLabel
    Left = 81
    Top = 86
    Width = 6
    Height = 13
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 11
    Top = 219
    Width = 372
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = 
      '** - '#1074' '#1089#1074#1103#1079#1080' '#1089' '#1090#1077#1084', '#1095#1090#1086' '#1090#1072#1083#1086#1085' '#1085#1072' '#1074#1086#1079#1074#1088#1072#1090' '#1103#1074#1083#1103#1077#1090#1089#1103' '#1089#1086#1087#1088#1086#1074#1086#1076#1080#1090#1077#1083#1100#1085 +
      #1099#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084', '#13#10#1087#1088#1080' '#1085#1077#1082#1086#1088#1088#1077#1082#1090#1085#1086#1084' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1093' '#1087#1086#1083#1077#1081',' +
      ' '#1090#1086#1074#1072#1088' '#1084#1086#1078#1077#1090' '#1073#1099#1090#1100' '#1082#1086#1085#1092#1080#1089#1082#1086#1074#1072#1085' '#13#10#1087#1088#1086#1074#1077#1088#1103#1102#1097#1080#1084#1080' '#1086#1088#1075#1072#1085#1072#1084#1080'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object OkBtn: TBitBtn
    Left = 183
    Top = 263
    Width = 118
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' (F10)'
    ModalResult = 1
    TabOrder = 0
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CancelBtn: TBitBtn
    Left = 312
    Top = 263
    Width = 98
    Height = 24
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 1
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
  object DateEd: TJvDBDateTimePicker
    Left = 89
    Top = 7
    Width = 84
    Height = 21
    Date = 39684.722677893520000000
    Time = 39684.722677893520000000
    TabOrder = 2
    DropDownDate = 39684.000000000000000000
    DataField = 'Data'
    DataSource = Data.ReturnDocDataSource
  end
  object NumEd: TDBEdit
    Left = 212
    Top = 7
    Width = 29
    Height = 21
    DataField = 'Num'
    DataSource = Data.ReturnDocDataSource
    ReadOnly = True
    TabOrder = 3
  end
  object DescriptionEd: TDBEdit
    Left = 89
    Top = 167
    Width = 312
    Height = 21
    DataField = 'Note'
    DataSource = Data.ReturnDocDataSource
    TabOrder = 4
  end
  object ClientComboBox: TDBLookupComboBox
    Left = 89
    Top = 87
    Width = 312
    Height = 21
    DataField = 'Cli_id'
    DataSource = Data.ReturnDocDataSource
    KeyField = 'Client_ID'
    ListField = 'Client_id;Description'
    ListFieldIndex = 1
    ListSource = Data.ClIDsDataSource
    TabOrder = 5
    OnClick = ClientComboBoxClick
  end
  object TypeComboBox: TJvDBComboBox
    Left = 290
    Top = 7
    Width = 76
    Height = 21
    DataField = 'Type'
    DataSource = Data.ReturnDocDataSource
    ItemHeight = 13
    Items.Strings = (
      #1086#1089#1085#1086#1074#1085#1086#1081
      #1076#1086#1087#1086#1083#1085#1080#1090'.')
    TabOrder = 6
    Values.Strings = (
      'A'
      'B')
    Visible = False
  end
  object btOpenContr: TButton
    Left = 381
    Top = 62
    Width = 20
    Height = 19
    Caption = '...'
    TabOrder = 7
    OnClick = btOpenContrClick
  end
  object AgrDescr: TDBEdit
    Left = 89
    Top = 61
    Width = 291
    Height = 21
    DataField = 'AgrDescr'
    DataSource = Data.ReturnDocDataSource
    ReadOnly = True
    TabOrder = 8
  end
  object DeliveryComboBox: TJvDBComboBox
    Left = 89
    Top = 34
    Width = 127
    Height = 21
    DataField = 'delivery'
    DataSource = Data.ReturnDocDataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 13
    Items.Strings = (
      #1076#1086#1089#1090#1072#1074#1082#1072
      #1089#1072#1084#1086#1074#1099#1074#1086#1079)
    ParentFont = False
    TabOrder = 9
    Values.Strings = (
      '1'
      '2')
    OnChange = DeliveryComboBoxChange
  end
  object ReasonComboBox: TJvDBComboBox
    Left = 297
    Top = 34
    Width = 104
    Height = 21
    DataField = 'reason'
    DataSource = Data.ReturnDocDataSource
    ItemHeight = 13
    Items.Strings = (
      #1041#1056#1040#1050'-'#1042#1086#1079#1074#1088#1072#1090
      #1041#1056#1040#1050'-'#1054#1073#1084#1077#1085)
    TabOrder = 10
    Values.Strings = (
      'ret'
      'exch')
  end
  object Phone1: TDBEdit
    Left = 17
    Top = 260
    Width = 312
    Height = 21
    DataField = 'Phone'
    DataSource = Data.ReturnDocDataSource
    TabOrder = 11
    Visible = False
    OnExit = Phone1Exit
    OnKeyPress = Phone1KeyPress
  end
  object Name: TDBEdit
    Left = 89
    Top = 87
    Width = 312
    Height = 21
    DataField = 'Name'
    DataSource = Data.ReturnDocDataSource
    TabOrder = 12
    OnExit = NameExit
    OnKeyPress = NameKeyPress
  end
  object FakeAddresDescr: TDBEdit
    Left = 89
    Top = 114
    Width = 291
    Height = 21
    DataField = 'FakeAddresDescr'
    DataSource = Data.ReturnDocDataSource
    TabOrder = 13
    OnKeyPress = FakeAddresDescrKeyPress
  end
  object btOpenAddr: TButton
    Left = 381
    Top = 115
    Width = 20
    Height = 19
    Caption = '...'
    TabOrder = 14
    OnClick = btOpenAddrClick
  end
  object edPhoneExample: TEdit
    Left = 17
    Top = 231
    Width = 312
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 15
    Text = #1060#1086#1088#1084#1072#1090': +375297776655'
    Visible = False
    OnEnter = edPhoneExampleEnter
  end
  object edNameExample: TEdit
    Left = 89
    Top = 114
    Width = 312
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 16
    Text = #1060#1086#1088#1084#1072#1090': '#1048#1074#1072#1085#1086#1074' '#1048'.'#1048'.'
    Visible = False
    OnEnter = edNameExampleEnter
  end
  object Phone: TDBAdvMaskEdit
    Left = 89
    Top = 140
    Width = 308
    Height = 21
    Color = clWindow
    Enabled = True
    EditMask = '+999999999999999999'
    MaxLength = 19
    TabOrder = 17
    Text = '+                  '
    Visible = True
    OnExit = PhoneExit
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
    DataSource = Data.ReturnDocDataSource
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'OrderEdit\'
    StoredValues = <>
    Left = 451
    Top = 31
  end
  object DS_Addres: TDataSource
    DataSet = AddresQuery
    Left = 475
    Top = 78
  end
  object AddresQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 450
    Top = 132
  end
end
