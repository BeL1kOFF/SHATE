object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #1041#1044' Revision'
  ClientHeight = 713
  ClientWidth = 1082
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 433
    Top = 86
    Height = 594
    ExplicitLeft = 504
    ExplicitTop = 328
    ExplicitHeight = 100
  end
  object sbInfo: TdxStatusBar
    Left = 0
    Top = 680
    Width = 1082
    Height = 33
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarContainerPanelStyle'
        PanelStyle.Container = dxStatusBar1Container0
        Width = 100
      end
      item
        PanelStyleClassName = 'TdxStatusBarContainerPanelStyle'
        PanelStyle.Container = dxStatusBar1Container1
        Width = 200
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        Fixed = False
        Width = 200
      end
      item
        PanelStyleClassName = 'TdxStatusBarContainerPanelStyle'
        PanelStyle.Container = sbInfoContainer3
        Fixed = False
        Width = 100
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    object dxStatusBar1Container0: TdxStatusBarContainerControl
      Left = 2
      Top = 4
      Width = 98
      Height = 27
      object cbDBCommited: TcxCheckBox
        Left = 0
        Top = 0
        Align = alClient
        Action = acDBCommited
        TabOrder = 0
        Width = 98
      end
    end
    object dxStatusBar1Container1: TdxStatusBarContainerControl
      Left = 106
      Top = 4
      Width = 198
      Height = 27
      object cxLabel1: TcxLabel
        Left = 3
        Top = 3
        Caption = #1055#1086#1080#1089#1082':'
      end
      object edtFind: TcxTextEdit
        Left = 47
        Top = 3
        Properties.OnChange = edtFindPropertiesChange
        TabOrder = 1
        OnKeyDown = edtFindKeyDown
        Width = 148
      end
    end
    object sbInfoContainer3: TdxStatusBarContainerControl
      Left = 778
      Top = 4
      Width = 232
      Height = 27
      object pbProgress: TcxProgressBar
        Left = 0
        Top = 0
        Align = alClient
        ParentColor = False
        Properties.PeakValue = 100.000000000000000000
        Properties.ShowTextStyle = cxtsText
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 0
        Width = 232
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 86
    Width = 433
    Height = 594
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 0
      Top = 400
      Width = 433
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitLeft = -3
      ExplicitTop = 416
    end
    object pnlDBCommited: TPanel
      Left = 0
      Top = 403
      Width = 433
      Height = 191
      Align = alBottom
      TabOrder = 0
      Visible = False
      object cxGridDBC: TcxGrid
        Left = 1
        Top = 1
        Width = 431
        Height = 189
        Align = alClient
        TabOrder = 0
        object tblDBCommited: TcxGridTableView
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
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          Styles.OnGetContentStyle = tblDBCommitedStylesGetContentStyle
          object colDBCServer: TcxGridColumn
            Caption = #1057#1077#1088#1074#1077#1088
            HeaderAlignmentHorz = taCenter
            Width = 187
          end
          object colDBCDataBase: TcxGridColumn
            Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
            HeaderAlignmentHorz = taCenter
            Width = 174
          end
          object colDBCIsCommited: TcxGridColumn
            Caption = #1042#1099#1087#1086#1083#1085#1077#1085
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            Width = 68
          end
          object colDBCIsAccess: TcxGridColumn
            Visible = False
          end
        end
        object cxLevelDBC: TcxGridLevel
          GridView = tblDBCommited
        end
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 433
      Height = 400
      Align = alClient
      TabOrder = 1
      object cxGridSS: TcxGrid
        Left = 1
        Top = 1
        Width = 431
        Height = 398
        Align = alClient
        TabOrder = 0
        object tblSQLScript: TcxGridTableView
          Navigator.Buttons.CustomButtons = <>
          OnFocusedRecordChanged = tblSQLScriptFocusedRecordChanged
          OnSelectionChanged = tblSQLScriptSelectionChanged
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          DataController.OnDataChanged = tblSQLScriptDataControllerDataChanged
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
          Styles.OnGetContentStyle = tblSQLScriptStylesGetContentStyle
          object colIdSQLScript: TcxGridColumn
            Visible = False
          end
          object colIndex: TcxGridColumn
            Caption = #8470
            HeaderAlignmentHorz = taCenter
            Width = 53
          end
          object colIdStatus: TcxGridColumn
            Caption = #1057#1090#1072#1090#1091#1089
            OnCustomDrawCell = colIdStatusCustomDrawCell
            HeaderAlignmentHorz = taCenter
            Width = 57
          end
          object colLabel: TcxGridColumn
            Caption = #1052#1077#1090#1082#1072
            HeaderAlignmentHorz = taCenter
          end
          object colRevision: TcxGridColumn
            Caption = 'Rev.'
            HeaderAlignmentHorz = taCenter
          end
          object colName: TcxGridColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            HeaderAlignmentHorz = taCenter
            Width = 177
          end
          object colCreateUser: TcxGridColumn
            Caption = #1057#1086#1079#1076#1072#1083
          end
          object colCreateDate: TcxGridColumn
            Caption = #1057#1086#1079#1076#1072#1085#1072
          end
          object colChangeUser: TcxGridColumn
            Caption = #1048#1079#1084#1077#1085#1080#1083
          end
          object colChangeDate: TcxGridColumn
            Caption = #1048#1079#1084#1077#1085#1077#1085#1072
          end
          object colIsCommit: TcxGridColumn
            Caption = 'Commit'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.ReadOnly = True
          end
          object colOrder: TcxGridColumn
            Visible = False
            IsCaptionAssigned = True
          end
          object colFind: TcxGridColumn
            Visible = False
          end
        end
        object cxLevelSS: TcxGridLevel
          GridView = tblSQLScript
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 436
    Top = 86
    Width = 646
    Height = 594
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 5
    object Splitter3: TSplitter
      Left = 0
      Top = 370
      Width = 646
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 0
    end
    object Panel3: TPanel
      Left = 0
      Top = 373
      Width = 646
      Height = 221
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object SynMemoRollback: TSynMemo
        Left = 0
        Top = 0
        Width = 646
        Height = 221
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        PopupMenu = pmBody
        TabOrder = 0
        OnEnter = SynMemoRollbackEnter
        OnExit = SynMemoRollbackExit
        OnKeyDown = SynMemoRollbackKeyDown
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Highlighter = SynSQLSyn
        ReadOnly = True
        RightEdge = 120
        SearchEngine = SynEditSearch
        TabWidth = 2
        OnChange = SynMemoRollbackChange
        FontSmoothing = fsmNone
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 646
      Height = 370
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object SynMemoCommit: TSynMemo
        Left = 0
        Top = 0
        Width = 646
        Height = 370
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        PopupMenu = pmBody
        TabOrder = 0
        OnEnter = SynMemoCommitEnter
        OnExit = SynMemoCommitExit
        OnKeyDown = SynMemoCommitKeyDown
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Highlighter = SynSQLSyn
        ReadOnly = True
        RightEdge = 120
        SearchEngine = SynEditSearch
        TabWidth = 2
        OnChange = SynMemoCommitChange
        FontSmoothing = fsmNone
      end
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
    ImageOptions.Images = cxImageList
    ImageOptions.LargeImages = cxImageListLarge
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 504
    Top = 488
    DockControlHeights = (
      0
      0
      86
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
          UserDefine = [udWidth]
          UserWidth = 180
          Visible = True
          ItemName = 'cmbProfile'
        end
        item
          Visible = True
          ItemName = 'btnProfile'
        end
        item
          BeginGroup = True
          UserDefine = [udWidth]
          UserWidth = 257
          Visible = True
          ItemName = 'cmbDBList'
        end
        item
          BeginGroup = True
          UserDefine = [udWidth]
          UserWidth = 283
          Visible = True
          ItemName = 'cmbTemplateList'
        end
        item
          Visible = True
          ItemName = 'btnTemplateList'
        end
        item
          Visible = True
          ItemName = 'btnLinkTemplate'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
      MultiLine = True
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      UseRestSpace = True
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
      DockedTop = 28
      DockingStyle = dsTop
      FloatLeft = 669
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnAdd'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'tbnUp'
        end
        item
          Visible = True
          ItemName = 'btnDown'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'btnLabel'
        end
        item
          Visible = True
          ItemName = 'btnRevision'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'btnSave'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'btnRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'btnCommit'
        end
        item
          Visible = True
          ItemName = 'btnRollback'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      UseRestSpace = True
      Visible = True
      WholeRow = False
    end
    object cmbDBList: TdxBarCombo
      Caption = #1041#1044
      Category = 0
      Hint = #1041#1044
      Visible = ivAlways
      OnChange = cmbDBListChange
      ShowCaption = True
      ShowEditor = False
      ItemIndex = -1
    end
    object btnProfile: TdxBarButton
      Caption = ' ... '
      Category = 0
      Hint = '  '
      Visible = ivAlways
      OnClick = btnProfileClick
    end
    object btnAdd: TdxBarLargeButton
      Action = acAdd
      Category = 0
      SyncImageIndex = False
      ImageIndex = -1
    end
    object cmbTemplateList: TdxBarCombo
      Caption = #1064#1072#1073#1083#1086#1085
      Category = 0
      Hint = #1064#1072#1073#1083#1086#1085
      Visible = ivAlways
      OnChange = cmbTemplateListChange
      ShowCaption = True
      ShowEditor = False
      ItemIndex = -1
    end
    object btnTemplateList: TdxBarButton
      Caption = ' ... '
      Category = 0
      Hint = '  '
      Visible = ivAlways
      OnClick = btnTemplateListClick
    end
    object btnLinkTemplate: TdxBarButton
      Action = acLinkTemplate
      Category = 0
    end
    object btnLabel: TdxBarLargeButton
      Action = acLabel
      Category = 0
      SyncImageIndex = False
      ImageIndex = -1
    end
    object btnSave: TdxBarLargeButton
      Action = acSave
      Category = 0
      SyncImageIndex = False
      ImageIndex = -1
    end
    object btnRefresh: TdxBarLargeButton
      Action = acRefresh
      Category = 0
      SyncImageIndex = False
      ImageIndex = -1
    end
    object btnCommit: TdxBarLargeButton
      Action = acCommit
      Category = 0
      SyncImageIndex = False
      ImageIndex = -1
    end
    object btnRollback: TdxBarLargeButton
      Action = acRollback
      Category = 0
      SyncImageIndex = False
      ImageIndex = -1
    end
    object dxBarButton1: TdxBarButton
      Action = acDataBase
      Align = iaRight
      Category = 0
    end
    object cmbProfile: TdxBarCombo
      Caption = #1055#1088#1086#1092#1080#1083#1100
      Category = 0
      Hint = #1055#1088#1086#1092#1080#1083#1100
      Visible = ivAlways
      OnChange = cmbProfileChange
      ShowCaption = True
      ShowEditor = False
      ItemIndex = -1
    end
    object btnRevision: TdxBarLargeButton
      Action = acRevision
      Category = 0
    end
    object tbnUp: TdxBarLargeButton
      Action = acUp
      Category = 0
    end
    object btnDown: TdxBarLargeButton
      Action = acDown
      Category = 0
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acHelp
      Align = iaRight
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acRepair
      Category = 0
    end
  end
  object FDConnection: TFDConnection
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    LoginPrompt = False
    Left = 41
    Top = 168
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    DriverID = 'MSSQL'
    VendorLib = 'sqlncli11.dll'
    ODBCDriver = 'SQL Server Native Client 11.0'
    Left = 137
    Top = 168
  end
  object qrQuery: TFDQuery
    Connection = FDConnection
    Left = 241
    Top = 168
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 337
    Top = 168
  end
  object SynSQLSyn: TSynSQLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Foreground = clGreen
    DelimitedIdentifierAttri.Foreground = clTeal
    FunctionAttri.Foreground = clFuchsia
    IdentifierAttri.Foreground = clTeal
    KeyAttri.Foreground = clBlue
    StringAttri.Foreground = clRed
    SymbolAttri.Foreground = clGray
    VariableAttri.Foreground = clTeal
    SQLDialect = sqlMSSQL2K
    Left = 801
    Top = 288
  end
  object ActionList: TActionList
    Left = 633
    Top = 490
    object acAdd: TAction
      Category = 'ToolBar'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      ImageIndex = 0
      ShortCut = 16462
      OnExecute = acAddExecute
      OnUpdate = acAddUpdate
    end
    object acUp: TAction
      Category = 'ToolBar'
      Caption = #1042#1074#1077#1088#1093
      ImageIndex = 8
      ShortCut = 16469
      OnExecute = acUpExecute
      OnUpdate = acUpUpdate
    end
    object acDown: TAction
      Category = 'ToolBar'
      Caption = #1042#1085#1080#1079
      ImageIndex = 9
      ShortCut = 16457
      OnExecute = acDownExecute
      OnUpdate = acDownUpdate
    end
    object acLabel: TAction
      Category = 'ToolBar'
      Caption = #1052#1077#1090#1082#1072'...'
      ImageIndex = 2
      ShortCut = 16460
      OnExecute = acLabelExecute
      OnUpdate = acLabelUpdate
    end
    object acRevision: TAction
      Category = 'ToolBar'
      Caption = #1056#1077#1074#1080#1079#1080#1103'...'
      ImageIndex = 7
      ShortCut = 16459
      OnExecute = acRevisionExecute
      OnUpdate = acRevisionUpdate
    end
    object acSave: TAction
      Category = 'ToolBar'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 3
      ShortCut = 16467
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
    object acRefresh: TAction
      Category = 'ToolBar'
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 4
      ShortCut = 116
      OnExecute = acRefreshExecute
      OnUpdate = acRefreshUpdate
    end
    object acCommit: TAction
      Category = 'ToolBar'
      Caption = 'Commit...'
      ImageIndex = 5
      ShortCut = 49234
      OnExecute = acCommitExecute
      OnUpdate = acCommitUpdate
    end
    object acRollback: TAction
      Category = 'ToolBar'
      Caption = 'Rollback...'
      ImageIndex = 6
      ShortCut = 49218
      OnExecute = acRollbackExecute
      OnUpdate = acRollbackUpdate
    end
    object acRepair: TAction
      Category = 'ToolBar'
      Caption = #1056#1077#1084#1086#1085#1090
      ImageIndex = 11
      OnExecute = acRepairExecute
      OnUpdate = acRepairUpdate
    end
    object acHelp: TAction
      Category = 'ToolBar'
      Caption = #1055#1086#1084#1086#1097#1100'...'
      ImageIndex = 10
      ShortCut = 112
      OnExecute = acHelpExecute
    end
    object acLinkTemplate: TAction
      Category = 'Menu'
      Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100
      Hint = #1055#1088#1080#1074#1103#1079#1072#1090#1100
      ImageIndex = 0
      OnExecute = acLinkTemplateExecute
      OnUpdate = acLinkTemplateUpdate
    end
    object acStatusNew: TAction
      Category = 'Status'
      Caption = #1053#1086#1074#1099#1081
      ImageIndex = 0
      SecondaryShortCuts.Strings = (
        'Ctrl+1')
      ShortCut = 16433
      OnExecute = acStatusNewExecute
    end
    object acStatusWork: TAction
      Category = 'Status'
      Caption = #1042' '#1088#1072#1073#1086#1090#1077
      ImageIndex = 1
      ShortCut = 16434
      OnExecute = acStatusWorkExecute
    end
    object acStatusReady: TAction
      Category = 'Status'
      Caption = #1043#1086#1090#1086#1074
      ImageIndex = 2
      ShortCut = 16435
      OnExecute = acStatusReadyExecute
    end
    object acStatusPartComplite: TAction
      Category = 'Status'
      Caption = #1063#1072#1089#1090#1080#1095#1085#1086' '#1074#1099#1087#1086#1083#1085#1077#1085
      ImageIndex = 3
      ShortCut = 16436
      OnExecute = acStatusPartCompliteExecute
    end
    object acStatusComplite: TAction
      Category = 'Status'
      Caption = #1042#1085#1077#1076#1088#1077#1085
      ImageIndex = 4
      ShortCut = 16437
      OnExecute = acStatusCompliteExecute
    end
    object acRenameSQLScript: TAction
      Category = 'Body'
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100'...'
      ImageIndex = 1
      ShortCut = 113
      OnExecute = acRenameSQLScriptExecute
      OnUpdate = acRenameSQLScriptUpdate
    end
    object acCompare: TAction
      Category = 'SQLScript'
      Caption = #1057#1088#1072#1074#1085#1080#1090#1100'...'
      ImageIndex = 0
      ShortCut = 49238
      OnExecute = acCompareExecute
      OnUpdate = acCompareUpdate
    end
    object acCompareBody: TAction
      Category = 'Body'
      Caption = #1057#1088#1072#1074#1085#1080#1090#1100'...'
      ImageIndex = 0
      ShortCut = 49219
      OnExecute = acCompareBodyExecute
      OnUpdate = acCompareBodyUpdate
    end
    object acStatusCancel: TAction
      Category = 'Status'
      Caption = #1054#1090#1084#1077#1085#1077#1085
      ImageIndex = 5
      ShortCut = 16438
      OnExecute = acStatusCancelExecute
    end
    object acDataBase: TAction
      Category = 'Menu'
      ImageIndex = 1
      OnExecute = acDataBaseExecute
    end
    object acDBCommited: TAction
      Category = 'StatusBar'
      Caption = #1041#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
      OnExecute = acDBCommitedExecute
      OnUpdate = acDBCommitedUpdate
    end
    object acSaveToFile: TAction
      Category = 'Body'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083'...'
      ImageIndex = 3
      ShortCut = 24659
      OnExecute = acSaveToFileExecute
      OnUpdate = acSaveToFileUpdate
    end
    object acCommitNow: TAction
      Category = 'SQLScript'
      Caption = 'Commit'
      ImageIndex = 4
      ShortCut = 16466
      OnExecute = acCommitNowExecute
      OnUpdate = acCommitNowUpdate
    end
    object acRollbackNow: TAction
      Category = 'SQLScript'
      Caption = 'Rollback'
      ImageIndex = 5
      ShortCut = 16450
      OnExecute = acRollbackNowExecute
      OnUpdate = acRollbackNowUpdate
    end
    object acSaveAllToFile: TAction
      Category = 'SQLScript'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083'...'
      ImageIndex = 3
      ShortCut = 24659
      OnExecute = acSaveAllToFileExecute
      OnUpdate = acSaveAllToFileUpdate
    end
    object acCompareOld: TAction
      Category = 'Body'
      Caption = #1057#1088#1072#1074#1085#1080#1090#1100' '#1089' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1081'...'
      ImageIndex = 0
      OnExecute = acCompareOldExecute
      OnUpdate = acCompareOldUpdate
    end
  end
  object cxImageList: TcxImageList
    FormatVersion = 1
    DesignInfo = 7471625
    ImageInfo = <
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          200000000000000400000000000000000000000000000000000002254B622274
          C3E7267FD5F9267FD5F9267FD5F9267FD5F9267FD5F9267FD5F9267FD5F9267F
          D5F9267FD5F9267FD5F9267FD5F9267FD5F92274C3E702264C642174C3E5158A
          F2FF0381F1FF4CA6F5FF71B8F7FF1289F1FF0381F1FF0381F1FF0381F1FF0381
          F1FF0381F1FF0381F1FF0381F1FF0381F1FF158AF2FF2376C7E92882D7F90381
          F1FF92C8F9FFF4F9FEFFBDDEFBFFCEE6FCFF138AF2FF0281F1FF0281F1FF0281
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0381F1FF2882D7F92983D9F957AB
          F5FFF2F8FEFF3198F3FF0281F1FF6CB6F7FFCDE6FCFF138AF2FF0281F1FF0281
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0381F1FF2983D9F92A85DAF976BB
          F7FFB2D8FAFF0281F1FF0281F1FF0281F1FF74BAF7FFC3E1FCFF0281F1FF0281
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0381F1FF2A85DAF92B86DCF90E87
          F1FFC2E0FBFF69B4F7FF0281F1FF8DC6F8FF80BFF7FFFAFCFEFF0381F1FF0281
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0381F1FF2B86DCF92D88DEF90381
          F1FF0E87F1FFC4E2FBFF74BAF7FF91C8F8FFFFFFFFFF9ECEF9FF0281F1FF0281
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0381F1FF2D88DEF92E8AE0F90381
          F1FF0281F1FF0F87F1FFB9DCFBFFF3F9FEFFA6D2FAFFF2F8FEFF43A1F4FF4BA5
          F5FF70B8F7FF1188F1FF0281F1FF0281F1FF0381F1FF2E8AE0F92F8BE3F90381
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF5BAEF5FFFAFCFEFFF5FA
          FEFFBDDEFBFFCEE6FCFF138AF2FF0281F1FF0381F1FF2F8BE3F9308DE5F90381
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF56ABF5FFF5FAFEFFF2F9
          FEFF369BF3FF6CB6F7FFCDE6FCFF138AF2FF0381F1FF308DE5F9328EE7F90381
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF75BAF7FFB2D8FAFF45A2
          F4FF0984F1FF0281F1FF74BAF7FFC3E1FCFF0381F1FF328EE7F9338FE9F90381
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF0D87F1FFC2E0FBFF69B4
          F7FF0281F1FF0281F1FF42A1F4FFFAFCFEFF0482F1FF338FE9F93490EAF90381
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF0E87F1FFC4E2
          FBFF74BAF7FF44A1F4FFE3F1FDFF82C0F8FF0381F1FF3490EAF93592ECF90381
          F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF0281F1FF0F87
          F1FFB9DCFBFFF3F9FEFF7DBEF7FF0381F1FF0381F1FF3592ECF93086DAE5168B
          F2FF0381F1FF0381F1FF0381F1FF0381F1FF0381F1FF0381F1FF0381F1FF0381
          F1FF0381F1FF0381F1FF0381F1FF0381F1FF168AF2FF3189DEE90D345B603087
          DCE53794EFF93794EFF93794EFF93794EFF93794EFF93794EFF93794EFF93794
          EFF93794EFF93794EFF93794EFF93794EFF93087DCE50D355D62}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00800100000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000008001
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          000000000000000000000000000200000014020201280B0B0A340B0B0A340202
          0228000000140000000200000000000000000000000000000000000000000000
          0004121211446866629FA29E96DDBDB8AAF7CFC8B9FFDAD3C5FFDDD7C8FFDBD5
          C6FFC0BCAEF7948F84DD5350489F100F0E4400000004000000000000000A6E6C
          66A9E9E6DDFBF7F4EBFFEEE9DEFFE0DACAFFDAD4C4FFD5CEBEFFD4CDBDFFD4CD
          BDFFD5CEBDFFD2CBBAFFBCB4A1FFACA593FD4C473EA90000000A4A474164E1DD
          CEFFEEEADFFFF0ECE0FFDCD7CBFFB8B2A3FFACA696FFA9A292FFAAA494FFABA5
          95FFAEA797FFBFB8A6FFBDB5A2FFB2A995FF978E79FF36332C666A665B8DC4BD
          AAFFCDC8BDFFCAC6BAFFCDC9BCFFD4CEBEFFD2CBBBFFDAD4C4FFDED7C8FFDED7
          C8FFD7D1C2FFBDB6A6FFA29B8BFF9D9685FF847A69FF4B463B9369645997C8C3
          B5FFF3F0E6FFF8F5ECFFECE8DDFFE0DACAFFDBD4C4FFD6CFBEFFD5CEBDFFD5CD
          BDFFD5CEBDFFD3CCBBFFBDB5A2FFB3AA97FF9A9281FF5C574B9F79756999E3DF
          D0FFEDE9DEFFF0ECE1FFDAD5C8FFBBB5A5FFAAA392FFA49D8CFFA59E8DFFA7A0
          8FFFB1A998FFC0B8A6FFBDB5A2FFB3AA96FF99907BFF5D574B9F7A7568A3C8C1
          AFFFCBC7BBFFC5C0B3FFC6C1B3FFC8C2B3FFCDC6B7FFD6CFC1FFD9D3C5FFD8D2
          C4FFCCC6B7FFB6AF9FFFA39B8AFFA19988FF8C8471FF565044AB7A7467ADC9C4
          B6FFEEEAE0FFF6F2E9FFE9E4D8FFDCD6C7FFD6D0C0FFD2CBBBFFD1CABAFFD1CA
          BAFFD1CABAFFCFC9B9FFBBB3A1FFB0A896FFA09988FF6E6759B5898478AFE4E0
          D2FFEAE6DAFFEFEADFFFDCD7CAFFC3BCADFFB5AE9DFFACA593FFADA694FFB2AB
          9AFFB9B2A1FFC2BBAAFFBDB5A3FFB0A895FF9B9380FF6A6456B58C8778BDCEC7
          B6FFD2CCBFFFB3AB9BFFA39B89FFA39B88FFA29A87FFA09884FF9D937EFF9990
          7AFF968C76FF948A74FF9A917CFFA9A18EFF8E8674FF615B4FC58B8576C7B2AB
          9AFFB1A998FFB5AE9DFFB9B1A0FFB6AE9BFFB3AA96FFB1A994FFB1A994FFB1A8
          93FFAFA691FFACA38EFFAAA18CFFA79E89FFB4AD9BFF7E7769CF8F897BC9C9C2
          B3FFCEC7B8FFCEC7B8FFC8C1AFFFC8C0ADFFC9C1AEFFC9C1AFFFC9C1AFFFC9C2
          AFFFCAC2AFFFCBC3B0FFCBC3B1FFC6BEABFFC6BEADFF989283CF38352E54CCC7
          B7FBECE7DBFFE9E3D6FFE4DECEFFE2DCCCFFE1DBCCFFE1DBCCFFE1DBCCFFE1DB
          CCFFE1DACBFFE1DACBFFE1DBCCFFE3DDCEFFD4CDBDFD3F3C3558000000002523
          1F3C918B7DC1DCD5C6FFEFEADDFFF6F1E5FFF5F0E4FFF4F0E4FFF4EFE3FFF4EF
          E3FFF4EFE3FFEFEADDFFDFD9C9FF999386C32927223E00000000000000000000
          00000000000012110F2046423A6274706491938F83ADA49F93BDA49F92BD938F
          83AD767166914B48406219181522000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000E007000080010000800100000000000000000000000000000000
          0000000000000000000000000000000000000000000080010000C0030000F81F
          0000}
      end>
  end
  object cxImageListLarge: TcxImageList
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 7471737
    ImageInfo = <
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000020000000E000000220000002A0007
          043C000A0548000804400001002C000000280000002400000010000000020000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000002010E0748054B2DBD0C9561F313BF
          8FFF1CCEAEFF18C59EFF0E9D6AF9065937D3081A119F2D2E2E8D2F3030813032
          317E3132317E3132317E3132317E3132317E3232327E3232327E3232327E3232
          327E3232327E3232327E3232327E070707380000000A00000000000000000000
          000000000000000000000003010A0545269D0DB568FF12E38CFF11EA93FF14EF
          A0FF16F2AEFF14EFA6FF12E893FF10E187FF0BC06CFF2A7E56FF7D9F8DFFAED3
          BCFFCEF5DBFFD9FBE3FFE0FCE6FFE6FCE8FFEBFCEBFFF0FCECFFF4FCEEFFF7FD
          EFFFF9FDF0FFFBFDF1FFFCFEF4FF131313440000000200000000000000000000
          0000000000000005030E076334C90BBE65FF0DCD72FF0ED67BFF0EDE84FF1DE2
          8FFF23E393FF21E08FFF0FDC82FF0ED378FF0DC96EFF0BBF64FF118046FF6B92
          7DFFAAD4BAFFCBF5DAFFD7F9E0FFDEFAE3FFE5FAE6FFEAFBE9FFEFFBEAFFF2FA
          ECFFF6FBEDFFF8FBEEFFFAFCF2FF141414400000000000000000000000000000
          00000000000006552DB309A654FF0AB25DFF0BBD65FF0BC76CFF0DD074FF5269
          38FF6B522AFF5E4E36FF1BC976FF0EC46CFF0BB862FF0AAD5AFF09A352FF1473
          43FF7EA590FFB9E5CAFFD1F8DEFFD9F9E2FFE1F9E5FFE7FAE7FFECF9E9FFF1FA
          EBFFF4FAEDFFF6FAEEFFF9FBF1FF141414400000000000000000000000000000
          0000032A175A079048FF089A4EFF09A455FF0AAD5CFF0BB662FF0CBE69FF4C60
          34FF644D29FF584934FF1AB76BFF0AB05EFF0AA658FF099C51FF09934CFF088D
          48FF347455FF9DC7AFFFC8F3D8FFD4F7DFFFDCF8E3FFE4F9E6FFE9F9E8FFEEF8
          EAFFF2F9ECFFF5FAEDFFF9FBF1FF141414400000000000000000000000000000
          000009743ED509954CFF09964DFF0A9D52FF0AA457FF0AAA5BFF0CB060FF445A
          37FF5A4930FF514739FF19AA64FF0AA459FF099B53FF09924DFF088C4AFF088B
          49FF097841FF79A18DFFB8E4CAFFCBF0D8FFD3F0DBFFDBF1DFFFE1F1E1FFE9F4
          E6FFF1F8ECFFF4F9EDFFF7F9F0FF151515400000000000000000000000000216
          0C2C099A52FF0A9E54FF0A9F54FF0AA055FF0AA458FF0BA85CFF0BAB5FFF4059
          3FFF4E4438FF49433FFF1AA663FF0AA058FF0A9A54FF099450FF09924FFF0991
          4FFF08904EFF4D8368FFADD9C0FFC8EFD7FFD1F0DBFFD9F0DEFFDFF0E0FFE8F4
          E6FFEFF7EBFFF3F8ECFFF6F8F0FF151515400000000000000000000000000436
          1E620AA75BFF0AA85CFF0DA75CFF44584FFF4B5C54FF4D5D52FF4F5E52FF4948
          43FF44403FFF403F41FF4A5B55FF495B54FF495A53FF495A53FF1D975DFF0A99
          56FF099755FF33825DFFA9D6BDFFC9F3DAFFD3F4DEFFDBF4E1FFE3F5E5FFE9F6
          E8FFEDF6EAFFF1F6EBFFF6F8F0FF15151540000000000000000000000000064A
          2A7C0DB165FF0EB366FF13B067FF3B3A3CFF414042FF413F42FF414042FF4140
          42FF414042FF414042FF403F42FF414042FF414042FF414042FF2E9F6BFF15A5
          64FF0CA05DFF28865CFFA6D3BAFFC6F1D8FFD1F3DDFFD9F3E0FFE1F4E4FFE7F4
          E6FFECF4E8FFEFF5E9FFF4F7EEFF16161640000000000000000000000000064A
          2B7A0FBB6FFF14BD72FF1ABB74FF323234FF343335FF343335FF343335FF3938
          3BFF424143FF424144FF3A393BFF343335FF343335FF343436FF38A977FF27B3
          76FF24B173FF2F8D64FFA0CCB4FFBCE5CDFFC6E6D1FFCEE7D4FFD4E6D7FFE1EE
          E0FFEAF3E7FFEEF4E9FFF3F6EDFF161616400000000000000000000000000535
          1F5C17C57CFF1AC880FF1FC983FF24C784FF28C785FF2CC887FF31C889FF3A58
          4DFF434245FF454447FF41C18CFF38C38AFF37C188FF34BF86FF32C085FF30BD
          83FF2CBA7EFF429771FFAFE0C5FFC5F0D6FFCFF0DBFFD7F0DEFFDEF1E1FFE4F1
          E3FFEAF2E6FFEDF2E7FFF2F4ECFF171717400000000000000000000000000111
          0A201CC380FF21D18CFF25D28EFF2AD391FF30D494FF35D597FF39D598FF3D5C
          51FF444346FF474649FF4BCD9AFF41D098FF41CE97FF3FCB94FF3DC992FF38C6
          8EFF32C088FF61A385FFB7E8CCFFC6EED6FFCFEFDAFFD7EFDDFFDEF0E0FFE4F0
          E3FFE9F1E5FFECF1E5FFF0F2EAFF171717400000000000000000000000000000
          0000168C5BC327D897FF2CD99AFF33DB9EFF38DCA0FF3CDCA1FF42DCA4FF3F5E
          54FF454447FF48474AFF55D4A5FF4CD8A4FF4BD6A2FF48D49FFF45D19CFF40CE
          98FF2EAB79FF92C4AAFFB6E3C9FFC0E4CEFFC8E4D1FFD0E5D4FFD6E6D7FFE0EB
          DEFFE8EFE3FFE8EDE2FFEBEDE5FF181818400000000000000000000000000000
          0000022B184431D598FF34E1A6FF38E2A8FF40E2ABFF45E3ADFF49E3AEFF3D5C
          52FF3D3C3EFF403F41FF5DDAAFFF56DFAFFF54DDADFF53DBABFF4FD8A8FF49D1
          A0FF55AA85FFB0E2C6FFBEE8CFFFC7E9D3FFCFEAD7FFD6E9D9FFDCEADCFFE1EB
          DFFFE4EADFFFE3E7DDFFE7E9E1FF181818400000000000000000000000000000
          000000000000106E449946E3AFFF41E7B4FF47E8B5FF4CE8B7FF53E9B9FF50C6
          A1FF50BA99FF54BB9BFF60E5B9FF5EE4B8FF5EE3B7FF5BE0B3FF5DDEB2FF3FAF
          83FFA4DABDFFBAE9CEFFC4EBD3FFCCEBD6FFD3EBD9FFD9ECDBFFDEEBDDFFE0E9
          DDFFDFE6DAFFDDE1D7FFE1E3DCFF191919400000000000000000000000000000
          00000000000000040206178353AD5CE7B9FF50EDC0FF54EDC1FF5AEDC3FF5EED
          C2FF64ECC4FF66ECC3FF69EBC3FF67E9C1FF67E8C0FF6FE3BFFF45B68BFF97D2
          B4FFB4E5C9FFBDE6CDFFC5E7D1FFCDE7D4FFD3E7D7FFD8E8D9FFDAE5D8FFDBE3
          D7FFDBE0D5FFD8DBD2FFDBDDD6FF191919400000000000000000000000000000
          00000000000000000000000100020A5D377C55D5A2F77EF1CFFF6CF2CEFF68F1
          CBFF6CF0CCFF71EFCDFF76EFCDFF8AEED0FF69D5B0FF57B992FF9BD3B6FFADDE
          C2FFB5DFC6FFBCDEC8FFC3DFCCFFC9DFCEFFCEDFD0FFD0DDCFFFD1DACEFFD4DA
          CFFFD5D9CFFFD0D3CAFFD6D8D1FF1A1A1A400000000000000000000000000000
          0000000000000000000000000000000000005C7066B360B98FFF6AD8A8FF6CDA
          AEFF74DCB4FF6FD6AFFF6CCEA7FF5FC49AFF8DD2B0FFAEE4C6FFB5E5C9FFBBE5
          CCFFC2E6CFFFC9E7D2FFCEE6D4FFD3E7D6FFD6E5D6FFD6E0D3FFD5DCD1FFD2D8
          CEFFCFD3C9FFCACCC3FFD0D1CBFF1A1A1A400000000000000000000000000000
          000000000000000000000000000001010104959593EFA5A5A0FFBCE8D0FFA8E2
          C3FFA2E0C0FFA7E1C2FFACE3C5FFAFE3C6FFB3E4C8FFB7E4C9FFBCE4CCFFC2E4
          CEFFC8E5D1FFCDE5D3FFD2E5D5FFD3E3D4FFD4E0D2FFD2DACFFFD1D7CCFFCCD1
          C7FFC8CBC2FFC3C5BDFFCACBC5FF1B1B1B400000000000000000000000000000
          000000000000000000000000000019191936AFB0ACFF9F9F99FFC3E7D2FFB4E2
          C8FFB4E2C7FFAEDBC1FFADD7BEFFAFD8C0FFB2D7C0FFB6D8C2FFBAD8C4FFBED9
          C6FFC3D9C8FFC6D9C9FFC8D7C9FFC8D3C7FFC7CFC4FFC5CBC0FFC1C6BCFFC3C6
          BDFFC1C3BBFFBBBDB5FFC4C5BEFF1B1B1B400000000000000000000000000000
          000000000000000000000000000050504F78ACADA8FF999993FFCAE7D4FFBDE1
          CBFFBDE1CAFFBDE1CAFFBEE2CBFFC0E2CCFFC3E2CDFFC6E2CEFFC9E1CFFFCDE2
          D1FFD0E3D2FFD1E0D1FFD1DCCFFFD0D8CCFFCDD3C8FFC9CEC4FFC5C8BFFFBFC2
          B9FFBABCB4FFB4B6AEFFBEBFB9FF1C1C1C400000000000000000000000000000
          000000000000000000000000000081827FBBABACA7FF96968FFFD0E6D6FFC5E1
          CDFFC5E1CDFFC5E1CDFFC6E1CDFFC7E1CEFFC9E1CFFFCBE1D0FFCEE1D1FFD1E1
          D2FFD0DED0FFD0DBCEFFCFD7CBFFCBD1C6FFC7CCC2FFC2C6BDFFBDC0B7FFB8BA
          B2FFB2B3ACFFACADA6FFB7B8B2FF1C1C1C400000000000000000000000000000
          0000000000000000000003030308AAAAA5F7AEAEA9FF95968FFFD5E6D8FFCBE0
          CFFFCBE0CFFFC9DDCCFFC7DBCBFFC9DBCBFFCADCCCFFCCDCCDFFCEDCCEFFCDD9
          CCFFCFD9CCFFCDD5CAFFC2C7BDFFB5B9B1FFAEB1A9FFAAACA5FFA5A7A1FFA1A3
          9CFF9C9C97FF959690FFA6A7A2FF1E1E1E400000000000000000000000000000
          0000000000000000000022222240B4B5AEFFB1B2ACFF95958EFFD9E5D9FFD0DE
          D0FFD0DFD0FFCCDBCCFFCBD9CAFFCCD9CBFFCDD9CBFFCED8CBFFCCD5C9FFCAD2
          C7FFCDD4C9FFC9CFC5FFB6BAB1FFFAFBF4FFFAFBF4FFFAFBF4FFF9FAF3FFF0F1
          EAFFDEDFD9FFC2C3BEFF70706DB1030303080000000000000000000000000000
          000000000000000000005C5C5B85A4A59CFFB6B6B1FF94958EFFDCE4DAFFD4DE
          D1FFD4DED1FFD4DED1FFD5DED1FFD5DED1FFD5DDD1FFD3DBCFFFD1D8CCFFCDD3
          C8FFCACFC5FFC4C8BEFFADAFA8FFFAFBF4FFFAFBF4FFF9FAF3FFF0F1EBFFE1E1
          DCFFC4C5C0FF6C6C69A902020206000000000000000000000000000000000000
          000000000000000000008C8D89C79A9B92FFBCBDB7FF94958EFFDFE4DAFFD7DD
          D2FFD7DDD2FFD8DED2FFD7DDD2FFD7DDD1FFD6DBD0FFD2D7CCFFCED2C8FFCACD
          C4FFC5C8BFFFBEC1B8FFA9AAA4FFFAFBF4FFF9FAF3FFF0F1EBFFE4E4E0FFC6C7
          C2FF6666639F0000000200000000000000000000000000000000000000000000
          0000000000000606060EB6B6B2FB9D9E97FFC4C4BDFF93948DFFE0E3DAFFD9DD
          D2FFD9DCD2FFD2D5CBFFCFD2C8FFCCCFC5FFC9CCC2FFC4C7BEFFBFC2B9FFBBBE
          B5FFBFC1B9FFB8BAB2FFA4A59FFFF9FAF3FFF1F2EBFFE7E7E3FFC9CAC5FF6060
          5E95000000020000000000000000000000000000000000000000000000000000
          00000000000000000000121212264C4C4B85CACBC2FF93948DFFE1E2DAFFDADC
          D2FFD9DBD1FFD9DBD2FFD7D9CFFFD3D5CBFFCFD0C7FFCACCC3FFC4C5BDFFBEC0
          B7FFB9BAB2FFB2B3ABFFA4A59FFFF1F2ECFFEAEAE7FFCCCCC8FF5A5A588B0000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000002A2A294AB7B7B2F19E9E9AFFE1E1DAFFDADB
          D2FFD9DAD1FFD7D8CEFFD3D4CBFFCFD0C7FFC9CAC2FFC4C5BCFFBEBFB6FFB8B8
          B1FFB1B2ABFFAAABA4FFA4A5A0FFEDEDEAFFCECFCBFF5253517E000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000022222244E0E1D9FFD8D9
          D0FFD6D7CDFFD2D3CAFFCECFC6FFC9CAC1FFC3C4BBFFBDBEB6FFB7B8B0FFB1B2
          AAFFAAABA4FFA3A49DFFA1A19DFFD1D1CEFF4D4D4B7400000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000020202040CDCEC9FFC8C9
          C4FFC6C7C1FFC4C4BFFFC1C1BDFFBEBFBAFFBBBBB6FFB8B8B4FFB4B4B0FFB1B1
          ADFFADADA9FFA9A9A5FFA6A7A4FF4A4A486E0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFE007FFFF8000007F0000007E0000007E0000007C0000007C000
          0007C0000007C0000007C0000007C0000007C0000007C0000007E0000007E000
          0007F0000007FC000007FC000007FC000007FC000007FC000007F8000007F800
          0007F8000007F000000FF000001FF000003FF800007FFC0001FFFF0003FFFF00
          07FF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          00060000001000000016000005240000001800000016000000140000000C0000
          0004000000000000000600000010000000160000001600000626000000160000
          00140000000C0000000400000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000004010112261D19AEE113116AA9000001120707073E303031813131
          32813030317E3131328131313283303030831614529F1F1BBFF7181737912F2F
          2F8331313283323232813232327E3232327E3232327E3232327E3232327E3232
          327E3232327E3232327E3232327E070707380000000A00000000000000000000
          0000010111201E1AADE11A15D9FF1D19D7FF131066A913131448C7C7D9FFC8C8
          E1FFC9C9E2FFC9C8E1FFBFBFD5FF706EB6FF201BD2FF1B16D9FF2420C7FF7271
          97FFB8B8BEFFE1E1E5FFEBEBECFFEEEFEDFFF2F2EEFFF4F5EFFFF7F8F0FFFAFA
          F1FFFBFBF1FFFCFDF2FFFDFEF4FF131313440000000200000000000000000000
          0E161E1BA4DF1B16CCFF1B16CCFF1A16CCFF1D18CAFF201F70D39C9CB0FFA9A9
          C8FFB7B7D9FFAFAFCFFF6361ACFF1F1BC6FF1A16CCFF1B16CCFF1B16CCFF221E
          BAFF7B7A9CFFD4D4DBFFE4E5E9FFE9E9EAFFEDEEEBFFF1F1ECFFF4F5EDFFF6F7
          EEFFF8F9EEFFF9FAEFFFFBFCF2FF141414400000000000000000000000000303
          10182925BBFF1C17C0FF1B15BFFF1B15BFFF1B15BFFF1E19BFFF39378EFF7D7D
          9AFF9998BBFF5E5CA9FF1F1ABBFF1A15BFFF1B16C0FF1B15BFFF1A15BFFF241F
          BBFF7B7BADFFD5D6E0FFE1E2E8FFE6E7E9FFEBECEBFFEFF0ECFFF2F3EDFFF6F6
          EEFFF8F8EEFFF8F9EFFFFBFBF2FF141414400000000000000000000000000000
          000037369BD52B27BCFF1D17B7FF1B16B7FF1B15B7FF1A15B6FF1E19B6FF3735
          8BFF4C4A92FF201BB4FF1B15B6FF1A15B6FF1B15B7FF1914B6FF231FB5FF2A29
          90FFABABC1FFD5D6E2FFDEDEE7FFE3E4E8FFE9E9EAFFEEEEECFFF1F2EDFFF4F4
          EDFFF6F7EEFFF8F8EFFFFAFBF2FF141414400000000000000000000000000000
          00001A1A455A4B4ACAFD2D29BEFF1D17B3FF1C16B2FF1B16B2FF1C16B2FF1F19
          B2FF201BB1FF1B15B2FF1B16B2FF1B16B2FF1B16B2FF241FB2FF2A2890FF5E5D
          9EFFC2C2D6FFCECEDDFFD6D6E0FFDCDCE2FFE1E2E3FFE6E7E5FFE9EAE5FFF0F1
          EAFFF6F6EEFFF7F8EEFFF9F9F1FF151515400000000000000000000000000000
          0000000000001E1D4D5C504ED4FD2C27B8FF1F19B5FF1E18B4FF1D17B4FF1D17
          B4FF1D17B4FF1E18B4FF1D17B4FF1D17B4FF241FB1FF2A288EFF5C5BA0FFB7B7
          D2FFC5C5DBFFCECEDEFFD5D5E0FFDBDBE2FFE1E1E3FFE6E6E5FFE9EAE6FFF0F1
          EAFFF5F6EDFFF6F7EEFFF8F8F1FF151515400000000000000000000000000000
          000000000000000000001C1C495C3B3A9EFD2520A6FF221CB9FF211BB9FF201A
          B9FF2019B9FF2019B9FF201AB9FF241FAFFF211F73FF565699FFAFAFD3FFBEBE
          DCFFC8C7DFFFD0D0E1FFD8D8E4FFDEDFE6FFE4E5E8FFE9EAE9FFEEEFEBFFF2F2
          ECFFF3F4ECFFF4F5EDFFF7F8F0FF151515400000000000000000000000000000
          000000000000000000000000000011112C5C201D78FD332DC2FF322CC2FF3630
          C3FF3831C3FF3832C4FF3933C4FF272483FF3D3D6BFF9696BCFFB1B1D6FFBCBC
          DAFFC6C6DEFFCFCFE0FFD6D7E3FFDDDDE4FFE3E4E6FFE8E9E8FFECEDE9FFF0F1
          EAFFF2F3EBFFF3F4EBFFF6F7EFFF161616400000000000000000000000000000
          00000000000000000000000000000F0D436A3A34C3FF3B35C8FF3E38C9FF413B
          CAFF433CCAFF453ECAFF463FCBFF4740C9FF413E8DFF71708DFF9A99B9FFB2B1
          CEFFBCBCD2FFC3C3D4FFCACBD6FFD1D1D8FFD7D8DBFFDCDDDCFFDFE0DCFFEAEA
          E4FFF0F1E9FFF2F3EAFFF5F6EEFF161616400000000000000000000000000000
          00000000000000000000100E446A403AC8FF433CCDFF4841CEFF4C45CFFF4E48
          D0FF5049D0FF524BD0FF534DD1FF534CD0FF544DCFFF464491FF7C7B95FFAAA9
          C4FFC3C3DAFFCDCDDEFFD4D4E0FFDBDBE2FFE1E1E4FFE6E6E5FFEAEAE6FFEDED
          E7FFEFF0E8FFF0F1E9FFF4F4EDFF171717400000000000000000000000000000
          000000000000100E446A433CCBFF4942D1FF4E47D2FF534CD3FF5750D4FF4943
          C0FF443FBFFF625CD6FF615BD6FF615AD6FF605AD5FF5E58D3FF4B4992FF8382
          96FFB2B2C5FFCBCBDBFFD3D4DFFFDADAE1FFE0E0E3FFE5E5E4FFE9E9E5FFECED
          E6FFEEEFE7FFEFF0E7FFF2F2EBFF171717400000000000000000000000000000
          0000110E456A4740CFFF4E46D5FF544DD6FF5B54D7FF6059D8FF514BC5FF1715
          54FF413FAFFF4F4ACCFF726CDBFF706ADBFF6F69DAFF6D66DAFF6A63D8FF4F4C
          93FF898A99FFBDBDCBFFCCCCD6FFD2D2D7FFD6D7D9FFDBDCDBFFDFE0DCFFE7E8
          E2FFEDEDE5FFEBECE3FFECEDE6FF181818400000000000000000000000000202
          1B284740CDFD5049D8FF5851DAFF5F58DBFF6760DCFF5751CAFF201E6DFF4847
          76FF7D7CC7FF5250D4FF5954D3FF837BE0FF8079DFFF7C75DFFF7770DEFF726C
          DBFF6A699FFFC4C4D1FFD1D2DAFFD7D7DCFFDCDCDEFFE0E0DFFFE4E5E0FFE8E8
          E2FFE8E9E1FFE6E7DEFFE8E9E2FF181818400000000000000000000000000000
          01023432A9E15750D9FF635BDDFF6A63DEFF5B55CEFF282683FF51508AFF9E9D
          C6FFA3A3CDFF8887D4FF5B59E5FF615CD8FF918AE3FF8C85E2FF867EE1FF423E
          B6FF9F9FB8FFCDCED9FFD5D5DCFFD9DADEFFDEDEDFFFE2E3E0FFE5E6E1FFE5E6
          DFFFE3E4DBFFE0E0D8FFE2E3DCFF191919400000000000000000000000000000
          000016163B4A4441CBF9665FDCFF5C56D0FF2C2A90FF545386FFB8B7D4FFABAB
          CEFFABABCEFFABAACDFF908FDAFF6462F3FF6B66DDFF9993E5FF4844B7FF6A6A
          A6FFC4C5D1FFCECFD8FFD4D4DAFFD8D8DBFFDCDCDCFFDFE0DDFFE0E1DBFFE0E1
          DAFFDDDED6FFD9DAD2FFDDDDD6FF191919400000000000000000000000000000
          0000000000001A1A444C4D4AD4F92C2A90FF4C4B81EB9B9B98FFC2C2D9FFB3B3
          D0FFB2B2CFFFAFAFCBFFAEAEC8FF9A99DEFF807CFAFF4D4ABBFF6969A5FFBDBD
          CAFFC6C6D0FFCACAD1FFCFCFD2FFD2D2D3FFD5D5D4FFD5D6D2FFD5D6D0FFD7D8
          D1FFD7D8D0FFD2D3CBFFD7D8D1FF1A1A1A400000000000000000000000000000
          000000000000000000002827484C1C1B4C8B6C6C6CB3A2A29EFFC8C8DAFFBBBB
          D1FFBBBBD1FFBCBBD2FFBCBCD2FFBEBED2FFAFAEE3FF9797C3FFC4C5D1FFCCCC
          D6FFD1D1D8FFD5D5DAFFD8D8DAFFDBDBDBFFDBDCD9FFDADAD6FFD8D9D3FFD5D6
          CFFFD0D1CAFFCBCCC4FFD0D1CBFF1A1A1A400000000000000000000000000000
          000000000000000000000000000001010104959593EFA5A5A0FFCDCEDBFFC2C2
          D2FFC2C2D3FFC1C1D2FFC3C3D3FFC4C4D3FFC6C7D4FFC9C9D5FFCCCCD5FFCFD0
          D6FFD3D3D8FFD6D7D9FFD9D9D9FFD9D9D7FFD8D8D5FFD4D5D0FFD2D3CDFFCECF
          C8FFC9CAC3FFC4C5BDFFCACBC5FF1B1B1B400000000000000000000000000000
          000000000000000000000000000019191936AFB0ACFF9F9F99FFD2D2DBFFC8C8
          D3FFC8C8D3FFC1C1CCFFBFBFC9FFC0C0CAFFC1C1C9FFC3C4CBFFC6C6CBFFC8C9
          CCFFCBCBCDFFCDCDCDFFCDCECCFFCCCCC9FFC9CAC6FFC6C7C1FFC3C3BDFFC4C4
          BDFFC1C2BCFFBCBDB5FFC4C5BEFF1B1B1B400000000000000000000000000000
          000000000000000000000000000050504F78ACADA8FF999993FFD6D7DCFFCDCD
          D4FFCDCDD3FFCDCDD4FFCECED4FFCECFD4FFD0D0D5FFD1D1D5FFD2D2D5FFD5D6
          D6FFD7D7D7FFD6D6D4FFD4D4D1FFD1D2CEFFCECFCAFFC9CAC4FFC6C6BFFFC0C0
          BAFFBABBB4FFB5B6AEFFBEBFB9FF1C1C1C400000000000000000000000000000
          000000000000000000000000000081827FBBABACA7FF96968FFFDADADCFFD1D2
          D4FFD1D2D4FFD1D2D4FFD2D2D4FFD2D3D5FFD3D4D5FFD4D5D5FFD5D6D5FFD7D7
          D6FFD5D6D3FFD3D4D0FFD0D1CDFFCCCCC7FFC7C8C2FFC3C4BDFFBEBEB8FFB9B9
          B3FFB2B3ACFFACADA6FFB7B8B2FF1C1C1C400000000000000000000000000000
          0000000000000000000003030308AAAAA5F7AEAEA9FF95968FFFDDDDDCFFD5D5
          D4FFD5D5D4FFD2D3D2FFD1D1D0FFD1D2D0FFD2D2D0FFD2D3D0FFD3D4D1FFD2D3
          CFFFD2D3CFFFCFD0CBFFC3C3BEFFB6B6B1FFAEAFA9FFAAABA5FFA6A7A1FFA1A2
          9CFF9B9C97FF959690FFA6A7A2FF1E1E1E400000000000000000000000000000
          0000000000000000000022222240B4B5AEFFB1B2ACFF95958EFFDFE0DCFFD7D8
          D4FFD8D9D5FFD4D4D0FFD2D3CEFFD2D3CFFFD2D3CFFFD2D3CEFFD0D1CBFFCECF
          C8FFD0D1CBFFCBCCC6FFB7B8B2FFFAFBF4FFFAFBF4FFFAFBF4FFF9FAF3FFF0F1
          EAFFDEDFD9FFC2C3BEFF70706DB1030303080000000000000000000000000000
          000000000000000000005C5C5B85A4A59CFFB6B6B1FF94958EFFE1E1DCFFDADA
          D4FFDADBD4FFDADAD4FFDADBD4FFDADAD4FFD9DAD3FFD7D8D1FFD4D5CEFFD0D0
          C9FFCCCCC5FFC5C6BFFFAEAEA8FFFAFBF4FFFAFBF4FFF9FAF3FFF0F1EBFFE1E1
          DCFFC4C5C0FF6C6C69A902020206000000000000000000000000000000000000
          000000000000000000008C8D89C79A9B92FFBCBDB7FF94958EFFE1E2DBFFDBDB
          D3FFDBDCD3FFDBDCD4FFDADBD3FFDADBD2FFD8D9D1FFD4D5CCFFCFD0C8FFCBCC
          C4FFC6C7BFFFBFC0B9FFA9AAA4FFFAFBF4FFF9FAF3FFF0F1EBFFE4E4E0FFC6C7
          C2FF6666639F0000000200000000000000000000000000000000000000000000
          0000000000000606060EB6B6B2FB9D9E97FFC4C4BDFF93948DFFE1E2DBFFDBDC
          D3FFDADBD3FFD4D5CCFFD0D1C8FFCDCEC6FFCACBC2FFC6C6BFFFC0C1BAFFBCBD
          B5FFC0C1B9FFB8B9B2FFA5A59FFFF9FAF3FFF1F2EBFFE7E7E3FFC9CAC5FF6060
          5E95000000020000000000000000000000000000000000000000000000000000
          00000000000000000000121212264C4C4B85CACBC2FF93948DFFE1E2DAFFDBDC
          D2FFDADBD2FFDBDBD2FFD8D9CFFFD4D5CBFFD0D0C8FFCBCCC3FFC5C5BDFFBFC0
          B7FFB9BAB2FFB2B3ABFFA4A59FFFF1F2ECFFEAEAE7FFCCCCC8FF5A5A588B0000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000002A2A294AB7B7B2F19E9E9AFFE1E1DAFFDADB
          D2FFD9DAD1FFD7D8CEFFD3D4CBFFCFD0C7FFC9CAC2FFC4C5BCFFBEBFB6FFB8B8
          B1FFB1B2ABFFAAABA4FFA4A5A0FFEDEDEAFFCECFCBFF5253517E000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000022222244E0E1D9FFD8D9
          D0FFD6D7CDFFD2D3CAFFCECFC6FFC9CAC1FFC3C4BBFFBDBEB6FFB7B8B0FFB1B2
          AAFFAAABA4FFA3A49DFFA1A19DFFD1D1CEFF4D4D4B7400000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000020202040CDCEC9FFC8C9
          C4FFC6C7C1FFC4C4BFFFC1C1BDFFBEBFBAFFBBBBB6FFB8B8B4FFB4B4B0FFB1B1
          ADFFADADA9FFA9A9A5FFA6A7A4FF4A4A486E0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFF3200FFFE1000007C0000007C0000007C0000007E0000007F000
          0007F8000007FC000007FC000007F8000007F0000007E0000007C0000007C000
          0007E0000007F0000007F8000007FC000007FC000007FC000007F8000007F800
          0007F8000007F000000FF000001FF000003FF800007FFC0001FFFF0003FFFF00
          07FF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000001800000030000000040000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000022000000AD000000CD000000320000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0016000300BF113B03FF144404FF000400D10000002200000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000100000
          00990D3002FF2EA10BFF2EA20AFF103903FF000000AD0000001A000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000040000008F0821
          01FB2FA90BFF32B50CFF33B40CFF32B10CFF103903FF000300C7000000240000
          0002000000000000000000000000000000000000000000000000000000000000
          0000000000000000000400000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000048041200F32383
          08FF32B80CFF32B50CFF32B40CFF32B50CFF2DA20BFF124304FF000000C90000
          005E000000000000000000000000000000000000000000000000000000000000
          0000000000380000009D00000058000000040000000000000000000000000000
          00000000000000000000000000000000000000000048010600DD238708FF32BB
          0CFF31B70CFF31B60CFF31B60CFF31B50CFF32B60CFF33B90CFF1F6F07FF0821
          01FF0000009F0000003E00000002000000000000000000000000000000100000
          007C000000E1000000A1000000D10000007A0000000000000000000000000000
          000000000000000000000000000000000016000200D3134B04FF30BE0CFF30BA
          0CFF30B90CFF30B80CFF31B80DFF31B70CFF31B60CFF31B60CFF32B70CFF2A9B
          0AFF103C03FD010700E300000076000000100000000000000000000000760000
          00D500000040000000080000005A000000DD0000001800000000000000000000
          0000000000000000000000000012000000A3124D04FF2EBB0CFF2FBC0DFF2FBC
          0DFF2FBB0DFF2FBA0DFF30BA0CFF30B90CFF30B80CFF31B80CFF31B70CFF31B7
          0CFF33BB0CFF29960AFF0C3002FF010500D1000000320000001A000000DD0000
          004A000000000000000000000016000000C10000003000000000000000000000
          0000000000000000000000000076051700F329AF0BFF2EC10DFF2EBF0DFF2FBD
          0DFF2FBD0DFF2FBC0CFF2FBB0CFF30BB0CFF30BA0CFF30B90CFF30B90CFF31B8
          0CFF31B70CFF32BA0CFF2DA80BFF175805FF000100D5000000A7000000B90000
          0014000000000000000000000010000000BB0000004C00000000000000000000
          0000000000020000005C051A00FF229709FF2DC50DFF2DC10DFF2DC10CFF2EC0
          0CFF2EBF0DFF2EBF0CFF2EBE0DFF2EBD0DFF2FBC0DFF2FBC0CFF2FBB0CFF2FBA
          0CFF30BA0CFF30B90CFF30B90CFF32BE0CFF228008FF051600FF000000AB0000
          001C000000000000000000000008000000B10000005800000000000000000000
          000000000036000000D31C7E08FF2CC60DFF2CC40DFF2DC40DFF2DC30CFF2DC2
          0CFF2DC10DFF2DC00DFF2EC00DFF2EBF0DFF2EBE0DFF2FBE0DFF2FBD0CFF2FBC
          0CFF2FBC0CFF30BB0CFF30BA0CFF30B90CFF2EB10BFF0C3002FF061901F90001
          00B900000028000000000000001A000000C30000004800000000000000000000
          0016000500CF156606FF2CCF0DFF2BC70DFF2BC70DFF2CC60DFF2CC60DFF2CC5
          0DFF2CC30DFF2DC30DFF2DC20DFF2DC10DFF2EC10DFF2EC00DFF2EBF0DFF2EBE
          0DFF2FBE0DFF2FBD0DFF2FBC0DFF2FBB0CFF279D0AFF061B01FF29A00AFF1555
          05FF000200CF0000004C0000004E000000DB0000000A000000000000000C0000
          00930C4203FF26BD0CFF2ACB0DFF2ACA0DFF2BC90DFF2BC80DFF2BC70DFF2BC7
          0DFF2CC60DFF2CC50DFF2CC40DFF2DC30DFF2DC20DFF2DC20DFF2DC10DFF2EC0
          0DFF2EBF0DFF2EBF0DFF2EBE0DFF2FBF0DFF208408FF071F01FF30BF0CFF2FB8
          0CFF165805FF020C00E5000000B7000000A700000000000000000000005C0418
          00F326C30CFF29D00DFF29CD0DFF29CC0DFF2ACC0DFF2ACB0DFF2ACA0DFF2AC9
          0DFF2BC80DFF2BC70DFF2CC70DFF2CC60DFF2CC50DFF2CC40DFF2CC40DFF2DC2
          0DFF2DC20DFF2DC10DFF2EC10DFF2EC20DFF1C7507FF0D3B03FF31C50DFF2FBC
          0DFF30C20DFF238C09FF031100FF000000970000000C00000000000000B5115E
          05FF2ADB0EFF28D00DFF29CF0DFF29CE0DFF29CD0DFF29CD0DFF2ACC0DFF2ACB
          0DFF2ACA0DFF2AC90DFF2BC90DFF2BC80DFF2CC70DFF2CC60DFF2CC50DFF2CC5
          0DFF2CC40DFF2DC30DFF2DC30DFF2EC60DFF186806FF0F4304FF30C70DFF2EBE
          0DFF2FBE0DFF2FC00DFF218608FF061D01F7000000810000000C0000007E0213
          00EF1FA90AFF28D50DFF28D20DFF28D10DFF28D00DFF28CF0DFF29CF0DFF29CE
          0DFF29CD0DFF29CC0DFF2ACB0DFF2ACA0DFF2ACA0DFF2BC90DFF2BC80DFF2BC7
          0DFF2BC60DFF2CC50DFF2CC50DFF2ECC0DFF0F4404FF176806FF2EC60DFF2DC1
          0DFF2EC00DFF2EBF0DFF2FC20DFF2AAD0BFF010A00E9000000560000000C0000
          0072052101FF198A08FF28DC0EFF27D40DFF28D30DFF28D20DFF28D10DFF28D0
          0DFF29CF0DFF29CE0DFF29CD0DFF2ACC0DFF2ACC0DFF2ACB0DFF2BCA0DFF2BC9
          0DFF2BC90DFF2BC70DFF2BC70DFF2ECF0DFF0D3F03FF1B7A07FF2DC60DFF2DC3
          0DFF2DC20DFF2DC10DFF2EC10DFF2FC50DFF071F01E90000005A000000000000
          000000000064000000DB126806FF24CB0CFF27D70DFF26D40EFF27D40EFF27D3
          0DFF28D20DFF28D10DFF28D00DFF29CF0DFF29CE0DFF29CD0DFF29CC0DFF29CC
          0DFF2ACB0DFF2ACA0DFF2BCB0DFF2AC30CFF093102FF114F04FF239E0AFF28B5
          0CFF2CC60DFF2DC50DFF2DC30DFF2EC70DFF072001E90000005A000000000000
          00000000000400000038000800D30C4B04FF25D40DFF26D90EFF26D60EFF26D5
          0DFF27D40DFF27D30DFF27D20DFF28D10DFF28D00DFF28CF0DFF29CE0DFF29CE
          0DFF29CD0DFF2AD00DFF23AB0AFF0D4103FF000400FB000300D9041300EB0829
          02FF1B7B07FF2CC50DFF2CC50DFF2DC90DFF072001E90000005A000000000000
          000000000000000000000000001E000000A3083102FB1EB10BFF26DC0EFF25D8
          0EFF25D70EFF26D60EFF26D50EFF27D50EFF27D30DFF27D20DFF28D20DFF28D1
          0DFF29D10DFF20A60AFF031200F300000089000000A70000007C0000000A0000
          0046000200F3115505FF2CCB0DFF2DCC0DFF072101E90000005A000000000000
          0000000000000000000000000000000000140001009D052201F91FBB0BFF26E1
          0EFF25D90EFF25D90EFF26D80EFF26D70EFF26D60EFF27D50EFF27D40EFF27D4
          0DFF22B50BFF082F02FF00000083000000100000006C000000D1000000580000
          007A000000EF010900F726B50BFF2CD00DFF072101E90000005C000000000000
          0000000000000000000000000000000000000000000600000066021300F31374
          07FF23D60DFF25DE0EFF25DA0EFF25DA0EFF25D90EFF25D80EFF26D70EFF27D9
          0EFF188A08FF000400FF00000022000000000000001400000081000000B10000
          00A90000005C000000C723AC0BFF2CD60EFF0A3302F90000008D000000000000
          0000000000000000000000000000000000000000000000000008000000600004
          00DB0C5204FF1FC40CFF25E30EFF24DC0EFF25DB0EFF25DA0EFF25D90EFF26DA
          0EFF1B9D09FF010D00E70000000E000000000000000000000002000000060000
          00040000002A000300D525B90BFF2BD80EFF0D4403F900000091000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          001800000099010F00ED138007FF21D40DFF24E00EFF24DD0EFF24DC0EFF24DC
          0EFF1FB70BFF052001F700000052000000080000000000000000000000000000
          000000000056062201F328D30DFF2AD80DFF105505FF000000BD000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000E00000050000900E10B4F04FF20D20DFF24E30EFF23DF0EFF24DD
          0EFF24DB0EFF178F08FF000700E5000000870000001200000000000000000000
          0000000000AD115C05FF28DA0DFF29D90DFF136706FF000000BF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000002000000097041E01F5159009FF22DF0EFF23E3
          0EFF23DF0EFF24E50EFF1BAA0BFF0B4603FF020F00E9000400B3000400A90003
          00B9083402FF21BB0BFF26D60DFF28DC0DFF136806FF000000BF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000C00000076000A00E90D5B05FF1DC2
          0BFF23E70EFF22E10EFF23E30EFF21D50DFF1AA50AFF168E08FF168E08FF178C
          08FF1FB90BFF25DA0DFF25D90DFF27DF0EFF126906FF000000BF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000220000009B0008
          00EF138407FF20D90DFF22E40EFF22E30EFF23E60EFF24E60EFF24E70EFF24E5
          0EFF24E00EFF23DB0DFF24D60DFF22CC0CFF0D5305FF000000BF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000000000C0000
          005A000A00EB0C5604FF21E10EFF1FD80DFF1CBE0BFF1CC00BFF1AAB0AFF1381
          07FF106A06FF0C5004FF0B4503FF062D02FF010900E100000085000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000032000000B7021600EB000B00DD000000C7000000BF000000BD0000
          00A10000007C0000006400000052000000340000000800000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000001C00000040000000320000001C00000016000000140000
          0006000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFE7FFFFFFC3FFFFFF81FFFFFF00FFFFFF007FEFFE001FC7FC00
          0FBBF800037BF800007BF000007BE000003BC000001B80000003800000030000
          000180000001C0000001E0000001F0000001F80001C1FC0006C1FF000E20FF80
          0FE0FFC00FE0FFF003C0FFF80000FFFE0000FFFF0000FFFFC000FFFFE03FFFFF
          FFFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000262626661D1D1D600000000200000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000050505124B4B4BEF3E3E3EFF3C3C3CCF0D0D0D42000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000353535892C2C2CFF242424FF3A3A3AFF5C5C5CFF2F2F2FB30202
          0228000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000606061A4A4A4AF5242424FF222222FF1C1C1CFF2C2C2CFF595959FF6A6A
          6AFB1A1A1A950000001600000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000383838992B2B2BFF252525FF454545FF919192FF2F2F2FFF272727FF3838
          38FF767676FF686868F10E0E0E76000000080000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000707
          07264A4A4AFB252525FF232323FFA5A4A5FFD1D0D1FFCFCECFFF7E7E7EFF2929
          29FF313131FF484848FF818181FF4E4E4EDF0404045A00000002000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000003A3A
          3AA9292929FF272727FF535353FFD3D2D3FFD4D4D5FFD6D6D7FFD8D8D8FFCDCD
          CEFF6D6D6DFF2B2B2BFF3B3B3BFF535353FF6E6E6EFF2D2D2DC90000003C0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000080808344848
          48FD262626FF252525FFB5B5B6FFD5D5D5FFBCBBBCFFD1D1D2FFDCDCDCFFDEDE
          DEFFE0DFE0FFC6C6C7FF5D5D5DFF333333FF414141FF555555FF4B4B4BFF1313
          13AD000000240000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000003A3A3ABB2828
          28FF282828FF636263FFD9D9D9FFDBDBDBFFDDDCDDFFCCCBCCFFC6C6C6FFDEDE
          DFFFE4E4E4FFE5E5E6FFE7E7E7FFB8B8B8FF515151FF3F3F3FFF484848FF4949
          49FF242424F90404048F00000012000000000000000000000000000000000000
          0000000000000000000000000000000000000000000007070742454545FF2727
          27FF292929FFC5C5C5FFDBDBDBFFC1C1C1FFDDDCDDFFE2E2E3FFE4E4E4FFD1D1
          D2FFD2D2D3FFE9E9E9FFEBEBEBFFEDEDEDFFEEEEEEFFA7A7A7FF4A4A4AFF4A4A
          4AFF4B4B4BFF2F2F2FFF030303ED0000005E0000000000000000000000000000
          00000000000000000000000000000000000000000000383838C9272727FF2929
          29FF737273FFDFDFE0FFE1E1E1FFE3E3E3FFCACACAFFC8C8C9FFE8E7E8FFEAEA
          EAFFEBEBEBFFDADADAFFE1E1E1FFF1F1F1FFF3F3F3FFF4F4F5FFF0F0F0FF9797
          97FF4D4D4DFF525252FF494949FF101010AD0000000000000000000000000000
          0000000000000000000000000000000000000B0B0B52424242FF282828FF2424
          24FFCACACAFFE1E1E1FFC7C7C7FFE6E5E6FFE8E8E9FFE8E8E8FFCDCDCDFFD6D6
          D7FFEFEFF0FFF1F1F1FFF0F0F0FFE5E5E5FFEEEEEEFFF8F8F8FFFAFAFAFFF2F2
          F2FF4F4F4FFF545454FF4F4F4FFD0404042C0000000000000000000000000000
          0000000000000000000000000000000000043B3B3BD7282828FF2A2A2AFF2B2B
          2BFF323232FF919091FFE5E5E5FFCCCCCCFFD1D1D2FFEEEEEEFFF0F0F0FFEBEB
          EBFFD8D7D8FFE5E5E6FFF7F7F7FFF9F9F9FFF6F6F6FFF1F1F1FFFDFDFDFF9696
          96FF535353FF565656FF262626A1000000000000000000000000000000000000
          0000000000000000000000000000101010623E3E3EFF292929FF2C2C2CFF2E2E
          2EFF313131FF303030FF414141FFA8A8A8FFEBEBEBFFD2D2D2FFDFDFE0FFF6F6
          F6FFF8F8F8FFEFEFEFFFE3E3E3FFF3F3F3FFFEFEFEFFFEFEFEFFEAEAEAFF4B4B
          4BFF565656FF4D4D4DF903030320000000000000000000000000000000000000
          00000000000000000000000000083C3C3CE3282828FF2B2B2BFF2D2D2DFF3030
          30FF323232FF353535FF373737FF343434FF525252FFC1C1C1FFEEEEEEFFDDDD
          DDFFEFEEEFFFFDFDFDFFFEFEFEFFF2F2F2FFEBEBEBFFFEFEFEFF858585FF5555
          55FF585858FF2323239100000000000000000000000000000000000000000000
          00000000000000000000151515723A3A3AFF2A2A2AFF2C2C2CFF2F2F2FFF3131
          31FF343434FF363636FF393939FF3B3B3BFF3E3E3EFF373737FF676767FFD8D8
          D8FFF1F1F1FFE7E7E7FFF8F8F8FFFFFFFFFFFFFFFFFFDCDCDCFF4A4A4AFF5858
          58FF4B4B4BF10202021600000000000000000000000000000000000000000000
          000000000000000000103B3B3BED282828FF2B2B2BFF2E2E2EFF303030FF4545
          45FF5D5D5DFF393939FF3A3A3AFF3D3D3DFF3F3F3FFF424242FF444444FF3C3C
          3CFF7B7B7BFFE7E7E7FFF1F1F1FFEDEDEDFFFEFEFEFF727272FF575757FF5959
          59FF1D1D1D7E0000000000000000000000000000000000000000000000000000
          00000000000019191985353535FF2A2A2AFF2C2C2CFF2F2F2FFF333333FF9A9A
          9AFFF8F8F8FFAFAFAFFF4A4A4AFF3D3D3DFF414141FF434343FF464646FF4848
          48FF4B4B4BFF444444FF8F8F8FFFF2F2F2FFC9C9C9FF4A4A4AFF595959FF4747
          47E90101010C0000000000000000000000000000000000000000000000000000
          000000000018393939F3292929FF2B2B2BFF2E2E2EFF303030FF494949FFEFEF
          EFFFFFFFFFFFFEFEFEFFF6F6F6FF979797FF3B3B3BFF444444FF474747FF4A4A
          4AFF4C4C4CFF4F4F4FFF515151FF515151FF555555FF585858FF5B5B5BFF1818
          186C000000000000000000000000000000000000000000000000000000000000
          00001D1D1D95303030FF2A2A2AFF2D2D2DFF2F2F2FFF333333FFA2A2A2FFFEFE
          FEFFFEFEFEFFFEFEFEFFFFFFFFFFFFFFFFFFEDEDEDFF818181FF3A3A3AFF4B4B
          4BFF4E4E4EFF505050FF535353FF555555FF585858FF5A5A5AFF424242DD0000
          0006000000000000000000000000000000000000000000000000000000000000
          0018373737F9292929FF2B2B2BFF2E2E2EFF313131FF4A4A4AFFF2F2F2FFFDFD
          FDFFFDFDFDFFFEFEFEFFFEFEFEFFFEFEFEFF848484FFD3D3D3FFE3E3E3FF7474
          74FF404040FF525252FF545454FF575757FF595959FF5B5B5BFF1212125A0000
          0000000000000000000000000000000000000000000000000000000000000404
          04102121219F2B2B2BFB2D2D2DFF2F2F2FFF323232FFA4A4A4FFF9F9F9FFFAFA
          FAFFFBFBFBFFFCFCFCFFFDFDFDFFC3C3C3FF030303FF0C0C0CFFC0C0C0FFFEFE
          FEFF747474FF535353FF565656FF585858FF5B5B5BFF3E3E3ED1000000020000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000008080824212121A3313131FB474747FFEEEEEEFFF5F5F5FFF7F7
          F7FFF8F8F8FFF9F9F9FFFAFAFAFF4D4D4DFF121212FF1B1B1BFFDEDEDEFFE9E9
          E9FF424242FF555555FF585858FF5A5A5AFF5A5A5AFF0D0D0D4A000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000A0A0A2846464683D3D3D3EBF1F1F1FFF1F1
          F1FFF3F3F3FFF5F5F5FFC3C3C3FF1B1B1BFF212121FF757575FFFBFBFBFF8686
          86FF535353FF565656FF595959FF5C5C5CFF373737C100000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000505050C6060607CD3D3
          D3EFEEEEEEFFEFEFEFFF5D5D5DFF2A2A2AFF343434FFDBDBDBFFE6E6E6FF4545
          45FF555555FF585858FF5A5A5AFF595959FF0909093800000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000707
          071267676787D5D5D5F3C6C6C6FF6C6C6CFF868686FFF0F0F0FF878787FF5454
          54FF575757FF595959FF5C5C5CFF303030AF0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000080808166B6B6B8FD7D7D6F7E2E2E2FFDBDBDBFF484848FF5555
          55FF585858FF5B5B5BFF555555FB0505052A0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000A0A0A1C707070977B7B7BFB545454FF5757
          57FF595959FF5C5C5CFF2929299D000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000F0F0F363E3E3EBD5858
          58FF5B5B5BFF525252F70202021E000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000001414
          143E434343C12323238D00000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000400000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFFFFFFFFFF1FFFFFFE07FFFFFE01FFFFFC00FFFFFC003FFFF80
          00FFFF80003FFF00000FFF000007FE000003FE000007FC000007FC00000FF800
          000FF800001FF000003FE000003FE000007FC000007FC00000FFC00000FFF000
          01FFFC0001FFFF8003FFFFC003FFFFF007FFFFFC07FFFFFF0FFFFFFFCFFFFFFF
          FFFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000020101010402020206020202060202
          0206000000020000000200000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000020404
          040E0C0C0C26181818482424246C2E2E2E8B3434349F353535A7343434A73333
          339F2F2F2F8F262626721B1B1B52101010300707071602020206000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000050505101414143C2929
          297C383838BF3D3D3DE9595959F96F6F6FFD858585FF939393FF979797FF9292
          92FF858585FF6A6A6AFB444444EF383838D33232329B1D1D1D580B0B0B220202
          0206000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000020202061313133A242424954D4D
          4DE57B7B7BFDA0A0A0FFA3A3A3FFA6A6A6FFA9A9A9FFADADADFFB0B0B0FFB3B3
          B3FFB7B7B7FFAEAEAEFF858585FF7D7D7DFF6A6A6AF73A3A3AC72020206C0B0B
          0B22000000020000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000010101182A2A2AA56F6F6FF78585
          85FF848484FFA7A7A7FFC8C8C8FFDCDCDCFFE7E7E7FFEAEAEAFFE8E8E8FFE1E1
          E1FFD8D8D8FFCACACAFFA2A2A2FF7C7C7CFF8C8C8CFFADADADFF7E7E7EDD1717
          175A000000040000000000000000000000000000000000000000000000000000
          000000000000000000000000000006060630525252CF646464FF757575FFBCBC
          BCFFEFEFEFFFF5F5F5FFF0F0F0FFEBEBEBFFE6E6E6FFE0E0E0FFDBDBDBFFD5D5
          D5FFCFCFCFFFC9C9C9FFC5C5C5FFD0D0D0FFC1C1C1FFA6A6A6FFACACACFFC1C1
          C1F53A3A3A7A0000000600000000000000000000000000000000000000000000
          0000000000000000000009090936717171E5717171FFA0A0A0FFF1F1F1FFF7F7
          F7FFF4F4F4FFF0F0F0FFCFDAD1FF96BA9FFF71AB81FF5EA371FF5CA16FFF62A0
          74FF77A484FF99AE9EFFBCBEBDFFBBBBBBFFB3B3B3FFB9B9B9FFC4C4C4FFB6B6
          B6FFD0D0D0FD4E4E4E8D00000006000000000000000000000000000000000000
          00000000000003030320696969DF848484FFD4D4D4FFF8F8F8FFF7F7F7FFEFF1
          EFFF95BE9FFF399A52FF139B3AFF19AC46FF1CB44DFF1EB752FF20B754FF20B6
          54FF1FB353FF1CA74CFF229547FF549468FF98A49BFFB0B0B0FFB7B7B7FFCECE
          CEFFC1C1C1FFCCCCCCFD3D3D3D76000000000000000000000000000000000000
          000000000006484848B5828282FFE2E2E2FFF8F8F8FFF7F7F7FFB7D1BDFF2B98
          48FF12AC40FF16B94BFF19BC51FF1BB854FF1FA652FF379B5DFF4A9D6AFF489E
          6AFF2E9D5BFF1EAD59FF21BC61FF1FBA5DFF1B9F4CFF59966DFFB9BDBAFFCBCB
          CBFFD9D9D9FFC6C6C6FFBFBFBFF71515153A0000000000000000000000000000
          000017171752757575FDDCDCDCFFF8F8F8FFF7F7F7FF7EB78DFF0DA239FF10BD
          49FF13C151FF15BF56FF25A95AFF71A185FFB2B6B4FFCCCCCCFFD3D3D3FFD5D5
          D5FFCCCCCCFF99AAA1FF519D74FF1DB264FF1DC66CFF1ABB61FF319959FFBBC6
          BEFFDBDBDBFFE6E6E6FFC4C4C4FF878787C70000000600000000000000000000
          00044D4D4DC9BCBCBCFFF8F8F8FFF7F7F7FF71B284FF09AF3EFF0DC34DFF0FC6
          54FF10C258FF4AA973FFC2C8C5FFE7EAE9FFC8E5D8FFB8DECDFFCBE0D7FFE6E6
          E6FFE9E9E9FFE6E6E6FFCECECEFF91AC9FFF27AD6EFF19CB75FF16C66CFF269F
          59FFCBD6CFFFECECECFFEDEDEDFFBDBDBDFF1F1F1F4800000000000000000B0B
          0B32848484FDF7F7F7FFF7F7F7FF98C3A4FF06AC3CFF09C44CFF0AC653FF0CC4
          59FF56AE7CFF9BC9B2FF5DD79FFF1DCD80FF15CF82FF16D186FF16D088FF38D2
          97FFA3DBC6FFE8E8E8FFE8E8E8FFDADADAFFA8B7B1FF26AC72FF13C976FF10BD
          68FF359F62FFEBEEECFFF7F7F7FFDBDBDBFF636363A900000000000000002D2D
          2D81CBCBCBFFF7F7F7FFDBE5DDFF0F9E3BFF06C247FF07C54EFF08C655FF1CBD
          62FF32C277FF0DCA6EFF0ECE77FF10D080FF11D185FF11D289FF12D28BFF12D2
          8CFF12D18CFF6FD2AEFFE6E6E6FFE9E9E9FFDEDEDEFFA3B5AEFF559C7DFF719F
          8AFF0BB25DFF7CB995FFF8F8F8FFF6F6F6FF9B9B9BE700000006000000005252
          52B5F7F7F7FFF6F6F6FF62AC77FF04B93FFF05C147FF06C34DFF07C454FF08C6
          5CFF0AC865FF0BCA6EFF0CCC76FF0ECD7DFF0ECF84FF0FCF87FF0FD089FF0FD0
          8AFF0FD08AFF0FCF89FF74C7A9FFE7E7E7FFE9E9E9FFE1E1E1FFCCCCCCFF95C8
          B0FF0AC568FF10A04FFFE4EBE6FFF8F8F8FFD0D0D0FF0B0B0B20000000028C8C
          8CD3F7F7F7FFE7EBE8FF0B9634FF04BC40FF04BD44FF05BF4AFF06C051FF07C2
          59FF08C461FF0AC66AFF0BC772FF0CC979FF0DCA7EFF0ECB82FF0ECC84FF0ECC
          85FF0EC984FF23AC79FF84A79AFFDCDCDCFFE7E7E7FFE9E9E9FFE4E4E4FF57BE
          8EFF09C567FF08B757FF89BC9BFFF8F8F8FFE8E8E8FF2020203C00000002B2B2
          B2E1F6F6F6FFAECAB4FF03A634FF03B63DFF04B741FF04B846FF05B64AFF06B9
          52FF07BD5BFF08BF63FF09C16BFF0AC371FF0BC477FF0BC57AFF0CC57CFF0CC6
          7DFF13C07DFF8FC0ADFFE6E6E6FFE6E6E6FFE5E5E5FFE6E6E6FFE7E8E7FF1CB5
          6BFF08BF60FF07BB57FF3FA063FFF8F8F8FFF7F7F7FF3030304E00000004C9C9
          C9E9F4F4F4FF92BE9DFF1DB34AFF02B039FF03B13CFF03AF40FF59A475FF339D
          5FFF06AD4FFF07B85AFF08BA61FF08BB68FF09BC6DFF09BD71FF0ABE73FF0ABE
          74FF0ABE74FF0ABD74FF3DC58DFFB3DDCBFFE7E7E7FFE5E5E5FFB6D4C5FF07B3
          5CFF06B758FF05B551FF0E8F3CFFF7F7F7FFF8F8F8FF4343435C00000006D4D4
          D4F1F2F2F2FF86B993FF46BE68FF16B044FF02A937FF159F42FFC9CBC9FFDFE1
          E0FF66A681FF079E49FF06B056FF07B35CFF07B461FF08B565FF08B567FF08B5
          68FF08B669FF08B669FF08B568FF08B466FF49BF88FFC6DDD1FF73C099FF06B0
          54FF05AF4EFF04AE48FF028C32FFE7ECE8FFF7F7F7FF4F4F4F6600000002CDCD
          CDEBF0F0F0FF8CBB97FF55BE72FF4EBD6EFF18A943FF5F9E72FFDEDEDEFFEBEB
          EBFFECECECFF9DBAAAFF18934EFF05A54EFF05AA54FF06AB58FF06AC5AFF06AC
          5BFF06AC5CFF06AC5CFF06AC5BFF06AB59FF05AB57FF0BAA56FF0BA952FF04A7
          49FF03A644FF03A53FFF02872CFFE2E9E4FFF3F3F3FF4C4C4C6400000000B1B1
          B1CFEEEEEEFF9EC1A6FF63BE7BFF5FBF79FF5FB878FFC3C8C4FFE5E5E5FFE5E5
          E5FFEAEAEAFFF1F1F1FFCBD3CEFF3F9965FF049F46FF04A14AFF04A24CFF04A2
          4EFF05A24EFF04A24EFF04A24DFF04A24CFF04A149FF04A046FF039F42FF039E
          3EFF029D3AFF029C36FF047B27FFF0F1F0FFECECECFF3535354A000000008888
          88A7ECECECFFB9CDBDFF71BD84FF6DC083FF96BFA1FFEAEAEAFFEEEEEEFFE6E6
          E6FFE5E5E5FFB5CDBDFF69B885FF1F9B4CFF03963BFF03983EFF03983FFF0398
          41FF039841FF039841FF039840FF03983FFF03973DFF03973AFF029637FF0295
          34FF029431FF01932EFF28843FFFEDEDEDFFDDDDDDFD0A0A0A12000000004E4E
          4E68E5E5E5FFD9DFDAFF80BA8DFF7DC18EFFC4CFC7FFD6E2D9FFEDF0EEFFF1F1
          F1FFEBEBEBFF95B09EFF028029FF018D2EFF018D30FF018E32FF018E34FF018F
          35FF018F35FF018F35FF018F34FF018E33FF018E32FF018D30FF018D2DFF018C
          2BFF018B29FF008625FF649B70FFE4E4E4FFA7A7A7CD00000000000000000E0E
          0E1AD0D0D0FBE9E9E9FFA0C2A7FF8AC597FF86C394FF82C291FFABCDB3FFF2F2
          F2FFF3F3F3FFEDEDEDFF79A687FF148835FF008627FF008629FF00862AFF0187
          2AFF01872BFF01872BFF01872AFF008629FF008628FF008627FF008525FF0085
          24FF008422FF00711BFFB6C6BAFFDADADAFF5A5A5A7800000000000000000000
          0000797979A9E5E5E5FFD0D9D2FF97C4A0FF93C79EFF90C69CFF8CC499FFC9DA
          CDFFF2F2F2FFF4F4F4FFEDEDEDFFA9C2AFFF61A873FF3A9B54FF198C38FF0280
          24FF007E23FF007D22FF007921FF067324FF087A26FF007D20FF007D1FFF007C
          1EFF00791CFF40824EFFDBDBDBFFC5C5C5F50E0E0E1600000000000000000000
          000016161628C3C3C3F9E8E8E8FFB8CDBCFFA0CAA8FF9CCAA5FF99C8A3FF98C7
          A2FFD0DED3FFF1F1F1FFF5F5F5FFEFEFEFFFCDD5CEFFA1BDA7FF89B393FF7CAE
          89FF6BA379FF6B9F77FF85A48CFF82A78BFF248A3CFF218A38FF228A39FF268C
          3CFF358445FFC6D0C8FFDADADAFF656565870000000000000000000000000000
          0000000000004E4E4E7ED7D7D7FFE3E4E3FFB4CDB8FFA8CEAFFFA5CEADFFA2CC
          AAFF9FCAA8FFC2D9C6FFEDEFEEFFF6F6F6FFF5F5F5FFEDEDEDFFE7E7E7FFE6E6
          E6FFEAEAEAFFE5EAE6FFA6CBAEFF76B585FF73B381FF6FB17CFF6BAF79FF68A4
          74FFBDCDC0FFE2E2E2FFA8A8A8D7050505080000000000000000000000000000
          00000000000001010104707070B9DBDBDBFFE3E5E3FFBBD1BFFFB0D2B6FFADD2
          B4FFAAD0B1FFA7CEAFFFAACFB1FFC5DCCAFFDBE8DDFFE3ECE4FFE0EAE2FFD2E2
          D5FFB5D3BBFF90C19AFF89BE94FF86BC91FF82BA8DFF7DB789FF7BAF86FFC0D0
          C3FFE7E7E7FFC1C1C1F11F1F1F2C000000000000000000000000000000000000
          000000000000000000000505050C767676C1E0E0E0FFECEDECFFCCDBCFFFB6D3
          BCFFB4D5BAFFB2D4B8FFAFD3B6FFACD1B3FFA9D0B1FFA6CEAEFFA3CCABFFA0CB
          A9FF9DC9A5FF9AC7A3FF96C5A0FF93C39CFF8FBF98FF98BC9FFFD6DFD7FFE9E9
          E9FFC2C2C2F12C2C2C3C00000000000000000000000000000000000000000000
          000000000000000000000000000004040408656565A1DCDCDCFFF4F4F4FFE7EC
          E8FFC9DBCCFFBAD5BFFFB8D6BEFFB6D6BCFFB3D5BAFFB1D4B8FFAED2B5FFABD1
          B3FFA8CFB0FFA6CDADFFA3C9AAFFA6C6ACFFC8D8CBFFEEEFEEFFE8E8E8FFADAD
          ADDD2121212E0000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000035353558B7B7B7E5F2F2
          F2FFFAFAFAFFF1F4F2FFDDE8DFFFCEDED1FFC2D8C6FFBBD4C0FFB8D2BDFFB9D2
          BEFFC0D6C4FFCDDDD0FFE1E9E2FFF6F6F6FFF3F3F3FFD2D2D2FB6C6C6C950909
          090E000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000606060A5353
          5370BCBCBCD9F0F0F0FFFBFBFBFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
          FDFFFDFDFDFFFBFBFBFFEDEDEDFFC6C6C6F16F6F6F9919191926000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000002323232E5C5C5C728F8F8FA5B0B0B0C5C3C3C3D9C5C5C5D9B9B9
          B9CD9A9A9AAF6C6C6C8530303048050505080000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFF81FFFFFC001FFFF0000FFFE00007FFC00003FF800000FF000
          000FE0000007E0000003C0000003C00000018000000180000001800000018000
          00018000000180000001800000018000000180000001C0000001C0000003C000
          0003E0000003F0000007F000000FF800001FFC00003FFF00007FFFC001FFFFF8
          0FFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000020000
          000400000006000000080000000A0000000A0000000C0000000C0000000C0000
          000C0000000A0000000A00000008000000060000000400000002000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000200000004000000080000000C0000
          00100000001200000016000000180000001A0000001A0000001C0000001C0000
          001A0000001A000000180000001600000012000000100000000C000000080000
          0004000000020000000000000000000000000000000000000000000000000000
          0000000000000000000000000002000000060000000C00000010000000140000
          00160000001A0000001E0000002200000026000000280000002C0000002C0000
          002800000026000000220000001E0000001A0000001600000014000000100000
          000C000000060000000200000000000000000000000000000000000000000000
          0000000000000000000000000002000000060000000C00000010000000140000
          00160000001A0000001E00000022021C0F5A1E794EE915653FD3000502340000
          002800000026000000220000001E0000001A0000001600000014000000100000
          000C000000060000000200000000000000000000000000000000000000000000
          00000000000000000000000000000000000200000004000000080000000C0000
          00100000001200000016042D19723C936AF970BDA3FF68B397FD063A208D0000
          001A0000001A000000180000001600000012000000100000000C000000080000
          0004000000020000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000020000
          00040001010A0743259554A684FF61B79AFF2E9F79FF5DB598FF338B61F3000A
          05220000000A0000000A00000008000000060000000400000002000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000007
          0410105C37BB67B295FD51B191FF2FA17AFF2FA17AFF33A37CFF71BCA0FF0845
          2895000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000011109261C72
          49D972BCA2FF45AC8AFF31A37CFF31A37CFF31A37CFF31A37CFF56B495FF4098
          70FB011109260000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000032012462E875EEF76C1
          A7FF3CA985FF33A57EFF33A57EFF33A57EFF33A57EFF33A57EFF34A680FF75C0
          A6FF0D5432AD0000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000005331C6E459B75FB70C1A5FF38A8
          83FF36A782FF36A782FF36A782FF36A782FF36A782FF36A782FF36A782FF51B3
          93FF4FA27DFD021B0F3A00000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000020106094A2A9D5EAE8DFF64BC9FFF38A984FF38A9
          84FF38A984FF38A984FF38A984FF3DAB87FF38A984FF38A984FF38A984FF38A9
          84FF77C3AAFF15643DC500000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000F5A36B770B99EFD56B897FF3AAC86FF3AAC86FF3AAC
          86FF3AAC86FF40AF8AFF78C5ABFF74BDA1FF55B797FF3AAC86FF3AAC86FF3AAC
          86FF4CB491FF5EAE8CFF03261552000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000278158EB71C4A8FF3CAE88FF3CAE88FF3CAE88FF3CAE
          88FF4CB592FF7BC5ABFF257F54E70F6037C77BC6ABFF3DAF89FF3CAE88FF3CAE
          88FF3CAE88FF75C6ABFF20744BD9000100040000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000042816565BAD8AFF59BB9BFF3EB08AFF3EB08AFF5EBD
          9DFF6FBA9EFD14663EC9010C071C02120A28419B73FB63BFA1FF3EB08AFF3EB0
          8AFF3EB08AFF49B591FF69B598FD042F1A680000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000942268D71BB9FFD4EB894FF72C6AAFF59AD
          8AFF0849299B0002010600000000000000000847289979C4A9FF44B48FFF40B2
          8CFF40B28CFF40B28CFF71C6AAFF2B8259E70005030C00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000001010416633EC376C1A5FF3B966DF9042F
          1A6600000000000000000000000000000000000B0618348E65F370C6AAFF43B4
          8FFF43B48FFF43B48FFF49B692FF75BEA3FD063B218100000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000008041205361E7602190E360000
          00000000000000000000000000000000000000000000063B218172BDA2FD4EB9
          96FF45B691FF45B691FF45B691FF6DC6A9FF3A926AF3000B0618000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000005030C278156E77ACC
          B1FF47B893FF47B893FF47B893FF4AB995FF7EC8ADFF09482999000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000042F1A6869B6
          98FD57C09DFF49BB95FF49BB95FF49BB95FF68C6A7FF4A9F79FB01120A280000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000100041C73
          49D783D1B6FF4BBD97FF4BBD97FF4BBD97FF4BBD97FF84CEB4FF105735B10000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000325
          14505FB28FFF62C7A5FF4EBF9AFF4EBF9AFF4EBF9AFF63C7A6FF59AC89FF021D
          0F3E000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000014643DC589D3B9FF50C19CFF50C19CFF50C19CFF50C19CFF86D2B9FF1868
          42C7000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000021B0F3A52A883FD6DCCADFF52C39EFF52C39EFF52C39EFF60C8A6FF68B7
          97FF042715540000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000C5432AD89D2B9FF56C6A1FF54C5A0FF54C5A0FF54C5A0FF85D5
          BAFF237850DB0001010400000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000001110926459E76FB78D2B4FF56C7A2FF56C7A2FF56C7A2FF79D3
          B5FF58AA88FD01120A2800000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000845279586CFB4FF5CCAA6FF6ED0B0FF8CD6BCFF4EA4
          7EFB094628930000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000A0516358F65F197DCC4FF5AAE8BFD105935B50113
          0A2A000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000322134A074A28A1031F1142000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFF87FFFFFE07FFFFFC0
          3FFFFF803FFFFF001FFFFE001FFFF8000FFFF0000FFFF00007FFF80C07FFF81C
          03FFFC7E01FFFFFE01FFFFFF00FFFFFF80FFFFFF807FFFFFC07FFFFFC03FFFFF
          E03FFFFFE01FFFFFF01FFFFFF01FFFFFF87FFFFFFDFFFFFFFFFFFFFFFFFFFFFF
          FFFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000040000000A0000001200000016000000160000
          00120000000C0000000400000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00040000001606061B4C2123598B383A87B5494AA1C95353AED35050A9D14445
          93C130306DA5121233740000043A000000180000000400000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000002000006201C20
          5D8B3E47C3E35965F9FF606AFCFF6971FCFF7378FDFF7C7EFDFF8484FEFF8686
          FEFF8686FEFF8686FEFF6F6FE3F73E3E88BB08081C600000001E000000040000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000008101447723041D4ED374D
          FAFF3F53FAFF485AFAFF5160FBFF5B67FBFF646EFCFF6E74FCFF777BFDFF8182
          FDFF8585FEFF8686FEFF8686FEFF8686FEFF7C7CF4FD3B3B85BB010109440000
          000C000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000005141A248DB51B39F6FF1D3CF8FF2742
          F9FF3049F9FF3A50FAFF4356FAFF4D5DFBFF5664FBFF5F6AFCFF6971FCFF7278
          FDFF7C7EFDFF8484FEFF8686FEFF8686FEFF8686FEFF8686FEFF6565D0EB0D0D
          266A000000140000000000000000000000000000000000000000000000000000
          00000000000000000000000006141C25A6CD0B25ECFF0B2AF3FF1031F7FF1938
          F8FF223FF9FF2B45F9FF354CFAFF3E53FAFF4859FAFF5160FBFF5B67FBFF646D
          FCFF6D74FCFF777BFDFF8182FDFF8585FEFF8686FEFF8686FEFF8686FEFF7474
          E8F7131434780000001200000000000000000000000000000000000000000000
          0000000000000000020A191E97C30615DEFF061AE3FF0820E9FF0A27EFFF0D2E
          F5FF1435F8FF1D3BF8FF2742F9FF3049F9FF394FFAFF4557FAFF4C5DFBFF5663
          FBFF5F6AFCFF6971FCFF7277FDFF7B7EFDFF8484FDFF8585FEFF8686FEFF8686
          FEFF7474E8F70B0C23660000000A000000000000000000000000000000000000
          00000000000013146A93060DD4FF030DD7FF0412DBFF0617E0FF071DE6FF0923
          ECFF0B2AF2FF1736F6FF2335C5DB1D25798D16194B5C1112384815163F502124
          64763A40A9BD5A64F3FD646DFCFF6D74FCFF767BFDFF8082FDFF8585FEFF8686
          FEFF8686FEFF6464CDE901010840000000020000000000000000000000000000
          00000A0A273E1719CDFD0003CEFF0107D1FF020BD5FF030FD9FF0514DEFF071A
          E3FF1B29C2DF0D0F3C5200000002000000000000000000000000000000000000
          000000000412383FADCD5563FBFF5F6AFCFF6870FCFF7277FDFF7B7EFDFF8384
          FDFF8585FEFF8686FEFF3A3B84B90000001A0000000000000000000000000000
          000237379EC74141D7FF0B0CCDFF0002CDFF0005D0FF0109D3FF050FD8FF191F
          97BD000007100000000000000000000000000000000000000000000000000000
          04122C36A3C33F53FAFF4759FAFF5060FBFF5A66FBFF636DFCFF6D74FCFF767A
          FDFF8082FDFF8585FEFF7C7CF4FD08081B5A0000000200000000000000000A0B
          283E5656DDFF4E4FDBFF4646D9FF1112CEFF0001CCFF0003CEFF191B9CC90000
          030C00000000000000000000000000000000000000000000000000000412232F
          A3C32742F9FF2F48F9FF394FFAFF4256FAFF4C5CFBFF5563FBFF5E6AFCFF6870
          FCFF7177FDFF7B7EFDFF8384FDFF3D3D87B90000001200000000000000003032
          7E9D595BE0FF5657DEFF5353DCFF4E4EDAFF2121D1FF1314C2F5020311280000
          00000000000000000000000000000000000000000000000004121C28A0C31132
          F7FF1837F8FF213EF9FF2A45F9FF344BF9FF3D52FAFF4759FAFF505FFBFF5A66
          FBFF636DFCFF6C73FCFF767AFDFF696BE0F50000033000000000000000004F54
          C2E56064E3FF5D60E1FF5A5CDFFF5758DDFF5455DCFF22226795000000020000
          000000000000000000000000000000000000000004121A229AC30A21E9FF0A26
          EFFF0C2DF5FF1334F8FF1C3BF8FF2641F9FF3049F9FF323CAFCD4756F2FD4B5C
          FBFF5563FBFF5E69FCFF6770FCFF7277FDFF1010316C00000002000111206B72
          E9FF676EE7FF6469E5FF6165E3FF5E60E1FF5D5FDEFF02021236000000000000
          000000000000000000000000000000000412191C96C30613DBFF0516E0FF071C
          E5FF0922EBFF0B29F2FF0F30F6FF1938F8FF2833A8C50000050E2C36A4B93D52
          FAFF4659FAFF505FFBFF5966FBFF636DFCFF292C6C9F000000060F103346747E
          EFFF6E77EBFF6B72E9FF686EE6FF6569E4FF4C4EB9E500000012000000000000
          0000000000000000000000000412171993C30308D2FF020AD4FF030FD9FF0514
          DDFF0619E2FF081FE8FF0C27EFFF212DA6C50000050E000000001A1F64762F48
          F9FF384EFAFF4255FAFF4B5CFBFF5462FBFF353A92BD0000000C1C1E485A7986
          F2FF7682F0FF737CEDFF6F77EAFF6C73E8FF41449BCB0000000C000000000000
          000000000000000004123A3A97C34343D9FF2527D4FF0E13D2FF0208D3FF020C
          D6FF0411DBFF0718E0FF1E27A1C50000050E000000000000000012143F50213E
          F9FF2A44F9FF3A51FAFF4E61FAFF606FFBFF444AA8CD0000000E1F224E608290
          F6FF7D8BF4FF7A86F1FF7782EFFF747CECFF404395C50000000E000000000000
          0000000004123E3F99C36060DFFF5C5CDDFF5959DDFF5758DDFF5052DDFF3F44
          DCFF343BDDFF24289CC50000050E00000000000000000000000010123748405A
          F9FF4C64F9FF556BFAFF5A6EFAFF6072FBFF424BADD10000000E1A1C43548999
          FAFF8594F8FF8290F5FF7E8BF3FF7B86F0FF4D53A8D500000016000000000000
          041242449AC3696CE3FF6667E1FF6363DFFF6060DEFF5D5DDDFF5B5BDDFF5A5B
          DEFF3E3F9EC50000050E00000000000000000000000000000000191B4A5E4C62
          F5FF4C65F9FF5068FAFF556BFAFF5A6EFAFF3B439FC50000000A080A273896A3
          FCFF8D9DFBFF8998F9FF8694F7FF8390F4FF6971D7F50000012C000004124649
          9DC37479E9FF7074E6FF6C70E4FF6A6BE2FF6768E1FF6464DFFF6262DFFF4141
          9DC50000050E0000000000000000000000000000000000000000292E77915060
          EEFF4F63F3FF4E66F7FF5068F9FF546BFAFF2E3684AD000000040000070E8D98
          F0FD99A7FCFF93A2FBFF8D9DFBFF8A98F8FF8894F6FF0E10347A4A50A0C57E87
          EFFF7A82ECFF777DEAFF7479E8FF7174E6FF6E70E4FF6C6DE2FF45459EC50000
          050E000000000000000000000000000000000000000000000004454BBDDF5560
          E9FF5361EDFF5263F1FF5166F5FF5169F9FF1D21557E00000000000000006B71
          B7CBA4AFFCFF9EABFCFF98A6FCFF92A2FBFF8E9DFAFF7A86E6FB8894F5FF858F
          F2FF828BF0FF7E87EEFF7B82EBFF787DE9FF7679E7FF4949A0C50000050E0000
          0000000000000000000000000000000000000000000013133B585E63E4FF5A61
          E5FF5862E8FF5663EBFF5565EFFF5869F1FF0304193E00000000000000003436
          6476AFB8FDFFA9B4FCFFA4AFFCFF9EABFCFF98A6FBFF92A1FBFF8F9DF8FF8C98
          F6FF8894F4FF858FF1FF838BEFFF8188EDFF4C4FA2C50000050E000000000000
          000000000000000000000000000000000000000007165152BBE16163E1FF5F63
          E3FF5D63E4FF5B63E7FF5A64EAFF434BB7DD0000000A00000000000000000202
          0F18A0A6EBF7B3BCFDFFAEB8FDFFA9B3FCFFA3AFFCFF9DABFCFF97A6FBFF93A1
          FAFF909DF8FF8D98F5FF8A94F3FF5054A4C50000050E00000000000000000000
          000000000000000000000000000000000312424296C1696AE0FF6767E0FF6566
          E1FF6266E2FF6165E4FF6167E7FF1E20557C0000000000000000000000000000
          0000494B7D91BDC3FDFFB8C0FDFFB3BCFDFFAEB7FDFFA8B3FDFFA2AFFCFF9DAA
          FCFF98A6FBFF95A2F9FF545AA7C7000006100000000000000000000000000000
          00000000000000000006030311324B4CA1CD7475E3FF6F70E1FF6D6DE0FF6A6B
          E1FF6869E1FF6668E2FF5357C3E9000005140000000000000000000000000000
          000001010A12979BD8E7C1C7FEFFBCC3FDFFB7BFFDFFB2BBFDFFADB7FDFFA8B3
          FDFFA2AFFCFF8994E9FB0F11367E000001320000001E00000014000000140000
          001C020213422F316A9D6F73D6F57C80E7FF797BE5FF7778E4FF7374E3FF7171
          E1FF6E6EE1FF6D6EE1FF17174264000000000000000000000000000000000000
          000000000000191A3646BABEF6FDC5CBFEFFC1C7FDFFBCC3FDFFB7BFFDFFB2BB
          FDFFADB7FDFFA7B3FCFFA1AEFBFF7E88DDF55D64ADD550579DC95459A1CD666D
          C2E7878EECFF8990EEFF868CECFF8388EAFF8184E8FF7D81E7FF7B7CE5FF7879
          E3FF7676E3FF393984AB00000002000000000000000000000000000000000000
          000000000000000000002E30566AC4C7F9FFC9CEFEFFC5CAFEFFC0C7FDFFBCC3
          FDFFB7BFFDFFB2BBFDFFACB7FDFFA7B3FCFFA1AFFBFF9DAAFAFF9AA6F8FF97A2
          F6FF949DF4FF9199F2FF8E95F0FF8A90EEFF878CECFF8488EAFF8284E8FF8081
          E6FF4F50A4C90000050E00000000000000000000000000000000000000000000
          00000000000000000000000000003030566AC1C3F5FDCDD1FEFFC9CEFEFFC5CA
          FDFFC0C7FDFFBBC3FDFFB6BFFDFFB1BBFDFFACB7FCFFA7B3FCFFA1AFFBFF9EAA
          FAFF9BA6F8FF98A2F5FF959DF3FF9299F1FF8F95EFFF8C91EDFF8A8EECFF4E4F
          9FC1000008120000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000191A3444A0A1D5E5D1D5FEFFCDD1
          FEFFC9CEFEFFC4CAFDFFC0C7FDFFBBC3FDFFB6BFFDFFB1BBFDFFACB7FCFFA6B3
          FCFFA2AFFBFF9FAAF9FF9CA6F7FF99A2F5FF969EF3FF8B91EAFD353773910000
          0308000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000010109104E4F7B8FB6B9
          ECF7D1D4FEFFCDD1FEFFC9CEFDFFC4CAFDFFC0C7FDFFBBC3FDFFB6BFFDFFB1BB
          FCFFABB7FCFFA7B3FBFFA3AFFAFF9CA6F6FF5D63ACC50E0E293A000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000202
          0D163C3D64768183B6C9B4B8F1FDCCD0FEFFC8CEFDFFC4CAFDFFBFC7FDFFBCC4
          FDFFABB4F9FF8088D2E5494F879B0D0E2A3C0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000060C0A0B273820214252292B50602425495A1213
          33440101111E0000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFF01FFFFF8003FFFF0000FFFC00007FF800003FF000001FE003
          C00FE01FE007C03FC007C07F800380FF000380FE000381FC010181F8038181F0
          078181E00F8181C01F8181803F0181007F038000FF03C001FE03C003FC07C007
          F807E00FE00FF000000FF800001FFC00003FFE00007FFF0001FFFFE007FFFFFF
          FFFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000706060A0F0D0C150303
          0205000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000020101032D241F4141322A610B0908130000
          000000000000000000000706050B45342C72544038C85D483DFD553C31FF5640
          36E7251D19440000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000003A2F295A5C453ADE40332EFF514D4BFF4C3930CF0101
          0103000000000908070F685146D2999594FF818181FFF6F6F6FFA0A0A0FFA7A7
          A7FF52423ADE010100022A221E4144352E77362B255901010103000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000362D28523F332EFFD9D9D9FFA8A8A8FF9F9F9FFF7A7878FF1D17
          143A010101023E322D6CBCBBBBFFFEFEFEFFBDBDBDFFC5C5C5FF878787FF9F9F
          9FFF79736EFF463C3679453A35FFA2A1A1FF514A47FF5C473EAB010101030000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000005C4C45BEA5A5A5FFE4E4E4FFA2A2A2FF949494FF7E7774FB2822
          1F445B4337E54D382EF1EBEBEBFFFFFFFFFFFDFDFDFF646464FFB4B4B4FF8888
          88FF786E67F37D716CEB9A9A9AFFF9F9F9FF9B9B9BFF565250FF342B265A0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000040303068B7C74F8F2F2F2FF858585FF8D8D8DFF8C8C8CFF453C37B34538
          329E594239FF3E2E27FFDCDCDCFFFFFFFFFFFFFFFFFFF0F0F0FF686868FF6F6F
          6FFF58483FE79E9A99FF989898FFA5A5A5FFD1D1D1FF858585FF3D342F8A0000
          0000000000000000000000000000000000000000000000000000000000000000
          00000F0D0C15968780FFFFFFFFFFCACACAFF656565FF515151FF2D25206C4F43
          3BC95E463DFF403029FF898989FFFEFEFEFFFFFFFFFFFFFFFFFFFEFEFEFFBBBB
          BBFF513224DFB0B0B0FFAEAEAEFF838383FF959595FFBDBDBDFF3C342F7A0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000030303058B7D74F7FFFFFFFFFFFFFFFFFFFFFFFFD8D8D8FF463730904C36
          2DD54F4C4BFFADADADFF999999FF7D7D7DFF9A9A9AFF9B9B9BFF7C7C7CFF8484
          84FFA1A1A1FF7B7B7BFFFBFBFBFF6E6E6EFF9F9F9FFF938B88FF1F1B18340000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000574840B4F0F0F0FFFFFFFFFFFFFFFFFFFDFDFDFF554E4BFFC3C2
          C2FFFCFCFCFFFFFFFFFFFEFEFEFFF1F1F1FFD9D9D9FFD7D7D7FFF2F2F2FFFEFE
          FEFFFEFEFEFF878787FFF1F1F1FFEAEAEAFF6C6C6CFF54453EB5000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000028211E41908884FFFEFEFEFFFEFEFEFFA6A6A6FFC1C1C1FFFFFF
          FFFFEAEAEAFFA7A7A6FFA7A6A6FFE4E4E4FFFEFEFEFFFFFFFFFFFFFFFFFFEFEF
          EFFFDDDDDDFFE0E0E0FFA7A7A7FFFAFAFAFF6B5E57EC120E0D20000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000005A483FB4919191FF7D7D7DFFAEAEAEFFFEFEFEFFB7B7
          B6FF80675DFFCA9E89FFCB9F8AFF8B6E61FF756E6AFF9B9A9AFF878482FF7B65
          5BFF7D655AFFE0E0E0FF737373FF616161FF534138F34B3A3285030302060000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000322924503E2F27F2B8B8B8FFF1F1F1FFFDFDFDFFA8A7A6FF9F7D
          6EFFFEC7ADFFFFC8AEFFFFC8AEFFFFC8AEFFF8C2A9FFDDAD96FFE9B69FFFFEC7
          ADFFF6C0A7FF989492FF909090FFE2E2E2FFF8F8F8FFA29F9EFF514139940000
          0000000000000000000000000000000000000000000000000000000000000000
          0000392E2960756963FC828282FFFBFBFBFFD1D1D1FF77706DFFAC8775FFFEC7
          ADFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFF97837AFFBEBEBEFFCFCFCFFFFFFFFFFFFEFEFEFF8B817CFE2922
          1E4100000000000000000000000000000000000000000000000000000000382E
          28617C706AFDF8F8F8FF979797FF2F2D2CFFA07D6DFFF0BCA4FFFFC8AEFFFFC8
          AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFF9B7C6EFFE6E6E6FFACACACFFFFFFFFFFFFFFFFFFF1F1F1FF6D60
          59F94F3C33C047362EA42D24214D0000000000000000000000002A231F44796D
          67FCDADADAFF807874FF74625AE8866F63F5EBB8A0FFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFFBE9481FFD4D4D4FF989898FFFFFFFFFFFFFFFFFFFFFFFFFFFBFB
          FBFFE8E8E8FFD5D5D5FF695D58FE40312A791814122900000000513F36A7695D
          58FE6A5851CB443C3863060505088C7F78ABA98270FFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFFF2BEA5FF9F9D9CFF8D8D8DFFF7F7F7FFFEFEFEFFFFFFFFFFFFFF
          FFFFFBFBFBFF828282FF939393FFA6A5A5FF6E5D55F81814112728242235322C
          2A41030303050000000000000000474443508A695AFFFEC7ADFFFFC8AEFFFFC8
          AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFFFEC7ADFF928279FFDEDEDEFF4F4541FF74655EFFE7E7E7FFFFFF
          FFFFB8B8B8FFD0D0D0FFFFFFFFFFFFFFFFFFDBDBDBFF4A3C3597000000000000
          00000000000000000000000000000303030498877EE0D0A28DFFFFC8AEFFFFC8
          AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFFFFC8AEFFAD8876FFA2A2A2FF83736CFF7B7370938B807AFFFFFF
          FFFFFAFAFAFFFCFCFCFFFDFDFDFFFFFFFFFFBDBCBBFF584B448D000000000000
          0000000000000000000000000000000000005B565468816153FFFDC6ACFFFFC8
          AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFFFEC7ADFFAA8471FF957C70EE6F686487000000005F5450B6F2F2
          F2FFF7F7F7FF635742FF70685CFF787672FF685349DC1614131D000000000000
          000000000000000000000000000000000000020202039F8F87D09E7766FFFEC7
          ADFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8
          AEFFFFC8AEFFC19683FF866E62F52725243000000000000000004139346EC7C7
          C7FFADACABFF9E6400FF593900FF865500FF624A37CC0807070A000000000000
          000000000000000000000000000000000000000000001E1C1B23998176E69974
          63FFFCC5ACFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFFC8AEFFFBC4
          ABFF9A7464FF8E7467F2363331430000000000000000000000002F292649A6A5
          A4FF918877FF9D6400FF0A0600FF3F2700FF482B11FD19171521000000000000
          000000000000000000000000000000000000000000000000000022201F28A08B
          81D9704F40FFAB8572FFE6B39CFFF9C3AAFFF7C2A8FFECB9A1FFBA917DFF7251
          43FF9B877ED1211F1E29000000000000000000000000000000000F0E0D189187
          82FF8F836EFFAA6C00FF2E1D00FF190F00FF271405FF2C28253B000000000000
          0000000000000000000000000000000000000000000000000000000000000A0A
          090C655F5C739E8A81D8876C60FF765344FF755749FF81685DFF9A847AE4625A
          5774050404060000000000000000000000000000000000000000000000006D60
          5ACD56514CFFB07000FF955E00FF734900FF643C0EFF1E1B1928000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000001A19181E403C3B463733313F1D1B1A22000000010000
          0000000000000000000000000000000000000202020203030303000000001D1B
          192967564CA1613D05FF452B00FFA56900FF694E38D90A09090D000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000005050505000000000000000000000000000000000000
          0000020202035A4E497B6251469A674D3CE44038335300000001000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000008080808000000000000000000000000000000000000
          00000000000000000000000000000C0B0B0E0202020300000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFE3FFFF8701FFFF02000FFE000007FE000
          007FC000007FC000007FC000007FE00000FFE00000FFF000007FE000007FC000
          003F80000007000000010000000018000000F8000000FC000100FC000300FE00
          0700FF000F00FF801F80FFF07C80FFFFF7C0FFFFF7F9FFFFFFFFFFFFFFFFFFFF
          FFFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000200000002000001020000010200000002000001020000
          0102000001020000010200000102000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000004C84CD01579AFF00467CFF005596FF005798FF005BA2FF005BA4FF0056
          99FF0060A6FF0062A9FF0372B6FF055D8ECB0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0002015C9AFF27BDEEFF27CBF8FF29CCF8FF25C3F7FF25C4F7FF29CBF8FF2CCD
          F8FF2CD0F9FF24C3F8FF31BFF4FF0881C3FD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000201518DFF0FB9EFFF07CEFEFF06C8FEFF05BFFEFF05C1FEFF07CDFEFF07D0
          FEFF06C4FEFF05B8FEFF23C3FAFF037CC3FD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0102025895FF11BEF1FF08CDFEFF07C8FEFF06C1FEFF05BBFDFF06C2FEFF06BF
          FDFF05B5FEFF07C2FEFF25C4FAFF0262AAFD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0102015395FF12B9F0FF07C2FEFF08CCFEFF07C2FEFF07BCFEFF07BDFEFF06B4
          FEFF06B4FEFF07BAFEFF28BFFAFF026AB3FD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0002014986FF13B4EFFF06B3FEFF07B6FEFF07BBFEFF07BCFEFF07B9FEFF07B6
          FEFF08BBFEFF09BAFEFF2CC2FAFF025DA5FD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000200386DFF10A9EBFF06ADFEFF05A1FEFF07AEFEFF07AEFEFF06AAFEFF08B6
          FEFF09BBFEFF0AB9FEFF37CBFBFF025596FD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0002002E58FF10A0EAFF06AAFEFF08B4FEFF07ABFEFF09B7FEFF08B2FEFF0ABA
          FEFF0AB5FEFF0CBDFEFF2CBFFAFF014885FF0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000102000001020000000200000002000000020000
          0104002D55FF0D96E7FF0AB6FEFF08AFFEFF06A2FEFF09B2FEFF09ADFEFF0BBC
          FEFF0AB2FEFF0AAEFEFF2CBCFAFF013C73FF0000000200000002000001020000
          0102000001020001010200000000000000000000000000000000000000000000
          0000001E303C0986BDF3116599FF14639AFF0F4C7BFF09355BFF0F4E7BFF0C46
          71FF084778FF1098EDFF0AADFEFF08A1FEFF08A0FEFF099FFEFF09A6FEFF0CB8
          FEFF0DBAFEFF0CB3FEFF27B9F9FF094A83FF093965FF083565FF0A447EFF0B4D
          91FF0B599CFF107EBAFF11689BC1000103040000000000000000000000000000
          00000038505C00A6E7FF0EB6F9FF11AFF7FF15ADF8FF129BF5FF1AA6F8FF1AA4
          F7FF25B4F9FF12B9FCFF0AA6FEFF089FFEFF0794FEFF078DFEFF0892FEFF0BAB
          FEFF0DB5FEFF0DB4FEFF15A7FCFF1A9AF2FF1384F0FF0B72EDFF0A70EDFF0A76
          EDFF0668ECFF086EE8FF0A68C6FF03172A380000000000000000000000000000
          00000006090C00558EE5088CE3FF10B4FDFF10B3FEFF0DAEFEFF0A9CFEFF0CA7
          FEFF0DAFFEFF0EBEFEFF0DBBFEFF0DB7FEFF099BFEFF098FFEFF0786FEFF0A99
          FEFF0993FEFF088CFEFF0674FEFF0882FEFF0671FEFF0357FDFF0666FEFF0979
          FEFF0764FDFF075CE5FF0959ACF301070F160000000000000000000000000000
          00000000000000192B46006BB4FD0A8FF8FF0C95FDFF0DA3FEFF0B9AFEFF0A92
          FEFF0DA8FEFF0DA8FEFF0CA7FEFF0EADFEFF0BA0FEFF0B9AFEFF077DFEFF0987
          FEFF0A8BFEFF0984FEFF0771FEFF0770FEFF045BFDFF0767FEFF0662FEFF0559
          FDFF086EF0FF0368C1FF0121435E000000000000000000000000000000000000
          000000000000000000000031558D036DC9FF0A77FCFF0B84FEFF0A84FEFF0D99
          FEFF0C99FEFF0FABFEFF10ABFEFF0D98FEFF0EA2FEFF0B91FEFF0777FEFF087A
          FEFF066EFEFF076EFEFF0664FEFF0556FDFF0762FEFF065EFEFF0869FEFF0962
          FAFF0A5FCBFF013876A700000000000000000000000000000000000000000000
          0000000000000000000000010306003D73CF0663E1FF0C77FEFF0E8DFEFF1098
          FEFF0E96FEFF0E93FEFF0E95FEFF0E98FEFF0E9EFEFF0B86FEFF0977FEFF097A
          FEFF0667FEFF086CFEFF075FFEFF0863FEFF0864FEFF0A6CFEFF0B6CFDFF107B
          E6FF01549EDD0003090E00000000000000000000000000000000000000000000
          0000000000000000000000000000000B1528004D93F50965F4FF0D72FFFF0E79
          FFFF108DFEFF1091FEFF0E87FEFF0D87FEFF0A7DFEFF0F9AFEFF0A7DFEFF0A7A
          FEFF086BFEFF096BFEFF0B77FEFF0B73FEFF0961FEFF0A62FDFF0E6EF4FF0677
          C3FB011C2B380000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000001B3666025AB9FF0E78FEFF0D72
          FFFF15A2FFFF149EFFFF1295FEFF0E81FEFF0E81FEFF0D81FEFF0F8DFEFF0E8A
          FEFF0F8FFEFF0A6BFEFF0D77FEFF0C70FEFF0B67FEFF0B58FAFF0753C8FF0227
          5378000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000003E70AF076CE1FF138E
          FFFF1393FFFF0F81FFFF1290FFFF1290FFFF1495FFFF1594FFFF138FFEFF128B
          FEFF107EFEFF117AFEFF0C62FEFF1075FEFF1689FEFF1786E6FF084A89BD0000
          0102000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000070C14005C9FE51298
          F8FF169AFFFF1494FFFF1495FFFF1598FFFF1693FFFF199BFFFF168DFFFF158C
          FFFF158DFFFF1585FFFF1583FFFF168AFFFF2397F8FF1886BDEB020C131A0000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000182D440486
          D2FD1897FEFF1796FFFF158BFFFF1793FFFF1BA1FFFF20B8FFFF1CA7FFFF1999
          FFFF1585FFFF1683FFFF1686FFFF2490FEFF27A2DCFF08293B4C000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000000003E
          678B11A0EAFF1A9EFFFF1897FFFF1893FFFF1995FFFF1C9FFFFF1FAEFFFF1DA5
          FFFF1681FFFF198DFFFF1E90FEFF34A0E6FF0C406D9300000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000002
          04060164A0CD1FAFF8FF1A9AFFFF188DFFFF1DA0FFFF1B93FFFF1D98FFFF1B8F
          FFFF1A8CFFFF1D91FFFF40AFF7FF1A7BABD10003060800000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000E1C26087BCCF31D8FFDFF198AFFFF1B8EFFFF1984FFFF1E98FFFF1D95
          FFFF1C8FFFFF3DAFFEFF35B8DFF5051A232A0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000264662168DE5FF1D88FEFF1B87FFFF1A85FFFF1D92FFFF1D91
          FFFF2B99FEFF45B5EBFF10485A66000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000005188AB228CF6FF1977FFFF1877FFFF1B85FFFF2499
          FFFF56BEF8FF1B7899AD00000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000080E120A7EC6E3247CFDFF1361FFFF1872FFFF47AC
          FCFF2B9EC7E1020B0F1200000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000001C323E219AE8FD1D6CFEFF2C80FEFF38AF
          E6FB0829363E0000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000034D728554B0F3FF54B5F0FF0F57
          7181000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000203043B81A7BF377FA3B90002
          0304000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFFFFFFFFFC003FFFFC003FFFFC003FFFFC003FFFFC003FFFFC0
          03FFFFC003FFFFC003FFFFC003FFE0000007E0000007E0000007F000000FF000
          000FF800001FFC00003FFE00007FFE00007FFF0000FFFF8001FFFF8001FFFFC0
          03FFFFE007FFFFF00FFFFFF00FFFFFF81FFFFFFC3FFFFFFC3FFFFFFE7FFFFFFF
          FFFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000001020603457AC7034071C50001
          0206000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000001B358F0165A8FF0263ACFF0016
          2E8D000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000D1A46004777FF04BEF8FF06C0FAFF0049
          80FF000D1B480000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000040914003360E703A3E2FF04C4FEFF05D2FEFF07B2
          EBFF00305DE90003061600000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000002C53B3038DC8FF05C3FEFF04BFFEFF05C8FEFF05C5
          FEFF0374C1FF002449B900000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000001A306A0068A8FF08CAFDFF06C5FEFF06C1FEFF05C3FEFF04BD
          FEFF05B5FDFF025DA3FF00162E70000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000008102A004A83F505A5F5FF06B7FEFF06BDFEFF07C0FEFF06BFFEFF05BD
          FEFF06C3FEFF08AFF6FF004A8AF9000C18300000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000001
          0206002E56CF0489D5FF06ACFEFF04A2FEFF06B0FEFF06B2FEFF05B0FEFF06BD
          FEFF07C3FEFF07C0FEFF09A2E6FF003A6FD70002050A00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000029
          4C8D0157A9FF06A0FDFF06A7FEFF07B4FEFF06ADFEFF08BAFEFF07B6FEFF08BF
          FEFF08BBFEFF09C3FEFF09B8FEFF0473C1FF00203F9900000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000001323440045
          88FD0580F8FF0696FEFF09B4FEFF08AEFEFF06A2FEFF09B4FEFF07B0FEFF0ABF
          FEFF09B7FEFF09B4FEFF0AB5FEFF09A0FAFF014C90FF00112052000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000040814004780E50682
          EAFF0998FEFF0794FEFF09AAFEFF07A0FEFF07A0FEFF08A0FEFF09A8FEFF0BBA
          FEFF0BBDFEFF0BB6FEFF0BB2FEFF09A5FEFF0571E7FF002E63ED00040A1C0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000335FB10473D8FF0A8A
          FEFF0BA2FEFF0CB2FEFF09A2FEFF089DFEFF0792FEFF068DFEFF0793FEFF0BAD
          FEFF0CB7FEFF0CB6FEFF0AA6FEFF0895FEFF067CFEFF0245BCFF001C3CC10000
          0002000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000002440680271C1FF0C8CFEFF0E98
          FEFF0EA2FEFF0FB7FEFF0EB7FEFF0DB4FEFF0999FEFF088EFEFF0785FEFF099A
          FEFF0994FEFF088DFEFF0676FEFF0884FEFF0672FEFF034FFBFF00378BFF001B
          337C000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000C152A00528DF50C92F3FF0C8CFFFF0B83
          FFFF0F9AFFFF0E99FEFF0E9AFEFF0FA6FEFF0C9CFEFF0B96FEFF077AFEFF0986
          FEFF098AFEFF0884FEFF0670FEFF076EFEFF0459FDFF0664FEFF0555EEFF002C
          5FFB000C173A0000000000000000000000000000000000000000000000000000
          0000000000000000000000010306003B65CF0666D8FF0B7AFFFF0A76FFFF0E8D
          FFFF0E8BFFFF12A0FFFF129EFFFF0E87FEFF0F97FEFF0C88FEFF0870FEFF0875
          FEFF066BFEFF076AFEFF0660FEFF0552FDFF075EFEFF0659FEFF0863FEFF0448
          C8FF00284FDF0002051000000000000000000000000000000000000000000000
          0000000000000000000000203B8F024DB2FF0B6AFEFF0C74FFFF0F87FFFF1092
          FFFF108BFFFF0F86FFFF1087FFFF1089FFFF118FFEFF0C74FEFF0A65FEFF0A6A
          FEFF0759FEFF095FFEFF0756FEFF085BFEFF095BFEFF0A62FEFF0A5EFEFF0B5D
          FDFF05499FFF002646A500000000000000000000000000000000000000000000
          00000000000000091A48014D8FFD0A69F9FF0A65FFFF0B65FFFF0C6FFFFF0E76
          FFFF1088FFFF1089FFFF0F7BFFFF0E79FFFF0C6EFFFF108BFFFF0C6CFFFF0B68
          FFFF0A58FEFF0B59FEFF0D66FEFF0C63FEFF0A53FEFF0B52FEFF0A51FEFF0F66
          FFFF1068F7FF0661A4FB002B4460000000000000000000000000000000000000
          00000002080E002B89E90646EAFF0A5FFFFF095AFFFF0B63FFFF0F74FFFF0D6F
          FFFF159EFFFF1499FFFF128FFFFF0E79FFFF0F77FFFF0E75FFFF1080FFFF107C
          FFFF1181FFFF0C5DFFFF0E69FFFF0D63FFFF0C5AFFFF0941FFFF0739FFFF0A45
          FFFF0C52FFFF1571EAFF1682B7EF020F14180000000000000000000000000000
          0000062348601567C3FF0F5BF9FF1365FCFF1C7DFCFF2287FCFF2487FDFF2DA3
          FDFF2DA7FDFF117EFEFF128CFFFF128CFFFF1491FFFF1590FFFF148AFFFF1285
          FFFF1077FFFF1174FFFF0E5EFFFF238DFCFF2D9CFDFF2083FCFF1972FCFF1F7E
          FCFF1770FBFF2586FBFF58AFD2FF1329323E0000000000000000000000000000
          0000021129420D4BA0F5084096FF094796FF0D59A0FF1474B0FF1572AEFF229B
          C6FF27A3C9FF1692FBFF1491FFFF1594FFFF1690FFFF1897FFFF1689FFFF1589
          FFFF1588FFFF1580FFFF1984FFFF30A8D8FF1E8EC0FF177DB6FF0E5EA3FF0A51
          A2FF095BA6FF147BBCFF186496C5020405060000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000002
          0304229DC9FF1894FCFF1488FFFF178FFFFF1B9CFFFF20B2FFFF1CA1FFFF1993
          FFFF1580FFFF167EFFFF1B88FEFF27A0D6FF0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          01020F97CBFF1898FCFF1891FFFF188EFFFF198FFFFF1C99FFFF1FA7FFFF1D9F
          FFFF167CFFFF1888FFFF1A8BFEFF138CCCFF0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0102006DB2FF189AFBFF1A93FFFF1888FFFF1D9AFFFF1B8EFFFF1C93FFFF1A8B
          FFFF1A87FFFF1A8BFFFF1A8BFEFF047FC5FD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0102004395FF0F6AF8FF1680FFFF1986FFFF1B89FFFF1980FFFF1E93FFFF1D90
          FFFF1C89FFFF1E91FFFF1C96FEFF0090D4FD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0102004B9EFF0B54F7FF146EFFFF1A7EFFFF1B82FFFF1A80FFFF1D8CFFFF1D8B
          FFFF1F89FFFF1C80FFFF1C8AFEFF03A0DBFD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000001
          01020872BFFF0B51F8FF115CFFFF1669FFFF1870FFFF1972FFFF1C7EFFFF218F
          FFFF208BFFFF1F84FFFF1F8DFEFF0BA5DCFD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000001
          01021380C2FF083AF7FF0B47FFFF1567FFFF1562FFFF145DFFFF186CFFFF1D83
          FFFF1D7CFFFF1D77FFFF1D7EFEFF18A0D8FD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000001
          01022D8CC5FF396EF1FF3A69F4FF4277F5FF5594F9FF508CF8FF5392F9FF599F
          FAFF5DA1FBFF5A9EFAFF60AAF8FF53B7DEFD0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000699DB5CD368FC1FD0A438EFD145EA3FD248ABFFD278AC2FD2A94C9FD33B1
          D9FD33AFD9FD32AAD7FD37A5D2FD6597AEC90000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFFE7FFFFFFC3FFFFFFC3FFFFFF81FFFFFF00FFFFFF00FFFFFE0
          07FFFFC003FFFF8001FFFF8001FFFF0000FFFE00007FFE00007FFC00003FF800
          001FF000000FF000000FE0000007E0000007E0000007FFC003FFFFC003FFFFC0
          03FFFFC003FFFFC003FFFFC003FFFFC003FFFFC003FFFFC003FFFFFFFFFFFFFF
          FFFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000002000000060000000A0000000A0000
          0006000000020000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000804040426343433686161609D7C7C79BD8D8D89CB8D8D89CB7C7C
          79BD6161609D3434336804040426000000080000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000000000A1D1D
          1C4E767675B7BBBBB8F5CBCBC7FFCDCDC9FFCFCFCAFFCFCFCAFFCFCFCAFFCFCF
          CAFFCDCDC9FFCBCBC7FFBBBBB8F5767675B71D1D1C4E0000000A000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000020808082A6F6F6DB1C5C5
          C2FDCDCDC9FFD1D1CCFFDADAD6FFE0E1DCFFE4E4E0FFE5E5E1FFE5E5E1FFE3E3
          DFFFDFE0DBFFD9DAD5FFD1D1CCFFCDCDC9FFC5C5C2FD6F6F6DB10808082A0000
          0002000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000041D1D1D50A8A8A5E7CBCBC7FFD4D4
          D1FFE5E5E1FFEFEFEBFFEEEEE9FFEDEDE8FFECEDE8FFECECE7FFEBEBE6FFEAEA
          E5FFE9EAE4FFE9EAE4FFEAEBE6FFE2E2DEFFD4D4D0FFCBCBC7FFA8A8A5E71D1D
          1D50000000040000000000000000000000000000000000000000000000000000
          00000000000000000000000000042323235AB7B7B4F3CECECAFFE4E5E1FFF3F3
          EFFFF2F2EDFFF1F1ECFFF0F0ECFFF0F0EBFFEFEFEAFFEEEEE9FFEDEEE9FFEDED
          E8FFECECE7FFEBEBE6FFEBEBE6FFEAEAE5FFEBEBE7FFE1E1DDFFCECECAFFB7B7
          B4F32323235A0000000400000000000000000000000000000000000000000000
          0000000000000000000014141444B3B3B0F1D2D2CFFFEFF0ECFFF5F5F1FFF4F4
          F0FFF4F4EFFFF3F2ECFFF2E2CCFFEFCA9AFFECB875FFEBAF62FFECB163FFEDBA
          76FFEECA9AFFEFE0CAFFEEEDE6FFEDEDE8FFECECE7FFECECE7FFE9EAE5FFD2D2
          CEFFB3B3B0F11414144400000000000000000000000000000000000000000000
          0000000000000000001C969693D9D4D4D0FFF2F3EFFFF5F6F1FFF5F6F1FFF5F4
          EEFFF1D5B4FFE89D54FFE28025FFE0781EFFE0781EFFE1801DFFE27E1DFFE17C
          1DFFE3841DFFE59022FFEBAC54FFEFD6B3FFF0EFE8FFEFEFEAFFEEEEE9FFECED
          E8FFD3D3CFFF969693D90000001C000000000000000000000000000000000000
          0000000000044D4D4B91CECFCBFFF1F1EDFFF5F5F1FFF5F5F0FFF4EBDEFFE9A5
          68FFE07923FFDF761FFFDF761FFFDF761FFFEBA966FFFDF8F1FFFDF6ECFFE9A1
          57FFE0791EFFE07A1EFFE2801DFFE69020FFEDB66AFFF1EADCFFF1F1ECFFF1F1
          ECFFEEEEEAFFCECFCAFF4D4D4B91000000040000000000000000000000000000
          00000303032AB2B2AEEFEAEAE7FFF4F4EFFFF4F4EFFFF2E5D6FFE49049FFDF76
          1DFFDF761DFFDF761DFFDF761DFFDE761CFFFAEADEFFFFFFFFFFFFFFFFFFF7DE
          CAFFE0771EFFE0781EFFE0791EFFE17A1EFFE4881BFFEBA94BFFF3E8D7FFF3F3
          EEFFF2F2EDFFEAEAE6FFB2B2AEEF0303032A0000000000000000000000000000
          000243434185DADBD6FFF3F3EEFFF2F2EDFFF2ECE0FFE4934BFFDF771EFFE07A
          21FFE07C23FFE17D24FFE07C24FFE07A22FFF6DDCCFFFFFFFFFFFFFFFFFFF3CE
          B5FFDF751EFFE0761FFFE0771EFFE0791EFFE07A1EFFE3861BFFEBAA4EFFF4EE
          E2FFF5F5F0FFF4F4F0FFDBDBD7FF434341850000000200000000000000000000
          0010888885CDEEEEE9FFF1F1ECFFF2F2ECFFEAB075FFE17E27FFE2832AFFE285
          2CFFE3872DFFE3882EFFE3882DFFE3872DFFE59046FFF2C9AFFFF1C5AAFFE080
          33FFDF761DFFDF761DFFDF761FFFE0771EFFE0791EFFE17A1EFFE48A1BFFEDBB
          75FFF5F6F1FFF6F6F1FFF1F1ECFF888885CD0000001000000000000000000000
          0028C7C8C4F5F1F1EBFFF0F0EBFFEFDEC2FFE48B32FFE3882DFFE48C30FFE58E
          32FFE59033FFE59134FFE59134FFE59033FFE58D31FFE48A30FFE3862DFFE282
          29FFE07A21FFDF761DFFDF761DFFDF761FFFE0771EFFE0791EFFE17B1DFFE795
          24FFF3E0C4FFF6F6F1FFF5F6F1FFC8C8C6F50000002800000000000000001515
          1550E4E4DFFFEFEFEAFFEFEFEAFFEBB771FFE48B30FFE59034FFE69537FFE799
          3AFFE89B3CFFE89D3EFFE89D3DFFE79B3CFFEBA955FFF5D5A5FFECAD64FFE48A
          2FFFE2842BFFE07C23FFDF761DFFDF761DFFDF761FFFE0781EFFE07A1EFFE385
          1BFFECB669FFF5F5F0FFF5F5F0FFE7E8E3FF1515155000000000000000002D2D
          2D6CEEEEEDFFF0F0EDFFEFEBE3FFE79E3DFFE69436FFE79A3BFFE8A040FFE9A5
          45FFEAA847FFEAA949FFEAA948FFEAA747FFF3CF9EFFFFFFFFFFEEB97CFFE591
          34FFE48B2FFFE2842BFFE07B22FFDF761DFFDF761EFFE0761FFFE0791EFFE17B
          1EFFE79726FFF3EFE6FFF4F4EFFFF1F1EDFF2D2D2D6C00000000000000003838
          3876F3F3F3FFF3F3F3FFEFDFC5FFE89F3BFFE89D3EFFE9A444FFEBAB4BFFECB0
          50FFEDB455FFEDB556FFEDB556FFEDB353FFF6DAB1FFFFFFFFFFF2C892FFE79A
          3BFFE59235FFE48A2FFFE2832AFFDF781FFFDF761DFFDF761FFFE0771EFFE079
          1EFFE58C1EFFEEDABAFFF3F3EDFFF3F3EEFF3838387600000000000000003B3B
          3B72F4F4F4FFF4F4F4FFEDD5B0FFE9A441FFEAA646FFECAE4EFFEDB557FFEFBC
          5EFFF0C064FFF0C266FFF0C166FFF0BE62FFF4D49CFFFFFFFFFFFAEBD3FFE9A3
          43FFE7993AFFE59033FFE3882DFFE17E26FFDF761DFFDF761EFFE0761FFFE079
          1EFFE3861DFFEACB9EFFF2F2ECFFF2F2EDFF3A3B397200000000000000003C3C
          3C66F4F4F4FFF4F4F4FFEBD3A9FFEBAA48FFECAE4EFFEEB759FFF0BF64FFF1C6
          6DFFF3CA73FFF3CD77FFF3CC76FFF2C972FFF1C671FFFDFAF4FFFFFFFFFFF3CE
          94FFE8A040FFE69537FFE48C31FFE2842AFFDF781FFFDF761DFFDF761FFFE078
          1EFFE2831DFFE7C493FFF1F1EBFFF1F1ECFF3C3C3B6600000000000000003636
          3550F5F5F4FFF5F5F4FFEAD6B1FFECB24FFFEDB455FFF0BF63FFF2C86FFFF4CF
          7AFFF5D484FFF5D688FFF5D687FFF4D381FFF3CD76FFF5D69AFFFEFEFEFFFEFE
          FCFFF1C684FFE79A3BFFE59033FFE3872DFFE07C23FFDF761DFFDF761EFFE077
          1EFFE2821DFFE4C69AFFF0F0EAFFF0F0EBFF3535335000000000000000001A1A
          1A2EF5F5F3FFF5F5F4FFEADEC5FFEDB859FFEEBA5CFFF1C56BFFF4CE79FFF5D6
          88FFF6DC92FFF7DE97FFF7DE96FFF6DA8FFFF4D483FFF3CA73FFF7DDAEFFFFFF
          FFFFFEFCFAFFEFBB72FFE59336FFE4892EFFE18027FFDF761DFFDF761EFFE077
          1EFFE1821CFFE3D0B1FFEFEFEAFFEFEFEAFF1919192E00000000000000000101
          0106E5E5E3F3F5F5F4FFF2EFE9FFE7BA5FFFEFBE61FFF2C871FFF4D281FFF6DB
          91FFF8E19DFFF9E4A6FFF8E3A3FFF7DF99FFF6D88BFFF4CF7AFFF1C46AFFF9E7
          C9FFFFFFFFFFFCF5EBFFE79A3EFFE48B30FFE28228FFDF761DFFDF761DFFE077
          1FFFD9811DFFEEEAE5FFF1F1F0FFE0E0DFF30101010600000000000000000000
          0000AAAAA9B7F6F6F5FFF6F6F5FFE4C686FFF1C369FFF3CA72FFF5D484FFF7DC
          94FFF8E3A3FFF9E7AEFFF9E6ABFFF8E19DFFF6DA8EFFF4D17DFFF2C66DFFF0BF
          6BFFFEFDFCFFFFFFFFFFEDB574FFE48B30FFE28329FFDF761DFFDF761EFFE077
          1FFFD89B53FFF3F3F3FFF3F3F3FFA8A8A7B70000000000000000000000000000
          00005A5B5A60F7F7F4FFF7F7F5FFE8DCC2FFEFC770FFF2C971FFF4D382FFF6DB
          91FFF8E19EFFF9E4A7FFF8E4A4FFF7DF9AFFF6D88CFFF4CF7BFFF1C56CFFEEB9
          5BFFFCF5ECFFFFFFFFFFF0C18EFFE48B30FFE28228FFDF761DFFDF761DFFDC77
          1DFFE1CBAEFFF4F4F4FFF4F4F3FF595959600000000000000000000000000000
          00000909090AE2E2DFEBF8F8F5FFF7F7F4FFE2C687FFF3CB77FFF4CF7AFFF5D7
          89FFF7DC94FFF7DF99FFF7DE98FFF7E1A3FFF4D484FFF3CB75FFF0C167FFF1C4
          75FFFEFEFDFFFFFFFFFFEEB57BFFE4892FFFE18027FFDF761DFFDF751EFFD18F
          4BFFF4F4F3FFF5F5F4FFDFDFDFEB0909090A0000000000000000000000000000
          0000000000006F6F6D74F8F8F5FFF8F8F6FFF0EBDEFFE7C579FFF3CC77FFF4D0
          7CFFF5D586FFF5D88AFFF7DC99FFFEFDFAFFFBF1D9FFF8E5B9FFF9E6C0FFFDFA
          F2FFFFFFFFFFFCF4EFFFE6943FFFE3872DFFE07C24FFDF761DFFD17727FFEAE0
          D3FFF5F5F4FFF5F5F4FF6D6D6D74000000000000000000000000000000000000
          00000000000005050506C9C9C7D1F9F9F6FFF9F9F6FFEBE3CDFFE8C678FFF3CB
          77FFF3CC75FFF4CE79FFF6DA9DFFFEFCF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFBF0E8FFEAA661FFE58D31FFE2842BFFDF7920FFD27422FFE2CEBAFFF6F6
          F4FFF5F5F4FFC7C7C6D105050506000000000000000000000000000000000000
          000000000000000000002727272AE9EAE6F1F9FAF6FFF9F9F6FFEDE6D2FFE3C3
          79FFF2C973FFF1C46AFFF1C368FFF0C169FFF2CB8CFFF4D09CFFF3CC99FFEEB8
          79FFE7993FFFE59033FFE3882EFFE18027FFCE7C31FFE6D5C3FFF7F7F5FFF6F6
          F5FFE7E7E5F12727272A00000000000000000000000000000000000000000000
          00000000000000000000000000003E3E3D42EEEEEAF5F9FAF5FFF9FAF5FFF4F3
          EAFFE1CC9BFFE3BC67FFEFBF63FFEEB759FFECB050FFEBAA4AFFE9A343FFE89B
          3CFFE59236FFE48D2FFFD4852DFFD5AA76FFF2EDE5FFF7F7F5FFF7F7F5FFECEC
          E9F53E3E3D420000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000003737363AE2E2DEE9FAFAF5FFF9FA
          F5FFF9FAF5FFF3EFE4FFE2D0A9FFDEBE7CFFDBAF5DFFD9A245FFD79C3EFFD69F
          4AFFD8AB66FFDCC399FFF0EBE1FFF9F9F6FFF8F8F6FFF8F8F6FFE0E0DEE93636
          363A000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000016161618A6A6A4ADF9F9
          F5FFFAFAF6FFFAFAF5FFFAFAF5FFFAFAF5FFF9FAF5FFF9F9F5FFF9F9F5FFF9FA
          F5FFF9FAF6FFF9FAF6FFF9FAF6FFF9F9F6FFF8F8F5FFA5A5A3AD161616180000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000003D3D
          3C40B1B1ADB7F7F7F2FDFAFAF6FFFAFAF6FFFAFAF6FFFAFAF6FFFAFAF5FFFAFA
          F5FFF9FAF5FFF9FAF5FFF6F6F2FDAFB0ADB73C3C3B4000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000001818181A5D5E5C629696939BB7B7B4BDC8C9C5CFC8C8C5CFB7B7
          B4BD9595939B5D5D5C621818181A000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFF81FFFFFC003FFFF0000FFFE00007FFC00003FF800001FF000
          000FE0000007E0000007C0000003C0000003C0000003C0000003C0000003C000
          0003C0000003C0000003C0000003C0000003C0000003C0000003E0000007E000
          0007F000000FF000000FF800001FFC00003FFE00007FFF0000FFFFC003FFFFF8
          1FFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000003020408372A46126C5387229172B133A887C93AB190D137AC8CCD2397
          77B91272578F063A2B4A00030204000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000047
          325E0EB181E329D09FFF4BDBB1FF65E3BFFF7BE9CAFFA5F0DCFF98EFD7FF6CE5
          C3FF4EDCB2FF2BD0A0FF0FAB7EDB023224420000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000006F4E9301C3
          89FF1CCD96FF39D6A6FF51DDB4FF65E3BFFF92ECD3FFA9F1DDFFA9F1DDFF6FE6
          C4FF56DFB6FF40D8AAFF27D09CFF09C08BF90039294C00000000000000004845
          4564848080A9868383AB868383AB868383AB868383AB868383AB868383AB8683
          83AB868383AB868383AB868383AB868383AB868383AB458C76B900C288FF03C6
          88FF1ECE97FF3AD6A7FF52DDB4FF66E3BFFF9FEFD8FFAAF1DEFFA9F1DDFF78E7
          C7FF55DEB6FF40D8AAFF2AD19EFF12CA91FF00AF7CE7000A070E3C393954D6D4
          D4FFE2E2E2FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
          E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FF1FC694FF00C486FF03C6
          88FF1FCE97FF3BD6A7FF52DEB5FF6AE4C1FFA3EFDAFFAAF1DEFFA9F1DDFF7DE8
          C9FF55DEB6FF3FD8AAFF29D19DFF13CB91FF01C388FF0045315C67656587E2E2
          E2FFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
          EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFCCE8DFFF00C288FF00C486FF04C6
          88FF20CE98FF3BD7A7FF53DEB5FF6EE5C3FFA3EFDAFFAAF1DEFFA9F1DDFF7EE8
          CAFF54DEB5FF3ED8A9FF28D19DFF13CB91FF01C487FF006F4F9368666687E6E6
          E6FFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEF
          EFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFB1E4D4FF00C288FF00C586FF04C6
          89FF20CF98FF3CD7A8FF54DEB5FF6EE5C3FF9EEFD8FFA6F1DCFFA4F0DBFF7CE8
          C9FF53DEB5FF3ED7A9FF28D19DFF12CA90FF01C587FF007D58A569676787E7E7
          E7FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFDFDFEDFF6B6BDDFF6B6BDDFF728FD4FF68D6B6FF68D6B5FF6AD7
          B6FF73DABBFF7BDCC0FF84DEC5FF8AE0C8FF8FE2CBFF89DAC4FF85D6C0FF88DE
          C6FF7AD6BCFF1F7F639F0C70538F056F4F8F006C4C8F00412E5669676787E8E8
          E8FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
          F1FFF1F1F1FFD2D2ECFF0000CFFF0000CFFF4A4AD9FFF1F1F1FFF1F1F1FFF1F1
          F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFEDEDEDFFD1D1D1FFE0E0
          E0FFE9E9E9FF8A8A8AA70000000000000000000000000000000069676787E9E9
          E9FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
          F2FFF2F2F2FFD3D3EEFF0000D4FF0000D4FF4A4ADDFFF2F2F2FFF2F2F2FFF2F2
          F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFE6E6E6FFD3D3
          D3FFE8E8E8FFE0E0E0FF4C4C4C5E0000000000000000000000006A686887EAEA
          EAFFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFCECE
          F0FFA6A6EEFF9292ECFF0000E0FF0000E0FF3333E5FFA6A6EEFFA6A6EEFFEFEF
          F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF1F1F1FFD6D6
          D6FFD8D8D8FFECECECFFCCCCCCF11C1C1C2400000000000000006A686887EBEB
          EBFFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FF7C7C
          F0FF0000ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000ECFFE8E8
          F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF2F2F2FFCFCD
          CDF3ACACACD3E0E0E0FFE7E7E7FF7D7D7D9700000000000000006B696987EBEB
          EBFFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FF7D7D
          F6FF0000F8FF0000F8FF0000F8FF0000F8FF0000F8FF0000F8FF0000F8FFE9E9
          F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF3F3F3FFCCCB
          CBEF2323232CCBCBCBF5E0E0E0FF5D5D5D6C00000000000000006B696987ECEC
          ECFFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFB9B9
          F7FF7979FAFF6A6AFAFF0000FFFF0000FFFF2525FDFF7979FAFF7979FAFFEFEF
          F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF4F4F4FFCDCC
          CCEF0000000020202028363636400000000000000000000000006C696987EDED
          EDFFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
          F6FFF6F6F6FFD7D7F7FF0000FFFF0000FFFF4B4BFCFFF6F6F6FFF6F6F6FFF6F6
          F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF5F5F5FFCECD
          CDEF0000000000000000000000000000000000000000000000006C6A6A87EEEE
          EEFFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
          F7FFF7F7F7FFD8D8F8FF0000FFFF0000FFFF4C4CFCFFF7F7F7FFF7F7F7FFF7F7
          F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF6F6F6FFCFCD
          CDEF0000000000000000000000000000000000000000000000006C6B6B87EFEF
          EFFFF9F9F9FFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFB
          FBFFFBFBFBFFF6F6FBFFD5D5FCFFD5D5FCFFE1E1FCFFFBFBFBFFFBFBFBFFFBFB
          FBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFF6F6F6FFCFCE
          CEEF0000000000000000000000000000000000000000000000006D6B6B87EFEF
          EFFFFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8FFD0CF
          CFEF0000000000000000000000000000000000000000000000006D6B6B87F0F0
          F0FFFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8FFD0CF
          CFEF0000000000000000000000000000000000000000000000004C4B4B64E8E8
          E8FFF9F9F9FFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFC
          FCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFC
          FCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFF1F1F1FFACAB
          ABCB000000000000000000000000000000000000000000000000030202046D6C
          6C89B0B0B0CDB6B5B5CFB6B5B5CFB6B5B5CFB6B5B5CFC1BFBFDBDFDEDEFFC4C3
          C3E3B6B5B5CFB6B5B5CFB6B5B5CFB6B5B5CFB6B5B5CFB6B5B5CFD4D2D2F5D9D8
          D8F7B6B5B5CFB6B5B5CFB6B5B5CFB6B5B5CFB6B5B5CFB5B4B4CF999898B51E1D
          1D28000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000003232323ADCDBDBFF7876
          769F000000000000000000000000000000000000000010101016BEBBBBEDB7B6
          B6D3000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000F0F0F12D3D1D1F1D8D6
          D6FFB7B5B5DDAFADADD3AFADADD3AFADADD3AFADADD3CAC7C7F3DEDCDCFF8988
          889D000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000002D2D2D347B7A
          7A89807F7F8B807F7F8B807F7F8B807F7F8B807F7F8B807F7F8B696969780A0A
          0A0C000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01FFFFFC007FFFF
          0003C0000001800000010000000000000000000000010000000F0000000F0000
          000700000003000000270000003F0000003F0000003F0000003F0000003F0000
          003F8000003F8000007FFF3F3FFFFF003FFFFF80FFFFFFFFFFFFFFFFFFFFFFFF
          FFFF}
      end>
  end
  object cxImageListStatus: TcxImageList
    FormatVersion = 1
    DesignInfo = 12452476
    ImageInfo = <
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000805000E0805000E0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000493109722519053865450C9565450C952519
          0538493109720000000000000000000000000000000000000000000000000000
          000000000000261B073C2A1E083E91671AC7BF8822FDC28A22FFC28A22FFBF88
          22FD91671AC72A1E083E261B073C000000000000000000000000000000000000
          00000000000048351066C5912DFFC8932DFFC8932DFFC8932DFFC8932DFFC893
          2DFFC8932DFFC5912DFF48351066000000000000000000000000000000000000
          000051401C7092702ABBCDA960FFC99C41FFC99938FFCE9C39FFCE9C39FFCE9C
          39FFCE9C39FFCE9C39FF92702ABB4F3C17700000000000000000000000000000
          0000584A2D6ED2A544FFD3C4A4FFD3BF97FFDACBA9FFD5BF93FFD1B16EFFD1A4
          45FFD3A545FFD3A545FFD2A544FF52401A6E0000000000000000000000000806
          030C6F5A2A8DD1AB58FFE8E4DBFFD3C39EFFCFBA8CFFDED3BBFFD0B67AFFD0B0
          69FFD6BD85FFD4AB50FFD7AD50FF6F5A2A8D0806030C00000000000000001A16
          0D24AA935DC7DCB65CFFD8B45EFFD8C087FFD9C79EFFD6C6A2FFD4BB80FFD9CD
          B0FFDBCCAAFFE4DCCAFFD7B86FFFA28542C71814092400000000000000000000
          000039301A46E3C067FFE4C068FFE4C068FFDEBD68FFDFC991FFD2C092FFD3BF
          8CFFE8E5DEFFDCD3BCFFD9BA6CFF39301A460000000000000000000000000000
          000084744B9FD2B770E9E9C973FFE9C973FFE9C973FFE9C973FFE9C973FFE6C7
          72FFE0C98BFFDDCEA3FFCBB26CE983744A9F0000000000000000000000000000
          0000000000004C432858EDD17EFFEED280FFEED280FFEED280FFEED280FFEED2
          80FFEED280FFEDD17EFF4C432858000000000000000000000000000000000000
          000000000000504932607067487ECAB774DBF4DB8BFFF4DB8BFFF4DB8BFFF4DB
          8BFFCBB774DB7167487E4E47305E000000000000000000000000000000000000
          0000000000000000000000000000857A509D6C634178B1A474BDAEA069BD6E67
          4A78877D559D0000000000000000000000000000000000000000000000000000
          00000000000000000000000000000101000200000000201F18261F1D13260000
          0000010100020000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FE7F0000F81F0000F00F0000E0070000E0070000C003
          0000C0030000E0070000C0030000F00F0000F81F0000FA5F0000FFFF0000FFFF
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000010710000A3A81000A
          3A81000A3A81000A3A81000A3A81000A3A81000A3A8100072B60000000000000
          000000000000000000000000000000000000000000002B3B60818CE4F6FF3BEF
          FEFF4CC1E9FF14BAEDFF0974CEFF023AAEFF001893FF001784FF000000000000
          00000000000000000000000000000000000000000000000209108479859FD9E6
          F6FF95C0EDFF4B9BE6FF4396E5FF4095E5FF4868AFFF11193A70000000000000
          0000000000000000000000000000000000000000000000000000281E2640EAE1
          ECFFF8FDFEFFADE0FEFF2DA7FEFF1A9BFEFF625784EF00000000000000000000
          0000000000000000000000000000000000000000000000000000000000009C87
          9CCFFEFEFEFFCBECFEFF2AA4FEFF328BDFFF442B3A8100000000000000000000
          0000000000000000000000000000000000000000000000000000000000001D15
          1C30C6B5C8EFF1FAFEFFD6D7E9FF795571CF0805071000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000634A5F9FD3C4D9FFA986A4FF251B23400000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000005644
          5381BFADC9FFDBDBECFFF1F1F7FFB49AB3EF1D161C3000000000000000000000
          000000000000000000000000000000000000000000000000000016121620B59B
          BAFFC9C9E1FFDADAEBFFF2F2F8FFF2F2F8FF725A70AF00000000000000000000
          000000000000000000000000000000000000000000000000000051455170B6AB
          CCFFB5B5D6FFB6B6D6FFB6B6D6FFB6B6D6FFAE97B9FF0B080A10000000000000
          0000000000000000000000000000000000000000000007293F401C78BDDF1D5D
          B0FF1B57ACFF1A51A9FF184BA5FF1744A1FF163C99FF021556AF000000000000
          000000000000000000000000000000000000000000002F648081B6EEF9FF4CC1
          E9FF4CC1E9FF1890D5FF0868C2FF0553B6FF0340ABFF002088FF}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FFFF0000FFFF0000FF010000FE000000FF010000FF81
          0000FF810000FFC30000FFC70000FF830000FF810000FF810000FF000000FE00
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000102030405080A0C06080A0C06080A0C06080A0C0709
          0A0C06080A0C0203040600000000000000000000000000000000000000000000
          00000000000000000000010102040C10151C1D29353E22303D461F2D39461F2D
          3A460F171E280203030600000000000000000000000000000000000000000000
          00000000000200000004000000040000000C05080A200C111630080E1330090F
          143001020318000000100000000E000000060000000000000000000000000000
          00000000000C0000001A0000002000000030020304460A0E125A070D135C060A
          0E560000003C0000003A0000002E000000180000000600000000000000000000
          00000000000000000000000000042231425E5C89BCE16FA3DCFB6799C5F76CA4
          D2FD273F577C0101010600000002000000000000000000000000000000000000
          00020D0C0A240202020A354F6E916BA1DDFD76ACE3FF7AAFE6FF8EB8DFFFA9C9
          EBFFA0C5E7FF4C667E9D02020206030303080000000000000000000000000B08
          0010958E7DF9708195ED5F92C6FB73A8E2FF7BAFE6FF86B7EAFF9DC5F0FF97C0
          EBFF88B5E3FF74A3D0F3545659B9272C2E580000000200000000000000000201
          000892886CC7B6C3D0FF77AEDEFF6BA3DAFF8CB9E8FFA5CAF3FFABCEF7FFAACE
          F7FF9FC7F3FF7BABDAFF7B8F97EB0B191F3E0001010400000000000000000302
          000A5C4E2485CAC8C4FF8BB5DCFF7CB3E4FF7EB3E3FF9BBEE4FF9FC2EAFF9CC2
          ECFF8AB4E3FF93B1CFFF2B5E74C90318204C0405060A00000000000000000303
          000A271F09588F7A44DBAAACA8D555738C9F8EABC4D578AFDFF978B1E4FF7EB4
          E5FF8FB8DCF1708A99C501425DCF001721600002020A00000000000000000504
          000A1D1500381711002E0707060800000000010101020D12161C171E252C2B31
          363C0707080A0303030403101628001D2A5000090D1A00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000200000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FC3F0000F00F0000C007
          0000C0070000C0070000E0070000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000020000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000702041045172E95551C3AAF642243C30401
          021E000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000002E0F1F54CB82C0FFECB9FCFFC884BDFF3912
          2585000000060000000000000002000000040000000000000000000000000000
          000200000006000000020702051A6E264AC1E2C1F7FFEDBCFFFFE9AAF2FF9F3E
          75F95A1D3BBD391226836A284CC13110207A000000000000000000000000300F
          1F5E712A4FD55D1E3DBF8F406FE1DA87D1FFD07AC2FFCB82C0FFCA8AC3FFE5B6
          F4FFDC86D3FFE19DE3FFEBBEFEFFA24782F10702042600000000070205149F52
          84E9E5CBFEFFD4E7FBFFDB9CDDFFC191BEFFDECFFAFFE4CEFFFFE4C1F8FFC485
          BBFFD2BFE5FFF5ABFFFFE6C9FFFFB3609CF118081030000000004C193387C98F
          C5FFD8E5FFFFDFD6FEFFBB91B8FFDAE2FFFFC19CC4FD94547ED9C087B8FDE6C9
          FEFFC087B7FFE7C7FFFFC67BB8FD210A164400000000000000000802050E6525
          46A7C1BED3FFD5BEE7FFC3BED6FFCDD2EAFF3B14276E0000000042152C70D1AC
          DBFFCD9DCFFFDCBBEEFFB6609AFF0501031E0000000000000000000000000C04
          0818B297B1FFCFBFE2FFC2CBDBFFC9D8E9FF2D101F700000000434112364CDB0
          D9FFCDA7D4FFDCB5EAFFB774A5FF230B17680000000200000000000000001D09
          1340B696B5FFD2ECFCFFB7A3BCFFCDFBFFFFAFA3B9F7714C66C9B08DAEF7DAE1
          FEFFBF8FBAFFE0D3FEFFD5E5FBFFA96090F91D09134E0000000011050B289766
          86E9D3E8FBFFCFF8FFFFC0BCD2FFBDC2D2FFCDFCFFFFD0F6FFFFD3F0FFFFC3AE
          CDFFCCADD7FFD1F3FFFFDBE0FFFFA96393F50F040920000000002F0F1F50B9A8
          C0FFCEFAFFFFD4ECFEFFCFF1FBFFC3D0DEFFB7A3BDFFBAA5C0FFBB9BBDFFCAB9
          DBFFB17FA6FB956A89DDB16D9CFF4B1832870000000000000000000000005A27
          4293A784A0F56A3853A9854066D3B998B9FFD3F0FFFFD3F0FFFFCEE5F4FF8139
          60D3230B173E000000000E0409180501030A0000000000000000000000000301
          02060602040C0000000002000104591D3B97C4DDE6FFCCFDFFFFB9ADC3FF2E0F
          1E5C000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000001D091332A15E86FB9C6C8DE9833C62D30903
          0618000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000100000200000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FC7F0000FC3F0000F8070000C003000080030000000700008387
          0000C3870000C00300008003000080030000803F0000F87F0000FC7F0000FFFF
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000002120C22259170DF30B18DFF12513B87000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000003110B20289372DF37C9A8FF2DC39FFF39BE9EFF052317420000
          0000000000000000000000000000000000000000000000000000000000000000
          000003100B1E279171DD3ACBACFF2FC4A1FF2FC4A1FF35C8A7FF2C997AE1020A
          071400000000000000000000000000000000000000000000000000000000030E
          091A299070DB3ECEB0FF34C7A6FF4CCFB3FF3ACAAAFF33C7A5FF40CEB0FF195B
          4593000000000000000000000000000000000000000000000000020806102A8F
          6FD943D1B4FF39CBACFF65D9C1FF50977ED58CD5C1FF44CFB2FF3ACCACFF42C6
          A8FF0B31225800000000000000000000000000000000000000000821173C48CA
          ADFF41D2B4FF6ADCC6FF4E957CD5020B0714123A2A6490D8C5FF49D3B7FF43D3
          B6FF36A386E3030D091800000000000000000000000000000000000000001549
          357A61D0B8FF4F967ED5030B081400000000000000001540306C94DBC9FF4ED7
          BDFF4DD9BFFF246E57A900000000000000000000000000000000000000000000
          0000081E15340206040C000000000000000000000000000000001945347097DD
          CCFF53DCC3FF4ED1B6FF1037285E000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000001C49
          387499E0D0FF5AE0CAFF41AC93E3050F0B1A0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000214E3E7A9CE2D3FF5EE3CEFF2B745EAB0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000002553437E9FE5D7FF5ADAC2FF163D2E6400000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000028574881A0E7DAFF4BB49CE306100C1C000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000002C5B4B859FE8DAFF22544185000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000204F4174122C2346000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000F8FF0000F0FF0000E07F0000C03F0000803F0000861F0000CF0F
          0000FF8F0000FFC70000FFE30000FFF30000FFF10000FFF80000FFFF0000FFFF
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          000000000000000000000000000001010618161738542727547224244E6E1010
          284A000000140000000200000000000000000000000000000000000000000000
          00000000000004051220212C8DA74756EBF75D69FCFF7076FCFF8182FDFF8585
          FEFF6D6DD8EB2F2F658D00000216000000000000000000000000000000000000
          000007092C3E132CD9ED1B3AF8FF2E47F9FF4154FAFF5462FBFF666FFCFF797C
          FDFF8485FDFF8686FEFF5B5BB7D305050D280000000000000000000000000505
          1B280A13C7EF0619E2FF0A25EEFF1534F6FF2639CCD929349EA9363EA6B15760
          E3ED6F76FCFF8082FDFF8585FEFF595AB5D10000021400000000000000002727
          9BC10306CEFF020AD4FF0B18CCEF0A0E41500000000000000000000001042832
          94A95361FBFF666FFCFF787CFDFF8484FDFF3030658B000000000E0F29365556
          DDFF3E3ED7FF0D0ECBFD07072B3E000000000000000000000104142390A72440
          F9FF364DFAFF495AFBFF5C68FBFF6F75FCFF6769D8EB000000102E316E816267
          E4FF5C5EE0FF36368DB30000000000000000000001040E1485A7081EE7FF0D2B
          F2FF1A39F8FF232E94A73E4EE2ED5261FBFF656EFCFF0E0E2744464C96A77079
          ECFF6A70E7FF232454720000000000000104252683A70E13D3FF030ED8FF0618
          E1FF121E8EA5000001041F2FA5B1374EFAFF5363FBFF1E214F6A515AA1AD808D
          F5FF7984EFFF23254E6E000001043B3C87A76162DFFF5B5CDDFF5153DDFF2629
          86A500000104000000002D3A9BA94F67F9FF5A6EFAFF1F23536C4B52879190A0
          FBFF8896F7FF3F4581A744488CA7757BE9FF6F72E5FF696AE1FF3A3A87A50000
          01040000000000000000454EC3DB5063F2FF5269F8FF1315364C272A4650A7B1
          FCFF9BA8FCFF8C9AF4FD8A96F5FF848DF1FF7D85ECFF43448BA5000001040000
          00000000000019193F545E62E3FF5A63E8FF5260E0F70001061200000306969C
          D8E1B0BAFDFFA5B1FCFF9AA8FBFF929FF8FF4C5091A700000104000000000000
          000213132D446364CEEF6969E1FF6467E2FF3537829F00000000000000002D2E
          4650C0C5FCFFBAC1FDFFAFB9FDFFA0ACF9FF4B5184A92B2E52742E3158785054
          96B77D82E5FD7B7DE6FF7676E3FF6364CAEB0505101A00000000000000000000
          000048496874C8CCFCFFC2C9FDFFB9C1FDFFAFB9FCFFA4B1FCFF9CA8F9FF969F
          F5FF9097F0FF898EECFF7579D5EF13142C3A0000000000000000000000000000
          0000000000002E2F444EA8ACD8E1CBCFFDFFC2C9FDFFB8C1FDFFAEB9FCFFA5B1
          FBFF9DA7F7FF6368ADBF0D0D1D26000000000000000000000000000000000000
          00000000000000000000000003062F30465063658791767AA4AD6C719DA74B50
          778115172C360000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000F00F0000E0070000C0030000878100008F0100000E0100001C11
          0000183100000071000080F1000081E10000C1830000E0070000F00F0000FC3F
          0000}
      end>
  end
  object cxGridPopupMenu: TcxGridPopupMenu
    Grid = cxGridSS
    PopupMenus = <
      item
        GridView = tblSQLScript
        HitTypes = [gvhtCell]
        Index = 0
        PopupMenu = pmSQLScript
      end
      item
        GridView = tblSQLScript
        HitTypes = [gvhtColumnHeader]
        Index = 1
        PopupMenu = pmGridHeader
      end>
    Left = 512
    Top = 286
  end
  object pmSQLScript: TPopupMenu
    Images = cxImageListMenu
    Left = 908
    Top = 182
    object N1: TMenuItem
      Caption = #1057#1090#1072#1090#1091#1089
      SubMenuImages = cxImageListStatus
      ImageIndex = 2
      object N2: TMenuItem
        Action = acStatusNew
      end
      object N3: TMenuItem
        Action = acStatusWork
      end
      object N4: TMenuItem
        Action = acStatusReady
      end
      object N12: TMenuItem
        Action = acStatusPartComplite
      end
      object N5: TMenuItem
        Action = acStatusComplite
      end
      object N9: TMenuItem
        Action = acStatusCancel
      end
    end
    object N6: TMenuItem
      Action = acCompare
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object N16: TMenuItem
      Action = acSaveAllToFile
    end
    object N15: TMenuItem
      Caption = '-'
    end
    object N14: TMenuItem
      Action = acCommitNow
    end
    object Rollback1: TMenuItem
      Action = acRollbackNow
    end
  end
  object pmBody: TPopupMenu
    Images = cxImageListMenu
    Left = 796
    Top = 182
    object miBodyRename: TMenuItem
      Action = acRenameSQLScript
    end
    object miBodyCompare: TMenuItem
      Action = acCompareBody
    end
    object N7: TMenuItem
      Action = acCompareOld
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object miBodySave: TMenuItem
      Action = acSaveToFile
    end
  end
  object cxImageListMenu: TcxImageList
    FormatVersion = 1
    DesignInfo = 12452356
    ImageInfo = <
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FCFDFCFFFCFD
          FCFFFCFDFCFFFDFEFDFFF4F4F4FFD2D3D3FFB5B3B2FFAAA8A5FFABA9A6FFB5B5
          B5FFD1D2D2FFF0F1F0FFFCFDFCFFFCFDFCFFFCFDFCFFFCFDFCFFFCFDFCFFFCFD
          FCFFFCFDFCFFD8D8D8FF878381FF4B403CFF472F22FF60351EFF7B4021FF864F
          33FF89695AFF9E9B99FFD9DADAFFF9FAFAFFFCFDFDFFF7FAFBFFFCFDFCFFFCFD
          FCFFBBBEBEFF404040FF15110EFF1B0F09FF39190AFF662809FF8E3405FFB043
          08FFC4551DFFA65D39FF8A7C75FFC6CACAFFCFCCC9FFD4D5D5FFFEFFFEFFC6C6
          C6FF323232FF131214FF272423FF3C3835FF56433AFF754934FF91451EFFAF43
          09FFD45A1AFFED7237FFC36C43FF8E6D5EFFA5725BFFB7B1ADFFE9E9E9FF5252
          52FF131313FF282829FF696969FFA7AAAAFFBEC3C4FFC3C6C7FFC6BBB5FFC592
          77FFD1652DFFF07437FFFA8953FFE98656FFC57C59FFB4AFAAFF9E9E9EFF1B1C
          1BFF171614FF4D4F4EFFB8BFC2FFB9CAD2FF9EB4BCFF97ABB3FF9DAFB7FFB3C4
          CCFFCFB1A0FFEB7A42FFFB8C56FFFF9C6CFFC98361FFB4AFAAFF555756FF1010
          11FF171717FF7B8385FFB2C6CFFF98AEB5FF96A7ADFF869499FF8D989DFF95A4
          ACFFA8A5A3FFE07844FFFC874EFFFF9A68FFCB835FFFB2AFABFF343334FF100E
          0DFF141515FF92A3A9FFA1B8C1FFA4B9BEFF93A0A5FF888B8CFF7E898DFF9AAA
          B0FFA68B7BFFC48461FFB56C4AFF9E5735FF87553DFFB1ADABFF2C2B2DFF0B0A
          0CFF16171BFF8B9EA4FF9FB5C0FFB3C8D0FFAEB7B8FFC8C8C6FFACB8BDFFAFC3
          CBFFA4BAC3FFA3B7BFFF5D5D5EFF191817FF282626FFADACAAFF454493FF3435
          98FF2C2B99FF4143B5FF717CBCFFC3D6E2FFC7D4D9FFCACDCEFFD5E1E5FFCEE1
          EAFFACC2CBFF90A1A8FF474949FF141415FF2D2D2FFFBABBBBFF6564DCFF6767
          FFFF5150FEFF3B3AD8FF7888ADFFC2D5DFFFE1EEF6FFEFF5FAFFF2F7FAFFD5E2
          E8FF99AEB5FF676F73FF282829FF181819FF525352FFD9DBDCFF6866D9FF6D6D
          FEFF5656FCFF3B3AE3FF5961A3FF8899A2FFB2C3C9FFCBD8DCFFBBCAD0FF95A6
          ADFF6B787EFF353535FF211E1EFF343435FF989797FFF6F7F6FF5E5DD5FF5D5D
          EBFF5352F8FF3937F0FF2222C8FF3A3E99FF5A6486FF6A7688FF636F79FF4A54
          59FF343536FF29282AFF393737FF717070FFDFDEDDFFFDFEFDFF7979C9FFABAC
          D5FF6767E2FF3635EBFF1A1AD4FF0A0BAFFF111186FF19195AFF1E1E39FF2223
          2BFF2E2E30FF3E3E40FF727172FFCCCDCCFFFBFCFCFFFCFDFCFFECEDF1FFFCFD
          FBFFD4D6E9FF6E6FD7FF2726CBFF0B0CAEFF0A0A8DFF0D0C62FF15153FFF2122
          32FF424349FF858587FFD3D4D4FFFBFCFBFFFCFDFCFFFCFDFCFFFDFEFDFFFCFD
          FCFFFEFFFCFFEDEEF2FFA9AAD8FF5E5FBCFF313398FF2A297AFF3A3B63FF696A
          78FFB1B3B6FFECEDEDFFFDFEFDFFFCFDFCFFFCFDFCFFFCFDFCFF}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          00000101022C1315176200000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000001020A5C8DA6F917364E8B000000020000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000798F9BC13F90C3FF1444679D0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000174F667619A2EAFF2089D5FF07202F4E00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000203081090C6D91E93E0FF1B76B3E501040610000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000041E2B3A15A9EEFD208DDBFF11476C9B000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000B55768D1A9FE9FF1F8BD6FF061A26420000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000003050A128DC4D91E92E0FF1A71ADDD0002
          030A000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000051E2C3C17A5EBFD208EDDFF1040
          638F000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000D53778F1C9BE7FF1E8B
          D6FD051520380000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000103050A1588C4DB1F91
          DFFF186CA6D50001020800000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000061D2B3C199F
          E8FD3797DAFF3B53638500000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000002B54
          6C91CACCCCFFCDCCCCFB2525252E000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000C0C
          0C14BEBEBEEB9796C2FF626299C9000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000303040566260CDFF7270D7FB05050A0C0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000001C1B3C4C19182F38000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000E7FF0000E3FF0000F3FF0000F1FF0000F8FF0000F8FF0000FC7F
          0000FE3F0000FE3F0000FF1F0000FF8F0000FF8F0000FFC70000FFE70000FFFF
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000171717243B3B
          3B5C4A4A4A74545454835C5C5C8F5D5D5D916565659D6666669F6666669F6565
          659D5D5D5D915C5C5C8F545454834A4A4A743B3B3B5C171717240A0A0A101C1C
          1C2C2727273E3030304C343434523D3D3D603D3D3D603D3D3D604D4D4D785555
          55833F3F3F62343434523030304C2727273E1C1C1C2C0A0A0A10000000000000
          0000000000000000000000000000000000002727273A8B8B8BCFACACACFFACAC
          ACFF9D9D9DE94040406000000000000000000000000000000000000000000000
          00000000000000000000000000002A2A2A3CABABABF77F7F7FB94F4F4F744D4D
          4D72848484BFB1B1B1FF3F3F3F5A000000000000000000000000000000000000
          0000000000000000000004040406A3A3A3DD6C6C6C9500000000000000000000
          000000000000828282B3A9A9A9E7040404060000000000000000000000000000
          0000000000000E0E0E127D7D7DA1C4C4C4FF7777779B0C0C0C10000000000000
          0000000000004545455ACCCBC4FF4F4E48600000000000000000000000000000
          00000807030C928055D1CCCCCBFFCCCCCCFFCCCCCCFF9C937ED30705010C0000
          000011100E12C3BBA3D1DBC592FFD4C18DFF938D72A901010102000000000000
          000067511F9F9F7A28FF8A7D5CC1272727308D8169BF9F7B2AFF644D19A10000
          00007E7B6E85DEBE80FFC49B4AFFB28C3AFFC5AF73FF3F3C2F4A000000002C24
          1140A07B29FF876822D90A070210000000000806020E866722D79F7A28FF2A20
          0A44999585A1DBB66FFFC49B4AFFB28C3AFFBEA462FF5754426600000000876B
          2EC5A78130FD201909320000000000000000000000001E1707309D7929FB8064
          24C74C4B4450EAD9AEFFCFAB60FFC5A45CFFD1C599F51C1B16201E1A0F26B48E
          3CFF84682BBD00000000000000000000000000000000000000007B6024B9AC86
          35FF1F190C2A5B595160B7B29CC5A9A48DB936342D3C000000004C3F2260BD95
          44FF765D2A9F00000000000000000000000000000000000000006E57259BB68F
          3DFF4C3F216400000000000000000000000000000000000000004C40265AC99F
          4EFF98783CCD0506094601020318000000000101021605060946917338CBC49B
          4AFF4E42275E00000000000000000000000000000000000000000807040AB192
          55CF816B47FF272A33FF262831E9000000022B2D35E72C2F38FF7E6A48FFB496
          5AD10806030A0000000000000000000000000000000000000000000000000A09
          050C5E5C59B57A7A7DFF6E6F73E5000000026A6B6EE376777BFF5C5A59B70C0A
          050E000000000000000000000000000000000000000000000000000000000000
          0000010101022D2D2D421212121C000000001111111C2C2C2C44020202040000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00E0070000FFBF0000FE1F0000FCCF0000F9E70000F1F70000E0E10000C441
          0000CE4100009F2100009F3300009F3F00009F3F0000843F0000C47F0000FFFF
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000001111113200000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000E0E0E26363636FB383838C30C0C0C360000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000002E2E2EAB2C2C2CFF424242FF494949FD3E3E
          3EA7030303200000000000000000000000000000000000000000000000000000
          0000000000000000000010101034303030FD7B7B7BFFD3D2D3FF949494FF4444
          44FF575757F72828288900000010000000000000000000000000000000000000
          000000000000000000002D2D2DBB353536FFCFCFD0FFCDCDCEFFD7D7D8FFDCDB
          DCFF8C8C8CFF494949FF3C3C3CEB0A0A0A6A0000000400000000000000000000
          0000000000000F0F0F422F2F2FFF909090FFD8D8D8FFD4D4D5FFE2E2E2FFE0E0
          E0FFEAEAEBFFDFDFDFFF878787FF464646FF171717BF00000000000000000000
          0000000000002C2C2CCB282828FF9C9C9CFFD8D7D8FFE4E4E4FFE0E0E0FFE7E7
          E8FFF1F1F1FFF3F3F3FFE0E0E0FF535353FF1E1E1E7200000000000000000000
          0000131313542E2E2EFF2E2E2EFF323232FF555555FFB4B4B4FFE8E8E8FFF5F4
          F5FFF2F1F2FFF9F9F9FF848484FF484848E10000000800000000000000000000
          00042D2D2DD72C2C2CFF353535FF404040FF3B3B3BFF3D3D3DFF707070FFCFCF
          CFFFF5F5F5FFD3D3D3FF545454FF1A1A1A600000000000000000000000001515
          15642D2D2DFF2E2E2EFF828282FFE9E9E9FF858585FF414141FF484848FF4A4A
          4AFF898989FF707070FF454545D5000000040000000000000000000000062B2B
          2BE32C2C2CFF373737FFE4E4E4FFFEFEFEFFFEFEFEFFB1B1B1FF777777FF4C4C
          4CFF555555FF595959FF15151550000000000000000000000000010101041515
          15702C2C2CE7838383FFF8F8F8FFFAFAFAFFC2C2C2FF0F0F0FFFE2E2E2FF5757
          57FF585858FF404040C700000000000000000000000000000000000000000000
          00000202020A4747475EC6C6C6DBF1F1F1FF595959FF696969FFABABABFF5656
          56FF5A5A5AFF0F0F0F3E00000000000000000000000000000000000000000000
          0000000000000000000001010104515151649D9D9DE1CDCDCDFF5E5E5EFF5959
          59FF393939B50000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000020202063F3F3F72505050EF5858
          58FD0A0A0A2E0000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000050505101919
          1954000000000000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FCFF0000F83F0000F80F0000F0070000F0010000E0030000E003
          0000C0070000C0070000800F0000C00F0000F01F0000FC1F0000FF3F0000FFFF
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000002000000040000000400000006000000060000
          0004000000040000000200000000000000000000000000000000000000000000
          0000000000040000000A00000012000000180000001E00000022000000220000
          001E00000018000000120000000A000000040000000000000000000000000000
          0000000000040000000A00000012000000181037257A449471EF010F08400000
          001E00000018000000120000000A000000040000000000000000000000000000
          000000000000000000000001010620543C954DAC8BFF3BA682FF2B664CAB0000
          0004000000040000000200000000000000000000000000000000000000000000
          00000000000000080412307255BB4AAE8CFF32A47DFF32A47DFF50AB8AFD0318
          0E34000000000000000000000000000000000000000000000000000000000000
          000002130A28438E70DB46AF8CFF37A883FF38A984FF37A883FF3EAB87FF3779
          5DBF000000000000000000000000000000000000000000000000000000000000
          0000469675E742B08BFF3BAD87FF50B593FF489876EB52B694FF3BAD87FF57B5
          94FF0827184C0000000000000000000000000000000000000000000000000000
          00001A45317856B896FF5AB897FF235C429B000704104A9979E540B18CFF42B2
          8DFF428C6DD30001010400000000000000000000000000000000000000000000
          000000000002245941931037256400000000000000000E3522625DBD9CFF44B5
          90FF5CBD9CFF1035236200000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000002448C6FD34CBB
          96FF49BA94FF4E9E7FE50004020A000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000826174A63C1
          A0FF4CBE98FF60C4A3FF1B47327A000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000003C7E
          63BF58C4A1FF51C29DFF5AAE8EF1010A05160000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000319
          0E3466C1A1FD55C6A1FF6ACDACFF1F4E38810000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000306B51A76FC9A9FF3B7A5FB7021109240000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000080412021A0E3800000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FEFF0000F87F0000F07F0000E03F0000C03F0000E21F
          0000EF1F0000FF0F0000FF8F0000FF870000FFC30000FFC70000FFFF0000FFFF
          0000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          000000000000000000000000000001010618161738542727547224244E6E1010
          284A000000140000000200000000000000000000000000000000000000000000
          00000000000004051220212C8DA74756EBF75D69FCFF7076FCFF8182FDFF8585
          FEFF6D6DD8EB2F2F658D00000216000000000000000000000000000000000000
          000007092C3E132CD9ED1B3AF8FF2E47F9FF4154FAFF5462FBFF666FFCFF797C
          FDFF8485FDFF8686FEFF5B5BB7D305050D280000000000000000000000000505
          1B280A13C7EF0619E2FF0A25EEFF1534F6FF2639CCD929349EA9363EA6B15760
          E3ED6F76FCFF8082FDFF8585FEFF595AB5D10000021400000000000000002727
          9BC10306CEFF020AD4FF0B18CCEF0A0E41500000000000000000000001042832
          94A95361FBFF666FFCFF787CFDFF8484FDFF3030658B000000000E0F29365556
          DDFF3E3ED7FF0D0ECBFD07072B3E000000000000000000000104142390A72440
          F9FF364DFAFF495AFBFF5C68FBFF6F75FCFF6769D8EB000000102E316E816267
          E4FF5C5EE0FF36368DB30000000000000000000001040E1485A7081EE7FF0D2B
          F2FF1A39F8FF232E94A73E4EE2ED5261FBFF656EFCFF0E0E2744464C96A77079
          ECFF6A70E7FF232454720000000000000104252683A70E13D3FF030ED8FF0618
          E1FF121E8EA5000001041F2FA5B1374EFAFF5363FBFF1E214F6A515AA1AD808D
          F5FF7984EFFF23254E6E000001043B3C87A76162DFFF5B5CDDFF5153DDFF2629
          86A500000104000000002D3A9BA94F67F9FF5A6EFAFF1F23536C4B52879190A0
          FBFF8896F7FF3F4581A744488CA7757BE9FF6F72E5FF696AE1FF3A3A87A50000
          01040000000000000000454EC3DB5063F2FF5269F8FF1315364C272A4650A7B1
          FCFF9BA8FCFF8C9AF4FD8A96F5FF848DF1FF7D85ECFF43448BA5000001040000
          00000000000019193F545E62E3FF5A63E8FF5260E0F70001061200000306969C
          D8E1B0BAFDFFA5B1FCFF9AA8FBFF929FF8FF4C5091A700000104000000000000
          000213132D446364CEEF6969E1FF6467E2FF3537829F00000000000000002D2E
          4650C0C5FCFFBAC1FDFFAFB9FDFFA0ACF9FF4B5184A92B2E52742E3158785054
          96B77D82E5FD7B7DE6FF7676E3FF6364CAEB0505101A00000000000000000000
          000048496874C8CCFCFFC2C9FDFFB9C1FDFFAFB9FCFFA4B1FCFF9CA8F9FF969F
          F5FF9097F0FF898EECFF7579D5EF13142C3A0000000000000000000000000000
          0000000000002E2F444EA8ACD8E1CBCFFDFFC2C9FDFFB8C1FDFFAEB9FCFFA5B1
          FBFF9DA7F7FF6368ADBF0D0D1D26000000000000000000000000000000000000
          00000000000000000000000003062F30465063658791767AA4AD6C719DA74B50
          778115172C360000000000000000000000000000000000000000}
        Mask.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000F00F0000E0070000C0030000878100008F0100000E0100001C11
          0000183100000071000080F1000081E10000C1830000E0070000F00F0000FC3F
          0000}
      end>
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 796
    Top = 118
    PixelsPerInch = 96
    object stlGreen: TcxStyle
      AssignedValues = [svColor]
      Color = 8978312
    end
    object stlRed: TcxStyle
      AssignedValues = [svColor]
      Color = clMaroon
    end
    object stlYellow: TcxStyle
      AssignedValues = [svColor]
      Color = clYellow
    end
  end
  object FDConnectionIsCommited: TFDConnection
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    LoginPrompt = False
    Left = 44
    Top = 238
  end
  object qrQueryIsCommited: TFDQuery
    Connection = FDConnectionIsCommited
    Left = 188
    Top = 240
  end
  object sdBody: TSaveDialog
    DefaultExt = '*.sql'
    Filter = '*.sql|*.sql'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 524
    Top = 374
  end
  object pmGridHeader: TPopupMenu
    Left = 628
    Top = 289
    object miGridHeader: TMenuItem
      Caption = #1050#1086#1083#1086#1085#1082#1080'...'
      OnClick = miGridHeaderClick
    end
  end
  object SynEditSearch: TSynEditSearch
    Left = 932
    Top = 286
  end
  object fdBody: TFindDialog
    OnShow = fdBodyShow
    OnFind = fdBodyFind
    Left = 620
    Top = 374
  end
  object gchSQLScript: TsmGridColumnHide
    TableView = tblSQLScript
    Left = 796
    Top = 382
  end
end
