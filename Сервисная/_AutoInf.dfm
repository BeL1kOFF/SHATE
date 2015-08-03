object AutoInfo: TAutoInfo
  Left = 0
  Top = 0
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086#1073' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077
  ClientHeight = 544
  ClientWidth = 588
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    588
    544)
  PixelsPerInch = 96
  TextHeight = 13
  object TypNameLabel: TLabel
    Left = 8
    Top = 8
    Width = 70
    Height = 13
    Caption = 'TypNameLabel'
  end
  object CloseBtn: TBitBtn
    Left = 508
    Top = 515
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 0
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000320B0000320B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF096EB0096EB0086098FF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF096EB0096EB01479B814
      79B8086098FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      096EB0096EB01680BF157DBC147AB91479B8086098394A6B394A6B394A6B394A
      6B394A6B394A6BFF00FFFF00FFFF00FF096EB01886C41783C11680BF157DBC14
      7CBA0860983D5B81085A8E085A8E085A8E085A8E394A6BFF00FFFF00FFFF00FF
      096EB01989C71886C41783C11680BF157FBD0860980F49340F47320F46320F45
      31104531394A6BFF00FFFF00FFFF00FF096EB01A8CCA1989C71886C41783C116
      82C0086098164D38164A36154935164633154431394A6BFF00FFFF00FFFF00FF
      096EB01B90CD1A8CCA1989C71886C41785C30860981C7A5B1C7C5E1D7D601E78
      5B1E7257394A6BFF00FFFF00FFFF00FF096EB01B93CF1B90CD22A6E221A2DE18
      88C60860981F83601E79581E6E4F1D6245205E43394A6BFF00FFFF00FFFF00FF
      096EB01C96D21B93CF22A6E2FFFFFF198BC80860985A7662798370959484AF9C
      8ABB9887394A6BFF00FFFF00FFFF00FF096EB01E9AD61C96D21B93CF1B91CE1A
      8ECB086098F0BAA4F0B297F1BFA8F0BFA8F1BFA9394A6BFF00FFFF00FFFF00FF
      096EB01F9EDA1E9AD61C96D21C94D11B91CE086098F0B79EF2BFA9F4E0D7F2C6
      AEF1A581394A6BFF00FFFF00FFFF00FF096EB021A2DE1F9EDA1E9AD61D98D41C
      94D1086098EE7B45F0A27DF1A986EF7D45F08956394A6BFF00FFFF00FFFF00FF
      096EB022A6E221A2DE1F9EDA1E9CD81D98D4086098ED733BEC6F34EB6F33EC6E
      32EE8655394A6BFF00FFFF00FFFF00FF096EB0096EB022A6E221A2DE20A0DC1E
      9CD8086098E96F3CE65F24E76731EE9D7BED946D394A6BFF00FFFF00FFFF00FF
      FF00FFFF00FF096EB0096EB021A4E020A0DC086098394A6B394A6B394A6B394A
      6B394A6B394A6BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF096EB009
      6EB0086098FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
  end
  object Grid: TDBGridEh
    Left = 5
    Top = 31
    Width = 578
    Height = 478
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
    DataSource = DataSource
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnGetCellParams = GridGetCellParams
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Param'
        Footers = <>
        Title.Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
        Width = 258
      end
      item
        EditButtons = <>
        FieldName = 'Value'
        Footers = <>
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      end>
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'AutoInfo\'
    StoredValues = <>
    Left = 32
    Top = 192
  end
  object AutoInfoTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    TableName = 'AutoInfo'
    Left = 29
    Top = 63
    object AutoInfoTableParam: TStringField
      FieldName = 'Param'
      Size = 100
    end
    object AutoInfoTableValue: TStringField
      FieldName = 'Value'
      Size = 100
    end
    object AutoInfoTableCaption: TBooleanField
      FieldName = 'Caption'
    end
  end
  object DataSource: TDataSource
    DataSet = AutoInfoTable
    Left = 32
    Top = 120
  end
end
