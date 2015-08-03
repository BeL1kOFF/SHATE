object frmDepartmentDetail: TfrmDepartmentDetail
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1090#1076#1077#1083#1099
  ClientHeight = 232
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
    Top = 191
    Width = 645
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 171
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 191
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 171
    object Label1: TLabel
      Left = 21
      Top = 32
      Width = 92
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1086#1090#1076#1077#1083#1072':'
    end
    object Label2: TLabel
      Left = 21
      Top = 93
      Width = 35
      Height = 13
      Caption = #1055#1086#1095#1090#1072':'
    end
    object Label3: TLabel
      Left = 376
      Top = 32
      Width = 82
      Height = 13
      Caption = #1053#1072#1095#1072#1083#1086' '#1088#1072#1073#1086#1090#1099':'
    end
    object Label4: TLabel
      Left = 506
      Top = 32
      Width = 76
      Height = 13
      Caption = #1050#1086#1085#1077#1094' '#1088#1072#1073#1086#1090#1099':'
    end
    object Label5: TLabel
      Left = 21
      Top = 139
      Width = 55
      Height = 13
      Caption = #1048#1079#1076#1077#1088#1078#1082#1072':'
    end
    object edtName: TEdit
      Left = 21
      Top = 51
      Width = 340
      Height = 21
      TabOrder = 0
    end
    object edtEmail: TEdit
      Left = 21
      Top = 112
      Width = 603
      Height = 21
      TabOrder = 4
    end
    object teBegin: TcxTimeEdit
      Left = 376
      Top = 51
      EditValue = 0d
      TabOrder = 1
      Width = 121
    end
    object teEnd: TcxTimeEdit
      Left = 503
      Top = 51
      EditValue = 0d
      TabOrder = 2
      Width = 121
    end
    object edtDistributionCost: TEdit
      Left = 21
      Top = 156
      Width = 603
      Height = 21
      TabOrder = 5
    end
    object cbRoundClock: TcxCheckBox
      Left = 376
      Top = 78
      Action = acRoundClock
      TabOrder = 3
      Width = 121
    end
  end
  object ActionList: TActionList
    Left = 64
    Top = 168
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
    object acRoundClock: TAction
      Caption = #1050#1088#1091#1075#1083#1086#1089#1091#1090#1086#1095#1085#1086
      OnExecute = acRoundClockExecute
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 128
    Top = 168
  end
end
