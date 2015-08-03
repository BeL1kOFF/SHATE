unit Velcom.MultiReportExcel;

interface

uses
  Controls,
  ADODB,
  cxGridTableView;

type
  TxCallerRec = record
    ID: Integer;
    Name: string;
    AbnName: string;
    Number: string;
  end;

  TxCallerRecArray = array of TxCallerRec;

  TxCostCallerRec = record
    ID: Integer;
    Name: string;
    Len: Integer;
    SumNDS: Double;
  end;

  TxCostCallerRecArray = array of TxCostCallerRec;

  TxCallerRec2 = record
    ID: Integer;
    xCostCallerRecArray: TxCostCallerRecArray;
  end;

  TxCallerRecArray2 = array of TxCallerRec2;

  TxOnStatusMessage = procedure(aMessage: string) of object;

  TOnPrepareViewData = procedure(const aCallerId: Integer; out aViewData: TcxGridViewData) of object;

  //Загрузка данных из SQL
  function MultiExportCurToExcel(aConnection: TADOConnection;
    aId_Period: Integer;
    ACallerRecArray: TxCallerRecArray;
    ASave: Boolean; ADepartment: string;
    aOnStatusMessage: TxOnStatusMessage): string; overload;

  function MultiExportCurToExcel(aConnection: TADOConnection;
    aId_Period: Integer;
    ACallerRecArray: TxCallerRecArray;
    ASave: Boolean; ADepartment: string): string; overload;

  //Загрузка данных из Грида
  function MultiExportCurToExcel(aOnPrepareViewData: TOnPrepareViewData;
    ACallerRecArray: TxCallerRecArray; ASave: Boolean; ADepartment: string;
    aOnStatusMessage: TxOnStatusMessage): string; overload;

  function MultiExportCurToExcel(aOnPrepareViewData: TOnPrepareViewData;
    ACallerRecArray: TxCallerRecArray; ASave: Boolean;
    ADepartment: string): string; overload;

implementation

uses
  Windows,
  DateUtils,
  Variants,
  SysUtils,
  Math,
  Forms,
  ExcelXP,
  cxGridDBBandedTableView;

{
  Описания параметров:
  aOnPrepareViewData - Если загрузка из грида, позволяет получить ViewData
    из которой будут читаться данные.
  aConnection - Если загрузка из SQL, коннект к SQL. Eсли nil, то
    используется загрузка из грида.
  aId_Period - Если загрузка из SQL, период.
  ACallerRecArray - список Абонентов.
  ASave - необходимл ли сохранять во временную папку файл.
  ADepartment - префикс к имени файла.
  aOnStatusMessage - процедура для вывода хода выполнения.
}
function MultiExportCurToExcel2(aOnPrepareViewData: TOnPrepareViewData;
  aConnection: TADOConnection; aId_Period: Integer; ACallerRecArray: TxCallerRecArray;
  ASave: Boolean; ADepartment: string; aOnStatusMessage: TxOnStatusMessage): string;
var
  ExcelApp: TExcelApplication;
  WorkBook: ExcelWorkbook;
  WorkSheet: ExcelWorksheet;
  Cells: ExcelRange;
  CellsCost: ExcelRange;
  k, i: Integer;
  RowIndex: Integer;
  iRow: Integer;
  SumCostPrice:Double;
  TempStr: array[0..4095] of char;
  qrQuery: TADODataSet;
  xCallerRec2: TxCallerRecArray2;
  cost_id: Integer;
  viewData: TcxGridViewData;

  procedure SetColumnDetail(ACells: ExcelRange; ARange, AText: string; AWidth: integer);
  var
    Cells: ExcelRange;
  begin
    Cells := ACells.Range[ARange, ARange];
    Cells.FormulaR1C1 := AText;
    Cells.Borders.LineStyle := xlContinuous;
    Cells.Font.Bold := True;
    Cells.ColumnWidth := AWidth;
    Cells.WrapText := True;
  end;

  function GetValueFromColumn(aVD: TcxGridViewData; aIndex: Integer; aColumnName: string): Variant;
  begin
    Result := aVD.Records[aIndex].Values[(aVD.GridView as TcxGridDBBandedTableView).GetColumnByFieldName(aColumnName).Index];
  end;

  function MakeCorrectName(aValue: string): string;
  const
    ILLEGAL_CHARS = ':\/?*[]';
  var
    k: Integer;
  begin
    for k := 1 to Length(ILLEGAL_CHARS) do
      aValue := StringReplace(aValue, ILLEGAL_CHARS[k], '', [rfReplaceAll]);
    aValue := Copy(aValue, 1, 31);
    if aValue = '' then
      aValue := 'Неизвестный';
    Result := aValue;
  end;

begin
  SetLength(xCallerRec2, Length(ACallerRecArray));

  ExcelApp := TExcelApplication.Create(nil);
  ExcelApp.Connect;
  ExcelApp.DisplayAlerts[GetUserDefaultLCID()] := False;
  qrQuery := TADODataSet.Create(nil);
  if Assigned(aConnection) then
  begin
    qrQuery.Connection := aConnection;
    qrQuery.CursorType := ctStatic;
  end;
  try
    ExcelApp.AutoQuit := False; // по умолчанию это свойство True только в unit ExcelXP
    ExcelApp.EnableEvents := FALSE;
    ExcelApp.Visible[0]:= FALSE;
    WorkBook := ExcelApp.Workbooks.Add(NULL, GetUserDefaultLCID);
    WorkSheet := WorkBook.Worksheets.Item[1] as ExcelWorksheet;
    while WorkBook.Worksheets.Count > 1 do
      (WorkBook.Worksheets.Item[2] as ExcelWorksheet).Delete(GetUserDefaultLCID);
    WorkSheet.Name := 'Page4';
    CellsCost := WorkSheet.Cells;

    CellsCost.Range['A1', 'A1'].ColumnWidth := 0.58;
    CellsCost.Range['B1', 'B1'].ColumnWidth := 17;
    CellsCost.Range['C1', 'C1'].ColumnWidth := 10;
    CellsCost.Range['D1', 'D1'].ColumnWidth := 5;
    CellsCost.Range['E1', 'E1'].ColumnWidth := 9;
    CellsCost.Range['F1', 'F1'].ColumnWidth := 13;
    CellsCost.Range['A1', 'F1'].Merge(False);
    CellsCost.Range['A1', 'A1'].FormulaR1C1 := 'Детализация счета и расшифровка начислений';
    CellsCost.Range['A1', 'A1'].HorizontalAlignment := xlHAlignCenter;
    CellsCost.Range['A1', 'A1'].Font.Size := 11;
    CellsCost.Range['A1', 'A1'].WrapText := True;
    CellsCost.Range['F2', 'F2'].FormulaR1C1 := 'Сумма с НДС';
    CellsCost.Range['F2', 'F2'].Font.Size := 8;
    CellsCost.Range['F2', 'F2'].WrapText := True;
    CellsCost.Range['F2', 'F2'].HorizontalAlignment := xlHAlignCenter;
    CellsCost.Range['A1', 'F1'].Borders.Item[xlEdgeBottom].LineStyle := xlContinuous;
    CellsCost.Range['A2', 'F2'].Borders.Item[xlEdgeBottom].LineStyle := xlContinuous;
    RowIndex := 3;

    for k := 0 to Length(ACallerRecArray) - 1 do
    begin
      xCallerRec2[k].ID := ACallerRecArray[k].ID;
      if Assigned(aOnStatusMessage) then
        aOnStatusMessage('Всего: ' + IntToStr(k + 1) + '/' + IntToStr(Length(ACallerRecArray)));

      WorkSheet := WorkBook.Worksheets.Add(EmptyParam, WorkSheet, 1, xlWorksheet, GetUserDefaultLCID) as ExcelWorksheet;
      WorkSheet.Name := MakeCorrectName(ACallerRecArray[k].AbnName + ' (' + ACallerRecArray[k].Number + ')');
      Cells := WorkSheet.Cells;
      Cells.Font.Name := 'Arial';
      Cells.Font.Size := 8;

      SetColumnDetail(Cells, 'A1', 'Время', 13);
      SetColumnDetail(Cells, 'B1', 'Длит., сек', 6);
      SetColumnDetail(Cells, 'C1', 'Сумма', 9);
      SetColumnDetail(Cells, 'D1', 'Сумма с НДС', 8);
      SetColumnDetail(Cells, 'E1', 'Кому|номер', 11);
      SetColumnDetail(Cells, 'F1', 'Кому|Абонент', 16);
      SetColumnDetail(Cells, 'G1', 'Кому|Справочник', 11);
      SetColumnDetail(Cells, 'H1', 'Статья расхода', 33);
      SetColumnDetail(Cells, 'I1', 'Код оп.', 6);

      iRow := 1;

      //заголовок с именем абонента
      Inc(iRow);
      Cells := ExcelApp.Range['A' + IntToStr(iRow), 'A' + IntToStr(iRow)];
      Cells := Cells.Resize[1, 9];
      Cells.Merge(1);
      Cells.Value2 := 'Абонент: ' + ACallerRecArray[k].AbnName + ' (' + ACallerRecArray[k].Number + ')';
      Cells.Borders.LineStyle := xlContinuous;
      Cells.Font.Bold := 1;
      Inc(iRow);

      if not Assigned(aConnection) then
      begin
        ZeroMemory(xCallerRec2[k].xCostCallerRecArray, Length(xCallerRec2[k].xCostCallerRecArray));
        if Assigned(aOnPrepareViewData) then
          aOnPrepareViewData(ACallerRecArray[k].ID, viewData);
        for i := 0 to viewData.RecordCount - 1 do
        begin
          cost_id := GetValueFromColumn(viewData, i, 'Id_Cost');
          if (Length(xCallerRec2[k].xCostCallerRecArray) - 1) < cost_id then
            SetLength(xCallerRec2[k].xCostCallerRecArray, cost_id + 1);

          xCallerRec2[k].xCostCallerRecArray[cost_id].ID := cost_id;
          xCallerRec2[k].xCostCallerRecArray[cost_id].Name := GetValueFromColumn(viewData, i, 'CostName');
          xCallerRec2[k].xCostCallerRecArray[cost_id].Len := xCallerRec2[k].xCostCallerRecArray[cost_id].Len + GetValueFromColumn(viewData, i, 'Duration');
          xCallerRec2[k].xCostCallerRecArray[cost_id].SumNDS := xCallerRec2[k].xCostCallerRecArray[cost_id].SumNDS + GetValueFromColumn(viewData, i, 'PriceWithVAT');

          Cells := ExcelApp.Range['A' + IntToStr(iRow), 'A' + IntToStr(iRow)];
          Cells.Item[1, 1] := GetValueFromColumn(viewData, i, 'CallDateTime');
          Cells.Item[1, 2] := GetValueFromColumn(viewData, i, 'Duration');
          Cells.Item[1, 3] := GetValueFromColumn(viewData, i, 'Price');
          Cells.Item[1, 4] := GetValueFromColumn(viewData, i, 'PriceWithVAT');
          Cells.Item[1, 5].NumberFormat := '@';
          Cells.Item[1, 5] := GetValueFromColumn(viewData, i, 'CallNumber');
          Cells.Item[1, 6] := GetValueFromColumn(viewData, i, 'AbonentWhom');
          Cells.Item[1, 7] := GetValueFromColumn(viewData, i, 'Reference');
          case GetValueFromColumn(viewData, i, 'IsAbonent') of
            1:
            begin
              Cells.Item[1, 5].Font.Color := RGB($00, $80, $00);
              Cells.Item[1, 6].Font.Color := RGB($00, $80, $00);
              Cells.Item[1, 7].Font.Color := RGB($00, $80, $00);
            end;
            2:
            begin
              Cells.Item[1, 5].Font.Color := RGB($00, $00, $80);
              Cells.Item[1, 6].Font.Color := RGB($00, $00, $80);
              Cells.Item[1, 7].Font.Color := RGB($00, $00, $80);
              Cells.Item[1, 5].Font.Italic := True;
              Cells.Item[1, 6].Font.Italic := True;
              Cells.Item[1, 7].Font.Italic := True;
            end;
          end;
          Cells.Item[1, 8] := GetValueFromColumn(viewData, i, 'CostName');
          Cells.Item[1, 9] := GetValueFromColumn(viewData, i, 'TypeCode');
          Inc(iRow);
        end;
      end
      else
      begin
        if qrQuery.Active then
          qrQuery.Close;

        qrQuery.CommandText := 'excl_sel_calls :Id_Employee, :Id_Period';
        qrQuery.Parameters.ParamValues['Id_Employee'] := ACallerRecArray[k].ID;
        qrQuery.Parameters.ParamValues['Id_Period'] := aId_Period;
        qrQuery.Open;
        qrQuery.DisableControls;
        try
          //детализация абонента
          qrQuery.First;
          while not qrQuery.Eof do
          begin
            Cells := ExcelApp.Range['A' + IntToStr(iRow), 'A' + IntToStr(iRow)];
            Cells.Item[1, 1] := qrQuery.FieldByName('CallDateTime').AsString;
            Cells.Item[1, 2] := qrQuery.FieldByName('Duration').AsString;
            Cells.Item[1, 3] := qrQuery.FieldByName('Price').AsString;
            Cells.Item[1, 4] := qrQuery.FieldByName('PriceWithVAT').AsString;
            Cells.Item[1, 5].NumberFormat := '@';
            Cells.Item[1, 5] := qrQuery.FieldByName('CallNumber').AsString;
            Cells.Item[1, 6] := qrQuery.FieldByName('AbonentWhom').AsString;
            Cells.Item[1, 7] := qrQuery.FieldByName('Reference').AsString;
            case qrQuery.FieldByName('IsAbonent').AsInteger of
              1:
              begin
                Cells.Item[1, 5].Font.Color := RGB($00, $80, $00);
                Cells.Item[1, 6].Font.Color := RGB($00, $80, $00);
                Cells.Item[1, 7].Font.Color := RGB($00, $80, $00);
              end;
              2:
              begin
                Cells.Item[1, 5].Font.Color := RGB($00, $00, $80);
                Cells.Item[1, 6].Font.Color := RGB($00, $00, $80);
                Cells.Item[1, 7].Font.Color := RGB($00, $00, $80);
                Cells.Item[1, 5].Font.Italic := True;
                Cells.Item[1, 6].Font.Italic := True;
                Cells.Item[1, 7].Font.Italic := True;
              end;
            end;
            Cells.Item[1, 8] := qrQuery.FieldByName('CostName').AsString;
            Cells.Item[1, 9] := qrQuery.FieldByName('TypeCode').AsString;
            Inc(iRow);
            qrQuery.Next;
          end;
        finally
          qrQuery.EnableControls;
        end;
      end;
      
      //Запись по абоненту в сводный лист
      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).FormulaR1C1 := 'Абонент:';
      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).Font.Size := 11;
      CellsCost.Range['C' + IntToStr(RowIndex), 'F' + IntToStr(RowIndex)].Merge(False);
      CellsCost.Range['A' + IntToStr(RowIndex), 'F' + IntToStr(RowIndex)].Borders.Item[xlEdgeBottom].LineStyle := xlContinuous;
      (IDispatch(CellsCost.Item[RowIndex, 3]) as ExcelRange).FormulaR1C1 := ACallerRecArray[k].Name + ' (' + ACallerRecArray[k].Number + ')';
      (IDispatch(CellsCost.Item[RowIndex, 3]) as ExcelRange).Font.Bold := True;
      (IDispatch(CellsCost.Item[RowIndex, 3]) as ExcelRange).Font.Size := 11;
      Inc(RowIndex);
      SumCostPrice := 0;

      if not Assigned(aConnection) then
      begin
        for i := 1 to Length(xCallerRec2[k].xCostCallerRecArray) - 1 do
          if xCallerRec2[k].xCostCallerRecArray[i].ID = i then
          begin
            (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).FormulaR1C1 := xCallerRec2[k].xCostCallerRecArray[i].Name;
            (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).Font.Size := 9.5;
            (IDispatch(CellsCost.Item[RowIndex, 5]) as ExcelRange).FormulaR1C1 := xCallerRec2[k].xCostCallerRecArray[i].Len;
            (IDispatch(CellsCost.Item[RowIndex, 6]) as ExcelRange).FormulaR1C1 := xCallerRec2[k].xCostCallerRecArray[i].SumNDS;
            SumCostPrice := SumCostPrice + xCallerRec2[k].xCostCallerRecArray[i].SumNDS;
            Inc(RowIndex);
          end;
      end
      else
      begin
        if qrQuery.Active then
          qrQuery.Close;
        qrQuery.CommandText := 'excl_sel_costcallers :Id_Employee, :Id_Period';
        qrQuery.Parameters.ParamValues['Id_Employee'] := ACallerRecArray[k].ID;
        qrQuery.Parameters.ParamValues['Id_Period'] := aId_Period;
        qrQuery.Open;
        qrQuery.First;
        for i := 0 to qrQuery.RecordCount - 1 do
        begin
          (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).FormulaR1C1 := qrQuery.FieldByName('CostName').AsString;
          (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).Font.Size := 9.5;
          (IDispatch(CellsCost.Item[RowIndex, 5]) as ExcelRange).FormulaR1C1 := qrQuery.FieldByName('Duration').AsInteger;
          (IDispatch(CellsCost.Item[RowIndex, 6]) as ExcelRange).FormulaR1C1 := qrQuery.FieldByName('PriceWithVAT').AsInteger;
          SumCostPrice := SumCostPrice + qrQuery.FieldByName('PriceWithVAT').AsInteger;
          Inc(RowIndex);
          qrQuery.Next;
        end;
      end;

      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).FormulaR1C1 := 'Итого начислений по абоненту';
      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).Font.Bold := True;
      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).Font.Size := 9.5;
      (IDispatch(CellsCost.Item[RowIndex, 6]) as ExcelRange).FormulaR1C1 := SumCostPrice;
      CellsCost.Range['A' + IntToStr(RowIndex), 'F' + IntToStr(RowIndex)].Borders.Item[xlEdgeTop].LineStyle := xlContinuous;
      Inc(RowIndex);
      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).FormulaR1C1 := 'Итого начислений по абоненту с учётом округлений';
      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).Font.Bold := True;
      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).Font.Size := 9.5;
      (IDispatch(CellsCost.Item[RowIndex, 6]) as ExcelRange).FormulaR1C1 := SimpleRoundTo(SumCostPrice, 1);
      CellsCost.Range['A' + IntToStr(RowIndex), 'F' + IntToStr(RowIndex)].Borders.Item[xlEdgeTop].LineStyle := xlContinuous;
      Inc(RowIndex);
      (IDispatch(CellsCost.Item[RowIndex, 2]) as ExcelRange).RowHeight := 2.25;
      CellsCost.Range['A' + IntToStr(RowIndex), 'F' + IntToStr(RowIndex)].Borders.Item[xlEdgeBottom and xlEdgeTop].LineStyle := xlDouble;
      Inc(RowIndex, 2);

    end;
    if ASave then
    begin
      FillChar(TempStr, 4096, 0);
      GetTempPath(4096, TempStr);
      Result := IncludeTrailingPathDelimiter(TempStr) + ADepartment + '_' + IntToStr(GetTickCount) + '.xlsx';
      WorkBook.SaveAs(Result, 51, EmptyParam, EmptyParam, False, False, xlNoChange, EmptyParam,
        False, EmptyParam, EmptyParam, False, GetUserDefaultLCID());
    end;
  finally
    qrQuery.Close;
    qrQuery.Free;
    if not ASave then
      ExcelApp.Visible[0]:= True
    else
      WorkBook.Close(False, EmptyParam, False, GetUserDefaultLCID());

    ExcelApp.Disconnect;
    ExcelApp.Free;
  end;
end;

function MultiExportCurToExcel(aConnection: TADOConnection; aId_Period: Integer;
  ACallerRecArray: TxCallerRecArray; ASave: Boolean; ADepartment: string;
  aOnStatusMessage: TxOnStatusMessage): string; overload;
begin
  Result := MultiExportCurToExcel2(nil, aConnection, aId_Period,
    ACallerRecArray, ASave, ADepartment, aOnStatusMessage);
end;

function MultiExportCurToExcel(aOnPrepareViewData: TOnPrepareViewData;
  ACallerRecArray: TxCallerRecArray; ASave: Boolean; ADepartment: string;
  aOnStatusMessage: TxOnStatusMessage): string; overload;
begin
  Result := MultiExportCurToExcel2(aOnPrepareViewData, nil, -1,
    ACallerRecArray, ASave, ADepartment, aOnStatusMessage);
end;

function MultiExportCurToExcel(aConnection: TADOConnection; aId_Period: Integer;
  ACallerRecArray: TxCallerRecArray;
  ASave: Boolean; ADepartment: string): string; overload;
begin
  Result := MultiExportCurToExcel2(nil, aConnection, aId_Period, ACallerRecArray,
    ASave, ADepartment, nil);
end;

function MultiExportCurToExcel(aOnPrepareViewData: TOnPrepareViewData;
  ACallerRecArray: TxCallerRecArray; ASave: Boolean;
  ADepartment: string): string; overload;
begin
  Result := MultiExportCurToExcel2(aOnPrepareViewData, nil, -1, ACallerRecArray,
    ASave, ADepartment, nil);
end;

end.
