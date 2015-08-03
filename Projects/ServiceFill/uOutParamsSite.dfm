object OutParamsSiteForm: TOutParamsSiteForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1074#1099#1075#1088#1091#1079#1082#1080
  ClientHeight = 242
  ClientWidth = 269
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btOK: TButton
    Left = 185
    Top = 209
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btOKClick
  end
  object cbParams: TCheckListBox
    Left = 8
    Top = 25
    Width = 252
    Height = 126
    ItemHeight = 13
    Items.Strings = (
      #1050#1072#1090#1072#1083#1086#1075
      #1040#1085#1072#1083#1086#1075#1080
      'OE'
      #1057#1087#1080#1089#1086#1082' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
      #1055#1088#1080#1084#1077#1085#1103#1077#1084#1086#1089#1090#1100' '#1082' '#1084#1072#1096#1080#1085#1077
      #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1087#1086' '#1084#1072#1096#1080#1085#1077
      #1054#1087#1080#1089#1072#1085#1080#1103
      #1050#1072#1088#1090#1080#1085#1082#1080
      #1057#1087#1080#1089#1086#1082' '#1082#1072#1088#1090#1080#1085#1086#1082' JP2')
    TabOrder = 1
  end
  object cbAll: TCheckBox
    Left = 8
    Top = 8
    Width = 101
    Height = 17
    Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074#1089#1077
    TabOrder = 2
    OnClick = cbAllClick
  end
  object cbZipAll: TCheckBox
    Left = 8
    Top = 158
    Width = 158
    Height = 17
    Caption = #1059#1087#1072#1082#1086#1074#1072#1090#1100' '#1074#1089#1077' '#1074' '#1086#1076#1080#1085' ZIP'
    TabOrder = 3
    OnClick = cbZipAllClick
  end
  object edZipName: TEdit
    Left = 165
    Top = 157
    Width = 95
    Height = 21
    TabOrder = 4
    Text = 'all.zip'
  end
  object cbZipEach: TCheckBox
    Left = 8
    Top = 181
    Width = 252
    Height = 17
    Caption = #1059#1087#1072#1082#1086#1074#1072#1090#1100' '#1082#1072#1078#1076#1099#1081' '#1092#1072#1081#1083' '#1086#1090#1076#1077#1083#1100#1085#1086
    TabOrder = 5
    OnClick = cbZipEachClick
  end
end
