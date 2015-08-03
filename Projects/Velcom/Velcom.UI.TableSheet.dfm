object frmTableSheet: TfrmTableSheet
  Left = 0
  Top = 0
  Caption = #1058#1072#1073#1077#1083#1100
  ClientHeight = 518
  ClientWidth = 881
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
    Top = 84
    Width = 881
    Height = 434
    Align = alClient
    TabOrder = 4
    object cxTable: TcxGridBandedTableView
      OnEditValueChanged = cxTableEditValueChanged
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.BandMoving = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      OnCustomDrawColumnHeader = cxTableCustomDrawColumnHeader
      Bands = <
        item
          FixedKind = fkLeft
          Width = 415
        end
        item
        end>
      object colIdEmployee: TcxGridBandedColumn
        Visible = False
        Options.Editing = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colEmployeeName: TcxGridBandedColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
        HeaderAlignmentHorz = taCenter
        MinWidth = 200
        Options.Editing = False
        Width = 200
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colDepartmentName: TcxGridBandedColumn
        Caption = #1054#1090#1076#1077#1083
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 108
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object colDistributionCost: TcxGridBandedColumn
        Caption = #1048#1079#1076#1077#1088#1078#1082#1072
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 107
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
    end
    object cxLevel: TcxGridLevel
      GridView = cxTable
    end
  end
  object ActionList: TActionList
    Left = 40
    Top = 168
    object acAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      ImageIndex = 2
    end
    object acEdit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'...'
      ImageIndex = 3
    end
    object acDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 4
    end
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
      OnUpdate = acRefreshUpdate
    end
    object acExternalCode: TAction
      Caption = #1042#1085#1077#1096#1085#1080#1077' '#1082#1086#1076#1099'...'
      ImageIndex = 6
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
    Left = 96
    Top = 240
    DockControlHeights = (
      0
      0
      84
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
          ItemName = 'btnRefresh'
        end>
      MultiLine = True
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object dxBarManagerBar2: TdxBar
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 2'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 58
      DockingStyle = dsTop
      FloatLeft = 907
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxBarEditItem1'
        end
        item
          Visible = True
          ItemName = 'edtBeginDate'
        end
        item
          Visible = True
          ItemName = 'cxBarEditItem3'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 105
          Visible = True
          ItemName = 'edtEndDate'
        end>
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object btnRefresh: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = #1057' '
      Category = 0
      Hint = #1057' '
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object edtBeginDate: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxDateEditProperties'
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ShowTime = False
      Properties.ValidateOnEnter = False
    end
    object cxBarEditItem3: TcxBarEditItem
      Caption = ' '#1087#1086' '
      Category = 0
      Hint = ' '#1087#1086' '
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object edtEndDate: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxDateEditProperties'
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 144
    Top = 264
  end
end
