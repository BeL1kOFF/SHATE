object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Form2'
  ClientHeight = 500
  ClientWidth = 838
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object JvBehaviorLabel1: TJvBehaviorLabel
    Left = 228
    Top = 479
    Width = 84
    Height = 13
    Caption = 'JvBehaviorLabel1'
  end
  object LabeledEdit1: TLabeledEdit
    Left = 608
    Top = 473
    Width = 208
    Height = 21
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'LabeledEdit1'
    ReadOnly = True
    TabOrder = 0
    Visible = False
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 473
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 104
    Top = 473
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object JvDBSpinEdit1: TJvDBSpinEdit
    Left = 8
    Top = 0
    Width = 44
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Visible = False
  end
  object JvDBLookupComboEdit1: TJvDBLookupComboEdit
    Left = 191
    Top = 0
    Width = 368
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = 'JvDBLookupComboEdit1'
    Visible = False
  end
  object JvDBLookupCombo1: TJvDBLookupCombo
    Left = 112
    Top = 0
    Width = 73
    Height = 21
    ReadOnly = True
    TabOrder = 5
    Visible = False
  end
  object JvDBCheckBox1: TJvDBCheckBox
    Left = 624
    Top = 35
    Width = 97
    Height = 17
    Caption = 'JvDBCheckBox1'
    TabOrder = 6
    ValueChecked = 'True, False'
    ValueUnchecked = 'NULL'
    Visible = False
  end
  object DBEdit3: TDBEdit
    Left = 318
    Top = 471
    Width = 121
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 7
  end
  object Panel1: TPanel
    Left = 333
    Top = 27
    Width = 497
    Height = 98
    Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1103' '#1079#1072#1087#1091#1089#1082#1072' '#1101#1082#1089#1087#1086#1088#1090#1072
    Alignment = taLeftJustify
    Color = clAppWorkSpace
    ParentBackground = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    VerticalAlignment = taAlignTop
    object JvLabel1: TJvLabel
      Left = 147
      Top = 0
      Width = 44
      Height = 13
      Caption = 'JvLabel1'
      Transparent = True
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
    end
    object JvDBComboBox1: TJvDBComboBox
      Left = 147
      Top = 16
      Width = 201
      Height = 21
      Hint = 
        #1042#1099#1073#1077#1088#1080#1090#1077' '#1080#1085#1090#1077#1088#1074#1072#1083' '#1079#1072#1087#1091#1089#1082#1072' '#1101#1082#1089#1087#1086#1088#1090#1072#13#10#13#10#1044#1083#1103' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1103' '#1101#1082#1089#1087#1086#1088#1090#1072' '#1042#1099 +
        ' '#1084#1086#1078#1077#1090#1077' '#1074#1099#1073#1088#1072#1090#1100' '#1087#1091#1085#1082#1090' "'#1047#1040#1055#1056#1045#1065#1045#1053#1054'"'#13#10#13#10#1053#1077' '#1079#1072#1073#1091#1076#1100#1090#1077' '#1085#1072#1078#1072#1090#1100' '#13#10' OK '#1076#1083 +
        #1103' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1085#1072#1089#1090#1088#1086#1081#1082#1080'  '#13#10' Cancel '#1076#1083#1103' '#1086#1090#1084#1077#1085#1099
      ItemHeight = 13
      Items.Strings = (
        ' 1 '#1088#1072#1079' '#1074' '#1089#1091#1090#1082#1080'  (24 '#1095')'
        ' 2 '#1088#1072#1079#1072' '#1074' '#1089#1091#1090#1082#1080' (12 '#1095')'
        ' 3 '#1088#1072#1079#1072' '#1074' '#1089#1091#1090#1082#1080'  (8 '#1095')'
        ' 4 '#1088#1072#1079#1072' '#1074' '#1089#1091#1090#1082#1080'  (6 '#1095')'
        ' 6 '#1088#1072#1079' '#1074' '#1089#1091#1090#1082#1080'   (4 '#1095')'
        #1056#1072#1079' '#1074'  2 '#1089#1091#1090#1086#1082'  (48 '#1095')'
        #1056#1072#1079' '#1074' '#1085#1077#1076#1077#1083#1102'  (7 '#1076#1085#1077#1081')  '
        #1047' '#1040' '#1055' '#1056' '#1045' '#1065' '#1045' '#1053' '#1054' ')
      TabOrder = 0
      Values.Strings = (
        '1440'
        ' 720'
        ' 480'
        ' 360'
        ' 240'
        '2880'
        '1080'
        '')
      OnChange = JvDBComboBox1Change
      OnDropDown = JvDBComboBox1DropDown
    end
    object JvDBDateEdit1: TJvDBDateEdit
      Left = 7
      Top = 16
      Width = 121
      Height = 21
      Hint = 
        #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1085#1086#1075#1086' '#1101#1082#1089#1087#1086#1088#1090#1072'.'#13#10#13#10#1044#1083#1103' '#1072#1082#1090#1080#1074#1072#1094#1080#1080' '#1101#1082#1089#1087#1086#1088#1090#1072 +
        ' '#1085#1077#1084#1077#1076#1083#1077#1085#1085#1086' '#13#10'- '#1091#1076#1072#1083#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1080#1079' '#1087#1086#1083#1103' '#1076#1072#1090#1099#13#10'- '#1097#1077#1083#1082#1085#1080#1090#1077' '#1074' '#1087#1086#1083#1077' '#1074#1088 +
        #1077#1084#1077#1085#1080' '#1076#1086' '#1087#1086#1103#1074#1083#1077#1085#1080#1103' '#1085#1072#1076#1087#1080#1089#1080' "'#1040#1082#1090#1080#1074#1077#1085'"'
      TabOrder = 1
      OnButtonClick = JvDBDateEdit1ButtonClick
    end
    object JvDBDateEdit2: TJvDBDateEdit
      Left = 367
      Top = 16
      Width = 121
      Height = 21
      Hint = 
        #1041#1083#1080#1078#1072#1081#1096#1072#1103' '#1076#1072#1090#1072' '#1079#1072#1087#1091#1089#1082#1072' '#1101#1082#1089#1087#1086#1088#1090#1072' '#1087#1086' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1102'.'#13#10#13#10#1045#1089#1083#1080' '#1101#1082#1089#1087#1086#1088#1090' '#1085 +
        #1077' '#1076#1086#1083#1078#1077#1085' '#1074#1099#1086#1083#1085#1103#1090#1089#1103' '#1087#1086' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1102':'#13#10'- '#1091#1076#1072#1083#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1080#1079' '#1087#1086#1083#1103' '#1076#1072#1090#1099' ' +
        ' '#13#10'- '#1097#1077#1083#1082#1085#1080#1090#1077' '#1087#1086' '#1087#1086#1083#1102' '#1074#1088#1077#1084#1077#1085#1080' '#1076#1086' '#1087#1086#1103#1074#1083#1077#1085#1080#1103' '#1085#1072#1076#1087#1080#1089#1080' "'#1053#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1086 +
        '"'
      DirectInput = False
      TabOrder = 2
      OnButtonClick = JvDBDateEdit2ButtonClick
    end
    object JvDBDateTimePicker1: TJvDBDateTimePicker
      Left = 7
      Top = 43
      Width = 225
      Height = 21
      Hint = 
        #1042#1088#1077#1084#1103' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1085#1086#1075#1086' '#1101#1082#1089#1087#1086#1088#1090#1072'.'#13#10#13#10#1044#1083#1103' '#1072#1082#1090#1080#1074#1072#1094#1080#1080' '#1101#1082#1089#1087#1086#1088#1090 +
        #1072' '#1085#1077#1084#1077#1076#1083#1077#1085#1085#1086#13#10'- '#1091#1076#1072#1083#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1080#1079' '#1087#1086#1083#1103' '#1076#1072#1090#1099#13#10'- '#1097#1077#1083#1082#1085#1080#1090#1077' '#1074' '#1087#1086#1083#1077' '#1074#1088 +
        #1077#1084#1077#1085#1080' '#1076#1086' '#1087#1086#1103#1074#1083#1077#1085#1080#1103' '#1085#1072#1076#1087#1080#1089#1080' "'#1040#1082#1090#1080#1074#1077#1085'"'#13#10#13#10' '
      Date = 41598.400807534720000000
      Format = 'H:mm:ss'
      Time = 41598.400807534720000000
      ShowCheckbox = True
      Kind = dtkTime
      TabOrder = 3
      OnClick = JvDBDateTimePicker1Click
      DropDownDate = 41598.000000000000000000
      TrimValue = False
    end
    object JvDBDateTimePicker2: TJvDBDateTimePicker
      Left = 263
      Top = 43
      Width = 225
      Height = 21
      Hint = 
        #1042#1088#1077#1084#1103' '#1079#1072#1087#1091#1089#1082#1072' '#1101#1082#1089#1087#1086#1088#1090#1072' '#1087#1086' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1102'.'#13#10#13#10#1045#1089#1083#1080' '#1074#1099#1073#1088#1072#1085#1085#1072#1103' '#1087#1077#1088#1080#1086#1076#1080#1095 +
        #1085#1086#1089#1090#1100' '#1089#1091#1090#1082#1080' '#1080' '#1073#1086#1083#1077#1077','#13#10#1074#1087#1086#1089#1083#1077#1076#1089#1090#1074#1080#1080' '#1082#1072#1078#1076#1099#1081' '#1087#1086#1089#1083#1077#1076#1091#1102#1097#1080#1081' '#1079#1072#1087#1091#1089#1082' '#1101#1082#1089 +
        #1087#1086#1088#1090#1072' '#13#10#1073#1091#1076#1077#1090' '#1086#1089#1091#1097#1077#1089#1090#1074#1083#1103#1090#1100#1089#1103' '#1074' '#1101#1090#1086' '#1074#1088#1077#1084#1103'.'#13#10#13#10#1045#1089#1083#1080' '#1087#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1090#1100' ' +
        #1088#1072#1079' '#1074' '#1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1095#1072#1089#1086#1074','#13#10#1087#1086#1089#1083#1077#1076#1091#1102#1097#1080#1077' '#1079#1072#1087#1091#1089#1082#1080' '#1073#1091#1076#1091#1090' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090#1100' '#13#10 +
        #1074' '#1091#1082#1072#1079#1072#1085#1085#1091#1102' '#1084#1080#1085#1091#1090#1091' '#1095#1072#1089#1072#13#10#13#10#1045#1089#1083#1080' '#1101#1082#1089#1087#1086#1088#1090' '#1085#1077' '#1076#1086#1083#1078#1077#1085' '#1074#1099#1086#1083#1085#1103#1090#1089#1103' '#1087#1086' '#1088 +
        #1072#1089#1087#1080#1089#1072#1085#1080#1102':'#13#10'- '#1091#1076#1072#1083#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1080#1079' '#1087#1086#1083#1103' '#1076#1072#1090#1099'  '#13#10'- '#1097#1077#1083#1082#1085#1080#1090#1077' '#1087#1086' '#1087#1086#1083#1102' '#1074 +
        #1088#1077#1084#1077#1085#1080' '#1076#1086' '#1087#1086#1103#1074#1083#1077#1085#1080#1103' '#1085#1072#1076#1087#1080#1089#1080' "'#1053#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1086'" '
      Date = 41598.402425312510000000
      Format = 'H:mm:ss'
      Time = 41598.402425312510000000
      ShowCheckbox = True
      DateFormat = dfLong
      Kind = dtkTime
      TabOrder = 4
      OnClick = JvDBDateTimePicker2Click
      DropDownDate = 41598.000000000000000000
      NullText = #1053#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1086
      ShowTodayCircle = False
      TrimValue = False
    end
    object StaticText1: TStaticText
      Left = 7
      Top = 0
      Width = 59
      Height = 17
      Caption = 'StaticText1'
      TabOrder = 5
    end
    object StaticText2: TStaticText
      Left = 367
      Top = 0
      Width = 59
      Height = 17
      Caption = 'StaticText2'
      TabOrder = 6
    end
    object Button1: TButton
      Left = 7
      Top = 70
      Width = 481
      Height = 25
      Hint = 
        #1053#1072#1078#1084#1080#1090#1077', '#1095#1090#1086#1073#1099' '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1101#1082#1089#1087#1086#1088#1090#13#10#13#10#1053#1077' '#1079#1072#1073#1091#1076#1100#1090#1077' '#1085#1072#1078#1072#1090#1100' O' +
        'K '#1076#1083#1103' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      Caption = 'Button1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 108
    Top = 202
    Width = 722
    Height = 257
    Caption = 'Panel2'
    Color = clInactiveCaption
    ParentBackground = False
    TabOrder = 9
    object JvgLabel2: TJvgLabel
      Left = 158
      Top = 103
      Width = 51
      Height = 16
      Caption = 'JvgLabel2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      FontWeight = fwDONTCARE
      Options = [floActiveWhileControlFocused]
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Alignment = taLeftJustify
    end
    object JvgLabel3: TJvgLabel
      Left = 158
      Top = 137
      Width = 51
      Height = 16
      Caption = 'JvgLabel3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      FontWeight = fwDONTCARE
      Options = [floActiveWhileControlFocused]
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Alignment = taLeftJustify
    end
    object JvgLabel1: TJvgLabel
      Left = 158
      Top = 70
      Width = 51
      Height = 16
      Caption = 'JvgLabel1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      FontWeight = fwDONTCARE
      Options = [floActiveWhileControlFocused]
      Gradient.Active = False
      Gradient.Orientation = fgdHorizontal
      Alignment = taLeftJustify
    end
    object DBEdit1: TDBEdit
      Left = 208
      Top = 76
      Width = 505
      Height = 21
      Hint = 
        #1044#1083#1103' '#1074#1099#1079#1086#1074#1072' '#1076#1080#1072#1083#1086#1075#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1087#1080#1089#1082#1072' '#1088#1072#1089#1089#1099#1083#1082#1080#13#10#1074#1099#1087#1086#1083#1085#1080#1090#1077' '#1076#1074#1086#1081#1085#1086#1081' ' +
        #1097#1077#1083#1095#1086#1082#13#10#13#10#1045#1089#1083#1080' '#1088#1072#1089#1089#1099#1083#1082#1072' '#1086#1089#1091#1097#1077#1089#1090#1074#1083#1103#1077#1090#1089#1103' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1086#1089#1085#1086#1074#1085#1086#1081' '#1072#1076#1088#1077#1089' ' +
        #1082#1083#1080#1077#1085#1090#1072','#13#10#1087#1086#1083#1077' '#1072#1076#1088#1077#1089#1072' '#1084#1086#1078#1085#1086' '#1086#1089#1090#1072#1074#1083#1103#1090#1100' '#1087#1091#1089#1090#1099#1084'. '#13#10#1055#1088#1080' '#1087#1077#1088#1074#1086#1084' '#1079#1072#1087#1091#1089 +
        #1082#1077' '#1101#1082#1089#1087#1086#1088#1090#1072' '#1101#1090#1086' '#1087#1086#1083#1077' '#1073#1091#1076#1077#1090' '#1079#1072#1087#1086#1083#1085#1077#1085#1086' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '
      ParentColor = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = DBEdit1DblClick
      OnEnter = DBEdit1Enter
    end
    object JvDirectoryEdit1: TJvDirectoryEdit
      Left = 8
      Top = 27
      Width = 418
      Height = 21
      DialogKind = dkWin32
      Enabled = False
      TabOrder = 1
      Text = 'JvDirectoryEdit1'
    end
    object JvFilenameEdit1: TJvFilenameEdit
      Left = 432
      Top = 27
      Width = 281
      Height = 21
      Hint = 
        #1044#1074#1086#1081#1085#1086#1081' '#1082#1083#1080#1082' '#1087#1077#1088#1077#1082#1083#1102#1095#1072#1077#1090' '#1088#1077#1078#1080#1084' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1087#1086#1083#1103'.'#13#10#1042' '#1072#1074#1090#1086#1084#1072#1090#1080#1095 +
        #1077#1089#1082#1086#1084' '#1088#1077#1078#1080#1084#1077' '#1080#1084#1103' '#1092#1072#1081#1083#1072' '#1075#1077#1085#1077#1088#1080#1088#1091#1077#1090#1089#1103' '#1085#1072' '#1086#1089#1085#1086#1074#1077' '#1085#1072#1089#1090#1088#1086#1077#1082#13#10#1042' '#1088#1091#1095#1085#1086#1084 +
        ' '#1088#1077#1078#1080#1084#1077' '#1080#1084#1103' '#1092#1072#1081#1083#1072' '#1084#1086#1078#1085#1086' '#1074#1074#1077#1089#1090#1080' '#1089' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099' '
      OnBeforeDialog = JvFilenameEdit1BeforeDialog
      OnAfterDialog = JvFilenameEdit1AfterDialog
      DialogOptions = [ofHideReadOnly, ofExtensionDifferent]
      DialogTitle = #1042#1099#1073#1086#1088' '#1082#1072#1090#1072#1083#1086#1075#1072' '#1080' '#1080#1084#1077#1085#1080' '#1076#1083#1103' '#1092#1072#1081#1083#1072' '#1074#1099#1075#1088#1091#1079#1082#1080
      ParentColor = True
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 2
      Text = 'JvFilenameEdit1'
      OnDblClick = JvFilenameEdit1DblClick
      OnEnter = JvFilenameEdit1Enter
      OnKeyPress = JvFilenameEdit1KeyPress
    end
    object DBCheckBox1: TDBCheckBox
      Left = 8
      Top = 80
      Width = 201
      Height = 17
      Caption = 'DBCheckBox1'
      TabOrder = 3
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object DBCheckBox2: TDBCheckBox
      Left = 8
      Top = 231
      Width = 201
      Height = 17
      Caption = 'DBCheckBox2'
      TabOrder = 4
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
    object DBEdit2: TDBEdit
      Left = 208
      Top = 115
      Width = 505
      Height = 21
      Hint = 
        #1044#1074#1086#1081#1085#1086#1081' '#1082#1083#1080#1082' '#1087#1077#1088#1077#1082#1083#1102#1095#1072#1077#1090' '#1088#1077#1078#1080#1084' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1087#1086#1083#1103'.'#13#10#1042' '#1072#1074#1090#1086#1084#1072#1090#1080#1095 +
        #1077#1089#1082#1086#1084' '#1088#1077#1078#1080#1084#1077' '#1090#1077#1084#1072' '#1088#1072#1089#1089#1099#1083#1082#1080' '#1075#1077#1085#1077#1088#1080#1088#1091#1077#1090#1089#1103' '#13#10#1042' '#1088#1091#1095#1085#1086#1084' '#1088#1077#1078#1080#1084#1077' '#1090#1077#1084#1091' '#1088 +
        #1072#1089#1089#1099#1083#1082#1080' '#1084#1086#1078#1085#1086' '#1074#1074#1077#1089#1090#1080' '#1089' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099' '
      AutoSelect = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnDblClick = DBEdit2DblClick
      OnEnter = DBEdit2Enter
    end
    object DBMemo1: TDBMemo
      Left = 208
      Top = 137
      Width = 505
      Height = 89
      TabOrder = 6
    end
    object JvStaticText1: TJvStaticText
      Left = 432
      Top = 4
      Width = 70
      Height = 17
      Caption = 'JvStaticText1'
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
      Layout = tlTop
      TabOrder = 7
      TextMargins.X = 0
      TextMargins.Y = 0
      WordWrap = False
    end
  end
  object Panel3: TPanel
    Left = 5
    Top = 147
    Width = 825
    Height = 49
    Color = clInactiveCaption
    ParentBackground = False
    TabOrder = 10
    object DBText1: TDBText
      Left = 8
      Top = 1
      Width = 808
      Height = 17
    end
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Label3'
    end
    object DBLookupComboBox3: TDBLookupComboBox
      Left = 112
      Top = 24
      Width = 153
      Height = 21
      DropDownRows = 8
      DropDownWidth = 1500
      TabOrder = 0
      OnCloseUp = DBLookupComboBox3CloseUp
    end
  end
  object Panel4: TPanel
    Left = 5
    Top = 27
    Width = 322
    Height = 98
    Hint = 
      #1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1076#1086#1089#1090#1091#1087#1085#1099#1093' '#1074#1099#1075#1088#1091#1079#1086#1082'/'#1074#1086#1079#1074#1088#1072#1090#1072' '#1074' '#1086#1089#1085#1086#1074#1085#1086#1081' '#1088#1077#1078#1080 +
      #1084#13#10#1085#1072#1078#1084#1080#1090#1077' '#1082#1083#1072#1074#1080#1096#1091' <CTRL> '#13#10#1080' '#1074#1099#1087#1086#1083#1085#1080#1090#1077' '#1076#1074#1086#1081#1085#1086#1081' '#1097#1077#1083#1095#1086#1082' '#1083#1077#1074#1086#1081' '#1082#1085#1086 +
      #1087#1082#1086#1081' '#1084#1099#1096#1082#1080' '#13#10#1074' '#1089#1074#1086#1073#1086#1076#1085#1086#1084' '#1084#1077#1089#1090#1077' '#1087#1072#1085#1077#1083#1080' '
    Color = clAppWorkSpace
    ParentBackground = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnDblClick = Panel4DblClick
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 8
      Top = 47
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object DBLookupComboBox1: TDBLookupComboBox
      Left = 112
      Top = 16
      Width = 146
      Height = 21
      DropDownWidth = 705
      KeyField = 'ID'
      TabOrder = 0
      OnCloseUp = DBLookupComboBox1CloseUp
    end
    object DBLookupComboBox2: TDBLookupComboBox
      Left = 112
      Top = 43
      Width = 49
      Height = 21
      TabOrder = 1
      OnCloseUp = DBLookupComboBox2CloseUp
    end
    object JvDBComboBox2: TJvDBComboBox
      Left = 8
      Top = 72
      Width = 304
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      OnChange = JvDBComboBox2Change
    end
  end
end
