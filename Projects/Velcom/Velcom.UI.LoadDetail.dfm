object frmLoadDetail: TfrmLoadDetail
  Left = 0
  Top = 0
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 443
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
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 643
    Height = 179
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 643
      Height = 154
      Align = alClient
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object sbLoad: TdxStatusBar
      Left = 0
      Top = 154
      Width = 643
      Height = 25
      Panels = <
        item
          PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
          Width = 250
        end
        item
          PanelStyleClassName = 'TdxStatusBarContainerPanelStyle'
          PanelStyle.Container = dxStatusBar1Container0
          Width = 150
        end
        item
          PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      object dxStatusBar1Container0: TdxStatusBarContainerControl
        Left = 256
        Top = 4
        Width = 148
        Height = 19
        object pb: TcxProgressBar
          Left = 0
          Top = 0
          Align = alClient
          TabOrder = 0
          Width = 148
        end
      end
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 58
    Width = 643
    Height = 206
    Align = alClient
    TabOrder = 5
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
      object colId: TcxGridColumn
        Visible = False
      end
      object colPeriod: TcxGridColumn
        Caption = #1055#1077#1088#1080#1086#1076
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
    Left = 304
    Top = 240
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
      FloatLeft = 669
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton3'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acLoad
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1074#1086#1085#1082#1080'...'
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acDelete
      Category = 0
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = acLoadClient
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1083#1080#1077#1085#1090#1086#1074'...'
      Category = 0
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 280
    Top = 176
  end
  object ActionList: TActionList
    Left = 352
    Top = 88
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
    end
    object acLoad: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1074#1086#1085#1082#1080
      ImageIndex = 18
      OnExecute = acLoadExecute
    end
    object acDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 4
      OnExecute = acDeleteExecute
      OnUpdate = acDeleteUpdate
    end
    object acLoadClient: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1083#1080#1077#1085#1090#1086#1074
      ImageIndex = 19
      OnExecute = acLoadClientExecute
    end
  end
  object odExcel: TOpenDialog
    Filter = #1060#1072#1081#1083#1099' Excel 2003|*.xls'
    Left = 208
    Top = 216
  end
end
