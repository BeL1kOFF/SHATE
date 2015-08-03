object Form1: TForm1
  Left = 239
  Top = 181
  Caption = #1043#1086#1090#1086#1074#1099#1077' '#1089#1073#1086#1088#1082#1080
  ClientHeight = 449
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 162
    Width = 521
    Height = 5
    Cursor = crVSplit
    Align = alTop
    Color = clGray
    ParentColor = False
    ExplicitTop = 115
    ExplicitWidth = 587
  end
  object Panel1: TPanel
    Left = 0
    Top = 167
    Width = 521
    Height = 282
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 171
    ExplicitHeight = 278
    DesignSize = (
      521
      282)
    object Label2: TLabel
      Left = 195
      Top = 26
      Width = 63
      Height = 13
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 185
      Top = 25
      Width = 11
      Height = 55
      Shape = bsLeftLine
    end
    object Bevel2: TBevel
      Left = 8
      Top = 89
      Width = 502
      Height = 12
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      ExplicitWidth = 535
    end
    object Label3: TLabel
      Left = 8
      Top = 102
      Width = 22
      Height = 13
      Caption = #1051#1086#1075':'
    end
    object Label4: TLabel
      Left = 2
      Top = 2
      Width = 517
      Height = 16
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1073#1086#1088#1082#1077
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 583
    end
    object lbStatusCatalog: TLabel
      Left = 81
      Top = 26
      Width = 75
      Height = 13
      Caption = #1085#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbStatusAnalog: TLabel
      Left = 81
      Top = 44
      Width = 75
      Height = 13
      Caption = #1085#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbStatusOE: TLabel
      Left = 81
      Top = 62
      Width = 75
      Height = 13
      Caption = #1085#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 15
      Top = 26
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1050#1072#1090#1072#1083#1086#1075':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 15
      Top = 44
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1040#1085#1072#1083#1086#1075#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 15
      Top = 62
      Width = 55
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1054#1045':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object MemoNote: TMemo
      Left = 264
      Top = 26
      Width = 246
      Height = 51
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Ctl3D = True
      ParentColor = True
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
    end
    object MemoLog: TMemo
      Left = 8
      Top = 115
      Width = 502
      Height = 157
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      ExplicitHeight = 153
    end
  end
  object Grid: TDBGridEh
    Left = 0
    Top = 0
    Width = 521
    Height = 136
    Align = alTop
    AllowedOperations = []
    AllowedSelections = [gstAll]
    AutoFitColWidths = True
    DataSource = DataSource1
    Flat = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghRowHighlight, dghDialogFind]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = GridDrawColumnCell
    OnGetCellParams = GridGetCellParams
    Columns = <
      item
        EditButtons = <>
        FieldName = 'VER_CALC'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Footers = <>
        Title.Caption = #1042#1077#1088#1089#1080#1103
        Width = 134
      end
      item
        EditButtons = <>
        FieldName = 'PARENT_VER'
        Footers = <>
        Title.Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1072#1103' '#1074#1077#1088#1089#1080#1103
        Width = 121
      end
      item
        EditButtons = <>
        FieldName = 'NOTE'
        Footers = <>
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 239
      end>
  end
  object pnActions: TPanel
    Left = 0
    Top = 136
    Width = 521
    Height = 26
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 2
    object btDelete: TButton
      Left = 3
      Top = 3
      Width = 73
      Height = 21
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 0
      OnClick = btDeleteClick
    end
    object btMoveToCurrent: TButton
      Left = 82
      Top = 3
      Width = 125
      Height = 21
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1090#1077#1082#1091#1097#1080#1077
      TabOrder = 1
      OnClick = btMoveToCurrentClick
    end
    object btMoveToTemp: TButton
      Left = 213
      Top = 3
      Width = 148
      Height = 21
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074#1086' '#1074#1088#1077#1084#1077#1085#1085#1099#1077
      TabOrder = 2
      Visible = False
    end
  end
  object qBUILDS: TADOQuery
    Connection = FormMain.connService
    CursorType = ctStatic
    AfterScroll = qBUILDSAfterScroll
    OnCalcFields = qBUILDSCalcFields
    Parameters = <>
    SQL.Strings = (
      
        'SELECT ID, VERSION, NUM, PARENT_VER, NOTE FROM BUILDS WHERE ISCU' +
        'R <> 1'
      'ORDER BY VERSION/* DESC*/')
    Left = 150
    Top = 50
    object qBUILDSID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object qBUILDSVERSION: TStringField
      FieldName = 'VERSION'
    end
    object qBUILDSNUM: TIntegerField
      FieldName = 'NUM'
    end
    object qBUILDSPARENT_VER: TStringField
      FieldName = 'PARENT_VER'
    end
    object qBUILDSNOTE: TStringField
      FieldName = 'NOTE'
      Size = 250
    end
    object qBUILDSVER_CALC: TStringField
      FieldKind = fkCalculated
      FieldName = 'VER_CALC'
      Calculated = True
    end
  end
  object DataSource1: TDataSource
    DataSet = qBUILDS
    Left = 250
    Top = 50
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 300
    OnTimer = Timer1Timer
    Left = 340
    Top = 45
  end
end
