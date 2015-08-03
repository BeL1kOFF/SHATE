object frmAdminModuleAutoRegister: TfrmAdminModuleAutoRegister
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1040#1074#1090#1086#1088#1077#1075#1080#1089#1090#1088#1072#1090#1086#1088' '#1084#1086#1076#1091#1083#1077#1081
  ClientHeight = 404
  ClientWidth = 849
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
    Top = 46
    Width = 849
    Height = 249
    Align = alClient
    TabOrder = 1
    object tblModules: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
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
      object colId_TemplateDataBase: TcxGridColumn
        Visible = False
      end
      object colTemplateDataBaseName: TcxGridColumn
        Caption = #1064#1072#1073#1083#1086#1085' '#1041#1044
        HeaderAlignmentHorz = taCenter
      end
      object colModuleName: TcxGridColumn
        Caption = #1052#1086#1076#1091#1083#1100
        HeaderAlignmentHorz = taCenter
      end
      object colGUID: TcxGridColumn
        Caption = 'GUID'
        HeaderAlignmentHorz = taCenter
      end
      object colFileName: TcxGridColumn
        Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = tblModules
    end
  end
  object dxStatusBar1: TdxStatusBar
    Left = 0
    Top = 384
    Width = 849
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarContainerPanelStyle'
        PanelStyle.Container = dxStatusBar1Container0
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    object dxStatusBar1Container0: TdxStatusBarContainerControl
      Left = 2
      Top = 4
      Width = 829
      Height = 14
      object pbScan: TcxProgressBar
        Left = 0
        Top = 0
        Align = alClient
        TabOrder = 0
        Width = 829
      end
    end
  end
  object mLog: TcxMemo
    Left = 0
    Top = 295
    Align = alBottom
    Properties.ReadOnly = True
    Properties.ScrollBars = ssVertical
    TabOrder = 6
    Height = 89
    Width = 849
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 272
    Top = 216
    DockControlHeights = (
      0
      0
      46
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
          ItemName = 'dxBarLargeButton2'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acScan
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acRegister
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 376
    Top = 224
    object acScan: TAction
      Caption = #1057#1082#1072#1085#1080#1088#1086#1074#1072#1090#1100
      OnExecute = acScanExecute
    end
    object acRegister: TAction
      Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100
      OnExecute = acRegisterExecute
      OnUpdate = acRegisterUpdate
    end
  end
  object qrQuery: TFDQuery
    Left = 160
    Top = 160
  end
  object ttModuleAccess: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        MSSQLDataType = mftNVarChar
        FieldName = 'Name'
        Precision = 0
        Size = 255
      end
      item
        Attributes = [fttaRequired]
        FieldName = 'Bit'
      end>
    TableName = 'tblModuleAccess'
    Left = 152
    Top = 256
  end
end
