object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 377
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 42
    Top = 111
    Width = 23
    Height = 22
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 63
    Top = 111
    Width = 23
    Height = 22
    OnClick = SpeedButton2Click
  end
  object BitBtn1: TBitBtn
    Left = 312
    Top = 55
    Width = 75
    Height = 23
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 57
    Width = 272
    Height = 21
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'LabeledEdit1'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 56
    Top = 159
    Width = 623
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 56
    Top = 190
    Width = 623
    Height = 148
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
  object Button2: TButton
    Left = 56
    Top = 344
    Width = 623
    Height = 25
    Caption = 'Button2'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 439
    Top = 119
    Width = 240
    Height = 25
    Caption = 'Button3'
    Enabled = False
    TabOrder = 5
    OnClick = Button3Click
  end
  object RadioGroup1: TRadioGroup
    Left = 439
    Top = 8
    Width = 240
    Height = 105
    Caption = 'RadioGroup1'
    Items.Strings = (
      #1064#1090#1072#1090
      #1044#1086#1083#1078#1085#1086#1089#1090#1080
      #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103)
    TabOrder = 6
    OnClick = RadioGroup1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 84
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'Edit1'
  end
  object CheckBox1: TCheckBox
    Left = 160
    Top = 32
    Width = 265
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 8
  end
  object Button4: TButton
    Left = 224
    Top = 119
    Width = 201
    Height = 25
    Caption = 'Button4'
    TabOrder = 9
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 279
    Top = 1
    Width = 146
    Height = 25
    Caption = 'Button5'
    TabOrder = 10
    OnClick = Button5Click
  end
  object CheckBox2: TCheckBox
    Left = 224
    Top = 96
    Width = 201
    Height = 17
    Caption = 'CheckBox2'
    State = cbGrayed
    TabOrder = 11
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = '\\10.0.20.177\D$\Perco\GraphWork\SCD17K.FDB'
    Params.Strings = (
      'user_name=sysdba'
      'PASSWORD=masterke')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    Left = 8
  end
  object IBTransaction1: TIBTransaction
    DefaultDatabase = IBDatabase1
    Left = 40
  end
  object IBDatabaseINI1: TIBDatabaseINI
    Database = IBDatabase1
    DatabaseName = 'D:\Work\Perco\SCD17K.fdb'
    Username = 'sysdba'
    Password = 'masterkey'
    CharacterSet = 'UTF-8'
    FileName = 'D:\Work\Perco\SCD17K.ini'
    UseAppPath = ipoPathToServer
    Section = 'Database Settings'
    Left = 72
  end
  object IBStoredProc1: TIBStoredProc
    Database = IBDatabase1
    Transaction = IBTransaction1
    StoredProcName = '_CROSSES_FOR_PERIOD$GET'
    Left = 104
  end
  object OpenDialog1: TOpenDialog
    Left = 136
  end
  object XMLDocument1: TXMLDocument
    Left = 16
    Top = 246
    DOMVendorDesc = 'MSXML'
  end
  object SaveDialog1: TSaveDialog
    Left = 168
  end
  object IBQuery1: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    SQL.Strings = (
      '  UPDATE STAFF SFF'
      '    SET SFF.id_from_1c ='
      '     CASE :P_UNLOCK_SPIN'
      '        WHEN 0 THEN TRIM(SFF.tabel_id)'
      '        WHEN 1 THEN '#39#39
      '        ELSE SFF.id_from_1c'
      '     END'
      '   WHERE'
      '    SFF.id_staff = (select first 1 ss.id_staff'
      '                        from staff ss'
      '                        where trim(ss.tabel_id) = :P_TABEL_ID'
      '                              and ss.id_from_1c is not null'
      '                        order by ss.id_staff DESC)')
    Left = 144
    Top = 80
    ParamData = <
      item
        DataType = ftString
        Name = 'P_UNLOCK_SPIN'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'P_TABEL_ID'
        ParamType = ptUnknown
      end>
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 50
    Top = 120
  end
  object PopupMenu1: TPopupMenu
    Left = 208
    object Open1: TMenuItem
      Caption = 'Show Main Window'
      OnClick = Open1Click
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end
