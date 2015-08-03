object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dxRibbon: TdxRibbon
    Left = 0
    Top = 0
    Width = 635
    Height = 126
    BarManager = dxBarManager
    ColorSchemeName = 'Blue'
    Contexts = <>
    TabOrder = 4
    TabStop = False
    object dxRibbonTab1: TdxRibbonTab
      Active = True
      Caption = 'dxRibbonTab1'
      Groups = <
        item
          ToolbarName = 'dxBarManagerBar1'
        end>
      Index = 0
    end
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 80
    Top = 240
    DockControlHeights = (
      0
      0
      0
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
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
      Action = acConnections
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acLog
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 144
    Top = 240
    object acConnections: TAction
      Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
      OnExecute = acConnectionsExecute
    end
    object acLog: TAction
      Caption = #1051#1086#1075
      OnExecute = acLogExecute
    end
  end
end
