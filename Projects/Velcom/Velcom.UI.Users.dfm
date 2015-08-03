object frmUsers: TfrmUsers
  Left = 0
  Top = 0
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
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
    Top = 58
    Width = 643
    Height = 253
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
      OnEditValueChanged = cxTableEditValueChanged
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnMoving = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.MultiSelect = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colId: TcxGridColumn
        Visible = False
      end
      object colName: TcxGridColumn
        Caption = #1070#1079#1077#1088
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 201
      end
      object colLogin: TcxGridColumn
        AlternateCaption = 'CanLogin'
        Caption = #1042#1093#1086#1076
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.NullStyle = nssInactive
        HeaderAlignmentHorz = taCenter
        Width = 110
      end
      object colUser: TcxGridColumn
        AlternateCaption = 'CanUser'
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.NullStyle = nssInactive
        HeaderAlignmentHorz = taCenter
        Width = 110
      end
      object colWrite: TcxGridColumn
        AlternateCaption = 'CanWrite'
        Caption = #1056#1077#1076#1072#1082#1090#1086#1088
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.NullStyle = nssInactive
        HeaderAlignmentHorz = taCenter
        Width = 110
      end
      object colAdmin: TcxGridColumn
        AlternateCaption = 'CanAdmin'
        Caption = #1040#1076#1084#1080#1085
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.NullStyle = nssInactive
        HeaderAlignmentHorz = taCenter
        Width = 110
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
    Left = 208
    Top = 208
    DockControlHeights = (
      0
      0
      58
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
      FloatLeft = 669
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton5'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton5: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 288
    Top = 216
    object acAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      ImageIndex = 2
    end
    object acDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 4
    end
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 376
    Top = 240
  end
end
