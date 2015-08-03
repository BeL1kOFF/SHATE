object TableView: TTableView
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1090#1072#1073#1083#1080#1094
  ClientHeight = 512
  ClientWidth = 827
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 827
    Height = 512
    Align = alClient
    DataSource = DataSource
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'TableView\'
    StoredValues = <>
    Left = 216
    Top = 48
  end
  object DataSource: TDataSource
    DataSet = ADODataSet
    Left = 106
    Top = 208
  end
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=tcd_error_0;Persist Security Info=Tr' +
      'ue;User ID=tecdoc;Data Source=SHTMP_TECDOC'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 105
    Top = 89
  end
  object ADODataSet: TADODataSet
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    Left = 104
    Top = 152
  end
end
