object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form3'
  ClientHeight = 496
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 120
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 224
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 224
    Top = 64
    Width = 31
    Height = 13
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 8
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 8
    Top = 70
    Width = 31
    Height = 13
    Caption = 'Label5'
  end
  object DBEdit1: TDBEdit
    Left = 120
    Top = 29
    Width = 81
    Height = 21
    DataField = 'ID'
    TabOrder = 4
  end
  object DBEdit2: TDBEdit
    Left = 224
    Top = 29
    Width = 336
    Height = 21
    TabOrder = 3
    OnEnter = DBEdit2Enter
  end
  object DBEdit3: TDBEdit
    Left = 224
    Top = 83
    Width = 201
    Height = 21
    TabOrder = 1
    OnEnter = DBEdit3Enter
  end
  object DBLookupComboBox1: TDBLookupComboBox
    Left = 8
    Top = 29
    Width = 89
    Height = 21
    TabOrder = 5
    OnCloseUp = DBLookupComboBox1CloseUp
  end
  object DBLookupComboBox2: TDBLookupComboBox
    Left = 8
    Top = 83
    Width = 89
    Height = 21
    ReadOnly = True
    TabOrder = 6
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 453
    Width = 75
    Height = 25
    TabOrder = 7
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 104
    Top = 453
    Width = 75
    Height = 25
    TabOrder = 8
    Kind = bkCancel
  end
  object JvDBComboBox1: TJvDBComboBox
    Left = 553
    Top = 160
    Width = 145
    Height = 21
    ItemHeight = 0
    TabOrder = 0
    Visible = False
    OnChange = JvDBComboBox1Change
  end
  object JvDBGrid1: TJvDBGrid
    Left = 8
    Top = 231
    Width = 690
    Height = 202
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 9
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = JvDBGrid1CellClick
    SelectColumnsDialogStrings.Caption = 'Select columns'
    SelectColumnsDialogStrings.OK = '&OK'
    SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
    EditControls = <>
    RowsHeight = 17
    TitleRowHeight = 17
  end
  object DBLookupComboBox3: TDBLookupComboBox
    Left = 8
    Top = 144
    Width = 89
    Height = 21
    KeyField = 'No_'
    ListField = 'No_'
    ListSource = DataSource1
    TabOrder = 2
    Visible = False
  end
  object DBGridEh1: TDBGridEh
    Left = 8
    Top = 219
    Width = 9
    Height = 14
    AutoFitColWidths = True
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    TabOrder = 10
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Edit1: TEdit
    Left = 8
    Top = 192
    Width = 121
    Height = 21
    TabOrder = 11
    Text = '<Enter value here...>'
    Visible = False
    OnChange = Edit1Change
    OnClick = Edit1Click
    OnEnter = Edit1Enter
    OnExit = Edit1Exit
    OnKeyPress = Edit1KeyPress
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 552
    Top = 120
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    Filter = '[Customer Price Group]<>'#39#1056#1054#1047#1053#1048#1062#1040#39
    Filtered = True
    LockType = ltReadOnly
    AfterOpen = ADOTable1AfterOpen
    AfterScroll = ADOTable1AfterScroll
    Left = 520
    Top = 120
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Left = 488
    Top = 120
  end
end
