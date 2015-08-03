object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 391
  ClientWidth = 482
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
  object Button1: TButton
    Left = 128
    Top = 8
    Width = 217
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 127
    Width = 463
    Height = 263
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 128
    Top = 69
    Width = 217
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object DateTimePicker1: TDateTimePicker
    Left = 8
    Top = 100
    Width = 161
    Height = 21
    Date = 42078.482986504630000000
    Time = 42078.482986504630000000
    TabOrder = 3
  end
  object DateTimePicker2: TDateTimePicker
    Left = 311
    Top = 100
    Width = 160
    Height = 21
    Date = 42078.483448530100000000
    Time = 42078.483448530100000000
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 128
    Top = 46
    Width = 153
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 5
    OnClick = CheckBox1Click
  end
  object Edit1: TEdit
    Left = 287
    Top = 42
    Width = 58
    Height = 21
    TabOrder = 6
    Text = 'Edit1'
  end
  object SaveDialog1: TSaveDialog
    Left = 40
  end
  object OpenDialog1: TOpenDialog
    Left = 8
  end
end
