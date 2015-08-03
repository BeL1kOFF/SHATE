object frmCommitRollback: TfrmCommitRollback
  Left = 0
  Top = 0
  Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1089#1082#1088#1080#1087#1090#1086#1074
  ClientHeight = 471
  ClientWidth = 635
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
    Top = 430
    Width = 635
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      635
      41)
    object btnRun: TButton
      Left = 456
      Top = 6
      Width = 75
      Height = 25
      Action = acRun
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 544
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Panel4: TPanel
      Left = 393
      Top = 0
      Width = 242
      Height = 430
      Align = alRight
      TabOrder = 0
      object mLog: TMemo
        Left = 1
        Top = 1
        Width = 240
        Height = 428
        Align = alClient
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 393
      Height = 430
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 393
        Height = 41
        Align = alTop
        TabOrder = 0
        object cmbProfile: TcxComboBox
          Left = 22
          Top = 14
          Properties.DropDownListStyle = lsFixedList
          Properties.OnChange = cmbProfilePropertiesChange
          TabOrder = 0
          Width = 357
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 41
        Width = 393
        Height = 389
        Align = alClient
        TabOrder = 1
        DesignSize = (
          393
          389)
        object cxGrid: TcxGrid
          Left = 1
          Top = 1
          Width = 391
          Height = 336
          Align = alTop
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          object tblServer: TcxGridTableView
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
            object tblServerColumn1: TcxGridColumn
              Caption = #1057#1077#1088#1074#1077#1088
              HeaderAlignmentHorz = taCenter
            end
            object tblServerColumn2: TcxGridColumn
              Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
              HeaderAlignmentHorz = taCenter
            end
            object tblServerColumn3: TcxGridColumn
              Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1086
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
            end
          end
          object cxGridLevel: TcxGridLevel
            GridView = tblServer
          end
        end
        object cxProgressBar: TcxProgressBar
          Left = 22
          Top = 352
          Anchors = [akLeft, akRight, akBottom]
          TabOrder = 1
          Width = 357
        end
      end
    end
  end
  object ActionList: TActionList
    Left = 280
    Top = 200
    object acRun: TAction
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
      OnExecute = acRunExecute
      OnUpdate = acRunUpdate
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      OnExecute = acCancelExecute
    end
  end
  object qrQuery: TFDQuery
    Connection = frmMain.FDConnection
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    Left = 57
    Top = 57
  end
  object FDConnectionCommitRollback: TFDConnection
    Left = 488
    Top = 25
  end
end
