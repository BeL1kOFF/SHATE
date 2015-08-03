object frmColumnCaption: TfrmColumnCaption
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1050#1086#1083#1086#1085#1082#1080
  ClientHeight = 310
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 269
    Width = 332
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      332
      41)
    object btnCancel: TButton
      Left = 243
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object btnSave: TButton
      Left = 155
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
    Width = 332
    Height = 269
    Align = alClient
    TabOrder = 1
    object clbTableColumn: TcxCheckListBox
      Left = 1
      Top = 1
      Width = 330
      Height = 267
      Align = alClient
      EditValueFormat = cvfStatesString
      Items = <>
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 32
    Top = 8
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
  end
end
