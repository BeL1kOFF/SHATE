object ExportForm: TExportForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' Excel'
  ClientHeight = 430
  ClientWidth = 398
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
  object Panel1: TPanel
    Left = 0
    Top = 389
    Width = 398
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      398
      41)
    object btnCancel: TButton
      Left = 308
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnExport: TButton
      Left = 219
      Top = 6
      Width = 75
      Height = 25
      Action = acExport
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 398
    Height = 369
    Align = alClient
    TabOrder = 1
    object cxGridExport: TcxGrid
      Left = 1
      Top = 1
      Width = 396
      Height = 367
      Align = alClient
      TabOrder = 0
      object tblExport: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnMoving = False
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.MultiSelect = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object colFieldName: TcxGridColumn
          Caption = #1057#1090#1086#1083#1073#1077#1094
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colFieldCaption: TcxGridColumn
          Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colCheck: TcxGridColumn
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.ImmediatePost = True
        end
      end
      object cxLevelExport: TcxGridLevel
        GridView = tblExport
      end
    end
  end
  object sbBar: TdxStatusBar
    Left = 0
    Top = 369
    Width = 398
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarContainerPanelStyle'
        PanelStyle.Container = sbBarContainer1
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    object sbBarContainer1: TdxStatusBarContainerControl
      Left = 2
      Top = 4
      Width = 394
      Height = 14
      object pbExport: TcxProgressBar
        Left = 0
        Top = 0
        Align = alClient
        TabOrder = 0
        Width = 394
      end
    end
  end
  object ActionList: TActionList
    Left = 72
    Top = 251
    object acExport: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090'...'
      OnExecute = acExportExecute
      OnUpdate = acExportUpdate
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
  end
  object sdExport: TSaveDialog
    DefaultExt = '*.xlsx'
    Filter = '*.xlsx|*.xlsx'
    Left = 72
    Top = 192
  end
  object tmpExport: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id'
      end>
    TableName = 'tmpExport'
    Left = 72
    Top = 120
  end
end
