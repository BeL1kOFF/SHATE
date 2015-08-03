inherited OrderEdit: TOrderEdit
  Caption = #1047#1072#1082#1072#1079
  ClientHeight = 266
  ClientWidth = 386
  Color = clWindow
  Position = poMainFormCenter
  OnCloseQuery = nil
  OnDeactivate = FormDeactivate
  OnKeyDown = nil
  ExplicitWidth = 392
  ExplicitHeight = 294
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnBevel: TBevel
    Top = 228
    Width = 379
    ExplicitTop = 118
    ExplicitWidth = 406
  end
  object Label1: TLabel [1]
    Left = 2
    Top = 10
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1044#1072#1090#1072
  end
  object Label2: TLabel [2]
    Left = 202
    Top = 10
    Width = 23
    Height = 13
    AutoSize = False
    Caption = #8470
  end
  object Label3: TLabel [3]
    Left = 2
    Top = 169
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object lbNameCli: TLabel [4]
    Left = 2
    Top = 92
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object Label5: TLabel [5]
    Left = 432
    Top = 11
    Width = 23
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1058#1080#1087
    Visible = False
  end
  object Label6: TLabel [6]
    Left = 2
    Top = 37
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1044#1086#1089#1090#1072#1074#1082#1072
  end
  object Label7: TLabel [7]
    Left = 201
    Top = 37
    Width = 78
    Height = 13
    Caption = #1042#1072#1083#1102#1090#1072' '#1086#1087#1083#1072#1090#1099
    Visible = False
  end
  object Label8: TLabel [8]
    Left = 2
    Top = 67
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  end
  object lbAddr: TLabel [9]
    Left = 2
    Top = 119
    Width = 65
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1040#1076#1088#1077#1089
  end
  object lbFIO: TLabel [10]
    Left = 40
    Top = 92
    Width = 27
    Height = 13
    Caption = #1060#1048#1054
  end
  object lbMobile: TLabel [11]
    Left = 22
    Top = 144
    Width = 45
    Height = 13
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object lbRedStarAgr: TLabel [12]
    Left = 67
    Top = 63
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
  object lbRedStarAdr: TLabel [13]
    Left = 67
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
  object lbRedStarPhone: TLabel [14]
    Left = 67
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
  object lbRedStarCli: TLabel [15]
    Left = 67
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
  object Label12: TLabel [16]
    Left = 189
    Top = 211
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
    ExplicitLeft = 183
    ExplicitTop = 199
  end
  inherited OkBtn: TBitBtn
    Left = 151
    Top = 233
    TabOrder = 8
    OnClick = nil
    ExplicitLeft = 151
    ExplicitTop = 233
  end
  inherited CancelBtn: TBitBtn
    Left = 280
    Top = 233
    TabOrder = 9
    ExplicitLeft = 280
    ExplicitTop = 233
  end
  object DateEd: TJvDBDateTimePicker
    Left = 76
    Top = 7
    Width = 115
    Height = 21
    Date = 39684.722677893520000000
    Time = 39684.722677893520000000
    TabOrder = 0
    DropDownDate = 39684.000000000000000000
    DataField = 'Date'
    DataSource = Data.OrderDataSource
  end
  object NumEd: TDBEdit
    Left = 226
    Top = 7
    Width = 34
    Height = 21
    DataField = 'Num'
    DataSource = Data.OrderDataSource
    TabOrder = 1
  end
  object DescriptionEd: TDBEdit
    Left = 76
    Top = 166
    Width = 276
    Height = 21
    DataField = 'Description'
    DataSource = Data.OrderDataSource
    TabOrder = 6
    OnChange = DescriptionEdChange
  end
  object ClientComboBox: TDBLookupComboBox
    Left = 76
    Top = 88
    Width = 276
    Height = 21
    DataField = 'Cli_id'
    DataSource = Data.OrderDataSource
    KeyField = 'Client_ID'
    ListField = 'Client_id;Description'
    ListFieldIndex = 1
    ListSource = DataSourceCli
    TabOrder = 4
    OnClick = ClientComboBoxClick
    OnCloseUp = ClientComboBoxCloseUp
    OnEnter = ClientComboBoxEnter
  end
  object ClearClientBtn: TAdvGlowButton
    Left = 354
    Top = 89
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
    TabOrder = 5
    OnClick = ClearClientBtnClick
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
  object TypeComboBox: TJvDBComboBox
    Left = 491
    Top = 8
    Width = 76
    Height = 21
    DataField = 'Type'
    DataSource = Data.OrderDataSource
    ItemHeight = 13
    Items.Strings = (
      #1086#1089#1085#1086#1074#1085#1086#1081
      #1076#1086#1087#1086#1083#1085#1080#1090'.')
    TabOrder = 7
    Values.Strings = (
      'A'
      'B')
    Visible = False
    OnChange = TypeComboBoxChange
  end
  object DeliveryComboBox: TJvDBComboBox
    Left = 76
    Top = 34
    Width = 115
    Height = 21
    DataField = 'Delivery'
    DataSource = Data.OrderDataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    Items.Strings = (
      #1076#1086#1089#1090#1072#1074#1082#1072
      #1089#1072#1084#1086#1074#1099#1074#1086#1079
      #1089#1087#1088#1072#1096#1080#1074#1072#1090#1100)
    ParentFont = False
    TabOrder = 2
    Values.Strings = (
      '1'
      '2'
      '3')
    OnChange = DeliveryComboBoxChange
  end
  object CurrCombo: TJvDBComboBox
    Left = 285
    Top = 34
    Width = 67
    Height = 21
    DataField = 'Currency'
    DataSource = Data.OrderDataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    Items.Strings = (
      'EUR'
      'BYR'
      'USD'
      'RUB'#160)
    ParentFont = False
    TabOrder = 3
    Values.Strings = (
      '1'
      '2'
      '3'
      '4')
    Visible = False
  end
  object DBEdit1: TDBEdit
    Left = 425
    Top = 35
    Width = 121
    Height = 21
    TabStop = False
    DataField = 'Agreement_No'
    DataSource = Data.OrderDataSource
    TabOrder = 10
    Visible = False
    OnChange = DBEdit1Change
  end
  object btOpenContr: TButton
    Left = 354
    Top = 64
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 11
    OnClick = btOpenContrClick
  end
  object AgrDescr: TDBEdit
    Left = 76
    Top = 64
    Width = 276
    Height = 21
    DataField = 'AgrDescr'
    DataSource = Data.OrderDataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 12
  end
  object Name: TDBEdit
    Left = 76
    Top = 88
    Width = 276
    Height = 21
    DataField = 'Name'
    DataSource = Data.OrderDataSource
    TabOrder = 13
    OnExit = NameExit
    OnKeyPress = NameKeyPress
  end
  object Phone1: TDBEdit
    Left = 22
    Top = 265
    Width = 276
    Height = 21
    DataField = 'Phone'
    DataSource = Data.OrderDataSource
    TabOrder = 14
    Visible = False
  end
  object FakeAddresDescr: TDBEdit
    Left = 76
    Top = 116
    Width = 276
    Height = 21
    DataField = 'FakeAddresDescr'
    DataSource = Data.OrderDataSource
    TabOrder = 15
    OnKeyPress = FakeAddresDescrKeyPress
  end
  object btOpenAddr: TButton
    Left = 354
    Top = 116
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 16
    OnClick = btOpenAddrClick
  end
  object edNameExample: TEdit
    Left = 76
    Top = 88
    Width = 276
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 17
    Text = #1060#1086#1088#1084#1072#1090': '#1048#1074#1072#1085#1086#1074' '#1048'.'#1048'.'
    OnEnter = edNameExampleEnter
    OnKeyPress = edNameExampleKeyPress
  end
  object edPhoneExample1: TEdit
    Left = 132
    Top = 265
    Width = 276
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 18
    Text = #1060#1086#1088#1084#1072#1090': +375297776655'
    Visible = False
  end
  object Phone: TDBAdvMaskEdit
    Left = 79
    Top = 142
    Width = 272
    Height = 21
    Color = clWindow
    Enabled = True
    EditMask = '+999999999999999999'
    MaxLength = 19
    TabOrder = 19
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
    DataSource = Data.OrderDataSource
  end
  object cbNearestDelivery: TDBCheckBox
    Left = 76
    Top = 193
    Width = 130
    Height = 17
    Caption = #1041#1083#1080#1078#1072#1081#1096#1072#1103' '#1076#1086#1089#1090#1072#1074#1082#1072
    DataField = 'NearestDelivery'
    DataSource = Data.OrderDataSource
    TabOrder = 20
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'OrderEdit\'
    StoredValues = <>
    Left = 479
    Top = 82
  end
  object TableCli: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Client_ID'
        DataType = ftString
        Size = 15
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Order_type'
        DataType = ftString
        Size = 1
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Delivery'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ByDefault'
        DataType = ftInteger
        Description = 'ByDefault'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'email'
        DataType = ftString
        Size = 255
        Description = 'email'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Key'
        DataType = ftString
        Size = 22
        Description = 'Key'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'UpdateDisc'
        DataType = ftBoolean
        Description = 'UpdateDisc'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'UseDiffMargin'
        DataType = ftBoolean
        Description = 'UseDiffMargin'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiffMargin'
        DataType = ftString
        Size = 255
        Description = 'DiffMargin'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiscountVersion'
        DataType = ftInteger
        Description = 'DiscountVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'DiscVersion'
        DataType = ftInteger
        Description = 'DiscVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AddresVersion'
        DataType = ftInteger
        Description = 'AddresVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'AgrVersion'
        DataType = ftInteger
        Description = 'AgrVersion'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'ContractByDefault'
        DataType = ftString
        Size = 20
        Description = 'ContractByDefault'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Phone'
        DataType = ftString
        Size = 20
        Description = 'Phone'
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 100
        Description = 'Name'
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'TableCliDBISA1'
        Fields = 'Id'
        Options = [ixPrimary, ixUnique]
        Compression = icNone
      end
      item
        Name = 'Client_ID'
        Fields = 'Client_ID'
        Compression = icNone
      end
      item
        Name = 'Descr'
        Fields = 'Description'
        Options = [ixCaseInsensitive]
        Compression = icNone
      end>
    IndexName = 'Descr'
    TableName = '011'
    StoreDefs = True
    Left = 435
    Top = 138
  end
  object DataSourceCli: TDataSource
    DataSet = TableCli
    Left = 410
    Top = 233
  end
  object AddresQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 490
    Top = 92
  end
  object DS_Addres: TDataSource
    DataSet = AddresQuery
    Left = 425
    Top = 78
  end
  object OrderCliChangeTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = OrderCliChangeTimerTimer
    Left = 455
    Top = 185
  end
end
