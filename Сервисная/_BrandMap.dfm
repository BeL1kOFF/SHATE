object BrandMap: TBrandMap
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1041#1088#1077#1085#1076#1099
  ClientHeight = 371
  ClientWidth = 522
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 315
    Top = 346
    Width = 91
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 426
    Top = 346
    Width = 91
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 1
    OnClick = Button2Click
  end
  object DBCheckBox1: TDBCheckBox
    Left = 8
    Top = 350
    Width = 290
    Height = 17
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1088#1080' '#1080#1084#1087#1086#1088#1090#1077' '#1079#1072#1082#1072#1079#1086#1074' '#1076#1072#1085#1085#1091#1102' '#1090#1072#1073#1083#1080#1094#1091
    DataField = 'bReplBrand'
    DataSource = Data.ParamDataSource
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBGridEh1: TDBGridEh
    Left = 0
    Top = 0
    Width = 522
    Height = 344
    Align = alTop
    DataSource = Data.DS_mapBrand4ImportOrder
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'replBrand'
        Footers = <>
        Title.Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1091#1077#1084#1099#1081' '#1073#1088#1077#1085#1076
        Width = 272
      end
      item
        ButtonStyle = cbsEllipsis
        EditButtons = <>
        FieldName = 'serviceBrand'
        Footers = <>
        Title.Caption = #1041#1088#1077#1085#1076' '#1074' '#1089#1077#1088#1074#1080#1089#1085#1086#1081
        Width = 224
        OnEditButtonClick = DBGridEh1Columns1EditButtonClick
      end>
  end
  object PopupMenu1: TPopupMenu
    Left = 300
    Top = 235
    object N1: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = N3Click
    end
  end
end
