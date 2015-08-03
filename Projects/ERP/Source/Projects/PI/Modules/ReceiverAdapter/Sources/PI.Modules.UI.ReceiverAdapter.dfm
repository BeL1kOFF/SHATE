object frmReceiverAdapter: TfrmReceiverAdapter
  Left = 0
  Top = 0
  Caption = 'frmReceiverAdapter'
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
  object cxGrid1: TcxGrid
    Left = 0
    Top = 46
    Width = 635
    Height = 254
    Align = alClient
    TabOrder = 4
    object tblReceiverAdapter: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
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
      object tblReceiverAdapterColumn1: TcxGridColumn
      end
      object tblReceiverAdapterColumn2: TcxGridColumn
      end
      object tblReceiverAdapterColumn3: TcxGridColumn
      end
      object tblReceiverAdapterColumn4: TcxGridColumn
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = tblReceiverAdapter
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
    end
    object acEdit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'...'
    end
    object acDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    end
  end
end
