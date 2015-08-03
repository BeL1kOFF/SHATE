inherited QuantTextAttr: TQuantTextAttr
  Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1090#1077#1082#1089#1090#1072' '#1087#1088#1080' '#1085#1072#1083#1080#1095#1080#1080
  ClientHeight = 159
  ClientWidth = 272
  ExplicitWidth = 278
  ExplicitHeight = 191
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnBevel: TBevel
    Top = 117
    Width = 265
    ExplicitTop = 121
  end
  object Label1: TLabel [1]
    Left = 15
    Top = 17
    Width = 57
    Height = 13
    Caption = #1053#1072#1083#1080#1095#1080#1077' '#1086#1090
  end
  object Label2: TLabel [2]
    Left = 154
    Top = 17
    Width = 12
    Height = 13
    Caption = #1076#1086
  end
  inherited OkBtn: TBitBtn
    Left = 30
    Top = 126
    TabOrder = 5
    ExplicitTop = 130
  end
  inherited CancelBtn: TBitBtn
    Left = 164
    Top = 126
    TabOrder = 6
    ExplicitTop = 130
  end
  inherited Memo: TMemo
    Top = 46
    Width = 204
    TabOrder = 2
    ExplicitTop = 46
    ExplicitWidth = 204
  end
  inherited BackgroundBtn: TBitBtn
    Top = 82
    TabOrder = 3
    ExplicitTop = 82
  end
  inherited FontBtn: TBitBtn
    Left = 159
    Top = 82
    TabOrder = 4
    ExplicitLeft = 159
    ExplicitTop = 82
  end
  object LoEd: TJvValidateEdit [8]
    Left = 80
    Top = 14
    Width = 70
    Height = 21
    CriticalPoints.MaxValueIncluded = False
    CriticalPoints.MinValueIncluded = False
    TabOrder = 0
  end
  object HiEd: TJvValidateEdit [9]
    Left = 172
    Top = 14
    Width = 71
    Height = 21
    CriticalPoints.MaxValueIncluded = False
    CriticalPoints.MinValueIncluded = False
    TabOrder = 1
  end
  inherited FormStorage: TJvFormStorage
    Left = 104
    Top = 112
  end
  inherited ColorDialog: TColorDialog
    Left = 24
    Top = 112
  end
  inherited FontDialog: TFontDialog
    Left = 64
    Top = 112
  end
end
