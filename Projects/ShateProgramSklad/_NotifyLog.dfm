object NotifyLogForm: TNotifyLogForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103
  ClientHeight = 268
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sgLog: TStringGrid
    Left = 0
    Top = 0
    Width = 460
    Height = 234
    Align = alClient
    ColCount = 2
    Ctl3D = True
    DefaultRowHeight = 16
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goRowSelect]
    ParentCtl3D = False
    TabOrder = 0
    ExplicitTop = -2
    ExplicitWidth = 492
    ColWidths = (
      56
      388)
  end
  object Panel1: TPanel
    Left = 0
    Top = 234
    Width = 460
    Height = 34
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 492
    DesignSize = (
      460
      34)
    object Button1: TButton
      Left = 380
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 412
    end
    object btClear: TBitBtn
      Left = 248
      Top = 4
      Width = 131
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1079#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = btClearClick
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000732DE000732DE00FF00FF000732
        DE000732DE00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF000732DE000732DE00FF00FF00FF00FF000732
        DE000732DE000732DE00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF000732DE000732DE00FF00FF00FF00FF00FF00FF000732
        DE000732DD000732DE000732DE00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF000732DE000732DE00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF000534ED000732DF000732DE000732DE00FF00FF00FF00FF00FF00FF00FF00
        FF000732DE000732DE00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF000732DE000732DE000732DD00FF00FF000732DD000732
        DE000732DE00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF000732DD000633E6000633E6000633E9000732
        DC00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000633E3000732E3000534EF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF000732DD000534ED000533E9000434EF000434
        F500FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF000434F4000534EF000533EB00FF00FF00FF00FF000434
        F4000335F800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF000335FC000534EF000434F800FF00FF00FF00FF00FF00FF00FF00
        FF000335FC000335FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF000335FB000335FB000335FC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF000335FB000335FB00FF00FF00FF00FF00FF00FF00FF00FF000335
        FB000335FB000335FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF000335FB00FF00FF00FF00FF000335FB000335
        FB000335FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000335FB000335
        FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      ExplicitLeft = 280
    end
  end
end