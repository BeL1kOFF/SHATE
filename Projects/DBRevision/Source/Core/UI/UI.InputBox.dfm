object frmInputBox: TfrmInputBox
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmInputBox'
  ClientHeight = 103
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lText: TLabel
    Left = 24
    Top = 7
    Width = 24
    Height = 13
    Caption = 'lText'
  end
  object edtValue: TEdit
    Left = 24
    Top = 26
    Width = 345
    Height = 21
    TabOrder = 0
    Text = 'edtValue'
  end
  object btnCancel: TButton
    Left = 294
    Top = 63
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 206
    Top = 63
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 1
  end
end
