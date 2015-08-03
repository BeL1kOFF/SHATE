object frmAdminServerDetail: TfrmAdminServerDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1077#1088#1074#1077#1088#1072
  ClientHeight = 223
  ClientWidth = 282
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
    Top = 182
    Width = 282
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      282
      41)
    object btnCancel: TButton
      Left = 183
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 87
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
    Width = 282
    Height = 182
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 80
      Width = 41
      Height = 13
      Caption = #1057#1077#1088#1074#1077#1088':'
    end
    object Label2: TLabel
      Left = 24
      Top = 24
      Width = 86
      Height = 13
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088':'
    end
    object chbEnabled: TcxCheckBox
      Left = 24
      Top = 134
      Caption = #1042#1082#1083#1102#1095#1077#1085
      TabOrder = 0
      Width = 121
    end
    object edtId: TcxTextEdit
      Left = 24
      Top = 43
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 234
    end
    object edtName: TcxTextEdit
      Left = 24
      Top = 99
      TabOrder = 2
      Width = 234
    end
  end
  object ActionList: TActionList
    Left = 184
    Top = 128
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
end
