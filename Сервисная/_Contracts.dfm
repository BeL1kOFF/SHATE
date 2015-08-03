object ContractsForm: TContractsForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  ClientHeight = 208
  ClientWidth = 323
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
  DesignSize = (
    323
    208)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 176
    Width = 323
    Height = 32
    Align = alBottom
    ExplicitLeft = 1
    ExplicitTop = 217
    ExplicitWidth = 510
  end
  object JvBevel1: TJvBevel
    Left = 0
    Top = 0
    Width = 323
    Height = 0
    Align = alTop
    Shape = bsBottomLine
    Edges = [beBottom]
    Inner = bvRaised
    PenStyle = psDot
    ExplicitWidth = 614
  end
  object Label1: TLabel
    Left = 10
    Top = 9
    Width = 93
    Height = 13
    Caption = #1043#1088#1091#1087#1087#1072' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
    Visible = False
  end
  object Label2: TLabel
    Left = 244
    Top = 11
    Width = 39
    Height = 13
    Caption = #1042#1072#1083#1102#1090#1072
    Visible = False
  end
  object ContractGrid: TDBGridEh
    Left = 0
    Top = 0
    Width = 323
    Height = 176
    Align = alClient
    AutoFitColWidths = True
    DataSource = DS_Contract
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = ContractGridDblClick
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ContractDescr'
        Footers = <>
        MaxWidth = 300
        MinWidth = 50
        Title.Caption = #1058#1080#1087
        Width = 150
      end>
  end
  object GroupBox: TComboBox
    Left = 64
    Top = 36
    Width = 122
    Height = 21
    ItemHeight = 0
    TabOrder = 1
    Visible = False
    OnChange = GroupBoxChange
  end
  object CurrencyBox: TComboBox
    Left = 389
    Top = 51
    Width = 122
    Height = 21
    ItemHeight = 0
    TabOrder = 2
    Visible = False
    OnChange = CurrencyBoxChange
  end
  object btSetDefContr: TBitBtn
    Left = 205
    Top = 182
    Width = 110
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 3
    OnClick = btSetDefContrClick
  end
  object AddresGrid: TDBGridEh
    Left = 0
    Top = 0
    Width = 323
    Height = 176
    Align = alClient
    AutoFitColWidths = True
    DataSource = DS_Addr
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind]
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Visible = False
    OnDblClick = AddresGridDblClick
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Addres'
        Footers = <>
        Title.Caption = #1040#1076#1088#1077#1089
      end>
  end
  object Q1: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 25
    Top = 150
  end
  object ContractQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'Memory'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 25
    Top = 110
  end
  object DS_Contract: TDataSource
    DataSet = Main.memAgr
    Left = 100
    Top = 110
  end
  object DS_Addr: TDataSource
    DataSet = Q1
    Left = 90
    Top = 170
  end
end
