object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  Align = alClient
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 523
  ClientWidth = 819
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 819
    Height = 523
    Align = alClient
    DefaultColWidth = 100
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 20
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnDblClick = StringGrid1DblClick
    OnDrawCell = StringGrid1DrawCell
    OnKeyUp = StringGrid1KeyUp
    RowHeights = (
      24
      25
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 65528
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 65528
    object Colorinqueue1: TMenuItem
      Caption = 'Color - in queue'
      OnClick = Colorinqueue1Click
    end
    object ColorReady1: TMenuItem
      Caption = 'Color - complete'
      OnClick = ColorReady1Click
    end
    object Font1: TMenuItem
      Caption = 'Font...'
      OnClick = Font1Click
    end
  end
  object ColorDialog1: TColorDialog
    OnClose = ColorDialog1Close
    Left = 72
    Top = 65528
  end
  object ColorDialog2: TColorDialog
    OnClose = ColorDialog2Close
    Left = 104
    Top = 65528
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 136
    Top = 65528
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 168
    Top = 65528
  end
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 200
    Top = 65528
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnExecute = IdTCPServer1Execute
    Left = 232
    Top = 65528
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 264
    Top = 65528
  end
end
