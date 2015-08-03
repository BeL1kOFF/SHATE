Attribute VB_Name = "Module1"
Option Explicit

#If VBA7 Then
    Public Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As LongPtr) 'For 64 Bit Systems
#Else
    Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long) 'For 32 Bit Systems
#End If
'21.05.2015
Const PATH_FILEEXE = "\\svbyprisa0114\applications\WHSalaryTable\ReportSynchronizer.exe" '"c:\Users\shingarev\Documents\RAD Studio\Projects\PercoDataLoader\Utility\Project1.exe" '
Public Const CLMNTABEL = "J"
Public Const ROWDATES = 7

Const HOURSHIFT = 7

Public wshmain As Worksheet
Public Date0 As Date
Public Date1 As Date
Public DateD As Date

Public TabelRow0 As Integer
Public TabelRowFin As Integer

Function LetterIndex(ByVal clmn As String) As Integer
   LetterIndex = 0
   
   Dim c As String
   Dim l As Integer
      
   clmn = UCase(clmn)
   
   Do
    l = Len(clmn)
    c = Left(clmn, 1)
    clmn = Right(clmn, l - 1)
    LetterIndex = LetterIndex * 26 + Asc(c) - 64
   Loop Until l = 1
   
   End Function



Sub RunSynchr()

   Set wshmain = ThisWorkbook.ActiveSheet
   
   Dim ProcID
   
   
   Call TabelRangeSelect(ThisWorkbook.ActiveSheet, TabelRow0, TabelRowFin)
   Call DateRangeSelect(ThisWorkbook.ActiveSheet, Date1, DateD)
   
   Date0 = Date1
   Call SynchronizeInterval(Date0, DateD)
      
   Dim ParamsFile As String
   If (Date0 = DateD + 1) And (Date0 = DateAdd("m", 1, Date1)) Then
    ParamsFile = " "
    ProcID = Shell(PATH_FILEEXE & " """ & ThisWorkbook.FullName & """ " & ActiveSheet.Name & " " & Int(CDbl(Date1)) & " " & Int(CDbl(DateD)) & " " & 1 + TabelRowFin - TabelRow0 & " " & ParamsFile, vbNormalFocus)
    Exit Sub
   End If
   ParamsFile = GenerateParamsFile(ThisWorkbook.Path)
   If ParamsFile <> "" Then
    ParamsFile = """" & ParamsFile & """" 'ThisWorkbook.Path & "\" &
   End If
   ThisWorkbook.Activate
   'ActiveSheet.Protect
   'Range(wshmain.Cells(TabelRow0, LetterIndex(CLMNTABEL) + 1), wshmain.Cells(TabelRowFin, LetterIndex(CLMNTABEL) + 1 + (Date1 - DateD))).Select
   'MsgBox PATH_FILEEXE & " """ & ThisWorkbook.FullName & """ " & ActiveSheet.Name & " " & Int(CDbl(Date1)) & " " & Int(CDbl(DateD)) & " " & 1 + TabelRowFin - TabelRow0 & " " & ParamsFile
   ProcID = Shell(PATH_FILEEXE & " """ & ThisWorkbook.FullName & """ " & ActiveSheet.Name & " " & Int(CDbl(Date0)) & " " & Int(CDbl(DateD)) & " " & 1 + TabelRowFin - TabelRow0 & " " & ParamsFile, vbNormalFocus)
   'If WaitForProcess(ProcID, 60) Then
   ' ThisWorkbook.Activate
   ' MsgBox "Внешний загрузчик данных свою работу завершил!"
   'Else
   ' MsgBox "Время ожидания операции истекло"
   'End If
   'ActiveSheet.Unprotect
   
   
   'Call Shell(PATH_FILEEXE & " """ & ThisWorkbook.FullName & """ " & ActiveSheet.Name & " " & Int(CDbl(Now()) - 365 - 19) & " " & Int(CDbl(Now()) - 365 - 19 + 31) & " 10", vbNormalFocus)
End Sub

Function WorksheetIndex(Wbk As Workbook, namewsh As String) As Integer
    WorksheetIndex = 0
    Dim k As Integer
    For k = 1 To Wbk.Sheets.Count
        If Wbk.Sheets(k).Name = namewsh Then
            WorksheetIndex = k
            Exit Function
        End If
    Next k
End Function

Function NextMonth(ByVal DatePrev As Date, ByVal DateNext As Date) As Boolean
    NextMonth = (12 * Year(DateNext) + Month(DateNext) > 12 * Year(DatePrev) + Month(DatePrev))
End Function

Sub DateRangeSelect(ByVal wsh As Worksheet, ByRef Date0 As Date, ByRef DateFin As Date)
    Dim i As Integer
    Dim j As Integer
    
    Dim i0 As Integer
    Dim j0 As Integer
    
    
    
    i0 = ROWDATES
    j0 = 0
    j = LetterIndex(CLMNTABEL) + 1
    Do
      If IsDate(wsh.Cells(i0, j).Value) Then
        j0 = j
        Date0 = wsh.Cells(i0, j).Value
        Exit Do
       Else
        j = j + 1
      End If
    Loop Until j > 100
    
    If j0 = 0 Then Exit Sub
    
    Do
      If IsDate(wsh.Cells(i0, j).Value) Then
        DateFin = wsh.Cells(i0, j).Value
        j = j + 1
      Else
        Exit Do
      End If
    Loop Until j - j0 > 31
    
    

    wsh.Activate
    
    Range(wsh.Cells(i0, j0), wsh.Cells(i0, j - 1)).Select
End Sub

Sub SynchronizeInterval(ByRef dateBegin As Date, ByRef dateEnd As Date)
    If dateEnd > Now() - 1 Then dateEnd = Fix(Now()) - 1
        
    Dim timesindex As Integer
    timesindex = WorksheetIndex(ThisWorkbook, "Times")
    If timesindex > 0 Then
        On Error Resume Next
        Dim wshTimes As Worksheet
        Set wshTimes = ThisWorkbook.Worksheets(timesindex)
        If IsDate(wshTimes.Cells(ROWDATES, 1).Value) Then
            Dim dd As Integer
            dd = 0
            While wshTimes.Cells(ROWDATES, 1 + dd) = dateBegin + dd
                dd = dd + 1
            Wend
            If dd > 0 Then
                While wshTimes.Cells(ROWDATES, dd + 1) > ""
                    wshTimes.Columns(dd + 1).Delete
                Wend
                Dim tt As Integer
                For tt = TabelRow0 To TabelRowFin
                    Dim TabLenMain As Integer
                    Dim TabLenTimes As Integer
                    If wshmain.Cells(tt, CLMNTABEL) <> wshTimes.Cells(tt, dd + 1) Then
                        TabLenMain = Len(Trim(wshmain.Cells(tt, CLMNTABEL)))
                        TabLenTimes = Len(Trim(wshTimes.Cells(tt, dd + 1)))
                        If TabLenMain * TabLenTimes * (TabLenMain - TabLenTimes) <> 0 Then Exit Sub
                    End If
                Next tt
            End If
            dateBegin = dateBegin + dd
            
            Dim c As Integer
            For c = 1 To dateEnd - dateBegin + 1
                wshTimes.Columns(dd + 1).Insert
            Next c
        End If
    End If
End Sub


Sub TabelRangeSelect(ByVal wsh As Worksheet, ByRef rowstart, ByRef rowfin)
    Dim i As Integer
    Dim j As Integer
    
    Dim i0 As Integer
    Dim j0 As Integer
    
    j0 = LetterIndex(CLMNTABEL)
    i0 = 0
    
    i = ROWDATES + 1
    Do
      If Len(wsh.Cells(i, j0).Value) = 5 Then
        i0 = i
        rowstart = i
        Exit Do
       Else
        i = i + 1
      End If
    Loop Until i > 100
    
    If i0 = 0 Then Exit Sub
    
    Do
      If Len(wsh.Cells(i, j0).Value) = 5 Then
        rowfin = i
        i = i + 1
      Else
        If Trim(wsh.Cells(i, j0).Text) = "" Then
            i = i + 1
        Else
            'MsgBox Asc(wsh.Cells(i, j0).Text)
            Exit Do
        End If
      End If
    Loop Until (Range(CLMNTABEL & i).Borders.LineStyle <> xlContinuous)
    
    wsh.Activate
    
    Range(wsh.Cells(rowstart, j0), wsh.Cells(rowfin, j0)).Select
End Sub

Function WriteLines(ByVal wsh As Worksheet) As Integer
    Const CLMNTABNO = "A"
    Const CLMND0 = "B"
    Const CLMNDFIN = "C"
    Const CLMNHOURSHIFT = "D"
    
    Dim k As Integer
    k = 0
    
    Dim tt As String
    wsh.Cells(1, CLMNTABNO).Value = "TABNO"
    wsh.Cells(1, CLMND0).Value = "D0"
    wsh.Cells(1, CLMNDFIN).Value = "DFIN"
    wsh.Cells(1, CLMNHOURSHIFT).Value = "HOURSHIFT"
    k = k + 1
    Dim i As Integer
    For i = TabelRow0 To TabelRowFin
        tt = Trim(wshmain.Cells(i, LetterIndex(CLMNTABEL)).Text)
        
        If Len(tt) = 5 Then
            k = k + 1
            wsh.Cells(k, CLMNTABNO).NumberFormat = "@"
            wsh.Cells(k, CLMND0).NumberFormat = "dd.mm.yyyy"
            wsh.Cells(k, CLMNDFIN).NumberFormat = "dd.mm.yyyy"
            
            wsh.Cells(k, CLMNTABNO).Value = tt
            wsh.Cells(k, CLMND0).Value = Date0
            wsh.Cells(k, CLMNDFIN).Value = DateD + 1
            wsh.Cells(k, CLMNHOURSHIFT).Value = HOURSHIFT
        End If
    Next i
    
    WriteLines = k
End Function



Function GenerateParamsFile(ByVal Path As String) As String
    Const TABELSWSH = "TabelsList"
    Dim Wbk As Workbook
    Dim wsh As Worksheet
    Set Wbk = Application.Workbooks.Add
    
    Set wsh = Wbk.Worksheets.Add
        wsh.Name = TABELSWSH
    
        Dim k As Integer
        k = WriteLines(wsh)
        
        If k > 0 Then
            If Path = "" Then Path = Wbk.Path Else: Path = Path & "\"
            Application.DisplayAlerts = False
            Wbk.SaveAs Filename:=Path & TABELSWSH, FileFormat:=xlCSV, Local:=True  '& "0.csv"
            Application.DisplayAlerts = True
        End If
        Wbk.Close (False)
        GenerateParamsFile = Path & TABELSWSH & ".csv"
End Function

Function WaitForProcess(ByVal id As Long, ByVal MinutesTimeout As Integer) As Boolean
    Const DeltaHours = 1
    Const SLEEPINTERVAL = 100
    Dim t0 As Date
    Dim t As Date
    
    Dim collSWbemObjectSet As Object
    Dim objSWbemObjectEx As Object
    WaitForProcess = False
    t0 = Now()
    With CreateObject("WbemScripting.SWbemLocator")
        With .ConnectServer(".", "root\cimv2")
          Dim cnt As Integer
          cnt = 0
          Do
            DoEvents
            Sleep SLEEPINTERVAL
            Set collSWbemObjectSet = .ExecQuery("SELECT * FROM Win32_Process WHERE ProcessId = " & id)
            cnt = collSWbemObjectSet.Count
            Set collSWbemObjectSet = Nothing
            t = Now()
            If (t - t0) * 24 * 60 > MinutesTimeout Then Exit Function
          Loop Until cnt = 0
          WaitForProcess = (cnt = 0)
        End With
    End With
End Function

Sub RunUnSynchr()
    Dim MsgStr As String
    Dim mr
    MsgStr = "Выполнить сброс отчёта?"
    MsgStr = MsgStr & Chr(13) & Chr(10) & "Все вспомогательные данные будут удалены. Продолжить?"
    mr = MsgBox(MsgStr, vbYesNo Or vbExclamation, "Рассинхронизация отчёта")
    If mr <> vbYes Then Exit Sub
    
    Dim pass As String
    
    pass = InputBox("Для выполнения операции введите пароль", "Проверка пользователя", "******")
    If pass <> "пароль" Then Exit Sub
    
    On Error Resume Next
    Application.DisplayAlerts = False
    
    Dim wshNo As Integer

    wshNo = Module1.WorksheetIndex(ThisWorkbook, "Enters")
    If wshNo > 0 Then ThisWorkbook.Sheets(wshNo).Delete
    wshNo = Module1.WorksheetIndex(ThisWorkbook, "Exits")
    If wshNo > 0 Then ThisWorkbook.Sheets(wshNo).Delete
    
    wshNo = Module1.WorksheetIndex(ThisWorkbook, "Times")
    If wshNo > 0 Then ThisWorkbook.Sheets(wshNo).Delete
    
    wshNo = Module1.WorksheetIndex(ThisWorkbook, "RepScan")
    If wshNo > 0 Then ThisWorkbook.Sheets(wshNo).Delete
    
    Application.DisplayAlerts = True
End Sub


