object frmTableSheetDetail: TfrmTableSheetDetail
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1058#1072#1073#1077#1083#1100
  ClientHeight = 362
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 321
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -48
    ExplicitTop = 8
    ExplicitHeight = 272
    object Label1: TLabel
      Left = 34
      Top = 32
      Width = 56
      Height = 13
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
    end
    object cxComboBox1: TcxComboBox
      Left = 34
      Top = 51
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 0
      Width = 590
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 321
    Width = 645
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 272
    object btnCancel: TButton
      Left = 549
      Top = 6
      Width = 75
      Height = 25
      Action = acCancel
      TabOrder = 1
    end
    object btnSave: TButton
      Left = 468
      Top = 6
      Width = 75
      Height = 25
      Action = acSave
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 40
    Top = 328
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
    end
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    end
  end
  object qrQuery: TADOQuery
    Connection = MainForm.connVelcom
    Parameters = <>
    Left = 104
    Top = 328
  end
end
