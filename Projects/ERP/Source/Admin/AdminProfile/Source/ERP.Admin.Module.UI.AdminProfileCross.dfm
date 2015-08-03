object frmAdminProfileCross: TfrmAdminProfileCross
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1092#1080#1083#1100': '
  ClientHeight = 373
  ClientWidth = 617
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 617
    Height = 332
    Align = alClient
    TabOrder = 0
    object tblProfileCross: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnMoving = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
    end
    object cxLevel: TcxGridLevel
      GridView = tblProfileCross
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 332
    Width = 617
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      617
      41)
    object btnCancel: TButton
      Left = 536
      Top = 6
      Width = 75
      Height = 25
      Action = actCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 432
      Top = 6
      Width = 75
      Height = 25
      Action = actSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object qrQuery: TFDQuery
    Left = 216
    Top = 317
  end
  object ActionList: TActionList
    Left = 160
    Top = 317
    object actSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = actSaveExecute
    end
    object actCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = actCancelExecute
    end
  end
  object ttTempTable: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id'
      end
      item
        Attributes = [fttaRequired]
        MSSQLDataType = mftBit
        FieldName = 'Applied'
        Precision = 1
        Size = 1
      end>
    Left = 112
    Top = 240
  end
end
