object OutParamsForm: TOutParamsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1074#1099#1075#1088#1091#1079#1082#1080
  ClientHeight = 300
  ClientWidth = 268
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
    Top = 268
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cbParams: TCheckListBox
    Left = 8
    Top = 25
    Width = 252
    Height = 196
    OnClickCheck = cbParamsClickCheck
    ItemHeight = 13
    Items.Strings = (
      #1050#1072#1090#1072#1083#1086#1075' ([002], [003], [004], [005])'
      #1040#1085#1072#1083#1086#1075#1080' ([007])'
      #1054#1045' ([016])'
      #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1076#1072#1085#1085#1099#1077' Tecdoc ([024], [025])'
      #1048#1084#1077#1085#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' ([015])'
      #1058#1080#1087#1099' '#1072#1074#1090#1086' ([022])'
      #1052#1086#1076#1077#1083#1080' '#1072#1074#1090#1086' ([021])'
      #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080' '#1072#1074#1090#1086' ([020])'
      #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1086#1087#1080#1089#1072#1085#1080#1103' ([013])'
      #1055#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1090#1080#1087#1072#1084' ([023])'
      #1044#1086#1087'. '#1087#1072#1088#1072#1084#1077#1090#1088#1099' ([014])'
      #1044#1086#1087'. '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086' '#1090#1080#1087#1072#1084' ([028])'
      #1050#1072#1088#1090#1080#1085#1082#1080' ([027])'
      #1042#1077#1088#1089#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1080' '#1085#1086#1084#1077#1088' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103' ([098])')
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
  object cbMakeUpdate: TCheckBox
    Left = 8
    Top = 245
    Width = 252
    Height = 17
    Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1095#1072#1089#1090#1080#1095#1085#1086#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object cbBuildPrimen: TCheckBox
    Left = 8
    Top = 227
    Width = 252
    Height = 17
    Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1087#1088#1080#1084#1077#1085#1103#1077#1084#1086#1089#1090#1100
    TabOrder = 4
    Visible = False
  end
end
