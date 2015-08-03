object frmReportNumberDetail: TfrmReportNumberDetail
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1085#1086#1084#1077#1088#1072#1084' - '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103
  ClientHeight = 437
  ClientWidth = 1109
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 85
    Width = 1109
    Height = 352
    Align = alClient
    TabOrder = 4
    object cxTable: TcxGridDBBandedTableView
      DataController.DataSource = dsReport
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Column = cxTableColumn3
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = cxTableColumn4
        end
        item
          Format = #1050#1086#1083'-'#1074#1086' '#1079#1072#1087#1080#1089#1077#1081': 0'
          Kind = skCount
          Column = cxTableColumn1
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaderHeight = 22
      Bands = <
        item
          Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
          Width = 89
        end
        item
          Caption = #1042#1088#1077#1084#1103
          Width = 134
        end
        item
          Caption = #1044#1083#1080#1090'., '#1089#1077#1082
          Width = 63
        end
        item
          Caption = #1057#1091#1084#1084#1072
          Width = 88
        end
        item
          Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
          Width = 71
        end
        item
          Caption = #1050#1086#1084#1091
          Width = 297
        end
        item
          Caption = #1053#1086#1084#1077#1088
          Position.BandIndex = 5
          Position.ColIndex = 0
          Width = 78
        end
        item
          Caption = #1040#1073#1086#1085#1077#1085#1090
          Position.BandIndex = 5
          Position.ColIndex = 1
          Width = 121
        end
        item
          Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
          Position.BandIndex = 5
          Position.ColIndex = 2
          Width = 76
        end
        item
          Caption = #1057#1090#1072#1090#1100#1103' '#1088#1072#1089#1093#1086#1076#1072
          Width = 300
        end
        item
          Caption = #1050#1086#1076' '#1086#1087'.'
          Width = 72
        end
        item
          Caption = #1053#1077#1074#1080#1076#1080#1084#1099#1081
          Visible = False
        end>
      object cxTableColumn14: TcxGridDBBandedColumn
        AlternateCaption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
        DataBinding.FieldName = 'EmployeeName'
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn1: TcxGridDBBandedColumn
        AlternateCaption = #1042#1088#1077#1084#1103
        DataBinding.FieldName = 'CallDateTime'
        Styles.Content = DM.stlDefault
        Styles.OnGetContentStyle = cxTableColumn1StylesGetContentStyle
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn2: TcxGridDBBandedColumn
        AlternateCaption = #1044#1083#1080#1090'., '#1089#1077#1082
        DataBinding.FieldName = 'Duration'
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn3: TcxGridDBBandedColumn
        AlternateCaption = #1057#1091#1084#1084#1072
        DataBinding.FieldName = 'Price'
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn4: TcxGridDBBandedColumn
        AlternateCaption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
        DataBinding.FieldName = 'PriceWithVAT'
        Position.BandIndex = 4
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn5: TcxGridDBBandedColumn
        AlternateCaption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'CallNumber'
        Styles.Content = DM.stlDefault
        Styles.OnGetContentStyle = cxTableColumn5StylesGetContentStyle
        Position.BandIndex = 6
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn6: TcxGridDBBandedColumn
        AlternateCaption = #1040#1073#1086#1085#1077#1085#1090
        DataBinding.FieldName = 'AbonentWhom'
        Styles.Content = DM.stlDefault
        Styles.OnGetContentStyle = cxTableColumn6StylesGetContentStyle
        Position.BandIndex = 7
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn13: TcxGridDBBandedColumn
        AlternateCaption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
        DataBinding.FieldName = 'Reference'
        Styles.Content = DM.stlDefault
        Styles.OnGetContentStyle = cxTableColumn13StylesGetContentStyle
        Position.BandIndex = 8
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn7: TcxGridDBBandedColumn
        AlternateCaption = #1057#1090#1072#1090#1100#1103' '#1088#1072#1089#1093#1086#1076#1072
        DataBinding.FieldName = 'CostName'
        Position.BandIndex = 9
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn8: TcxGridDBBandedColumn
        AlternateCaption = #1050#1086#1076' '#1086#1087'.'
        DataBinding.FieldName = 'TypeCode'
        Position.BandIndex = 10
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn9: TcxGridDBBandedColumn
        AlternateCaption = #1056#1072#1073'. '#1074#1088#1077#1084#1103
        DataBinding.FieldName = 'IsWorkTime'
        Visible = False
        Position.BandIndex = 11
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn10: TcxGridDBBandedColumn
        AlternateCaption = #1053#1072#1096' '#1072#1073#1086#1085#1077#1085#1090
        DataBinding.FieldName = 'IsAbonent'
        Visible = False
        Position.BandIndex = 11
        Position.ColIndex = 1
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object cxTableColumn11: TcxGridDBBandedColumn
        AlternateCaption = 'COST_ID'
        DataBinding.FieldName = 'Id_Cost'
        Position.BandIndex = 11
        Position.ColIndex = 2
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
    Left = 32
    Top = 344
    DockControlHeights = (
      0
      0
      85
      0)
    object dxBarManagerBar2: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 2'
      CaptionButtons = <>
      Color = 16773087
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 58
      DockingStyle = dsTop
      FloatLeft = 973
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxBarEditItem1'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 278
          Visible = True
          ItemName = 'edtCaller'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'cxBarEditItem8'
        end
        item
          Visible = True
          ItemName = 'edtTimeFilter'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = True
      UseRestSpace = True
      Visible = True
      WholeRow = True
    end
    object dxBarManagerBar3: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 3'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 1135
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
          ItemName = 'dxBarLargeButton4'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarManagerBar4: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 4'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 200
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 1135
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          UserDefine = [udWidth]
          UserWidth = 557
          Visible = True
          ItemName = 'edtMail'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      UseRestSpace = True
      Visible = True
      WholeRow = False
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1087#1086' '#1085#1086#1084#1077#1088#1091': '
      Category = 0
      Hint = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1087#1086' '#1085#1086#1084#1077#1088#1091': '
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object cxBarEditItem8: TcxBarEditItem
      Caption = '  '#1042#1088#1077#1084#1103': '
      Category = 0
      Hint = '  '#1042#1088#1077#1084#1103': '
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object edtMail: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxTextEditProperties'
      Properties.OnChange = edtMailPropertiesChange
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acMail
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Align = iaRight
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = acSaveExcel
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' Excel...'
      Category = 0
    end
    object edtTimeFilter: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.DropDownListStyle = lsFixedList
      Properties.ImmediatePost = True
      Properties.Items.Strings = (
        '* '#1074#1089#1077' *'
        #1088#1072#1073#1086#1095#1077#1077
        #1085#1077#1088#1072#1073#1086#1095#1077#1077)
      InternalEditValue = '* '#1074#1089#1077' *'
    end
    object edtCaller: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.DropDownListStyle = lsFixedList
      Properties.ImmediatePost = True
    end
  end
  object qrReport: TADOQuery
    Connection = MainForm.connVelcom
    CommandTimeout = 60000
    Parameters = <>
    Left = 80
    Top = 200
  end
  object dsReport: TDataSource
    DataSet = qrReport
    Left = 120
    Top = 200
  end
  object ActionList: TActionList
    Left = 80
    Top = 344
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
    end
    object acSaveExcel: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' Excel'
      ImageIndex = 11
      OnExecute = acSaveExcelExecute
      OnUpdate = acSaveExcelUpdate
    end
    object acMail: TAction
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
      ImageIndex = 7
      OnExecute = acMailExecute
      OnUpdate = acMailUpdate
    end
  end
end
