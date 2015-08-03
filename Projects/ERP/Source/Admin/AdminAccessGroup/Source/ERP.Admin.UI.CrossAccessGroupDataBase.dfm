object frmAccessGroupDatabase: TfrmAccessGroupDatabase
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1088#1080#1074#1103#1079#1082#1072' '#1073#1072#1079' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 300
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 564
    Height = 259
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object tblCrossAccessGroupDB: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnMoving = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colIdDB: TcxGridColumn
        Visible = False
        Options.Editing = False
        VisibleForEditForm = bFalse
      end
      object colGroupName: TcxGridColumn
        Caption = #1057#1077#1088#1074#1077#1088
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        VisibleForEditForm = bFalse
        Width = 158
      end
      object colGroupDescr: TcxGridColumn
        Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        VisibleForEditForm = bFalse
        Width = 150
      end
      object colEnabled: TcxGridColumn
        Caption = #1055#1088#1080#1084#1077#1085#1077#1085#1072
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        HeaderAlignmentHorz = taCenter
        VisibleForEditForm = bTrue
        Width = 84
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = tblCrossAccessGroupDB
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 259
    Width = 564
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      564
      41)
    object btnCancel: TButton
      Left = 459
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 363
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 248
    Top = 128
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      OnExecute = acCancelExecute
    end
  end
  object qrQuery: TFDQuery
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    Left = 88
    Top = 216
  end
  object ttCrossAccessGroupDB: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id_database'
      end>
    TableName = 'tblCrossAccessGroupDB'
    Left = 136
    Top = 112
  end
end
