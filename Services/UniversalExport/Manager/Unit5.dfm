object Form5: TForm5
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Form5'
  ClientHeight = 259
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 289
    Height = 153
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    TabOrder = 0
    OnClick = Memo1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 184
    Width = 289
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 303
    Top = 182
    Width = 171
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 216
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 89
    Top = 216
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object Button2: TButton
    Left = 303
    Top = 8
    Width = 171
    Height = 25
    Caption = 'Button2'
    TabOrder = 5
    OnClick = Button2Click
  end
end
