object frmEmployeeExternalCode: TfrmEmployeeExternalCode
  Left = 0
  Top = 0
  Caption = #1042#1085#1077#1096#1085#1080#1077' '#1082#1086#1076#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
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
    object cxTable: TcxGridBandedTableView
      OnEditValueChanged = cxTableEditValueChanged
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      Bands = <
        item
          FixedKind = fkLeft
          Width = 139
        end
        item
          Width = 501
        end>
      object cxTableColumn1: TcxGridBandedColumn
        Visible = False
        Options.Editing = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxTableColumn2: TcxGridBandedColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
    end
    object cxLevel: TcxGridLevel
      GridView = cxTable
    end
  end
  object dxBarManager1: TdxBarManager
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
    Left = 40
    Top = 232
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
      FloatLeft = 669
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end>
      MultiLine = True
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100'...'
      Category = 0
      Visible = ivAlways
      LargeImageIndex = 7
    end
  end
  object ActionList1: TActionList
    Left = 120
    Top = 256
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 240
    Top = 152
  end
end
