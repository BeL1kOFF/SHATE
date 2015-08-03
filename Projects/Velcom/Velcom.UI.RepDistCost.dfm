object frmDistCost: TfrmDistCost
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1080#1079#1076#1077#1088#1078#1082#1072#1084
  ClientHeight = 300
  ClientWidth = 635
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
    Width = 635
    Height = 216
    Align = alClient
    TabOrder = 4
    object tblReport: TcxGridTableView
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Column = colPrice
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnMoving = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      object colDistributionCost: TcxGridColumn
        Caption = #1048#1079#1076#1077#1088#1078#1082#1080
        HeaderAlignmentHorz = taCenter
      end
      object colPrice: TcxGridColumn
        Caption = #1057#1091#1084#1084#1072
        DataBinding.ValueType = 'Float'
        HeaderAlignmentHorz = taCenter
      end
      object colPercentPrice: TcxGridColumn
        Caption = #1055#1088#1086#1094#1077#1085#1090
        DataBinding.ValueType = 'Float'
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxLevel: TcxGridLevel
      GridView = tblReport
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
    Left = 80
    Top = 200
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
      FloatLeft = 669
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
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarManagerBar2: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 2'
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
          ItemName = 'cxBarEditItem2'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 271
          Visible = True
          ItemName = 'cbPeriod'
        end>
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
    object dxBarEdit1: TdxBarEdit
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object cxBarEditItem2: TcxBarEditItem
      Caption = #1055#1077#1088#1080#1086#1076': '
      Category = 0
      Hint = #1055#1077#1088#1080#1086#1076': '
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object cbPeriod: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 15
      Properties.ItemHeight = 13
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acExcel
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 160
    Top = 208
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = acRefreshExecute
      OnUpdate = acRefreshUpdate
    end
    object acExcel: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' Excel...'
      ImageIndex = 11
      OnExecute = acExcelExecute
      OnUpdate = acExcelUpdate
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 232
    Top = 216
  end
end
