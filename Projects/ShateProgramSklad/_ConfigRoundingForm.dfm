object ConfigRoundingForm: TConfigRoundingForm
  Left = 301
  Top = 104
  BorderStyle = bsToolWindow
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103
  ClientHeight = 140
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 15
    Width = 105
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1042#1072#1083#1102#1090#1072
  end
  object Label2: TLabel
    Left = 15
    Top = 42
    Width = 105
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1054#1082#1088#1091#1075#1076#1103#1090#1100' '#1076#1086':'
  end
  object Label3: TLabel
    Left = 15
    Top = 69
    Width = 105
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1052#1077#1090#1086#1076' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103':'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 97
    Width = 251
    Height = 7
    Shape = bsTopLine
  end
  object cbCurrency: TComboBox
    Left = 126
    Top = 12
    Width = 120
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'BYR'
    OnChange = cbCurrencyChange
    Items.Strings = (
      'BYR'
      'RUB'
      'USD')
  end
  object edRoundPower: TEdit
    Left = 145
    Top = 39
    Width = 82
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = '1'
    OnExit = edRoundPowerExit
  end
  object cbRoundMethod: TComboBox
    Left = 126
    Top = 66
    Width = 120
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = #1076#1086' '#1073#1083#1080#1078#1072#1081#1096#1077#1075#1086
    OnChange = cbRoundMethodChange
    OnExit = cbRoundMethodExit
    Items.Strings = (
      #1076#1086' '#1073#1083#1080#1078#1072#1081#1096#1077#1075#1086
      #1076#1086' '#1084#1077#1085#1100#1096#1077#1085#1075#1086
      #1076#1086' '#1073#1086#1083#1100#1096#1077#1075#1086)
  end
  object btOK: TButton
    Left = 96
    Top = 107
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btCancel: TButton
    Left = 171
    Top = 107
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object Button1: TButton
    Left = 227
    Top = 39
    Width = 19
    Height = 21
    Caption = '>'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 126
    Top = 39
    Width = 19
    Height = 21
    Caption = '<'
    TabOrder = 6
    OnClick = Button2Click
  end
end
