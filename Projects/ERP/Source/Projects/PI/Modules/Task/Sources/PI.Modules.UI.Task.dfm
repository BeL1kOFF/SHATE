object frmTask: TfrmTask
  Left = 0
  Top = 0
  Caption = 'frmTask'
  ClientHeight = 300
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
    Height = 254
    Align = alClient
    TabOrder = 4
    object tblTask: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      OnCellDblClick = tblTaskCellDblClick
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.MultiSelect = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colId_Task: TcxGridColumn
        Visible = False
      end
      object colName: TcxGridColumn
        Caption = #1047#1072#1076#1072#1085#1080#1077
        HeaderAlignmentHorz = taCenter
      end
      object colGuid: TcxGridColumn
        Caption = 'Guid'
        HeaderAlignmentHorz = taCenter
      end
      object colEnable: TcxGridColumn
        Caption = #1042#1082#1083#1102#1095#1077#1085#1086
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
      end
      object colSynchronize: TcxGridColumn
        Caption = #1057#1080#1085#1093#1088#1086#1085#1085#1086#1077
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
      end
      object colIsMemory: TcxGridColumn
        Caption = #1042' '#1087#1072#1084#1103#1090#1080
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxLevel: TcxGridLevel
      GridView = tblTask
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
    Left = 72
    Top = 208
    DockControlHeights = (
      0
      0
      46
      0)
    object barMain: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 669
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnAdd'
        end
        item
          Visible = True
          ItemName = 'btnEdit'
        end
        item
          Visible = True
          ItemName = 'btnDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'btnRefresh'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object btnAdd: TdxBarLargeButton
      Action = acAdd
      Category = 0
    end
    object btnEdit: TdxBarLargeButton
      Action = acEdit
      Category = 0
    end
    object btnDelete: TdxBarLargeButton
      Action = acDelete
      Category = 0
    end
    object btnRefresh: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 240
    Top = 200
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
  object ttTaskDel: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id_Task'
      end>
    TableName = 'tmpTaskDelete'
    Left = 232
    Top = 96
  end
end
