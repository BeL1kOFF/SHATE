unit Velcom.UI.LoadDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxClasses, dxBar, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridLevel,
  cxGrid, ExtCtrls, StdCtrls, DB, ADODB, ActnList, dxStatusBar, cxContainer, cxProgressBar;

type
  TfrmLoadDetail = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    Panel1: TPanel;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    Memo1: TMemo;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    qrQuery: TADOQuery;
    colId: TcxGridColumn;
    colPeriod: TcxGridColumn;
    ActionList: TActionList;
    acRefresh: TAction;
    acLoad: TAction;
    acDelete: TAction;
    odExcel: TOpenDialog;
    sbLoad: TdxStatusBar;
    dxStatusBar1Container0: TdxStatusBarContainerControl;
    pb: TcxProgressBar;
    dxBarLargeButton4: TdxBarLargeButton;
    acLoadClient: TAction;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acLoadExecute(Sender: TObject);
    procedure acLoadClientExecute(Sender: TObject);
  private
    FTimeRest: Cardinal;
    FPercent: Integer;
    FInchTotal: Int64;
    procedure ClearPeriod(const aActBill: string);
    procedure InsertPeriod(const aActBill: string; aBeginDate, aEndDate: TDate);
    procedure LoadCalls(const aFileName: string);
    procedure LoadClients(const aFileName: string);
    procedure RefreshPeriods;
    procedure UpdateProgress(aPos: Integer; const aCaption: string = '');
  end;

implementation

uses
  uMain,
  uDataModule,
  Velcom.ISQLCursor,
  adoDBUtils,
  ExcelXP,
  USysGlobal,
  DateUtils,
  StrUtils,
  Math;

{$R *.dfm}

{ TfrmLoadDetail }

procedure TfrmLoadDetail.acDeleteExecute(Sender: TObject);
var
  k: Integer;
  ResultText: string;
  ResultCode: Integer;
begin
  if Application.MessageBox('Вы уверенны, что хотите удалить выделенные записи?', 'Удаление', MB_YESNO or MB_ICONQUESTION) <> ID_YES then
    Exit;
  CreateSQLCursor();
  qrQuery.Close();
  CreateTempTable(qrQuery, 'tmpDelPeriod', ['Id_Period INT']);
  try
    for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
      InsertTempTable(qrQuery, 'tmpDelPeriod', [cxTable.Controller.SelectedRecords[k].Values[0]]);
    qrQuery.SQL.Text := 'ldd_del_item';
    try
      qrQuery.Open();
      ResultCode := qrQuery.Fields.Fields[0].AsInteger;
      ResultText := qrQuery.Fields.Fields[1].AsString;
    except on E: Exception do
    begin
      ResultCode := -1000;
      ResultText := E.Message;
    end;
    end;
    qrQuery.Close();
  finally
    DropTempTable(qrQuery, 'tmpDelPeriod');
  end;
  case ResultCode of
    1:
      Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
    0:
      Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
    -1:
      Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
  RefreshPeriods();
end;

procedure TfrmLoadDetail.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.Controller.SelectedRecordCount > 0;
end;

procedure TfrmLoadDetail.acLoadClientExecute(Sender: TObject);
begin
  if not odExcel.Execute() then
    Exit;
  LoadClients(odExcel.FileName);
end;

procedure TfrmLoadDetail.acLoadExecute(Sender: TObject);
begin
  if odExcel.Execute() then
    LoadCalls(odExcel.FileName);
  RefreshPeriods();
end;

procedure TfrmLoadDetail.acRefreshExecute(Sender: TObject);
begin
  RefreshPeriods();
end;

procedure TfrmLoadDetail.ClearPeriod(const aActBill: string);
begin
  qrQuery.SQL.Text := 'ldd_del_itemfromdate :ActBill';
  qrQuery.Parameters.ParamValues['ActBill'] := aActBill;
  try
    qrQuery.Open();
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmLoadDetail.FormShow(Sender: TObject);
begin
  RefreshPeriods();
end;

procedure TfrmLoadDetail.InsertPeriod(const aActBill: string; aBeginDate, aEndDate: TDate);
begin
  qrQuery.SQL.Text := 'ldd_ins_period :ActBill, :BeginDate, :EndDate, :Month, :Year';
  qrQuery.Parameters.ParamValues['ActBill'] := aActBill;
  qrQuery.Parameters.ParamValues['BeginDate'] := FormatDateTime('yyyymmdd', aBeginDate);
  qrQuery.Parameters.ParamValues['EndDate'] := FormatDateTime('yyyymmdd', aEndDate);
  qrQuery.Parameters.ParamValues['Month'] := MonthOf(aBeginDate);
  qrQuery.Parameters.ParamValues['Year'] := YearOf(aBeginDate);
  try
    qrQuery.Open();
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmLoadDetail.LoadCalls(const aFileName: string);
var
  excel: TExcelApplication;
  wb: ExcelWorkbook;
  shPage3: ExcelWorksheet;
  shPage4: ExcelWorksheet;
  shChargeDetails: ExcelWorksheet;
  sheet: ExcelWorksheet;
  k, i: Integer;
  tmpString: string;
  beginDate, endDate: TDate;
  isExists: Boolean;
  spaceString: Integer;
  numberCaller: string;
  nameCaller: string; 
  costName: string;
  dateCall: TDateTime;
  typeCode: string;
  lenCall: Integer;
  parseTime: TStringList;
  hh, mm, ss: Integer;
  numberCall: string;
  price: Double;
  isStart: Boolean;
  ResultError: Integer;
  ResultText: string;
  AffRec: Integer;
  ActBill: string;

  function GetRecordInSheet(aSheet: ExcelWorksheet): Integer;
  begin
    Result := aSheet.Cells.SpecialCells(11, EmptyParam).Row;
  end;

begin
  CreateSQLCursor();
  isStart := False;
  UpdateProgress(0, 'Обработка звонков...');
  excel := TExcelApplication.Create(nil);
  try
    excel.Connect();
    excel.AutoQuit := False;
    excel.EnableEvents := False;
    excel.DisplayAlerts[GetUserDefaultLCID()] := False;
    excel.Visible[GetUserDefaultLCID()] := False;
    wb := excel.Workbooks.Open(aFileName, False, True, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);
    for k := 1 to wb.Worksheets.Count do
    begin
      if (wb.Sheets.Item[k] as ExcelWorksheet).Name = 'Page3' then
        shPage3 := (wb.Sheets.Item[k] as ExcelWorksheet)
      else
        if (wb.Sheets.Item[k] as ExcelWorksheet).Name = 'Page4' then
          shPage4 := (wb.Sheets.Item[k] as ExcelWorksheet)
        else
          if (wb.Sheets.Item[k] as ExcelWorksheet).Name = 'ChargeDetails' then
            shChargeDetails := (wb.Sheets.Item[k] as ExcelWorksheet);
    end;
    ActBill := shPage3.Cells.Range['B3', 'B3'].FormulaR1C1;
    tmpString := shPage3.Cells.Range['B4', 'B4'].FormulaR1C1;
    beginDate := DateOf(StrToDate(Copy(tmpString, 1, Pos('-', tmpString) - 2)));
    endDate := DateOf(StrToDate(Copy(tmpString, Pos('-', tmpString) + 2, Length(tmpString))));
    qrQuery.SQL.Text := 'ldd_sel_callinperiod :ActBill';
    qrQuery.Parameters.ParamValues['ActBill'] := ActBill;
    try
      qrQuery.Open();
      isExists := qrQuery.FieldByName('IsExists').AsBoolean;
    finally
      qrQuery.Close();
    end;
    if isExists then
    begin
      if MsgBoxYN(Format('Счет-акт оказанных услуг %s уже загружался. Данные будут заменены.'#13#10'Продолжить?', [ActBill])) then
        isStart := True;
    end
    else
      isStart := True;
    if isStart then
    begin
      ClearPeriod(ActBill);
      InsertPeriod(ActBill, beginDate, endDate);
        
      CreateTempTable(qrQuery, 'tmpCaller', ['Number NCHAR(9)', 'Name NVARCHAR(255)']);
      try
        k := 2;
        spaceString := 0;
        UpdateProgress(0, 'Подготовка абонентов...');
        pb.Properties.Min := 0;
        pb.Properties.Max := GetRecordInSheet(shChargeDetails);        
        while k < 65536 do
        begin
          UpdateProgress(k, 'Подготовка абонентов...');
          numberCaller := RightStr(Trim(string(shChargeDetails.Cells.Item[k, 2])), 9);
          if numberCaller = '' then
          begin
            Inc(spaceString);
            if spaceString = 3 then
              Break;
          end
          else
          begin
            spaceString := 0;
            nameCaller := Trim(string(shChargeDetails.Cells.Item[k, 3]));
            InsertTempTable(qrQuery, 'tmpCaller', [numberCaller, nameCaller]);
          end;
          Inc(k);
        end;
        CreateTempTable(qrQuery, 'tmpCallerCost', ['Number NCHAR(9)', 'NameCost NVARCHAR(128)', 'Price MONEY', 'CallDateTime DATE']);
        try
          k := 1;
          spaceString := 0;
          numberCaller := '';
          UpdateProgress(0, 'Подготовка статей...');
          pb.Properties.Min := 0;
          pb.Properties.Max := GetRecordInSheet(shPage4);          
          while k < 65536 do
          begin
            UpdateProgress(k, 'Подготовка статей...');
            tmpString := Trim(string(shPage4.Cells.Item[k, 1]));
            if tmpString = '' then
            begin
              Inc(spaceString);
              if spaceString = 5 then
                Break;
            end
            else
            begin
              spaceString := 0;
              if Pos('Абонент', tmpString) > 0 then
              begin
                tmpString := Trim(string(shPage4.Cells.Item[k, 2]));
                numberCaller := RightStr(Trim(Copy(tmpString, Pos(',', tmpString) + 1, Length(tmpString))), 9);
              end
              else
              begin
                if (Pos('Итого начислений', tmpString) = 0) and (numberCaller <> '') then
                begin
                  costName := tmpString;
                  price := StrToFloatUnic(Trim(string(shPage4.Cells.Item[k, 4])));
                  InsertTempTable(qrQuery, 'tmpCallerCost', [numberCaller, costName, price, FormatDateTime('yyyymmdd', beginDate)]);
                end;
              end;
            end;
            Inc(k);
          end;
          CreateTempTable(qrQuery, 'tmpCalls', ['NumberCaller NCHAR(9)', 'NameCost NVARCHAR(128)', 'CallDateTime DATETIME2',
                                                'TypeCode NVARCHAR(50)', 'Duration INT', 'NumberCall NVARCHAR(100)',
                                                'Price MONEY']);
          try
            numberCaller := '';
            for i := 1 to wb.Sheets.Count do
            begin
              sheet := wb.Sheets.Item[i] as ExcelWorksheet;
              if Pos('CallDetails', string(sheet.Name)) = 0 then
                Continue;
              k := 1;
              spaceString := 0;
              UpdateProgress(0, 'Подготовка звонков... Лист: ' + IntToStr(i));
              pb.Properties.Min := 0;
              pb.Properties.Max := GetRecordInSheet(sheet);
              while k < 65536 do
              begin
                UpdateProgress(k, 'Подготовка звонков... Лист: ' + IntToStr(i));
                tmpString := Trim(string(sheet.Cells.Item[k, 1]));
                if tmpString = '' then
                begin
                  Inc(spaceString);
                  if spaceString = 10 then
                    Break;
                end
                else
                begin
                  spaceString := 0;
                  if (Pos('Дата', tmpString) = 0) and (Pos('Итого', tmpString) = 0) then
                    if Pos('Абонент', tmpString) > 0 then
                    begin
                      tmpString := Trim(string(sheet.Cells.Item[k, 2]));
                      numberCaller := RightStr(Trim(Copy(tmpString, 1, Pos(',', tmpString) - 1)), 9);
                      memo1.Lines.Add('#ABN# ' + numberCaller);
                    end
                    else
                    begin
                      dateCall := StrToDateTimeDef(tmpString, 0);
                      if dateCall = 0 then
                      begin
                        costName := tmpString;
                        memo1.Lines.Add('#CST# ' + costName);
                      end
                      else
                      begin
                        typeCode := Trim(string(sheet.Cells.Item[k, 2]));
                        tmpString := Trim(string(sheet.Cells.Item[k, 3]));
                        lenCall := StrToIntDef(tmpString, -1);
                        if lenCall = -1 then
                        begin
                          parseTime := TStringList.Create;
                          try
                            parseTime.Delimiter := ':';
                            parseTime.DelimitedText := tmpString;
                            hh := StrToInt(parseTime.Strings[0]);
                            mm := StrToInt(parseTime.Strings[1]);
                            ss := StrToInt(parseTime.Strings[2]);
                            lenCall := SecondOfTheYear(StrToDate('01.01.1900') + (hh + mm / 60 + ss / 3600) / 24);
                          finally
                            parseTime.Free();
                          end;
                        end;
                        numberCall := Trim(string(sheet.Cells.Item[k, 4]));
                        price := StrToFloatUnic(Trim(string(sheet.Cells.Item[k, 5])));
                        InsertTempTable(qrQuery, 'tmpCalls', [numberCaller, costName, FormatDateTime('yyyymmdd hh:nn:ss', dateCall), typeCode,
                                                              lenCall, numberCall, price]);
                      end;
                    end;
                end;
                Inc(k);
              end;
            end;
            UpdateProgress(0, 'Загрузка звонков...');
            qrQuery.SQL.Text := 'ldd_ins_calls :ActBill';
            qrQuery.Parameters.ParamValues['ActBill'] := ActBill;
            try
              qrQuery.Open();
              ResultError := qrQuery.Fields.Fields[0].AsInteger;
              ResultText := qrQuery.Fields.Fields[1].AsString;
              while Assigned(qrQuery.Recordset) do
                qrQuery.Recordset := qrQuery.NextRecordset(AffRec);
            finally
              qrQuery.Close();
            end;
            if ResultError = -1 then
              Application.MessageBox(PChar(ResultText), 'Ошибка!', MB_OK or MB_ICONERROR);
          finally
            DropTempTable(qrQuery, 'tmpCalls');
          end;
        finally
          DropTempTable(qrQuery, 'tmpCallerCost');
        end;
      finally
        DropTempTable(qrQuery, 'tmpCaller');
      end;
    end;
  finally
    wb.Close(False, EmptyParam, False, GetUserDefaultLCID());
    excel.Disconnect();
    excel.Free();
  end;
  UpdateProgress(0, 'Загрузка завершена');
end;

procedure TfrmLoadDetail.LoadClients(const aFileName: string);
var
  ExcelApp: TExcelApplication;
  wb: ExcelWorkbook;
  aSheet: ExcelWorksheet;
  ir: ExcelRange;
  sPhone, sDescription, sCode: string;
  sDesc1, sDesc2: string;
  iRow, aSpaceCount: Integer;
begin
  UpdateProgress(0, 'Загрузка клиентов...');
  ExcelApp := TExcelApplication.Create(nil);
  ExcelApp.Connect; // подключение
  try
    ExcelApp.AutoQuit := False; // по умолчанию это свойство True только в unit ExcelXP
    ExcelApp.EnableEvents := FALSE;
    ExcelApp.DisplayAlerts[0] := False;
    ExcelApp.Visible[0]:= False;
    wb := ExcelApp.WorkBooks.Open(aFileName, False, True, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);

    aSheet := wb.Sheets.Item[1] as ExcelWorksheet;
    ir := aSheet.Range['A1', 'A1'];
    iRow := 2;
    aSpaceCount := 0;
    while iRow < 65000 do
    begin
      sPhone := ir.Item[iRow, 1];
      if sPhone = '' then
      begin
        Inc(iRow);
        Inc(aSpaceCount);
        if aSpaceCount > 3 then
          Break;
        Continue;
      end;
      aSpaceCount := 0;

      sPhone := Trim(sPhone);
      sDesc1 := ir.Item[iRow, 2];
      sDesc2 := ir.Item[iRow, 3];
      sDescription := Trim(sDesc1 + ' ' + sDesc2);
      sCode := ir.Item[iRow, 4];
      sCode := Trim(sCode);
      UpdateProgress(0, 'Загрузка клиента... ' + sPhone);

      qrQuery.SQL.Text := 'EXEC call_ins_contact :Number, :Description, :Code, :Type';
      qrQuery.Parameters.ParamValues['Number'] := sPhone;
      qrQuery.Parameters.ParamValues['Description'] := sDescription;
      qrQuery.Parameters.ParamValues['Code'] := sCode;
      qrQuery.Parameters.ParamValues['Type'] := 1;
      qrQuery.ExecSQL();
      qrQuery.Close();

      Inc(iRow);
    end;
  finally
    ExcelApp.Visible[0]:= False;
    ExcelApp.Disconnect;
    ExcelApp.Free;

    UpdateProgress(0, ' ');
  end;
end;

procedure TfrmLoadDetail.RefreshPeriods;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'ldd_sel_periodlist';
  qrQuery.Open();
  cxTable.DataController.RecordCount := qrQuery.RecordCount;
  qrQuery.First();
  formatDate.DateSeparator := '-';
  formatDate.ShortDateFormat := 'yyyymmdd';
  for k := 0 to qrQuery.RecordCount - 1 do
  begin
    cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Period').AsInteger;
    cxTable.DataController.Values[k, 1] := Format('%s %d  [%s - %s] Счет: %s',
      [cMonthNames[qrQuery.FieldByName('Month').AsInteger],
      qrQuery.FieldByName('Year').AsInteger,
      FormatDateTime('DD.MM.YYYY', StrToDate(qrQuery.FieldByName('BeginDate').AsString, formatDate)),
      FormatDateTime('DD.MM.YYYY', StrToDate(qrQuery.FieldByName('EndDate').AsString, formatDate)),
      qrQuery.FieldByName('ActBill').AsString]);
    qrQuery.Next();
  end;
  qrQuery.Close();
end;

procedure TfrmLoadDetail.UpdateProgress(aPos: Integer; const aCaption: string);
var
  tmpTimeRest: Int64;
begin
  if pb.Position = pb.Properties.Min then
  begin
    FTimeRest := GetTickCount;
    FPercent := 0;
  end;
  if pb.Position <> aPos then
  begin
    if FPercent < pb.PercentDone then
    begin
      tmpTimeRest := GetTickCount - FTimeRest;
      tmpTimeRest := tmpTimeRest * (100 - pb.PercentDone);
      if pb.PercentDone = 1 then
        FInchTotal := tmpTimeRest
      else
        FInchTotal := Round(Math.Mean([FInchTotal, tmpTimeRest]));
      FTimeRest := GetTickCount;
      sbLoad.Panels.Items[2].Text := 'Осталось времени: ' + TimeToStr(IncMilliSecond(0, FInchTotal));
      FPercent := pb.PercentDone;      
    end;
    pb.Position := aPos;
  end;

  if aCaption <> '' then
    sbLoad.Panels.Items[0].Text := aCaption;
  sbLoad.Update();
  pb.Update();
  Memo1.Update();
end;

end.
