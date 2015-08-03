object BatchSelectorForm: TBatchSelectorForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1082#1072' '#1089#1087#1080#1089#1082#1072
  ClientHeight = 425
  ClientWidth = 684
  Color = clBtnFace
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
  object Splitter1: TSplitter
    Left = 364
    Top = 0
    Width = 4
    Height = 388
    Align = alRight
    Color = clGray
    ParentColor = False
    ExplicitLeft = 361
    ExplicitHeight = 383
  end
  object lbDest: TListBox
    Left = 0
    Top = 0
    Width = 364
    Height = 388
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnKeyDown = lbDestKeyDown
    ExplicitHeight = 383
  end
  object Panel1: TPanel
    Left = 0
    Top = 388
    Width = 684
    Height = 37
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 383
    DesignSize = (
      684
      37)
    object btOK: TButton
      Left = 601
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object bAdd: TButton
      Left = 371
      Top = 6
      Width = 26
      Height = 25
      Caption = '+'
      TabOrder = 1
      Visible = False
      OnClick = bAddClick
    end
    object btLoadFromFile: TButton
      Left = 10
      Top = 6
      Width = 121
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072
      TabOrder = 2
      OnClick = btLoadFromFileClick
    end
    object btSaveToFile: TButton
      Left = 137
      Top = 6
      Width = 119
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      TabOrder = 3
      OnClick = btSaveToFileClick
    end
    object btCancel: TButton
      Left = 525
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 368
    Top = 0
    Width = 316
    Height = 388
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitHeight = 383
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 35
      Height = 388
      Align = alLeft
      Shape = bsSpacer
      ExplicitHeight = 268
    end
    object btAddDir: TButton
      Left = 2
      Top = 6
      Width = 30
      Height = 42
      Caption = '<<'
      TabOrder = 0
      OnClick = btAddDirClick
    end
    object Panel3: TPanel
      Left = 35
      Top = 0
      Width = 281
      Height = 388
      Align = alClient
      BevelOuter = bvLowered
      Caption = 'Panel3'
      TabOrder = 1
      ExplicitHeight = 383
      object Bevel1: TBevel
        Left = 1
        Top = 23
        Width = 279
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Splitter2: TSplitter
        Left = 1
        Top = 246
        Width = 279
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        Color = clGray
        ParentColor = False
        ExplicitLeft = -14
        ExplicitTop = 218
      end
      object cbDrive: TDriveComboBoxEx
        Left = 1
        Top = 1
        Width = 279
        Height = 22
        Align = alTop
        DirList = lbDirs
        TabOrder = 0
        Version = '1.2.1.0'
      end
      object lbDirs: TDirectoryListBoxEx
        Left = 1
        Top = 27
        Width = 279
        Height = 219
        Align = alClient
        ItemHeight = 16
        TabOrder = 1
        OnClick = lbDirsClick
        OnKeyDown = lbDirsKeyDown
        DirectOpen = False
        Version = '1.2.1.0'
        ExplicitHeight = 235
      end
      object pnFiles: TPanel
        Left = 1
        Top = 250
        Width = 279
        Height = 137
        Align = alBottom
        Caption = 'pnFiles'
        TabOrder = 2
        DesignSize = (
          279
          137)
        object Label1: TLabel
          Left = 1
          Top = 1
          Width = 277
          Height = 22
          Align = alTop
          AutoSize = False
          Caption = ' '#1057#1087#1080#1089#1086#1082' '#1087#1086' '#1084#1072#1089#1082#1077
          Layout = tlCenter
        end
        object lbFiles: TFileListBoxEx
          Left = 1
          Top = 23
          Width = 277
          Height = 113
          Align = alClient
          ItemHeight = 16
          ShowGlyphs = True
          TabOrder = 0
          OnKeyDown = lbFilesKeyDown
          Version = '1.2.1.0'
          ExplicitHeight = 92
        end
        object edMask: TEdit
          Left = 95
          Top = 1
          Width = 181
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Text = '*.*'
          OnExit = edMaskExit
          OnKeyDown = edMaskKeyDown
        end
      end
    end
    object btAddFile: TButton
      Left = 2
      Top = 6
      Width = 30
      Height = 42
      Caption = '<<'
      TabOrder = 2
      OnClick = btAddFileClick
    end
  end
  object sdDialog: TJvSelectDirectory
    Left = 45
    Top = 140
  end
  object od: TOpenDialog
    DefaultExt = 'txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 120
    Top = 55
  end
  object sd: TSaveDialog
    DefaultExt = 'txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 180
    Top = 55
  end
end
