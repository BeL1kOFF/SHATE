object frmMDMTradeMarkDetail: TfrmMDMTradeMarkDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
  ClientHeight = 490
  ClientWidth = 475
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 449
    Width = 475
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      475
      41)
    object btnCancel: TButton
      Left = 373
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 277
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
    Width = 475
    Height = 449
    Align = alClient
    TabOrder = 0
    object edtName: TcxTextEdit
      Left = 24
      Top = 32
      TabOrder = 0
      OnExit = edtNameExit
      Width = 185
    end
    object cxLabel1: TcxLabel
      Left = 24
      Top = 16
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 72
      Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object edtFullName: TcxTextEdit
      Left = 24
      Top = 88
      TabOrder = 3
      Width = 424
    end
    object cbOriginal: TcxCheckBox
      Left = 327
      Top = 66
      Caption = #1054#1088#1080#1075#1080#1085#1072#1083
      TabOrder = 2
      Width = 121
    end
    object cxLabel3: TcxLabel
      Left = 24
      Top = 316
      Caption = #1051#1086#1075#1086#1090#1080#1087':'
    end
    object imgLogo: TcxImage
      Left = 24
      Top = 339
      Properties.Center = False
      Properties.PopupMenuLayout.MenuItems = [pmiDelete]
      Properties.IsGraphicClassNameEmpty = True
      TabOrder = 7
      OnDblClick = imgLogoDblClick
      Height = 100
      Width = 424
    end
    object edtVersion: TcxTextEdit
      Left = 327
      Top = 32
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 121
    end
    object cxLabel4: TcxLabel
      Left = 327
      Top = 16
      Caption = #1042#1077#1088#1089#1080#1103':'
    end
    object lbWarning: TcxLabel
      Left = 24
      Top = 51
      Caption = #1058#1072#1082#1072#1103' '#1090#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' '#1091#1078#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1077#1090
      ParentColor = False
      Style.Color = clRed
      Style.TextColor = clWhite
      Visible = False
    end
    object edtIdTradeMark: TcxTextEdit
      Left = 295
      Top = 32
      TabStop = False
      ParentColor = True
      Properties.ReadOnly = True
      TabOrder = 13
      Visible = False
      Width = 17
    end
    object cxLabel5: TcxLabel
      Left = 24
      Top = 160
      Caption = 'URL '#1082#1072#1090#1072#1083#1086#1075#1072':'
    end
    object edtURLCatalog: TcxTextEdit
      Left = 24
      Top = 176
      TabOrder = 5
      Width = 424
    end
    object cxLabel6: TcxLabel
      Left = 24
      Top = 117
      Caption = 'URL '#1089#1072#1081#1090#1072':'
    end
    object edtURLSite: TcxTextEdit
      Left = 24
      Top = 133
      TabOrder = 4
      Width = 424
    end
    object mDescription: TcxMemo
      Left = 24
      Top = 224
      TabOrder = 6
      Height = 89
      Width = 424
    end
    object cxLabel7: TcxLabel
      Left = 24
      Top = 203
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
    end
  end
  object ActionList: TActionList
    Left = 16
    Top = 440
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
  object odLogo: TOpenDialog
    Filter = 
      'BMP (*.bmp)|*.bmp|JPEG (*.jpeg;*.jpg)|*.jpeg;*.jpg|PNG (*.png)|*' +
      '.png'
    Left = 80
    Top = 440
  end
end
