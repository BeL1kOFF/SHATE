unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  DB, ADODB, VCLUnZip, VCLZip, ActiveX, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, SyncObjs,
  NativeXml, IdCustomTCPServer, IdTCPServer, IdContext,
  IdCoderHeader, IdIOHandler, IdMessageClient, IdIMAP4, InvokeRegistry, Rio,
  SOAPHTTPClient, DateUtils;

const
  cSessionExpiredTime = 10 * 60 * 1000; //10 мин
  cWSUser = 'Shate\ord-q';
  cWSPassword = 'yjdsqord101';
  cTestClientID = '123456789';

  cAMDConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;';
  cCustomAutorityParams = 'Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s;';

  //[DATABASE]
  cSQLServerDef = 'svbyminssq1';
  cDatabaseNameDef = 'CLIENT_DATA';
  cDBUserDef = 'Client_Data';
  cDBPasswordDef = 'Asdfa^%H';

  //MAIL
  cReportOldOrdersDef = '';
  cReportSysErrorsDef = '';
  cReportUserErrorsDef = '';
  cMailHostDef = '10.0.0.1';
  cMailPortDef = 25;
  cMailUserDef = '';
  cMailPasswordDef = '';

  //IMAP
  cIMAPMailDef = 'testnav@shate-m.com';
  cIMAPHostDef = '10.0.0.1';
  cIMAPPortDef = 143;
  cIMAPUserDef = 'testnav';
  cIMAPPasswordDef = 'testnavtest21';

type
  TClientPriority = record
    FClientServiceID: string;
    FClientCode: string;
    FTimeStart: string;
    FTimeEnd: string;
    FPriority: Integer;
  end;

type
  TClientPriorityList = class(TObject)
  private
    FClientPriorityList: array of TClientPriority;
    FLength: integer;
    FLastOrderID: integer;
  public
    procedure AddClientPriority(const aClientPriority: TClientPriority);
    function FindClient(aClientCode: string): integer;

    constructor Create();
    destructor Destroy(); override;
end;


type
  TPrefs = record
    //MAIN
    DebugLogEnabled: Boolean;
    ScanMailInterval: Cardinal;
    MailBathSize: Integer;
    ScanIncomingInterval: Cardinal;
    ReceiveTimeout: Integer;
    SendTimeout: Integer;
    CodesMapFile: string;
    ClientPriorityFile: string;
    ManagersMapFile: string;
    SendToNAVCount: Integer;
    SendResponseCount: Integer;
    LimitSelectWaitList: Integer;

    //QUEUE
    DefaultPriority: Integer;
    QueueSize: Integer;
    RetdocSkipStart: TDateTime;
    RetdocSkipEnd: TDateTime;
    RetdocSkipRows: Integer;

    //DATABASE
    SqlServerName: string;
    DatabaseName: string;
    DBUser: string;
    DBPassword: string;
{
    //NET
    NetUser: string;
    NetPassword: string;
    UnmountDriveIfUsed: Boolean;
}
    //MAIL
    ReportOldOrders: string;
    ReportSysErrors: string;
    ReportUserErrors: string;
    MailHost: string;
    MailPort: Integer;
    MailUser: string;
    MailPassword: string;

    //IMAP
    IMAPMail: string;
    IMAPHost: string;
    IMAPPort: Integer;
    IMAPUser: string;
    IMAPPassword: string;
  end;

  TOrderProcessingStatus = (oprNone, oprOK, oprOldest, oprError);
const
  cOrderProcessingStatusCode: array[TOrderProcessingStatus] of Integer = 
  (
    0, 1, 2, -1
  );

type  
  TOrdServiceIMAP = class(TService)
    Zipper: TVCLZip;
    IdIMAP: TIdIMAP4;
    HTTPRIO1: THTTPRIO;

    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceDestroy(Sender: TObject);
  private
    fThread: TThread;
    fWSThread: TThread;

    fMailSendThread: TThread;
    fMailSendReThread: TThread;

    fLogLock: TCriticalSection;
    fLogLockTCP: TCriticalSection;
    fLogLockRe: TCriticalSection;

    fListMessages: TThreadList;

    fMappedDrives: string; //e.g. 'XYZ'

    fLogFileName: string;
    fLogFileNameWS: string;
    fLogFileNameRe: string;
    fIniFileName: string;
    fAborted: Boolean;
    fServiceHasStarted: Boolean;

    fRegisteredPaths: TStrings;

    //INI prefs
    fPrefs: TPrefs;
    fClientPriorityList: TClientPriorityList;

    fCodesMap: TStrings;
    fManagersMap: TStrings;

    fPac_ClientCfo: TStrings;
    fPac_CfoPac: TStrings;
    fPac_PacManagers: TStrings;
    fPac_ManagerEmail: TStrings;

    //FormatDateTime
    formatDateSettings: TFormatSettings;

    procedure LoadINI;
    procedure LoadClientPriorityFile;
    procedure LogPrefs;

//    function MapNetDrive(aDrive: Char; const aPath: string; UnmapBefore: Boolean = False): Boolean;
//    function UnmapNetDrive(aDrive: Char): Boolean;
//    procedure ProcessPaths(aPathsList: TStrings);
//    procedure UnmapAllDrives;

    procedure ProcessMessages;

  public
    function GetServiceController: TServiceController; override;

    //Log
    procedure AddLog(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);
    procedure AddLogWS(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);
    procedure AddLogRe(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);


    procedure AddEmailReport(const aText: string; isSysReport: Boolean);
    procedure AddEmailOrderOld(const aEmailTo, aFileName, aFileName_orig: string);
    procedure AddEmailOrderMarkets(const aEmailFrom, aEmailTo, aFileName, aFileName_orig: string);
    procedure AddEmailOrderError(const aEmailTo, aFileName_orig, aErrors: string);

    //DB tools
    function  DBConnectNew(IsTest: Boolean = False): TAdoConnection;
    procedure DBDisconnectNew(var aConnection: TAdoConnection);

    //Work in thread1
    procedure ProcessEMail;
    procedure ProcessIncomming;
    function ProcessFileCsv(const aFileName, aOrderName: string; {out}aResCSVStream,
      {out}aResXMLStream: TStream; out aClientId: string; out aNum: string; out aOutCur: string; out isPortal: Boolean; {out}var aReplacedCodes: string; out aRowCount: Integer; out isRetdoc: Boolean): TOrderProcessingStatus;

    //Work in thread2
    procedure SendOrders;
    function IsSkipRetdoc(aRowCount: Integer): Boolean;
    procedure SendWaitList(aBatchLimit: Integer = 10);

    //SEND
    function SendXML(aXmlStream: TStream; out aErr: string; aNeedWarmUp: Boolean; aIsTest: Boolean; const aLogIdentity: string): Boolean;
    function SendWaitlistCSV(aCsvStream: TMemoryStream; out aErr: string): Boolean;

    procedure BuildSendAddrList;
    property ManagersMap: TStrings read fManagersMap;
  end;

var
  OrdServiceIMAP: TOrdServiceIMAP;

implementation

{$R *.DFM}

uses
  uIMAPThread, uWSThread, uSmtpThread, uSmtpThreadRe, uSysGlobal, Variants,
  md5, IniFiles, WinSvc, AdoDBUtils, StrUtils, IdException, ComObj,
  IdMessage, IdAttachmentFile, _CSVReader, WS, XSBuiltIns;

{ Global }

function MakeSearchCode(const s: string): string;
const
  Ign_chars = ' _-/.,"'';:+&?\<>[]{}()*~`^';
var
  i: integer;
begin
  Result := AnsiUpperCase(s);
  for i := 1 to Length(Ign_chars) do
    Result := StringReplace(Result, Ign_chars[i], '', [rfReplaceAll]);
end;

function DecodeCodeBrand(const aCode_Brand: string; var aCode, aBrand: string; aMakeSearchCode: Boolean = True): Boolean;
var
  aPos: Integer;
begin
  aPos := Pos('_', aCode_Brand);
  if aPos > 0 then
  begin
    aCode := Copy(aCode_Brand, 1,  aPos - 1);
    aBrand := Copy(aCode_Brand, aPos + 1, MaxInt);
    if aMakeSearchCode then
      aCode := MakeSearchCode(aCode);
  end
  else
  begin
    aCode := '';
    aBrand := '';
  end;

  Result := (aCode <> '') and (aBrand <> '');
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
  OrdServiceIMAP.AddLog('CtrlCode: ' + IntToStr(CtrlCode), True);
  OrdServiceIMAP.Controller(CtrlCode);
end;


{ TServiceMK }

function TOrdServiceIMAP.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TOrdServiceIMAP.ServiceCreate(Sender: TObject);
begin
  fLogLock := TCriticalSection.Create;
  fLogLockTCP := TCriticalSection.Create;
  fLogLockRe := TCriticalSection.Create;

  fListMessages := TThreadList.Create;
  fRegisteredPaths := TStringList.Create;
  fCodesMap := TStringList.Create;
  fManagersMap := TStringList.Create;

  fPac_ClientCfo := TStringList.Create;
  fPac_CfoPac := TStringList.Create;
  fPac_PacManagers := TStringList.Create;
  fPac_ManagerEmail := TStringList.Create;


  fLogFileName := ChangeFileExt(ExpandFileName(ParamStr(0)), '.log');
  fLogFileNameWS := ChangeFileExt(ExpandFileName(ParamStr(0)), '_WS.log');
  fLogFileNameRe := ChangeFileExt(ExpandFileName(ParamStr(0)), '_RE.log');
  fIniFileName := ChangeFileExt(ExpandFileName(ParamStr(0)), '.ini');
  ZeroMemory(@fPrefs, SizeOf(fPrefs));

  formatDateSettings.ShortDateFormat := 'dd.mm.yyyy';
  formatDateSettings.DateSeparator := '.';

  AddLog('ServiceCreate');
  fClientPriorityList := TClientPriorityList.Create();
  LoadINI;
  LoadClientPriorityFile;
  AddLog('Config loaded');
  // debug >>
//  ServiceStart(Self, b);
//  while True do;
  // << debug
end;

procedure TOrdServiceIMAP.ServiceDestroy(Sender: TObject);
begin
  fRegisteredPaths.Free;

  if fServiceHasStarted then
  begin
    AddLog('Служба остановлена');
    AddLog('**************************************', False, True);
  end;
  fLogLock.Free;
  fLogLockTCP.Free;
  fLogLockRe.Free;
  fListMessages.Free;
  fCodesMap.Free;
  fManagersMap.Free;

  fPac_ClientCfo.Free;
  fPac_CfoPac.Free;
  fPac_PacManagers.Free;
  fPac_ManagerEmail.Free;

  fClientPriorityList.Free;
end;

procedure TOrdServiceIMAP.ServiceStart(Sender: TService; var Started: Boolean);
var
  aConn: TAdoConnection;
begin
  AddLog(#13#10#13#10'**************************************', False, True);
  AddLog('Запуск службы...');
  LogPrefs;
//  if (Trim(fPrefs.MailHost) = '') or (fPrefs.MailPort <= 0) then
//    AddLog('Зарегистрированные пути: '#13#10 + fRegisteredPaths.Text, True);

//  AddLog('Зарегистрированные пути: '#13#10 + fRegisteredPaths.Text, True);
//  ProcessPaths(fRegisteredPaths);
//  AddLog('Подключенные диски: ' + fMappedDrives);
//  AddLog('Зарегистрированные пути после обработки: '#13#10 + fRegisteredPaths.Text, True);


  AddLog('Проверка подключения к SQL-серверу', True);
  aConn := DBConnectNew(True{IsTest});
  DBDisconnectNew(aConn);

  Started := True;
  fServiceHasStarted := True;
  AddLog('Служба запущена');


  fThread := TIMAPThread.Create(Self);
  TIMAPThread(fThread).Init(fPrefs);
  fThread.Resume;

  fWSThread := TWSThread.Create(Self);
  TWSThread(fWSThread).Init(fPrefs);
  fWSThread.Resume;

  fMailSendThread := TSMTPMessagesThrd.Create(Self, fListMessages);
  fMailSendThread.Resume;

  fMailSendReThread := TSMTPMessagesReThrd.Create(Self);
  TSMTPMessagesReThrd(fMailSendReThread).Init(fPrefs);
  fMailSendReThread.Resume;
end;

procedure TOrdServiceIMAP.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  AddLog('Остановка службы...');
  fAborted := True;

  //говорим потокам чтоб завершались
  if Assigned(fThread) then
    fThread.Terminate;

  if Assigned(fWSThread) then
    fWSThread.Terminate;
    
  if Assigned(fMailSendThread) then
    fMailSendThread.Terminate;

  if Assigned(fMailSendReThread) then
    fMailSendReThread.Terminate;


  //ждем завершения потоков
  if Assigned(fThread) then
  begin
    fThread.WaitFor;
    fThread.Free;
  end;
  if Assigned(fWSThread) then
  begin
    fWSThread.WaitFor;
    fWSThread.Free;
  end;
  if Assigned(fMailSendThread) then
  begin
    fMailSendThread.WaitFor;
    fMailSendThread.Free;
  end;

  if Assigned(fMailSendReThread) then
  begin
    fMailSendReThread.WaitFor;
    fMailSendReThread.Free;
  end;

//  UnmapAllDrives; //только после завершения TIMAPThread, т.к. он использует подключенные диски
  Stopped := True;
end;

procedure TOrdServiceIMAP.AddEmailOrderOld(const aEmailTo, aFileName, aFileName_orig: string);
var
  aClient: TMessSMTP;
begin
  AddLog('Отправить ' + aEmailTo + ' файл ' + aFileName);

  aClient := TMessSMTP.Create;
  aClient.email := 'ORDERS Processing Service';
  aClient.ShateEmail := aEmailTo;
  aClient.subj := 'ORDERS Processing Service - заказ старого формата';
  
  aClient.fn := aFileName;
  aClient.fn_orig := aFileName_orig;
  aClient.Host := fPrefs.MailHost;
  aClient.Port := fPrefs.MailPort;
  aClient.Username := '';
  aClient.Password := '';


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

procedure TOrdServiceIMAP.AddEmailOrderMarkets(const aEmailFrom, aEmailTo, aFileName, aFileName_orig: string);
var
  aClient: TMessSMTP;
begin
  AddLog('Отправить ' + aEmailTo + ' файл ' + aFileName);

  aClient := TMessSMTP.Create;
  aClient.email := aEmailFrom;
  aClient.ShateEmail := aEmailTo;
  aClient.subj := 'Заказ ИП';
  
  aClient.fn := aFileName;
  aClient.fn_orig := aFileName_orig;
  aClient.Host := fPrefs.MailHost;
  aClient.Port := fPrefs.MailPort;
  aClient.Username := '';
  aClient.Password := '';


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

procedure TOrdServiceIMAP.AddEmailOrderError(const aEmailTo, aFileName_orig, aErrors: string);
var
  aClient: TMessSMTP;
begin
  AddLog('Отправить ' + aEmailTo + ' файл ' + aFileName_orig);

  aClient := TMessSMTP.Create;
  aClient.email := 'ORDERS Processing Service';
  aClient.ShateEmail := aEmailTo;
  aClient.subj := 'ORDERS Processing Service - !ОШИБКА при резервировании';
  aClient.body := '5 неудачных попыток отправки заявки:'#13#10 + aErrors;
  
  aClient.fn := '';
  aClient.fn_orig := aFileName_orig;
  aClient.Host := fPrefs.MailHost;
  aClient.Port := fPrefs.MailPort;
  aClient.Username := '';
  aClient.Password := '';


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

procedure TOrdServiceIMAP.AddEmailReport(const aText: string; isSysReport: Boolean);
var
  aClient: TMessSMTP;
begin
  aClient := TMessSMTP.Create;

  aClient.email := 'ORDERS Processing Service';//from
  if isSysReport then
  begin
    aClient.ShateEmail := fPrefs.ReportSysErrors;//to
    aClient.subj := 'ORDERS Processing Service - оповещение о системных ошибках';
  end
  else
  begin
    aClient.ShateEmail := fPrefs.ReportUserErrors;//to
    aClient.subj := 'ORDERS Processing Service - оповещение об ошибках';
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

procedure TOrdServiceIMAP.AddLog(const aText: string; isDebug: Boolean; aWithoutDateTime: Boolean);
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

procedure TOrdServiceIMAP.AddLogRe(const aText: string; isDebug,
  aWithoutDateTime: Boolean);
var
  f: TextFile;
  aDebugLabel: string;
begin
  if isDebug and not fPrefs.DebugLogEnabled then
    Exit;

  fLogLockRe.Enter;
  try
    if isDebug then
      aDebugLabel := '# '
    else
      aDebugLabel := '';

    AssignFile(f, fLogFileNameRe);
    if not FileExists(fLogFileNameRe) then
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
    fLogLockRe.Leave;
  end;
end;

procedure TOrdServiceIMAP.AddLogWS(const aText: string; isDebug,
  aWithoutDateTime: Boolean);
var
  f: TextFile;
  aDebugLabel: string;
begin
  if isDebug and not fPrefs.DebugLogEnabled then
    Exit;

  fLogLockTCP.Enter;
  try
    if isDebug then
      aDebugLabel := '# '
    else
      aDebugLabel := '';

    AssignFile(f, fLogFileNameWS);
    if not FileExists(fLogFileNameWS) then
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
    fLogLockTCP.Leave;
  end;
end;

procedure TOrdServiceIMAP.BuildSendAddrList;

  procedure RemapLists(aDestList, aSourceList: TStrings; aDeleteNotMapped: Boolean = True);
  var
    i: Integer;
    s: string;
  begin
    for i := aDestList.Count - 1 downto 0 do
    begin
      s := aDestList.ValueFromIndex[i];

      s := aSourceList.Values[s];

      if s <> '' then
        aDestList.ValueFromIndex[i] := s
      else  
        if aDeleteNotMapped then
          aDestList.Delete(i)
        else  
          aDestList.ValueFromIndex[i] := s;
    end;
  end;
  
var
  i, j, p: Integer;
  s: string;
  sl: TStrings;
begin
  //тянем вверх по цепочке
  //1. пакам проставляем емэйлы вместо кодов
  sl := TStringList.Create;
  for i := 0 to fPac_PacManagers.Count - 1 do
  begin
    sl.CommaText := fPac_PacManagers.ValueFromIndex[i];
    for j := sl.Count - 1 downto 0 do
    begin
      s := sl[j];
      
      s := fPac_ManagerEmail.Values[s];
      
      if s = '' then
        sl.Delete(j)
      else 
        sl[j] := s;
    end;
    fPac_PacManagers.ValueFromIndex[i] := sl.CommaText;
  end;

  
  //2. в ЦФО проставляем емэйлы вместо паков
  RemapLists(fPac_CfoPac, fPac_PacManagers, True);
  
  //3. в клиентах проставляем емэйлы вместо ЦФО
  RemapLists(fPac_ClientCfo, fPac_CfoPac, False);
end;

procedure TOrdServiceIMAP.LoadClientPriorityFile;
var
  aIni: TIniFile;
  cntSection, i: Integer;
  PriorityRecord: TClientPriority;
begin
  AddLog('Файл приоритета клиентов: ' + fPrefs.ClientPriorityFile);
  aIni := TIniFile.Create(fPrefs.ClientPriorityFile);
  try
    cntSection := aINI.ReadInteger('SECTION_COUNT', 'COUNT', 0);
    AddLog('Файл приоритета клиентов - SECTION_COUNT: ' + IntToStr(cntSection));
    for i := 1 to cntSection do
    begin
      if aIni.SectionExists('ClientPriority_' + IntToStr(i)) then
      begin
        PriorityRecord.FClientServiceID := aINI.ReadString('ClientPriority_' + IntToStr(i), 'ClientServiceID', '');
        PriorityRecord.FClientCode := aINI.ReadString('ClientPriority_' + IntToStr(i), 'ClientCode', '');
        PriorityRecord.FTimeStart := aINI.ReadString('ClientPriority_' + IntToStr(i), 'TimeStart', '');
        PriorityRecord.FTimeEnd := aINI.ReadString('ClientPriority_' + IntToStr(i), 'TimeEnd', '');
        PriorityRecord.FPriority := aINI.ReadInteger('ClientPriority_' + IntToStr(i), 'Priority', 100);
        fClientPriorityList.AddClientPriority(PriorityRecord);
      end;
    end;
    AddLog('Файл приоритета клиентов - загружено записей: ' + IntToStr(Length(fClientPriorityList.FClientPriorityList)));
  finally
    aINI.Free;
  end;

end;

procedure TOrdServiceIMAP.LoadINI;
var
  aIni: TIniFile;
  i: Integer;
  aCurDir: string;
begin
try
  aIni := TIniFile.Create(fIniFileName);
  try
    //[MAIN]
    fPrefs.DebugLogEnabled := aINI.ReadBool('MAIN', 'EnableDebugLog', fPrefs.DebugLogEnabled);
    fPrefs.ScanMailInterval := aINI.ReadInteger('MAIN', 'ScanMailInterval', 60);
    fPrefs.MailBathSize := aINI.ReadInteger('MAIN', 'MailBathSize', 100);
    fPrefs.ScanIncomingInterval := aINI.ReadInteger('MAIN', 'ScanIncomingInterval', 60);

    fPrefs.SendTimeout := aINI.ReadInteger('MAIN', 'SendTimeout', 120);
    fPrefs.ReceiveTimeout := aINI.ReadInteger('MAIN', 'ReceiveTimeout', 120);
    fPrefs.CodesMapFile := aINI.ReadString('MAIN', 'CodesMapFile', '');
    fPrefs.ClientPriorityFile := aINI.ReadString('MAIN', 'ClientPriorityFile', '');

    AddLog('Путь приоритетов до добавления: ' + fPrefs.ClientPriorityFile);
    
    fPrefs.ManagersMapFile := aINI.ReadString('MAIN', 'ManagersMapFile', '');

    fPrefs.SendToNAVCount := aINI.ReadInteger('MAIN', 'SendToNAVCount', 5);
    fPrefs.SendResponseCount := aINI.ReadInteger('MAIN', 'SendResponseCount', 5);
    fPrefs.LimitSelectWaitList := aINI.ReadInteger('MAIN', 'LimitSelectWaitList', 10);

    if (Copy(fPrefs.ClientPriorityFile, 1, 2) <> '\\') and (Copy(fPrefs.ClientPriorityFile, 2, 2) <> ':\') then
      fPrefs.ClientPriorityFile := ExtractFilePath(ParamStr(0)) + fPrefs.ClientPriorityFile;
    AddLog('Путь приоритетов после добавления: ' + fPrefs.ClientPriorityFile);

    if (Copy(fPrefs.CodesMapFile, 1, 2) <> '\\') and (Copy(fPrefs.CodesMapFile, 2, 2) <> ':\') then
      fPrefs.CodesMapFile := ExtractFilePath(ParamStr(0)) + fPrefs.CodesMapFile;
    if FileExists(fPrefs.CodesMapFile) then
      fCodesMap.LoadFromFile(fPrefs.CodesMapFile);

    if (Copy(fPrefs.ManagersMapFile, 1, 2) <> '\\') and (Copy(fPrefs.ManagersMapFile, 2, 2) <> ':\') then
      fPrefs.ManagersMapFile := ExtractFilePath(ParamStr(0)) + fPrefs.ManagersMapFile;
    if FileExists(fPrefs.ManagersMapFile) then
      fManagersMap.LoadFromFile(fPrefs.ManagersMapFile);

//---------------------------------------
// pac
  aCurDir := ExtractFilePath(ParamStr(0)) + 'paki\';
  fPac_ClientCfo.LoadFromFile(aCurDir + '_client-cfo.csv');
  fPac_CfoPac.LoadFromFile(aCurDir + '_cfo-pac.csv');
  fPac_PacManagers.LoadFromFile(aCurDir + '_pac-managers.csv');
  fPac_ManagerEmail.LoadFromFile(aCurDir + '_manager-email.csv');
  BuildSendAddrList;
  fPac_ClientCfo.SaveToFile(aCurDir + '_client-sendto_.csv');
//---------------------------------------
  fManagersMap.Assign(fPac_ClientCfo);

    //[NET]
{
    fPrefs.UnmountDriveIfUsed := aINI.ReadBool('NET', 'UnmountDriveIfUsed', fPrefs.UnmountDriveIfUsed);
    fPrefs.NetUser := aINI.ReadString('NET', 'NetUser', '');
    fPrefs.NetPassword := aINI.ReadString('NET', 'NetPassword', '');
    if fPrefs.NetUser = '' then
    begin
      fPrefs.NetUser := cNetUserDef;
      fPrefs.NetPassword := cNetPasswordDef;
    end;
}

    //QUEUE
    fPrefs.DefaultPriority := aINI.ReadInteger('QUEUE', 'DefaultPriority', 100);
    fPrefs.QueueSize := aINI.ReadInteger('QUEUE', 'QueueSize', 10);
    fPrefs.RetdocSkipStart := aINI.ReadTime('QUEUE', 'RetdocSkipStart', 0);
    fPrefs.RetdocSkipEnd := aINI.ReadTime('QUEUE', 'RetdocSkipEnd', 0);
    fPrefs.RetdocSkipRows := aINI.ReadInteger('QUEUE', 'RetdocSkipRows', 20);


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
    fPrefs.ReportOldOrders := aINI.ReadString('MAIL', 'ReportOldOrders', cReportOldOrdersDef);
    
    
    fPrefs.MailHost := aINI.ReadString('MAIL', 'MailHost', cMailHostDef);
    fPrefs.MailPort := aINI.ReadInteger('MAIL', 'MailPort', cMailPortDef);
    fPrefs.MailUser := aINI.ReadString('MAIL', 'MailUser', cMailUserDef);
    fPrefs.MailPassword := aINI.ReadString('MAIL', 'MailPassword', cMailPasswordDef);

    //[IMAP]
    fPrefs.IMAPMail := aINI.ReadString('IMAP', 'IMAPMail', cIMAPMailDef);
    fPrefs.IMAPHost := aINI.ReadString('IMAP', 'IMAPHost', cIMAPHostDef);
    fPrefs.IMAPPort := aINI.ReadInteger('IMAP', 'IMAPPort', cIMAPPortDef);
    fPrefs.IMAPUser := aINI.ReadString('IMAP', 'IMAPUser', cIMAPUserDef);
    fPrefs.IMAPPassword := aINI.ReadString('IMAP', 'IMAPPassword', cIMAPPasswordDef);
    
  finally
    aIni.Free;
  end;
except
  on E: Exception do
  begin
    AddLog('!Exception(LoadINI): ' + E.Message);
    raise;
  end;
end;
end;

procedure TOrdServiceIMAP.LogPrefs;
begin
  AddLog(
    Format(
      '#'#13#10 +
      '#  Общие настройки-----------------------'#13#10 +
      '#    отладочный лог: %d'#13#10 +
      '#    интервал почты: %d'#13#10 +
      '#  БД------------------------------------'#13#10 +
      '#    SQL-сервер: %s'#13#10 +
      '#    база данных: %s'#13#10 +
      '#    пользователь БД: %s'#13#10 +
//      '#  Сеть----------------------------------'#13#10 +
//      '#    демонтировать занятые сетевые диски: %d'#13#10 +
//      '#    сетевой пользователь: %s'#13#10 +
      '#  E-Mail--------------------------------'#13#10 +
      '#    отсылать системные ошибки: %s'#13#10 +
      '#    отсылать ошибки загрузок: %s'#13#10 +
      '#    e-mail сервер: %s'#13#10 +
      '#    e-mail порт: %d'#13#10 +
      '#    e-mail пользователь: %s',
      [
        Integer(fPrefs.DebugLogEnabled),
        fPrefs.ScanMailInterval,

        fPrefs.SqlServerName,
        fPrefs.DatabaseName,
        fPrefs.DBUser,

//        Integer(fPrefs.UnmountDriveIfUsed),
//        fPrefs.NetUser,

        fPrefs.ReportSysErrors,
        fPrefs.ReportUserErrors,
        fPrefs.MailHost,
        fPrefs.MailPort,
        fPrefs.MailUser

      ]
    ), False, True
  );

  if fCodesMap.Count > 0 then
    AddLog('#    Файл замены кодов ' + fPrefs.CodesMapFile + ', загружено: ' + IntToStr(fCodesMap.Count), False, True);

  if fManagersMap.Count > 0 then
    AddLog('#    Файл рассылки старых заказов' + fPrefs.ManagersMapFile + ', загружено: ' + IntToStr(fManagersMap.Count), False, True);
end;

{
function TOrdServiceIMAP.MapNetDrive(aDrive: Char;
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

function TOrdServiceIMAP.UnmapNetDrive(aDrive: Char): Boolean;
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

procedure TOrdServiceIMAP.UnmapAllDrives;
var
  i: Integer;
begin
  for i := 1 to Length(fMappedDrives) do
    UnmapNetDrive(fMappedDrives[i]);
end;

}
{
//обработка путей поиска, подключение сетевых дисков
procedure TOrdServiceIMAP.ProcessPaths(aPathsList: TStrings);

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
  fMkPaths.Delimiter := ';';
  fMkPaths.DelimitedText := ReplacePathVars(fPrefs.MKSearchPaths);
  NormalizePaths(fMkPaths);
end;
}


procedure TOrdServiceIMAP.ProcessMessages;
begin
  ServiceThread.ProcessRequests(False);
  fAborted := Terminated;
end;


function TOrdServiceIMAP.DBConnectNew(IsTest: Boolean): TAdoConnection;
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

procedure TOrdServiceIMAP.DBDisconnectNew(var aConnection: TAdoConnection);
begin
  if Assigned(aConnection) then
  begin
    aConnection.Connected := False;
    aConnection.Free;
    aConnection := nil;
  end;
end;

procedure TOrdServiceIMAP.ProcessEMail;
var
  aConn: TAdoConnection;

  function SaveAttachs(aMsg: TIdMessage): Boolean;
  var
    anAttachment: TIdAttachmentFile;
    aPath: string;
    i, aSize: Integer;
    aFileName: string;
    aQuery: TAdoQuery;
  begin
    Result := False;
    AddLog('  обработка вложений..');

    aConn := DBConnectNew;
    try
      aQuery := TAdoQuery.Create(nil);
      aQuery.Connection := aConn;
      aQuery.SQL.Text := 
        ' INSERT INTO INCOMING ( EMAIL,  DT_EMAIL,  DT_INSERT,  FILE_NAME,  DATA_CSV) ' + 
        '               VALUES (:EMAIL, :DT_EMAIL, :DT_INSERT, :FILE_NAME, :DATA_CSV) ';
    
      aPath := ExtractFilePath(ParamStr(0)) + 'Incoming\';
    
      for i := 0 to aMsg.MessageParts.Count - 1 do
        if (aMsg.MessageParts[i] is TIdAttachmentFile) then
        begin
          anAttachment := (aMsg.MessageParts[i] as TIdAttachmentFile);
          aSize := GetFileSize_Internal(anAttachment.StoredPathName);
          AddLog('  вложение #' + IntToStr(i) + ': "' + anAttachment.FileName + '", размер: ' + IntToStr(aSize));

          aFileName := anAttachment.FileName;
          if SameText(Copy(aFileName, 1, 7), '=_utf-8') then
          begin
            aFileName := 'utf8_' + IntToStr(i) + aMsg.UID + '.CSV';
            AddLog('  вложение переименовано #: "' + aFileName + '"');
          end;
            
          if SameText(RightStr(aFileName, 4), '.CSV') and (aSize < 300 * 1024) then
          begin
            DeleteFile(aPath + aFileName);
            try
              anAttachment.SaveToFile(aPath + aFileName);
            except
              //save for test only
            end;

            aQuery.Parameters[0].Value := aMsg.From.Address;
            aQuery.Parameters[1].Value := aMsg.Date;
            aQuery.Parameters[2].Value := Now;
            aQuery.Parameters[3].Value := aFileName;           
            aQuery.Parameters[4].LoadFromFile(anAttachment.StoredPathName, ftBlob);
            aQuery.ExecSQL;
            AddLog('  добавлен в БД');
            
            Result := True;
          end;
        end;
    finally
      DBDisconnectNew(aConn);
    end;
  end;      


var
  aQuery: TAdoQuery;
  aStream: TMemoryStream;
  aProcessStatus: Integer;
  aCountAll, aCountError: Integer;

  aMsg: TIdMessage;
  i, aCount, aProcessedCount: Integer;
  //aUID: string;
begin
  AddLog('', False, True);
  AddLog('Проверка новых писем...', True);
  aCount := 0;
  aCountError := 0;

  aMsg := TIdMessage.Create;
  IdIMAP.Host := fPrefs.IMAPHost;
  IdIMAP.Port := fPrefs.IMAPPort;
  IdIMAP.Connect(False);
  try
    
    IdIMAP.Username := fPrefs.IMAPUser;
    IdIMAP.Password := fPrefs.IMAPPassword;
  
    AddLog('IMAP Login, user ' + fPrefs.IMAPUser);
    IdIMAP.Login;
    IdIMAP.SelectMailBox('Inbox');
    aCount := IdIMAP.MailBox.TotalMsgs;
    AddLog('Сообщений: ' + IntToStr(aCount));

    aProcessedCount := 0;
    for i := aCount  downto 1 do
    begin
      //IdIMAP.GetUID(i, aUID);
      AddLog('>> Сообщение #' + IntToStr(i));
      
      if IdIMAP.RetrieveMsgSize(i) < 1024*1024 then
      begin      
        IdIMAP.Retrieve(i, aMsg);
        AddLog('  ' + DateTimeToStr(aMsg.Date) + 'от ' + aMsg.From.Address);
        if not (mfDeleted in aMsg.Flags) then
          SaveAttachs(aMsg)  //ложим в базу
        else
          AddLog('  пропуск - уже помечено удаленным');
      end
      else
        AddLog('  пропуск - размер больше 1Мб');

      if IdIMAP.CopyMsg(i, 'processed') then
        AddLog('  скопировано в processed');
      if IdIMAP.DeleteMsgs([i]) then
        AddLog('  удалено');
        
      IdIMAP.ExpungeMailBox; 
      
      
      AddLog('<< обработано');

      Inc(aProcessedCount);
      if (fPrefs.MailBathSize > 0) and (aProcessedCount > fPrefs.MailBathSize) then
      begin
        AddLog('стоп, конец пачки (' + IntToStr(fPrefs.MailBathSize) + ')');
        Break;
      end;
      
      if fAborted then 
        Break;
    end;
    
  finally
    IdIMAP.Disconnect;
    aMsg.Free;
  end;

end;

function TOrdServiceIMAP.ProcessFileCsv(const aFileName, aOrderName: string; {out}aResCSVStream,
  {out}aResXMLStream: TStream; out aClientId: string; out aNum: string; out aOutCur: string; out isPortal: Boolean; {out}var aReplacedCodes: string; out aRowCount: Integer; out isRetdoc: Boolean): TOrderProcessingStatus;

  function ReplaceOldCodes(const aCSVFileName: string; {out} aReplaced: TStrings): Integer;
  var
    sl: TStrings;
    aReader: TCSVReader;
    i: Integer;
    aCode, aCodeNew, aLine: string;
  begin
    Result := 0;
    sl := TStringList.Create;
    aReader := TCSVReader.Create;
    try
      aReader.Open(aCSVFileName);
      aReader.ReturnLine;
      sl.Add(aReader.CurrentLine);
      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        aLine := aReader.CurrentLine;

        aCode := AnsiUpperCase(aReader.Fields[0]);
        aCodeNew := fCodesMap.Values[aCode];
        if aCodeNew <> '' then
        begin
          aReplaced.Add(aCode + '=' + aCodeNew);
          aLine := StringReplace(aLine, aCode, aCodeNew, [rfIgnoreCase]);
          Inc(Result);
        end;
        sl.Add(aLine);
      end;
      aReader.Close;
      sl.SaveToFile(aCSVFileName);
    finally
      aReader.Free;
      sl.Free;
    end;
  end;
  
var
  aHeader, aDate, aCur, aComment: string;
  aDateDT: TDateTime;
  aReader: TCSVReader;
  aDoc: TNativeXml;
  aNode: TXmlNode;
  aAddrCode, aArgCode, aDelivery, aReturnReason, aNearestDelivery: string;
  aProcessedFileName: string;
//  aNormCSV: TStrings;
  aCountReplaced: Integer;
  slReplaced: TStrings; //REPLACED_CODES
begin
  Result := oprError;
  AddLog('>>Конвертирование: ' + aOrderName);
  aRowCount := 0;
  try
    aReader := TCSVReader.Create;
    slReplaced := TStringList.Create;
    try
      aCountReplaced := ReplaceOldCodes(aFileName, slReplaced);
      aReplacedCodes := slReplaced.Text;
      AddLog('  Заменено кодов: ' + IntToStr(aCountReplaced));
      (aResCSVStream as TMemoryStream).LoadFromFile(aFileName);
      
      aReader.Open(aFileName);
      aReader.ReturnLine;
  
      aClientId := aReader.Fields[0];
      aDate := StringReplace(aReader.Fields[1], '.', '', [rfReplaceAll]);

      //date format fix (090413 -> 09042013)
      if Length(aDate) = 6 then
        aDate := Copy(aDate, 1, 4) + '20' + Copy(aDate, 5, 2);

      aNum := aReader.Fields[2];

      if (aClientID = '') or (aNum = '') then
        Exit;

      aCur := '';
      aArgCode := '';
      aAddrCode := '';
      aDelivery := '';
      aOutCur := '';
      aReturnReason := '';
      isPortal := False;
      isRetdoc := False;
      
      if SameText(aReader.Fields[3], 'RET') and SameText(aReader.Fields[5], 'NAV') then //новый возврат
      begin
        isRetdoc := True;
        aHeader := 'Return';
        aCur := '';
        aComment := aReader.Fields[4];
        //NAV;S7036_6956
        //5  ;6         
        aArgCode := aReader.Fields[6];

        //добавлены поля
        //7 - Код адреса доставки
        //8 - Признак Доставка/Самовывоз
        //9 - Причину возврата "БРАК - Возврат" / "БРАК - Обмен", хранится в файле как "ret"/"exch" 
        aAddrCode := aReader.Fields[7];
        if aReader.Fields[8] = '1' then
          aDelivery := '1';
        if aReader.Fields[9] <> '' then //признак того что это брак
        begin
          if SameText(aReader.Fields[9], 'ret') then
            aReturnReason := 'БРАК_ВЗВРТ'
          else
            if SameText(aReader.Fields[9], 'exch') then
              aReturnReason := 'БРАК_ОБМЕН';
        end;
      end
      else
      if SameText(aReader.Fields[7], 'NAV') then //новый заказ
      begin
        aHeader := 'Order';
        //Код валюты
        aCur := '';
        
        case StrToIntDef(aReader.Fields[4], 0) of
          1: aCur := 'EUR';
          2: aCur := 'BYR';
          3: aCur := 'USD';
          4: aCur := 'RUB';
        end;
        
        aComment:= aReader.Fields[5];
        //NAV;S7036_6956;Д1;1/2;Ближайшая_доставка(1\0)
        //7  ;8         ;9 ;10 ;11
        aArgCode := aReader.Fields[8];
        aAddrCode := aReader.Fields[9];
        if aReader.Fields[10] = '1' then
          aDelivery := '1';
        aNearestDelivery := aReader.Fields[11];
      end
      else //заказ с портала
      if SameText(aReader.Fields[6], 'ordershate') or SameText(aReader.Fields[6], 'orderpartner') then
      begin
        isPortal := True;
        //возврат
        if (SameText(aReader.Fields[3], '04A') or SameText(aReader.Fields[3], '04B')) then 
        begin
          //73693073;24.12.2012;88949;04B;4;Возврат;ordershate
          aHeader := 'Return';
          aComment := aReader.Fields[5];
          AddLog('  возврат из портала');
        end
        else //заказ
        begin
          //64000225;31.12.2013;91887;B;4;Доставка;ordershate 
          aHeader := 'Order';
          aComment := aReader.Fields[5];
          AddLog('  заказ из портала');
        end
      end
      else //старый возврат
      if SameText(aReader.Fields[3], '04A') or SameText(aReader.Fields[3], '04B') then 
      begin
        //послать на мыло
        {
        aHeader := 'Return';
        aCur := 'BYR';
        aComment:= aReader.Fields[4];
        }
        Result := oprOldest;
        AddLog('  старый возврат');
        Exit;
      end
      else
      begin //старый заказ
        //послать на мыло
        Result := oprOldest;
        AddLog('  старый заказ');

        case StrToIntDef(aReader.Fields[4], 0) of
          1: aOutCur := 'EUR';
          2: aOutCur := 'BYR';
          3: aOutCur := 'USD';
          4: aOutCur := 'RUB';
        end;
        
        Exit;
      end;
      

      try //except
      //convert
        aDoc := TNativeXml.Create;
        try
          aDoc.EncodingString := 'windows-1251';
          aDoc.ExternalEncoding := se8Bit;// seUTF8;
          aDoc.XmlFormat := xfReadable;
          aDoc.VersionString := '1.0';
          aDoc.Root.Name := 'Document';
          aDoc.Root.AttributeAdd('Document_Type', aHeader);
          aDoc.Root.AttributeAdd('Customer_ID', aClientId);
          aDoc.Root.AttributeAdd('Request_No', aNum);
          aDoc.Root.AttributeAdd('Document_Date', aDate);
          aDoc.Root.AttributeAdd('Agreement_No', aArgCode);
          aDoc.Root.AttributeAdd('Currency', aCur);
          aDoc.Root.AttributeAdd('Ship_Address', aAddrCode);
          aDoc.Root.AttributeAdd('Comment', aComment);
          aDoc.Root.AttributeAdd('Delivery_Type', aDelivery);
          aDoc.Root.AttributeAdd('Return_Reason', aReturnReason);
          aDoc.Root.AttributeAdd('Nearest_Delivery', aNearestDelivery);

          while not aReader.Eof do
          begin
            aReader.ReturnLine;
            //<Line Item_No = "11024895" Quantity="34"/>
            aNode := aDoc.Root.NodeNew('Line');
            aNode.AttributeAdd('Item_No', aReader.Fields[0]);
            aNode.AttributeAdd('Quantity', aReader.Fields[1]);
            Inc(aRowCount);
          end;
          aReader.Close;

          aDoc.SaveToStream(aResXmlStream);
          Result := oprOK;
        finally
          aDoc.Free;
        end;
      except
        on E: Exception do
        begin
          AddLog('!Exception (Convert2XML): ' + E.Message);
          Result := oprError;
        end;
      end;  

    finally
//      aNormCSV.Free;
      aReader.Free;
      slReplaced.Free;
    end;
    
  except
    on E: Exception do
    begin
      AddLog('!Exception (ProcessFileCsv): ' + E.Message);
      Result := oprError;
    end;
  end;
end;


procedure TOrdServiceIMAP.ProcessIncomming;
var
  i, p: Integer;
  aConn: TAdoConnection;
  aQuery: TAdoQuery;
  aQueryUpdate: TAdoQuery;
  aQueryCode: TAdoQuery;
  aFileNameCsv, aErr, sCode, sCodeOrig: string;

  aCSVStream, aXmlStream: TMemoryStream;
  aProcessStatus: TOrderProcessingStatus;

  aClientID, aNum, aOldFile, aOrigFile, aOutCur: string;
  aOldLines: TStrings;
  aEmailManager: string;
  aIsPortal, aIsRetdoc: Boolean;
  aReplacedCodes: string;
  aRowCount: Integer;
begin
  AddLog('', False, True);
  AddLog('Обработка заявок...', True);

  aConn := DBConnectNew;
  aCSVStream := TMemoryStream.Create;
  aXmlStream := TMemoryStream.Create;
  try
    aQueryUpdate := TAdoQuery.Create(nil);
    aQueryUpdate.Connection := aConn;
    aQueryUpdate.CursorLocation := clUseClient;
    aQueryUpdate.CursorType := ctStatic;

    aQuery := TAdoQuery.Create(nil);
    aQuery.Connection := aConn;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.SQL.Text :=
      ' SELECT ID, FILE_NAME, DATA_CSV, EMAIL, DT_INSERT FROM INCOMING ' +
      ' WHERE PROCESS_STATUS IS NULL OR PROCESS_STATUS = 0 ' +
      ' ORDER BY ID ';
    aQuery.Open;  
      
    while not aQuery.Eof do
    begin
      if fAborted then 
        Break;
    
      aFileNameCsv := ExtractFilePath(ParamStr(0)) + 'processing.tmp';
      DeleteFile(aFileNameCsv);
      (aQuery.FieldByName('DATA_CSV') as TBlobField).SaveToFile(aFileNameCsv);
      
      aXmlStream.Clear;
      aOutCur := '';
      aIsPortal := False;
      aReplacedCodes := '';
      aRowCount := 0;
      aProcessStatus := ProcessFileCsv(aFileNameCsv, aQuery.FieldByName('FILE_NAME').AsString, aCSVStream, aXmlStream, aClientID, aNum, aOutCur, aIsPortal, aReplacedCodes, aRowCount, aIsRetdoc);
      aErr := '';
      case aProcessStatus of
        oprError:  
        begin
          aErr := 'Неправильный формат';
          aClientID := '';
          aNum := '';
        end;

        oprOK:     
        begin
          aErr := '';
        end;
        
        oprOldest: 
        begin
          aErr := 'Старый формат';
          //отправить на мыло манагеру
          aOldFile := ExtractFilePath(ParamStr(0)) + 'Old\' + aQuery.FieldByName('FILE_NAME').AsString;
          aOrigFile := ExtractFilePath(ParamStr(0)) + 'Old\_ORIG_' + aQuery.FieldByName('FILE_NAME').AsString;
          aOldLines := TStringList.Create;
          aQueryCode := TAdoQuery.Create(nil);
          try
            aCSVStream.Position := 0;
            aOldLines.LoadFromStream(aCSVStream);
            aOldLines.SaveToFile(aOrigFile);
            
            if aOldLines.Count > 0 then
              aOldLines[0] := aOldLines[0] + ';' + aOutCur;
            
            aQueryCode.Connection := aConn;
            aQueryCode.CursorLocation := clUseClient;
            aQueryCode.CursorType := ctStatic;
            aQueryCode.SQL.Text := 'SELECT NAV_NO FROM CODES_MAP WHERE DOP1 = :DOP1';
            
            for i := 1 to aOldLines.Count - 1 do
            begin
              p := POS(';', aOldLines[i]);
              if p > 0 then
              begin
                sCode := Copy(aOldLines[i], 1, p - 1);
                sCodeOrig := sCode;

                aQueryCode.Parameters[0].Value := sCode;
                try
                  aQueryCode.Open;
                  if not aQueryCode.Eof then
                    aOldLines[i] := aQueryCode.Fields[0].AsString + ';' + Copy(aOldLines[i], p + 1, MaxInt) + ';' + sCodeOrig
                  else
                    aOldLines[i] := aOldLines[i] + ';!код не найден';
                except
                  on E: Exception do
                  begin
                    AddLog('!Exception(aQueryCode.Open): ' + E.Message);
                    aOldLines[i] := aOldLines[i] + ';!EXCEPTION';
                  end;
                end;
                aQueryCode.Close;  
              end;
            end;
            aOldLines.SaveToFile(aOldFile);
          finally
            aQueryCode.Free;
            aOldLines.Free;
          end;

          aEmailManager := fManagersMap.Values[aClientID];
          if aEmailManager = '' then
            aEmailManager := fPrefs.ReportOldOrders;

          if (StrToIntDef(aClientID, 0) > 0) and (StrToIntDef(aClientID, 0) < 30) then
          begin
            AddLog('Отправка Рынки');
            aEmailManager := 'request_ip@shate-m.com';
            AddEmailOrderMarkets(aQuery.FieldByName('EMAIL').AsString, aEmailManager, aOldFile, aOrigFile);
          end
          else
            AddEmailOrderOld(aEmailManager, aOldFile, aOrigFile);
        end;
      end;

      aQueryUpdate.SQL.Text :=
        ' UPDATE INCOMING SET ' +
        '   DATA_CSV = :DATA_CSV, ' +
        '   DATA_XML = :DATA_XML, ' +
        '   PROCESS_STATUS = :PROCESS_STATUS, ' +
        '   PROCESS_ERROR = :PROCESS_ERROR, ' +
        '   CLIENT_ID = :CLIENT_ID, ' +
        '   NUM = :NUM, ' +
        '   SEND_STATUS = 0, ' +
        '   SEND_COUNT = 0, ' +
        '   SEND_RESPONSE_COUNT = 0, ' +
        '   IS_PORTAL = :IS_PORTAL, ' +
        '   IS_RETDOC = :IS_RETDOC, ' +
        '   REPLACED_CODES = :REPLACED_CODES, ' +
        '   ROW_COUNT = :ROW_COUNT, ' +
        '   PRIORITY = :PRIORITY, ' +
        '   DT_DELAYED = GetDate() ' +
        ' WHERE ID = :ID ';
      aCSVStream.Position := 0;
      aQueryUpdate.Parameters[0].LoadFromStream(aCSVStream, ftBlob);
      if aProcessStatus = oprOK then
        aQueryUpdate.Parameters[1].LoadFromStream(aXMLStream, ftBlob)
      else
        aQueryUpdate.Parameters[1].Value := NULL;

      aQueryUpdate.Parameters[2].Value := cOrderProcessingStatusCode[aProcessStatus];
      aQueryUpdate.Parameters[3].Value := aErr;
      aQueryUpdate.Parameters[4].Value := aClientID;
      aQueryUpdate.Parameters[5].Value := aNum;
      aQueryUpdate.Parameters[6].Value := Integer(aIsPortal);
      aQueryUpdate.Parameters[7].Value := Integer(aIsRetdoc);
      aQueryUpdate.Parameters[8].Value := aReplacedCodes;
      aQueryUpdate.Parameters[9].Value := aRowCount;
      aQueryUpdate.Parameters[10].Value := fPrefs.DefaultPriority;
     // aQueryUpdate.Parameters[11].Value := aQuery.FieldByName('DT_INSERT').AsDateTime;
      aQueryUpdate.Parameters[11].Value := aQuery.FieldByName('ID').AsInteger;
      aQueryUpdate.ExecSQL;
      aQueryUpdate.Close;

      aQuery.Next;
    end;
    aQuery.Close;
    
    aQuery.Free;
    aQueryUpdate.Free;
  finally
    aXmlStream.Free;
    DBDisconnectNew(aConn);
  end;
end;






function TOrdServiceIMAP.SendXML(aXmlStream: TStream; out aErr: string; aNeedWarmUp: Boolean; aIsTest: Boolean; const aLogIdentity: string): Boolean;
var
  aXml: TStrings;
  iServiceProg_Port: ServiceProg_Port;
  aErrFile: string;
  aWS: WideString;
  t: Cardinal;
begin
  Result := False;

  if aIsTest then
    AddLogWS('>> Отправка(ТЕСТ0)..')
  else
    AddLogWS('>> Отправка (' + aLogIdentity + ')..');
  t := GetTickCount;
  try
    aXml := TStringList.Create;
    try
      aXmlStream.Position := 0;
      aXml.LoadFromStream(aXmlStream);

      HTTPRIO1.WSDLLocation := ExtractFilePath(ParamStr(0)) + 'WS.WSDL';
      HTTPRIO1.Service := 'ServiceProg';
      HTTPRIO1.Port := 'ServiceProg_Port';
      HTTPRIO1.HTTPWebNode.ReceiveTimeout := fPrefs.ReceiveTimeout * 1000;
      HTTPRIO1.HTTPWebNode.SendTimeout := fPrefs.SendTimeout * 1000;

      HTTPRIO1.HTTPWebNode.UserName := cWSUser;
      HTTPRIO1.HTTPWebNode.Password := cWSPassword;
//yjdsqord101
      //iServiceProg_Port := GetServiceProg_Port(False, '', HTTPRIO1);

//--------------->>>>>>>
//aXml.SaveToFile(ExtractFilePath(ParamStr(0)) + 'out\1.xml');

      if aNeedWarmUp then
      begin
        try
          AddLogWS('   Warmup');
          (HTTPRIO1 as ServiceProg_Port).Warmup;
        except
          //ignore
        end;
      end;

      try
     //   AddLogWS('  Import');
        (HTTPRIO1 as ServiceProg_Port).ImportXML(aXml.Text);
     //   AddLogWS('  Import ok');
      except
        if not aIsTest then
          raise;
      end;

//if Random(3) = 1 then
//  raise Exception.Create(' test error ');
//<<<<<<<<<<<<<<<<<<<<<<<<<

      Result := True;
      AddLogWS('<< OK (' + IntToStr(GetTickCount - t) + ')');
    finally
      aXml.Free;
    end;
  except 
    on E: Exception do
    begin
      aErr := E.Message;
      AddLogWS('!EXCEPTION: ' + E.Message);
    end;
  end;
end;

function TOrdServiceIMAP.IsSkipRetdoc(aRowCount: Integer): Boolean;
begin
  Result :=
    (aRowCount > fPrefs.RetdocSkipRows) and
    (GetTime > fPrefs.RetdocSkipStart) and
    (GetTime < fPrefs.RetdocSkipEnd);
end;


procedure TOrdServiceIMAP.SendOrders;
var
  i: Integer;
  aConn: TAdoConnection;
  aQuery: TAdoQuery;
  aQueryUpdate: TAdoQuery;
  aFileNameCsv, aSendErr, aSendStatus: string;
  aXmlStream: TMemoryStream;
  aNeedWarmUp: Boolean;
  aIsOrderError5: Boolean;
  aEmailManager, aClientID, aNum, aOrigFile, aErrorsLog: string;
  aLastSent: Cardinal;
  fOut: TextFile;
  aIsTestOrder: Boolean;
  aQueueRecordCount: Integer;
  aProcessedCount, aProcessedBatchCount: Integer;
  aNeedSkip: Boolean;
  iPosClientPriority: integer;
begin
  AddLogWS('', False, True);
  AddLogWS('Отправка заявок...', True);
  
  aConn := DBConnectNew;
  aXmlStream := TMemoryStream.Create;
  try
    aQueryUpdate := TAdoQuery.Create(nil);
    aQueryUpdate.Connection := aConn;
    aQueryUpdate.CursorLocation := clUseClient;
    aQueryUpdate.CursorType := ctStatic;
  
    aQuery := TAdoQuery.Create(nil);
    aQuery.Connection := aConn;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.SQL.Text :=
      ' SELECT Count(ID) FROM INCOMING ' +
      ' WHERE ' +
      '   PROCESS_STATUS = :PROCESS_STATUS AND ' +
      '   (SEND_STATUS = 0 OR (SEND_STATUS = -1 AND SEND_COUNT < :SEND_COUNT)) AND ' +
      '   (DT_DELAYED <= GetDate() OR DT_DELAYED IS NULL) ';
    aQuery.Parameters[0].Value := cOrderProcessingStatusCode[oprOK];
    aQuery.Parameters[1].Value := fPrefs.SendToNAVCount;
    aQuery.Open;
    aQueueRecordCount := aQuery.Fields[0].AsInteger;
    aQuery.Close;
    AddLogWS(' в очереди: ' + IntToStr(aQueueRecordCount));
    aProcessedCount := 0;

    while True do
    begin
      {Селектим пачку для установки приоритетов}
      aQuery.SQL.Text :=
        ' SELECT ID, CLIENT_ID FROM INCOMING ' +
        ' WHERE ' +
        ' PROCESS_STATUS = :PROCESS_STATUS AND ' +
        ' (SEND_STATUS = 0 OR (SEND_STATUS = -1 AND SEND_COUNT < :SEND_COUNT)) AND (ID > :ID) ' +
        ' ORDER BY ID ';
      aQuery.Parameters[0].Value := cOrderProcessingStatusCode[oprOK];
      aQuery.Parameters[1].Value := fPrefs.SendToNAVCount;
      aQuery.Parameters[2].Value := fClientPriorityList.FLastOrderID;
      AddLogWS('Select пачки!!! Последняя ID: ' + IntToStr(fClientPriorityList.FLastOrderID));
      aQuery.Open;
      aQuery.First;
      AddLogWS('Select пачки - ОК');
      {Утановка приоритетов}
      while not aQuery.Eof do
      begin
        AddLogWS('Запись найдена -> ID: ' + aQuery.FieldByName('ID').AsString + ' Cli_id: ' + aQuery.FieldByName('CLIENT_ID').AsString);
        iPosClientPriority := fClientPriorityList.FindClient(aQuery.FieldByName('CLIENT_ID').AsString);
        AddLogWS('Порядковый номер найденой записи: ' + IntToStr(iPosClientPriority));
        if iPosClientPriority >= 0 then
        begin
          try
            AddLogWS('Запись: ' +
              'ID = ' + fClientPriorityList.FClientPriorityList[iPosClientPriority].FClientServiceID + #13#10 +
              'Clienty_code = ' + fClientPriorityList.FClientPriorityList[iPosClientPriority].FClientCode + #13#10 +
              'Start time = ' + fClientPriorityList.FClientPriorityList[iPosClientPriority].FTimeStart + #13#10 +
              'End time = ' + fClientPriorityList.FClientPriorityList[iPosClientPriority].FTimeEnd + #13#10 +
              'Priority = ' + IntToStr(fClientPriorityList.FClientPriorityList[iPosClientPriority].FPriority)
            );
          except
            on E: Exception do
              AddLogWS('!Exception: ' + E.Message);
          end;

          {проверка на диапазон времни}
          if (CompareTime(StrToDateTime(fClientPriorityList.FClientPriorityList[iPosClientPriority].FTimeStart),
                          Now()) <= 0)
            and
             (CompareTime(StrToDateTime(fClientPriorityList.FClientPriorityList[iPosClientPriority].FTimeEnd),
                          Now()) >= 0) then
          begin
            aQueryUpdate.SQL.Text :=
              ' UPDATE INCOMING SET ' +
              '   PRIORITY = :PRIORITY ' +
              ' WHERE ID = :ID ';
            aQueryUpdate.Parameters[0].Value := fClientPriorityList.FClientPriorityList[iPosClientPriority].FPriority;
            aQueryUpdate.Parameters[1].Value := aQuery.FieldByName('ID').AsInteger;
            aQueryUpdate.ExecSQL;

            AddLogWS('Приоритет изменен: клиент ' + aQuery.FieldByName('CLIENT_ID').AsString + ', приоритет ' + IntToStr(fClientPriorityList.FClientPriorityList[iPosClientPriority].FPriority), True);
          end;
        end;

        //Запоминаем последнюю запись
        fClientPriorityList.FLastOrderID := aQuery.FieldByName('ID').AsInteger;
        aQuery.Next;
      end;
      aQuery.Close;

     //цикл пачками по fPrefs.QueueSize штук, но селектим больше т.к. документы могут скиповаться
      aQuery.SQL.Text :=
        ' SELECT TOP ' + IntToStr(fPrefs.QueueSize*5) + ' ID, DATA_XML, SEND_COUNT, SEND_ERROR_LOG, CLIENT_ID, DATA_CSV, FILE_NAME, SEND_STATUS, NUM, ROW_COUNT, IS_RETDOC FROM INCOMING ' +
        ' WHERE ' +
        '   PROCESS_STATUS = :PROCESS_STATUS AND ' +
        '   (SEND_STATUS = 0 OR (SEND_STATUS = -1 AND SEND_COUNT < :SEND_COUNT)) AND ' +
        '   (DT_DELAYED <= GetDate() OR DT_DELAYED IS NULL) ' +
        ' ORDER BY PRIORITY, ID ';
      aQuery.Parameters[0].Value := cOrderProcessingStatusCode[oprOK];
      aQuery.Parameters[1].Value := fPrefs.SendToNAVCount;
      aQuery.Open;

      if aQuery.RecordCount < fPrefs.QueueSize then
        AddLogWS(' пачка: ' + IntToStr(aQuery.RecordCount))
      else
        AddLogWS(' пачка: ' + IntToStr(fPrefs.QueueSize));

      if aQuery.Eof then
        Break;

      aProcessedBatchCount := 0;
      aLastSent := 0;
      aNeedWarmUp := True;
      while not aQuery.Eof do
      begin
        if fAborted then
          Break;

        aClientID := aQuery.FieldByName('CLIENT_ID').AsString;
        aNum := aQuery.FieldByName('NUM').AsString;

        aNeedSkip := False;
        if aQuery.FieldByName('IS_RETDOC').AsInteger = 1 then
        begin
          aNeedSkip := IsSkipRetdoc(aQuery.FieldByName('ROW_COUNT').AsInteger);
          if aNeedSkip then
            AddLogWS(' !пропуск, большой возврат (' + aClientID + '_' + aNum + ')');
        end;

        aNeedSkip := aNeedSkip or (aQuery.FieldByName('SEND_STATUS').AsInteger = -2);
        if not aNeedSkip then
        begin
          Inc(aProcessedCount);
          Inc(aProcessedBatchCount);
          aXmlStream.Clear;
          (aQuery.FieldByName('DATA_XML') as TBlobField).SaveToStream(aXmlStream);

          aIsOrderError5 := False;

          //отправить в NAV
          aNeedWarmUp := aNeedWarmUp or ((GetTickCount - aLastSent) > 15000) or (aXmlStream.Size > 2 * 1024);
          aIsTestOrder := aClientID = '123456789';
          aLastSent := GetTickCount;
          if not SendXML( aXmlStream, aSendErr, {aNeedWarmUp - отключаем}False, aIsTestOrder, aClientID + '_' + aNum) then
          begin
            aSendStatus := '-1';
            if aQuery.FieldByName('SEND_COUNT').AsInteger + 1 >= fPrefs.SendToNAVCount then
            begin
              aSendStatus := '-2';
              aIsOrderError5 := True;
            end;

            aQueryUpdate.SQL.Text :=
              ' UPDATE INCOMING SET ' +
              '   SEND_STATUS = ' + aSendStatus + ', ' +
              '   SEND_COUNT = SEND_COUNT + 1, ' +
              '   SEND_ERROR = :SEND_ERROR, ' +
              '   SEND_ERROR_LOG = :SEND_ERROR_LOG, ' +
              '   DT_SEND = :DT_SEND ' +
              ' WHERE ID = :ID ';
            aQueryUpdate.Parameters[0].Value := aSendErr;

            if aQuery.FieldByName('SEND_ERROR_LOG').AsString = '' then
              aErrorsLog := FormatDateTime('DD.MM.YYYY HH:NN:SS', Now()) + ' - ' + aSendErr
            else
              aErrorsLog := aQuery.FieldByName('SEND_ERROR_LOG').AsString +  #13#10 + FormatDateTime('DD.MM.YYYY HH:NN:SS', Now()) + ' - ' + aSendErr;
            aQueryUpdate.Parameters[1].Value := aErrorsLog;
            aQueryUpdate.Parameters[2].Value := Now();
            aQueryUpdate.Parameters[3].Value := aQuery.FieldByName('ID').AsInteger;
            aQueryUpdate.ExecSQL;
            aQueryUpdate.Close;

            //отсылаем менеджеру письмо об ошибке резервирования заказа
            if aIsOrderError5 then
            begin
              aEmailManager := fManagersMap.Values[aClientID];
              if aEmailManager = '' then
                aEmailManager := fPrefs.ReportOldOrders;
              aOrigFile := ExtractFilePath(ParamStr(0)) + 'Old\_ERR_' + aQuery.FieldByName('FILE_NAME').AsString;
              DeleteFile(aOrigFile);
              TBlobField(aQuery.FieldByName('DATA_CSV')).SaveToFile(aOrigFile);
              AddEmailOrderError(aEmailManager, aOrigFile, aErrorsLog);
            end;

          end
          else
          begin
            aQueryUpdate.SQL.Text :=
              ' UPDATE INCOMING SET ' +
              '   SEND_STATUS = 1, ' +
              '   SEND_COUNT = SEND_COUNT + 1, ' +
              '   SEND_ERROR = '''', ' +
              '   DT_SEND = :DT_SEND ' +
              ' WHERE ID = :ID ';
            aQueryUpdate.Parameters[0].Value := Now();
            aQueryUpdate.Parameters[1].Value := aQuery.FieldByName('ID').AsInteger;
            aQueryUpdate.ExecSQL;
            aQueryUpdate.Close;

            if aIsTestOrder then
            begin
              AssignFile(fOut, ExtractFilePath(ParamStr(0)) + 'testorder.txt');
              Rewrite(fOut);
              try
                Writeln(fOut, aQuery.FieldByName('ID').AsString);
              finally
                CloseFile(fOut);
              end;
            end;
          end;
        end;

        aNeedWarmUp := False;

        //в выборке больше чем fPrefs.QueueSize, т.к. заказы могут пропускаться, а отправить нужно fPrefs.QueueSize штук
        if aProcessedBatchCount > fPrefs.QueueSize then
          Break;

        aQuery.Next;
      end; //while not aQuery.Eof

      aQuery.Close;

      if fAborted then
        Break;
      if (aProcessedCount >= aQueueRecordCount) or (aProcessedCount = 0) then
        Break;
    end;//while true

    aQuery.Free;
    aQueryUpdate.Free;
  finally
    aXmlStream.Free;
    DBDisconnectNew(aConn);
  end;

  //отправляем Waitlist только при свободной очереди заявок
  if aQueueRecordCount = 0 then
    SendWaitList(fPrefs.LimitSelectWaitList);
end;


procedure TOrdServiceIMAP.SendWaitList(aBatchLimit: Integer);
var
  i: Integer;
  aConn: TAdoConnection;
  aQuery: TAdoQuery;
  aQueryUpdate: TAdoQuery;
  aFileNameCsv, aSendErr, aSendStatus: string;
  aCsvStream: TMemoryStream;
  aIsOrderError5: Boolean;
  aEmailManager, aClientID, aOrigFile, aErrorsLog: string;
  fOut: TextFile;
begin
  AddLogWS('', False, True);
  AddLogWS('Отправка WaitList...', True);
  
  aConn := DBConnectNew;
  aCsvStream := TMemoryStream.Create;
  try
    aQueryUpdate := TAdoQuery.Create(nil);
    aQueryUpdate.Connection := aConn;
    aQueryUpdate.CursorLocation := clUseClient;
    aQueryUpdate.CursorType := ctStatic;
  
    aQuery := TAdoQuery.Create(nil);
    aQuery.Connection := aConn;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.SQL.Text :=     
      ' SELECT TOP ' + IntToStr(aBatchLimit) + ' ID, SEND_COUNT, SEND_ERROR_LOG, CLIENT_ID, DATA_CSV, FILE_NAME, SEND_STATUS FROM WAITLIST ' +
      ' WHERE (SEND_STATUS = 0 OR (SEND_STATUS = -1 AND SEND_COUNT < :SEND_COUNT) OR (SEND_STATUS IS NULL)) ' +
      ' ORDER BY ID ';
   // aQuery.Parameters[0].Value := cOrderProcessingStatusCode[oprOK];  //нет ProcessingStatus
    aQuery.Parameters[0].Value := fPrefs.SendToNAVCount;
    aQuery.Open;  

    AddLogWS(' в очереди: ' + IntToStr(aQuery.RecordCount));

    while not aQuery.Eof do
    begin
      if fAborted then 
        Break;
    
      if aQuery.FieldByName('SEND_STATUS').AsInteger <> -2 then
      begin
        aCsvStream.Clear;
        (aQuery.FieldByName('DATA_CSV') as TBlobField).SaveToStream(aCsvStream);
      
        aIsOrderError5 := False;
        aClientID := aQuery.FieldByName('CLIENT_ID').AsString;

        //отправить в NAV
        if not SendWaitlistCSV( aCsvStream, aSendErr) then
        begin
          aSendStatus := '-1';
          if aQuery.FieldByName('SEND_COUNT').AsInteger + 1 >= fPrefs.SendToNAVCount then
          begin
            aSendStatus := '-2';
            aIsOrderError5 := True;
          end;
        
          aQueryUpdate.SQL.Text := 
            ' UPDATE WAITLIST SET ' + 
            '   SEND_STATUS = ' + aSendStatus + ', ' + 
            '   SEND_COUNT = COALESCE(SEND_COUNT, 0) + 1, ' +
            '   SEND_ERROR = :SEND_ERROR, ' +
            '   SEND_ERROR_LOG = :SEND_ERROR_LOG, ' +
            '   DT_SEND = :DT_SEND ' +
            ' WHERE ID = :ID ';
          aQueryUpdate.Parameters[0].Value := aSendErr;

          if aQuery.FieldByName('SEND_ERROR_LOG').AsString = '' then
            aErrorsLog := FormatDateTime('DD.MM.YYYY HH:NN:SS', Now()) + ' - ' + aSendErr
          else  
            aErrorsLog := aQuery.FieldByName('SEND_ERROR_LOG').AsString +  #13#10 + FormatDateTime('DD.MM.YYYY HH:NN:SS', Now()) + ' - ' + aSendErr;
          aQueryUpdate.Parameters[1].Value := aErrorsLog;
          aQueryUpdate.Parameters[2].Value := Now();
          aQueryUpdate.Parameters[3].Value := aQuery.FieldByName('ID').AsInteger;
          aQueryUpdate.ExecSQL;
          aQueryUpdate.Close;

          //отсылаем менеджеру письмо об ошибке резервирования заказа
          {
          if aIsOrderError5 then
          begin
            aEmailManager := fManagersMap.Values[aClientID];
            if aEmailManager = '' then
              aEmailManager := fPrefs.ReportOldOrders;
            aOrigFile := ExtractFilePath(ParamStr(0)) + 'Old\_ERR_' + aQuery.FieldByName('FILE_NAME').AsString;
            DeleteFile(aOrigFile);
            TBlobField(aQuery.FieldByName('DATA_CSV')).SaveToFile(aOrigFile);
            AddEmailOrderError(aEmailManager, aOrigFile, aErrorsLog);
          end;
          }
        end
        else
        begin
          aQueryUpdate.SQL.Text := 
            ' UPDATE WAITLIST SET ' + 
            '   SEND_STATUS = 1, ' + 
            '   SEND_COUNT = COALESCE(SEND_COUNT, 0) + 1, ' +
            '   SEND_ERROR = '''', ' + 
            '   DT_SEND = :DT_SEND ' +
            ' WHERE ID = :ID ';
          aQueryUpdate.Parameters[0].Value := Now();
          aQueryUpdate.Parameters[1].Value := aQuery.FieldByName('ID').AsInteger;
          aQueryUpdate.ExecSQL;
          aQueryUpdate.Close;
        end;
      end;
    
      aQuery.Next;
    end;
    aQuery.Close;
    
    aQuery.Free;
    aQueryUpdate.Free;
  finally
    aCsvStream.Free;
    DBDisconnectNew(aConn);
  end;
end;


function TOrdServiceIMAP.SendWaitlistCSV(aCsvStream: TMemoryStream; out aErr: string): Boolean;
var
  aXml: TStrings;
  iServiceProg_Port: ServiceProg_Port;
  aFileNameCsv, aClientId, aCode,aBrand: string;
  aWS: WideString;
  aReader: TCSVReader;
  aQuant: TXSDecimal;
  aDateTime: TXSDateTime;
  aReaderLine: string;
  fImported: boolean;
  aHasWaitListLines: Boolean;

  function isValidQnt(value: string): string;
  begin
    Result := IntToStr(StrToIntDef(value, 1));
  end;

begin
  Result := False;
  AddLogWS('>>Отправка waitlist');

  aFileNameCsv := ExtractFilePath(ParamStr(0)) + 'waitlist.tmp';
  DeleteFile(aFileNameCsv);
  aCsvStream.Position := 0;
  aCsvStream.SaveToFile(aFileNameCsv);

  try
    aReader := TCSVReader.Create;
    fImported := False;
    aHasWaitListLines := False;

    HTTPRIO1.WSDLLocation := ExtractFilePath(ParamStr(0)) + 'WS.WSDL';
    HTTPRIO1.Service := 'ServiceProg';
    HTTPRIO1.Port := 'ServiceProg_Port';
    HTTPRIO1.HTTPWebNode.ReceiveTimeout := fPrefs.ReceiveTimeout * 1000;
    HTTPRIO1.HTTPWebNode.SendTimeout := fPrefs.SendTimeout * 1000;

    HTTPRIO1.HTTPWebNode.UserName := cWSUser;
    HTTPRIO1.HTTPWebNode.Password := cWSPassword;

    try
      aReader.Open(aFileNameCsv);
      aReader.ReturnLine;
      aClientId := aReader.Fields[0];
      AddLogWS('  client: ' + aClientId);
      aQuant := TXSDecimal.Create;
      aDateTime := TXSDateTime.Create;

      while not aReader.Eof do
      begin
        aReaderLine := aReader.ReturnLine;
        DecodeCodeBrand(aReader.Fields[0], aCode, aBrand, False);

        try
          //aReader.Fields[2] - тип waitlist/assort exp
          aQuant.DecimalString :=  isValidQnt(aReader.Fields[3]);
          aDateTime.AsDateTime := StrToDateTime(aReader.Fields[1], formatDateSettings);

          {Не импортить расширение ассортимента}
          if aReader.Fields[2] <> '3' then
          begin
            aHasWaitListLines := True;
            AddLogWS('  Import line ');
            (HTTPRIO1 as ServiceProg_Port).ImportWaitingList(aClientId, aCode, aBrand, aQuant, aDateTime);
            fImported := TRUE;
            AddLogWS('  Import ok');
          end;
          
        except
          on E: Exception do
          begin
            aErr := E.Message;
            AddLogWS('!EXCEPTION(SendWaitlistCSV: ' + aReaderLine + '): ' + E.Message);
          end;
        end;
      end;

      Result := fImported;
      if (not Result) and not (aHasWaitListLines) then
        Result := True;

      if Result then
        AddLogWS('<<Отправка OK')
      else
        AddLogWS('<<!Отправка FAIL');

    finally
      aReader.Free;
      aQuant.Free;
      aDateTime.Free;
    end;
    
  except 
    on E: Exception do
    begin
      aErr := E.Message;
      AddLogWS('!EXCEPTION: ' + E.Message);
    end;
  end;
end;

{ TClientPriorityList }

procedure TClientPriorityList.AddClientPriority(const aClientPriority: TClientPriority);
begin
  Inc(FLength);
  SetLength(FClientPriorityList, FLength);
  FClientPriorityList[FLength - 1] := aClientPriority;
end;

constructor TClientPriorityList.Create;
begin
  FLength := 0;
  FLastOrderID := 0;
end;

destructor TClientPriorityList.Destroy;
begin
  SetLength(FClientPriorityList, 0);
end;

function TClientPriorityList.FindClient(aClientCode: string): integer;
var
  i: integer;
begin
  result := -1;
  if FClientPriorityList <> nil then
  begin
    for i:=0 to FLength -1 do
      if FClientPriorityList[i].FClientServiceID = aClientCode then
      begin
        result := i;
        break;
      end;
  end;
end;

end.

