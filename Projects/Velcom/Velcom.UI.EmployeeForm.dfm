object frmEmployeeForm: TfrmEmployeeForm
  Left = 0
  Top = 0
  Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
  ClientHeight = 375
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 58
    Width = 750
    Height = 317
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
      object colIdEmployee: TcxGridColumn
        Visible = False
      end
      object colName: TcxGridColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object colDepartment: TcxGridColumn
        Caption = #1058#1077#1082#1091#1097#1080#1081' '#1086#1090#1076#1077#1083
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object colNumber: TcxGridColumn
        Caption = #1058#1077#1082#1091#1097#1080#1081' '#1085#1086#1084#1077#1088
        HeaderAlignmentHorz = taCenter
      end
      object colBeginTime: TcxGridColumn
        Caption = #1053#1072#1095#1072#1083#1086' '#1088#1072#1073#1086#1090#1099
        PropertiesClassName = 'TcxTimeEditProperties'
        HeaderAlignmentHorz = taCenter
      end
      object colEndTime: TcxGridColumn
        Caption = #1050#1086#1085#1077#1094' '#1088#1072#1073#1086#1090#1099
        PropertiesClassName = 'TcxTimeEditProperties'
        HeaderAlignmentHorz = taCenter
      end
      object colIsExternalCode: TcxGridColumn
        Caption = #1042#1085#1077#1096#1085#1080#1081' '#1082#1086#1076
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxLevel: TcxGridLevel
      GridView = cxTable
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
      58
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
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'btnExtCode'
        end>
      MultiLine = True
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
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
      OnExecute = acExternalCodeExecute
      OnUpdate = acExternalCodeUpdate
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 168
    Top = 256
  end
end
