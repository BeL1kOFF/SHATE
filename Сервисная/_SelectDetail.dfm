object SelectDetail: TSelectDetail
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 113
  ClientWidth = 656
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DBGridEh: TDBGridEh
    Left = 0
    Top = 0
    Width = 656
    Height = 113
    Align = alClient
    AutoFitColWidths = True
    DataSource = DataSource
    Flat = True
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
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    OnDblClick = DBGridEhDblClick
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Code'
        Footers = <>
        Title.Caption = #1050#1086#1076
        Width = 161
      end
      item
        EditButtons = <>
        FieldName = 'BrandName'
        Footers = <>
        Title.Caption = #1041#1088#1077#1085#1076
        Width = 165
      end
      item
        EditButtons = <>
        FieldName = 'Description'
        Footers = <>
        Width = 281
      end>
  end
  object DataSource: TDataSource
    DataSet = Data.DoubleTable
    Left = 576
    Top = 16
  end
end
