object SearchGrid: TSearchGrid
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'SearchGrid'
  ClientHeight = 100
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Grid: TDBGridEh
    Left = 0
    Top = 0
    Width = 634
    Height = 100
    Align = alClient
    AutoFitColWidths = True
    DataSource = SearchDataSource
    Flat = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    OnDblClick = GridDblClick
    OnEnter = GridEnter
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Code'
        Footers = <>
        Title.Caption = #1050#1086#1076
        Width = 86
      end
      item
        EditButtons = <>
        FieldName = 'BrandName'
        Footers = <>
        Title.Caption = #1041#1088#1077#1085#1076
        Width = 102
      end
      item
        EditButtons = <>
        FieldName = 'Descr'
        Footers = <>
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 402
      end>
  end
  object SearchDataSource: TDataSource
    DataSet = Data.DoubleTable
    Left = 336
    Top = 32
  end
end
