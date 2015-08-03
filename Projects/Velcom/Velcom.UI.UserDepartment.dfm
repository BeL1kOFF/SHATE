object frmUserDepartment: TfrmUserDepartment
  Left = 0
  Top = 0
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080'/'#1054#1090#1076#1077#1083#1099
  ClientHeight = 492
  ClientWidth = 933
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
  object Panel11: TPanel
    Left = 0
    Top = 58
    Width = 933
    Height = 434
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object cxGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 933
      Height = 434
      Align = alClient
      TabOrder = 0
      object cxTable: TcxGridBandedTableView
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.BandMoving = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        Bands = <
          item
            FixedKind = fkLeft
            Width = 85
          end
          item
          end>
        object cxTableColumn1: TcxGridBandedColumn
          Caption = 'Id_User'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object cxTableColumn2: TcxGridBandedColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
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
    Left = 248
    Top = 360
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
      FloatLeft = 959
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
    Left = 328
    Top = 320
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
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 248
    Top = 224
  end
end
