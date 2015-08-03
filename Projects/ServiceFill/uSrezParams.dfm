object SrezParamsForm: TSrezParamsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1082#1072' '#1089#1088#1077#1079#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 172
  ClientWidth = 222
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object cbParam_Primen: TCheckBox
    Left = 13
    Top = 13
    Width = 160
    Height = 17
    Caption = #1055#1088#1080#1084#1077#1085#1103#1077#1084#1086#1089#1090#1100
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object cbParam_Picts: TCheckBox
    Left = 13
    Top = 36
    Width = 160
    Height = 17
    Caption = #1050#1072#1088#1090#1080#1085#1082#1080
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object cbParam_Descr: TCheckBox
    Left = 13
    Top = 59
    Width = 160
    Height = 17
    Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1086#1087#1080#1089#1072#1085#1080#1103
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object cbParam_Det: TCheckBox
    Left = 13
    Top = 82
    Width = 160
    Height = 17
    Caption = #1058#1072#1073#1083#1080#1095#1085#1099#1077' '#1086#1087#1080#1089#1072#1085#1080#1103
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object cbParam_DetTyp: TCheckBox
    Left = 13
    Top = 105
    Width = 160
    Height = 17
    Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1087#1086' '#1084#1072#1096#1080#1085#1072#1084
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object btOK: TButton
    Left = 139
    Top = 138
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 5
    OnClick = btOKClick
  end
end
