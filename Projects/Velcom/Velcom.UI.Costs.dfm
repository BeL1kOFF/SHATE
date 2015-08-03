object frmCost: TfrmCost
  Left = 0
  Top = 0
  Caption = #1057#1090#1072#1090#1100#1080
  ClientHeight = 485
  ClientWidth = 726
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
  object Panel6: TPanel
    Left = 0
    Top = 58
    Width = 726
    Height = 427
    Align = alClient
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 724
      Height = 425
      Align = alClient
      TabOrder = 0
      object cxTable: TcxGridTableView
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnMoving = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object colId_Costs: TcxGridColumn
          Caption = 'Id_Costs'
          Visible = False
        end
        object colName: TcxGridColumn
          Caption = #1057#1090#1072#1090#1100#1103
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 566
        end
        object colNDS: TcxGridColumn
          Caption = #1053#1044#1057
          HeaderAlignmentHorz = taCenter
          Width = 73
        end
        object colIsSubscriberService: TcxGridColumn
          Caption = #1040#1073#1086#1085'. '#1091#1089#1083#1091#1075#1072
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.ImmediatePost = True
          HeaderAlignmentHorz = taCenter
          Width = 83
        end
      end
      object cxLevel: TcxGridLevel
        GridView = cxTable
      end
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 64
    Top = 136
  end
  object dxBarManager1: TdxBarManager
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
          ItemName = 'dxBarLargeButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      UseRestSpace = True
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acSave
      Align = iaRight
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 160
    Top = 232
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
    end
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 14
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
  end
end
