object UpdateClientsParamsForm: TUpdateClientsParamsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103
  ClientHeight = 140
  ClientWidth = 282
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
  object Label1: TLabel
    Left = 10
    Top = 6
    Width = 157
    Height = 13
    Caption = 'E-Mail '#1076#1083#1103' '#1086#1090#1074#1077#1090#1086#1074' '#1087#1086' '#1079#1072#1082#1072#1079#1072#1084':'
  end
  object rbUseEmailClient: TRadioButton
    Left = 22
    Top = 25
    Width = 156
    Height = 17
    Caption = #1042#1089#1090#1072#1074#1083#1103#1090#1100' E-Mail '#1082#1083#1080#1077#1085#1090#1072
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object rbUseEmailCustom: TRadioButton
    Left = 22
    Top = 48
    Width = 104
    Height = 17
    Caption = #1042#1089#1090#1072#1074#1083#1103#1090#1100' E-Mail:'
    TabOrder = 1
  end
  object btOK: TButton
    Left = 115
    Top = 107
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = btOKClick
  end
  object btCancel: TButton
    Left = 196
    Top = 107
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object edEMail: TComboBox
    Left = 130
    Top = 46
    Width = 141
    Height = 21
    ItemHeight = 0
    TabOrder = 4
  end
  object cbNotQuery: TCheckBox
    Left = 12
    Top = 84
    Width = 139
    Height = 17
    Caption = #1041#1086#1083#1100#1096#1077' '#1085#1077' '#1089#1087#1088#1072#1096#1080#1074#1072#1090#1100
    TabOrder = 5
  end
end
