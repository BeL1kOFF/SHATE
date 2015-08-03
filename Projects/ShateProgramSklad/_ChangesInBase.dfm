object ChangesInBase: TChangesInBase
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1074' '#1073#1072#1079#1077
  ClientHeight = 416
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    592
    416)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 380
    Width = 592
    Height = 36
    Align = alBottom
    ExplicitTop = 379
  end
  object BitBtn1: TBitBtn
    Left = 490
    Top = 386
    Width = 96
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 0
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
  object ChangesTree: TVirtualStringTree
    Left = 0
    Top = 17
    Width = 592
    Height = 363
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag]
    PopupMenu = pmTree
    ScrollBarOptions.ScrollBars = ssVertical
    TabOrder = 1
    TreeOptions.SelectionOptions = [toExtendedFocus]
    OnFreeNode = ChangesTreeFreeNode
    OnGetText = ChangesTreeGetText
    OnInitNode = ChangesTreeInitNode
    OnMeasureItem = ChangesTreeMeasureItem
    OnShowScrollbar = ChangesTreeShowScrollbar
    Columns = <
      item
        Position = 0
        Width = 300
        WideText = '1'
      end
      item
        Position = 1
        Width = 400
        WideText = '2'
      end
      item
        Position = 2
        Width = 500
        WideText = '3'
      end>
  end
  object HeaderControl: THeaderControl
    Left = 0
    Top = 0
    Width = 592
    Height = 17
    HotTrack = True
    Sections = <
      item
        ImageIndex = -1
        Text = #1043#1088#1091#1087#1087#1072'/'#1073#1088#1077#1085#1076
        Width = 200
      end
      item
        ImageIndex = -1
        Text = #1053#1086#1084#1077#1088
        Width = 130
      end
      item
        ImageIndex = -1
        Text = #1050#1086#1083'-'#1074#1086' '#1087#1086#1079#1080#1094#1080#1081'\'#1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 210
      end>
    Style = hsFlat
    OnSectionResize = HeaderControlSectionResize
  end
  object edCopy: TEdit
    Left = 15
    Top = 385
    Width = 121
    Height = 21
    TabOrder = 3
    Visible = False
  end
  object TABLE: TDBISAMTable
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'MEMORY'
    EngineVersion = '4.25 Build 5'
    IndexDefs = <
      item
        Name = 'iDel'
        Fields = 'iDel'
        Compression = icNone
      end>
    TableName = 'TABLE'
    StoreDefs = True
    Left = 8
    Top = 24
    object TABLEiDel: TIntegerField
      FieldName = 'iDel'
    end
    object TABLEsSubGroupe: TStringField
      FieldName = 'sSubGroupe'
      Size = 250
    end
    object TABLEsBrand: TStringField
      FieldName = 'sBrand'
      Size = 50
    end
    object TABLEsCode: TStringField
      FieldName = 'sCode'
    end
    object TABLEsName: TStringField
      FieldName = 'sName'
      Size = 250
    end
  end
  object pmTree: TPopupMenu
    OnPopup = pmTreePopup
    Left = 170
    Top = 80
    object miCopy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = miCopyClick
    end
    object miSearchCode: TMenuItem
      Caption = #1048#1089#1082#1072#1090#1100' '#1085#1086#1084#1077#1088' '#1074' '#1082#1072#1090#1072#1083#1086#1075#1077
      OnClick = miSearchCodeClick
    end
  end
end
