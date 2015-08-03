object CulumnView: TCulumnView
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1090#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1082#1086#1083#1086#1085#1086#1082
  ClientHeight = 201
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 154
    Width = 280
    Height = 11
    Shape = bsBottomLine
  end
  object DBCheckBox1: TDBCheckBox
    Left = 16
    Top = 16
    Width = 73
    Height = 17
    Caption = #1050#1086#1076
    DataField = 'Code'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 0
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox2: TDBCheckBox
    Left = 16
    Top = 39
    Width = 73
    Height = 17
    Caption = #1041#1088#1077#1085#1076
    DataField = 'BrandDescrView'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 1
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox3: TDBCheckBox
    Left = 16
    Top = 62
    Width = 97
    Height = 17
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    DataField = 'Name_Descr'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox4: TDBCheckBox
    Left = 16
    Top = 85
    Width = 97
    Height = 17
    Caption = #1053#1086#1074#1080#1085#1082#1080
    DataField = 'New'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 3
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox5: TDBCheckBox
    Left = 16
    Top = 108
    Width = 97
    Height = 17
    Caption = #1047#1072#1082#1072#1079#1072#1085#1085#1086
    DataField = 'OrdQuantityStr'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 4
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox6: TDBCheckBox
    Left = 135
    Top = 16
    Width = 153
    Height = 17
    Caption = #1062#1077#1085#1072' '#1074' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1074#1072#1083#1102#1090#1077
    DataField = 'Price_koef'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 5
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox7: TDBCheckBox
    Left = 135
    Top = 39
    Width = 97
    Height = 17
    Caption = #1062#1077#1085#1072' '#1074' EUR'
    DataField = 'Price_koef_eur'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 6
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox8: TDBCheckBox
    Left = 135
    Top = 62
    Width = 97
    Height = 17
    Caption = #1062#1077#1085#1072' '#1074' BYR'
    DataField = 'Price_koef_rub'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 7
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox9: TDBCheckBox
    Left = 135
    Top = 85
    Width = 97
    Height = 17
    Caption = #1062#1077#1085#1072' '#1074' USD'
    DataField = 'Price_koef_usd'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 8
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox10: TDBCheckBox
    Left = 135
    Top = 108
    Width = 97
    Height = 17
    Caption = #1053#1072#1083#1080#1095#1080#1077
    DataField = 'Quantity'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 9
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object BitBtn1: TBitBtn
    Left = 94
    Top = 169
    Width = 113
    Height = 24
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 10
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object DBCheckBox13: TDBCheckBox
    Left = 135
    Top = 131
    Width = 113
    Height = 17
    Caption = #1042#1085#1077#1096#1085#1080#1077' '#1089#1082#1083#1072#1076#1099
    DataField = 'QuantNew'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 11
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox14: TDBCheckBox
    Left = 16
    Top = 131
    Width = 109
    Height = 17
    Caption = #1062#1077#1085#1072' '#1089' '#1085#1072#1094#1077#1085#1082#1086#1081
    DataField = 'Price_pro'
    DataSource = Data.ColumnViewDataSource
    TabOrder = 12
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
end
