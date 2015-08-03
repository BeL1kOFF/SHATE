object frmAdminUserAD: TfrmAdminUserAD
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' - Active Directory'
  ClientHeight = 300
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 259
    Width = 473
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      473
      41)
    object btnCancel: TButton
      Left = 382
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 293
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 473
    Height = 259
    Align = alClient
    TabOrder = 0
    object cxLabel2: TcxLabel
      Left = 24
      Top = 14
      Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081':'
      Transparent = True
    end
    object cmbUsersGroups: TcxComboBox
      Left = 24
      Top = 37
      BeepOnEnter = False
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 1
      Width = 234
    end
    object cxGrid: TcxGrid
      Left = 1
      Top = 72
      Width = 471
      Height = 186
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 3
      object tblUsers: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnMoving = False
        OptionsData.CancelOnExit = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsSelection.MultiSelect = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object colUserLogin: TcxGridColumn
          Caption = #1048#1084#1103' '#1074#1093#1086#1076#1072
          HeaderAlignmentHorz = taCenter
        end
        object colUserName: TcxGridColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          HeaderAlignmentHorz = taCenter
        end
      end
      object cxLevel: TcxGridLevel
        GridView = tblUsers
      end
    end
    object btnAddUserAD: TButton
      Left = 293
      Top = 36
      Width = 155
      Height = 25
      Action = acAdd
      TabOrder = 2
    end
  end
  object ActionList: TActionList
    Left = 32
    Top = 200
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
    object acAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081'...'
      OnExecute = acAddExecute
    end
  end
  object qrQuery: TFDQuery
    Left = 104
    Top = 200
  end
  object smFireDACTempTable: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        MSSQLDataType = mftNVarChar
        FieldName = 'UserLogin'
        Precision = 0
        Size = 128
      end
      item
        Attributes = [fttaRequired]
        MSSQLDataType = mftNVarChar
        FieldName = 'UserName'
        Precision = 0
        Size = 128
      end>
    TableName = 'tmpUserAD'
    Left = 184
    Top = 200
  end
end
