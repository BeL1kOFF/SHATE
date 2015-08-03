object frmTaskDetail: TfrmTaskDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1047#1072#1076#1072#1085#1080#1077
  ClientHeight = 185
  ClientWidth = 450
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
    Top = 144
    Width = 450
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = 408
    ExplicitTop = 200
    ExplicitWidth = 185
    DesignSize = (
      450
      41)
    object btnCancel: TButton
      Left = 354
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 0
      ExplicitLeft = 544
    end
    object btnSave: TButton
      Left = 258
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 448
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 144
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 24
    ExplicitWidth = 635
    ExplicitHeight = 259
    object cxLabel1: TcxLabel
      Left = 24
      Top = 24
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object edtName: TcxTextEdit
      Left = 24
      Top = 47
      TabOrder = 1
      Width = 257
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 74
      Caption = 'Guid:'
    end
    object edtGuid: TcxTextEdit
      Left = 24
      Top = 97
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 257
    end
    object cbEnable: TcxCheckBox
      Left = 312
      Top = 24
      Caption = #1042#1082#1083#1102#1095#1077#1085#1086
      TabOrder = 4
      Width = 121
    end
    object cbSynchronize: TcxCheckBox
      Left = 312
      Top = 59
      Caption = #1057#1080#1085#1093#1088#1086#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      TabOrder = 5
      Width = 121
    end
    object cbIsMemory: TcxCheckBox
      Left = 312
      Top = 97
      Caption = #1042' '#1087#1072#1084#1103#1090#1080
      TabOrder = 6
      Width = 121
    end
  end
  object ActionList: TActionList
    Left = 120
    Top = 144
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
