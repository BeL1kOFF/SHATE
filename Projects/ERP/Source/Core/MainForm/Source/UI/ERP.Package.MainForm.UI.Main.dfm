object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'ERP '#1064#1072#1090#1077'-'#1052
  ClientHeight = 562
  ClientWidth = 988
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  WindowState = wsMaximized
  OnCanResize = FormCanResize
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dxRibbon: TdxRibbon
    Left = 0
    Top = 0
    Width = 988
    Height = 60
    ApplicationButton.Menu = dxRibbonBackstageView
    BarManager = dxBarManager
    Style = rs2010
    ColorSchemeName = 'Caramel'
    MinimizeOnTabDblClick = False
    PopupMenuItems = []
    QuickAccessToolbar.Toolbar = tbQuickAccess
    Contexts = <>
    TabOrder = 0
    TabStop = False
    OnResize = dxRibbonResize
  end
  object dxRibbonBackstageView: TdxRibbonBackstageView
    Left = 320
    Top = 120
    Width = 617
    Height = 300
    Buttons = <>
    Ribbon = dxRibbon
    OnCloseUp = dxRibbonBackstageViewCloseUp
    OnPopup = dxRibbonBackstageViewPopup
    object dxRibbonBackstageViewTabSheet1: TdxRibbonBackstageViewTabSheet
      Left = 132
      Top = 0
      Active = True
      Caption = #1057#1077#1088#1074#1077#1088#1072
      object cbDBList: TcxComboBox
        Left = 32
        Top = 47
        Properties.DropDownListStyle = lsFixedList
        Properties.OnChange = cbDBListPropertiesChange
        TabOrder = 0
        Width = 289
      end
      object cxLabel1: TcxLabel
        Left = 32
        Top = 24
        Caption = #1041#1072#1079#1099' '#1076#1072#1085#1085#1099#1093':'
        Transparent = True
      end
      object btnRefresh: TButton
        Left = 248
        Top = 88
        Width = 75
        Height = 25
        Action = acRefresh
        TabOrder = 2
      end
    end
  end
  object pcWindowManager: TcxPageControl
    Left = 0
    Top = 60
    Width = 209
    Height = 502
    Align = alLeft
    TabOrder = 6
    Properties.CustomButtons.Buttons = <>
    Properties.NavigatorPosition = npLeftTop
    Properties.Options = [pcoAlwaysShowGoDialogButton, pcoGoDialog, pcoGradient, pcoGradientClientArea, pcoRedrawOnResize, pcoSort]
    Properties.TabPosition = tpLeft
    ClientRectBottom = 495
    ClientRectLeft = 4
    ClientRectRight = 202
    ClientRectTop = 4
  end
  object splMain: TcxSplitter
    Left = 209
    Top = 60
    Width = 6
    Height = 502
    Control = pcWindowManager
    OnMoved = splMainMoved
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
    ImageOptions.LargeImages = cxImageList
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 320
    Top = 448
    DockControlHeights = (
      0
      0
      0
      0)
    object tbQuickAccess: TdxBar
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 816
      FloatTop = 8
      FloatClientWidth = 57
      FloatClientHeight = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lDataBaseName'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object lDataBaseName: TcxBarEditItem
      Category = 0
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
  end
  object dxSkinController: TdxSkinController
    NativeStyle = False
    SkinName = 'Caramel'
    Left = 424
    Top = 448
  end
  object cxLookAndFeelController: TcxLookAndFeelController
    NativeStyle = False
    SkinName = 'Caramel'
    Left = 560
    Top = 448
  end
  object cxImageList: TcxImageList
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 29360816
  end
  object ApplicationEvents: TApplicationEvents
    OnMessage = ApplicationEventsMessage
    Left = 256
    Top = 104
  end
  object ActionList: TActionList
    Left = 760
    Top = 448
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnExecute = acRefreshExecute
      OnUpdate = acRefreshUpdate
    end
  end
end
