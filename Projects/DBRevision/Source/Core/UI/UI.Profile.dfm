object frmProfile: TfrmProfile
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1087#1080#1089#1086#1082' '#1073#1072#1079' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 426
  ClientWidth = 642
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
  object btnAdd: TButton
    Left = 295
    Top = 215
    Width = 25
    Height = 25
    Action = acAdd
    TabOrder = 0
  end
  object btnDelete: TButton
    Left = 295
    Top = 246
    Width = 25
    Height = 25
    Action = acDelete
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 265
    Height = 426
    Align = alLeft
    TabOrder = 2
    object cxGridLeft: TcxGrid
      Left = 1
      Top = 1
      Width = 263
      Height = 424
      Align = alClient
      TabOrder = 0
      object tblDataBaseLeft: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        OnCellDblClick = tblDataBaseLeftCellDblClick
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
        OptionsSelection.MultiSelect = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object tblDataBaseLeftColumn1: TcxGridColumn
          Visible = False
        end
        object tblDataBaseLeftColumn2: TcxGridColumn
          Caption = #1057#1077#1088#1074#1077#1088
          HeaderAlignmentHorz = taCenter
        end
        object tblDataBaseLeftColumn3: TcxGridColumn
          Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
          HeaderAlignmentHorz = taCenter
        end
      end
      object cxLevelLeft: TcxGridLevel
        GridView = tblDataBaseLeft
      end
    end
  end
  object Panel5: TPanel
    Left = 354
    Top = 0
    Width = 288
    Height = 426
    Align = alRight
    TabOrder = 3
    object cxGridRight: TcxGrid
      Left = 1
      Top = 91
      Width = 286
      Height = 334
      Align = alBottom
      TabOrder = 0
      object tblDataBaseRight: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        OnCellDblClick = tblDataBaseRightCellDblClick
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
        OptionsSelection.MultiSelect = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object cxGridColumn1: TcxGridColumn
          Visible = False
        end
        object cxGridColumn2: TcxGridColumn
          Caption = #1057#1077#1088#1074#1077#1088
          HeaderAlignmentHorz = taCenter
        end
        object cxGridColumn3: TcxGridColumn
          Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
          HeaderAlignmentHorz = taCenter
        end
      end
      object cxLevelRight: TcxGridLevel
        GridView = tblDataBaseRight
      end
    end
    object cmbProfile: TcxComboBox
      Left = 16
      Top = 56
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cmbProfilePropertiesChange
      TabOrder = 1
      Width = 257
    end
    object btnProfileAdd: TButton
      Left = 23
      Top = 25
      Width = 58
      Height = 25
      Action = acProfileAdd
      TabOrder = 2
    end
    object Button1: TButton
      Left = 112
      Top = 25
      Width = 73
      Height = 25
      Action = acProfileEdit
      TabOrder = 3
    end
    object Button2: TButton
      Left = 207
      Top = 25
      Width = 58
      Height = 25
      Action = acProfileDelete
      TabOrder = 4
    end
  end
  object ActionList: TActionList
    Left = 289
    Top = 294
    object acProfileAdd: TAction
      Caption = #1053#1086#1074#1099#1081'...'
      OnExecute = acProfileAddExecute
    end
    object acProfileEdit: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
      OnExecute = acProfileEditExecute
      OnUpdate = acProfileEditUpdate
    end
    object acProfileDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = acProfileDeleteExecute
      OnUpdate = acProfileDeleteUpdate
    end
    object acAdd: TAction
      Caption = '->'
      OnExecute = acAddExecute
      OnUpdate = acAddUpdate
    end
    object acDelete: TAction
      Caption = '<-'
      OnExecute = acDeleteExecute
      OnUpdate = acDeleteUpdate
    end
  end
  object qrQuery: TFDQuery
    Connection = frmMain.FDConnection
    Left = 289
    Top = 357
  end
  object FDConnectionCheck: TFDConnection
    LoginPrompt = False
    Left = 288
    Top = 120
  end
end
