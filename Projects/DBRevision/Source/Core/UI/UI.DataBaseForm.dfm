object frmDataBase: TfrmDataBase
  Left = 0
  Top = 0
  Caption = #1057#1087#1080#1089#1086#1082' '#1073#1072#1079' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 58
    Width = 635
    Height = 242
    Align = alClient
    TabOrder = 4
    object tblDataBase: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      OnEditValueChanged = tblDataBaseEditValueChanged
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnMoving = False
      OptionsData.Appending = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colIdDataBase: TcxGridColumn
        Visible = False
      end
      object colServer: TcxGridColumn
        Caption = #1057#1077#1088#1074#1077#1088
        HeaderAlignmentHorz = taCenter
        Width = 211
      end
      object colDataBase: TcxGridColumn
        Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
        HeaderAlignmentHorz = taCenter
        Width = 309
      end
      object colLocal: TcxGridColumn
        Caption = #1053#1077' '#1087#1088#1086#1076#1091#1082#1090#1080#1074
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.NullStyle = nssUnchecked
        HeaderAlignmentHorz = taCenter
        Width = 113
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = tblDataBase
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
    ImageOptions.LargeImages = frmMain.cxImageListLarge
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 48
    Top = 224
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
          ItemName = 'btnRefresh'
        end
        item
          Visible = True
          ItemName = 'btnSave'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      UseRestSpace = True
      Visible = True
      WholeRow = False
    end
    object btnRefresh: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
    object btnSave: TdxBarLargeButton
      Action = acSave
      Align = iaRight
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 128
    Top = 224
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 3
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 4
      OnExecute = acRefreshExecute
    end
  end
  object qrQuery: TFDQuery
    Connection = frmMain.FDConnection
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvUnifyParams]
    Left = 216
    Top = 232
  end
end
