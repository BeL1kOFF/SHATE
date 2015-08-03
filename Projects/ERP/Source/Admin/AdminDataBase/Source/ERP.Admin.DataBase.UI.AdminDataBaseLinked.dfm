object frmAdminDataBaseLinked: TfrmAdminDataBaseLinked
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1074#1103#1079#1072#1085#1085#1099#1077' '#1041#1044
  ClientHeight = 310
  ClientWidth = 645
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
  object Panel1: TPanel
    Left = 0
    Top = 269
    Width = 645
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      645
      41)
    object btnCancel: TButton
      Left = 544
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnSave: TButton
      Left = 456
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 1
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
      object tblLinked: TcxGridTableView
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
          Options.Editing = False
        end
        object colServer: TcxGridColumn
          Caption = #1057#1077#1088#1074#1077#1088
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colDataBase: TcxGridColumn
          Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colDataBaseName: TcxGridColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1041#1044
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object colChecked: TcxGridColumn
          Caption = #1057#1074#1103#1079#1072#1085#1072
          PropertiesClassName = 'TcxCheckBoxProperties'
          HeaderAlignmentHorz = taCenter
        end
      end
      object cxLevel: TcxGridLevel
        GridView = tblLinked
      end
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 240
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
    Top = 240
  end
  object ttLinkedDB: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id_DataBaseDetail'
      end>
    TableName = 'tmpLinkedDB'
    Left = 56
    Top = 136
  end
end
