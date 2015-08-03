object frmAdminServer: TfrmAdminServer
  Left = 0
  Top = 0
  Caption = #1057#1077#1088#1074#1077#1088#1072
  ClientHeight = 461
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
    Height = 415
    Align = alClient
    TabOrder = 4
    LookAndFeel.NativeStyle = False
    object tblServer: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      OnCellDblClick = tblServerCellDblClick
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
      object colId_Server: TcxGridColumn
        Visible = False
      end
      object colServerName: TcxGridColumn
        Caption = #1057#1077#1088#1074#1077#1088
        HeaderAlignmentHorz = taCenter
        Width = 230
      end
      object colEnabled: TcxGridColumn
        Caption = #1042#1082#1083#1102#1095#1077#1085
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = tblServer
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
    Left = 168
    Top = 232
  end
  object ttDelServer: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id_Server'
      end>
    TableName = 'tmpDelServer'
    Left = 64
    Top = 120
  end
end
