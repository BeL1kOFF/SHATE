object TireCalcForm: TTireCalcForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1073#1086#1088' '#1096#1080#1085
  ClientHeight = 331
  ClientWidth = 509
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Pager: TAdvOfficePager
    Left = 0
    Top = 0
    Width = 509
    Height = 331
    Align = alClient
    ActivePage = SelectionTiresPage
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
    TabOrder = 0
    NextPictureChanged = False
    PrevPictureChanged = False
    object CalcPage: TAdvOfficePage
      Left = 1
      Top = 26
      Width = 507
      Height = 303
      Caption = #1064#1080#1085#1085#1099#1081' '#1082#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088
      PageAppearance.BorderColor = 14922381
      PageAppearance.Color = 16445929
      PageAppearance.ColorTo = 15587527
      PageAppearance.ColorMirror = 15587527
      PageAppearance.ColorMirrorTo = 16773863
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 15383705
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 16709360
      TabAppearance.ColorSelectedTo = 16445929
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 14542308
      TabAppearance.ColorHotTo = 16768709
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 14016477
      TabAppearance.ColorMirrorHotTo = 10736609
      TabAppearance.ColorMirrorSelected = 16445929
      TabAppearance.ColorMirrorSelectedTo = 16181984
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggVertical
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = 9126421
      TabAppearance.TextColorHot = 9126421
      TabAppearance.TextColorSelected = 9126421
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.BackGround.Color = 16767935
      TabAppearance.BackGround.ColorTo = clNone
      TabAppearance.BackGround.Direction = gdHorizontal
      object lbFindNew: TLabel
        Left = 263
        Top = 40
        Width = 89
        Height = 13
        Cursor = crHandPoint
        Caption = #1085#1072#1081#1090#1080' '#1074' '#1082#1072#1090#1072#1083#1086#1075#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lbFindNewClick
      end
      object lbFindOld: TLabel
        Left = 263
        Top = 16
        Width = 89
        Height = 13
        Cursor = crHandPoint
        Caption = #1085#1072#1081#1090#1080' '#1074' '#1082#1072#1090#1072#1083#1086#1075#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lbFindOldClick
      end
      object Panel1: TPanel
        Left = 5
        Top = 8
        Width = 257
        Height = 55
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object Label1: TLabel
          Left = 1
          Top = 8
          Width = 88
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1057#1090#1072#1088#1099#1081' '#1088#1072#1079#1084#1077#1088':'
        end
        object Label2: TLabel
          Left = 1
          Top = 32
          Width = 88
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1053#1086#1074#1099#1081' '#1088#1072#1079#1084#1077#1088':'
        end
        object Label3: TLabel
          Left = 141
          Top = 8
          Width = 4
          Height = 13
          Caption = '/'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 141
          Top = 32
          Width = 4
          Height = 13
          Caption = '/'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 199
          Top = 8
          Width = 7
          Height = 13
          Caption = 'R'
        end
        object Label6: TLabel
          Left = 199
          Top = 32
          Width = 7
          Height = 13
          Caption = 'R'
        end
        object cbOldW: TComboBox
          Left = 92
          Top = 5
          Width = 46
          Height = 21
          Style = csDropDownList
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          OnKeyDown = cbOldWKeyDown
          Items.Strings = (
            '145'
            '155'
            '165'
            '175'
            '185'
            '195'
            '205'
            '215'
            '225'
            '235'
            '245'
            '255'
            '265'
            '275'
            '285'
            '295'
            '305'
            '315'
            '325')
        end
        object cbOldH: TComboBox
          Left = 147
          Top = 5
          Width = 46
          Height = 21
          Style = csDropDownList
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 1
          OnKeyDown = cbOldWKeyDown
          Items.Strings = (
            '30'
            '35'
            '40'
            '45'
            '50'
            '55'
            '60'
            '65'
            '70'
            '75'
            '80'
            '85')
        end
        object cbOldR: TComboBox
          Left = 207
          Top = 5
          Width = 46
          Height = 21
          Style = csDropDownList
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 2
          OnKeyDown = cbOldWKeyDown
          Items.Strings = (
            '12'
            '13'
            '14'
            '15'
            '16'
            '17'
            '18'
            '19'
            '20'
            '21'
            '22'
            '23'
            '24')
        end
        object cbNewW: TComboBox
          Left = 92
          Top = 29
          Width = 46
          Height = 21
          Style = csDropDownList
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 3
          OnKeyDown = cbOldWKeyDown
          Items.Strings = (
            '145'
            '155'
            '165'
            '175'
            '185'
            '195'
            '205'
            '215'
            '225'
            '235'
            '245'
            '255'
            '265'
            '275'
            '285'
            '295'
            '305'
            '315'
            '325')
        end
        object cbNewH: TComboBox
          Left = 147
          Top = 29
          Width = 46
          Height = 21
          Style = csDropDownList
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 4
          OnKeyDown = cbOldWKeyDown
          Items.Strings = (
            '30'
            '35'
            '40'
            '45'
            '50'
            '55'
            '60'
            '65'
            '70'
            '75'
            '80'
            '85')
        end
        object cbNewR: TComboBox
          Left = 207
          Top = 29
          Width = 46
          Height = 21
          Style = csDropDownList
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 5
          OnKeyDown = cbOldWKeyDown
          Items.Strings = (
            '12'
            '13'
            '14'
            '15'
            '16'
            '17'
            '18'
            '19'
            '20'
            '21'
            '22'
            '23'
            '24')
        end
      end
      object Panel2: TPanel
        Left = 1
        Top = 64
        Width = 505
        Height = 232
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object JvLabel1: TJvLabel
          Left = 10
          Top = 10
          Width = 152
          Height = 22
          AutoSize = False
          Caption = '  '#1056#1072#1079#1084#1077#1088
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel2: TJvLabel
          Left = 161
          Top = 10
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = #1057#1090#1072#1088#1099#1081
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel3: TJvLabel
          Left = 220
          Top = 10
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = #1053#1086#1074#1099#1081
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel4: TJvLabel
          Left = 279
          Top = 10
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = #1056#1072#1079#1085#1080#1094#1072
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel5: TJvLabel
          Left = 10
          Top = 31
          Width = 152
          Height = 22
          AutoSize = False
          Caption = '  '#1064#1080#1088#1080#1085#1072' '#1096#1080#1085#1099', '#1084#1084' (A)'
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel6: TJvLabel
          Left = 10
          Top = 52
          Width = 152
          Height = 22
          AutoSize = False
          Caption = '  '#1042#1099#1089#1086#1090#1072' '#1087#1088#1086#1092#1080#1083#1103', '#1084#1084' (B)'
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel7: TJvLabel
          Left = 10
          Top = 73
          Width = 152
          Height = 22
          AutoSize = False
          Caption = '  '#1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1076#1080#1072#1084#1077#1090#1088', '#1084#1084' (C)'
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel8: TJvLabel
          Left = 10
          Top = 94
          Width = 152
          Height = 22
          AutoSize = False
          Caption = '  '#1042#1085#1077#1096#1085#1080#1081' '#1076#1080#1072#1084#1077#1090#1088', '#1084#1084' (D)'
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel9: TJvLabel
          Left = 10
          Top = 115
          Width = 329
          Height = 23
          AutoSize = False
          Caption = '  '#1057#1087#1080#1076#1086#1084#1077#1090#1088
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel10: TJvLabel
          Left = 10
          Top = 137
          Width = 270
          Height = 22
          AutoSize = False
          Caption = '  '#1055#1086#1082#1072#1079#1072#1085#1080#1103' '#1089#1087#1080#1076#1086#1084#1077#1090#1088#1072' ('#1082#1084'/'#1095')'
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel11: TJvLabel
          Left = 10
          Top = 158
          Width = 270
          Height = 22
          AutoSize = False
          Caption = '  '#1056#1077#1072#1083#1100#1085#1072#1103' '#1089#1082#1086#1088#1086#1089#1090#1100' ('#1082#1084'/'#1095')'
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel12: TJvLabel
          Left = 10
          Top = 179
          Width = 270
          Height = 22
          AutoSize = False
          Caption = '  '#1056#1072#1079#1085#1080#1094#1072' ('#1082#1084'/'#1095')'
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object JvLabel13: TJvLabel
          Left = 10
          Top = 200
          Width = 270
          Height = 22
          AutoSize = False
          Caption = '  '#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1082#1083#1080#1088#1077#1085#1089#1072' ('#1084#1084')'
          Color = clWhite
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object newA: TJvLabel
          Left = 220
          Top = 31
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object difA: TJvLabel
          Left = 279
          Top = 31
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          HotTrack = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clBlue
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = [fsBold]
        end
        object oldB: TJvLabel
          Left = 161
          Top = 52
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object newB: TJvLabel
          Left = 220
          Top = 52
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object oldA: TJvLabel
          Left = 161
          Top = 31
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object oldC: TJvLabel
          Left = 161
          Top = 73
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object difB: TJvLabel
          Left = 279
          Top = 52
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          HotTrack = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clBlue
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = [fsBold]
        end
        object newC: TJvLabel
          Left = 220
          Top = 73
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object difC: TJvLabel
          Left = 279
          Top = 73
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          HotTrack = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clBlue
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = [fsBold]
        end
        object oldD: TJvLabel
          Left = 161
          Top = 94
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object newD: TJvLabel
          Left = 220
          Top = 94
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Layout = tlCenter
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object difD: TJvLabel
          Left = 279
          Top = 94
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          HotTrack = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clBlue
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = [fsBold]
        end
        object JvLabel26: TJvLabel
          Left = 279
          Top = 137
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FocusControl = oldSpeed
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          OnClick = JvLabel26Click
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object newSpeed: TJvLabel
          Left = 279
          Top = 158
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          HotTrack = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clBlue
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = [fsBold]
        end
        object difSpeed: TJvLabel
          Left = 279
          Top = 179
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          HotTrack = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clBlue
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = [fsBold]
        end
        object difClearense: TJvLabel
          Left = 279
          Top = 200
          Width = 60
          Height = 22
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          FrameColor = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          HotTrack = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clBlue
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = [fsBold]
        end
        object Image1: TImage
          Left = 358
          Top = 13
          Width = 138
          Height = 204
          AutoSize = True
          Picture.Data = {
            0A544A504547496D616765D1120000FFD8FFE000104A46494600010100000100
            010000FFDB008400090606130F10141213141615121218151714151814181714
            1517171C1B1C1718141A171C271E1A1D231E17151F2F202727292E2E2C171F32
            35322A38282B2C2D01090A0A0D0C0C140C0F14291C1418292C29292929292C2C
            29292929292C2929292929292929292929292929292929292929292929292929
            292929292929292929FFC000110800CC008A03012200021101031101FFC4001B
            00000203010101000000000000000000000405000106070302FFC40046100001
            020303050A0A0A0202030000000001020300041105122106313473B213162233
            4151616493B107324244717274B3D1D21415235275819192C2C353A162822443
            F0FFC40014010100000000000000000000000000000000FFC400141101000000
            00000000000000000000000000FFDA000C03010002110311003F00E916759CA9
            A5CC2D731309BAFBA84A50EDD42529A5000041DBD7EB537DB9F84564BF9D7B53
            FDE21E4024DEBF5A9BEDCFC226F5FAD4DF6E7E10EE24024DEBF5A9BEDCFC226F
            5FAD4DF6E7E10D271E28482295BC818F3296949FF44C7BC024DEBF5A9BEDCFC2
            26F5FAD4DF6E7E10EE24024DEBF5A9BEDCFC226F5FAD4DF6E7E1074D5B4CB4F3
            2C2D612ECC5FDC918D57705554A0A6039E0D8049BD7EB537DB9F844DEBF5A9BE
            DCFC21DC48049BD7EB537DB9F844DEBF5A9BEDCFC21A3AF10E2138514155E7C2
            94A7EB1EF00937AFD6A6FB73F089BD7EB537DB9F843B89019BB4B278B6CBAB4C
            D4DDE4216A1F6FCA1248E48716438572ECAD58A94DB6A51E7252093156DE8CFE
            A9CD931560E8AC6A9AD91000E4BF9D7B53FDE21E423C97F3AF6A7FBC43C80912
            244800ED54D5BA73ADAF4F188CDD302A326D01C0E05BB517B3B84F8D42684E29
            186619FF00282ED2F107AED7BC44170027D5C3EFB9DA2BE313EAE1F7DCED15F1
            82E24073AB7F2667669E9B9A4DD42DA536255B53416B704AD1E694DAC3A94A6F
            BAA58A2D2AA7A2370DCB171295AB74429494952038689240AA70C30CD58968CC
            A90A602732DDBAAE94DC59E6E748836004FAB87DF73B457C63C672C44BA8282B
            72869E593988230554724318900A65ECD4B0EB612A5A810E78EB2BA609CD7B1E
            486D023FC735E873F8C17012244890015B7A33FAA7364C5583A2B1AA6B6445DB
            7A33FAA7364C5583A2B1AA6B64400392FE75ED4FF78876B4D410731C21264BF9
            D7B53FDE21E4067ED165287D94252ABAA26FD375231C138834CF5279A809A086
            9F54B7CC7F7AFE31737C6B3EB2F60C1700AAD0B31B08181F1DA1E328E75A473C
            099453D2967B05E7C909AD1290A515AD59C2502F6270FF0058C35B4CF007AED7
            BC4473FB22C84E504D393B3355C8B2A53526CD780BBB82DC55338247E798E090
            08675DF09B3334B22464AA94E0707E6178D68541A52528CC7024E68F5766EDD7
            90DA5B9579A7125C2B5D1B425614416C00B5129BA2F0E5AD454D63B1CACA21A4
            843684A103325290948E5C00C047AC07176136FB61616D2D45C494B64BCC24A1
            CADEBC918DF344AB83D35E4C3C8B39449E1143AA008A80583515CD4AC75CB55C
            A2E5F049ABC0639C7D9B86A9C463874E04E10C6038ACE6565ACC2D6A54828337
            94A485B0F28A1BA9A254E30E018014BC41E7358D0E45784494B41C4B0E36597D
            5E2FDAA96D38463442AA083415A103A2B1D2632D95BE0F65AD0428DC0DCC6743
            E8175615C854478C2A067FCA8718066FD98DEEAD8A1A10BAF095C94E9E982BEA
            96F98FEF5FC633590D6FB936DB697C11332CA7589807956809E17FD863E9AC6C
            6011DBB2896985290955FCC9A170D39CF04E14178D79C0F44172F66B6B425452
            A0540120A9C0412311426A23DAD4C595A7CA525400A8049A7254C14950230C44
            0056D0A4ABDAA7364C4B07456354D6C88BB6F467F54E6C98AB07456354D6C880
            0725FCEBDA9FEF10F211E4BF9D7B53FDE21E400935C6B3EB2F60C17024D71ACF
            ACBD8305C0036E4BADC97712D9A2CA7826B4C410463F9422F058B41B2256E530
            410AA7DF0A37EBD35AD63571CBAD29C7B27269D74365DB326977CA41A298755E
            35DAE02A73034040A541188751890B6C1CA1627D90F30B0A49C08CCA41E54AD2
            7149FF00EC619402EB55355CBE2051E19D4057ECDCC054F08F40A9CE79218C2F
            B51CA2E5F3709E03100FFEB70E15CC70CE218404891239E654F850FB43276720
            CC4DAEA80B4E2DB6AC7149A1BE539CF92394E71004E4A36176C5A6B6C8DCD2B6
            8280E57373A2BF3042EBE98DD421C8AC981674A25A2ABEEAC971F5D6B7DD5F8C
            457905001D02A71261F40734F09CC32A9E942F96D2D8626384EC9AE6D17AFB34
            171188245EA2AB850F3C38F056D84CA3B75346FE92F96D41B5B4DAD1C1A29A69
            7C5A6B517461549E52634D6CCC86D8592ABA482126B437883400F3C14CBA1690
            A49052A15041A820E620C00B6DE8CFEA9CD931560E8AC6A9AD91176DE8CFEA9C
            D931560E8AC6A9AD91000E4BF9D7B53FDE21E423C97F3AF6A7FBC43C80126B8D
            67D65EC182E049BE359F597B060B80919ECA494DDDE65AE453530403E295008B
            97C665004E6208E88D0C289FD365F5733FD501CD725B275F92B43E992E02645C
            0A25B4870AB7352494B6414DDE02A9455E2280D0E31D391942C915BC71AF924E
            6E94D41FD7FDC7C64A6852FAB4C3154AA09A94A49E72904FEB009A7AD569D5B2
            52AC1B72FA894AC009085838D29E5038E0054F243C5AC0049CC313F9426B7241
            B3B8B771002DD02A129BC9210B50520F22814A4838E6E6AC09654A3AEB5783CB
            42429C40424E0036B29E0D4120512682A6986269009F2E2D972764F7093252E3
            EA4A6AA2117DB22F10820935229D39C670A013644E4F2A41A42EEDD7CBEDB6F1
            4DDA9AAB890A22B72E6E6AC295538AA9C001AAB1727439288505D03EDA0B8828
            0A6CF28A57ED134CE28BCF551AA94A510E49A7529097177EECEB092A2384A5A6
            814AA8F24A773001AAAA9512A55700D77D317FE15FEADFCD13E98BFF000AFF00
            56FE782C44804B6EBE552EE05B6B42695BC54DD30208AF0B9C01CFCD063534A0
            90034B200001BCDE34FF00B479E50CB6E92EB17AE802F1CD8DDC4035CD8806BD
            106CB3571094D6B74015A015A72D0610035B47FF0015ED539B262583A2B1AA6B
            6445DB7A33FAA7364C5583A2B1AA6B64400392FE75ED4FF7887908F25FCEBDA9
            FEF10F20049AE359F597B060B8126B8D67D65EC182E024289FD365F5733FD50D
            E144FE9B2FAB99FEA80BC94D0A5F56986D0A72534297D5A61B402FB51BAAE5F1
            48BAF038AA84FD9B8289FBC71AD39813C903E4DE8C75931EF57045A8E5172F80
            35780C535A7D9B86A9E63867E93CF03E4DE8C75931EF5701F792FA14BEA91DD0
            995E57E228FE10E725F4297D523BA132BCAFC451FC2035C2244112004B5B8877
            D4577417025ADC43BEA2BBA0B800ADBD19FD539B262AC1D158D535B222EDBD19
            FD539B262AC1D158D535B22001C97F3AF6A7FBC43C84792FE75ED4FF00788790
            024D71ACFACBD8305C666DACB39297994B4EBD71C6882B05B74A5216921254B4
            A0A1231A924800035CD1A365E4AD2169214950052A06A0822A083CA0880FB851
            3FA6CBEAE67FAA1BC289FD365F5733FD5017929A14BEAD30DA14E4A6852FAB4C
            36805F6A3254B97229C178135201A6E6E0E0D46271180E9E681F26F463AC98F7
            AB822D5580B97E0A5557800549A94FD9B9C24732B0A57989E781F26F463AC98F
            7AB80FBC97D0A5F548EE84CAF2BF1147F087392FA14BEA91DD0995E57E228FE1
            01AE11220890025ADC43BEA2BBA0B85194F6CB12CC2B767437BA029460A52944
            8CC94A0152A99CD01A004E61055916C3338D25E61C4B8DAAB450E719C281C524
            7282011012DBD19FD539B262AC1D158D535B222EDBD19FD539B262AC1D158D53
            5B22001C97F3AF6A7FBC43C84792FE75ED4FF788790189984CE4BDA336B6A4F7
            76E6D32C942CBECB6D82DA5615BA0528ACA7878D124D01A031A0C94B1D525252
            F2EA55E532DA52A23313CB4E8AD60B9B1F6ACFACBD8305C0484F3FA6CB6AE67F
            AA1C4289FD365F5733FD50179263FF000A5F56986D0A72534297D5A61B402FB4
            D952972E40144BC14AC40A0DCDC18573E2461F081F26F463AC98F7AB8F7B5540
            2E5EA949ABC284E749DCDCC5388C738E5C09C23C326F463AC98F7AB80FBC97D0
            A5F548EE84AB1E37E248FE10EB25F4297D523BA132BCAFC451FC2035C2244112
            033594926FB732CCEB2D07F716DE6D6CEE896D443A5B216DA97C0A8B98D4A782
            55424E05864DA1D0C5E799698716B5ACB4D90426F1A8DD08C14E7DE22A2B9898
            2AD7E21DF515DD05C0056DE8CFEA9CD931560E8AC6A9AD91176DE8CFEA9CD931
            560E8AC6A9AD91000E4BF9D7B53FDE21E423C97F3AF6A7FBC43C80126F8D67D6
            5EC182E049AE359F597B060B8090A27F4D97D5CCFF0054378513FA6CBEAE67FA
            A02F2534297D5A61B429C94D0A5F56986D0005A6C294B6081825D0A5634A0B8E
            0FCF12206C9BD18EB263DEAE3DED522FCBD5215F6C286A45D3B9B9C21438E151
            438631E1937A31D64C7BD5C07DE4BE852FAA4774265795F88A3F8439C97D0A5F
            548EE84CAF2BF1147F080D708910448012D6E21DF515DD05C096B710EFA8AEE8
            2E002B6F467F54E6C98AB07456354D6C88BB6F467F54E6C98AB07456354D6C88
            00725FCEBDA9FEF10F211E4BF9D7B53FDE21E400937C6B3EB2F60C17024D71AC
            FACBD8305C048513FA6CBEAE67FAA1BC27B45404E4B93800D4C9279071701F59
            29A14BEAD30DA31F61E5632CB2CCB2B8F4B69FB3DD19DD3357C42E058C31C403
            0D9BB46694010C000FE6393EF942B9FC81F9F28156A3254B97205425E0A5740D
            CDC15FD48FD606C9BD18EB263DEAE01B594FBBB9A14808515F01550920DD5037
            55BA7055754AE100A200510926E8839AC986C006F2AF67253448BDCE0530E5E5
            FD603D725F4297D523BA12ABCAFC451FC22FEBA4D9492898E0B0154697790100
            1CC1254A181C78385D21400BB7090656D66DE6C3885552E4EB6F248A1AB64817
            814920E2858CF9D260376224082D46F9CFEC57C227D6ADF39FD8AF8404B5B887
            7D4577417092DE984BCC2D282ABFC940E0AF38C063504FE7482E5AD06D084A6F
            1340056EACD6839C8A9F4980FBB6F467F54E6C98AB07456354D6C8896D1ACABD
            AA7364C4B07456354D6C8800725FCEBDA9FEF10F211E4BF9D7B53FDE21E40093
            7C6B3EB2F60C17024D71ACFACBD8305C048E7FE13B295B95534845F726D495A5
            0CA33290ED01DD282F50DCC0278468730A91BC7DE084A96A344A41513CC00A93
            187F06B628792AB55F17A6A70A948271DC59382108E6C00A9E6A0E43505BE0FB
            C1FBE268DA53D83EA2A5A1AA004296082B5D3049A1202466071C63A7448900B2
            D8F1E5B5E3DDBB0CE01B4470D8F178D14BCB292380E788078CAFF89E4A9E483A
            012E57E4CA6D2945CBA95749A290BA56EAD3E2923947211CC4E68E5364CCBD61
            BEDCB5A0DABE8C1D0B6DF6CA8A4281AE0732D15E11410142AA206263B840B6A5
            96D4D34B65E405B6B145248FD08E5046704620804407BB2E85A4292414A80208
            35041CC418FB8C4F8365392E66ACE71457F417006944F08B2E0BC814E8FF0057
            A828008DB4048912240056DE8CFEA9CD931560E8AC6A9AD91176DE8CFEA9CD93
            1560E8AC6A9AD91000E4BF9D7B53FDE21E423C97F3AF6A7FBC43C80126B8C67D
            656C182E155A53F7261845C51BC4D08BB4C4149CE6B85413D1CF9A1AC0784ECA
            875A5B673389524FA14083DF193F05568DE9012CBA25F9252987518D45D26E9C
            738239731A1E68D9C73DCB7C9A99967CDA766D77722932C81783A903C608F294
            282A339A54622843A1448E55657876452ECCCB38971381DC8A543A6A971495A7
            D1C2F4C3D63C3259AA342E3A8E9530E01FA806034D6BF8F2DAF1EEDD8651859C
            F0A7662D4D1DD81B8E5EC50EA4A780B17922E708E34A7FCBA23DDCF0BD66015D
            DD4736019749D980D9C5295415E411CF66BC3848A4701B9873D0DA5007A7755A
            6103594B686512CCBB09FA349AB079D4D566E72A4B868144E6BA91CB8E1580D5
            783D74CD4CDA13E07D94C3A96D95622FA19176F00790E18F3831B8816CBB3512
            ACB6C3628DB490948E81CFD2739F4C15012244890015B7A33FAA7364C5583A2B
            1AA6B6445DB7A33FAA7364C5583A2B1AA6B64400392FE75ED4FF0078874B1504
            034246070C3A7184AAC964DE5AD0FCC37BA28AD4943B445E5672010695A45EF5
            FAD4DF6C3E58021CB214A52545E515209293B9B585450F931EBF4273FCEAFD8D
            FCB016F5FAD4DF6C3E589BD7EB537DB0F9600DFA139FE757EC6FE589F4273FCE
            AFD8DFCB016F5FAD4DF6C3E589BD7EB537DB0F9603CED0C8F6664D5E0874F3AE
            5D852A9D04A2A3F585939E0B24DE421B20A50D159425012900B942BCC31A94A4
            F453086FBD7EB537DB0F9626F5FAD4DF6C3E580CD2BC17C9CB94A5295A933277
            170151C1142E552522A9379A463510535E07ECD4A81DC966841A179C20D39F85
            9A1DEF5FAD4DF6C3E589BD7EB537DB0F9603E4643C86E8A74CAB2A716A2B5294
            80B254A3527875A63CD0E9B6C2404A40006600500F40109F7AFD6A6FB61F2C4D
            EBF5A9BED87CB00EE2424DEBF5A9BED87CB137AFD6A6FB61F2C03B890937AFD6
            A6FB61F2C4DEBF5A9BED87CB0075B7A33FAA7364C5583A2B1AA6B6442F7724C2
            D252A9A9B2950208DDB383811E2C35976C3684A13E2A004A7D09141DD01FFFD9}
        end
        object oldSpeed: TEdit
          Left = 293
          Top = 140
          Width = 32
          Height = 16
          AutoSize = False
          BorderStyle = bsNone
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = '90'
          OnKeyPress = oldSpeedKeyPress
        end
      end
      object btCalc: TButton
        Left = 363
        Top = 17
        Width = 128
        Height = 38
        Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100
        TabOrder = 2
        OnClick = btCalcClick
      end
    end
    object SelectionTiresPage: TAdvOfficePage
      Left = 1
      Top = 26
      Width = 507
      Height = 303
      Caption = #1055#1086#1076#1073#1086#1088' '#1096#1080#1085' '#1087#1086' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1102
      PageAppearance.BorderColor = 14922381
      PageAppearance.Color = 16445929
      PageAppearance.ColorTo = 15587527
      PageAppearance.ColorMirror = 15587527
      PageAppearance.ColorMirrorTo = 16773863
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 15383705
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 16709360
      TabAppearance.ColorSelectedTo = 16445929
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 14542308
      TabAppearance.ColorHotTo = 16768709
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 14016477
      TabAppearance.ColorMirrorHotTo = 10736609
      TabAppearance.ColorMirrorSelected = 16445929
      TabAppearance.ColorMirrorSelectedTo = 16181984
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggVertical
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = 9126421
      TabAppearance.TextColorHot = 9126421
      TabAppearance.TextColorSelected = 9126421
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.BackGround.Color = 16767935
      TabAppearance.BackGround.ColorTo = clNone
      TabAppearance.BackGround.Direction = gdHorizontal
      object lbMark: TLabel
        Left = 6
        Top = 13
        Width = 32
        Height = 13
        Caption = #1052#1072#1088#1082#1072
      end
      object lbModel: TLabel
        Left = 6
        Top = 47
        Width = 39
        Height = 13
        Caption = #1052#1086#1076#1077#1083#1100
      end
      object lbEngine: TLabel
        Left = 6
        Top = 81
        Width = 55
        Height = 13
        Caption = #1044#1074#1080#1075#1072#1090#1077#1083#1100
      end
      object lbSearch: TLabel
        Left = 6
        Top = 115
        Width = 111
        Height = 14
        Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1087#1086#1080#1089#1082#1072':'
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lbTires_1: TLabel
        Left = 6
        Top = 139
        Width = 152
        Height = 16
        Caption = #1047#1072#1074#1086#1076#1089#1082#1072#1103' '#1082#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object lbTires_2: TLabel
        Left = 208
        Top = 139
        Width = 110
        Height = 16
        Caption = #1042#1072#1088#1080#1072#1085#1090#1099' '#1079#1072#1084#1077#1085#1099':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object MarksComboBox: TDBLookupComboboxEh
        Left = 67
        Top = 10
        Width = 324
        Height = 21
        EditButtons = <>
        KeyField = 'mark_id'
        ListField = 'mark'
        ListSource = Data.DS_TiresCarMake
        TabOrder = 0
        Visible = True
        OnChange = MarksComboBoxChange
        OnDropDown = MarksComboBoxDropDown
        OnKeyDown = MarksComboBoxKeyDown
      end
      object ModelComboBox: TDBLookupComboboxEh
        Left = 67
        Top = 44
        Width = 324
        Height = 21
        Enabled = False
        EditButtons = <>
        KeyField = 'model_id'
        ListField = 'model'
        ListSource = Data.DS_TiresCarModel
        TabOrder = 1
        Visible = True
        OnChange = ModelComboBoxChange
        OnDropDown = ModelComboBoxDropDown
        OnKeyDown = ModelComboBoxKeyDown
      end
      object engineComboBox: TDBLookupComboboxEh
        Left = 67
        Top = 78
        Width = 324
        Height = 21
        Enabled = False
        EditButtons = <>
        KeyField = 'engine_id'
        ListField = 'Engine'
        ListSource = Data.DS_TiresCarEngine
        TabOrder = 2
        Visible = True
        OnChange = engineComboBoxChange
        OnDropDown = engineComboBoxDropDown
        OnKeyDown = engineComboBoxKeyDown
      end
    end
  end
end
