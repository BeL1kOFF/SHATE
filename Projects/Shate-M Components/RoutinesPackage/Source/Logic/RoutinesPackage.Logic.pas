unit RoutinesPackage.Logic;

interface

uses
  Winapi.ActiveX,
  Data.Win.ADODB,
  Data.DB,
  IdSMTP,
  IdMessage,
  RoutinesPackage.Logic.IEventLogger;

function InitializeCOM(const aCoInit: Integer = COINIT_MULTITHREADED + COINIT_SPEED_OVER_MEMORY): IInterface;

function GetEventLogger(const aName: string): IEventLogger;

(* создание и установка значений(aArgs) параметров SQL-запроса(tmpSQL),
  а также самого SQL-запроса в aQuery.
  Метод добавляет к строке aSQL количесво строк ':P?'(где
  ":" - символ обозначающий что это параметр,
  "?" - номер параметра), равное количесву элементов в aArgs,
  далее вставляет эту строку в aQuery и присваивает значения параметров
  aDataSet-а из aArgs *)
procedure SetADOQuery(const aQuery: TADOQuery; aSQL: string; const aArgs: array of Variant; const aOpen: Boolean = True);

function GetADOQuery(const AConnection: TCustomConnection): TADOQuery;

function SendEMail(const aSMTP: TIdSMTP; const aEMail: TIdMessage; var aLogMessage: string): Boolean;
function SaveDatasetToCSV(const aDataSet: TADOQuery; const aFileName: string; const aTitle: string = ''): Boolean;
function Caesar(const aValue: string): string;
function FilePathLocalization(var aFileName, aShare: string; const aSubDirectory: string): Boolean;

implementation

uses
  RoutinesPackage.Logic.TInitializeCOM,
  RoutinesPackage.Logic.TEventLogger,
  Vcl.Forms,
  Vcl.Controls,
  System.Classes,
  System.SysUtils;

resourcestring
  RsSended = 'Отправлено: [%s <%s>]';

function InitializeCOM(const aCoInit: Integer): IInterface;
begin
  Result := TInitializeCOM.Create(aCoInit);
end;

function GetEventLogger(const aName: string): IEventLogger;
begin
  Result := TEventLogger.Create(aName);
end;

procedure SetADOQuery(const aQuery: TADOQuery; aSQL: string; const aArgs: array of Variant; const aOpen: Boolean);
var
  i, iParams: Integer;
  tmpSQL: string;
  tmpParameters: array of Variant;
  tmpCursor: TCursor;
begin
  tmpCursor := Screen.Cursor;

  iParams := aSQL.IndexOf(':');
  tmpParameters := nil;
  if iParams > 0 then
  begin
    SetLength(tmpParameters, aQuery.Parameters.Count);
    for i := 0 to Pred(aQuery.Parameters.Count) do
    begin
      tmpParameters[i] := aQuery.Parameters.Items[i].Value;
    end;
  end;

  aQuery.SQL.Clear();
  aQuery.Close();
  tmpSQL := aSQL;

  for i := 0 to high(aArgs) do
  begin
    if (i = 0) and (iParams <= 0) then
    begin
      tmpSQL := Format('%s :P%d', [tmpSQL, i]);
    end
    else
    begin
      tmpSQL := Format('%s, :P%d', [tmpSQL, i]);
    end;
  end;

  aQuery.SQL.Append(tmpSQL);

  if iParams > 0 then
  begin
    for i := 0 to high(tmpParameters) do
    begin
      aQuery.Parameters.Items[i].Value := tmpParameters[i];
    end;

    for i := 0 to high(aArgs) do
    begin
      aQuery.Parameters.Items[(Succ(high(tmpParameters))) + i].Value := aArgs[i];
    end;
  end
  else
  begin
    for i := 0 to high(aArgs) do
    begin
      aQuery.Parameters.Items[i].Value := aArgs[i];
    end;
  end;

  if aOpen then
  begin
    try
      Screen.Cursor := crSQLWait;
      aQuery.Open();
    finally
      Screen.Cursor := tmpCursor;
    end;
  end;
end;

function GetADOQuery(const AConnection: TCustomConnection): TADOQuery;
begin
  Result := nil;

  if not Assigned(AConnection) then
  begin
    Exit;
  end;

  if not(AConnection is TADOConnection) then
  begin
    Exit;
  end;

  Result := TADOQuery.Create(nil);

  if not Assigned(Result) then
  begin
    Exit;
  end;

  Result.Connection := AConnection as TADOConnection;
  Result.CommandTimeout := Result.Connection.CommandTimeout;
  Result.LockType := ltReadOnly;
  Result.CursorType := ctOpenForwardOnly;
end;

function GetQuery(const AConnection: TCustomConnection): TDataSet;
begin
  Result := nil;

  if not Assigned(AConnection) then
  begin
    Exit;
  end;

  if AConnection is TADOConnection then
  begin
    Result := GetADOQuery(AConnection);
  end;
end;

function SendEMail(const aSMTP: TIdSMTP; const aEMail: TIdMessage; var aLogMessage: string): Boolean;
begin;
  Result := False;

  try
    if aSMTP.Connected() then
    begin
      aSMTP.Disconnect();
    end;

    aSMTP.Connect();
    try
      aSMTP.Send(aEMail);
      aLogMessage := Format(RsSended, [aEMail.Subject, aEMail.Recipients.EMailAddresses]);
      Result := True;
    finally
      aSMTP.Disconnect();
    end;
  except
    on e: Exception do
    begin
      aLogMessage := e.ToString();
    end;
  end;
end;

function SaveDatasetToCSV(const aDataSet: TADOQuery; const aFileName, aTitle: string): Boolean;
var
  i, j: Integer;
  tmpLine: string;
  tmpTextFile: Text;
begin
  Result := False;

  if not Assigned(aDataSet) then
  begin
    Exit;
  end;

  if not aDataSet.Active then
  begin
    Exit;
  end;

  if aDataSet.IsEmpty() then
  begin
    Exit;
  end;

  aDataSet.First();

  Assign(tmpTextFile, aFileName);
  try
    Rewrite(tmpTextFile);

    if not aTitle.IsEmpty() then
    begin
      Writeln(tmpTextFile, aTitle);
    end;

    for i := 0 to Pred(aDataSet.RecordCount) do
    begin
      tmpLine := EmptyStr;
      if aDataSet.Eof then
      begin
        Break;
      end;

      for j := 0 to Pred(aDataSet.Fields.Count) do
      begin
        tmpLine := tmpLine + aDataSet.Fields[j].AsString.Trim() + ';';
      end;
      SetLength(tmpLine, Pred(Length(tmpLine)));
      Writeln(tmpTextFile, tmpLine);
      aDataSet.Next();
    end;
    Result := aDataSet.Eof;
  finally
    CloseFile(tmpTextFile);
  end;
end;

function Caesar(const aValue: string): string;
var
  i: Integer;
begin
  Result := aValue;
  for i := 1 to Length(Result) do
  begin
    Result[i] := Pred(Result[i]);
  end;
end;

function FilePathLocalization(var aFileName, aShare: string; const aSubDirectory: string): Boolean;
begin
  aShare := ExtractFileDrive(aFileName); // для определения типа имени файла
  if aShare.IsEmpty() then // если в имени файла ни диска ни шары
  begin
    case aFileName.IndexOf('\') of
      0:
        begin // - относительный путь
          aFileName := Format('%s%s%s', [ExtractFilePath(ParamStr(0)), aSubDirectory, aFileName]); // дописываем папку по умолчанию
        end;
      1:
        begin
          // - подвязка по подкаталогу либо каталогу исполняемого файла
          if aFileName.Contains('\' + aSubDirectory) then
          begin
            aFileName := Format('%s%s%s', [ExtractFileDir(ParamStr(0)), aFileName.Substring(aFileName.IndexOf('\' + aSubDirectory))]);
          end
          else
          begin
            aFileName := Format('%s%s', [ExtractFilePath(ParamStr(0)), aFileName]);
          end
        end
    else
      begin
        // - префиксный путь просто игнорируется
        aFileName := Format('%s%s', [ExtractFilePath(ParamStr(0)), ExtractFileName(aFileName)]);
      end;
    end;
  end
  else
  begin
    if aShare.Substring(1, 2) = '\\' then // назначение на удалённом сервере
    begin // сохранение шары в буфер & подстановка каталога для локального сохранения
      aShare := aFileName;
      aFileName := ChangeFilePath(aFileName, ExtractFilePath(ParamStr(0)));
    end
    else
    begin
      aShare := EmptyStr; // share='<Drive>:\' => исходный путь не требует преобразования
    end;
  end;
  Result := not aShare.IsEmpty(); // в результате "выполнена подмена на локальный путь сохранения"
end;

end.
