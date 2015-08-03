object SelectBrandsForm: TSelectBrandsForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088' '#1073#1088#1077#1085#1076#1086#1074
  ClientHeight = 427
  ClientWidth = 241
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object clbBrands: TCheckListBox
    Left = 0
    Top = 22
    Width = 241
    Height = 368
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    ExplicitWidth = 270
    ExplicitHeight = 413
  end
  object Panel1: TPanel
    Left = 0
    Top = 390
    Width = 241
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 435
    ExplicitWidth = 270
    DesignSize = (
      241
      37)
    object btCancel: TButton
      Left = 161
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 190
    end
    object Button2: TButton
      Left = 80
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = Button2Click
      ExplicitLeft = 109
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 270
    DesignSize = (
      241
      22)
    object cbSelectAll: TCheckBox
      Left = 5
      Top = 4
      Width = 97
      Height = 17
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      TabOrder = 0
      OnClick = cbSelectAllClick
    end
    object Button1: TButton
      Left = 113
      Top = 2
      Width = 126
      Height = 19
      Anchors = [akTop, akRight]
      Caption = #1042#1099#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1092#1072#1081#1083#1091
      TabOrder = 1
      OnClick = Button1Click
      ExplicitLeft = 142
    end
  end
  object OD: TOpenDialog
    Left = 95
    Top = 295
  end
end
