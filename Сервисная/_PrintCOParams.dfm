object PrintCOParamsForm: TPrintCOParamsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1074#1099#1074#1086#1076#1072
  ClientHeight = 293
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 96
    Width = 97
    Height = 13
    Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1089#1090#1086#1083#1073#1094#1099
  end
  object Label2: TLabel
    Left = 8
    Top = 240
    Width = 209
    Height = 12
    Caption = '*'#1087#1077#1088#1077#1090#1103#1075#1080#1074#1072#1081#1090#1077' '#1089#1090#1086#1083#1073#1094#1099' '#1084#1099#1096#1082#1086#1081' '#1076#1083#1103' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10640185
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object cbExcludeNullQuants: TCheckBox
    Left = 8
    Top = 73
    Width = 210
    Height = 17
    Caption = #1053#1077' '#1074#1082#1083#1102#1095#1072#1090#1100' '#1087#1086#1079#1080#1094#1080#1080' '#1073#1077#1079' '#1086#1089#1090#1072#1090#1082#1086#1074
    TabOrder = 0
  end
  object Button1: TButton
    Left = 173
    Top = 260
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 43
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
    TabOrder = 2
    object rbSortBrandGroup: TRadioButton
      Left = 127
      Top = 18
      Width = 96
      Height = 17
      Caption = #1041#1088#1077#1085#1076'/'#1043#1088#1091#1087#1087#1072
      TabOrder = 0
      OnClick = rbSortBrandGroupClick
    end
    object rbSortGroupBrand: TRadioButton
      Left = 23
      Top = 18
      Width = 98
      Height = 17
      Caption = #1043#1088#1091#1087#1087#1072'/'#1041#1088#1077#1085#1076
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = rbSortGroupBrandClick
    end
    object Sort_off: TRadioButton
      Left = 229
      Top = 18
      Width = 113
      Height = 17
      Caption = #1041#1077#1079' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080
      TabOrder = 2
      OnClick = Sort_offClick
    end
  end
  object cbIncludeSubtitles: TCheckBox
    Left = 8
    Top = 57
    Width = 210
    Height = 17
    Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1079#1072#1075#1086#1083#1086#1074#1082#1080' '#1075#1088#1091#1087#1087'/'#1073#1088#1077#1085#1076#1086#1074
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object clbColumns: TCheckListBox
    Left = 72
    Top = 115
    Width = 240
    Height = 128
    DragMode = dmAutomatic
    ItemHeight = 16
    Style = lbOwnerDrawFixed
    TabOrder = 4
    OnDragDrop = clbColumnsDragDrop
    OnDragOver = clbColumnsDragOver
    OnDrawItem = clbColumnsDrawItem
  end
end
