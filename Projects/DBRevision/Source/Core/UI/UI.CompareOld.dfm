object frmCompareOld: TfrmCompareOld
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1089' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1084#1080' '#1074#1077#1088#1089#1080#1103#1084#1080
  ClientHeight = 310
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 645
    Height = 310
    Align = alClient
    TabOrder = 0
    object tblDiff: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      OnCellDblClick = tblDiffCellDblClick
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colIdSQLScriptOld: TcxGridColumn
        Caption = 'ID'
        DataBinding.ValueType = 'Integer'
        HeaderAlignmentHorz = taCenter
      end
      object colCreateUser: TcxGridColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        HeaderAlignmentHorz = taCenter
      end
      object colCreateDate: TcxGridColumn
        Caption = #1044#1072#1090#1072
        DataBinding.ValueType = 'DateTime'
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxLevel: TcxGridLevel
      GridView = tblDiff
    end
  end
  object qrQuery: TFDQuery
    Connection = frmMain.FDConnection
    Left = 40
    Top = 136
  end
end
