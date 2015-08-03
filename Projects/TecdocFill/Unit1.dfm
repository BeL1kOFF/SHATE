object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1047#1072#1083#1080#1074#1082#1072
  ClientHeight = 683
  ClientWidth = 1030
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 623
    Top = 136
    Width = 286
    Height = 98
    AutoSize = False
    Caption = 
      #1042#1099#1090#1103#1078#1082#1080' '#1080#1079' TecDoc - '#1087#1086#1083#1085#1099#1077', '#1076#1077#1083#1072#1102#1090#1089#1103' '#1086#1076#1080#1085' '#1088#1072#1079#13#10'-----------------' +
      '-----------------------------------------------'#13#10'1 - '#1072#1088#1090#1080#1082#1091#1083#1072' [ ' +
      'TD_ART ]'#13#10'2 - '#1087#1088#1080#1074#1103#1079#1082#1072' '#1072#1088#1090#1080#1082#1091#1083#1086#1074' '#1082' '#1090#1080#1087#1072#1084' '#1072#1074#1090#1086' [ ART_TYP ]'#13#10'3 - '#1090 +
      #1080#1087#1099' '#1072#1074#1090#1086' [ TD_TYPES ]'#13#10'4 - '#1084#1086#1076#1077#1083#1080' '#1072#1074#1090#1086' [ TD_MODELS ]'#13#10'5 - '#1087#1088#1086#1080#1079#1074 +
      #1086#1076#1080#1090#1077#1083#1080' ('#1084#1072#1088#1082#1080') [ TD_MANUFACTURERS ]'#13#10'6 - '#1087#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080' [ TD_DETAI' +
      'LS ]'#13#10'7 - '#1087#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080' '#1087#1086' '#1090#1080#1087#1072#1084' [ TD_DETAILS_TYP ]'#13#10'8 - '#1080#1084#1077#1085#1072' '#1087#1072#1088 +
      #1072#1084#1077#1090#1088#1086#1074' [ TD_PARAMS ]'#13#10'9 - '#1087#1088#1080#1074#1103#1079#1082#1072' '#1082#1072#1088#1090#1080#1085#1086#1082' '#1082' '#1072#1088#1090#1080#1082#1091#1083#1072#1084' [ ART_P' +
      'ICTS ]'#13#10'10 - '#1082#1072#1088#1090#1080#1085#1082#1080' [ TD_PICTS ]'#13#10'11 - '#1087#1088#1080#1084#1077#1085#1103#1077#1084#1086#1089#1090#1100' [ ? ]'#13#10'24' +
      ', 25 '#1090#1072#1073#1083#1080#1094#1099' '#1079#1072#1090#1103#1075#1080#1074#1072#1102#1090#1089#1103' '#1074' '#1089#1077#1088#1074#1080#1089#1085#1091#1102' '#1086#1076#1080#1085' '#1088#1072#1079
    Visible = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 428
    Top = 8
    Width = 58
    Height = 13
    Caption = 'Connection:'
  end
  object lbProgressInfo: TLabel
    Left = 433
    Top = 605
    Width = 12
    Height = 13
    Caption = '---'
  end
  object btImport_ARTTYP: TButton
    Left = 433
    Top = 115
    Width = 133
    Height = 25
    Caption = '2 - '#1040#1088#1090#1080#1082#1091#1083#1072' '#1082' '#1090#1080#1087#1072#1084
    TabOrder = 0
    OnClick = btImport_ARTTYPClick
  end
  object btFill_PictCodes: TButton
    Left = 433
    Top = 298
    Width = 178
    Height = 25
    Caption = '9 - '#1050#1072#1088#1090#1080#1085#1082#1080' '#1082' '#1072#1088#1090#1080#1082#1091#1083#1072#1084
    TabOrder = 1
    OnClick = btFill_PictCodesClick
  end
  object btFill_PictData: TButton
    Left = 433
    Top = 328
    Width = 133
    Height = 25
    Caption = '10 - '#1044#1072#1085#1085#1099#1077' '#1082#1072#1088#1090#1080#1085#1086#1082
    TabOrder = 2
    OnClick = btFill_PictDataClick
  end
  object btFill_Arts: TButton
    Left = 433
    Top = 84
    Width = 98
    Height = 25
    Caption = '1 - '#1040#1088#1090#1080#1082#1091#1083#1072
    TabOrder = 3
    OnClick = btFill_ArtsClick
  end
  object btFill_Typ: TButton
    Left = 433
    Top = 141
    Width = 178
    Height = 25
    Caption = '3 - '#1058#1080#1087#1099' '#1072#1074#1090#1086
    TabOrder = 4
    OnClick = btFill_TypClick
  end
  object rbConnectionLocal: TRadioButton
    Left = 497
    Top = 7
    Width = 124
    Height = 17
    Caption = 'Local'
    Checked = True
    TabOrder = 5
    TabStop = True
    Visible = False
  end
  object rbConnectionServer: TRadioButton
    Left = 497
    Top = 24
    Width = 124
    Height = 17
    Caption = 'Work (Server: AMD)'
    TabOrder = 6
    Visible = False
  end
  object Button1: TButton
    Left = 638
    Top = 6
    Width = 128
    Height = 20
    Caption = #1058#1077#1089#1090' MSSQL Connection'
    TabOrder = 7
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 638
    Top = 26
    Width = 128
    Height = 20
    Caption = #1058#1077#1089#1090' TecDoc Connection'
    TabOrder = 8
    Visible = False
    OnClick = Button2Click
  end
  object btFill_Des: TButton
    Left = 531
    Top = 84
    Width = 40
    Height = 25
    Caption = 'Des'
    TabOrder = 9
    OnClick = btFill_DesClick
  end
  object btFill_Cds: TButton
    Left = 571
    Top = 84
    Width = 40
    Height = 25
    Caption = 'Cds'
    TabOrder = 10
    OnClick = btFill_CdsClick
  end
  object btFill_Models: TButton
    Left = 433
    Top = 166
    Width = 178
    Height = 25
    Caption = '4 - '#1052#1086#1076#1077#1083#1080' '#1072#1074#1090#1086
    TabOrder = 11
    OnClick = btFill_ModelsClick
  end
  object btFill_Manufacturers: TButton
    Left = 433
    Top = 191
    Width = 178
    Height = 25
    Caption = '5 - '#1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080' '#1072#1074#1090#1086
    TabOrder = 12
    OnClick = btFill_ManufacturersClick
  end
  object btFill_Params: TButton
    Left = 433
    Top = 216
    Width = 178
    Height = 25
    Caption = '6 - '#1055#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080
    TabOrder = 13
    OnClick = btFill_ParamsClick
  end
  object btFill_ParamsByTypes: TButton
    Left = 433
    Top = 236
    Width = 143
    Height = 25
    Caption = '7 - '#1055#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080' '#1087#1086' '#1090#1080#1087#1072#1084
    TabOrder = 14
    OnClick = btFill_ParamsByTypesClick
  end
  object btImport_ARTTYP2: TButton
    Left = 566
    Top = 115
    Width = 45
    Height = 25
    Caption = 'AT2'
    TabOrder = 15
    OnClick = btImport_ARTTYP2Click
  end
  object btFill_ParamNames: TButton
    Left = 433
    Top = 267
    Width = 178
    Height = 25
    Caption = '8 - '#1048#1084#1077#1085#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
    TabOrder = 16
    OnClick = btFill_ParamNamesClick
  end
  object btFill_ParamsByTypes2: TButton
    Left = 576
    Top = 236
    Width = 35
    Height = 25
    Caption = #1055#1058'2'
    TabOrder = 17
    OnClick = btFill_ParamsByTypes2Click
  end
  object btAddPictDir: TButton
    Left = 308
    Top = 53
    Width = 201
    Height = 25
    Caption = #1044#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1082#1072#1088#1090#1080#1085#1086#1082' '#1080#1079' '#1087#1072#1087#1086#1082
    TabOrder = 18
    Visible = False
    OnClick = btAddPictDirClick
  end
  object btAddArt: TButton
    Left = 18
    Top = 422
    Width = 201
    Height = 25
    Caption = #1044#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1072#1088#1090#1080#1082#1091#1083#1086#1074
    TabOrder = 19
    Visible = False
    OnClick = btAddArtClick
  end
  object btFill_PictHash: TButton
    Left = 566
    Top = 328
    Width = 45
    Height = 25
    Caption = 'Hashs'
    TabOrder = 20
    OnClick = btFill_PictHashClick
  end
  object btAddAllFromService: TButton
    Left = 18
    Top = 480
    Width = 201
    Height = 25
    Caption = #1044#1086#1083#1080#1074#1082#1080' '#1080#1079' '#1089#1077#1088#1074#1080#1089#1085#1086#1081
    TabOrder = 21
    Visible = False
    OnClick = btAddAllFromServiceClick
  end
  object Button3: TButton
    Left = 433
    Top = 354
    Width = 178
    Height = 25
    Caption = #1055#1088#1086#1089#1090#1072#1074#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1082#1072#1088#1090#1080#1085#1082#1091
    TabOrder = 22
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 557
    Top = 466
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 23
    OnClick = Button4Click
  end
  object btLoadHidedManufacturers: TButton
    Left = 18
    Top = 391
    Width = 201
    Height = 25
    Caption = #1057#1082#1088#1099#1090#1080#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1077#1081
    TabOrder = 24
    Visible = False
    OnClick = btLoadHidedManufacturersClick
  end
  object Button5: TButton
    Left = 18
    Top = 449
    Width = 201
    Height = 25
    Caption = #1044#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1072#1088#1090#1080#1082#1091#1083#1086#1074' ('#1088#1072#1089#1087#1086#1079#1085#1072#1090#1100')'
    TabOrder = 25
    Visible = False
    OnClick = Button5Click
  end
  object rbConnectionServerNew: TRadioButton
    Left = 515
    Top = 47
    Width = 135
    Height = 17
    Caption = #1053#1086#1074#1072#1103' '#1041#1044' (Tecdoc 2014)'
    TabOrder = 26
  end
  object Button6: TButton
    Left = 617
    Top = 240
    Width = 152
    Height = 25
    Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1085#1072#1096#1080' '#1087#1077#1088#1077#1073#1080#1074#1082#1080
    TabOrder = 27
    Visible = False
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 617
    Top = 298
    Width = 152
    Height = 25
    Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1084#1072#1087#1082#1091' '#1072#1088#1090#1080#1082#1091#1083#1086#1074
    TabOrder = 28
    Visible = False
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 617
    Top = 323
    Width = 152
    Height = 25
    Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1084#1072#1087#1082#1091' '#1084#1072#1096#1080#1085
    TabOrder = 29
    Visible = False
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 617
    Top = 267
    Width = 152
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1085#1072#1096#1080' '#1087#1077#1088#1077#1073#1080#1074#1082#1080
    TabOrder = 30
    Visible = False
    OnClick = Button9Click
  end
  object Memo1: TMemo
    Left = 623
    Top = 87
    Width = 296
    Height = 76
    ScrollBars = ssVertical
    TabOrder = 31
    WordWrap = False
  end
  object Button10: TButton
    Left = 617
    Top = 354
    Width = 134
    Height = 25
    Caption = #1057#1082#1088#1099#1090#1080#1077' '#1072#1074#1090#1086
    TabOrder = 32
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 770
    Top = 323
    Width = 149
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1084#1072#1087#1082#1091' '#1084#1072#1096#1080#1085
    TabOrder = 33
    Visible = False
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 770
    Top = 298
    Width = 149
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1084#1072#1087#1082#1091' '#1072#1088#1090#1080#1082#1091#1083#1086#1074
    TabOrder = 34
    Visible = False
    OnClick = Button12Click
  end
  object btPicturesFix: TButton
    Left = 770
    Top = 354
    Width = 176
    Height = 25
    Caption = 'FIX '#1082#1072#1088#1090#1080#1085#1086#1082
    TabOrder = 35
    Visible = False
    OnClick = btPicturesFixClick
  end
  object btFill_KITs_IDs: TButton
    Left = 433
    Top = 385
    Width = 178
    Height = 25
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1099' ID'
    TabOrder = 36
    OnClick = btFill_KITs_IDsClick
  end
  object Button13: TButton
    Left = 686
    Top = 440
    Width = 75
    Height = 25
    Caption = 'Button13'
    TabOrder = 37
    OnClick = Button13Click
  end
  object btFill_KITs: TButton
    Left = 433
    Top = 410
    Width = 178
    Height = 25
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1099' CODE_BRAND'
    TabOrder = 38
    OnClick = btFill_KITsClick
  end
  object Button14: TButton
    Left = 663
    Top = 471
    Width = 131
    Height = 31
    Caption = #1050#1080#1083#1100#1085#1091#1090#1100' '#1076#1091#1073#1083#1080
    TabOrder = 39
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 663
    Top = 501
    Width = 131
    Height = 31
    Caption = #1047#1072#1083#1080#1090#1100' '#1088#1072#1079#1085#1080#1094#1091
    TabOrder = 40
    OnClick = Button15Click
  end
  object Memo2: TMemo
    Left = 465
    Top = 489
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo2')
    TabOrder = 41
  end
  object Button16: TButton
    Left = 663
    Top = 538
    Width = 131
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1077#1085#1086' '#1074#1088#1091#1095#1085#1091#1102
    TabOrder = 42
    OnClick = Button16Click
  end
  object Button17: TButton
    Left = 676
    Top = 569
    Width = 75
    Height = 25
    Caption = 'KITS'
    TabOrder = 43
    OnClick = Button17Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 17
    Width = 1030
    Height = 61
    Align = alTop
    TabOrder = 44
    Visible = False
    object Label3: TLabel
      Left = 8
      Top = 9
      Width = 30
      Height = 13
      Caption = #1051#1086#1075#1080#1085
    end
    object Label4: TLabel
      Left = 8
      Top = 36
      Width = 37
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100
    end
    object edUser: TEdit
      Left = 63
      Top = 6
      Width = 148
      Height = 21
      TabOrder = 0
    end
    object edPassword: TEdit
      Left = 63
      Top = 33
      Width = 148
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 35
    Top = 115
    Width = 346
    Height = 504
    TabOrder = 45
    DesignSize = (
      346
      504)
    object Label5: TLabel
      Left = 6
      Top = 190
      Width = 210
      Height = 13
      Caption = #1051#1086#1075' '#1087#1086#1079#1080#1094#1080#1081', '#1082#1086#1090#1086#1088#1099#1077' '#1085#1077' '#1089#1086#1087#1086#1089#1090#1072#1074#1080#1083#1080#1089#1100':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object btAddPictList: TButton
      Left = 50
      Top = 4
      Width = 201
      Height = 25
      Caption = #1044#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1082#1072#1088#1090#1080#1085#1086#1082' '#1087#1086' '#1089#1087#1080#1089#1082#1091
      TabOrder = 0
      OnClick = btAddPictListClick
    end
    object btAddParams: TButton
      Left = 50
      Top = 66
      Width = 201
      Height = 25
      Caption = #1044#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1087#1086#1076#1088#1086#1073#1085#1086#1089#1090#1077#1081
      TabOrder = 1
      OnClick = btAddParamsClick
    end
    object btAddDescriptions: TButton
      Left = 50
      Top = 35
      Width = 201
      Height = 25
      Caption = #1044#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1086#1087#1080#1089#1072#1085#1080#1081
      TabOrder = 2
      OnClick = btAddDescriptionsClick
    end
    object btAddPrimen: TButton
      Left = 50
      Top = 97
      Width = 201
      Height = 25
      Caption = #1044#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1080#1084#1077#1085#1103#1077#1084#1086#1089#1090#1080
      TabOrder = 3
      OnClick = btAddPrimenClick
    end
    object btAbort: TButton
      Left = 272
      Top = 388
      Width = 63
      Height = 24
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      TabOrder = 4
      OnClick = btAbortClick
    end
    object pb: TProgressBar
      Left = 1
      Top = 488
      Width = 344
      Height = 15
      Align = alBottom
      Step = 1
      TabOrder = 5
    end
    object Panel3: TPanel
      Left = 1
      Top = 128
      Width = 296
      Height = 60
      TabOrder = 6
      object btPatrialFillDataInTecdoc: TButton
        Left = 6
        Top = 8
        Width = 183
        Height = 43
        Caption = #1047#1072#1083#1080#1074#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1086#1090#1076#1077#1083#1100#1085#1086#1089#1090#1080
        TabOrder = 0
        OnClick = btPatrialFillDataInTecdocClick
      end
      object ChBoxPicts: TCheckBox
        Left = 195
        Top = 34
        Width = 97
        Height = 17
        Caption = #1050#1072#1088#1090#1080#1085#1082#1080
        TabOrder = 1
      end
      object ChBoxPrimen: TCheckBox
        Left = 195
        Top = 4
        Width = 97
        Height = 17
        Caption = #1055#1088#1080#1084#1077#1085#1103#1077#1084#1086#1089#1090#1100
        TabOrder = 2
      end
      object ChBoxDescr: TCheckBox
        Left = 195
        Top = 19
        Width = 84
        Height = 17
        Caption = #1054#1087#1080#1089#1072#1085#1080#1103
        TabOrder = 3
      end
    end
    object MemLog: TMemo
      Left = 1
      Top = 209
      Width = 306
      Height = 176
      ReadOnly = True
      TabOrder = 7
    end
    object Button18: TButton
      Left = 7
      Top = 35
      Width = 31
      Height = 25
      Caption = 'Button18'
      TabOrder = 8
      Visible = False
      OnClick = Button18Click
    end
  end
  object cbWindowsAutority: TCheckBox
    Left = 0
    Top = 0
    Width = 1030
    Height = 17
    Align = alTop
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' Windows '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1102
    Checked = True
    State = cbChecked
    TabOrder = 46
    OnClick = cbWindowsAutorityClick
  end
  object Button19: TButton
    Left = 440
    Top = 624
    Width = 75
    Height = 25
    Caption = 'Test_connect'
    TabOrder = 47
    OnClick = Button19Click
  end
  object adoOLEDB: TADOConnection
    CommandTimeout = 360
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=Admin;Initial Catalog=TECDOC2015;Data Source=SV' +
      'BYMINSD10'
    ConnectionTimeout = 360
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 635
    Top = 81
  end
  object insertQuery: TADOCommand
    CommandTimeout = 60
    Connection = adoOLEDB
    Parameters = <>
    Left = 750
    Top = 81
  end
  object msQuery: TADOQuery
    Connection = adoOLEDB
    CursorType = ctOpenForwardOnly
    CommandTimeout = 360
    Parameters = <>
    Left = 695
    Top = 81
  end
  object tdConnection: TADOConnection
    CommandTimeout = 60
    ConnectionString = 
      'Provider=MSDASQL.1;Password=tcd_error_0;Persist Security Info=Tr' +
      'ue;User ID=tecdoc;Data Source=SHTMP_TECDOC'
    ConnectionTimeout = 60
    CursorLocation = clUseServer
    IsolationLevel = ilBrowse
    LoginPrompt = False
    Mode = cmRead
    Provider = 'MSDASQL.1'
    Left = 793
    Top = 9
  end
  object tdQuery: TADOQuery
    Connection = tdConnection
    CursorLocation = clUseServer
    CursorType = ctOpenForwardOnly
    CommandTimeout = 60
    Parameters = <>
    Left = 855
    Top = 10
  end
  object SelectDirectory: TJvSelectDirectory
    Left = 1053
    Top = 240
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'csv'
    Filter = #1060#1072#1081#1083#1099' CSV|*.CSV'
    Left = 938
    Top = 173
  end
  object DBISAMEngine: TDBISAMEngine
    Active = True
    EngineVersion = '4.25 Build 5'
    EngineType = etClient
    EngineSignature = 'DBISAM_SIG_IMP'
    Functions = <>
    LargeFileSupport = False
    FilterRecordCounts = True
    LockFileName = 'dbisam.lck'
    MaxTableDataBufferSize = 32768
    MaxTableDataBufferCount = 8192
    MaxTableIndexBufferSize = 65536
    MaxTableIndexBufferCount = 8192
    MaxTableBlobBufferSize = 32768
    MaxTableBlobBufferCount = 8192
    TableDataExtension = '.1'
    TableIndexExtension = '.2'
    TableBlobExtension = '.3'
    TableDataBackupExtension = '.1_'
    TableIndexBackupExtension = '.2_'
    TableBlobBackupExtension = '.3_'
    TableDataUpgradeExtension = '.1$'
    TableIndexUpgradeExtension = '.2$'
    TableBlobUpgradeExtension = '.3$'
    TableDataTempExtension = '.1~'
    TableIndexTempExtension = '.2~'
    TableBlobTempExtension = '.3~'
    CreateTempTablesInDatabase = False
    TableFilterIndexThreshhold = 1
    TableReadLockWaitTime = 3
    TableReadLockRetryCount = 32768
    TableWriteLockWaitTime = 3
    TableWriteLockRetryCount = 32768
    TableTransLockWaitTime = 3
    TableTransLockRetryCount = 32768
    TableMaxReadLockCount = 100
    ServerName = 'DBSRVR'
    ServerDescription = 'DBISAM Database Server'
    ServerMainPort = 12005
    ServerMainThreadCacheSize = 10
    ServerAdminPort = 12006
    ServerAdminThreadCacheSize = 1
    ServerEncryptedOnly = False
    ServerEncryptionPassword = 'elevatesoft'
    ServerConfigFileName = 'dbsrvr.scf'
    ServerConfigPassword = 'elevatesoft'
    ServerLicensedConnections = 65535
    Left = 995
    Top = 210
  end
  object DBIQuery: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA_IMP'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    Params = <>
    Left = 945
    Top = 90
  end
  object DBISAMDB: TDBISAMDatabase
    EngineVersion = '4.25 Build 5'
    DatabaseName = 'DATA_IMP'
    KeepTablesOpen = False
    SessionName = 'Default'
    Left = 610
    Top = 781
  end
  object memART: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'look'
        Fields = 'ART_ID;ART_LOOK;SUP_BRAND'
        Compression = icNone
      end>
    TableName = 'memART'
    StoreDefs = True
    Left = 995
    Top = 90
    object memARTID: TIntegerField
      FieldName = 'ID'
    end
    object memARTART_ID: TIntegerField
      FieldName = 'ART_ID'
    end
    object memARTART_LOOK: TStringField
      FieldName = 'ART_LOOK'
      Size = 50
    end
    object memARTSUP_BRAND: TStringField
      FieldName = 'SUP_BRAND'
      Size = 50
    end
    object memARTPARAM_ID: TIntegerField
      FieldName = 'PARAM_ID'
    end
    object memARTTYP_ID: TIntegerField
      FieldName = 'TYP_ID'
    end
    object memARTCUR_PICT: TIntegerField
      FieldName = 'CUR_PICT'
    end
  end
  object AnalogIDTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Cat_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end>
    IndexDefs = <
      item
        Name = 'cat_id'
        Fields = 'cat_id'
        Compression = icNone
      end
      item
        Name = 'Gen_An_id'
        Fields = 'Gen_An_id'
        Compression = icNone
      end>
    MasterFields = 'Cat_id'
    TableName = '007_2'
    StoreDefs = True
    Left = 690
    Top = 460
    object AnalogIDTableGen_An_id: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = '007_2.Gen_An_id'
    end
    object AnalogIDTableCat_id: TIntegerField
      FieldName = 'Cat_id'
      Origin = '007_2.Cat_id'
    end
  end
  object AnalogMainTable: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    Filter = 'Locked = 0'
    Filtered = True
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    FieldDefs = <
      item
        Name = 'Gen_An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_code'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_brand'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_id'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'Locked'
        DataType = ftInteger
        CharCase = fcNoChange
        Compression = 0
      end
      item
        Name = 'An_ShortCode'
        DataType = ftString
        Size = 50
        CharCase = fcNoChange
        Compression = 0
      end>
    TableName = '007_1'
    StoreDefs = True
    Left = 690
    Top = 510
    object AnalogMainTableGen_An_id: TIntegerField
      FieldName = 'Gen_An_id'
      Origin = '007_1.Gen_An_id'
    end
    object AnalogMainTableAn_code: TStringField
      FieldName = 'An_code'
      Origin = '007_1.An_code'
      Size = 50
    end
    object AnalogMainTableAn_brand: TStringField
      FieldName = 'An_brand'
      Origin = '007_1.An_brand'
      Size = 50
    end
    object AnalogMainTableAn_id: TIntegerField
      FieldName = 'An_id'
      Origin = '007_1.An_id'
    end
    object AnalogMainTableDescription: TStringField
      FieldKind = fkLookup
      FieldName = 'Description'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Description'
      KeyFields = 'An_id'
      Size = 150
      Lookup = True
    end
    object AnalogMainTablePrice: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      currency = False
      Lookup = True
    end
    object AnalogMainTablePrice_koef: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef'
      DisplayFormat = ',0.##'
      currency = False
      Calculated = True
    end
    object AnalogMainTableAn_group_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_group_id'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Group_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTableAn_subgroup_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_subgroup_id'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Subgroup_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTableQuantity: TStringField
      FieldKind = fkLookup
      FieldName = 'Quantity'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Quantity'
      KeyFields = 'An_id'
      Size = 10
      Lookup = True
    end
    object AnalogMainTableAn_sale: TStringField
      FieldKind = fkLookup
      FieldName = 'An_sale'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogMainTableAn_new: TStringField
      FieldKind = fkLookup
      FieldName = 'An_new'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'New'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogMainTableAn_usa: TStringField
      FieldKind = fkLookup
      FieldName = 'An_usa'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Usa'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogMainTableSale: TStringField
      FieldKind = fkCalculated
      FieldName = 'Sale'
      Size = 1
      Calculated = True
    end
    object AnalogMainTableNew: TStringField
      FieldKind = fkCalculated
      FieldName = 'New'
      Size = 1
      Calculated = True
    end
    object AnalogMainTableName: TStringField
      FieldKind = fkLookup
      FieldName = 'Name'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Name'
      KeyFields = 'An_id'
      Size = 100
      Lookup = True
    end
    object AnalogMainTableName_Descr: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name_Descr'
      Size = 350
      Calculated = True
    end
    object AnalogMainTableAn_Brand_id: TIntegerField
      FieldKind = fkLookup
      FieldName = 'An_Brand_id'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Brand_id'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTableMult: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Mult'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Mult'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTablePrice_koef_eur: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_koef_eur'
      Calculated = True
    end
    object AnalogMainTableOrdQuantity: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantity'
      Calculated = True
    end
    object AnalogMainTableOrdQuantityStr: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrdQuantityStr'
      Size = 10
      Calculated = True
    end
    object AnalogMainTablePrice_pro: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Price_pro'
      DisplayFormat = ',0.##'
      Calculated = True
    end
    object AnalogMainTableUsa: TStringField
      FieldKind = fkCalculated
      FieldName = 'Usa'
      Size = 1
      Calculated = True
    end
    object AnalogMainTablesaleQCalc: TStringField
      FieldKind = fkLookup
      FieldName = 'saleQCalc'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Sale'
      KeyFields = 'An_id'
      Size = 1
      Lookup = True
    end
    object AnalogMainTableSaleQ: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleQ'
      Size = 1
      Calculated = True
    end
    object AnalogMainTablePriceItog: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceItog'
      Calculated = True
    end
    object AnalogMainTablePriceQuant: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'PriceQuant'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Price'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTableLocked: TIntegerField
      FieldName = 'Locked'
      Origin = '007_1.Locked'
    end
    object AnalogMainTableAn_ShortCode: TStringField
      FieldName = 'An_ShortCode'
      Origin = '007_1.An_ShortCode'
      Size = 50
    end
    object AnalogMainTableAn_brand_repl: TStringField
      FieldKind = fkCalculated
      FieldName = 'An_brand_repl'
      Size = 100
      Calculated = True
    end
    object AnalogMainTableQuantLatest: TIntegerField
      FieldKind = fkLookup
      FieldName = 'QuantLatest'
      LookupKeyFields = 'Cat_id'
      LookupResultField = 'Latest'
      KeyFields = 'An_id'
      Lookup = True
    end
    object AnalogMainTableOrderOnly: TBooleanField
      FieldKind = fkLookup
      FieldName = 'OrderOnly'
      LookupKeyFields = 'CAT_ID'
      LookupResultField = 'IsOrder'
      KeyFields = 'An_id'
      Lookup = True
    end
  end
end
