object frmImportExternal: TfrmImportExternal
  Left = 0
  Top = 0
  Caption = #1048#1084#1087#1086#1088#1090
  ClientHeight = 311
  ClientWidth = 643
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
  object cxGrid: TcxGrid
    Left = 0
    Top = 56
    Width = 643
    Height = 255
    Align = alClient
    TabOrder = 4
    object cxTable: TcxGridTableView
      OnKeyUp = cxTableKeyUp
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
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnMoving = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.MultiSelect = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colIdImportEmployee: TcxGridColumn
        Visible = False
      end
      object colEmployeeExternalCode: TcxGridColumn
        Caption = #1050#1086#1076' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
        HeaderAlignmentHorz = taCenter
      end
      object colFIO: TcxGridColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
        HeaderAlignmentHorz = taCenter
      end
      object colDepartmentExternalCode: TcxGridColumn
        Caption = #1050#1086#1076' '#1086#1090#1076#1077#1083#1072
        HeaderAlignmentHorz = taCenter
      end
      object colNameDepartment: TcxGridColumn
        Caption = #1054#1090#1076#1077#1083
        HeaderAlignmentHorz = taCenter
      end
      object colStatus: TcxGridColumn
        Caption = #1054#1096#1080#1073#1082#1072
        HeaderAlignmentHorz = taCenter
      end
      object colIdExternalSystem: TcxGridColumn
        Visible = False
      end
      object colSystemName: TcxGridColumn
        Caption = #1057#1080#1089#1090#1077#1084#1072
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxLevel: TcxGridLevel
      GridView = cxTable
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    CursorType = ctStatic
    Parameters = <>
    Left = 152
    Top = 208
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
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
    Left = 280
    Top = 224
    DockControlHeights = (
      0
      0
      56
      0)
    object dxBarManager1Bar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 562
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton3'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acImport
      Category = 0
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Action = acDelete
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 384
    Top = 136
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
    end
    object acImport: TAction
      Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
      ImageIndex = 22
      OnExecute = acImportExecute
      OnUpdate = acImportUpdate
    end
    object acDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100'...'
      ImageIndex = 4
      OnExecute = acDeleteExecute
      OnUpdate = acDeleteUpdate
    end
  end
end
