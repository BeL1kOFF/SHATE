object frmCatalogMerge: TfrmCatalogMerge
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'frmCatalogMerge'
  ClientHeight = 543
  ClientWidth = 787
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
  object Panel1: TPanel
    Left = 0
    Top = 502
    Width = 787
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      787
      41)
    object btnMerge: TButton
      Left = 16
      Top = 6
      Width = 75
      Height = 25
      Action = acMerge
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 697
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 787
    Height = 443
    Align = alClient
    TabOrder = 1
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 785
      Height = 441
      Align = alClient
      TabOrder = 0
      object tblMerge: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        OnCellDblClick = tblMergeCellDblClick
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnSorting = False
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        Styles.OnGetContentStyle = tblMergeStylesGetContentStyle
      end
      object cxLevel: TcxGridLevel
        GridView = tblMerge
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 443
    Width = 787
    Height = 59
    Align = alBottom
    TabOrder = 2
    object cxGridResult: TcxGrid
      Left = 1
      Top = 1
      Width = 785
      Height = 57
      Align = alClient
      TabOrder = 0
      object tblMergeResult: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
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
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
      end
      object cxLevelResult: TcxGridLevel
        GridView = tblMergeResult
      end
    end
  end
  object ActionList: TActionList
    Left = 80
    Top = 176
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
    object acMerge: TAction
      Caption = #1057#1083#1080#1103#1085#1080#1077
      OnExecute = acMergeExecute
      OnUpdate = acMergeUpdate
    end
  end
  object qrQuery: TFDQuery
    Left = 168
    Top = 176
  end
  object qrQueryMeta: TFDQuery
    Left = 272
    Top = 176
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 224
    Top = 104
    PixelsPerInch = 96
    object stlGreen: TcxStyle
      AssignedValues = [svColor]
      Color = clMoneyGreen
    end
    object stlRed: TcxStyle
      AssignedValues = [svColor]
      Color = 8421631
    end
    object stlYellow: TcxStyle
      AssignedValues = [svColor]
      Color = 8454143
    end
    object stlBlue: TcxStyle
      AssignedValues = [svColor]
      Color = 16744448
    end
  end
  object ttDraftMerge: TsmFireDACTempTable
    Fields = <>
    TableName = 'tmpDraftMerge'
    Left = 80
    Top = 96
  end
  object ttDraftId: TsmFireDACTempTable
    Fields = <
      item
        FieldName = 'Id_Draft'
      end>
    TableName = 'tmpDraftId'
    Left = 80
    Top = 40
  end
end
