inherited FlatSpr: TFlatSpr
  Left = 400
  Top = 411
  HelpContext = 7
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
  ClientHeight = 295
  ClientWidth = 390
  Position = poMainFormCenter
  ExplicitWidth = 398
  ExplicitHeight = 329
  PixelsPerInch = 96
  TextHeight = 13
  inherited GridPanel1: TPanel
    Width = 390
    Height = 295
    ExplicitWidth = 390
    ExplicitHeight = 295
    inherited Grid1: TDBGridEh
      Width = 390
      Height = 254
      DataSource = DataSource
    end
    inherited AdvDockPanel1: TAdvDockPanel
      Width = 390
      ExplicitWidth = 390
      inherited ToolBar: TAdvToolBar
        Width = 384
        ExplicitWidth = 384
      end
    end
  end
  object NvgTable: TDBISAMTable [1]
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    Left = 216
    Top = 144
  end
  object FormStorage: TJvFormStorage [2]
    AppStoragePath = 'FlatSpr\'
    StoredValues = <>
    Left = 45
    Top = 199
  end
  inherited GridPopupMenu: TPopupMenu
    Left = 44
    Top = 145
  end
  inherited ActionList: TActionList
    Left = 141
    Top = 94
  end
  inherited ImageList: TImageList
    Left = 43
    Top = 94
  end
  inherited ToolBarStyler: TAdvToolBarOfficeStyler
    Left = 216
    Top = 96
  end
  object DataSource: TDataSource
    DataSet = Table
    Left = 143
    Top = 197
  end
  object Table: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filtered = True
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    Left = 143
    Top = 144
  end
end
