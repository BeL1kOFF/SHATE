object frmAccessData: TfrmAccessData
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1086#1089#1090#1091#1087' '#1082' '#1076#1072#1085#1085#1099#1084
  ClientHeight = 310
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 269
    Width = 645
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnCancel: TButton
      Left = 560
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 472
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 269
    Align = alClient
    TabOrder = 1
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 643
      Height = 267
      Align = alClient
      TabOrder = 0
      object tblData: TcxGridTableView
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
        object colId_DataBase: TcxGridColumn
          Visible = False
        end
        object colId_AccessTable: TcxGridColumn
          Visible = False
        end
        object colId_Data: TcxGridColumn
          Visible = False
        end
        object colTemplateName: TcxGridColumn
          Caption = #1064#1072#1073#1083#1086#1085
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colDataBaseName: TcxGridColumn
          Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colAccessCode: TcxGridColumn
          Caption = #1050#1086#1076' '#1090#1072#1073#1083#1080#1094#1099
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colTableCaption: TcxGridColumn
          Caption = #1058#1072#1073#1083#1080#1094#1072
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colFieldCaption: TcxGridColumn
          Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colChecked: TcxGridColumn
          Caption = #1044#1086#1089#1090#1091#1087
          PropertiesClassName = 'TcxCheckBoxProperties'
          HeaderAlignmentHorz = taCenter
        end
        object colPrevChecked: TcxGridColumn
          Visible = False
        end
      end
      object cxLevel: TcxGridLevel
        GridView = tblData
      end
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 268
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
    Left = 136
    Top = 264
  end
  object FDConnectionRemote: TFDConnection
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    LoginPrompt = False
    Left = 48
    Top = 56
  end
  object qrQueryRemote: TFDQuery
    Connection = FDConnectionRemote
    Left = 48
    Top = 120
  end
end
