object frmReportNumber: TfrmReportNumber
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1085#1086#1084#1077#1088#1072#1084
  ClientHeight = 452
  ClientWidth = 1054
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 84
    Width = 1054
    Height = 368
    Align = alClient
    TabOrder = 4
    object cxTable: TcxGridDBBandedTableView
      OnCellDblClick = cxTableCellDblClick
      DataController.DataSource = dsCallers
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Column = colSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = colSumWork
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = colSumNoWork
        end
        item
          Format = #1050#1086#1083'-'#1074#1086' '#1079#1072#1087#1080#1089#1077#1081': 0'
          Kind = skCount
          Column = cikAbonentName
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsData.Deleting = False
      OptionsData.Inserting = False
      OptionsSelection.MultiSelect = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaderHeight = 31
      Bands = <
        item
          Caption = #1053#1086#1084#1077#1088
          Width = 88
        end
        item
          Caption = #1040#1073#1086#1085#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
          Width = 256
        end
        item
          Caption = #1054#1090#1076#1077#1083' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072
          Width = 201
        end
        item
          Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
          Width = 220
        end
        item
          Caption = #1074#1089#1077#1075#1086
          Position.BandIndex = 3
          Position.ColIndex = 0
        end
        item
          Caption = #1088#1072#1073'. '#1074#1088#1077#1084#1103
          Position.BandIndex = 3
          Position.ColIndex = 1
        end
        item
          Caption = #1085#1077#1088#1072#1073'. '#1074#1088#1077#1084#1103
          Position.BandIndex = 3
          Position.ColIndex = 2
        end
        item
          Caption = #1053#1077#1074#1080#1076#1080#1084#1099#1077
          Visible = False
        end>
      object colNumber: TcxGridDBBandedColumn
        AlternateCaption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'Number'
        Options.Editing = False
        Width = 78
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cikAbonentName: TcxGridDBBandedColumn
        AlternateCaption = #1040#1073#1086#1085#1077#1085#1090
        DataBinding.FieldName = 'AbonentName'
        Options.Editing = False
        Styles.OnGetContentStyle = cikAbonentNameStylesGetContentStyle
        Width = 226
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object colDepartment: TcxGridDBBandedColumn
        AlternateCaption = #1054#1090#1076#1077#1083
        DataBinding.FieldName = 'DepartmentName'
        Options.Editing = False
        Width = 177
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object colSum: TcxGridDBBandedColumn
        AlternateCaption = #1074#1089#1077#1075#1086
        DataBinding.FieldName = 'Summa'
        RepositoryItem = DM.edtRepFloat
        Options.Editing = False
        Position.BandIndex = 4
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object colSumWork: TcxGridDBBandedColumn
        AlternateCaption = #1088#1072#1073'. '#1074#1088#1077#1084#1103
        DataBinding.FieldName = 'SummaWork'
        RepositoryItem = DM.edtRepFloat
        Options.Editing = False
        Position.BandIndex = 5
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object colSumNoWork: TcxGridDBBandedColumn
        AlternateCaption = #1085#1077#1088#1072#1073'. '#1074#1088#1077#1084#1103
        DataBinding.FieldName = 'SummaNoWork'
        RepositoryItem = DM.edtRepFloat
        Options.Editing = False
        Position.BandIndex = 6
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object colCallerId: TcxGridDBBandedColumn
        AlternateCaption = 'Id_Caller'
        DataBinding.FieldName = 'Id_Caller'
        Position.BandIndex = 7
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object colAbonentExists: TcxGridDBBandedColumn
        AlternateCaption = 'IsAbonentExists'
        DataBinding.FieldName = 'IsAbonentExists'
        Position.BandIndex = 7
        Position.ColIndex = 1
        Position.RowIndex = 0
        IsCaptionAssigned = True
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
    Left = 64
    Top = 216
    DockControlHeights = (
      0
      0
      84
      0)
    object dxBarManager1Bar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 58
      DockingStyle = dsTop
      FloatLeft = 669
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxBarEditItem1'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 286
          Visible = True
          ItemName = 'edtPeriods'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarManagerBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 2'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 955
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarManagerBar2: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 3'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 200
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 955
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnDetail'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      UseRestSpace = True
      Visible = True
      WholeRow = False
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = #1055#1077#1088#1080#1086#1076': '
      Category = 0
      Hint = #1055#1077#1088#1080#1086#1076': '
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object edtPeriods: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 15
      Properties.ItemHeight = 13
    end
    object btnRefresh: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
    object btnDetail: TdxBarLargeButton
      Action = acDetail
      Align = iaRight
      Category = 0
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acSaveExcel
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 128
    Top = 216
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
      OnUpdate = acRefreshUpdate
    end
    object acDetail: TAction
      Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1087#1086#13#10' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1085#1086#1084#1077#1088#1072#1084'...'
      ImageIndex = 10
      OnExecute = acDetailExecute
      OnUpdate = acDetailUpdate
    end
    object acSaveExcel: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' Excel...'
      ImageIndex = 11
      OnExecute = acSaveExcelExecute
      OnUpdate = acSaveExcelUpdate
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    CommandTimeout = 60000
    Parameters = <>
    Left = 448
    Top = 248
  end
  object qrCallers: TADOQuery
    Connection = MainForm.connVelcom
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 248
    Top = 312
  end
  object dsCallers: TDataSource
    DataSet = qrCallers
    Left = 296
    Top = 312
  end
end
