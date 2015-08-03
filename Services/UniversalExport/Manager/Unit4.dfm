object Form4: TForm4
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form4'
  ClientHeight = 611
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 8
    Top = 31
    Width = 456
    Height = 562
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 1
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 168
  end
  object ADOQuery1: TADOQuery
    CursorType = ctStatic
    LockType = ltReadOnly
    ParamCheck = False
    Parameters = <>
    SQL.Strings = (
      'SELECT A.ID,ROW_NUMBER() OVER ( ORDER BY stt,'
      
        '       SIGN(stt*(stt-1))*CONVERT(INT,CASE WHEN NEXT_EXPORT<DATEA' +
        'DD(mi, A.INTERVAL,LAST_EXPORT) THEN NEXT_EXPORT ELSE DATEADD(mi,' +
        ' A.INTERVAL,LAST_EXPORT)END),'
      
        '                                                                ' +
        '                                  COALESCE(A.Priority,A.ID)     ' +
        '         '
      ') AS position ,'
      'A.stt,CASE stt'
      'WHEN 0 THEN '#39#1072#1082#1090#1080#1074#1080#1088#1086#1074#1072#1085#39
      'WHEN 1 THEN '#39#1074' '#1086#1078#1080#1076#1072#1085#1080#1080#39
      'WHEN 2 THEN '#39#1075#1086#1090#1086#1074#39
      'WHEN 3 THEN '#39#1073#1083#1086#1082#1080#1088#1086#1074#1072#1085#39
      'WHEN 4 THEN '#39#1085#1077' '#1088#1072#1079#1073#1083#1086#1082#1080#1088#1086#1074#1072#1085#39
      'WHEN 5 THEN '#39#1085#1077' '#1075#1086#1090#1086#1074#39
      'WHEN 6 THEN '#39#1088#1072#1079#1073#1083#1086#1082#1080#1088#1086#1074#1072#1085#39
      'WHEN 7 THEN '#39#1074#1099#1087#1086#1083#1085#1077#1085#39
      'END AS '#39'Status'#39
      ',   A.Interval, A.blocked, A.Last_Export, A.Next_Export FROM '
      '('
      
        'SELECT ex.ID, ex.Priority, ex.INTERVAL, ex.blocked,ex.LAST_EXPOR' +
        'T, ex.NEXT_EXPORT,'
      ' CASE  '
      ' '
      ' WHEN '
      #9'ex.LAST_EXPORT = 0 '
      #9'THEN 0+3*ISNULL(blocked,0)'
      ' WHEN '
      
        #9'CASE WHEN NEXT_EXPORT<DATEADD(mi, ex.INTERVAL,LAST_EXPORT) THEN' +
        ' NEXT_EXPORT ELSE DATEADD(mi, ex.INTERVAL,LAST_EXPORT) END <GETD' +
        'ATE()'
      
        #9'THEN 1+3*ISNULL(blocked,0)--=0,1/*'#39#1087#1088#1086#1089#1088#1086#1095#1077#1085#39'*/,4/*'#39#1085#1077' '#1088#1072#1079#1073#1083#1086#1082#1080 +
        #1088#1086#1074#1072#1085#39'*/'#9#9#9' '
      ' WHEN '
      #9'DATEDIFF(mi,LAST_EXPORT,NEXT_EXPORT)>0.666*[INTERVAL] '
      
        #9'THEN 6+1*ISNULL(blocked,1)--=1,7/*'#39#1074#1099#1087#1086#1083#1085#1077#1085#39'*/,6/*'#39#1088#1072#1079#1073#1083#1086#1082#1080#1088#1086#1074#1072 +
        #1085#39'*/ '
      ' WHEN'
      #9'NOT (DATEDIFF(mi,LAST_EXPORT,NEXT_EXPORT)>0.666*[INTERVAL])'
      #9'THEN 2+3*ISNULL(blocked,0)--=0,2/*'#39#1075#1086#1090#1086#1074#39'*/, 5/*'#39#1085#1077' '#1075#1086#1090#1086#1074#39'*/) '
      ' '#9' '
      ' END'#9'AS stt'
      'FROM Exports ex'#9
      #9
      ') AS A'#9
      'WHERE A.stt IS NOT NULL')
    Left = 136
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = Timer1Timer
    Left = 104
  end
end
