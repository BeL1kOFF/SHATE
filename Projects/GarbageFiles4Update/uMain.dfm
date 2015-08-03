object main: Tmain
  Left = 0
  Top = 0
  Caption = 'Uploader File For ShateMPlus'
  ClientHeight = 432
  ClientWidth = 749
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object EdMagic: TEdit
    Left = 133
    Top = 394
    Width = 83
    Height = 21
    TabOrder = 0
    Text = 
      'EXEC [sp_setapprole] '#39'$ndo$shadow'#39', '#39'FF5EC4E40F67BD4EDF3D04F8B84' +
      '364DAD0'#39', '#39'none'#39', 0, 0'
    Visible = False
  end
  object AdvOfficePager1: TAdvOfficePager
    Left = 0
    Top = 0
    Width = 749
    Height = 432
    AdvOfficePagerStyler = PageStyler
    Align = alClient
    ActivePage = AdvOfficePager11
    ButtonSettings.CloseButtonPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001000001010100000100
      0000000202000100020200000000000202020002020200000000010002020202
      0200010000000101000202020001010000000100020202020200010000000002
      0202000202020000000000020200010002020000000001000001010100000100
      0000}
    ButtonSettings.PageListButtonPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000101010100
      0000010101000200010101000000010100020202000101000000010002020202
      0200010000000002020200020202000000000002020001000202000000000100
      0001010100000100000001010101010101010100000001010101010101010100
      0000}
    ButtonSettings.ScrollButtonPrevPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000001010100
      0000010101000202000101000000010100020202000101000000010002020200
      0101010000000002020200010101010000000100020202000101010000000101
      0002020200010100000001010100020200010100000001010101000001010100
      0000}
    ButtonSettings.ScrollButtonNextPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010000010101010100
      0000010002020001010101000000010002020200010101000000010100020202
      0001010000000101010002020200010000000101000202020001010000000100
      0202020001010100000001000202000101010100000001010000010101010100
      0000}
    ButtonSettings.CloseButtonHint = 'Close'
    ButtonSettings.PageListButtonHint = 'Page List'
    ButtonSettings.ScrollButtonNextHint = 'Next'
    ButtonSettings.ScrollButtonPrevHint = 'Previous'
    TabSettings.StartMargin = 4
    TabReorder = False
    ShowShortCutHints = False
    TabOrder = 1
    NextPictureChanged = False
    PrevPictureChanged = False
    object AdvOfficePager11: TAdvOfficePage
      Left = 1
      Top = 26
      Width = 747
      Height = 404
      Caption = #1060#1072#1081#1083#1099' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080
      PageAppearance.BorderColor = clBlack
      PageAppearance.Color = clWhite
      PageAppearance.ColorTo = clBtnFace
      PageAppearance.ColorMirror = clBtnFace
      PageAppearance.ColorMirrorTo = clBtnFace
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = 10670559
      TabAppearance.BorderColorHot = 3251427
      TabAppearance.BorderColorSelected = clBlack
      TabAppearance.BorderColorSelectedHot = 4227327
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clWhite
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 5951226
      TabAppearance.ColorSelectedTo = 10543868
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clWhite
      TabAppearance.ColorHot = 5946106
      TabAppearance.ColorHotTo = 12779261
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 12779261
      TabAppearance.ColorMirrorHotTo = clWhite
      TabAppearance.ColorMirrorSelected = 10543868
      TabAppearance.ColorMirrorSelectedTo = clWhite
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clWhite
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = [fsBold]
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggVertical
      TabAppearance.GradientMirrorHot = ggVertical
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clBlack
      TabAppearance.TextColorHot = clBlack
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.BackGround.Color = clBtnFace
      TabAppearance.BackGround.ColorTo = clBtnFace
      TabAppearance.BackGround.Direction = gdVertical
      DesignSize = (
        747
        404)
      object Bevel2: TBevel
        Left = 2
        Top = 353
        Width = 743
        Height = 26
        Align = alBottom
        Shape = bsSpacer
        ExplicitLeft = 1
        ExplicitTop = 357
      end
      object Bevel1: TBevel
        Left = -14
        Top = 158
        Width = 812
        Height = 4
      end
      object Bevel4: TBevel
        Left = 2
        Top = 11
        Width = 765
        Height = 4
      end
      object lbProgressInfo: TLabel
        Left = 8
        Top = 361
        Width = 12
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = '    '
        ExplicitTop = 357
      end
      object lbProgressPercent: TLabel
        Left = 60
        Top = 360
        Width = 12
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = '    '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitTop = 356
      end
      object Panel2: TPanel
        Left = 2
        Top = 379
        Width = 743
        Height = 23
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 3
        Caption = 'Panel2'
        TabOrder = 0
        DesignSize = (
          743
          23)
        object Bevel3: TBevel
          Left = 661
          Top = 3
          Width = 79
          Height = 17
          Align = alRight
          Shape = bsSpacer
          ExplicitLeft = 551
          ExplicitTop = 18
        end
        object pb: TProgressBar
          Left = 3
          Top = 3
          Width = 658
          Height = 17
          Align = alClient
          Step = 1
          TabOrder = 0
        end
        object btAbort: TButton
          Left = 664
          Top = 3
          Width = 75
          Height = 18
          Anchors = [akRight, akBottom]
          Caption = #1055#1088#1077#1088#1074#1072#1090#1100
          TabOrder = 1
          OnClick = btAbortClick
        end
      end
      object MemoLog: TMemo
        Left = 2
        Top = 197
        Width = 743
        Height = 156
        Align = alBottom
        BevelInner = bvLowered
        BevelOuter = bvSpace
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object checkOE: TCheckBox
        Left = 21
        Top = 23
        Width = 90
        Height = 17
        Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1054#1045
        Checked = True
        Color = clBtnFace
        ParentColor = False
        State = cbChecked
        TabOrder = 2
        OnClick = checkOEClick
      end
      object CheckItems: TCheckBox
        Left = 21
        Top = 50
        Width = 106
        Height = 17
        Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' ITEMS'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = checkOEClick
      end
      object CheckKit: TCheckBox
        Left = 21
        Top = 77
        Width = 132
        Height = 17
        Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1084#1087#1083#1077#1082#1090#1099
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = checkOEClick
      end
      object CheckAna: TCheckBox
        Left = 21
        Top = 104
        Width = 115
        Height = 17
        Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1072#1085#1072#1083#1086#1075#1080
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = checkOEClick
      end
      object CheckPod: TCheckBox
        Left = 21
        Top = 131
        Width = 114
        Height = 17
        Caption = #1054#1089#1090#1072#1090#1082#1080' '#1055#1086#1076#1086#1083#1100#1089#1082
        Checked = True
        Color = clCream
        ParentColor = False
        State = cbChecked
        TabOrder = 6
        OnClick = checkOEClick
      end
      object btLoadItem: TButton
        Left = 719
        Top = 46
        Width = 23
        Height = 25
        Caption = '...'
        TabOrder = 7
        OnClick = btLoadOEClick
      end
      object btLoadKit: TButton
        Left = 719
        Top = 73
        Width = 23
        Height = 25
        Caption = '...'
        TabOrder = 8
        OnClick = btLoadOEClick
      end
      object btLoadPod: TButton
        Left = 719
        Top = 127
        Width = 23
        Height = 25
        Caption = '...'
        TabOrder = 9
        OnClick = btLoadOEClick
      end
      object btLoadOE: TButton
        Left = 719
        Top = 19
        Width = 23
        Height = 25
        Caption = '...'
        TabOrder = 10
        OnClick = btLoadOEClick
      end
      object btLoadAna: TButton
        Left = 719
        Top = 100
        Width = 23
        Height = 25
        Caption = '...'
        TabOrder = 11
        OnClick = btLoadOEClick
      end
      object aPathOE: TEdit
        Left = 159
        Top = 21
        Width = 555
        Height = 21
        TabOrder = 12
      end
      object aPathItem: TEdit
        Left = 159
        Top = 48
        Width = 555
        Height = 21
        TabOrder = 13
      end
      object aPathKit: TEdit
        Left = 159
        Top = 75
        Width = 555
        Height = 21
        TabOrder = 14
      end
      object aPathAna: TEdit
        Left = 159
        Top = 102
        Width = 555
        Height = 21
        TabOrder = 15
      end
      object aPathPod: TEdit
        Left = 159
        Top = 129
        Width = 555
        Height = 21
        TabOrder = 16
      end
      object Button6: TButton
        Left = 638
        Top = 166
        Width = 106
        Height = 25
        Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
        TabOrder = 17
        OnClick = Button6Click
      end
      object Button1: TButton
        Left = 525
        Top = 166
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 18
        Visible = False
      end
    end
    object AdvOfficePage1: TAdvOfficePage
      Left = 1
      Top = 26
      Width = 747
      Height = 404
      Caption = 'test'
      PageAppearance.BorderColor = clBlack
      PageAppearance.Color = clWhite
      PageAppearance.ColorTo = clBtnFace
      PageAppearance.ColorMirror = clBtnFace
      PageAppearance.ColorMirrorTo = clBtnFace
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabVisible = False
      TabAppearance.BorderColor = 10670559
      TabAppearance.BorderColorHot = 3251427
      TabAppearance.BorderColorSelected = clBlack
      TabAppearance.BorderColorSelectedHot = 4227327
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clWhite
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 5951226
      TabAppearance.ColorSelectedTo = 10543868
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clWhite
      TabAppearance.ColorHot = 5946106
      TabAppearance.ColorHotTo = 12779261
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 12779261
      TabAppearance.ColorMirrorHotTo = clWhite
      TabAppearance.ColorMirrorSelected = 10543868
      TabAppearance.ColorMirrorSelectedTo = clWhite
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clWhite
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = [fsBold]
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggVertical
      TabAppearance.GradientMirrorHot = ggVertical
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clBlack
      TabAppearance.TextColorHot = clBlack
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.BackGround.Color = clBtnFace
      TabAppearance.BackGround.ColorTo = clBtnFace
      TabAppearance.BackGround.Direction = gdVertical
      object Button2: TButton
        Left = 340
        Top = 109
        Width = 131
        Height = 78
        Caption = 'Button2'
        TabOrder = 0
        Visible = False
        OnClick = Button2Click
      end
    end
  end
  object SD: TSaveDialog
    DefaultExt = '*.csv'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 435
    Top = 315
  end
  object connService: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=NOM;Data Source=SVBYMINSD10;Use Procedu' +
      're for Prepare=1;Auto Translate=True;Packet Size=4096;Workstatio' +
      'n ID=DOYNIKOV;Use Encryption for Data=False;Tag with column coll' +
      'ation when possible=False'
    CursorLocation = clUseServer
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 545
    Top = 255
  end
  object msQuery: TADOQuery
    Connection = Connection
    CursorLocation = clUseServer
    CursorType = ctOpenForwardOnly
    Parameters = <>
    Left = 545
    Top = 315
  end
  object Command: TADOCommand
    Connection = Connection
    Parameters = <>
    Left = 100
    Top = 340
  end
  object Connection: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=Shate-M;Data Source=svbyminssq1;Use Pro' +
      'cedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workst' +
      'ation ID=SPBYPRIW0140;Use Encryption for Data=False;Tag with col' +
      'umn collation when possible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 160
    Top = 296
  end
  object QueryReport: TADOQuery
    Connection = Connection
    CursorType = ctStatic
    Parameters = <>
    Left = 215
    Top = 335
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 437
    Top = 269
  end
  object PageStyler: TAdvOfficePagerOfficeStyler
    Style = psCustom
    PageAppearance.BorderColor = clBlack
    PageAppearance.Color = clWhite
    PageAppearance.ColorTo = clBtnFace
    PageAppearance.ColorMirror = clBtnFace
    PageAppearance.ColorMirrorTo = clBtnFace
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    TabAppearance.BorderColor = 10670559
    TabAppearance.BorderColorHot = 3251427
    TabAppearance.BorderColorSelected = clBlack
    TabAppearance.BorderColorSelectedHot = 4227327
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clWhite
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = 5951226
    TabAppearance.ColorSelectedTo = 10543868
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clWhite
    TabAppearance.ColorHot = 5946106
    TabAppearance.ColorHotTo = 12779261
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 12779261
    TabAppearance.ColorMirrorHotTo = clWhite
    TabAppearance.ColorMirrorSelected = 10543868
    TabAppearance.ColorMirrorSelectedTo = clWhite
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clWhite
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Tahoma'
    TabAppearance.Font.Style = [fsBold]
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggVertical
    TabAppearance.GradientMirrorHot = ggVertical
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = clBlack
    TabAppearance.TextColorHot = clBlack
    TabAppearance.TextColorSelected = clBlack
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.BackGround.Color = clBtnFace
    TabAppearance.BackGround.ColorTo = clBtnFace
    TabAppearance.BackGround.Direction = gdVertical
    GlowButtonAppearance.BorderColor = 12179676
    GlowButtonAppearance.BorderColorHot = clHighlight
    GlowButtonAppearance.BorderColorDown = clHighlight
    GlowButtonAppearance.BorderColorChecked = clBlack
    GlowButtonAppearance.Color = 15653832
    GlowButtonAppearance.ColorTo = 12179676
    GlowButtonAppearance.ColorChecked = 12179676
    GlowButtonAppearance.ColorCheckedTo = 12179676
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 11899524
    GlowButtonAppearance.ColorDownTo = 11899524
    GlowButtonAppearance.ColorHot = 15717318
    GlowButtonAppearance.ColorHotTo = 15717318
    GlowButtonAppearance.ColorMirror = 12179676
    GlowButtonAppearance.ColorMirrorTo = 12179676
    GlowButtonAppearance.ColorMirrorHot = 15717318
    GlowButtonAppearance.ColorMirrorHotTo = 15717318
    GlowButtonAppearance.ColorMirrorDown = 11899524
    GlowButtonAppearance.ColorMirrorDownTo = 11899524
    GlowButtonAppearance.ColorMirrorChecked = 12179676
    GlowButtonAppearance.ColorMirrorCheckedTo = 12179676
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    Left = 305
    Top = 270
  end
  object OpenFile: TOpenDialog
    Left = 520
    Top = 55
  end
  object Database: TDBISAMDatabase
    EngineVersion = '4.25 Build 5'
    DatabaseName = 'DATA'
    Directory = 'E:\Project\service\ServiceAutoUpdate_NAV\_out\'#1044#1072#1085#1085#1099#1077
    KeepTablesOpen = False
    SessionName = 'Default'
    Left = 176
    Top = 138
  end
  object UpdateTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    TableName = '007'
    Left = 80
    Top = 150
  end
  object memImportDiscount: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    TableName = 'DiscountTable'
    Left = 125
    Top = 240
    object memImportDiscountDISCOUNT: TCurrencyField
      FieldName = 'DISCOUNT'
    end
    object memImportDiscountGROUP: TIntegerField
      FieldName = 'GROUP'
    end
    object memImportDiscountSUBGROUP: TIntegerField
      FieldName = 'SUBGROUP'
    end
    object memImportDiscountBRAND: TIntegerField
      FieldName = 'BRAND'
    end
    object memImportDiscountFIX: TIntegerField
      FieldName = 'FIX'
    end
  end
end
