object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 388
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 8
    Top = 191
    Width = 409
    Height = 153
    ColCount = 3
    DefaultColWidth = 128
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    PopupMenu = PopupMenu2
    TabOrder = 0
    OnClick = StringGrid1Click
    OnDblClick = StringGrid1DblClick
    OnDrawCell = StringGrid1DrawCell
    OnSelectCell = StringGrid1SelectCell
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 350
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object Button1: TButton
    Left = 88
    Top = 160
    Width = 155
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 80
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
  end
  object ComboBox2: TComboBox
    Left = 160
    Top = 80
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'ComboBox2'
    OnChange = ComboBox2Change
  end
  object RadioGroup1: TRadioGroup
    Left = 312
    Top = 80
    Width = 168
    Height = 105
    Caption = 'RadioGroup1'
    ItemIndex = 3
    Items.Strings = (
      'TEST'
      'DEVELOPER'
      'PRODUCTIVE'
      'UNKNOWN')
    TabOrder = 5
    OnClick = RadioGroup1Click
  end
  object ComboBox3: TComboBox
    Left = 312
    Top = 8
    Width = 155
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 6
    Text = #1050#1088#1091#1087#1085#1099#1081' '#1096#1088#1080#1092#1090
    OnChange = ComboBox3Change
    Items.Strings = (
      #1052#1077#1083#1082#1080#1081' '#1096#1088#1080#1092#1090
      #1050#1088#1091#1087#1085#1099#1081' '#1096#1088#1080#1092#1090)
  end
  object CheckBox1: TCheckBox
    Left = 48
    Top = 8
    Width = 258
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 7
  end
  object Edit1: TEdit
    Left = 48
    Top = 40
    Width = 385
    Height = 21
    TabOrder = 8
    Text = 'Edit1'
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
  end
  object PopupMenu1: TPopupMenu
    Left = 456
    Top = 344
    object N2: TMenuItem
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1103
      OnClick = N2Click
    end
    object N1: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = N1Click
    end
  end
  object ActionList1: TActionList
    Top = 32
    object Action1Cfg: TAction
      Caption = 'Action1Cfg'
      OnExecute = Action1CfgExecute
    end
    object Action2Run: TAction
      Caption = 'Action2Run'
      OnExecute = Action2RunExecute
    end
    object Action3Monitoring: TAction
      Caption = 'Action3Monitoring'
      OnExecute = Action3MonitoringExecute
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 440
    Top = 40
  end
  object PopupMenu2: TPopupMenu
    Left = 424
    Top = 192
    object N3: TMenuItem
      Action = Action1Cfg
    end
    object N4: TMenuItem
      Action = Action2Run
    end
    object N5: TMenuItem
      Action = Action3Monitoring
    end
  end
end
