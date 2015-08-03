object frmAdminUserDetail: TfrmAdminUserDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
  ClientHeight = 295
  ClientWidth = 621
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
    Top = 254
    Width = 621
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      621
      41)
    object btnCancel: TButton
      Left = 540
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnSave: TButton
      Left = 436
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 621
    Height = 254
    Align = alClient
    TabOrder = 1
    object edtIdUser: TcxTextEdit
      Left = 24
      Top = 90
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 234
    end
    object edtName: TcxTextEdit
      Left = 24
      Top = 150
      TabOrder = 2
      Width = 234
    end
    object cxLabel1: TcxLabel
      Left = 24
      Top = 71
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088':'
      Transparent = True
    end
    object cxLabel3: TcxLabel
      Left = 24
      Top = 131
      Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
      Transparent = True
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 14
      Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081':'
      Transparent = True
    end
    object cbEnabled: TcxCheckBox
      Left = 24
      Top = 196
      Caption = #1040#1082#1090#1080#1074#1077#1085
      TabOrder = 6
      Width = 121
    end
    object cmbUsersGroups: TcxComboBox
      Left = 24
      Top = 37
      BeepOnEnter = False
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 0
      Width = 234
    end
    object edtLogin: TcxTextEdit
      Left = 352
      Top = 90
      TabOrder = 7
      Width = 234
    end
    object cxLabel4: TcxLabel
      Left = 352
      Top = 71
      Caption = #1051#1086#1075#1080#1085
    end
    object edtPassword: TcxMaskEdit
      Left = 352
      Top = 150
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      TabOrder = 9
      Width = 234
    end
    object cxLabel5: TcxLabel
      Left = 352
      Top = 131
      Caption = #1055#1072#1088#1086#1083#1100
    end
    object cbChangePassword: TCheckBox
      Left = 352
      Top = 196
      Width = 234
      Height = 17
      Caption = #1057#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1086#1083#1100' '#1087#1088#1080' '#1074#1093#1086#1076#1077
      TabOrder = 12
    end
    object cbWinAuth: TCheckBox
      Left = 352
      Top = 219
      Width = 225
      Height = 17
      Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103' Windows'
      TabOrder = 11
      OnClick = cbWinAuthClick
    end
  end
  object ActionList: TActionList
    Left = 240
    Top = 248
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      OnExecute = acCancelExecute
    end
  end
  object qrQuery: TFDQuery
    Left = 312
    Top = 248
  end
end
