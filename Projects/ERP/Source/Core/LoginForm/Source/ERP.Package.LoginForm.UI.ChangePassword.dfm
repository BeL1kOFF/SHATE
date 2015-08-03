object frmChangePassword: TfrmChangePassword
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1086#1083#1103
  ClientHeight = 210
  ClientWidth = 298
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
    Top = 169
    Width = 298
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      298
      41)
    object btnSave: TButton
      Left = 103
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 200
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
    Width = 298
    Height = 169
    Align = alClient
    TabOrder = 1
    object cxLabel1: TcxLabel
      Left = 40
      Top = 48
      Caption = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100':'
      Transparent = True
    end
    object edtPassword: TcxTextEdit
      Left = 40
      Top = 71
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      TabOrder = 1
      Width = 211
    end
    object cxLabel2: TcxLabel
      Left = 27
      Top = 8
      Caption = #1042#1072#1084' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1086#1083#1100'.'
      ParentColor = False
      ParentFont = False
      Style.Color = clBtnFace
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clMaroon
      Style.Font.Height = -16
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.Shadow = False
      Style.TransparentBorder = True
      Style.IsFontAssigned = True
      StyleDisabled.TextColor = clMaroon
      Transparent = True
    end
    object cxLabel3: TcxLabel
      Left = 40
      Top = 96
      Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1077' '#1087#1072#1088#1086#1083#1100':'
      Transparent = True
    end
    object edtPassword2: TcxTextEdit
      Left = 40
      Top = 119
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      TabOrder = 4
      Width = 211
    end
  end
  object ActionList: TActionList
    Left = 56
    Top = 160
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
    end
  end
end
