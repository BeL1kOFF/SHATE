object TTNRetDocInformationForm: TTTNRetDocInformationForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1044#1072#1085#1085#1099#1077' '#1058#1058#1053' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
  ClientHeight = 250
  ClientWidth = 876
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GridPanel: TPanel
    Left = 0
    Top = 0
    Width = 876
    Height = 250
    Align = alClient
    Caption = 'GridPanel'
    TabOrder = 0
    ExplicitTop = 8
    ExplicitWidth = 901
    ExplicitHeight = 96
    object OrderGrid: TDBGridEh
      Left = 1
      Top = 1
      Width = 874
      Height = 248
      Align = alClient
      AutoFitColWidths = True
      Constraints.MinWidth = 250
      DataSource = Data.DSmemRetDocTTNInfo
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
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = [fsBold]
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Adress'
          Footers = <>
          Title.Caption = #1040#1076#1088#1077#1089
          Width = 220
        end
        item
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
          Width = 130
        end
        item
          EditButtons = <>
          FieldName = 'No'
          Footers = <>
          Title.Caption = #1053#1086#1084#1077#1088' '#1087#1091#1090#1077#1074#1086#1075#1086' '#1083#1080#1089#1090#1072
        end
        item
          EditButtons = <>
          FieldName = 'DriverName'
          Footers = <>
          Title.Caption = #1060#1048#1054' '#1074#1086#1076#1080#1090#1077#1083#1103
          Width = 160
        end
        item
          EditButtons = <>
          FieldName = 'Model'
          Footers = <>
          Title.Caption = #1052#1086#1076#1077#1083#1100' '#1072#1074#1090#1086
          Width = 118
        end
        item
          EditButtons = <>
          FieldName = 'StateNumber'
          Footers = <>
          Title.Caption = #1053#1086#1084#1077#1088' '#1072#1074#1090#1086
          Width = 150
        end>
    end
  end
  object TextPanel: TPanel
    Left = 0
    Top = 0
    Width = 876
    Height = 250
    Align = alClient
    Caption = 'TextPanel'
    TabOrder = 1
    ExplicitLeft = 2
    ExplicitTop = 128
    ExplicitWidth = 899
    object memoInfromation: TMemo
      Left = 1
      Top = 1
      Width = 874
      Height = 248
      Align = alClient
      ReadOnly = True
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 120
      ExplicitWidth = 896
      ExplicitHeight = 258
    end
  end
end
