object frmCaller: TfrmCaller
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1085#1086#1084#1077#1088#1086#1074
  ClientHeight = 311
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 116
    Width = 643
    Height = 195
    Align = alClient
    TabOrder = 4
    object cxTable: TcxGridTableView
      Navigator.Buttons.First.Visible = True
      Navigator.Buttons.PriorPage.Visible = True
      Navigator.Buttons.Prior.Visible = True
      Navigator.Buttons.Next.Visible = True
      Navigator.Buttons.NextPage.Visible = True
      Navigator.Buttons.Last.Visible = True
      Navigator.Buttons.Insert.Visible = True
      Navigator.Buttons.Append.Visible = False
      Navigator.Buttons.Delete.Visible = True
      Navigator.Buttons.Edit.Visible = True
      Navigator.Buttons.Post.Visible = True
      Navigator.Buttons.Cancel.Visible = True
      Navigator.Buttons.Refresh.Visible = True
      Navigator.Buttons.SaveBookmark.Visible = True
      Navigator.Buttons.GotoBookmark.Visible = True
      Navigator.Buttons.Filter.Visible = True
      OnCellDblClick = cxTableCellDblClick
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnGrouping = False
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
      object colIdCaller: TcxGridColumn
        Visible = False
      end
      object colNumber: TcxGridColumn
        Caption = #1053#1086#1084#1077#1088
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object colEmployeeName: TcxGridColumn
        Caption = #1058#1077#1082#1091#1097#1080#1081' '#1089#1086#1090#1088#1091#1076#1085#1080#1082
        HeaderAlignmentHorz = taCenter
      end
      object colDepartmentName: TcxGridColumn
        Caption = #1058#1077#1082#1091#1097#1080#1081' '#1086#1090#1076#1077#1083
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxLevel: TcxGridLevel
      GridView = cxTable
    end
  end
  object ActionList: TActionList
    Left = 64
    Top = 160
    object acAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      ImageIndex = 2
      OnExecute = acAddExecute
      OnUpdate = acAddUpdate
    end
    object acEdit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'...'
      ImageIndex = 3
      OnExecute = acEditExecute
      OnUpdate = acEditUpdate
    end
    object acDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 4
      OnExecute = acDeleteExecute
      OnUpdate = acDeleteUpdate
    end
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
    end
    object acExternalCode: TAction
      Caption = #1042#1085#1077#1096#1085#1080#1077' '#1082#1086#1076#1099'...'
      ImageIndex = 6
    end
    object acChange: TAction
      Caption = #1053#1072#1079#1085#1072#1095#1080#1090#1100
      ImageIndex = 24
      OnExecute = acChangeExecute
      OnUpdate = acChangeUpdate
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
    ImageOptions.LargeImages = DM.ilLargeImage
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 120
    Top = 232
    DockControlHeights = (
      0
      0
      116
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
      FloatLeft = 544
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      IsMainMenu = True
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
      MultiLine = True
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object dxBarManagerBar2: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 2'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 58
      DockingStyle = dsTop
      FloatLeft = 677
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxBarEditItem2'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 317
          Visible = True
          ItemName = 'cmbEmployee'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 136
          Visible = True
          ItemName = 'dtDateActive'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end>
      OneOnRow = True
      Row = 1
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
    object btnExtCode: TdxBarLargeButton
      Action = acExternalCode
      Category = 0
    end
    object cmbEmployee: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediatePost = True
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acChange
      Category = 0
    end
    object cxBarEditItem2: TcxBarEditItem
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
      Category = 0
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object dtDateActive: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxDateEditProperties'
      Properties.DateButtons = [btnToday]
      Properties.ImmediatePost = True
      Properties.SaveTime = False
      Properties.ShowTime = False
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 168
    Top = 256
  end
end
