object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form2'
  ClientHeight = 207
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 112
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object ProgressBar1: TProgressBar
    Left = 64
    Top = 141
    Width = 150
    Height = 17
    Step = 1
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 99
    Top = 164
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkAbort
  end
  object BitBtn2: TBitBtn
    Left = 99
    Top = 63
    Width = 75
    Height = 25
    TabOrder = 2
    OnClick = BitBtn2Click
    Kind = bkOK
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 8
    Width = 172
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 40
    Width = 172
    Height = 17
    Caption = 'CheckBox2'
    TabOrder = 4
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 8
    Top = 112
  end
end
