object frmCallerDetail: TfrmCallerDetail
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1085#1086#1084#1077#1088#1086#1074
  ClientHeight = 294
  ClientWidth = 611
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
    Top = 253
    Width = 611
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 112
    ExplicitWidth = 312
    DesignSize = (
      611
      41)
    object btnSave: TButton
      Left = 437
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
      ExplicitLeft = 138
    end
    object btnCancel: TButton
      Left = 518
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 219
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 611
    Height = 253
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 312
    ExplicitHeight = 112
    object Label1: TLabel
      Left = 20
      Top = 11
      Width = 31
      Height = 13
      Caption = #1053#1086#1084#1077#1088
    end
    object edNumber: TEdit
      Left = 20
      Top = 30
      Width = 573
      Height = 21
      TabOrder = 0
      OnKeyPress = edNumberKeyPress
    end
    object cxGridEmployee: TcxGrid
      Left = 17
      Top = 68
      Width = 576
      Height = 169
      TabOrder = 1
      object cxTableEmployee: TcxGridTableView
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoImmediatePost]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.OnNewRecord = cxTableEmployeeDataControllerNewRecord
        OptionsData.Appending = True
        OptionsData.CancelOnExit = False
        OptionsData.DeletingConfirmation = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object colIdEmployee: TcxGridColumn
          Visible = False
        end
        object colEmployee: TcxGridColumn
          Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
          PropertiesClassName = 'TcxComboBoxProperties'
          Properties.DropDownListStyle = lsEditFixedList
          Properties.ImmediatePost = True
          Properties.OnValidate = colEmployeePropertiesValidate
          HeaderAlignmentHorz = taCenter
        end
        object colDateActive: TcxGridColumn
          Caption = #1044#1072#1090#1072
          PropertiesClassName = 'TcxDateEditProperties'
          Properties.DisplayFormat = 'dd.mm.yyyy'
          Properties.EditFormat = 'dd.mm.yyyy'
          HeaderAlignmentHorz = taCenter
        end
      end
      object cxLevelEmployee: TcxGridLevel
        GridView = cxTableEmployee
      end
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 88
    Top = 248
  end
  object ActionList: TActionList
    Left = 24
    Top = 248
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
  end
end
