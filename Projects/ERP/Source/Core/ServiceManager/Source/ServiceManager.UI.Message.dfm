object frmMessage: TfrmMessage
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
  ClientHeight = 239
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 198
    Width = 420
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      420
      41)
    object btnCancel: TButton
      Left = 311
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      ModalResult = 2
      TabOrder = 1
    end
    object btnSend: TButton
      Left = 214
      Top = 6
      Width = 75
      Height = 25
      Action = acSend
      Anchors = [akTop, akRight]
      ModalResult = 1
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 198
    Align = alClient
    TabOrder = 0
    object mmMessage: TMemo
      Left = 1
      Top = 1
      Width = 418
      Height = 196
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 144
    Top = 64
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
    object acSend: TAction
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
      OnUpdate = acSendUpdate
    end
  end
end
