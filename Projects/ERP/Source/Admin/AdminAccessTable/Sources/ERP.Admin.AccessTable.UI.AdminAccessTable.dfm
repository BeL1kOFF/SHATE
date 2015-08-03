object frmAccessTable: TfrmAccessTable
  Left = 0
  Top = 0
  Caption = 'frmAccessTable'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 46
    Width = 635
    Height = 254
    Align = alClient
    TabOrder = 4
    object tblAccessTable: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
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
      object colId_AccessTable: TcxGridColumn
        Visible = False
      end
      object colTemplateDataBase: TcxGridColumn
        Caption = #1064#1072#1073#1083#1086#1085' '#1041#1044
        HeaderAlignmentHorz = taCenter
      end
      object colTableName: TcxGridColumn
        Caption = #1058#1072#1073#1083#1080#1094#1072
        HeaderAlignmentHorz = taCenter
      end
      object colTableCaption: TcxGridColumn
        Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1090#1072#1073#1083#1080#1094#1099
        HeaderAlignmentHorz = taCenter
      end
      object colFieldId: TcxGridColumn
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        HeaderAlignmentHorz = taCenter
      end
      object colFieldName: TcxGridColumn
        Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
        HeaderAlignmentHorz = taCenter
      end
      object colFieldCaption: TcxGridColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1086#1083#1103
        HeaderAlignmentHorz = taCenter
      end
      object colAccessCode: TcxGridColumn
        Caption = #1050#1086#1076
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxLevel: TcxGridLevel
      GridView = tblAccessTable
    end
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 80
    Top = 192
    DockControlHeights = (
      0
      0
      46
      0)
    object dxBarManagerBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 669
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton3'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton4'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = acAdd
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = acEdit
      Category = 0
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Action = acDelete
      Category = 0
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = acRefresh
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 176
    Top = 200
    object acAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      OnExecute = acAddExecute
    end
    object acEdit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'...'
      OnExecute = acEditExecute
      OnUpdate = acEditUpdate
    end
    object acDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = acDeleteExecute
      OnUpdate = acDeleteUpdate
    end
    object acRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnExecute = acRefreshExecute
    end
  end
  object qrQuery: TFDQuery
    Left = 264
    Top = 216
  end
  object ttAccessTableDel: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id_AccessTable'
      end>
    TableName = 'tmpAccessTableDel'
    Left = 144
    Top = 128
  end
end
