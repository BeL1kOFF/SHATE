object frmAdminTemplateDataBase: TfrmAdminTemplateDataBase
  Left = 0
  Top = 0
  Caption = 'frmAdminTemplateDataBase'
  ClientHeight = 387
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 46
    Width = 635
    Height = 341
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object tblTemplate: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      OnCellDblClick = tblTemplateCellDblClick
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnMoving = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.MultiSelect = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colIdTemplateDataBase: TcxGridColumn
        Visible = False
      end
      object colName: TcxGridColumn
        Caption = #1064#1072#1073#1083#1086#1085
        HeaderAlignmentHorz = taCenter
        Width = 488
      end
      object colTypeDB: TcxGridColumn
        Caption = #1058#1080#1087
        HeaderAlignmentHorz = taCenter
        Width = 145
      end
      object colVisible: TcxGridColumn
        Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = tblTemplate
    end
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 40
    Top = 240
    DockControlHeights = (
      0
      0
      46
      0)
    object dxBarManagerBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 379
      FloatTop = 63
      FloatClientWidth = 105
      FloatClientHeight = 126
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end
        item
          Visible = True
          ItemName = 'btnEdit'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton4'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acAdd
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acDelete
      Category = 0
    end
    object btnEdit: TdxBarLargeButton
      Action = acEdit
      Category = 0
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = acRefresh
      Category = 0
      SyncImageIndex = False
      ImageIndex = 1
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 328
    object acAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      OnExecute = acAddExecute
    end
    object acEdit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'...'
      OnExecute = acEditExecute
      OnUpdate = acEditUpdate
    end
    object acDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = acDeleteExecute
      OnUpdate = acDeleteUpdate
    end
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnExecute = acRefreshExecute
    end
  end
  object qrQuery: TFDQuery
    Left = 192
    Top = 104
  end
  object ttDelTemplateDataBase: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id_TemplateDataBase'
      end>
    TableName = 'tmpDelTemplateDataBase'
    Left = 64
    Top = 120
  end
end
