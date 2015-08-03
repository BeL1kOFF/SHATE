inherited OrderEdit: TOrderEdit
  Caption = #1047#1072#1082#1072#1079
  ClientHeight = 156
  ClientWidth = 413
  Color = clWindow
  Position = poMainFormCenter
  ExplicitWidth = 419
  ExplicitHeight = 188
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnBevel: TBevel
    Top = 118
    Width = 406
    ExplicitTop = 118
    ExplicitWidth = 406
  end
  object Label1: TLabel [1]
    Left = 28
    Top = 8
    Width = 26
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1044#1072#1090#1072
  end
  object Label2: TLabel [2]
    Left = 162
    Top = 10
    Width = 23
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #8470
  end
  object Label3: TLabel [3]
    Left = 8
    Top = 91
    Width = 55
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  object Label4: TLabel [4]
    Left = 14
    Top = 65
    Width = 36
    Height = 13
    Caption = #1050#1083#1080#1077#1085#1090
  end
  object Label5: TLabel [5]
    Left = 232
    Top = 10
    Width = 23
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1058#1080#1087
  end
  object Label6: TLabel [6]
    Left = 14
    Top = 39
    Width = 50
    Height = 13
    Caption = #1044#1086#1089#1090#1072#1074#1082#1072
  end
  object Label7: TLabel [7]
    Left = 215
    Top = 38
    Width = 78
    Height = 13
    Caption = #1042#1072#1083#1102#1090#1072' '#1086#1087#1083#1072#1090#1099
  end
  inherited OkBtn: TBitBtn
    Left = 150
    Top = 123
    TabOrder = 6
    ExplicitLeft = 150
    ExplicitTop = 123
  end
  inherited CancelBtn: TBitBtn
    Left = 279
    Top = 123
    TabOrder = 7
    ExplicitLeft = 279
    ExplicitTop = 123
  end
  object DateEd: TJvDBDateTimePicker
    Left = 78
    Top = 7
    Width = 84
    Height = 21
    Date = 39684.722677893520000000
    Time = 39684.722677893520000000
    TabOrder = 0
    DropDownDate = 39684.000000000000000000
    DataField = 'Date'
    DataSource = Data.OrderDataSource
  end
  object NumEd: TDBEdit
    Left = 192
    Top = 7
    Width = 29
    Height = 21
    DataField = 'Num'
    DataSource = Data.OrderDataSource
    TabOrder = 1
  end
  object DescriptionEd: TDBEdit
    Left = 78
    Top = 88
    Width = 299
    Height = 21
    DataField = 'Description'
    DataSource = Data.OrderDataSource
    TabOrder = 5
  end
  object ClientComboBox: TDBLookupComboBox
    Left = 78
    Top = 61
    Width = 299
    Height = 21
    DataField = 'Cli_id'
    DataSource = Data.OrderDataSource
    KeyField = 'Client_ID'
    ListField = 'Client_id;Description'
    ListFieldIndex = 1
    ListSource = Data.ClIDsDataSource
    TabOrder = 3
    OnCloseUp = ClientComboBoxCloseUp
    OnEnter = ClientComboBoxEnter
  end
  object ClearClientBtn: TAdvGlowButton
    Left = 383
    Top = 58
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
    TabOrder = 4
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
    Left = 261
    Top = 8
    Width = 76
    Height = 21
    DataField = 'Type'
    DataSource = Data.OrderDataSource
    ItemHeight = 13
    Items.Strings = (
      #1086#1089#1085#1086#1074#1085#1086#1081
      #1076#1086#1087#1086#1083#1085#1080#1090'.')
    TabOrder = 2
    Values.Strings = (
      'A'
      'B')
    OnChange = TypeComboBoxChange
  end
  object DeliveryComboBox: TJvDBComboBox
    Left = 78
    Top = 34
    Width = 129
    Height = 21
    DataField = 'Delivery'
    DataSource = Data.OrderDataSource
    ItemHeight = 13
    Items.Strings = (
      #1076#1086#1089#1090#1072#1074#1082#1072
      #1089#1072#1084#1086#1074#1099#1074#1086#1079
      #1089#1087#1088#1072#1096#1080#1074#1072#1090#1100)
    TabOrder = 8
    Values.Strings = (
      '1'
      '2'
      '3')
    OnChange = DeliveryComboBoxChange
  end
  object CurrCombo: TJvDBComboBox
    Left = 299
    Top = 35
    Width = 78
    Height = 21
    DataField = 'Currency'
    DataSource = Data.OrderDataSource
    ItemHeight = 13
    Items.Strings = (
      'EUR'
      'BYR'
      'USD'
      'RUB'#160)
    TabOrder = 9
    Values.Strings = (
      '1'
      '2'
      '3'
      '4')
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'OrderEdit\'
    StoredValues = <>
    Left = 19
    Top = 117
  end
end
