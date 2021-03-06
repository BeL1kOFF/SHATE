object FormReleaseInfo: TFormReleaseInfo
  Left = 246
  Top = 184
  BorderStyle = bsDialog
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1073#1086#1088#1082#1077
  ClientHeight = 196
  ClientWidth = 249
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
  DesignSize = (
    249
    196)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 46
    Width = 100
    Height = 13
    AutoSize = False
    Caption = #1042#1077#1088#1089#1080#1103' '#1076#1072#1085#1085#1099#1093':'
  end
  object Label2: TLabel
    Left = 8
    Top = 70
    Width = 100
    Height = 13
    AutoSize = False
    Caption = #1053#1086#1084#1077#1088' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103':'
  end
  object Label3: TLabel
    Left = 8
    Top = 95
    Width = 65
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
  end
  object Label4: TLabel
    Left = 5
    Top = 10
    Width = 110
    Height = 13
    Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1072#1103' '#1089#1073#1086#1088#1082#1072
  end
  object DateTimePicker1: TDateTimePicker
    Left = 222
    Top = 48
    Width = 16
    Height = 15
    CalAlignment = dtaRight
    Date = 40815.535807592590000000
    Time = 40815.535807592590000000
    TabOrder = 6
    OnCloseUp = DateTimePicker1CloseUp
  end
  object edVersion: TEdit
    Left = 120
    Top = 43
    Width = 100
    Height = 21
    TabOrder = 0
  end
  object edDiscretVersion: TEdit
    Left = 120
    Top = 67
    Width = 51
    Height = 21
    TabOrder = 1
  end
  object btOK: TButton
    Left = 84
    Top = 164
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btOKClick
  end
  object btCancel: TButton
    Left = 165
    Top = 164
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object MemoNote: TMemo
    Left = 8
    Top = 110
    Width = 232
    Height = 46
    TabOrder = 4
  end
  object cbPrevRelease: TComboBox
    Left = 120
    Top = 6
    Width = 101
    Height = 22
    Hint = 'detg4e3t'
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ItemHeight = 14
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object btDatePick: TBitBtn
    Left = 221
    Top = 43
    Width = 21
    Height = 21
    TabOrder = 7
    OnClick = btDatePickClick
    Glyph.Data = {
      9E020000424D9E0200000000000036000000280000000E0000000E0000000100
      1800000000006802000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FF0000FF00FFFF00FF8080808080808080808080808080808080808080
      80808080808080808080FF00FFFF00FF0000FF00FF0000000000008000000000
      00800000800000000000800000000000000000800000FF00FFFF00FF0000FF00
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
      0000FF00FFFF00FF0000FF00FFFFFFFF000000000000000000FFFFFF00000000
      0000000000C0C0C0FFFFFF800000FF00FFFF00FF0000FF00FFFFFFFFFFFFFF00
      0000FFFFFFFFFFFFC0C0C0FFFFFFC0C0C0000000FFFFFF800000FF00FFFF00FF
      0000FF00FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
      FFFFFF800000FF00FFFF00FF0000FF00FFFFFFFFFFFFFF000000FFFFFFFFFFFF
      000000000000000000C0C0C0FFFFFF800000FF00FFFF00FF0000FF00FFFFFFFF
      000000000000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF800000FF00
      FFFF00FF0000FF00FFFFFFFFFFFFFF000000FFFFFFFFFFFF0000000000000000
      00000000FFFFFF800000FF00FFFF00FF0000FF00FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF800000FF00FFFF00FF0000FF00
      FFFFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FFFFFF80
      0000FF00FFFF00FF0000FF00FF00000000000000000000000000000000000000
      0000000000000000000000FF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      0000}
  end
  object btClearPrev: TBitBtn
    Left = 221
    Top = 6
    Width = 21
    Height = 22
    TabOrder = 8
    OnClick = btClearPrevClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      4949A8A7A7D0D9D9D9B1B1B1A8A8A8B4B4B49898B25151A2D3D3D4DADADAE2E2
      E2EBEBEBF4F4F4FF00FFFF00FF9696C8030392070D9D6764A9A2A29C82827E63
      636D1014910203922D2D858D8D8D9F9F9FC2C2C2E9E9E9FF00FFFF00FF5D5DB1
      0A0F9E0B13A81022B67B83C7CFD2DB303FBA0E1BAF060C9D50509EA3A4A29191
      90949494DBDBDBFF00FFFF00FFFF00FFCDCEE22F2A9E162DC41D3AD3132DC014
      2CC51325BC2D36AEEBECEFFCFCFBFEFEFE717171D6D6D6FF00FFFF00FFFF00FF
      FF00FFA5697D1F38C82447E22549E31D3BD43747C0DADCE4F9FAF6FCFCFBFEFE
      FE717171D6D6D6FF00FFFF00FFFF00FFCACBE21F25AC1A35CD2447E21336D214
      2DBD7576807F7F7EBCBCBAFEFEFEFEFEFE717171D6D6D6FF00FFFF00FFE1E1EA
      2028AB0E1BB1162DC4344ACB1E3AD11931C95560BEF1F2EDF9FAF6FCFCFBFEFE
      FE717171D6D6D6FF00FFFF00FF5D5DB1070C9D0B13A7434DAEE6E8E43D45930A
      1CB20713A823268EADADB4FEFEFEFEFEFE717171D6D6D6FF00FFFF00FF5B5BB0
      030392261B8FCDC5BCF1F3E8ECEEE64C52B2070C9E0303924445A7FCFCFBFEFE
      FE717171D6D6D6FF00FFFF00FFFF00FF6969B6955E7AD4CDBEF1F3E87F7F7E7E
      7E7E434382232394DEDFE8FCFCFBFEFEFE717171D6D6D6FF00FFFF00FFFF00FF
      FF00FFBF7878D5CEC0F1F3E8F1F3E8F1F3E8F3F5EBF6F7F0F9FAF6FCFCFBFEFE
      FE717171D6D6D6FF00FFFF00FFFF00FFFF00FFBF7878CFCCBAF1F3E8F1F3E8F1
      F3E8F3F5EBF6F7F0F9FAF6FCFCFBFEFEFE717171D6D6D6FF00FFFF00FFFF00FF
      FF00FFBF7878E1C5C3426985F1F3E8426985F3F5EB426985F9FAF6426985FEFE
      FE717171D7D7D7FF00FFFF00FFFF00FFFF00FFE3C9C9C07878C07878316B8F90
      A9BB6F798CD2B5B86F8FA8B9B3BD5D819CA3A3A3E1E1E1FF00FFFF00FFFF00FF
      FF00FFF8F8F84E9BBD4BBED3316B8F3D84A34BBED3637E934BBED36D6E835D81
      9CD6D6D6F0F0F0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFD8E5EBD6E3E9D4E1E7B5CFDBE2E8ECF4F4F4FF00FFFF00FF}
  end
end
