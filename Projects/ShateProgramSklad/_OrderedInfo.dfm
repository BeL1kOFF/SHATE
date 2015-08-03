object FormOrderedInfo: TFormOrderedInfo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1079#1072#1082#1072#1079#1072#1084
  ClientHeight = 239
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 386
    Height = 201
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 407
    ExplicitHeight = 192
    object lbGoodsName: TLabel
      Left = 0
      Top = 0
      Width = 386
      Height = 19
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #1058#1086#1074#1072#1088
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 465
    end
    object lbGoodsInfo: TLabel
      Left = 0
      Top = 19
      Width = 386
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      WordWrap = True
      ExplicitLeft = 4
      ExplicitTop = 23
      ExplicitWidth = 49
    end
    object pnInfo: TPanel
      Left = 0
      Top = 32
      Width = 386
      Height = 169
      Align = alClient
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = #1058#1086#1074#1072#1088' '#1085#1077' '#1085#1072#1081#1076#1077#1085' '#1074' '#1079#1072#1082#1072#1079#1072#1093
      Color = clWindow
      ParentBackground = False
      TabOrder = 0
      ExplicitLeft = 4
      ExplicitTop = 36
      ExplicitWidth = 401
      ExplicitHeight = 142
      object GridOrders: TDBGridEh
        Left = 0
        Top = 0
        Width = 382
        Height = 165
        Align = alClient
        AutoFitColWidths = True
        BorderStyle = bsNone
        DataSource = DataSource1
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = GridOrdersDblClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Date'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
            Width = 73
          end
          item
            EditButtons = <>
            FieldName = 'Quantity'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1050#1086#1083'-'#1074#1086
            Width = 43
          end
          item
            EditButtons = <>
            FieldName = 'Price'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1062#1077#1085#1072
            Width = 78
          end
          item
            EditButtons = <>
            FieldName = 'Info'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1048#1085#1092#1086
            Width = 159
          end>
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 201
    Width = 386
    Height = 38
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 407
    DesignSize = (
      386
      38)
    object btGotoOrder: TButton
      Left = 279
      Top = 6
      Width = 103
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1079#1072#1082#1072#1079#1091
      TabOrder = 0
      OnClick = btGotoOrderClick
      ExplicitLeft = 300
    end
  end
  object QueryOrders: TDBISAMQuery
    AutoDisplayLabels = False
    CopyOnAppend = False
    DatabaseName = 'DATA'
    EngineVersion = '4.25 Build 5'
    MaxRowCount = -1
    SQL.Strings = (
      
        'select o."Date", od.Code2 Code, od.Brand, od.Quantity, od.Price,' +
        ' od.Info from [010] od'
      'inner join [009] o on (o.order_id = od.order_id)'
      
        'where UPPER(Code) = UPPER(:Code) and UPPER(Brand) = UPPER(:Brand' +
        ')'
      'order by o."Date" desc')
    Params = <
      item
        DataType = ftUnknown
        Name = 'Code'
      end
      item
        DataType = ftUnknown
        Name = 'Brand'
      end>
    Left = 125
    Top = 98
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Code'
      end
      item
        DataType = ftUnknown
        Name = 'Brand'
      end>
  end
  object DataSource1: TDataSource
    DataSet = QueryOrders
    Left = 240
    Top = 100
  end
end
