{ **** UBPFD *********** by delphibase.endimus.com ****
>> «апуск и закрытие Excel, добавление и удаление книг и листов

Ќа данный момент работает:
- вызов и закрытие Excel
- добавление новых, открытие ранее созданных и удаление рабочих книг
- добавление и удаление листов в рабочие книги

«ависимости: ComObj, SysUtils,Dialogs,Controls;
јвтор:       lookin, lookin@mail.ru, ≈катеринбург
Copyright:   lookin
ƒата:        04 ма€ 2002 г.
***************************************************** }

unit MSExcel;

interface

uses ComObj, SysUtils, Dialogs, Controls;

function CallExcel(Show: boolean): boolean;
procedure CloseExcel;
procedure AddWorkBook(WorkBookName: Ansistring);
procedure OpenWorkBook(WorkBookName: Ansistring);
procedure CloseWorkBook(WorkBookName: Ansistring);
function ActivateWorkBook(WorkBookName: Ansistring): boolean;
function ActivateWorkSheet(WorkBookName, WorkSheetName: Ansistring): boolean;
function WorkBookIndex(WorkBookName: Ansistring): integer;
function WorkSheetIndex(WorkBookName, WorkSheetName: Ansistring): integer;
procedure CheckExtension(Name: Ansistring);
function AddWorkSheet(WorkBookName, WorkSheetName: Ansistring): boolean;
procedure DeleteWorkSheet(WorkBookName, WorkSheetName: Ansistring);

function ReadCellValue(WorkSheetName: string; RowIndex, ColumnIndex: integer): Variant;
function SetCellFormat(WorkSheetName: string; RowIndex, ColumnIndex: integer; format: string): boolean;
function GetCellFormat(WorkSheetName: string; RowIndex, ColumnIndex: integer): string;
function WriteCellValue(WorkSheetName: string; RowIndex, ColumnIndex: integer; Value: Variant): boolean;

const
  FMTTEXT = '@';
  FMTNUMBER = '0.00';
  FMTDATE = 'm/d/yyyy';
var
  Excel: Variant;

implementation

uses Variants;

function CallExcel(Show: boolean): boolean;
begin
  RESULT := True;
  if VarIsEmpty(Excel) = true then
  begin
    try
      Excel := GetActiveOleObject('Excel.Application');
      RESULT := True;
    except
      on EOleSysError do
        Excel := CreateOleObject('Excel.Application');
    end;

    if Show then
      Excel.Visible := true;
  end;
end;

procedure CloseExcel;
begin
  if VarIsEmpty(Excel) = false then
  begin
    Excel.Quit;
    Excel := 0;
  end;
end;

procedure AddWorkBook(WorkBookName: Ansistring);
var
  k: integer;
begin
  CheckExtension(WorkBookName);
  if VarIsEmpty(Excel) = true then
  begin
    Excel := CreateOleObject('Excel.Application');
    Excel.Visible := true;
  end;
  k := WorkBookIndex(WorkBookName);
  if k = 0 then
  begin
    Excel.Workbooks.Add;
    Excel.ActiveWorkbook.SaveCopyAs(FileName := WorkBookName);
    Excel.ActiveWorkbook.Close;
    Excel.Workbooks.Open(WorkBookName);
  end
  else
    MessageDlg(' нига с таким именем уже существует.', mtWarning, [mbOk], 0);
end;

procedure OpenWorkBook(WorkBookName: Ansistring);
var
  k: integer;
begin
  CheckExtension(WorkBookName);
  if VarIsEmpty(Excel) = true then
  begin
    Excel := CreateOleObject('Excel.Application');
    Excel.Visible := true;
  end;
  k := WorkBookIndex(WorkBookName);
  if k = 0 then
    Excel.Workbooks.Open(WorkBookName)
  else
    MessageDlg(' нига с таким именем уже открыта.', mtWarning, [mbOk], 0);
end;

procedure CloseWorkBook(WorkBookName: Ansistring);
var
  k: integer;
begin
  if VarIsEmpty(Excel) = false then
  begin
    k := WorkBookIndex(WorkBookName);
    if k <> 0 then
      Excel.ActiveWorkbook.Close(WorkBookName)
    else
      MessageDlg(' нига с таким именем отсутствует.', mtWarning, [mbOk], 0);
  end;
end;

function ActivateWorkBook(WorkBookName: Ansistring): boolean;
var
  k: integer;
begin
  RESULT := False;
  if VarIsEmpty(Excel) = false then
  begin
    k := WorkBookIndex(WorkBookName);
    if k <> 0 then
      Excel.WorkBooks[k].Activate
     else
      Excel.Workbooks.Open(WorkBookName);
  end;
end;

function ActivateWorkSheet(WorkBookName, WorkSheetName: Ansistring): boolean;
var
  k, j: integer;
begin
  Result := False;
  if VarIsEmpty(Excel) = false then
  begin
    k := WorkBookIndex(WorkBookName);
    j := WorkSheetIndex(WorkBookName, WorkSheetName);
    if j <> 0 then
      Excel.WorkBooks[k].Sheets[j].Activate;
  end;
end;

function AddWorkSheet(WorkBookName, WorkSheetName: Ansistring): boolean;
var
  k, j: integer;
  MainSheet: Variant;
begin
  RESULT := True;
  if VarIsEmpty(Excel) = false then
  begin
    k := WorkBookIndex(WorkBookName);
    if k <> 0 then
    begin
      Excel.DisplayAlerts := False;
      MainSheet := Excel.Workbooks[k].ActiveSheet;
      Excel.Workbooks[k].Sheets.Add(EmptyParam, Excel.Workbooks[k].Sheets[Excel.Workbooks[k].Sheets.Count]);
      j := WorkSheetIndex(WorkBookName, WorkSheetName);
      if j = 0 then
        Excel.Workbooks[k].ActiveSheet.Name := WorkSheetName;
      Excel.Workbooks[k].Sheets[MainSheet.Name].Activate;
      Excel.DisplayAlerts := True;
    end;
  end;
end;

procedure DeleteWorkSheet(WorkBookName, WorkSheetName: Ansistring);
var
  k, j: integer;
begin
  if VarIsEmpty(Excel) = false then
  begin
    k := WorkBookIndex(WorkBookName);
    Excel.DisplayAlerts := false;
    j := WorkSheetIndex(WorkBookName, WorkSheetName);
    if j <> 0 then
      Excel.Workbooks[k].Sheets[j].Delete
    else
      MessageDlg('Ћиста с таким именем в этой книге нет.', mtWarning, [mbOk],
        0);
  end;
end;

procedure CheckExtension(Name: Ansistring);
var
  s: string;
begin
  //проверка расширени€
  s := ExtractFileExt(Name);
  if LowerCase(s) <> '.xls' then
    if
      MessageDlg('¬ы задали им€ книги с нестандартным расширением. ѕродолжить?',
      mtWarning, [mbYes, mbCancel], 0) = mrCancel then
      Abort;
end;

function WorkBookIndex(WorkBookName: Ansistring): integer;
var
  i, n: integer;
begin
  //проверка на наличие книги с этим именем
  n := 0;
  if VarIsEmpty(Excel) = false then
    for i := 1 to Excel.WorkBooks.Count do
      if Excel.WorkBooks[i].FullName = WorkBookName then
      begin
        n := i;
        break;
      end;
  WorkBookIndex := n;
end;

function WorkSheetIndex(WorkBookName, WorkSheetName: Ansistring): integer;
var
  i, k, n: integer;
begin
  //проверка на наличие листа с этим именем в книге с этим именем
  n := 0;
  if VarIsEmpty(Excel) = false then
  begin
    k := WorkBookIndex(WorkBookName);
    for i := 1 to Excel.WorkBooks[k].Sheets.Count do
      if Excel.WorkBooks[k].Sheets[i].Name = WorkSheetName then
      begin
        n := i;
        break;
      end;
  end;
  WorkSheetIndex := n;
end;

function ReadCellValue(WorkSheetName: string; RowIndex, ColumnIndex: integer): Variant;
begin
  RESULT := NULL;
  try
    RESULT := Excel.Application.Worksheets.Item[WorkSheetName].Cells.Item[RowIndex,ColumnIndex].Value;
  except
    RESULT := #$D#$A;
  end;
end;
function WriteCellValue(WorkSheetName: string; RowIndex, ColumnIndex: integer; Value: Variant): boolean;
begin
  RESULT := False;
 try
  Excel.Application.Worksheets.Item[WorkSheetName].Cells.Item[RowIndex,ColumnIndex].Value := Value;
  RESULT := True;
 except
   ;
 end;
end;

function SetCellFormat(WorkSheetName: string; RowIndex, ColumnIndex: integer; format: string): boolean;
begin
  Result := False;
  Excel.Application.Worksheets.Item[WorkSheetName].Cells.Item[RowIndex,ColumnIndex].NumberFormat := format;
end;

function GetCellFormat(WorkSheetName: string; RowIndex, ColumnIndex: integer): string;
begin
  RESULT := '';
  try
    RESULT := Excel.Application.Worksheets.Item[WorkSheetName].Cells.Item[RowIndex,ColumnIndex].NumberFormat;
  except

  end;
end;
end.