object frmCategoryTaskDetail: TfrmCategoryTaskDetail
  Left = 0
  Top = 0
  Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1079#1072#1076#1072#1085#1080#1081
  ClientHeight = 280
  ClientWidth = 366
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
    Top = 239
    Width = 366
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      366
      41)
    object btnCancel: TButton
      Left = 274
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 178
      Top = 6
      Width = 75
      Height = 25
      Action = acOK
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 366
    Height = 239
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 103
      Height = 13
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1079#1072#1076#1072#1085#1080#1103':'
    end
    object Label2: TLabel
      Left = 24
      Top = 70
      Width = 53
      Height = 13
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
    end
    object edtName: TEdit
      Left = 24
      Top = 43
      Width = 325
      Height = 21
      TabOrder = 0
    end
    object mDescription: TMemo
      Left = 24
      Top = 89
      Width = 325
      Height = 128
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object ActionList: TActionList
    Left = 24
    Top = 232
    object acOK: TAction
      Caption = #1054#1050
      OnExecute = acOKExecute
      OnUpdate = acOKUpdate
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
  end
  object qrQuery: TFDQuery
    Left = 112
    Top = 232
  end
end
