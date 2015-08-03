VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ЭтаКнига"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit
'25.05.2015
Const DDMMDATEFORMAT = "[$-419]d mmm;@"

Public Function ProcessSyncClick(rng As Range) As Boolean
    Const REPSCANTAG = "Оплата, сборка"
    Const CLMNMAP = 5
    Const CLMNVAL = 4
    Const CLMNNUM = 3
    
    Const THRSHLDNUM = 10000
    ProcessSyncClick = False
    Dim answer
    

    
    On Error Resume Next
    Dim wshManuscript As Worksheet
    Set wshManuscript = ThisWorkbook.Sheets("Manuscript")
    Dim wshTimes As Worksheet
    Set wshTimes = ThisWorkbook.Sheets("Times")


    
    If rng.Row > Module1.ROWDATES And wshManuscript.Cells(rng.Row, rng.Column) > "" Then
        On Error Resume Next
        Dim CommentStr As String
        CommentStr = "Значение для восстановления = " & wshManuscript.Cells(rng.Row, rng.Column)
        If Not (rng.Comment Is Nothing) Then
            CommentStr = CommentStr & Chr(10) & Chr(10) & rng.Comment.Text
        End If
        If Not (Range(wshManuscript.Cells(rng.Row, rng.Column), wshManuscript.Cells(rng.Row, rng.Column)).Comment Is Nothing) Then
            CommentStr = CommentStr & Chr(10) & Chr(10) & "Примечание:"
            CommentStr = CommentStr & Chr(10) & Range(wshManuscript.Cells(rng.Row, rng.Column), wshManuscript.Cells(rng.Row, rng.Column)).Comment.Text
        End If
        answer = MsgBox("Восстановить оригинальное значение в ячейке?" & Chr(10) & CommentStr, vbYesNo, wshManuscript.Cells(rng.Row, rng.Column))
        If answer = vbYes Then
            rng.Value = wshManuscript.Cells(rng.Row, rng.Column)
            rng.Interior.Color = Range(wshManuscript.Cells(rng.Row, rng.Column), wshManuscript.Cells(rng.Row, rng.Column)).Interior.Color
            rng.Font.Color = Range(wshManuscript.Cells(rng.Row, rng.Column), wshManuscript.Cells(rng.Row, rng.Column)).Font.Color
            rng.Comment.Delete
            If Not Range(wshManuscript.Cells(rng.Row, rng.Column), wshManuscript.Cells(rng.Row, rng.Column)).Comment Is Nothing Then
                rng.NoteText Range(wshManuscript.Cells(rng.Row, rng.Column), wshManuscript.Cells(rng.Row, rng.Column)).Comment.Text
            End If
        Else
            rng.Comment.Visible = False
        End If
        
        ProcessSyncClick = rng.Font.Bold
    End If
    
    
    If rng.Value = REPSCANTAG Then
        If (Module1.Date1 = 0) Or (Module1.DateD = 0) Then
            Dim MsgStr As String
            MsgStr = "Перед заполнением необходима синхронизация данных со внешним источником"
            MsgStr = MsgStr & Chr(13) & Chr(10) & "Выполнить синхронизацию сейчас?"
            Dim mr
            mr = MsgBox(MsgStr, vbYesNo Or vbExclamation, "RepScan")
            If mr = vbYes Then
                Call Module1.RunSynchr
            End If
            Exit Function
        Else ' синхронизация производилась - требуется проверка полного периода для заполнения строк
            If Module1.NextMonth(Module1.DateD, Now) And Module1.NextMonth(Module1.DateD, Module1.DateD + 1) Then
                If Module1.WorksheetIndex(ThisWorkbook, "RepScan") = 0 Then
                    'Dim MsgStr As String
                    MsgStr = "Будет произведён вызов загрузки строк"
                    'Dim mr
                    mr = MsgBox(MsgStr, vbOKCancel Or vbInformation, "RepScan")
                    If mr = vbOK Then
                        Call Module1.RunSynchr
                    End If
                    Exit Function
                End If
            Else
                MsgBox "Невозможно получить итоговое количество строк для неполного месяца"
            End If
        End If
        
        answer = MsgBox("Выполнить заполнение данными из RepScan?", vbYesNo)
        If answer <> vbYes Then Exit Function
        
        Dim wshRepScan As Worksheet
        On Error Resume Next
        Set wshRepScan = ThisWorkbook.Sheets("RepScan")
        If wshRepScan Is Nothing Then
            MsgBox "Перед заполнением необходима синхронизация данных со внешним источником", vbCancel, "RepScan"
            Exit Function
        End If
        Dim k As Integer
        For k = 1 To Module1.TabelRowFin - Module1.TabelRow0
            If wshRepScan.Cells(k, CLMNMAP) = "" Then Exit For
            'Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).Select
            
            wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column) = wshRepScan.Cells(k, CLMNVAL)
            
            If wshRepScan.Cells(k, CLMNVAL) > 0 Then
            On Error Resume Next
                Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).Comment.Delete
                Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).AddComment
                Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).Comment.Text ("Число строк:" & wshRepScan.Cells(k, CLMNNUM))
                
                If wshRepScan.Cells(k, CLMNNUM) > THRSHLDNUM Then
                On Error Resume Next
                    Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).Interior.Color = vbRed
                    Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).Font.Color = vbBack
                    Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).Comment.Visible = True
                End If
                
                Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).Comment.Shape.ScaleHeight 0.2, msoFalse, msoScaleFromTopLeft
                Range(wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column), wshmain.Cells(wshRepScan.Cells(k, CLMNMAP), rng.Column)).Comment.Shape.ScaleWidth 0.8, msoFalse, msoScaleFromTopLeft
            End If
        Next k
        
        ProcessSyncClick = True
    End If
    
    If rng.NumberFormat <> DDMMDATEFORMAT Then Exit Function

    Application.DisplayCommentIndicator = xlCommentIndicatorOnly
    Application.DecimalSeparator = "."
    
    If rng.Font.Bold Then
    On Error Resume Next
        If wshManuscript.Cells(rng.Row, rng.Column) = rng.Value Then
            answer = MsgBox("Данные указанной даты уже были синхронизированы. Восстановить оригинальное значение в столбце?", vbYesNo, rng.Value)
            If answer = vbYes Then
                Dim r As Integer
                For r = Module1.TabelRow0 To Module1.TabelRowFin
                    If wshManuscript.Cells(r, rng.Column) > "" Then
                        wshmain.Cells(r, rng.Column) = wshManuscript.Cells(r, rng.Column)
                        Range(wshmain.Cells(r, rng.Column), wshmain.Cells(r, rng.Column)).Interior.Color = Range(wshManuscript.Cells(r, rng.Column), wshManuscript.Cells(r, rng.Column)).Interior.Color
                        Range(wshmain.Cells(r, rng.Column), wshmain.Cells(r, rng.Column)).Font.Color = Range(wshManuscript.Cells(r, rng.Column), wshManuscript.Cells(r, rng.Column)).Font.Color
                        Range(wshmain.Cells(r, rng.Column), wshmain.Cells(r, rng.Column)).Font.Bold = False
                    On Error Resume Next
                        Range(wshmain.Cells(r, rng.Column), wshmain.Cells(r, rng.Column)).Comment.Delete
                    End If
                Next r
                wshManuscript.Cells(rng.Row, rng.Column) = ""
                rng.Font.Bold = False
                ProcessSyncClick = True
            Else
                MsgBox ("Дата написанная жирным шрифтом воспринимается как признак синхронизации столбца")
            End If
            Exit Function
        End If
    End If
    
    If rng.Value > Int(Now() - 1) Then
        MsgBox "Не истёк срок указанной даты", vbCancel, rng.Value
    End If
    
    If (Module1.Date1 = 0) Or (Module1.DateD = 0) Then
        answer = MsgBox("Перед заполнением необходима синхронизация данных со внешним источником", vbYes, rng.Value)
        ProcessSyncClick = True
        Exit Function
    End If
    

    
    Dim d As Integer
    d = rng.Column - CInt(1 + CDbl(rng.Value) - CDbl(Module1.Date1))
    If (d < 0) Then Exit Function 'Else j = j - d
    
    If CDate(rng.Value) <> CDate(wshTimes.Cells(rng.Row, rng.Column - d)) Then Exit Function

    answer = MsgBox("Выполнить заполнение для указанной даты?", vbYesNo, rng.Value)
    ProcessSyncClick = (answer = vbYes)
    If ProcessSyncClick Then
        'MsgBox ActiveCell.Value
        Dim i As Integer
        Dim j As Integer
        
        'MsgBox Module1.wshmain.Name
        'MsgBox ThisWorkbook.Sheets("Times").Name
        Dim Sync As Boolean
        Sync = True
        For i = Module1.TabelRow0 To Module1.TabelRowFin
            On Error Resume Next
            Sync = Sync And SynchrCellBusnessValue(rng, i, d, Module1.wshmain, ThisWorkbook.Sheets("Times"), ThisWorkbook.Sheets("Manuscript"))
            
            'If Not Sync Then
            '    Range(Module1.wshmain.Cells(i, rng.Row)).Interior.Pattern = xlGray8
            'End If
        Next i
        
        If (i > Module1.TabelRowFin) Then
            wshManuscript.Cells(rng.Row, rng.Column) = rng.Value
            rng.Font.Bold = Sync
        End If
    End If
End Function


Function SynchrCellBusnessValue(daterng As Range, r As Integer, delta As Integer, wshWork As Worksheet, wshTimes As Worksheet, wshManuscript As Worksheet) As Boolean
    Const OBSERVANCELIMIT = 0.5
    SynchrCellBusnessValue = False
    
    Dim wshEnters As Worksheet
    Set wshEnters = ThisWorkbook.Sheets("Enters")
    Dim wshExits As Worksheet
    Set wshExits = ThisWorkbook.Sheets("Exits")
    
    Dim i As Integer
    Dim j As Integer
    i = r
    j = daterng.Column
    If (i < Module1.TabelRow0) Or (i > Module1.TabelRowFin) Then Exit Function
    
    Dim d As Integer
    If delta = 0 Then
        d = daterng.Column - CInt(1 + CDbl(daterng.Value) - CDbl(Module1.Date1))
        If (d < 0) Then Exit Function 'Else j = j - d
    Else
        d = delta
    End If
    If CDate(wshWork.Cells(Module1.ROWDATES, daterng.Column)) <> CDate(wshTimes.Cells(Module1.ROWDATES, j - d)) Then Exit Function
    
    Dim CellText As String
    CellText = wshWork.Cells(i, j)
    
    Dim CellPercoValue As String
    CellPercoValue = wshTimes.Cells(i, j - d)
        
    Dim isRewritedValue As Boolean
    Dim isPercoValuePresent As Boolean
    Dim nonObservance As Boolean

    Dim isCellHoliday As Boolean
    
    
    isCellHoliday = (UCase(CellText) = "B" Or UCase(CellText) = "В")
    
    isPercoValuePresent = CellPercoValue > ""
    
    
    
    
    Dim Switch As Integer
    
    Switch = 0
       
    
    
    If IsNumeric(CellText) And CellPercoValue = "" Then CellPercoValue = "0"
    If IsNumeric(CellPercoValue) Then Switch = 1  'isPercoValuePresent And
    
    If IsNumeric(CellText) Then
        If IsNumeric(CellPercoValue) And IsNumeric(CellText) Then
            nonObservance = (CDbl(wshWork.Cells(i, j)) - CDbl(wshTimes.Cells(i, j - d))) > OBSERVANCELIMIT
        End If
         'Else Switch = Switch
     Else
       If CellText > "" Then Switch = 2 * Switch
    End If
    If wshTimes.Cells(i, j - d) < OBSERVANCELIMIT Then Switch = -1 * Switch
    If isCellHoliday Then Switch = Sgn(Switch) * (1 + Sgn(Switch)) ' -1-->(-1)*0 = 0, 1-->1*2=2, 2-->1*2=2 0-->0*1=0
    
    If Abs(Switch) = 1 Then
        On Error Resume Next
        With Range(wshManuscript.Cells(i, j), wshManuscript.Cells(i, j))
            .Value = Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Value
            .Font.Color = Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Font.Color
            .Interior.Color = Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Interior.Color
            If .Comment Is Nothing Then .AddComment (Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Text)
        End With
    End If
    
    Dim EnterTime As String
    Dim ExitTime As String
    
    EnterTime = ""
    ExitTime = ""
    
    If wshEnters.Cells(i, j - d) > "" Then EnterTime = Chr(10) & "Вход: " & wshEnters.Cells(i, j - d).Text
    If wshExits.Cells(i, j - d) > "" Then ExitTime = Chr(10) & "Выход: " & wshExits.Cells(i, j - d).Text
    
    Select Case Switch
       Case -1
        Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Interior.Color = vbRed
        Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Font.Color = vbBack
        Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Font.Bold = True
        Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).AddComment
        If EnterTime & ExitTime = "" Then
            Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Text "Нет данных"
        Else: Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Text (EnterTime & ExitTime)
        End If
       Case 1
        wshWork.Cells(i, j) = CellPercoValue
        Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Font.Bold = True
        Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).AddComment
        
        If nonObservance Then
            Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Text ("Нарушение! <" & CellText & EnterTime & ExitTime)
            Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Visible = True
            Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Shape.ScaleHeight 0.8, msoFalse, msoScaleFromTopLeft
            Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Shape.ScaleWidth 0.8, msoFalse, msoScaleFromTopLeft
    
        Else
            Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Text ("Оригинальное значение: " & CellText & EnterTime & ExitTime)
        End If
       Case 2
        Dim CommentStr As String
        
        If (Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment Is Nothing) Then
            Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).AddComment
            CommentStr = ""
        Else
            CommentStr = Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Text
            'If InStr(1, CommentStr, Chr(10)) Then CommentStr = "" Else CommentStr = CommentStr & Chr(10)
        End If
        CommentStr = CommentStr & "Присутствие по Perco: " & CellPercoValue & " часов" & EnterTime & ExitTime
        Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Text (CommentStr)
        'Range(wshWork.Cells(i, j), wshWork.Cells(i, j)).Comment.Visible = True
    End Select
    
    SynchrCellBusnessValue = True
End Function


Function CopyRepScanData(wshRepScan As Worksheet, ByVal i As Integer, ByVal j As Integer) As Boolean

End Function






