object frmSenderAdapterDetails: TfrmSenderAdapterDetails
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'frmSenderAdapterDetails'
  ClientHeight = 401
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 365
    Width = 608
    Height = 36
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      608
      36)
    object Button1: TButton
      Left = 517
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      Anchors = [akRight, akBottom]
      TabOrder = 0
    end
    object Button2: TButton
      Left = 421
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      Anchors = [akRight, akBottom]
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 608
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object cxLabel1: TcxLabel
      Left = 24
      Top = 8
      Caption = #1040#1076#1072#1087#1090#1077#1088':'
    end
    object cmbPlugins: TcxComboBox
      Left = 24
      Top = 31
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cmbPluginsPropertiesChange
      TabOrder = 1
      Width = 225
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 73
    Width = 608
    Height = 223
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object tlProperty: TcxTreeList
      Left = 0
      Top = 0
      Width = 608
      Height = 223
      Align = alClient
      Bands = <
        item
        end>
      Navigator.Buttons.CustomButtons = <>
      OptionsCustomizing.BandMoving = False
      OptionsCustomizing.ColumnMoving = False
      OptionsData.Deleting = False
      OptionsView.ColumnAutoWidth = True
      TabOrder = 0
      OnEditing = tlPropertyEditing
      object tlPropertyColumn1: TcxTreeListColumn
        Caption.AlignHorz = taCenter
        Caption.Text = #1055#1072#1088#1072#1084#1077#1090#1088#1099
        DataBinding.ValueType = 'String'
        Options.Editing = False
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object tlPropertyColumn2: TcxTreeListColumn
        Caption.AlignHorz = taCenter
        Caption.Text = #1047#1085#1072#1095#1077#1085#1080#1103
        DataBinding.ValueType = 'String'
        Position.ColIndex = 1
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 296
    Width = 608
    Height = 69
    Align = alBottom
    TabOrder = 3
  end
  object XMLDocument: TXMLDocument
    Left = 136
    Top = 304
    DOMVendorDesc = 'MSXML'
  end
  object ActionList: TActionList
    Left = 40
    Top = 304
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = acCancelExecute
    end
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
  end
end
