unit ERP.Package.CustomGlobalFunctions.ExcelFunctions;

interface

uses
  Data.DB,
  cxProgressBar,
  cxGridCustomTableView,
  Excel_TLB;

procedure ExportQueryToExcel(aQuery: TDataSet; aDataController: TcxGridDataController; aVisible: Boolean;
  const aSheetName, aFileName: string; aProgressBar: TcxProgressBar);
procedure ImportQueryFromExcel(aQuery: TDataSet; const aSheetName, aFileName: string);

implementation

uses
  Winapi.Windows,
  System.Variants,
  System.SysUtils;

type
  ExceptionExportExcel = class(Exception);
  ExceptionImportExcel = class(Exception);

procedure ExportQueryToExcel(aQuery: TDataSet; aDataController: TcxGridDataController; aVisible: Boolean;
  const aSheetName, aFileName: string; aProgressBar: TcxProgressBar);
var
  Loc: LCID;
  k, i: Integer;
  ColIndex: Integer;
  ColCount: Integer;
  Excel: _Application;
  Wb: _Workbook;
  Ws: _Worksheet;
  Cells: ExcelRange;
  CellsHeader: ExcelRange;

  function GetCheckFromFieldName(const aFieldName: string): Boolean;
  var
    k: Integer;
  begin
    for k := 0 to aDataController.RecordCount - 1 do
      if SameText(aDataController.Values[k, 0], aFieldName) then
        Exit(aDataController.Values[k, 2]);
    raise ExceptionExportExcel.CreateFmt('Столбец %s не найден!', [aFieldName]);
  end;

  procedure IncProgress;
  begin
    if Assigned(aProgressBar) then
    begin
      aProgressBar.Position := aProgressBar.Position + 1;
      aProgressBar.Refresh();
    end;
  end;

begin
  if Assigned(aProgressBar) then
  begin
    aProgressBar.Properties.Min := 0;
    aProgressBar.Properties.Max := aQuery.RecordCount + 1 + 1 + 1 + 1;
    aProgressBar.Position := 0;
  end;
  Loc := GetUserDefaultLCID();
  Excel := CoExcelApplication.Create();
  IncProgress();
  try
    try
      Excel.Visible[Loc] := False;
      Excel.DisplayAlerts[Loc] := False;
      Wb := Excel.Workbooks.Add(EmptyParam(), Loc);
      while Wb.Worksheets.Count > 1 do
        (Wb.Worksheets.Item[Wb.Worksheets.Count] as _Worksheet).Delete(Loc);
      IncProgress();
      Ws := Wb.Worksheets.Item[1] as _Worksheet;
      Ws.Name := aSheetName;
      Cells := Ws.Cells;
      Cells.NumberFormat := '@';
      ColIndex := 0;
      for k := 0 to aQuery.FieldCount - 1 do
        if GetCheckFromFieldName(aQuery.Fields.Fields[k].FieldName) then
        begin
          Inc(ColIndex);
          Cells.Item[1, ColIndex] := aQuery.Fields.Fields[k].FieldName;
        end;
      IncProgress();
      ColCount := ColIndex;
      CellsHeader := Cells.Range[Cells.Item[1, 1], Cells.Item[1, ColCount]];
      CellsHeader.Font.Bold := True;
      CellsHeader.HorizontalAlignment := xlCenter;
      CellsHeader.Interior.Color := 65535;
      CellsHeader.AutoFilter(1, EmptyParam(), xlAnd, EmptyParam(), True);
      aQuery.First();
      for k := 0 to aQuery.RecordCount - 1 do
      begin
        ColIndex := 0;
        IncProgress();
        for i := 0 to aQuery.FieldCount - 1 do
          if GetCheckFromFieldName(aQuery.Fields.Fields[i].FieldName) then
          begin
            Inc(ColIndex);
            case aQuery.Fields.Fields[i].DataType of
              ftInteger, ftAutoInc:
                Cells.Item[k + 2, ColIndex] := aQuery.Fields.Fields[i].AsInteger;
              ftBoolean:
                Cells.Item[k + 2, ColIndex] := aQuery.Fields.Fields[i].AsBoolean;
              ftString, ftWideString:
                Cells.Item[k + 2, ColIndex] := aQuery.Fields.Fields[i].AsString;
              else
                Cells.Item[k + 2, ColIndex] := aQuery.Fields.Fields[i].AsVariant;
            end;
          end;
        aQuery.Next();
      end;
      Cells.Columns.AutoFit();
      Excel.Visible[Loc] := aVisible;
      if not aVisible then
      begin
        Wb.SaveAs(aFileName, xlOpenXMLWorkbook, EmptyParam(), EmptyParam(), False, False, xlNoChange,
          xlLocalSessionChanges, False, EmptyParam(), EmptyParam(), False, Loc);
        Excel.Quit();
      end;
      IncProgress();
    except
    begin
      Excel.Quit();
      raise;
    end;
    end;
  finally
    Excel := nil;
  end;
end;

procedure ImportQueryFromExcel(aQuery: TDataSet; const aSheetName, aFileName: string);
var
  Loc: LCID;
  k, i: Integer;
  Excel: _Application;
  Wb: _Workbook;
  Ws: _Worksheet;
  Cells: ExcelRange;
  LastRow: Integer;

  function FindColumnIndex(const aCells: ExcelRange; const aFieldName: string): Integer;
  var
    k: Integer;
    LastColumn: Integer;
  begin
    LastColumn := Cells.SpecialCells(xlCellTypeLastCell, EmptyParam()).Column;
    for k := 1 to LastColumn do
      if SameText(aCells.Item[1, k], aFieldName) then
        Exit(k);
    Result := 0;
  end;

  procedure IsFindColumn(aQuery: TDataSet; const aCells: ExcelRange);
  var
    k: Integer;
  begin
    for k := 0 to aQuery.FieldCount - 1 do
      if FindColumnIndex(aCells, aQuery.Fields.Fields[k].FieldName) = 0 then
        raise ExceptionImportExcel.CreateFmt('Поле %s не найдено', [aQuery.Fields.Fields[k].FieldName]);
  end;
begin
  Loc := GetUserDefaultLCID();
  Excel := CoExcelApplication.Create();
  try
    try
      Excel.Visible[Loc] := False;
      Excel.DisplayAlerts[Loc] := False;
      Wb := Excel.Workbooks.Open(aFileName, EmptyParam(), False, EmptyParam(), EmptyParam(), EmptyParam(), True, EmptyParam(),
        EmptyParam(), False, False, EmptyParam(), False, False, xlNormalLoad, Loc);
      if not SameText(aSheetName, '') then
      begin
        Ws := nil;
        for k := 0 to Wb.Worksheets.Count - 1 do
          if SameText((Wb.Worksheets.Item[k + 1] as _Worksheet).Name, aSheetName) then
          begin
            Ws := Wb.Worksheets.Item[k + 1] as _Worksheet;
            Break;
          end;
      end
      else
        Ws := Wb.Worksheets.Item[1] as _Worksheet;
      if Assigned(Ws) then
      begin
        Cells := Ws.Cells;
        aQuery.Open();
        IsFindColumn(aQuery, Cells);
        LastRow := Cells.SpecialCells(xlCellTypeLastCell, EmptyParam()).Row;
        for k := 2 to LastRow do
        begin
          aQuery.Append();
          for i := 0 to aQuery.FieldCount - 1 do
            aQuery.Fields.Fields[i].AsVariant := Cells.Item[k, FindColumnIndex(Cells, aQuery.Fields.Fields[i].FieldName)];
          aQuery.Post();
        end;
        Excel.Quit();
      end
      else
        raise ExceptionImportExcel.Create('Имя листа не найдено');
    except
    begin
      Excel.Quit();
      raise;
    end;
    end;
  finally
    Excel := nil;
  end;
end;

end.
