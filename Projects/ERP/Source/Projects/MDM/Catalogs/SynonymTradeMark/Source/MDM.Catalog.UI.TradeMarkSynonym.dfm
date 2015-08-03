object frmTradeMarkSynonym: TfrmTradeMarkSynonym
  Left = 0
  Top = 0
  Caption = 'frmTradeMarkSynonym'
  ClientHeight = 300
  ClientWidth = 865
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcTradeMarkSynonym: TcxPageControl
    Left = 0
    Top = 0
    Width = 865
    Height = 300
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = tsClean
    Properties.CustomButtons.Buttons = <>
    OnChange = pcTradeMarkSynonymChange
    ClientRectBottom = 296
    ClientRectLeft = 4
    ClientRectRight = 861
    ClientRectTop = 24
    object tsDraft: TcxTabSheet
      Caption = #1063#1077#1088#1085#1086#1074#1080#1082
      ImageIndex = 0
      object wbDraftDetails: TERPWebBrowser
        Left = 734
        Top = 46
        Width = 123
        Height = 226
        Align = alRight
        TabOrder = 0
        ERPOptions.APProtocolList = <>
        ERPOptions.TemplateList = <>
        ExplicitLeft = 504
        ExplicitTop = 0
        ControlData = {
          4C000000B60C00005C1700000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object cxSplitter2: TcxSplitter
        Left = 726
        Top = 46
        Width = 8
        Height = 226
        AlignSplitter = salRight
        Control = wbDraftDetails
      end
      object cxGridDraftTMS: TcxGrid
        Left = 0
        Top = 46
        Width = 726
        Height = 226
        Align = alClient
        TabOrder = 2
        object tblTradeMarkSynonymDraft: TCatalogTableViewDraft
          Navigator.Buttons.CustomButtons = <>
          OnCellDblClick = tblTradeMarkSynonymDraftCellDblClick
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.CellSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsMDM.WebBrowser = wbDraftDetails
          OptionsMDM.ActionOptions.ActionRefresh = acDraftRefresh
          OptionsMDM.ActionOptions.ActionAdd = acDraftAdd
          OptionsMDM.ActionOptions.ActionEdit = acDraftEdit
          OptionsMDM.ActionOptions.ActionDelete = acDraftDelete
          OptionsMDM.ActionOptions.ActionStatusReset = acDraftStatusReset
          OptionsMDM.ActionOptions.ActionStatusReady = acDraftStatusReady
          OptionsMDM.ActionOptions.ActionStatusDelete = acDraftStatusDelete
          OptionsMDM.ActionOptions.ActionMerge = acDraftMerge
          OptionsMDM.ActionOptions.ActionAnalysis = acDraftAnalysis
          OptionsMDM.ActionOptions.ActionApprove = acDraftApprove
          OptionsMDM.ActionOptions.ActionImport = acDraftImport
          object colDraftId_TradeMarkSynonymDraft: TCatalogDraftColumn
            Visible = False
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Id_TradeMarkSynonymDraft'
            MetaOptions.PK = True
            MetaOptions.ServiceType = stPK
            IsCaptionAssigned = True
          end
          object colDraftId_TradeMarkSynonym: TCatalogDraftColumn
            Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Id_TradeMarkSynonym'
            MetaOptions.ServiceType = stPKClean
          end
          object colDraftTradeMarkName: TCatalogDraftColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'TradeMarkName'
          end
          object colDraftName: TCatalogDraftColumn
            Caption = #1057#1080#1085#1086#1085#1080#1084
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Name'
            MetaOptions.ServiceType = stMetaData
          end
          object colDraftShowUI: TCatalogDraftColumn
            Caption = #1054#1090#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1074' UI'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'ShowUI'
            MetaOptions.ServiceType = stMetaData
          end
          object colDraftUserName: TCatalogDraftColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'UserName'
          end
          object colDraftId_StatusDraft: TCatalogDraftColumn
            Visible = False
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Id_StatusDraft'
            MetaOptions.ServiceType = stStatus
          end
          object colDraftStatusName: TCatalogDraftColumn
            Caption = #1057#1090#1072#1090#1091#1089
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'StatusName'
          end
          object colDraftVersion: TCatalogDraftColumn
            Caption = #1042#1077#1088#1089#1080#1103
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Version'
          end
          object colDraftCondition: TCatalogDraftColumn
            Visible = False
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Condition'
            MetaOptions.ServiceType = stCondition
          end
          object colDraftAnalysisIcon: TCatalogDraftColumn
            Caption = #1040#1085#1072#1083#1080#1079
            PropertiesClassName = 'TcxImageProperties'
            Properties.GraphicClassName = 'TIcon'
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'AnalysisIcon'
          end
          object colDraftConditionName: TCatalogDraftColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'ConditionName'
          end
          object colDraftLabel: TCatalogDraftColumn
            Caption = #1052#1077#1090#1082#1072
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Label'
          end
        end
        object cxLevelDraftTMS: TcxGridLevel
          GridView = tblTradeMarkSynonymDraft
        end
      end
      object barDockDraft: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 857
        Height = 46
        Align = dalTop
        BarManager = BarManager
      end
    end
    object tsClean: TcxTabSheet
      Caption = #1063#1080#1089#1090#1086#1074#1080#1082
      ImageIndex = 1
      object cxGridTMS: TcxGrid
        Left = 0
        Top = 72
        Width = 702
        Height = 200
        Align = alClient
        TabOrder = 0
        object tblTradeMarkSynonymClean: TCatalogTableViewClean
          Navigator.Buttons.CustomButtons = <>
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.CellSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsMDM.WebBrowser = wbCleanDetails
          OptionsMDM.ActionOptions.ActionRefresh = acCleanRefresh
          OptionsMDM.ActionOptions.ActionMoveToDraft = acCleanMoveToDraft
          OptionsMDM.ActionOptions.ActionCopyFrom = acCleanCopyFrom
          OptionsMDM.ActionOptions.ActionRestore = acCleanRestore
          OptionsMDM.ActionOptions.ActionExport = acCleanExport
          object colCleanId_TradeMarkSynonym: TCatalogCleanColumn
            Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Id_TradeMarkSynonym'
            MetaOptions.PK = True
            MetaOptions.ServiceType = stPK
          end
          object colCleanTradeMarkName: TCatalogCleanColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'TradeMarkName'
          end
          object colCleanName: TCatalogCleanColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Name'
            MetaOptions.ServiceType = stMetaData
          end
          object colCleanShowUI: TCatalogCleanColumn
            Caption = #1054#1090#1086#1073#1088#1072#1078#1077#1085#1080#1077
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'ShowUI'
            MetaOptions.ServiceType = stMetaData
          end
          object colCleanVersion: TCatalogCleanColumn
            Caption = #1042#1077#1088#1089#1080#1103
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Version'
          end
          object colCleanEnabled: TCatalogCleanColumn
            Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1072
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'Enabled'
            MetaOptions.ServiceType = stEnabled
          end
          object colCleanCountDraft: TCatalogCleanColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1088#1085#1086#1074#1080#1082#1086#1074
            HeaderAlignmentHorz = taCenter
            MetaOptions.FieldName = 'CountDraft'
          end
        end
        object cxLevelTMS: TcxGridLevel
          GridView = tblTradeMarkSynonymClean
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 702
        Top = 72
        Width = 8
        Height = 200
        AlignSplitter = salRight
        Control = wbCleanDetails
      end
      object wbCleanDetails: TERPWebBrowser
        Left = 710
        Top = 72
        Width = 147
        Height = 200
        Align = alRight
        TabOrder = 2
        ERPOptions.APProtocolList = <>
        ERPOptions.TemplateList = <>
        ExplicitLeft = 480
        ExplicitTop = 3
        ExplicitHeight = 269
        ControlData = {
          4C000000310F0000AC1400000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object barDockClean: TdxBarDockControl
        Left = 0
        Top = 26
        Width = 857
        Height = 46
        Align = dalTop
        BarManager = BarManager
      end
      object dxBarDockControl1: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 857
        Height = 26
        Align = dalTop
        BarManager = BarManager
      end
    end
  end
  object BarManager: TdxBarManager
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
    ImageOptions.LargeImages = ilImage32
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 52
    Top = 224
    DockControlHeights = (
      0
      0
      0
      0)
    object barSTM: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockControl = barDockClean
      DockedDockControl = barDockClean
      DockedLeft = 0
      DockedTop = 0
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
          ItemName = 'dxBarLargeButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton3'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton4'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton5'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 2'
      CaptionButtons = <>
      DockControl = barDockDraft
      DockedDockControl = barDockDraft
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 669
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnDraftAdd'
        end
        item
          Visible = True
          ItemName = 'btnDraftEdit'
        end
        item
          Visible = True
          ItemName = 'btnDraftDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'btnDraftRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton7'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton9'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton11'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBar2: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 3'
      CaptionButtons = <>
      DockControl = dxBarDockControl1
      DockedDockControl = dxBarDockControl1
      DockedLeft = 0
      DockedTop = 0
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
          UserWidth = 202
          Visible = True
          ItemName = 'cmbTradeMark'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object btnRefresh: TdxBarLargeButton
      Action = acCleanRefresh
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acCleanMoveToDraft
      Category = 0
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Action = acCleanCopyFrom
      Category = 0
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = acCleanRestore
      Category = 0
    end
    object dxBarLargeButton5: TdxBarLargeButton
      Action = acCleanExport
      Category = 0
    end
    object btnDraftRefresh: TdxBarLargeButton
      Action = acDraftRefresh
      Category = 0
    end
    object btnDraftAdd: TdxBarLargeButton
      Action = acDraftAdd
      Category = 0
    end
    object btnDraftEdit: TdxBarLargeButton
      Action = acDraftEdit
      Category = 0
    end
    object btnDraftDelete: TdxBarLargeButton
      Action = acDraftDelete
      Category = 0
    end
    object cmbTradeMark: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxLookupComboBoxProperties'
      Properties.GridMode = True
      Properties.ImmediatePost = True
      Properties.KeyFieldNames = 'Id_TradeMark'
      Properties.ListColumns = <
        item
          Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
          FieldName = 'Id_TradeMark'
        end
        item
          Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
          FieldName = 'Name'
        end
        item
          Caption = #1055#1086#1083#1085#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
          FieldName = 'FullName'
        end>
      Properties.ListFieldIndex = 1
      Properties.ListSource = dsTradeMark
    end
    object cxBarEditItem2: TcxBarEditItem
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      Category = 0
      Hint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acDraftStatusReset
      Category = 0
    end
    object dxBarLargeButton6: TdxBarLargeButton
      Action = acDraftStatusReady
      Category = 0
    end
    object dxBarLargeButton7: TdxBarLargeButton
      Action = acDraftStatusDelete
      Category = 0
    end
    object dxBarLargeButton8: TdxBarLargeButton
      Action = acDraftMerge
      Category = 0
    end
    object dxBarLargeButton9: TdxBarLargeButton
      Action = acDraftApprove
      Category = 0
    end
    object dxBarLargeButton10: TdxBarLargeButton
      Action = acDraftAnalysis
      Category = 0
    end
    object dxBarLargeButton11: TdxBarLargeButton
      Action = acDraftImport
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 52
    Top = 150
    object acCleanRefresh: TCatalogAction
      Category = #1063#1080#1089#1090#1086#1074#1080#1082
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    end
    object acCleanMoveToDraft: TCatalogAction
      Category = #1063#1080#1089#1090#1086#1074#1080#1082
      Caption = #1042' '#1095#1077#1088#1085#1086#1074#1080#1082
    end
    object acCleanCopyFrom: TCatalogAction
      Category = #1063#1080#1089#1090#1086#1074#1080#1082
      Caption = #1050#1086#1087#1080#1103' '#1080#1079
    end
    object acCleanRestore: TCatalogAction
      Category = #1063#1080#1089#1090#1086#1074#1080#1082
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
    end
    object acCleanExport: TCatalogAction
      Category = #1063#1080#1089#1090#1086#1074#1080#1082
      Caption = #1069#1082#1089#1087#1086#1088#1090'...'
    end
    object acDraftRefresh: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    end
    object acDraftAdd: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1053#1086#1074#1099#1081'...'
    end
    object acDraftEdit: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'...'
    end
    object acDraftDelete: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    object acDraftStatusReset: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081
    end
    object acDraftStatusReady: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1043#1086#1090#1086#1074
    end
    object acDraftStatusDelete: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1050' '#1091#1076#1072#1083#1077#1085#1080#1102
    end
    object acDraftMerge: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1057#1083#1080#1103#1085#1080#1077'...'
    end
    object acDraftAnalysis: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1040#1085#1072#1083#1080#1079#1080#1088#1086#1074#1072#1090#1100
    end
    object acDraftApprove: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1059#1090#1074#1077#1088#1076#1080#1090#1100
    end
    object acDraftImport: TCatalogAction
      Category = #1063#1077#1088#1085#1086#1074#1080#1082
      Caption = #1048#1084#1087#1086#1088#1090'...'
    end
  end
  object dsTradeMark: TDataSource
    DataSet = memTradeMark
    Left = 124
    Top = 152
  end
  object memTradeMark: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 204
    Top = 144
  end
  object ilImage32: TcxImageList
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 14680236
  end
end
