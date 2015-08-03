inherited TextAttr: TTextAttr
  Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1090#1077#1082#1089#1090#1072
  ClientHeight = 132
  ClientWidth = 257
  Position = poScreenCenter
  ExplicitWidth = 263
  ExplicitHeight = 158
  DesignSize = (
    257
    132)
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnBevel: TBevel
    Top = 90
    Width = 250
    ExplicitTop = 82
    ExplicitWidth = 250
  end
  inherited OkBtn: TBitBtn
    Left = 15
    Top = 99
    TabOrder = 3
    ExplicitLeft = 15
    ExplicitTop = 121
  end
  inherited CancelBtn: TBitBtn
    Left = 149
    Top = 99
    TabOrder = 4
    ExplicitLeft = 149
    ExplicitTop = 121
  end
  object Memo: TMemo
    Left = 38
    Top = 13
    Width = 181
    Height = 25
    Alignment = taCenter
    Lines.Strings = (
      #1054#1073#1088#1072#1079#1077#1094' '#1090#1077#1082#1089#1090#1072)
    TabOrder = 0
  end
  object BackgroundBtn: TBitBtn
    Left = 38
    Top = 49
    Width = 86
    Height = 25
    Caption = #1060#1086#1085
    TabOrder = 1
    OnClick = BackgroundBtnClick
  end
  object FontBtn: TBitBtn
    Left = 136
    Top = 49
    Width = 83
    Height = 25
    Caption = #1064#1088#1080#1092#1090
    TabOrder = 2
    OnClick = FontBtnClick
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'TextAttr\'
    StoredValues = <>
    Left = 240
    Top = 88
  end
  object ColorDialog: TColorDialog
    Left = 240
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 240
    Top = 40
  end
end
