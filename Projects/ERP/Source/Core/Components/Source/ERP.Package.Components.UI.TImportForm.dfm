object ImportForm: TImportForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1048#1084#1087#1086#1088#1090' '#1080#1079' Excel'
  ClientHeight = 349
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 629
    Height = 107
    Align = alTop
    Caption = #1060#1072#1081#1083' '#1076#1083#1103' '#1080#1084#1087#1086#1088#1090#1072
    TabOrder = 0
    DesignSize = (
      629
      107)
    object edtFileName: TcxButtonEdit
      Left = 16
      Top = 24
      Anchors = [akLeft, akTop, akRight]
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = edtFileNamePropertiesButtonClick
      TabOrder = 0
      Width = 595
    end
    object edtLabel: TcxTextEdit
      Left = 16
      Top = 74
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Width = 595
    end
    object cxLabel1: TcxLabel
      Left = 16
      Top = 51
      Caption = #1052#1077#1090#1082#1072' '#1080#1084#1087#1086#1088#1090#1072':'
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 308
    Width = 629
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      629
      41)
    object btnExport: TButton
      Left = 447
      Top = 6
      Width = 75
      Height = 25
      Action = acImport
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 536
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 107
    Width = 629
    Height = 201
    Align = alClient
    TabOrder = 2
    object cxGridImport: TcxGrid
      Left = 1
      Top = 1
      Width = 627
      Height = 199
      Align = alClient
      TabOrder = 0
      object tblImport: TcxGridTableView
        DragMode = dmAutomatic
        OnDragDrop = tblImportDragDrop
        OnDragOver = tblImportDragOver
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.DragDropText = True
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnSorting = False
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        Styles.OnGetContentStyle = tblImportStylesGetContentStyle
        object colBaseField: TcxGridColumn
          Caption = #1058#1072#1073#1083#1080#1094#1072' - '#1087#1086#1083#1077
          HeaderAlignmentHorz = taCenter
          Width = 161
        end
        object colBaseCaption: TcxGridColumn
          Caption = #1058#1072#1073#1083#1080#1094#1072' - '#1079#1072#1075#1086#1083#1086#1074#1086#1082
          HeaderAlignmentHorz = taCenter
          Width = 183
        end
        object colExcelField: TcxGridColumn
          Caption = 'Excel'
          HeaderAlignmentHorz = taCenter
          Width = 281
        end
        object colPK: TcxGridColumn
          Visible = False
        end
        object colBaseType: TcxGridColumn
          Visible = False
        end
        object colBaseSize: TcxGridColumn
          Visible = False
        end
      end
      object cxLevelImport: TcxGridLevel
        GridView = tblImport
      end
    end
  end
  object odImport: TOpenDialog
    Left = 40
    Top = 152
  end
  object ActionList: TActionList
    Left = 96
    Top = 211
    object acImport: TAction
      Caption = #1048#1084#1087#1086#1088#1090
      OnExecute = acImportExecute
      OnUpdate = acImportUpdate
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
  end
  object memQuery: TFDMemTable
    FieldDefs = <
      item
        Name = 'memQueryField1'
        DataType = ftWideString
        Size = 50
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 200
    Top = 161
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 280
    Top = 225
    PixelsPerInch = 96
    object stlYellow: TcxStyle
      AssignedValues = [svColor]
      Color = clYellow
    end
  end
  object ttImportExcel: TsmFireDACTempTable
    Fields = <>
    TableName = 'tmpImport'
    Left = 384
    Top = 169
  end
end
