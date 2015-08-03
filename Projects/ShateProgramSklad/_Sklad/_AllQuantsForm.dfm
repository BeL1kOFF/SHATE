object AllQuantsForm: TAllQuantsForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 149
  ClientWidth = 76
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbNames: TLabel
    Left = 0
    Top = 0
    Width = 53
    Height = 149
    Align = alClient
    Alignment = taRightJustify
    Caption = #1058#1086#1095#1082#1072' 1'#13#10#1058#1086#1095#1082#1072' 2'#13#10#1058#1086#1095#1082#1072' 3'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 52
  end
  object lbValues: TLabel
    Left = 56
    Top = 0
    Width = 20
    Height = 149
    Align = alRight
    AutoSize = False
    Caption = '1'#13#10'2'#13#10'3'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitLeft = 55
  end
  object Splitter1: TSplitter
    Left = 53
    Top = 0
    Height = 149
    Align = alRight
    AutoSnap = False
    MinSize = 20
    ExplicitLeft = 52
  end
end
