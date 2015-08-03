unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  DB, ADODB, ActiveX, SyncObjs, dbisamtb, DateUtils;

const
  cAMDConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;';
  cCustomAutorityParams = 'Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s;';

  //[DATABASE]
  cSQLServerDef = 'svbyminsd9';
  cDatabaseNameDef = 'CLIENT_DATA';
  cDBUserDef = 'Admin';
  cDBPasswordDef = 'Admin';
     
  //MAIL
  cReportSysErrorsDef = '';
  cReportUserErrorsDef = '';
  cMailHostDef = '10.0.0.1';
  cMailPortDef = 25;
  cMailUserDef = '';
  cMailPasswordDef = '';

  cDEF_QuantsFileName = 'quants.csv';
  cDEF_QuantsExFileName = 'quants_ext.csv';


type
  TPrefs = record
    //MAIN
    DebugLogEnabled: Boolean;
    ScanQuantsInterval: Cardinal;
    QuantsSearchPaths: string;
    LimitsSearchPaths: string;
    CodesMapFile: string;
    BrandsShinaMapFile: string;

    //имена файлов источников
    QuantsFileName: string;    //остатки
    QuantsExFileName: string;  //остатки по рынкам


    PricesMinSize: Int64;
    PricesClientsMinSize: Int64;
    QuantsMinSize: Int64;
    QuantsExMinSize: Int64;
    LimitsMinSize: Int64;

    IntervalOfExportFiles: integer;
    DelayBeforeExport:integer;
    
    BulkInsertQuantsConfigFile: string;
    BulkInsertPricesConfigFile: string;
    BulkInsertClientsPricesConfigFile: string;
    BulkInsertLimitsConfigFile: string;
    
    //DATABASE
    SqlServerName: string;
    DatabaseName: string;
    DBUser: string;
    DBPassword: string;

    //NET
    NetUser: string;
    NetPassword: string;
    UnmountDriveIfUsed: Boolean;

    //MAIL
    ReportOldOrders: string;
    ReportSysErrors: string;
    ReportUserErrors: string;
    MailHost: string;
    MailPort: Integer;
    MailUser: string;
    MailPassword: string;
  end;

type  
  TServiceQuantsProcessing = class(TService)
    memCodesMap: TDBISAMTable;
    DBISAMEngine: TDBISAMEngine;
    memCodesMapCodeOld: TStringField;
    memCodesMapCodeNew: TStringField;

    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceDestroy(Sender: TObject);
  private
    fMailSendThread: TThread;
    fProcessThread: TThread;
    fLogLock: TCriticalSection;
    
    fListMessages: TThreadList;

    fMappedDrives: string; //e.g. 'XYZ'

    fLogFileName: string;
    fIniFileName: string;
    fExePath: string;
    fTempPath: string;
    fFileOutPath: string;

    fAborted: Boolean;
    fServiceHasStarted: Boolean;

    fRegisteredPaths: TStrings;
    fQuantsPaths, fLimitsPaths: TStrings;

    fLastImportDate: TDateTime;
    //INI prefs
    fPrefs: TPrefs;

    fRatesHash: string;
    fQuantsHash: string;
    fQuantsStockHash: string;
    fPricesHash: string;
    fPricesClientsHash: string;    
    fLimitsHash: string;

    fCodesMap: TStrings;
    
    procedure LoadINI;

    //Запись/чтение с ini
    procedure WriteHashTheLastImportFile(const aSection, aIdent, aValue: string);
    procedure WriteTheLastExportDate(const aDate: TDateTime);
    function ReadTheLastExportDate():TDateTime;

    procedure LogPrefs;

    procedure ProcessMessages;

    function MapNetDrive(aDrive: Char; const aPath: string; UnmapBefore: Boolean = False): Boolean;
    function UnmapNetDrive(aDrive: Char): Boolean;
    procedure ProcessPaths(aPathsList: TStrings);
    procedure UnmapAllDrives;

    //Export final file
    procedure DoAllExports(const aPathIn, aPathOut: string);
    procedure DoExportShateShina(aConn: TAdoConnection; const anOutFile, anOutServerFile: string);
    procedure ExportQuantsShateMag(aConn: TAdoConnection; const anOutFile, anOutServerFile: string; aQuantsRaw: Boolean = False {некодированные остатки});
    procedure ExportQuants(aConn: TAdoConnection; const anOutFile, anOutServerFile: string; aQuantsRaw: Boolean = False; aQuantsOnlyBYR: Boolean = FALSE);
    function NeedToDoExport(): boolean;

  public
    function GetServiceController: TServiceController; override;

    //Log
    procedure AddLog(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);

    procedure AddEmailReport(const aText: string; isSysReport: Boolean);

    //DB tools
    function  DBConnectNew(IsTest: Boolean = False): TAdoConnection;
    procedure DBDisconnectNew(var aConnection: TAdoConnection);

    //Work in thread1
    procedure RenameQuants;
    procedure RenamePrices;
    procedure RenamePricesClient;

    procedure RenameQuantsEx(aForceExport: Boolean = False);
    procedure RenameKurses;
    procedure RenameLimits;

    procedure CheckToDoExport;
  
    //DeCoding
    procedure PrepareEncodingFile(const aFileNameServ, aNewFileNameLocal : string; const fNeedSeparatorInTheEndLine: boolean = FALSE);
    function ReMapCode(aCode: string): string;
    procedure DeteleTempFiles(aFileName: string);

  end;

var
  ServiceQuantsProcessing: TServiceQuantsProcessing;

implementation

{$R *.DFM}

uses
  uSMTPThread, uProcessThread, uSysGlobal, Variants,
  md5, IniFiles, WinSvc, AdoDBUtils, StrUtils, ComObj,
  _CSVReader;

{ Global }

  function Dos2Ansi(const aStr: string): string;
  begin
    Result := '';
    if aStr = '' then
      Exit;

    SetLength(Result, Length(aStr));
    if not OemToChar(PChar(aStr), PChar(Result)) then
      raise Exception.Create(SysErrorMessage(GetLastError));
  end;

function GetFileSize_Internal(const aFileName: string): Int64;
var
  aStream: TFileStream;
begin
  Result := 0;
  if not FileExists(aFileName) then
    Exit;

  aStream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := aStream.Size;
  finally
    aStream.Free;
  end;
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
//  ServiceQuantsProcessing.AddLog('CtrlCode: ' + IntToStr(CtrlCode), True);
  ServiceQuantsProcessing.Controller(CtrlCode);
end;


{ TServiceMK }

function TServiceQuantsProcessing.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServiceQuantsProcessing.ServiceCreate(Sender: TObject);
begin
  fLogLock := TCriticalSection.Create;
  
  fListMessages := TThreadList.Create;
  fRegisteredPaths := TStringList.Create;
  fQuantsPaths := TStringList.Create;
  fLimitsPaths := TStringList.Create;
  fCodesMap := TStringList.Create;
  fLogFileName := ChangeFileExt(ExpandFileName(ParamStr(0)), '.log');
  fIniFileName := ChangeFileExt(ExpandFileName(ParamStr(0)), '.ini');
  fExePath := ExtractFilePath(ParamStr(0));
  fTempPath := ExtractFilePath(ParamStr(0)) + 'Temp\';
  // инициализируем текущей датой - 1 месяц
  fLastImportDate := IncMonth(Now(), -1);

  if not DirectoryExists(fTempPath) then
    ForceDirectories(fTempPath);
  
  ZeroMemory(@fPrefs, SizeOf(fPrefs));

  memCodesMap.CreateTable;
  LoadINI;
end;

procedure TServiceQuantsProcessing.ServiceDestroy(Sender: TObject);
begin
  memCodesMap.Close;
  memCodesMap.Free;

  fRegisteredPaths.Free;
  fQuantsPaths.Free;
  fLimitsPaths.Free;
  fLogLock.Free;
  fListMessages.Free;
  fCodesMap.Free;

  if fServiceHasStarted then
  begin
    AddLog('Служба остановлена');
    AddLog('**************************************', False, True);
  end;
end;

procedure TServiceQuantsProcessing.ServiceStart(Sender: TService; var Started: Boolean);
var
  aConn: TAdoConnection;
begin
  AddLog(#13#10#13#10'**************************************', False, True);
  AddLog('Запуск службы...');
  LogPrefs;
//  if (Trim(fPrefs.MailHost) = '') or (fPrefs.MailPort <= 0) then
//    AddLog('Зарегистрированные пути: '#13#10 + fRegisteredPaths.Text, True);

  AddLog('Зарегистрированные пути: '#13#10 + fRegisteredPaths.Text, True);
  ProcessPaths(fRegisteredPaths);
  AddLog('Подключенные диски: ' + fMappedDrives);
  AddLog('Зарегистрированные пути после обработки: '#13#10 + fRegisteredPaths.Text, True);
  AddLog('fQuantsPaths: ' + fQuantsPaths.Text);
  AddLog('fLimitsPaths: ' + fLimitsPaths.Text);

  if fQuantsPaths.Count > 0 then
    fFileOutPath := fQuantsPaths[0] + 'Norm\';

  AddLog('Проверка подключения к SQL-серверу', True);
  aConn := DBConnectNew(True{IsTest});
  DBDisconnectNew(aConn);

  Started := True;
  fServiceHasStarted := True;
  AddLog('Служба запущена');

  
  fProcessThread := TProcessThread.Create(Self);
  TProcessThread(fProcessThread).Init(fPrefs);
  fProcessThread.Resume;
end;

procedure TServiceQuantsProcessing.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  AddLog('Остановка службы...');
  fAborted := True;

  //говорим потокам чтоб завершались
  if Assigned(fProcessThread) then
    fProcessThread.Terminate;

  if Assigned(fMailSendThread) then
    fMailSendThread.Terminate;


  //ждем завершения потоков
  if Assigned(fProcessThread) then
  begin
    fProcessThread.WaitFor;
    fProcessThread.Free;
  end;
  if Assigned(fMailSendThread) then
  begin
    fMailSendThread.WaitFor;
    fMailSendThread.Free;
  end;


//  UnmapAllDrives; //только после завершения TIMAPThread, т.к. он использует подключенные диски
  Stopped := True;
end;

procedure TServiceQuantsProcessing.AddEmailReport(const aText: string; isSysReport: Boolean);
var
  aClient: TMessSMTP;
begin
  aClient := TMessSMTP.Create;

  aClient.email := 'QUANTS Processing Service';//from
  if isSysReport then
  begin
    aClient.ShateEmail := fPrefs.ReportSysErrors;//to
    aClient.subj := 'QUANTS Processing Service - оповещение о системных ошибках';
  end
  else
  begin
    aClient.ShateEmail := fPrefs.ReportUserErrors;//to
    aClient.subj := 'QUANTS Processing Service - оповещение об ошибках';
  end;

  aClient.fn := '';
  aClient.Host := fPrefs.MailHost;
  aClient.Port := fPrefs.MailPort;
  aClient.Username := '';
  aClient.Password := '';
  aClient.Body := aText;

  if (Trim(aClient.ShateEmail) <> '') and
     (fPrefs.MailHost <> '') and
     (fPrefs.MailPort > 0) then
  begin
    //thread-safe add
    fListMessages.Add(aClient);
  end
  else
    aClient.Free;
end;

procedure TServiceQuantsProcessing.AddLog(const aText: string; isDebug: Boolean; aWithoutDateTime: Boolean);
var
  f: TextFile;
  aDebugLabel: string;
begin
  if isDebug and not fPrefs.DebugLogEnabled then
    Exit;

  fLogLock.Enter;
  try
    if isDebug then
      aDebugLabel := '# '
    else
      aDebugLabel := '';

    AssignFile(f, fLogFileName);
    if not FileExists(fLogFileName) then
      Rewrite(f)
    else
      Append(f);
    try
      if aWithoutDateTime then
        Writeln(f, aDebugLabel + aText)
      else
        Writeln(f, FormatDateTime('dd.mm.yyyy hh:nn:ss', Now()) + ' - ' + aDebugLabel + aText);
    finally
      CloseFile(f);
    end;
  finally
    fLogLock.Leave;
  end;
end;


procedure TServiceQuantsProcessing.CheckToDoExport;
begin
  if NeedToDoExport() then
    DoAllExports(fTempPath, fFileOutPath);
end;

function TServiceQuantsProcessing.NeedToDoExport: boolean;
begin
  //Выгрузки не было 2ч + Интервал больше 10 мин и меньще 2ч (так называемая проверка на актуальность цен и наличия)
  Result := (MinutesBetween(Now(), ReadTheLastExportDate()) > fPrefs.IntervalOfExportFiles) and
               (MinutesBetween(Now(), fLastImportDate) > fPrefs.DelayBeforeExport) and
                  (MinutesBetween(Now(), fLastImportDate) < fPrefs.IntervalOfExportFiles);
end;

procedure TServiceQuantsProcessing.LoadINI;
var
  aIni: TIniFile;
  i: Integer;
begin
  aIni := TIniFile.Create(fIniFileName);
  try
    //[MAIN]
    fPrefs.DebugLogEnabled := aINI.ReadBool('MAIN', 'EnableDebugLog', fPrefs.DebugLogEnabled);
    fPrefs.ScanQuantsInterval := aINI.ReadInteger('MAIN', 'ScanQuantsInterval', 60);
    fPrefs.BrandsShinaMapFile := aINI.ReadString('MAIN', 'BrandsShinaMapFile', 'TiresBrands.csv');

    fPrefs.QuantsFileName := aINI.ReadString('MAIN', 'QuantsFileName', cDEF_QuantsFileName);
    fPrefs.QuantsExFileName := aINI.ReadString('MAIN', 'QuantsExFileName', cDEF_QuantsExFileName);

    fPrefs.PricesMinSize := aINI.ReadInteger('MAIN', 'PricesMinSize', 10 * 1024 {10 kB});
    fPrefs.QuantsMinSize := aINI.ReadInteger('MAIN', 'QuantsMinSize', 10 * 1024 {10 kB});
    fPrefs.PricesClientsMinSize := aINI.ReadInteger('MAIN', 'PricesClientsMinSize', 10 * 1024 {10 kB});
    fPrefs.QuantsExMinSize := aINI.ReadInteger('MAIN', 'QuantsExMinSize', 10 * 1024 {10 kB});
    fPrefs.LimitsMinSize := aINI.ReadInteger('MAIN', 'LimitsMinSize', 10 * 1024 {10 kB});

    fPrefs.BulkInsertQuantsConfigFile := aINI.ReadString('MAIN', 'BulkInsertQuantsConfigFile', '');
    fPrefs.BulkInsertPricesConfigFile := aINI.ReadString('MAIN', 'BulkInsertPricesConfigFile', '');
    fPrefs.BulkInsertClientsPricesConfigFile := aINI.ReadString('MAIN', 'BulkInsertClientsPricesConfigFile', '');

    fPrefs.BulkInsertLimitsConfigFile := aINI.ReadString('MAIN', 'BulkInsertLimitsConfigFile', '');
    fPrefs.QuantsSearchPaths := aINI.ReadString('MAIN', 'QuantsSearchPaths', '');
    fPrefs.LimitsSearchPaths := aINI.ReadString('MAIN', 'LimitsSearchPaths', '');

    fPrefs.IntervalOfExportFiles := aINI.ReadInteger('MAIN', 'IntervalOfExportFiles', 120);
    fPrefs.DelayBeforeExport := aINI.ReadInteger('MAIN', 'DelayBeforeExport', 10);

    fPrefs.CodesMapFile := aINI.ReadString('MAIN', 'CodesMapFile', '');
    try
      fCodesMap.LoadFromFile(fExePath + fPrefs.CodesMapFile);
      memCodesMap.ImportTable(fExePath + fPrefs.CodesMapFile, '=');
    except
    end;

    //[DATABASE]
    fPrefs.SqlServerName := aINI.ReadString('DATABASE', 'SqlServerName', cSQLServerDef);
    fPrefs.DatabaseName := aINI.ReadString('DATABASE', 'DatabaseName', cDatabaseNameDef);
    fPrefs.DBUser := aINI.ReadString('DATABASE', 'DBUser', '');
    fPrefs.DBPassword := aINI.ReadString('DATABASE', 'DBPassword', '');
    if fPrefs.DBUser = '' then
    begin
      fPrefs.DBUser := cDBUserDef;
      fPrefs.DBPassword := cDBPasswordDef;
    end;

    //[PATHS]
    aINI.ReadSectionValues('PATHS', fRegisteredPaths);
    for i := fRegisteredPaths.Count - 1 downto 0 do
    begin
      if (Trim(fRegisteredPaths[i]) = '') or (Copy(Trim(fRegisteredPaths[i]), 1, 1) = '#') then
        fRegisteredPaths.Delete(i);
    end;

    //[MAIL]
    fPrefs.ReportSysErrors := aINI.ReadString('MAIL', 'ReportSysErrors', cReportSysErrorsDef);
    fPrefs.ReportUserErrors := aINI.ReadString('MAIL', 'ReportUserErrors', cReportUserErrorsDef);
    
    
    fPrefs.MailHost := aINI.ReadString('MAIL', 'MailHost', cMailHostDef);
    fPrefs.MailPort := aINI.ReadInteger('MAIL', 'MailPort', cMailPortDef);
    fPrefs.MailUser := aINI.ReadString('MAIL', 'MailUser', cMailUserDef);
    fPrefs.MailPassword := aINI.ReadString('MAIL', 'MailPassword', cMailPasswordDef);
    
  finally
    aIni.Free;
  end;
end;

procedure TServiceQuantsProcessing.LogPrefs;
begin
  AddLog(
    Format(
      '#'#13#10 +
      '#  Общие настройки-----------------------'#13#10 +
      '#    отладочный лог: %d'#13#10 +
      '#    интервал поиска файлов: %d'#13#10 +
      '#  БД------------------------------------'#13#10 +
      '#    SQL-сервер: %s'#13#10 +
      '#    база данных: %s'#13#10 +
      '#    пользователь БД: %s'#13#10 +
      '#  Сеть----------------------------------'#13#10 +
      '#    демонтировать занятые сетевые диски: %d'#13#10 +
      '#    сетевой пользователь: %s'#13#10 +
      '#  E-Mail--------------------------------'#13#10 +
      '#    отсылать системные ошибки: %s'#13#10 +
      '#    отсылать ошибки загрузок: %s'#13#10 +
      '#    e-mail сервер: %s'#13#10 +
      '#    e-mail порт: %d'#13#10 +
      '#    e-mail пользователь: %s',
      [
        Integer(fPrefs.DebugLogEnabled),
        fPrefs.ScanQuantsInterval,

        fPrefs.SqlServerName,
        fPrefs.DatabaseName,
        fPrefs.DBUser,

        Integer(fPrefs.UnmountDriveIfUsed),
        fPrefs.NetUser,

        fPrefs.ReportSysErrors,
        fPrefs.ReportUserErrors,
        fPrefs.MailHost,
        fPrefs.MailPort,
        fPrefs.MailUser

      ]
    ), False, True
  );

  if fCodesMap.Count > 0 then
    AddLog('#    Файл старых кодов ' + fPrefs.CodesMapFile + ', загружено: ' + IntToStr(fCodesMap.Count), False, True);
    
  memCodesMap.Open;
  AddLog('#    Таблица старых кодов, загружено: ' + IntToStr(memCodesMap.RecordCount), False, True);
  memCodesMap.Close;
end;


function TServiceQuantsProcessing.MapNetDrive(aDrive: Char;
  const aPath: string; UnmapBefore: Boolean): Boolean;
var
  sDrive: string;
  NR: TNetResource;
  aErrCode: Cardinal;
begin
  AddLog( Format('Монтирование диска %s <- %s', [aDrive, aPath]) );
  sDrive := aDrive + ':';
  NR.dwType := RESOURCEType_DISK;
  NR.lpLocalName := PChar(sDrive);
  NR.lpRemoteName := PChar(aPath);
  NR.lpProvider := nil;

  aErrCode := WNetAddConnection2(NR, PChar(fPrefs.NetPassword), PChar(fPrefs.NetUser), 0);
  if (aErrCode = ERROR_ALREADY_ASSIGNED) and (UnmapBefore) then
  begin
    AddLog( Format('!Ошибка монтирования диска %s: [%d] %s', [aDrive, aErrCode, SysErrorMessage(aErrCode)]) );
    UnmapNetDrive(aDrive);
    AddLog( Format('ПОВТОР: Монтирование диска %s <- %s', [aDrive, aPath]) );
    aErrCode := WNetAddConnection2(NR, PChar(fPrefs.NetPassword), PChar(fPrefs.NetUser), 0);
  end;

  Result := aErrCode = NO_ERROR;
  if not Result then
  begin
    //aErrCode := GetLastError;
    //можно обработать еще ERROR_EXTENDED_ERROR
    AddLog( Format('!Ошибка монтирования диска %s: [%d] %s', [aDrive, aErrCode, SysErrorMessage(aErrCode)]) );
  end;
end;

function TServiceQuantsProcessing.UnmapNetDrive(aDrive: Char): Boolean;
var
  sDrive: string;
  aErrCode: Cardinal;
begin
  AddLog( Format('Демонтирование диска %s', [aDrive]) );
  sDrive := aDrive + ':';
  aErrCode := WNetCancelConnection2(PChar(sDrive), 0, True);
  Result := aErrCode = NO_ERROR;
  if not Result then
    AddLog( Format('!Ошибка демонтирования диска %s: [%d] %s', [aDrive, aErrCode, SysErrorMessage(aErrCode)]) );
end;

procedure TServiceQuantsProcessing.WriteHashTheLastImportFile(const aSection,
  aIdent, aValue: string);
var
  aIni: TIniFile;
begin
  aIni := TIniFile.Create(fIniFileName);
  try
    aIni.WriteString(aSection, aIdent, aValue);
  finally
    aIni.Free;
  end;
end;

procedure TServiceQuantsProcessing.WriteTheLastExportDate(const aDate: TDateTime);
var
  aIni: TIniFile;
begin
  aIni := TIniFile.Create(fIniFileName);
  try
    aIni.WriteDateTime('SERVICE', 'LastExport', aDate);
  finally
    aIni.Free;
  end;
end;

procedure TServiceQuantsProcessing.UnmapAllDrives;
var
  i: Integer;
begin
  for i := 1 to Length(fMappedDrives) do
    UnmapNetDrive(fMappedDrives[i]);
end;

//обработка путей поиска, подключение сетевых дисков
procedure TServiceQuantsProcessing.ProcessPaths(aPathsList: TStrings);

  function ReplacePathVars(const aText: string): string;
  var
    i: Integer;
  begin
    Result := AnsiUpperCase(aText);
    for i := 0 to aPathsList.Count - 1 do
      Result := StringReplace(Result, '%' + StrGetName(aPathsList[i]) + '%', StrGetValue(aPathsList[i]), [rfIgnoreCase, rfReplaceAll]);
  end;

  procedure NormalizePaths(aList: TStrings);
  var
    i: Integer;
  begin
    for i := aList.Count - 1 downto 0 do
    begin
      aList[i] := Trim(aList[i]);
      if aList[i] = '' then
        aList.Delete(i)
      else
        if POS('%', aList[i]) > 0 then
        begin
          AddLog('!переменная пути не распознана, путь исключен: ' + aList[i]);
          aList.Delete(i);
        end
        else
        begin
          aList[i] := StringReplace(aList[i], '\\', '\', [rfReplaceAll]);
          aList[i] := StringReplace(aList[i], '\\', '\', [rfReplaceAll]);
          if Copy(aList[i], 1, 1) = '\' then
            aList[i] := '\' + aList[i];
          aList[i] := IncludeTrailingPathDelimiter(aList[i]);
        end;
    end;
  end;

  procedure RemoveEmptyStrings(aList: TStrings);
  var
    i: Integer;
  begin
    for i := aList.Count - 1 downto 0 do
    begin
      if Trim(aList[i]) = '' then
        aList.Delete(i);
    end;
  end;

var
  i, aIndex: Integer;
  aVar, aPath, aDrive: string;
begin
  AddLog('Обработка зарегистрированных путей', True);

// test  MapNetDrive('x', '\\Poligon\Photo');
  for i := 0 to aPathsList.Count - 1 do
  begin
    aVar := AnsiUpperCase( StrGetName(aPathsList[i]) );
    aPath := AnsiUpperCase( StrGetValue(aPathsList[i]) );
    aPath := Trim(aPath);

    aDrive := Copy(aPath, Length(aPath) - 2);
    if (Length(aDrive) = 3) and (aDrive[1] = '[') and (aDrive[3] = ']') then
    begin
      aDrive := aDrive[2];
      aPath := ExcludeTrailingPathDelimiter( Copy(aPath, 1, Length(aPath) - 3) );
      aPath := Trim(aPath);
    end
    else
      aDrive := '';

    aIndex := aPathsList.IndexOf(aPath);
    if (aIndex >= 0) and (aIndex < i) then //дубликат пути
    begin
      aPathsList[i] := '';
      Continue;
    end;

    if aDrive <> '' then
    begin
      if POS(aDrive[1], fMappedDrives) > 0 then //уже подключен в этом сеансе
      begin
        //aPathsList[i] := '';
        //AddLog('!сетевой диск уже подключен' + aDrive[1]);
      end
      else
        if MapNetDrive(aDrive[1], aPath, fPrefs.UnmountDriveIfUsed) then //подключаем сетевой диск
        begin
          aPath := aDrive[1] + ':\';
          fMappedDrives := fMappedDrives + aDrive[1];
        end;
    end;
    aPathsList[i] := aVar + '=' + IncludeTrailingPathDelimiter(aPath);
  end;

  RemoveEmptyStrings(aPathsList);

  AddLog('Обработка путей поиска', True);
  fQuantsPaths.Delimiter := ';';
  fQuantsPaths.DelimitedText := ReplacePathVars(fPrefs.QuantsSearchPaths);
  NormalizePaths(fQuantsPaths);

  fLimitsPaths.Delimiter := ';';
  fLimitsPaths.DelimitedText := ReplacePathVars(fPrefs.LimitsSearchPaths);
  NormalizePaths(fLimitsPaths);

end;


procedure TServiceQuantsProcessing.PrepareEncodingFile(const aFileNameServ, aNewFileNameLocal : string; const fNeedSeparatorInTheEndLine: boolean = FALSE);

  function DosToWin(St: string): string;
  var
    Ch: PChar;
  begin
    Ch := StrAlloc(Length(St) + 1);
    OemToAnsi(PChar(St), Ch);
    Result := Ch;
    StrDispose(Ch)
  end;

var
  aReader: TCSVReader;
  F: textfile;
  str: TStringList;
begin
  AddLog('конверт файла в ANSI [' + aFileNameServ + ']', True);
  DeleteFile(aFileNameServ + '_Old'); 
  aReader := TCSVReader.Create;
  str := TStringList.Create;
  AssignFile(F, aNewFileNameLocal);

  try
    aReader.Open(aFileNameServ);
    Rewrite(F);

    while not aReader.Eof do
    begin
      if fNeedSeparatorInTheEndLine then
        str.Append(aReader.ReturnLine + ';')
      else
        str.Append(aReader.ReturnLine);

      if str.Count mod 1000 = 0 then
      begin
        Writeln(F, DosToWin(str.Text));
        str.Clear;
      end;
    end;
    if str.Count > 0 then
      Writeln(F, DosToWin(str.Text));

  finally
    aReader.Free;
    str.Free;
    CloseFile(F);
  end;
  
  RenameFile(aFileNameServ, aFileNameServ + '_Old');
  CopyFile(pChar(aNewFileNameLocal), pChar(aFileNameServ), FALSE);
  AddLog('конверт OK', True);
end;

procedure TServiceQuantsProcessing.ProcessMessages;
begin
  ServiceThread.ProcessRequests(False);
  fAborted := Terminated;
end;


function TServiceQuantsProcessing.DBConnectNew(IsTest: Boolean): TAdoConnection;
begin
  try
    try
      Result := TAdoConnection.Create(nil);
      Result.CursorLocation := clUseClient;
    except
      on E: EOleSysError do
      begin
        if E.ErrorCode = -2147221008 then //$800401F0
        begin
          AddLog('CoInitializeEx(nil, COINIT_MULTITHREADED)');
          CoInitializeEx(nil, COINIT_MULTITHREADED);
          Result := TAdoConnection.Create(nil);
        end
        else
          raise;
      end;

      on E: Exception do
        raise;
    end;

  except
    on E: Exception do
    begin
      AddLog('#Ошибка создания TAdoConnection: ' + E.Message);

      if not IsTest then
        AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!Ошибка подключения к SQL-серверу: ' + E.Message, True);

      raise;
    end;
  end;

  Result.ConnectionString :=
    cAMDConnectionString +
    Format(cCustomAutorityParams, [fPrefs.SqlServerName, fPrefs.DatabaseName, fPrefs.DBUser, fPrefs.DBPassword]);
  
  try
    Result.Connected := True;
  except
    on E: Exception do
    begin
      AddLog('#Ошибка подключения к SQL-серверу: ' + E.Message);
      Result.Free;
      Result := nil;
      raise;
    end;
  end;
  
end;

procedure TServiceQuantsProcessing.DBDisconnectNew(var aConnection: TAdoConnection);
begin
  if Assigned(aConnection) then
  begin
    aConnection.Connected := False;
    aConnection.Free;
    aConnection := nil;
  end;
end;



procedure TServiceQuantsProcessing.DeteleTempFiles(aFileName: string);
begin
  if FileExists(aFileName + '.tmp') then
    DeleteFile(aFileName + '.tmp');
  if FileExists(aFileName + '.csv') then
    DeleteFile(aFileName + '.csv');
end;

procedure TServiceQuantsProcessing.DoAllExports(const aPathIn, aPathOut: string);
var
  aConn: TADOConnection;
begin
  aConn := DBConnectNew;
  try
    AddLog('выгрузка остатков..');
    ExportQuants(aConn, aPathIn + 'quants.tmp', aPathOut + 'quants.csv');
    AddLog('Файл остатков и цен выгружен - ' + aPathOut + 'quants.csv');

    AddLog('выгрузка некодированных остатков..');
    ExportQuants(aConn, aPathIn + 'quants_raw.tmp', aPathOut + 'quants_raw.csv', True);
    AddLog('Файл некодированных остатков и цен выгружен - ' + aPathOut + 'quants_raw.csv');

    {Прайс в белке под парсинг для РБ клиентов (http://shate-m.by/data/service/quants_client.csv)}
    AddLog('выгрузка остатков для shate-m.by..');
    ExportQuants(aConn, aPathIn + 'quants_client.tmp', aPathOut + 'quants_client.csv', False, True);
    AddLog('Файл остатков и цен выгружен - ' + aPathOut + 'quants_client.csv');

    {остатки для Shate-mag + розничная цена Field[5] }
    AddLog('выгрузка остатков Shate-mag.by..');
    ExportQuantsShateMag(aConn, aPathIn + 'quants_ret.tmp', aPathOut + 'quants_ret.csv');
    AddLog('Файл остатков и цен Shate-mag.by выгружен - ' + aPathOut + 'quants_ret.csv');

    AddLog('выгрузка остатков Shate-shina.by..');
    DoExportShateShina(aConn, aPathIn + 'qnt-shina.tmp', aPathOut + 'qnt-shina.csv');
    AddLog('Файл остатков и цен Shate-shina.by выгружен - ' + aPathOut + 'qnt-shina.csv');

    //Записываем время экспорта
    WriteTheLastExportDate(Now());
    fLastImportDate := Now();
  finally
    DBDisconnectNew(aConn);
  end;
end;

procedure TServiceQuantsProcessing.DoExportShateShina(aConn: TAdoConnection;
  const anOutFile, anOutServerFile: string);
var
  aTmpFile, aCsvFile, sOut, aQuant: string;
  fOut: TextFile;
  aQuery: TAdoQuery;
  aQuantNorm, aNo, aPrice, aBrand, aSale: string;
  i, iLen, aQuantSum: Integer;
  BrandsList: TStrings;

begin
  DeteleTempFiles(ChangeFileExt(anOutFile, ''));
  AssignFile(fOut, anOutFile);
  Rewrite(fOut);
  try
    Writeln(fOut, 'IE_XML_ID;CP_QUANTITY;CV_PRICE_1;CV_CURRENCY_1;CV_SALE');

    aQuery := TAdoQuery.Create(nil);
    try
      aQuery.Connection := aConn;
      aQuery.CursorLocation := clUseClient;
      aQuery.CursorType := ctStatic;
      aQuery.DisableControls;

      BrandsList := makeStrings;

      aQuery.SQL.Text :=
        ' SELECT p.[NO], q.[QUANT], p.[PRICE], p.[CODE_BRAND], p.[SALE] ' +
        ' FROM [CLIENT_DATA].[dbo].[prices] p ' +
        ' LEFT JOIN [CLIENT_DATA].[dbo].[quants] q ON (p.NO = q.NO) ' +
        ' WHERE q.[QUANT] <> ''0'' and q.[QUANT]<> '''' and p.[PRICE] <> ''0'' ' +
        ' ORDER by p.[NO]';

      aQuery.Open;
      aQuantSum := 0;

      // Мапка шинных брендов
      try
        BrandsList.LoadFromFile(fExePath + fPrefs.BrandsShinaMapFile);
        BrandsList.Text := AnsiUpperCase(BrandsList.Text);
      except
      end;

      while not aQuery.Eof do
      begin
        //Берем только бренды производителей шин
        aBrand := AnsiUpperCase(aQuery.Fields[3].AsString);
        Delete(aBrand, 1, Pos('_', aBrand));
        if BrandsList.IndexOf(aBrand) = -1 then
        begin
          //дополнительно проверяем коды с дисками
          aBrand := AnsiUpperCase(aQuery.Fields[3].AsString);
          Delete(aBrand, Pos('_', aBrand), MaxInt);
          if BrandsList.IndexOf(aBrand) = -1 then
          begin
            aQuery.Next;
            Continue;
          end;
        end;

        aQuant := aQuery.Fields[1].AsString;
        if aQuant = '0' then
          aQuant := '';

        aQuantNorm := '';
        iLen := Length(aQuant);
        for i := 1 to iLen do
          if aQuant[i] in ['1'..'9', '0'{, '.', ','}] then
            aQuantNorm := aQuantNorm + aQuant[i];
        aQuant := aQuantNorm;

        aQuantSum := aQuantSum + StrToIntDef(aQuant, 0);
        aNo := aQuery.Fields[0].AsString;
        aPrice := aQuery.Fields[2].AsString;
        aSale := aQuery.Fields[4].AsString;

        aQuery.Next;

        if aQuery.Eof or (aNo <> aQuery.Fields[0].AsString) then
        begin
          //IE_XML_ID;CP_QUANTITY;CV_PRICE_1;CV_CURRENCY_1;CV_SALE
          aQuant := IntToStr(aQuantSum);
          sOut := aNo + ';' +
                  aQuant + ';' +
                  aPrice + ';' +
                  'BYR' + ';' +
                  aSale;
          Writeln(fOut, sOut);

          aQuantSum := 0;
          aPrice := '';
        end;
      end;
      aQuery.Close;

    finally
      BrandsList.Free;
      memCodesMap.Close;
      aQuery.Free;
    end;

  finally
    CloseFile(fOut);
  end;

  if not CopyFile(pchar(anOutFile), pchar(anOutServerFile), False) then
    AddLog('!Error(CopyFile) - ' + SysErrorMessage(GetLastError()));
  RenameFile(anOutFile, ChangeFileExt(anOutFile, '.csv'));
  AddLog('Выгружен в ' + aCsvFile);
end;

procedure TServiceQuantsProcessing.ExportQuants(aConn: TAdoConnection;
  const anOutFile, anOutServerFile: string; aQuantsRaw,
  aQuantsOnlyBYR: Boolean);

   function AToCurr(aValue: string; aDef: Extended; const aCode: string): Currency;
   var
     aNorm: string;
   begin
     aNorm := aValue;
     if DecimalSeparator <> '.' then
       aNorm := StringReplace(aNorm, '.', DecimalSeparator, [rfReplaceAll]);
     if DecimalSeparator <> ',' then
       aNorm := StringReplace(aNorm, ',', DecimalSeparator, [rfReplaceAll]);

     try
       Result := StrToFloat(aNorm);
     except
       Result := aDef;
       if aValue <> '' then
         AddLog('!Кривая цена (' + aCode + '): ' + aValue);
     end;

   end;

var
  aQuery: TAdoQuery;
  fOut: TextFile;
  sOut, aQuant, aQuantNorm, sPriceAndSaleRF: string;
  iQuant: Integer;
  i, iLen: Integer;
  aCode, aCodeNew: string;
  aCount: Integer;

  aBYRRate: integer;
  sPrice, sPathRate: string;
  aListRates: TStrings;
  
begin
  aCount := 0;
  aBYRRate := 1;
    
  if aQuantsOnlyBYR then
  begin
    sPathRate := fFileOutPath + 'StockRates.csv';
    if not FileExists(sPathRate) then
    begin
      AddLog('Не найден файл курсов!!! ' + sPathRate);
      exit;
    end;

    aListRates := TStringList.Create;
    try
      aListRates.LoadFromFile(sPathRate);
      aBYRRate := StrToIntDef(Copy(aListRates[1], pos(';', aListRates[1]) + 1, MaxInt), 1)
    finally
      aListRates.Free;
    end;
  end;
    

  DeteleTempFiles(ChangeFileExt(anOutFile, ''));
  AssignFile(fOut, anOutFile);
  Rewrite(fOut);
  try

    aQuery := TAdoQuery.Create(nil);
    memCodesMap.Open;
    memCodesMap.DisableControls;
    try
      aQuery.Connection := aConn;
      aQuery.CursorLocation := clUseClient;
      aQuery.CursorType := ctStatic;
      aQuery.DisableControls;

      aQuery.SQL.Text :=
        ' SELECT q.[CODE_BRAND], q.[QUANT], coalesce(p.[PRICE], ''0''), coalesce(p.[SALE], ''0''), ' +
        ' coalesce(p.[PRICE_OPT_RF], ''0''), coalesce(p.[SALE_OPT_RF], ''0'') ' +
        ' FROM [CLIENT_DATA].[dbo].[quants] q ' +
        ' LEFT JOIN [CLIENT_DATA].[dbo].[PRICES_CLIENTS] p ON (p.NO = q.NO) ';
      aQuery.Open;
      while not aQuery.Eof do
      begin
        aQuant := aQuery.Fields[1].AsString;
        aQuantNorm := '';
        if aQuant <> '' then
        begin
          iLen := Length(aQuant);
          for i := 1 to iLen do
            if aQuant[i] in ['1'..'9', '0'{, '.', ','}] then
              aQuantNorm := aQuantNorm + aQuant[i];
          aQuant := aQuantNorm;

          //кодируем остатки при необходимости
          if not aQuantsRaw then
          begin
            iQuant := StrToIntDef(aQuant, -1);
            if (iQuant >= 10) and (iQuant < 50) then
              aQuant := '10>'
            else
              if (iQuant >= 50) and (iQuant < 100) then
                aQuant := '50>'
              else
                if (iQuant >= 100) then
                  aQuant := '100>';
          end;

        end;

        aCode := aQuery.Fields[0].AsString;

        {Прайс в белке под парсинг для РБ клиентов (http://shate-m.by/data/service/quants_client.csv)}
        if not aQuantsOnlyBYR then
        begin
          sPrice := aQuery.Fields[2].AsString;
          sPriceAndSaleRF := aQuery.Fields[4].AsString + ';' +
                             aQuery.Fields[5].AsString;
        end
        else
        begin
          sPrice := IntToStr(Round(AToCurr(aQuery.Fields[2].AsString, 0, aCode) * aBYRRate));
          sPriceAndSaleRF := '';
        end;

        sOut :=
          aCode  + ';' +
          aQuant + ';' +
          sPrice + ';' +
          aQuery.Fields[3].AsString + ';;0;0;' + sPriceAndSaleRF;
        Writeln(fOut, sOut);

        aCodeNew := ReMapCode(aCode);

        if aCodeNew <> '' then
        begin
          Inc(aCount);
          {Прайс в белке под парсинг для РБ клиентов (http://shate-m.by/data/service/quants_client.csv)}
          sOut := StringReplace(sOut, aCode, aCodeNew, [rfReplaceAll]);
          Writeln(fOut, sOut);
        end;

        aQuery.Next;
      end;

      if not CopyFile(pchar(anOutFile), pchar(anOutServerFile), False) then
         AddLog('!Error(CopyFile) - ' + SysErrorMessage(GetLastError()));
      RenameFile(anOutFile, ChangeFileExt(anOutFile, '.csv'));

      AddLog('Файл остатков - добавлено старых кодов: ' + IntToStr(aCount));

    finally
      memCodesMap.Close;
      aQuery.Free;
    end;

  finally
    CloseFile(fOut);
  end;
end;


procedure TServiceQuantsProcessing.ExportQuantsShateMag(aConn: TAdoConnection;
  const anOutFile, anOutServerFile: string; aQuantsRaw: Boolean);
var
  aQuery: TAdoQuery;
  fOut: TextFile;
  sOut, aQuant, aQuantNorm: string;
  iQuant: Integer;
  i, iLen: Integer;
  aCode, aCodeNew: string;
  aCount: Integer;
begin
  aCount := 0;
  DeteleTempFiles(ChangeFileExt(anOutFile, ''));
  AssignFile(fOut, anOutFile);
  Rewrite(fOut);
  try

    aQuery := TAdoQuery.Create(nil);
    memCodesMap.Open;
    try
      aQuery.Connection := aConn;
      aQuery.CursorLocation := clUseClient;
      aQuery.CursorType := ctStatic;
      aQuery.DisableControls;

       aQuery.SQL.Text :=
        ' SELECT t1.[CODE_BRAND], t1.[QUANT], q1.[PRICE], t1.[SALE], t1.[PRICE] FROM ' +
        ' (SELECT coalesce(q.[CODE_BRAND],p.[CODE_BRAND]) as [CODE_BRAND], q.[QUANT], p.[PRICE], p.[SALE], p.NO ' +
        ' FROM [CLIENT_DATA].[dbo].[prices] p ' +
        ' LEFT JOIN [CLIENT_DATA].[dbo].[quants] q ON (p.NO = q.NO)) as t1' +
        ' LEFT JOIN [CLIENT_DATA].[dbo].[prices_clients] q1 ON (t1.NO = q1.NO) ';

      aQuery.Open;
      while not aQuery.Eof do
      begin
        aQuant := aQuery.Fields[1].AsString;
        if aQuant <> '' then
        begin
          aQuantNorm := '';
          iLen := Length(aQuant);
          for i := 1 to iLen do
            if aQuant[i] in ['1'..'9', '0'{, '.', ','}] then
              aQuantNorm := aQuantNorm + aQuant[i];
          aQuant := aQuantNorm;

          //кодируем остатки при необходимости
          if not aQuantsRaw then
          begin
            iQuant := StrToIntDef(aQuant, -1);
            if (iQuant >= 10) and (iQuant < 50) then
              aQuant := '10>'
            else
              if (iQuant >= 50) and (iQuant < 100) then
                aQuant := '50>'
              else
                if (iQuant >= 100) then
                  aQuant := '100>';
          end;
        end;

        aCode := aQuery.Fields[0].AsString;//Dos2Ansi(aQuery.Fields[0].AsString);

        sOut :=
          aCode + ';' +
          aQuant + ';' +
          aQuery.Fields[2].AsString + ';' +
          aQuery.Fields[3].AsString + ';;0;0;'+
          aQuery.Fields[4].AsString;
        Writeln(fOut, sOut);

        aCodeNew := ReMapCode(aCode);

        if aCodeNew <> '' then
        begin
          Inc(aCount);

          sOut :=
            aCodeNew + ';' +
            aQuant + ';' +
            aQuery.Fields[2].AsString + ';' +
            aQuery.Fields[3].AsString + ';;0;0;' +
            aQuery.Fields[4].AsString;
          Writeln(fOut, sOut);
        end;


        aQuery.Next;
      end;

      if not CopyFile(pchar(anOutFile), pchar(anOutServerFile), False) then
        AddLog('!Error(CopyFile) - ' + SysErrorMessage(GetLastError()));

      RenameFile(anOutFile, ChangeFileExt(anOutFile, '.csv'));

      AddLog('Файл остатков - добавлено старых кодов: ' + IntToStr(aCount));

    finally
      memCodesMap.Close;
      aQuery.Free;
    end;

  finally
    CloseFile(fOut);
  end;
end;


procedure TServiceQuantsProcessing.RenameQuants;

  procedure FastLoadQuantsFile(aConn: TAdoConnection; const anInFileName, aFormatFile: string);
  var
    aQuery: TAdoQuery;
  begin
    AddLog('Загрузка остатков из ' + anInFileName);

    aQuery := TAdoQuery.Create(nil);
    try
      AddLog('очистка..');
      aQuery.Connection := aConn;
      aQuery.SQL.Text :=
        ' DROP TABLE [CLIENT_DATA].[dbo].[quants] ';
      try
        aQuery.ExecSQL;
        aQuery.Close;
      except

      end;

      aQuery.SQL.Text :=
       ' CREATE TABLE [dbo].[quants]( ' +
        ' [CODE_BRAND] [varchar](128) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [QUANT] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [NO] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [SKLAD] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL ' +
        ' ) ON [PRIMARY] ';
      aQuery.ExecSQL;
      aQuery.Close;

      aQuery.CommandTimeout := 180;
      aQuery.SQL.Text := ' BULK INSERT [CLIENT_DATA].[dbo].[quants] ' +
                         ' FROM ''' + anInFileName + '''' +
                         ' WITH (FORMATFILE = ''' + aFormatFile + ''')';
      aQuery.ExecSQL;
      AddLog('Загрузка завершена удачно');

    finally
      aQuery.Free;
    end;
  end;
 
var
  aFileNameQuants: string;
  aPath: string;
  aNewHash: string;
  aIni: TIniFile;

  aQuantsUpdated: boolean;
  aConn: TAdoConnection;
  aFileSize: Int64;
begin
  //Sleep(10000);
  aConn := DBConnectNew;
  try
    AddLog('TServiceClientData.RenameQuants', True);

    try
      aQuantsUpdated := False;

      if fQuantsPaths.Count = 0 then
        Exit;
      aPath := fQuantsPaths[0];

      aFileNameQuants := aPath + fPrefs.QuantsFileName;
      if FileExists(aFileNameQuants) then
      begin
        AddLog('Файл остатков найден - ' + aFileNameQuants);

        //checking min file size
        aFileSize := GetFileSize_Internal(aFileNameQuants);
        if aFileSize > fPrefs.QuantsMinSize then
        begin
          DeleteFile(ChangeFileExt(aFileNameQuants, '.processing'));
          if RenameFile(aFileNameQuants, ChangeFileExt(aFileNameQuants, '.processing')) then
          begin
            aFileNameQuants := ChangeFileExt(aFileNameQuants, '.processing');
            aNewHash := MD5.MD5DigestToStr(MD5.MD5File(aFileNameQuants));
            if fQuantsHash <> aNewHash then
            begin
              PrepareEncodingFile(aFileNameQuants, fTempPath + 'quants.processing', TRUE); // Кодирование Dos->Win
              FastLoadQuantsFile(aConn, aFileNameQuants, fPrefs.BulkInsertQuantsConfigFile);
              aQuantsUpdated := True;

              //Обновляем хэш
              fQuantsHash := aNewHash;
              WriteHashTheLastImportFile('SERVICE', 'QuantsHash', fQuantsHash);

              AddLog('Файл остатков загружен в БД');
              DeleteFile(ChangeFileExt(aFileNameQuants, '.processed_ok'));
              RenameFile(aFileNameQuants, ChangeFileExt(aFileNameQuants, '.processed_ok'));
            end
            else
            begin
              DeleteFile(ChangeFileExt(aFileNameQuants, '.processed'));
              RenameFile(aFileNameQuants, ChangeFileExt(aFileNameQuants, '.processed'));
            end;
          end
          else
            AddLog('ошибка переименования: ' + SysErrorMessage(GetLastError));
        end
        else
          AddLog('меньше минимально допустимого размера - пропускаем');
      end;

      {Выгружаем если обновились прайсы или устарела последняя выгрузка}
      if aQuantsUpdated and
            (MinutesBetween(Now(), fLastImportDate) > fPrefs.DelayBeforeExport) then
        fLastImportDate := Now();

    except
      on E: Exception do
      begin                                
        AddLog('!EXCEPTION: ' + E.Message);
        //AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
      end;
    end;
  finally
    DBDisconnectNew(aConn);
  end;
end;

procedure TServiceQuantsProcessing.RenameQuantsEx(aForceExport: Boolean = False);

  procedure FastLoadQuantsFile(aConn: TAdoConnection; const anInFileName, aFormatFile: string);
  var
    aQuery: TAdoQuery;
  begin
    AddLog('Загрузка рыночных остатков из ' + anInFileName);
  
    aQuery := TAdoQuery.Create(nil);
    try
      AddLog('очистка..');
      aQuery.Connection := aConn;
      aQuery.SQL.Text := 
        ' DROP TABLE [CLIENT_DATA].[dbo].[quants_market] ';
      try  
        aQuery.ExecSQL;  
        aQuery.Close;
      except

      end;

      aQuery.SQL.Text := 
        ' CREATE TABLE [dbo].[quants_market]( ' +
        ' [CODE_BRAND] [varchar](128) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [QUANT] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [NO] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [SKLAD] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL ' +
        ' ) ON [PRIMARY] ';
      aQuery.ExecSQL;
      aQuery.Close;

      aQuery.SQL.Text :=
        ' CREATE CLUSTERED INDEX [NoSklad] ON [dbo].[quants_market] ' +
        ' ( ' +
        ' 	[NO] ASC, ' +
        ' 	[SKLAD] ASC ' +
        ' )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] ';
      aQuery.ExecSQL;
      aQuery.Close;


      aQuery.CommandTimeout := 180;
      aQuery.SQL.Text := ' BULK INSERT [CLIENT_DATA].[dbo].[Quants_market] ' +
                         ' FROM ''' + anInFileName + '''' +
                         ' WITH (FORMATFILE = ''' + aFormatFile + ''')';
      aQuery.ExecSQL;
      AddLog('Загрузка завершена удачно');

    finally
      aQuery.Free;
    end;
  end;


  procedure DoExportStock_ALL(aConn: TAdoConnection; const anOutFile, anOutServerFile: string);

    function NormalizeQuant(const aValue: string): string;
    var
      aQuant, aQuantNorm: string;
      i, iLen: Integer;
    begin
      aQuant := aValue;
      if aQuant = '0' then
        aQuant := '';

      aQuantNorm := '';
      iLen := Length(aQuant);
      for i := 1 to iLen do
        if aQuant[i] in ['1'..'9', '0'{, '.', ','}] then
          aQuantNorm := aQuantNorm + aQuant[i];
      aQuant := aQuantNorm;
      Result := aQuant;
    end;

  var
    aTmpFile, aCsvFile, sOut, aQuant, aLimit: string;
    fOut: TextFile;
    aQuery: TAdoQuery;
    aCode, aCodeNew, sOutNew: string;
    aQuantNorm, s: string;
    i, iLen: Integer;
  begin
    DeteleTempFiles(ChangeFileExt(anOutFile, ''));
    AssignFile(fOut, anOutFile);
    Rewrite(fOut);
    try
      aQuery := TAdoQuery.Create(nil);
      memCodesMap.Open;
      try
        aQuery.Connection := aConn;
        aQuery.CursorLocation := clUseClient;
        aQuery.CursorType := ctStatic;
        aQuery.DisableControls;
        aQuery.CommandTimeout := 5*60;

        aQuery.SQL.Text := 'exec get_all_stock_qnt ';
        aQuery.Prepared := TRUE;

        aQuery.Open;
        while not aQuery.Eof do
        begin
          sOutNew := ReMapCode(aQuery.Fields[0].AsString);
          sOut := aQuery.Fields[0].AsString;

          for i := 1 to aQuery.Fields.Count - 1 do
          begin
            if Copy(aQuery.Fields[i].FieldName, 1, 5) = 'QUANT' then
              s := NormalizeQuant(aQuery.Fields[i].AsString)
            else
              s := aQuery.Fields[i].AsString;
            sOut := sOut + ';' + s;

            if sOutNew <> '' then
              sOutNew := sOutNew + ';' + s;
          end;

          Writeln(fOut, sOut);
          if sOutNew <> '' then
            Writeln(fOut, sOutNew);

          aQuery.Next;
        end;
        aQuery.Close;
        
      finally
        memCodesMap.Close;
        aQuery.Free;
      end;

    finally
      CloseFile(fOut);
    end;

    if not CopyFile(pchar(anOutFile), pchar(anOutServerFile), False) then
      AddLog('!Error(CopyFile) - ' + SysErrorMessage(GetLastError()));
    RenameFile(anOutFile, ChangeFileExt(anOutFile, '.csv'));
    AddLog('Выгружен в ' + aCsvFile);
  end;

var
  aFileNameQuants: string;
  aPath: string;
  aNewHash: string;
  aIni: TIniFile;

  aQuantsUpdated: Boolean;
  aConn: TAdoConnection;
  aFileSize: Int64;
begin
  aConn := DBConnectNew;
  try
    AddLog('TServiceClientData.RenameQuantsEx', True);

    try
      aQuantsUpdated := False;

      if fQuantsPaths.Count = 0 then
        Exit;
      aPath := fQuantsPaths[0];

      if not aForceExport then
      begin
        aFileNameQuants := aPath + fPrefs.QuantsExFileName;
        if FileExists(aFileNameQuants) then
        begin
          AddLog('Файл остатков рынков найден - ' + aFileNameQuants);

          //checking min file size
          aFileSize := GetFileSize_Internal(aFileNameQuants);
          if aFileSize > fPrefs.QuantsExMinSize then
          begin
            DeleteFile(ChangeFileExt(aFileNameQuants, '.processing'));
            if RenameFile(aFileNameQuants, ChangeFileExt(aFileNameQuants, '.processing')) then
            begin
              aFileNameQuants := ChangeFileExt(aFileNameQuants, '.processing');
              aNewHash := MD5.MD5DigestToStr(MD5.MD5File(aFileNameQuants));

              if fQuantsStockHash <> aNewHash then
              begin
                // >> отключено, сейчас выгрузка не из НАВа, в ANSI WIN кодировке
                //PrepareEncodingFile(aFileNameQuants, fTempPath + 'quants.processing', TRUE); // Кодирование Dos->Win
                // <<
                FastLoadQuantsFile(aConn, aFileNameQuants, fPrefs.BulkInsertQuantsConfigFile);
                aQuantsUpdated := True;

                //Обновляем хэш
                fQuantsStockHash := aNewHash;
                WriteHashTheLastImportFile('SERVICE', 'QuantsStockHash', fQuantsStockHash);

                AddLog('Файл остатков рынков загружен в БД');
                DeleteFile(ChangeFileExt(aFileNameQuants, '.processed_ok'));
                RenameFile(aFileNameQuants, ChangeFileExt(aFileNameQuants, '.processed_ok'));
              end
              else
              begin
                DeleteFile(ChangeFileExt(aFileNameQuants, '.processed'));
                RenameFile(aFileNameQuants, ChangeFileExt(aFileNameQuants, '.processed'));
              end;
            end
            else
              AddLog('ошибка переименования: ' + SysErrorMessage(GetLastError));
          end
          else
            AddLog('меньше минимально допустимого размера - пропускаем');
        end;
      end

      else
        aQuantsUpdated := True;

      {***STOCK***}
      if aQuantsUpdated then
      begin
        AddLog('Выгрузка рыночных остатков quants_all..');
        DoExportStock_ALL(aConn, fTempPath + 'quants_all.tmp', fFileOutPath + 'quants_all.csv');
        AddLog('Файлы остатков рынков выгружены');
      end;

    except
      on E: Exception do
      begin
        AddLog('!EXCEPTION: ' + E.Message);
        //AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
      end;
    end;
  finally
    DBDisconnectNew(aConn);
  end;
end;

procedure TServiceQuantsProcessing.RenamePrices;

  procedure FastLoadPricesFile(aConn: TAdoConnection; const anInFileName, aFormatFile: string);
  var
    aQuery: TAdoQuery;
  begin
    AddLog('Загрузка цен из ' + anInFileName);
  
    aQuery := TAdoQuery.Create(nil);
    try
      AddLog('очистка..');
      aQuery.Connection := aConn;
      aQuery.SQL.Text :=
        ' DROP TABLE [CLIENT_DATA].[dbo].[prices] ';
      try  
        aQuery.ExecSQL;  
        aQuery.Close;
      except

      end;

      aQuery.SQL.Text :=
        ' CREATE TABLE [dbo].[prices]( ' +
        ' [CODE_BRAND] [varchar](128) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [PRICE] [varchar](30) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [SALE] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [NO] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL ' +
        ' ) ON [PRIMARY] ';
      aQuery.ExecSQL;
      aQuery.Close;

      aQuery.SQL.Text :=
        ' CREATE CLUSTERED INDEX [No] ON [dbo].[prices] ' +
        ' ( ' +
        ' 	[NO] ASC ' +
        ' )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] ';
      aQuery.ExecSQL;
      aQuery.Close;

      aQuery.CommandTimeout := 180;
      aQuery.SQL.Text := ' BULK INSERT [CLIENT_DATA].[dbo].[Prices] ' +
                         ' FROM ''' + anInFileName + '''' +
                         ' WITH (FORMATFILE = ''' + aFormatFile + ''')';
      aQuery.ExecSQL;
      AddLog('Загрузка завершена удачно');
    finally
      aQuery.Free;
    end;
  end;


var
  aFileNamePrices: string;
  aPath: string;
  aNewHash: string;
  aIni: TIniFile;

  aPricesUpdated: Boolean;
  aConn: TAdoConnection;
  aFileSize: Int64;
begin
  aConn := DBConnectNew;
  try
    AddLog('TServiceClientData.RenamePrices', True);

    try
      aPricesUpdated := False;

      if fQuantsPaths.Count = 0 then
        Exit;
      aPath := fQuantsPaths[0];

      aFileNamePrices := aPath + 'prices.csv';
      if FileExists(aFileNamePrices) then
      begin
        AddLog('Файл цен найден - ' + aFileNamePrices);

        //checking min file size
        aFileSize := GetFileSize_Internal(aFileNamePrices);
        if aFileSize > fPrefs.PricesMinSize then
        begin
          DeleteFile(ChangeFileExt(aFileNamePrices, '.processing'));
          if RenameFile(aFileNamePrices, ChangeFileExt(aFileNamePrices, '.processing')) then
          begin
            aFileNamePrices := ChangeFileExt(aFileNamePrices, '.processing');
            aNewHash := MD5.MD5DigestToStr(MD5.MD5File(aFileNamePrices));
            if fPricesHash <> aNewHash then
            begin
              //PrepareEncodingFile(aFileNamePrices, ExtractFilePath(ParamStr(0)) + 'prices.processing'); // Кодирование Dos->Win
              FastLoadPricesFile(aConn, aFileNamePrices, fPrefs.BulkInsertPricesConfigFile);
              aPricesUpdated := True;

              //Обновляем хэш
              fPricesHash := aNewHash;
              WriteHashTheLastImportFile('SERVICE', 'PricesHash', fPricesHash);

              AddLog('Файл цен загружен в БД');
              DeleteFile(ChangeFileExt(aFileNamePrices, '.processed_ok'));
              RenameFile(aFileNamePrices, ChangeFileExt(aFileNamePrices, '.processed_ok'));
            end
            else
            begin
              DeleteFile(ChangeFileExt(aFileNamePrices, '.processed'));
              RenameFile(aFileNamePrices, ChangeFileExt(aFileNamePrices, '.processed'));
            end;
          end
          else
            AddLog('ошибка переименования: ' + SysErrorMessage(GetLastError));
        end
        else
          AddLog('меньше минимально допустимого размера - пропускаем');
      end;

    except
      on E: Exception do
      begin                                
        AddLog('!EXCEPTION: ' + E.Message);
        //AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
      end;
    end;
  finally
    DBDisconnectNew(aConn);
  end;
end;



procedure TServiceQuantsProcessing.RenamePricesClient;

  procedure FastLoadPricesFile(aConn: TAdoConnection; const anInFileName, aFormatFile: string);
  var
    aQuery: TAdoQuery;
  begin
    AddLog('Загрузка клиентских цен из ' + anInFileName);
  
    aQuery := TAdoQuery.Create(nil);
    try
      AddLog('очистка..');
      aQuery.Connection := aConn;
      aQuery.SQL.Text := 
        ' DROP TABLE [CLIENT_DATA].[dbo].[PRICES_CLIENTS] ';
      try  
        aQuery.ExecSQL;  
        aQuery.Close;
      except

      end;

      aQuery.SQL.Text :=
        ' CREATE TABLE [dbo].[PRICES_CLIENTS]( ' +
        ' [NO] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [CODE_BRAND] [varchar](128) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [PRICE] [varchar](30) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [SALE] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [PRICE_OPT_RF] [varchar](30) COLLATE Cyrillic_General_CI_AS NULL, ' +
        ' [SALE_OPT_RF] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL ' +
        ' ) ON [PRIMARY] ';
      aQuery.ExecSQL;
      aQuery.Close;

      aQuery.CommandTimeout := 180;
      aQuery.SQL.Text := ' BULK INSERT [CLIENT_DATA].[dbo].[PRICES_CLIENTS] ' +
                         ' FROM ''' + anInFileName + '''' +
                         ' WITH (FORMATFILE = ''' + aFormatFile + ''')';
      aQuery.ExecSQL;
      AddLog('Загрузка завершена удачно');
    finally
      aQuery.Free;
    end;  
  end;

var
  aFileNamePrices: string;
  aPath: string;
  aNewHash: string;
  aIni: TIniFile;

  aPricesUpdated: Boolean;
  aConn: TAdoConnection;
  aFileSize: Int64;
begin
  aConn := DBConnectNew;
  try
    AddLog('TServiceClientData.RenameClientsPrices', True);

    try
      aPricesUpdated := False;

      if fQuantsPaths.Count = 0 then
        Exit;
      aPath := fQuantsPaths[0];

//      aFileNamePrices := aPath + 'prices_client.csv';
      aFileNamePrices := aPath + 'prices_client_byr.csv';
      if FileExists(aFileNamePrices) then
      begin
        AddLog('Файл клиентских цен найден - ' + aFileNamePrices);

        //checking min file size
        aFileSize := GetFileSize_Internal(aFileNamePrices);
        if aFileSize > fPrefs.PricesClientsMinSize then
        begin
          DeleteFile(ChangeFileExt(aFileNamePrices, '.processing'));
          if RenameFile(aFileNamePrices, ChangeFileExt(aFileNamePrices, '.processing')) then
          begin
            aFileNamePrices := ChangeFileExt(aFileNamePrices, '.processing');
            aNewHash := MD5.MD5DigestToStr(MD5.MD5File(aFileNamePrices));
            if fPricesClientsHash <> aNewHash then
            begin
              FastLoadPricesFile(aConn, aFileNamePrices, fPrefs.BulkInsertClientsPricesConfigFile);
              aPricesUpdated := True;

              //Обновляем хэш
              fPricesClientsHash := aNewHash;
              WriteHashTheLastImportFile('SERVICE', 'PricesClientsHash', fPricesClientsHash);

              AddLog('Файл клиентских цен загружен в БД');
              DeleteFile(ChangeFileExt(aFileNamePrices, '.processed_ok'));
              RenameFile(aFileNamePrices, ChangeFileExt(aFileNamePrices, '.processed_ok'));
            end
            else
            begin
              DeleteFile(ChangeFileExt(aFileNamePrices, '.processed'));
              RenameFile(aFileNamePrices, ChangeFileExt(aFileNamePrices, '.processed'));
            end;
          end
          else
            AddLog('ошибка переименования: ' + SysErrorMessage(GetLastError));
        end
        else
          AddLog('меньше минимально допустимого размера - пропускаем');
      end;

      {Выгружаем если обновились прайсы или устарела последняя выгрузка}
       if aPricesUpdated and (MinutesBetween(Now(), fLastImportDate) > fPrefs.DelayBeforeExport) then
        fLastImportDate := Now();


    except
      on E: Exception do
      begin                                
        AddLog('!EXCEPTION: ' + E.Message);
        //AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
      end;
    end;
  finally
    DBDisconnectNew(aConn);
  end;

end;

function TServiceQuantsProcessing.ReadTheLastExportDate(): TDateTime;
var
  aIni: TIniFile;
begin
  aIni := TIniFile.Create(fIniFileName);
  try
    Result := aIni.ReadDateTime('SERVICE', 'LastExport', IncMonth(Now(), -1));
  finally
    aIni.Free;
  end;
end;

function TServiceQuantsProcessing.ReMapCode(aCode: string): string;
begin
  if memCodesMap.Locate('CodeNew', AnsiUpperCase(aCode), []) then
    result := memCodesMapCodeOld.AsString
  else
    result := '';
end;

procedure TServiceQuantsProcessing.RenameKurses;

  procedure UpdateRates(const aCurrency, aRate: string; const aOrder: integer);
  var
    Query: TADOQuery;
    Connection:TADOConnection;
    ID: integer;
  begin
     Connection := DBConnectNew;
     Query := TADOQuery.Create(nil);
     try
       Query.Connection := Connection;
       Query.CursorLocation := clUseClient;
       Query.CursorType := ctStatic;
       Query.DisableControls;

       Query.SQL.Text :=
         ' SELECT ID, RATE FROM [CLIENT_DATA].[dbo].[RATES] ' +
         ' WHERE [CURRENCY] = :CURR ';
       Query.Parameters[0].Value := aCurrency;
       Query.Open;

       if not Query.Eof then
       begin
         //Если изменилась, то апдейтим
         if (aRate <> Query.FieldByName('RATE').AsString) or (aOrder <> Query.FieldByName('ORDER').AsInteger) then
         begin
           ID := Query.FieldByName('ID').AsInteger;
           Query.Close;
           Query.SQL.Text :=
             ' UPDATE [CLIENT_DATA].[dbo].[RATES] ' +
             ' SET [RATE] = :RATE, [ORDER] = :ORDER ' +
             ' WHERE [ID] = :ID ';
           Query.Parameters[0].Value := aRate;
           Query.Parameters[1].Value := aOrder;
           Query.Parameters[2].Value := ID;
           Query.ExecSQL;
         end;
       end
       //Если запись не найдена добавляем
       else
       begin
         Query.Close;
         Query.SQL.Text :=
           ' INSERT INTO [CLIENT_DATA].[dbo].[RATES] ([CURRENCY], [RATE], [ORDER])' +
           ' VALUES (:CURRENCY, :RATE, :ORDER) ';
         Query.Parameters[0].Value := aCurrency;
         Query.Parameters[1].Value := aRate;
         Query.Parameters[2].Value := aOrder;         
         Query.ExecSQL;
       end;
     
     finally
       Query.Free;
       DBDisconnectNew(Connection);
     end;
  end;

  procedure ProcessRatesFile(const anInFileName, anOutFileName: string);
  var
    slOut: TStrings;
    Reader: TCSVReader;
    Curr, Rate: string;
    Order: integer;
  begin
    slOut := TStringList.Create;
    {Инициализация с сортировкой}
    slOut.Append('EUR/USD;0');
    slOut.Append('EUR/BYR;0');
    slOut.Append('EUR/RUB;0');

    Reader := TCSVReader.Create();
    try
      Reader.Open(anInFileName);
      while not Reader.Eof do
      begin
        Reader.ReturnLine;
        Curr := Reader.Fields[0];
        Rate := Reader.Fields[1];

        {строгий порядок}
        Order := -1;
        if (Curr = 'EUR/USD') then
          Order := 0
        else if (Curr = 'EUR/BYR') then
          Order := 1
        else if (Curr = 'EUR/RUB') then
          Order := 2;

        if (Rate = '') then
            Rate := '0';

        if Order >= 0 then
        begin
          slOut[Order] := Curr + ';' + Rate;
          UpdateRates(Curr, Rate, Order);
        end;
      end;
      slOut.SaveToFile(anOutFileName);

      //???
      //FileSetDate(anOutFileName, DateTimeToFileDate(Now));
    finally
      Reader.Free;
      slOut.Free;
    end;
  end;

var
  aFileName: string;
  aPath: string;
  aNewHash: string;
  aIni: TIniFile;
begin
  AddLog('TServiceClientData.RenameKurses', True);

  try
  
    if fQuantsPaths.Count = 0 then
      Exit;
    aPath := fQuantsPaths[0];

    aFileName := aPath + 'Rates.csv';
    if FileExists(aFileName) then
    begin
      AddLog('Файл курсов найден - ' + aFileName);

      aNewHash := MD5.MD5DigestToStr(MD5.MD5File(aFileName));
//      if fRatesHash <> aNewHash then //всегда обновляем курс чтобы в СП светилась сегодняшняя дата
      begin
        if FileExists(fFileOutPath + 'StockRates.tmp') then
          DeleteFile(fFileOutPath + 'StockRates.tmp');
        ProcessRatesFile(aFileName, fFileOutPath + 'StockRates.tmp');

        if FileExists(fFileOutPath + 'StockRates.csv') then
          DeleteFile(fFileOutPath + 'StockRates.csv');
        RenameFile(fFileOutPath + 'StockRates.tmp', fFileOutPath + 'StockRates.csv');

        //Обновляем хэш
        fRatesHash := aNewHash;
        WriteHashTheLastImportFile('SERVICE', 'RatesHash', fRatesHash);
      
        AddLog('Файл курсов обновлен - ' + fFileOutPath + 'StockRates.csv');

        DeleteFile(ChangeFileExt(aFileName, '.processed_ok'));
        RenameFile(aFileName, ChangeFileExt(aFileName, '.processed_ok'));
(*
            begin
              DeleteFile(ChangeFileExt(aFileName, '.processed'));
              RenameFile(aFileName, ChangeFileExt(aFileName, '.processed'));
            end;
*)            
        
      end;
    end;
  
  except
    on E: Exception do
    begin
      AddLog('!EXCEPTION: ' + E.Message);
      //AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
    end;
  end;
end;


procedure TServiceQuantsProcessing.RenameLimits;

    procedure FastLoadLimitsFile(aConn: TAdoConnection; const anInFileName, aFormatFile: string);
    var
      aQuery: TAdoQuery;
    begin
      AddLog('Загрузка лимитов из ' + anInFileName);

      aQuery := TAdoQuery.Create(nil);
      try
        AddLog('очистка..');
        aQuery.Connection := aConn;
        aQuery.SQL.Text := 
          ' DROP TABLE [CLIENT_DATA].[dbo].[Limits] ';
        try  
          aQuery.ExecSQL;  
          aQuery.Close;
        except

        end;

        aQuery.SQL.Text :=
          ' CREATE TABLE [dbo].[Limits]( ' +
          ' [NO] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL, ' +
          ' [VALUE] [int] NULL, ' +
          ' [SKLAD] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL ' +
          ' ) ON [PRIMARY] ';
        aQuery.ExecSQL;
        aQuery.Close;

        aQuery.SQL.Text :=
          ' CREATE CLUSTERED INDEX [NoSklad] ON [dbo].[Limits] ' +
          ' ( ' +
          ' 	[NO] ASC, ' +
          ' 	[SKLAD] ASC ' +
          ' )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] ';
        aQuery.ExecSQL;
        aQuery.Close;

        aQuery.CommandTimeout := 180;
        aQuery.SQL.Text := ' BULK INSERT [CLIENT_DATA].[dbo].[Limits] ' +
                           ' FROM ''' + anInFileName + '''' +
                           ' WITH (FORMATFILE = ''' + aFormatFile + ''')';
        aQuery.ExecSQL;
        AddLog('Загрузка завершена удачно');
      finally
        aQuery.Free;
      end;  
    end;

var
  aFileNameLimits: string;
  aPath: string;
  anOutPath: string;
  aNewHash: string;
  aIni: TIniFile;

  aLimitsUpdated: Boolean;
  aConn: TAdoConnection;
  aFileSize: Int64;
begin
  aConn := DBConnectNew;
  try
    AddLog('TServiceClientData.RenameLimits', True);

    try
      aLimitsUpdated := False;
    
      if fLimitsPaths.Count = 0 then
        Exit;
      aPath := fLimitsPaths[0];

      aFileNameLimits := aPath + 'limits.csv';
      if FileExists(aFileNameLimits) then
      begin
        AddLog('Файл лимитов найден - ' + aFileNameLimits);

        //checking min file size
        aFileSize := GetFileSize_Internal(aFileNameLimits);
        if aFileSize > fPrefs.LimitsMinSize then
        begin
          DeleteFile(ChangeFileExt(aFileNameLimits, '.processing'));
          if RenameFile(aFileNameLimits, ChangeFileExt(aFileNameLimits, '.processing')) then
          begin
            aFileNameLimits := ChangeFileExt(aFileNameLimits, '.processing');
            aNewHash := MD5.MD5DigestToStr(MD5.MD5File(aFileNameLimits));
            if fLimitsHash <> aNewHash then
            begin
              FastLoadLimitsFile(aConn, aFileNameLimits, fPrefs.BulkInsertLimitsConfigFile);
              aLimitsUpdated := True;

              //Обновляем хэш
              fLimitsHash := aNewHash;
              WriteHashTheLastImportFile('SERVICE', 'LimitsHash', fLimitsHash);

              AddLog('Файл лимитов загружен в БД');
              DeleteFile(ChangeFileExt(aFileNameLimits, '.processed_ok'));
              RenameFile(aFileNameLimits, ChangeFileExt(aFileNameLimits, '.processed_ok'));
            end
            else
            begin
              DeleteFile(ChangeFileExt(aFileNameLimits, '.processed'));
              RenameFile(aFileNameLimits, ChangeFileExt(aFileNameLimits, '.processed'));
            end;
          end
          else
            AddLog('ошибка переименования: ' + SysErrorMessage(GetLastError));
        end
        else
          AddLog('меньше минимально допустимого размера - пропускаем');
      end;

    except
      on E: Exception do
      begin                                
        AddLog('!EXCEPTION: ' + E.Message);
        //AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
      end;
    end;
  finally
    DBDisconnectNew(aConn);
  end;

end;

end.
