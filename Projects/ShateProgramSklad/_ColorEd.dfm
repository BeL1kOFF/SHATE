inherited ClientIDEdit: TClientIDEdit
  Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1082#1083#1080#1077#1085#1090#1072
  ClientHeight = 114
  ClientWidth = 338
  Position = poMainFormCenter
  ExplicitWidth = 344
  ExplicitHeight = 146
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnBevel: TBevel
    Top = 72
    Width = 331
  end
  object Label1: TLabel [1]
    Left = 6
    Top = 12
    Width = 83
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
  end
  object Label2: TLabel [2]
    Left = 8
    Top = 40
    Width = 81
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  inherited OkBtn: TBitBtn
    Left = 96
    Top = 81
    TabOrder = 2
  end
  inherited CancelBtn: TBitBtn
    Left = 230
    Top = 81
    TabOrder = 3
  end
  object ClientIdEd: TDBEdit
    Left = 96
    Top = 9
    Width = 98
    Height = 21
    DataField = 'Client_ID'
    TabOrder = 0
  end
  object DescriptionEd: TDBEdit
    Left = 96
    Top = 37
    Width = 232
    Height = 21
    DataField = 'Description'
    TabOrder = 1
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = '%FORM_NAME%'
    StoredValues = <>
    Left = 240
    Top = 24
  end
end
