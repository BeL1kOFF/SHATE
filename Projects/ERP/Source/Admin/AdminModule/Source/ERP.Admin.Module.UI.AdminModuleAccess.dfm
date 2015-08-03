object frmAdminModuleAccess: TfrmAdminModuleAccess
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1060#1091#1085#1082#1094#1080#1086#1085#1072#1083' '#1084#1086#1076#1091#1083#1103
  ClientHeight = 538
  ClientWidth = 869
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
    Top = 46
    Width = 869
    Height = 492
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = False
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
      object colName: TcxGridColumn
        Caption = #1044#1086#1089#1090#1091#1087
        HeaderAlignmentHorz = taCenter
        Width = 459
      end
      object colBit: TcxGridColumn
        Caption = #1041#1080#1090
        HeaderAlignmentHorz = taCenter
        Width = 174
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = tblModules
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 40
    Top = 240
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
      FloatLeft = 379
      FloatTop = 63
      FloatClientWidth = 105
      FloatClientHeight = 126
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton4'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = acRefresh
      Category = 0
      SyncImageIndex = False
      ImageIndex = 1
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 328
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnExecute = acRefreshExecute
    end
  end
  object qrQuery: TFDQuery
    Left = 240
    Top = 272
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
    Left = 48
    Top = 176
  end
end
