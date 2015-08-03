object frmEmployeeDetail: TfrmEmployeeDetail
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
  ClientHeight = 619
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 578
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 32
      Width = 55
      Height = 13
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
    end
    object edtName: TEdit
      Left = 34
      Top = 51
      Width = 576
      Height = 21
      TabOrder = 0
    end
    object cxGrid: TcxGrid
      Left = 34
      Top = 200
      Width = 576
      Height = 169
      TabOrder = 2
      object cxTable: TcxGridTableView
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
        DataController.OnNewRecord = cxTableDataControllerNewRecord
        OptionsData.Appending = True
        OptionsData.CancelOnExit = False
        OptionsData.DeletingConfirmation = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object colIdDepartment: TcxGridColumn
          Visible = False
        end
        object colName: TcxGridColumn
          Caption = #1054#1090#1076#1077#1083
          PropertiesClassName = 'TcxComboBoxProperties'
          Properties.DropDownListStyle = lsEditFixedList
          Properties.ImmediatePost = True
          Properties.OnValidate = colNamePropertiesValidate
          HeaderAlignmentHorz = taCenter
        end
        object colDate: TcxGridColumn
          Caption = #1044#1072#1090#1072
          PropertiesClassName = 'TcxDateEditProperties'
          Properties.DisplayFormat = 'dd.mm.yyyy'
          Properties.EditFormat = 'dd.mm.yyyy'
          HeaderAlignmentHorz = taCenter
        end
      end
      object cxLevel: TcxGridLevel
        GridView = cxTable
      end
    end
    object cxGridNumber: TcxGrid
      Left = 34
      Top = 394
      Width = 576
      Height = 169
      TabOrder = 3
      object cxTableNumber: TcxGridTableView
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
        DataController.OnNewRecord = cxTableNumberDataControllerNewRecord
        OptionsData.Appending = True
        OptionsData.CancelOnExit = False
        OptionsData.DeletingConfirmation = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object colIdCaller: TcxGridColumn
          Visible = False
        end
        object colNumber: TcxGridColumn
          Caption = #1053#1086#1084#1077#1088
          PropertiesClassName = 'TcxComboBoxProperties'
          Properties.DropDownListStyle = lsEditFixedList
          Properties.ImmediatePost = True
          Properties.OnValidate = colNumberPropertiesValidate
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
      object cxLevelNumber: TcxGridLevel
        GridView = cxTableNumber
      end
    end
    object Panel3: TPanel
      Left = 34
      Top = 86
      Width = 576
      Height = 88
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object Label3: TLabel
        Left = 8
        Top = 30
        Width = 82
        Height = 13
        Caption = #1053#1072#1095#1072#1083#1086' '#1088#1072#1073#1086#1090#1099':'
      end
      object Label4: TLabel
        Left = 157
        Top = 30
        Width = 76
        Height = 13
        Caption = #1050#1086#1085#1077#1094' '#1088#1072#1073#1086#1090#1099':'
      end
      object chbTime: TCheckBox
        Left = 8
        Top = 7
        Width = 209
        Height = 17
        Caption = #1054#1090#1083#1080#1095#1085#1086#1077' '#1074#1088#1077#1084#1103' '#1088#1072#1073#1086#1090#1099' '#1086#1090' '#1086#1090#1076#1077#1083#1072
        TabOrder = 0
        OnClick = chbTimeClick
      end
      object teBegin: TcxTimeEdit
        Left = 8
        Top = 48
        EditValue = 0d
        Enabled = False
        TabOrder = 1
        Width = 121
      end
      object teEnd: TcxTimeEdit
        Left = 157
        Top = 48
        EditValue = 0d
        Enabled = False
        TabOrder = 2
        Width = 121
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 578
    Width = 645
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnCancel: TButton
      Left = 549
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 468
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 40
    Top = 576
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
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 104
    Top = 576
  end
end
