unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  dbisamtb, DB, ADODB, VCLUnZip, VCLZip, ActiveX, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdMessage, IdCoderHeader, SyncObjs, Variants;

const
  cAMDConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;';
  cCustomAutorityParams = 'Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s;';

  //[DATABASE]
  cSQLServerDef = 'SVBYMINSD9';
  cDatabaseNameDef = 'CLIENT_INFO';
  cDBUserDef = 'DiscountsService';
  cDBPasswordDef = 'DiscountsService';

  //[NET]
  cNetUserDef = 'Shate\DiscountsService';
  cNetPasswordDef = 'DiscountsService';

  //MAIL
  cReportSysErrorsDef = '';
  cReportUserErrorsDef = '';
  cMailHostDef = '10.0.0.1';
  cMailPortDef = 25;
  cMailUserDef = '';
  cMailPasswordDef = '';


  //маски искомых файлов
  cFullDiscountsMask = 'servdiscagent_*.csv';
  cPartDiscountsMask = 'servdisc_*.csv';
  cFullClientsMask = 'servpassagent_*.csv';
  cPartClientsMask = 'servpass_*.csv';
  cClientsDescrMask = 'clients_*.csv';
  //новое для NAV  
  cNAV_FullClientsMask = 'servpassagent_*.csv';
  cNAV_PartClientsMask = 'servpass_*.csv';
  cNAV_DiscountsMask = 'servdiscagent_*.csv';
  cNAV_AgreementsMask = 'custagreement_*.csv'; //custagreement_<дата_время_в_формате_DD.MM.YYYY_HH.MM>.csv
  cNAV_AddressMask = 'shipaddress.csv';
  cNAV_ClientsDescrMask = 'ClientsDescr.csv';


type
  TClientRespondType = (crtADDRESS, crtAGREEMENTS, crtDISCOUNTS);
  TClientRespondTypes = set of TClientRespondType;

const
  cAllClientRespondTypes: TClientRespondTypes = [crtADDRESS, crtAGREEMENTS, crtDISCOUNTS];

type  


  TMyIdMessage = class(TIdMessage)
  protected
    procedure OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
  public
    constructor Create(AOwner:TComponent);
  end;

  TServiceDiscounts = class;
  TSMTPMessagesThrd = class(TThread)
  private
    fOwnerService: TServiceDiscounts;
    fMessages: TThreadList;
  protected
    procedure Execute; override;
  public
    constructor Create(aOwnerService: TServiceDiscounts; aMessageList: TThreadList);
  end;

  TMessSMTP = class
    TrySendCount: Integer;
    ShateEmail: string;
    email: string;
    subj: string;
    fn: string;
    Host: string;
    Port: Integer;
    Username: string;
    Password: string;
    Body: string;
  end;



  TPrefs = record
    //MAIN
    DebugLogEnabled: Boolean;
    RebuildAllOnStartup: Boolean;
    LotusMapFile: string;
    ScanFilesInterval: Cardinal;
    RenameProcessedDiscounts: Boolean;
    RenameProcessedClients: Boolean;

    //пути поиска
    DiscountsSearchPaths: string;
    ClientsSearchPaths: string;
    ClientsDescrSearchPaths: string;
    //пути поиска для NAV
    NAV_DiscountsSearchPaths: string;
    NAV_ClientsSearchPaths: string;
    NAV_AgreementsSearchPaths: string;
    NAV_AddressSearchPaths: string;

    //маски
    FullDiscountsMask: string;
    PartDiscountsMask: string;
    FullClientsMask: string;
    PartClientsMask: string;
    ClientsDescrMask: string;
    //маски новые для NAV
    NAV_FullClientsMask: string;
    NAV_PartClientsMask: string;
    NAV_DiscountsMask: string;
    NAV_AgreementsMask: string;
    NAV_AddressMask: string;
    NAV_ClientsDescrMask: string;

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
    ReportSysErrors: string;
    ReportUserErrors: string;
    MailHost: string;
    MailPort: Integer;
    MailUser: string;
    MailPassword: string;
  end;

  TFileType = (ftNone, ftFullDiscounts, ftFullClients, ftPartDiscounts, ftPartClients, ftClientsDescr);
  TFileTask = record
    FileType: TFileType;
    FileName: string;
    FileDateTime: TDateTime;
  end;

  TNAV_FileType = (nftNone, nftFullClients, nftPartClients, nftDiscounts, nftAgreements, nftAddress, nftClientsDescr);
  TNAV_FileTask = record
    FileType: TNAV_FileType;
    FileName: string;
    FileDateTime: TDateTime;
  end;
  
  TServiceDiscounts = class(TService)
    DBISAMEngine1: TDBISAMEngine;
    memDiscounts: TDBISAMTable;
    memDiscountsID: TAutoIncField;
    memDiscountsCAT_CODE: TStringField;
    memDiscountsDISCOUNT: TCurrencyField;
    memDiscountsUPDATED: TBooleanField;
    memDiscountsFOUND: TBooleanField;
    memDiscountsNEW: TBooleanField;
    memClients: TDBISAMTable;
    memClientsID: TAutoIncField;
    memClientsPRIVATE_KEY: TStringField;
    memClientsUPDATED: TBooleanField;
    memClientsFOUND: TBooleanField;
    memClientsNEW: TBooleanField;
    InsertCommand: TADOCommand;
    Zipper: TVCLZip;
    Query: TADOQuery;
    defConnection: TADOConnection;
    memClientsCLIENT_ID: TStringField;
    memDiscountsCLIENT_ID: TStringField;
    memImportDiscount: TDBISAMTable;
    memImportDiscountDISCOUNT: TCurrencyField;
    memImportDiscountGROUP: TIntegerField;
    memImportDiscountSUBGROUP: TIntegerField;
    memImportDiscountBRAND: TIntegerField;
    memImportDiscountFIX: TIntegerField;
    memDiscountsFIX: TIntegerField;
    memImportDiscountGROUP_DIS: TIntegerField;
    memDiscountsPRICE_GROUP: TIntegerField;

    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceDestroy(Sender: TObject);
  private
    fThread: TThread;
    fMailSendThread: TThread;
    fLogLock: TCriticalSection;
    fListMessages: TThreadList;

    fMappedDrives: string; //e.g. 'XYZ'

    fLogFileName: string;
    fIniFileName: string;
    fAborted: Boolean;
    fServiceHasStarted: Boolean;

    fRegisteredPaths: TStrings;
    fDiscountsPaths: TStrings;
    fClientsPaths: TStrings;
    fClientsDescrPaths: TStrings;

    fNAV_DiscountsPaths: TStrings;
    fNAV_ClientsPaths: TStrings;
    fNAV_AgreementsPaths: TStrings;
    fNAV_AddressPaths: TStrings;

    //INI prefs
    fPrefs: TPrefs;

    procedure LoadINI;
    procedure LogPrefs;

    function MapNetDrive(aDrive: Char; const aPath: string; UnmapBefore: Boolean = False): Boolean;
    function UnmapNetDrive(aDrive: Char): Boolean;
    procedure ProcessPaths(aPathsList: TStrings);
    procedure UnmapAllDrives;

    procedure ProcessMessages;
  public
    function GetServiceController: TServiceController; override;

    procedure AddLog(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);
    procedure AddEmailReport(const aText: string; isSysReport: Boolean);
    
    procedure DBConnect(IsTest: Boolean = False);
    procedure DBDisconnect;
    procedure UpVersion(const aParamName: string; aVersionDateTime: TDateTime; aVersionCustom: Integer = -1{Auto UP});

    function ScanForTask: TFileTask;
    procedure SaveProcessedData(aTaskType: TFileType; aFileDateTime: TDateTime);
    procedure SaveFileList;

    function CheckClientID(const aClientID: string): Boolean;
    procedure CacheClients(aForce: Boolean; aOnlyClientID: string);
    function LoadClients(const aClientsFileName: string; aIsPartial: Boolean): Boolean;
    function LoadClientsDescr(const aClientsFileName: string): Boolean;

    procedure CacheDiscounts(aForce: Boolean; aOnlyClientID: string);
    function LoadDiscounts(const aDiscountsFileName: string; aOnlyClientId: string = '-1'): Boolean;

    procedure LoadMap(const aMapFileName: string);

    procedure RePack(aForceAll: Boolean);

    //*** скидки по-новому (NAV) ***
    function NAV_LoadAddess(const aAddrFileName: string): Boolean;    //адреса доставок
    function NAV_LoadAgreement(const aAgrFileName: string): Boolean;      //договора
    function NAV_LoadDiscounts(const aDiscFileName: string): Boolean; //скидки

    procedure NAV_RePack(aForceAll: Boolean; aRepackTypes: TClientRespondTypes);
    procedure NAV_RePack_Address(aForceAll: Boolean);
    procedure NAV_RePack_Agreements(aForceAll: Boolean);
    procedure NAV_RePack_Discounts(aForceAll: Boolean);
    function NAV_LoadClientsDescr(const aClientsFileName: string): Boolean;

    function NAV_ScanForTask: TNAV_FileTask;
    procedure NAV_SaveProcessedData(aTaskType: TNAV_FileType; aFileDateTime: TDateTime);
  end;

var
  ServiceDiscounts: TServiceDiscounts;

implementation

{$R *.DFM}

uses
  uProcessThread, _CSVReader, IniFiles, WinSvc;

{ Global }

function StrToFloatDefUnic(const aValue: string; aDef: Extended): Double;
var
  aNorm: string;
begin
  aNorm := aValue;
  if DecimalSeparator <> '.' then
    aNorm := StringReplace(aNorm, '.', DecimalSeparator, [rfReplaceAll]);
  if DecimalSeparator <> ',' then
    aNorm := StringReplace(aNorm, ',', DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloatDef(aNorm, aDef);
end;

function StrGetName(const aValue: string): string;
var
  p: Integer;
begin
  p := POS('=', aValue);
  if p > 0 then
    Result := Copy(aValue, 1, p - 1)
  else
    Result := aValue;
end;

function StrGetValue(const aValue: string): string;
var
  p: Integer;
begin
  p := POS('=', aValue);
  if p > 0 then
    Result := Copy(aValue, p + 1, MAXINT)
  else
    Result := '';
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceDiscounts.AddLog('CtrlCode: ' + IntToStr(CtrlCode), True);
  ServiceDiscounts.Controller(CtrlCode);
end;


{ TServiceDiscounts }

function TServiceDiscounts.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServiceDiscounts.ServiceCreate(Sender: TObject);
var
  b: Boolean;
begin
  fLogLock := TCriticalSection.Create;
  fListMessages := TThreadList.Create;
  fRegisteredPaths := TStringList.Create;
  fDiscountsPaths := TStringList.Create;
  fClientsPaths := TStringList.Create;
  fClientsDescrPaths := TStringList.Create;
  //пути для NAV
  fNAV_DiscountsPaths := TStringList.Create;
  fNAV_ClientsPaths := TStringList.Create;
  fNAV_AgreementsPaths := TStringList.Create;
  fNAV_AddressPaths := TStringList.Create;
  

  fLogFileName := ChangeFileExt(ExpandFileName(ParamStr(0)), '.log');
  fIniFileName := ChangeFileExt(ExpandFileName(ParamStr(0)), '.ini');
  ZeroMemory(@fPrefs, SizeOf(fPrefs));
  LoadINI;
  
  // debug >>
//  ServiceStart(Self, b);
//  while True do;
  // << debug

end;

procedure TServiceDiscounts.ServiceDestroy(Sender: TObject);
begin
  fRegisteredPaths.Free;
  fDiscountsPaths.Free;
  fClientsPaths.Free;
  fClientsDescrPaths.Free;
  //NAV
  fNAV_DiscountsPaths.Free;
  fNAV_ClientsPaths.Free;
  fNAV_AgreementsPaths.Free;
  fNAV_AddressPaths.Free;

  if fServiceHasStarted then
  begin
    AddLog('Служба остановлена');
    AddLog('**************************************', False, True);
  end;
  fLogLock.Free;
  fListMessages.Free;
end;

procedure TServiceDiscounts.ServiceStart(Sender: TService; var Started: Boolean);
begin
  AddLog(#13#10#13#10'**************************************', False, True);
  AddLog('Запуск службы...');
  LogPrefs;
  if (Trim(fPrefs.MailHost) = '') or (fPrefs.MailPort <= 0) then
    AddLog('Зарегистрированные пути: '#13#10 + fRegisteredPaths.Text, True);

  AddLog('Зарегистрированные пути: '#13#10 + fRegisteredPaths.Text, True);
  ProcessPaths(fRegisteredPaths);
  AddLog('Подключенные диски: ' + fMappedDrives);
  AddLog('Зарегистрированные пути после обработки: '#13#10 + fRegisteredPaths.Text, True);
  AddLog('Пути Discounts: '#13#10 + fDiscountsPaths.Text, True);
  AddLog('Пути Clients: '#13#10 + fClientsPaths.Text, True);
  AddLog('Пути Clients Descriptions: '#13#10 + fClientsDescrPaths.Text, True);


  AddLog('Проверка подключения к SQL-серверу', True);
  DBConnect(True{IsTest});
  DBDisconnect;

  Started := True;
  fServiceHasStarted := True;
  AddLog('Служба запущена');

  fThread := TProcessThread.Create(Self);
  TProcessThread(fThread).Init(fPrefs);
  fThread.Resume;

  fMailSendThread := TSMTPMessagesThrd.Create(Self, fListMessages);
  fMailSendThread.Resume;
end;

procedure TServiceDiscounts.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  AddLog('Остановка службы...');
  fAborted := True;

  //говорим потокам чтоб завершались
  if Assigned(fThread) then
    fThread.Terminate;
  if Assigned(fMailSendThread) then
    fMailSendThread.Terminate;

  //ждем завершения потоков
  if Assigned(fThread) then
  begin
    fThread.WaitFor;
    fThread.Free;
  end;
  if Assigned(fMailSendThread) then
  begin
    fMailSendThread.WaitFor;
    fMailSendThread.Free;
  end;

  UnmapAllDrives; //только после завершения TProcessThread, т.к. он использует подключенные диски
  Stopped := True;
end;

procedure TServiceDiscounts.AddEmailReport(const aText: string; isSysReport: Boolean);
var
  aClient: TMessSMTP;
begin
  aClient := TMessSMTP.Create;

  aClient.email := 'DiscountsService';//from
  if isSysReport then
  begin
    aClient.ShateEmail := fPrefs.ReportSysErrors;//to
    aClient.subj := 'NAV Discounts Service - оповещение о системных ошибках';
  end
  else
  begin
    aClient.ShateEmail := fPrefs.ReportUserErrors;//to
    aClient.subj := 'NAV Discounts Service - оповещение об ошибках';
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

procedure TServiceDiscounts.AddLog(const aText: string; isDebug: Boolean; aWithoutDateTime: Boolean);
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

procedure TServiceDiscounts.LoadINI;
var
  aIni: TIniFile;
  i: Integer;
begin
  aIni := TIniFile.Create(fIniFileName);
  try
    //[MAIN]
    fPrefs.DebugLogEnabled := aINI.ReadBool('MAIN', 'EnableDebugLog', fPrefs.DebugLogEnabled);
    fPrefs.RebuildAllOnStartup := aINI.ReadBool('MAIN', 'RebuildAllOnStartup', fPrefs.DebugLogEnabled);
    fPrefs.LotusMapFile := aINI.ReadString('MAIN', 'LotusCategoryMapFile', 'lotusmap.csv');
    fPrefs.ScanFilesInterval := aINI.ReadInteger('MAIN', 'ScanFilesInterval', 60);
    fPrefs.RenameProcessedDiscounts := aINI.ReadBool('MAIN', 'RenameProcessedDiscounts', fPrefs.RenameProcessedDiscounts);
    fPrefs.RenameProcessedClients := aINI.ReadBool('MAIN', 'RenameProcessedClients', fPrefs.RenameProcessedClients);
    {
    fPrefs.DiscountsSearchPaths := aINI.ReadString('MAIN', 'DiscountsSearchPaths', '');
    fPrefs.ClientsSearchPaths := aINI.ReadString('MAIN', 'ClientsSearchPaths', '');
    fPrefs.ClientsDescrSearchPaths := aINI.ReadString('MAIN', 'ClientsDescrSearchPaths', '');
    }
    //NAV >>---
    fPrefs.NAV_DiscountsSearchPaths := aINI.ReadString('MAIN', 'NAV_DiscountsSearchPaths', '');
    fPrefs.NAV_ClientsSearchPaths := aINI.ReadString('MAIN', 'NAV_ClientsSearchPaths', '');
    fPrefs.NAV_AgreementsSearchPaths := aINI.ReadString('MAIN', 'NAV_AgreementsSearchPaths', '');
    fPrefs.NAV_AddressSearchPaths := aINI.ReadString('MAIN', 'NAV_AddressSearchPaths', '');
    //<< NAV
    {
    fPrefs.FullDiscountsMask := aINI.ReadString('MAIN', 'FullDiscountsMask', cFullDiscountsMask);
    fPrefs.PartDiscountsMask := aINI.ReadString('MAIN', 'PartDiscountsMask', cPartDiscountsMask);
    fPrefs.FullClientsMask := aINI.ReadString('MAIN', 'FullClientsMask', cFullClientsMask);
    fPrefs.PartClientsMask := aINI.ReadString('MAIN', 'PartClientsMask', cPartClientsMask);
    fPrefs.ClientsDescrMask := aINI.ReadString('MAIN', 'ClientsDescrMask', cClientsDescrMask);
    }
    //NAV >>---
    fPrefs.NAV_FullClientsMask := aINI.ReadString('MAIN', 'NAV_FullClientsMask', cNAV_FullClientsMask);
    fPrefs.NAV_PartClientsMask := aINI.ReadString('MAIN', 'NAV_PartClientsMask', cNAV_PartClientsMask);
    fPrefs.NAV_DiscountsMask := aINI.ReadString('MAIN', 'NAV_DiscountsMask', cNAV_DiscountsMask);
    fPrefs.NAV_AgreementsMask := aINI.ReadString('MAIN', 'NAV_AgreementsMask', cNAV_AgreementsMask);
    fPrefs.NAV_AddressMask := aINI.ReadString('MAIN', 'NAV_AddressMask', cNAV_AddressMask);
    fPrefs.NAV_ClientsDescrMask := aINI.ReadString('MAIN', 'NAV_ClientsDescrMask', cNAV_ClientsDescrMask);
    //<<NAV

    //[NET]
    fPrefs.UnmountDriveIfUsed := aINI.ReadBool('NET', 'UnmountDriveIfUsed', fPrefs.UnmountDriveIfUsed);
    fPrefs.NetUser := aINI.ReadString('NET', 'NetUser', '');
    fPrefs.NetPassword := aINI.ReadString('NET', 'NetPassword', '');
    if fPrefs.NetUser = '' then
    begin
      fPrefs.NetUser := cNetUserDef;
      fPrefs.NetPassword := cNetPasswordDef;
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

procedure TServiceDiscounts.LogPrefs;
begin
  AddLog(
    Format(
      '#'#13#10 +
      '#  Общие настройки-----------------------'#13#10 +
      '#    отладочный лог: %d'#13#10 +
      '#    пересобрать скидки при старте: %d'#13#10 +
      '#    файл с категориями Лотуса: %s'#13#10 +
      '#    интервал сканирования файлов: %d'#13#10 +
      '#    переименовывать файлы скидок: %d'#13#10 +
      '#    переименовывать файлы клиентов: %d'#13#10 +
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
      '#    e-mail пользователь: %s'#13#10 +
      '#  Маски файлов -------------------------'#13#10 +
      '#    полный файл скидок: %s'#13#10 +
      '#    частичный файл скидок: %s'#13#10 +
      '#    полный файл клиентов: %s'#13#10 +
      '#    частичный файл клиентов: %s'#13#10 +
      '#    файл описаний клиентов: %s'#13#10,
      [
        Integer(fPrefs.DebugLogEnabled),
        Integer(fPrefs.RebuildAllOnStartup),
        fPrefs.LotusMapFile,
        fPrefs.ScanFilesInterval,
        Integer(fPrefs.RenameProcessedDiscounts),
        Integer(fPrefs.RenameProcessedClients),

        fPrefs.SqlServerName,
        fPrefs.DatabaseName,
        fPrefs.DBUser,

        Integer(fPrefs.UnmountDriveIfUsed),
        fPrefs.NetUser,

        fPrefs.ReportSysErrors,
        fPrefs.ReportUserErrors,
        fPrefs.MailHost,
        fPrefs.MailPort,
        fPrefs.MailUser,

        fPrefs.FullDiscountsMask,
        fPrefs.PartDiscountsMask,
        fPrefs.FullClientsMask,
        fPrefs.PartClientsMask,
        fPrefs.ClientsDescrMask
      ]
    ), False, True
  );
end;


function TServiceDiscounts.MapNetDrive(aDrive: Char;
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

function TServiceDiscounts.UnmapNetDrive(aDrive: Char): Boolean;
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

procedure TServiceDiscounts.UpVersion(const aParamName: string;
  aVersionDateTime: TDateTime; aVersionCustom: Integer);
var
  aQuery: TAdoQuery;
  aVersion: Integer;
begin
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text := 'SELECT VERSION FROM VERSIONS WHERE PARAM = :PARAM';
    aQuery.Parameters[0].Value := aParamName;
    aQuery.Open;
    if aQuery.Eof then
    begin
      aQuery.Close;
      aQuery.SQL.Text := ' INSERT INTO VERSIONS ( PARAM,  VERSION,  VERSION_DATE) ' +
                         '               VALUES (:PARAM, :VERSION, :VERSION_DATE) ';
      if aVersionCustom <> -1 then
        aVersion := aVersionCustom
      else
        aVersion := 0;

      aQuery.Parameters[0].Value := aParamName;
      aQuery.Parameters[1].Value := aVersion;
      aQuery.Parameters[2].Value := aVersionDateTime;
      aQuery.ExecSQL;
    end
    else
    begin
      aVersion := aQuery.FieldByName('VERSION').AsInteger;
      aQuery.Close;
      aQuery.SQL.Text := ' UPDATE VERSIONS SET VERSION = :VERSION, VERSION_DATE = :VERSION_DATE ' +
                         ' WHERE PARAM = :PARAM ';

      if aVersionCustom <> -1 then
        aVersion := aVersionCustom
      else
        Inc(aVersion);

      aQuery.Parameters[0].Value := aVersion;
      aQuery.Parameters[1].Value := aVersionDateTime;
      aQuery.Parameters[2].Value := aParamName;
      aQuery.ExecSQL;
    end;
  finally
    aQuery.Free;
  end;
end;

//обработка путей поиска, подключение сетевых дисков
procedure TServiceDiscounts.ProcessPaths(aPathsList: TStrings);

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
  
  fDiscountsPaths.Delimiter := ';';
  fDiscountsPaths.DelimitedText := ReplacePathVars(fPrefs.DiscountsSearchPaths);
  NormalizePaths(fDiscountsPaths);

  fClientsPaths.Delimiter := ';';
  fClientsPaths.DelimitedText := ReplacePathVars(fPrefs.ClientsSearchPaths);
  NormalizePaths(fClientsPaths);

  fClientsDescrPaths.Delimiter := ';';
  fClientsDescrPaths.DelimitedText := ReplacePathVars(fPrefs.ClientsDescrSearchPaths);
  NormalizePaths(fClientsDescrPaths);

  // NAV - откоментить
  fNAV_DiscountsPaths.Delimiter := ';';
  fNAV_DiscountsPaths.DelimitedText := ReplacePathVars(fPrefs.NAV_DiscountsSearchPaths);
  NormalizePaths(fNAV_DiscountsPaths);

  fNAV_ClientsPaths.Delimiter := ';';
  fNAV_ClientsPaths.DelimitedText := ReplacePathVars(fPrefs.NAV_ClientsSearchPaths);
  NormalizePaths(fNAV_ClientsPaths);
  
  fNAV_AgreementsPaths.Delimiter := ';';
  fNAV_AgreementsPaths.DelimitedText := ReplacePathVars(fPrefs.NAV_AgreementsSearchPaths);
  NormalizePaths(fNAV_AgreementsPaths);
  
  fNAV_AddressPaths.Delimiter := ';';
  fNAV_AddressPaths.DelimitedText := ReplacePathVars(fPrefs.NAV_AddressSearchPaths);
  NormalizePaths(fNAV_AddressPaths);
  //--------------------
end;

procedure TServiceDiscounts.UnmapAllDrives;
var
  i: Integer;
begin
  for i := 1 to Length(fMappedDrives) do
    UnmapNetDrive(fMappedDrives[i]);
end;

procedure TServiceDiscounts.ProcessMessages;
begin
  ServiceThread.ProcessRequests(False);
  fAborted := Terminated;
end;

function TServiceDiscounts.ScanForTask: TFileTask;
  {
  procedure FindFile1(aPaths: TStrings);
  var
    aPath: string;
    SearchRec: TSearchRec;
    a, i: Integer;
    aFound: Boolean;
    aCurDateTime: TDateTime;
  begin

    aFound := False;
    for i := 0 to aPaths.Count - 1 do
    begin
      aPath := aPaths[i];
      a := FindFirst(aPath + '*.csv', faAnyFile, SearchRec);
      while a = 0 do
      begin
        if (SearchRec.Attr and faDirectory) > 0 then
        begin
          a := FindNext(SearchRec);
          Continue;
        end;

        if CopyFile(PChar(aPath + SearchRec.Name), PChar('c:\temp\srv1\' + SearchRec.Name), True) then
          AddLog('copy: ' + aPath + SearchRec.Name, True)
        else
          AddLog('copy error: ' + aPath + SearchRec.Name, True);


        a := FindNext(SearchRec);
      end;
      FindClose(SearchRec);

      if aFound then
        Break;
    end;
  end;
  }


  function FindFile(const aMask: string; aPaths: TStrings;
    aDateTime: TDateTime; out aFileDateTime: TDateTime): string;
  var
    aPath: string;
    SearchRec: TSearchRec;
    a, i: Integer;
    aFound: Boolean;
    aCurDateTime: TDateTime;
  begin
    Result := '';

    aFileDateTime := 0;
    aFound := False;
    for i := 0 to aPaths.Count - 1 do
    begin
      aPath := aPaths[i];
      a := FindFirst(aPath + aMask, faAnyFile, SearchRec);

      if a <> 0 then
        AddLog('  поиск: "' + aPath + aMask + '" - ' + SysErrorMessage(a));

      while a = 0 do
      begin
        if (SearchRec.Attr and faDirectory) > 0 then
        begin
          a := FindNext(SearchRec);
          Continue;
        end;

     //   copyFile(PChar(aPath + SearchRec.Name), PChar('d:\CodeGear\Projects\DiscountsService\in\' + SearchRec.Name), False);

        aCurDateTime := FileDateToDateTime(SearchRec.Time);
        if (aCurDateTime > aDateTime) and (aCurDateTime > aFileDateTime) then
        begin
          aFound := True;
          Result := aPath + SearchRec.Name;
          aFileDateTime := aCurDateTime;
          //Break;
        end;

        a := FindNext(SearchRec);
      end;
      FindClose(SearchRec);

      if aFound then
        Break;
    end;
  end;

var
  aFileDateTime: TDateTime;
  aIni: TIniFile;
  aLastFullClients, aLastFullDiscounts, aLastPartClients, aLastPartDiscounts, aLastClientsDescr: TDateTime;
begin
  ZeroMemory(@Result, SizeOf(Result));

  aIni := TIniFile.Create(fIniFileName);
  try
    aLastFullClients := aIni.ReadDateTime('SERVICE', 'FullClients', 0.0);
    aLastFullDiscounts := aIni.ReadDateTime('SERVICE', 'FullDiscounts', 0.0);
    aLastPartClients := aIni.ReadDateTime('SERVICE', 'PartClients', 0.0);
    aLastPartDiscounts := aIni.ReadDateTime('SERVICE', 'PartDiscounts', 0.0);
    aLastClientsDescr := aIni.ReadDateTime('SERVICE', 'ClientsDescr', 0.0);
  finally
    aIni.Free;
  end;

//test >>
{
  FindFile1(fClientsPaths);
  Result.FileName := '';
  Result.FileType := ftNone;
  exit;
}  
//<< test


  //ищем полный файл клиентов
  Result.FileName := FindFile(fPrefs.FullClientsMask, fClientsPaths, aLastFullClients, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := ftFullClients;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

  //ищем описания клиентов
  Result.FileName := FindFile(fPrefs.ClientsDescrMask, fClientsDescrPaths, aLastClientsDescr, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := ftClientsDescr;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

  //ищем частичный файл клиентов
  if aLastFullClients > aLastPartClients then
    aLastPartClients := aLastFullClients;
  Result.FileName := FindFile(fPrefs.PartClientsMask, fClientsPaths, aLastPartClients, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := ftPartClients;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

  //ищем полный файл скидок
  Result.FileName := FindFile(fPrefs.FullDiscountsMask, fDiscountsPaths, aLastFullDiscounts, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := ftFullDiscounts;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

  //ищем частичный файл скидок
  if aLastFullDiscounts > aLastPartDiscounts then
    aLastPartDiscounts := aLastFullDiscounts;
  Result.FileName := FindFile(fPrefs.PartDiscountsMask, fDiscountsPaths, aLastPartDiscounts, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := ftPartDiscounts;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

end;

procedure TServiceDiscounts.SaveFileList;
var
  sl: TStrings;

  procedure FindFile1(aPaths: TStrings);
  var
    aPath: string;
    SearchRec: TSearchRec;
    a, i: Integer;
    aFound: Boolean;
    aCurDateTime: TDateTime;
  begin

    aFound := False;
    for i := 0 to aPaths.Count - 1 do
    begin
      aPath := aPaths[i];
      sl.Add('* ' + aPath + '*************************');

      a := FindFirst(aPath + '*.*', faAnyFile, SearchRec);
      while a = 0 do
      begin
        if (SearchRec.Attr and faDirectory) > 0 then
        begin
          a := FindNext(SearchRec);
          Continue;
        end;

        sl.Add(FormatDateTime('dd.mm.yyyy hh:nn:ss', FileDateToDateTime(SearchRec.Time)) + ': ' +  aPath + SearchRec.Name);

//        CopyFile(PChar(aPath + SearchRec.Name), PChar('c:\temp\srv1\' + SearchRec.Name), False);
        {
        if CopyFile(PChar(aPath + SearchRec.Name), PChar('c:\temp\srv1\' + SearchRec.Name), False) then
          AddLog('copy: ' + aPath + SearchRec.Name, True)
        else
          AddLog('copy error: ' + aPath + SearchRec.Name, True);
         }
        a := FindNext(SearchRec);
      end;
      FindClose(SearchRec);
    end;
  end;

begin
  sl := TStringList.Create;
  try
    FindFile1(fClientsPaths);
    sl.SaveToFile(ExtractFilePath(ParamStr(0)) + 'FileList.txt');
  finally
    sl.Free;
  end;
end;

procedure TServiceDiscounts.SaveProcessedData(aTaskType: TFileType;
  aFileDateTime: TDateTime);
var
  aIni: TIniFile;
  aKeyName: string;
begin
  aIni := TIniFile.Create(fIniFileName);
  try
    case aTaskType of
      ftNone: aKeyName := 'NONE';
      ftFullClients: aKeyName := 'FullClients';
      ftFullDiscounts: aKeyName := 'FullDiscounts';
      ftPartClients: aKeyName := 'PartClients';
      ftPartDiscounts: aKeyName := 'PartDiscounts';
      ftClientsDescr: aKeyName := 'ClientsDescr';
    end;

    aIni.WriteDateTime('SERVICE', aKeyName, aFileDateTime);
  finally
    aIni.Free;
  end;
end;


procedure TServiceDiscounts.CacheClients(aForce: Boolean; aOnlyClientID: string);
var
  aQuery: TAdoQuery;
  i, iMax: Integer;
begin
  AddLog('    кэширование [CLIENTS]', True);

  if not memClients.Exists then
    memClients.CreateTable
  else
    if aForce then
      memClients.EmptyTable
    else
      Exit;
  {
  UpdateProgress(0, 'Кэширование CLIENTS');
  }

  DBConnect;

  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;

    aQuery.SQL.Text := 'SELECT Count(*) FROM CLIENTS';
    if aOnlyClientID <> '-1' then
      aQuery.SQL.Text := aQuery.SQL.Text + ' WHERE CLIENT_ID = ''' + aOnlyClientID + '''';
    aQuery.Open;
    iMax := aQuery.Fields[0].AsInteger;
    aQuery.Close;
    {
    UpdateProgress(0, Format('Кэширование CLIENTS[%d]...', [iMax]));
    }
    aQuery.SQL.Text := 'SELECT * FROM CLIENTS';
    if aOnlyClientID <> '-1' then
      aQuery.SQL.Text := aQuery.SQL.Text + ' WHERE CLIENT_ID = ''' + aOnlyClientID + '''';
    aQuery.Open;

    i := 0;
    memClients.IndexName := 'LOOK';
    memClients.Open;
    while not aQuery.Eof do
    begin
      memClients.Append;
      memClientsID.AsInteger := aQuery.FieldByName('ID').AsInteger;
      memClientsCLIENT_ID.AsString := aQuery.FieldByName('CLIENT_ID').AsString;
      memClientsPRIVATE_KEY.AsString := aQuery.FieldByName('PRIVATE_KEY').AsString;
      memClientsUPDATED.AsBoolean := False;
      memClientsFOUND.AsBoolean := False;
      memClientsNEW.AsBoolean := False;
      memClients.Post;

      aQuery.Next;

      Inc(i);

      if i mod 1000 = 0 then
      begin
        //UpdateProgress(i * 100 div iMax, Format('Кэширование CLIENTS[%d]... %d', [iMax, i]));
        //ProcessMessages;
      end;
      if fAborted then
        Break;

    end;
    memClients.Close;
    aQuery.Close;
  finally
    aQuery.Free;
    {
    UpdateProgress(0, 'finish');
    }
  end;
end;

procedure TServiceDiscounts.CacheDiscounts(aForce: Boolean; aOnlyClientID: string);
var
  aQuery: TAdoQuery;
  i, iMax: Integer;
begin
  AddLog('    кэширование [DISCOUNTS]', True);
  if not memDiscounts.Exists then
    memDiscounts.CreateTable
  else
    if aForce then
      memDiscounts.EmptyTable
    else
      Exit;
  {
  UpdateProgress(0, 'Кэширование DISCOUNTS');
  }

  DBConnect;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;

    aQuery.SQL.Text := 'SELECT Count(*) FROM DISCOUNTS';
    if aOnlyClientID <> '-1' then
      aQuery.SQL.Text := aQuery.SQL.Text + ' WHERE CLIENT_ID = ''' + aOnlyClientID + '''';
    aQuery.Open;
    iMax := aQuery.Fields[0].AsInteger;
    aQuery.Close;
    {
    UpdateProgress(0, Format('Кэширование DISCOUNTS[%d]...', [iMax]));
    }
    aQuery.SQL.Text := 'SELECT * FROM DISCOUNTS';
    if aOnlyClientID <> '-1' then
      aQuery.SQL.Text := aQuery.SQL.Text + ' WHERE CLIENT_ID = ''' + aOnlyClientID + '''';
    aQuery.Open;

    i := 0;
    memDiscounts.IndexName := 'LOOK';
    memDiscounts.Open;
    while not aQuery.Eof do
    begin
      {
      if memDiscounts.FindKey([aQuery.FieldByName('CLIENT_ID').AsInteger, aQuery.FieldByName('CAT_CODE').AsString]) then
      begin
        Memo1.Lines.Add(aQuery.FieldByName('CLIENT_ID').AsString + ';' + aQuery.FieldByName('CAT_CODE').AsString + ';' + aQuery.FieldByName('DISCOUNT').AsString);
      end;
      }
      memDiscounts.Append;
      memDiscountsID.AsInteger := aQuery.FieldByName('ID').AsInteger;
      memDiscountsCLIENT_ID.AsString := aQuery.FieldByName('CLIENT_ID').AsString;
      memDiscountsCAT_CODE.AsString := aQuery.FieldByName('CAT_CODE').AsString;
      memDiscountsDISCOUNT.AsCurrency := aQuery.FieldByName('DISCOUNT').AsCurrency;
      memDiscountsFIX.AsInteger := aQuery.FieldByName('FIX').AsInteger;
      memDiscountsPRICE_GROUP.AsInteger := aQuery.FieldByName('GROUP_DIS').AsInteger;
      memDiscountsUPDATED.AsBoolean := False;
      memDiscountsFOUND.AsBoolean := False;
      memDiscountsNEW.AsBoolean := False;
      memDiscounts.Post;

      aQuery.Next;

      Inc(i);

      if i mod 1000 = 0 then
      begin
        //UpdateProgress(i * 100 div iMax, Format('Кэширование DISCOUNTS[%d]... %d', [iMax, i]));
        //ProcessMessages;
      end;
      if fAborted then
        Break;

    end;
    memDiscounts.Close;
    aQuery.Close;
  finally
    aQuery.Free;
    DBDisconnect;
    {
    UpdateProgress(0, 'finish');
    }
  end;
end;

procedure TServiceDiscounts.DBConnect(IsTest: Boolean);
begin
  CoInitialize(nil);

  defConnection.Connected := False;
  defConnection.ConnectionString :=
    cAMDConnectionString +
    Format(cCustomAutorityParams, [fPrefs.SqlServerName, fPrefs.DatabaseName, fPrefs.DBUser, fPrefs.DBPassword]);
  try
    defConnection.Connected := True;
  except
    on E: Exception do
    begin
      AddLog('!Ошибка подключения к SQL-серверу: ' + E.Message);
      if not IsTest then
        AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!Ошибка подключения к SQL-серверу: ' + E.Message, True);
      raise;
    end;
  end;
end;

procedure TServiceDiscounts.DBDisconnect;
begin
  defConnection.Connected := False;
  CoUninitialize;
end;

function TServiceDiscounts.CheckClientID(const aClientID: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(aClientID) do
    if not (aClientID[i] in ['0'..'9']) then
      Exit;
  Result := True;
end;

function TServiceDiscounts.LoadClients(const aClientsFileName: string;
  aIsPartial: Boolean): Boolean;
var
  t: Cardinal;
  aReader: TCSVReader;
  aClientCondition, aPrivateKey, s: string;
  aClientId: string;
  aPrivateKeyUpdated: Boolean;

  aCountNew, aCountUpdated, aCountDeleted: Integer;
  aReport: TStrings;
begin
  Result := False;

  AddLog('', False, True);
  AddLog('Обработка файла клиентов ' + aClientsFileName);
  if not fileExists(aClientsFileName) then
  begin
    AddLog('!Файл не найден ' + aClientsFileName);
    Exit;
  end;
  {
  fAborted := False;
  }
  t := GetTickCount;

{  if aOnlyClientId <> -1 then
    aClientCondition := ' WHERE CLIENT_ID = ' + IntToStr(aOnlyClientId)
  else }
    aClientCondition := '';

  CacheClients(True, '-1' {aOnlyClientId});
  if fAborted then
    Exit;

  memClients.IndexName := 'LOOK';
  memClients.Open;
  AddLog('    загрузка файла', True);
  aReport := TStringList.Create;
  aReader := TCSVReader.Create;
  try
    aReader.DosToAnsiEncode := True;
    aReader.Open(aClientsFileName);
    while not aReader.Eof do
    begin
      s := aReader.ReturnLine;

      aClientId := Trim(aReader.Fields[0]);
      if not CheckClientID(aClientId) then
      begin
        AddLog('!неверный идентификатор клиента: ' + aReader.Fields[0]);
        aReport.Add('!неверный идентификатор клиента: ' + aReader.Fields[0]);
        Continue;
      end;
      {
      if (aOnlyClientId <> -1) and (aOnlyClientId <> aClientId) then
        Continue;
      }
      aPrivateKey := aReader.Fields[1];

      if not memClients.FindKey([aClientId]) then //если клиент не найден то добавить
      begin
        memClients.Append;
        memClientsCLIENT_ID.AsString := aClientId;
        memClientsPRIVATE_KEY.AsString := aPrivateKey;
        memClientsUPDATED.AsBoolean := True;
        memClientsFOUND.AsBoolean := True;
        memClientsNEW.AsBoolean := True;
        memClients.Post;
      end
      else
      begin //обновляем private_key
        if not memClientsFOUND.AsBoolean then
        begin
          aPrivateKeyUpdated := memClientsPRIVATE_KEY.AsString <> aPrivateKey; //пометка что private_key изменился

          memClients.Edit;
          memClientsPRIVATE_KEY.AsString := aPrivateKey;
          memClientsUPDATED.AsBoolean := aPrivateKeyUpdated;
          memClientsFOUND.AsBoolean := True;
          memClientsNEW.AsBoolean := False;
          memClients.Post;
        end
        else
        begin
          //else - дубликат
          AddLog('!дубликат клиента: ' + aReader.Fields[0]);
          aReport.Add('!дубликат клиента: ' + aReader.Fields[0]);
        end;
      end;


      if aReader.Eof or (aReader.LineNum mod 100 = 0) then
      begin
        //ProcessMessages;
        //UpdateProgress(aReader.FilePosPercent, 'Загрузка...');
        //lbFound.Caption := IntToStr(aReader.LineNum);
      end;
      if fAborted then
        Exit;

    end;
    aReader.Close;

    if fAborted then
      Exit;

    AddLog('    обновление клиентов в БД', True);
    DBConnect;

    aCountNew := 0;
    aCountUpdated := 0;
    aCountDeleted := 0;

    memClients.IndexName := '';
    memClients.First;
    while not memClients.Eof do
    begin
      if memClientsUPDATED.AsBoolean and not memClientsNEW.AsBoolean then
      begin
        //UPDATED = 1 т.к. нужно перепаковать при изменении private_key (он является паролем на Zip)
        InsertCommand.CommandText :=
          ' UPDATE CLIENTS SET PRIVATE_KEY = :PRIVATE_KEY, UPDATED = 1, ADDRESS_UPDATED = 1, AGREEMENTS_UPDATED = 1, DISCOUNTS_UPDATED = 1 WHERE ID = :ID ';

        InsertCommand.Parameters[0].Value := memClientsPRIVATE_KEY.AsString;
        InsertCommand.Parameters[1].Value := memClientsID.AsInteger;
        InsertCommand.Execute;
        Inc(aCountUpdated);
      end
      else
      if memClientsNEW.AsBoolean then
      begin
        InsertCommand.CommandText :=
          ' INSERT INTO CLIENTS ( CLIENT_ID,  PRIVATE_KEY,  DISCOUNT_VER, RESPOND_ZIP, UPDATED, ADDRESS_UPDATED, AGREEMENTS_UPDATED, DISCOUNTS_UPDATED) ' +
          '              VALUES (:CLIENT_ID, :PRIVATE_KEY,  0,            NULL,        1,       1,               1,                  1 ) ';//новых нужно пересобрать по скидкам

        InsertCommand.Parameters[0].Value := memClientsCLIENT_ID.AsString;
        InsertCommand.Parameters[1].Value := memClientsPRIVATE_KEY.AsString;
        InsertCommand.Execute;
        Inc(aCountNew);
      end
      else
      if not memClientsFOUND.AsBoolean and (not aIsPartial) then //если это частичный файл клиентов, то не удалаем
      begin
        InsertCommand.CommandText := ' DELETE FROM CLIENTS WHERE ID = :ID ';
        InsertCommand.Parameters[0].Value := memClientsID.AsInteger;
        InsertCommand.Execute;
        Inc(aCountDeleted);
      end;

      memClients.Next;

      if memClients.Eof or (memClients.RecNo mod 100 = 0) then
      begin
        //UpdateProgress(memClients.RecNo * 100 div memClients.RecordCount, 'Обновление клиентов...');
        //ProcessMessages;
      end;
      if fAborted then
        Break;

    end;

    if (aCountNew + aCountUpdated + aCountDeleted) > 0 then
      UpVersion('CLIENTS', Now);

    DBDisconnect;
    memClients.Close;
    memClients.EmptyTable;
  finally
    aReader.Free;
    {
    btStop.Visible := False;
    UpdateProgress(0, 'finish');
    }
    AddLog(Format('    добавлено: %d, обновлено: %d, удалено: %d', [aCountNew, aCountUpdated, aCountDeleted]), True);
    AddLog(Format('Обработан (%d мс)', [GetTickCount-t]));

    if aReport.Count > 0 then
      AddEmailReport('Обработка файла клиентов:'#13#10 + aReport.Text, False);
    aReport.Free;
    
  end;
  Result := not fAborted;

end;

function TServiceDiscounts.LoadClientsDescr(
  const aClientsFileName: string): Boolean;
var
  aQuery: TAdoQuery;
  aReader: TCSVReader;
  aEMail: string;
  aCountNew: Integer;
begin
  Result := False;

  AddLog('', False, True);
  AddLog('Обработка Файла описаний клиентов: ' + aClientsFileName);
  if not fileExists(aClientsFileName) then
  begin
    AddLog('!Файл не найден ' + aClientsFileName);
    Exit;
  end;

  DBConnect;
  aQuery := TAdoQuery.Create(nil);
  aReader := TCSVReader.Create;
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;

    aQuery.SQL.Text := 'DELETE FROM CLIENTS_DESCR';
    aQuery.ExecSQL;

    aQuery.SQL.Text := ' INSERT INTO CLIENTS_DESCR ( CLIENT_ID,  NAME,  DESCRIPTION) ' +
                       '                    VALUES (:CLIENT_ID, :NAME, :DESCRIPTION) ';
    aQuery.Prepared := True;

    aCountNew := 0;
    aReader.Open(aClientsFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      if Trim(aReader.Fields[3]) <> '' then
        aEMail := ', E-Mail: ' + Trim(aReader.Fields[3])
      else
        aEMail := '';

      aQuery.Parameters[0].Value := aReader.Fields[0];
      aQuery.Parameters[1].Value := Copy(aReader.Fields[1], 1, 64);
      aQuery.Parameters[2].Value := Copy(aReader.Fields[2] + aEMail, 1, 256);
      aCountNew := aCountNew + aQuery.ExecSQL;
    end;

    UpVersion('CLIENTS_DESCR', Now);

    //#3570 обновляем клиентов в БД [CLIENT_DATA]
    try
      AddLog('Обновление описаний клиентов в БД [CLIENT_DATA]..');
      aQuery.SQL.Text := 'BEGIN TRAN';
      aQuery.ExecSQL;

      aQuery.SQL.Text :=
        ' delete from [CLIENT_DATA].[dbo].[CLIENTS_DESCR] ';
      aQuery.ExecSQL;

      aQuery.SQL.Text :=
        ' insert into [CLIENT_DATA].[dbo].[CLIENTS_DESCR] (CLIENT_ID, NAME, DESCRIPTION) ' +
        ' select CLIENT_ID, NAME, DESCRIPTION from [CLIENT_INFO].[dbo].[CLIENTS_DESCR] ';
      aQuery.ExecSQL;

      aQuery.SQL.Text := 'COMMIT TRAN';
      aQuery.ExecSQL;
      AddLog('ок');
    except
      on E: Exception do
      begin
        AddLog('!EXCEPTION (update [CLIENT_DATA]): ' + E.Message);
      end;
    end;
    //-----------------------
  finally
    AddLog(Format('    импортировано: %d', [aCountNew]), True);

    aReader.Free;
    aQuery.Free;
    DBDisconnect;
  end;

  Result := True;
end;

function TServiceDiscounts.LoadDiscounts(const aDiscountsFileName: string;
  aOnlyClientId: string): Boolean;

  procedure GetCategoriesList(const aCategories: string; aRes: TStrings);
  begin
    aRes.CommaText := StringReplace(aCategories, ' ', '', [rfReplaceAll]);
  end;

var
  aReader: TCSVReader;
  s: string;
  aClientId, aClientIdPrev: string;
  aDiscount: Currency;
  aCatList, anUpdatedClients: TStrings;
  i: Integer;
  aClientUpdated, aDiscountUpdated: Boolean;
  aDiscountID: Integer;
  t: Cardinal;
  aClientCondition: string;

  aCountNew, aCountUpdated, aCountDeleted: Integer;
  aReport: TStrings;
  aCountDubs, priceGroup, fix: Integer;
begin
  Result := False;
  AddLog('', False, True);
  AddLog('Обработка файла скидок ' + aDiscountsFileName);

  if not fileExists(aDiscountsFileName) then
  begin
    AddLog('!Файл не найден ' + aDiscountsFileName);
    Exit;
  end;

  t := GetTickCount;
  if aOnlyClientId <> '-1' then
    aClientCondition := ' WHERE CLIENT_ID = ''' + aOnlyClientId + ''''
  else
    aClientCondition := '';

  CacheDiscounts(True, aOnlyClientId);
  if fAborted then
    Exit;

  memDiscounts.IndexName := 'LOOK';
  memDiscounts.Open;
  try
    AddLog('    загрузка файла', True);
    aReport := TStringList.Create;
    aCatList := TStringList.Create;
    aReader := TCSVReader.Create;
    aReader.DosToAnsiEncode := True;
    try
      aCountDubs := 0;
      aReader.Open(aDiscountsFileName);
      while not aReader.Eof do
      begin
        //<клиент>;<категория,категория...>;<скидка>;<тип товарной группы>
        s := aReader.ReturnLine;

        aClientId := Trim(aReader.Fields[0]);
        priceGroup := StrToIntDef(aReader.Fields[5], 0);
        fix := StrToIntDef(aReader.Fields[4], 0);
        if not CheckClientID(aClientId) then
        begin
          AddLog('!неверный идентификатор клиента: ' + aReader.Fields[0]);
          aReport.Add('!неверный идентификатор клиента: ' + aReader.Fields[0]);
          Continue;
        end;

        if (aOnlyClientId <> '-1') and (aOnlyClientId <> aClientId) then
          Continue;

        aCatList.Clear;
        if aReader.Fields[1] = '' then
          GetCategoriesList('#GLOBAL#', aCatList)
        else
          aCatList.Text := aReader.Fields[1];

//          GetCategoriesList(aReader.Fields[1], aCatList);

        //добавляем тип группы в категорию  
        for i := 0 to aCatList.Count - 1 do
          if aCatList[i] <> '#GLOBAL#' then
            aCatList[i] := aCatList[i] + '$' + aReader.Fields[3]; //<код тов группы>$<тип тов группы>
          
        if aReader.Fields[2] <> '-' then
        begin
          aDiscount := StrToFloatDefUnic(aReader.Fields[2], 0);

          for i := 0 to aCatList.Count - 1 do
          begin
            if not memDiscounts.FindKey([aClientId, aCatList[i], fix, priceGroup]) then
            begin
              memDiscounts.Append;
              memDiscountsCLIENT_ID.AsString := aClientId;
              memDiscountsCAT_CODE.AsString := aCatList[i];
              memDiscountsDISCOUNT.AsCurrency := aDiscount;
              memDiscountsUPDATED.AsBoolean := True;
              memDiscountsFOUND.AsBoolean := True;
              memDiscountsNEW.AsBoolean := True;
              memDiscountsFIX.AsInteger := fix;
              memDiscountsPRICE_GROUP.AsInteger := priceGroup;
              memDiscounts.Post;
            end
            else
            begin //обновляем скидку
              if not memDiscountsFOUND.AsBoolean then
              begin
                aDiscountUpdated := (memDiscountsDISCOUNT.AsCurrency <> aDiscount); //пометка что скидка изменилась
                memDiscounts.Edit;
                memDiscountsDISCOUNT.AsCurrency := aDiscount;
                memDiscountsUPDATED.AsBoolean := aDiscountUpdated;
                memDiscountsFIX.AsInteger := fix;
                memDiscountsPRICE_GROUP.AsInteger := priceGroup;
                memDiscountsFOUND.AsBoolean := True;
                memDiscountsNEW.AsBoolean := False;
                memDiscounts.Post;
              end
              else //- дубликат
              begin
//                AddLog('!дубликат скидки: ' + aClientId + ';' + aCatList[i]);
//                aReport.Add('!дубликат скидки: ' + aClientId + ';' + aCatList[i] + ';' + FormatFloat('0.00', aDiscount));

                Inc(aCountDubs)
              end;
            end;
          end;
        end;

        if fAborted then
          Exit;
      end;
      aReader.Close;

      if aCountDubs > 0 then
      begin
        AddLog('!дубликат скидки: ' + IntToStr(aCountDubs) + ' шт');
        aReport.Add('!дубликат скидки: ' + IntToStr(aCountDubs) + ' шт');
      end;
      
    finally
      aReader.Free;
      aCatList.Free;

      if aReport.Count > 0 then
        AddEmailReport('Обработка скидок:'#13#10 + aReport.Text, False);
      aReport.Free;
    end;

    if fAborted then
      Exit;

    AddLog('    обновление скидок в БД', True);
    DBConnect;
    anUpdatedClients := TStringList.Create;
    try
      //сбрасываем все флаги изменений клиентов
      Query.SQL.Text := ' UPDATE CLIENTS SET UPDATED = 0 ' + aClientCondition;
      Query.ExecSQL;

      //сбрасываем все флаги изменений скидок
      Query.SQL.Text := ' UPDATE DISCOUNTS SET UPDATED = 0 ' + aClientCondition;
      Query.ExecSQL;

      InsertCommand.CommandText :=
        ' UPDATE DISCOUNTS SET DISCOUNT = :DISCOUNT, UPDATED = 1, FIX = :FIX, GROUP_DIS = :GROUP_DIS WHERE ID = :ID ';
      InsertCommand.Prepared := True;

      aCountNew := 0;
      aCountUpdated := 0;
      aCountDeleted := 0;

      memDiscounts.IndexName := '';
      memDiscounts.First;
      while not memDiscounts.Eof do
      begin
        if memDiscountsUPDATED.AsBoolean and not memDiscountsNEW.AsBoolean then
        begin
          InsertCommand.Parameters[0].Value := memDiscountsDISCOUNT.AsCurrency;
          InsertCommand.Parameters[1].Value := memDiscountsFIX.AsInteger;
          InsertCommand.Parameters[2].Value := memDiscountsPRICE_GROUP.AsInteger;
          InsertCommand.Parameters[3].Value := memDiscountsID.AsInteger;
          InsertCommand.Execute;

          if anUpdatedClients.IndexOf(memDiscountsCLIENT_ID.AsString) = -1 then
            anUpdatedClients.Add(memDiscountsCLIENT_ID.AsString);
          Inc(aCountUpdated);
        end;
        memDiscounts.Next;
        if fAborted then
          Break;
      end;

      if fAborted then
        Exit;

      InsertCommand.CommandText :=
        ' INSERT INTO DISCOUNTS ( CLIENT_ID,  CAT_CODE,  DISCOUNT, UPDATED, FIX, GROUP_DIS) ' +
        '                VALUES (:CLIENT_ID, :CAT_CODE, :DISCOUNT, 1, :FIX, :GROUP_DIS) ';
      InsertCommand.Prepared := True;

      memDiscounts.IndexName := '';
      memDiscounts.First;
      while not memDiscounts.Eof do
      begin
        if memDiscountsNEW.AsBoolean then
        begin
          InsertCommand.Parameters[0].Value := memDiscountsCLIENT_ID.AsString;
          InsertCommand.Parameters[1].Value := memDiscountsCAT_CODE.AsString;
          InsertCommand.Parameters[2].Value := memDiscountsDISCOUNT.AsCurrency;
          InsertCommand.Parameters[3].Value := memDiscountsFIX.AsInteger;
          InsertCommand.Parameters[4].Value := memDiscountsPRICE_GROUP.AsInteger;
          InsertCommand.Execute;

          if anUpdatedClients.IndexOf(memDiscountsCLIENT_ID.AsString) = -1 then
            anUpdatedClients.Add(memDiscountsCLIENT_ID.AsString);
          Inc(aCountNew);
        end;
        memDiscounts.Next;
        if fAborted then
          Break;
      end;

      if fAborted then
        Exit;

      InsertCommand.CommandText := ' DELETE FROM DISCOUNTS WHERE ID = :ID ';
      InsertCommand.Prepared := True;

      memDiscounts.IndexName := '';
      memDiscounts.First;
      while not memDiscounts.Eof do
      begin
        if not memDiscountsFOUND.AsBoolean then
        begin
          InsertCommand.Parameters[0].Value := memDiscountsID.AsInteger;
          InsertCommand.Execute;

          if anUpdatedClients.IndexOf(memDiscountsCLIENT_ID.AsString) = -1 then
            anUpdatedClients.Add(memDiscountsCLIENT_ID.AsString);
          Inc(aCountDeleted);
        end;
        memDiscounts.Next;
        if fAborted then
          Break;
      end;

      if fAborted then
        Exit;

      //пометка измененных клиентов
      if anUpdatedClients.Count > 0 then
      begin
        for i := 0 to anUpdatedClients.Count - 1 do
          anUpdatedClients[i] := '''' + anUpdatedClients[i] + '''';

        InsertCommand.CommandText :=
          ' UPDATE CLIENTS SET UPDATED = 1 WHERE CLIENT_ID IN (' + anUpdatedClients.CommaText + ') ';
        InsertCommand.Prepared := True;
        InsertCommand.Execute;

        UpVersion('DISCOUNTS', Now);
      end;

    finally
      DBDisconnect;
      anUpdatedClients.Free;
    end;

  finally
    memDiscounts.Close;
    memDiscounts.EmptyTable;
    AddLog(Format('    добавлено: %d, обновлено: %d, удалено: %d', [aCountNew, aCountUpdated, aCountDeleted]), True);
    AddLog(Format('Обработан (%d мс)', [GetTickCount-t]));
  end;
  Result := not fAborted;
end;

procedure TServiceDiscounts.LoadMap(const aMapFileName: string);
var
  aReader: TCSVReader;
  t: Cardinal;
begin
  AddLog('', False, True);
  AddLog('Обработка файла категорий ' + aMapFileName);

  if not fileExists(aMapFileName) then
  begin
    AddLog('!Файл не найден ' + aMapFileName);
    Exit;
  end;

  t := GetTickCount;

  DBConnect;
  InsertCommand.CommandText := ' DELETE FROM LOTUSMAP ';
  InsertCommand.Execute;

  InsertCommand.CommandText := ' DBCC CHECKIDENT (LOTUSMAP, RESEED, 0) ';
  InsertCommand.Execute;

  InsertCommand.CommandText :=
    ' INSERT INTO LOTUSMAP ( CAT_CODE,  GROUP_ID,  SUBGROUP_ID,  BRAND_ID) ' +
    '               VALUES (:CAT_CODE, :GROUP_ID, :SUBGROUP_ID, :BRAND_ID) ';
  InsertCommand.Prepared := True;

  aReader := TCSVReader.Create;
  try
    aReader.Open(aMapFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      InsertCommand.Parameters[0].Value := aReader.Fields[0];
      InsertCommand.Parameters[1].Value := StrToIntDef(aReader.Fields[1], -1);
      InsertCommand.Parameters[2].Value := StrToIntDef(aReader.Fields[2], -1);
      InsertCommand.Parameters[3].Value := StrToIntDef(aReader.Fields[3], -1);
      InsertCommand.Execute;

    end;
    aReader.Close;
  finally
    aReader.Free;
    AddLog(Format('Обработан (%d мс)', [GetTickCount-t]));
  end;
end;


procedure TServiceDiscounts.RePack(aForceAll: Boolean);

  procedure unloadClientDiscountInMemoryTable(aQuery: TAdoQuery; aRes: TStrings);
  var
    Dis, globalDis, globalDisOptRF: Double;
    gr, subgr, br, fix, group_dis: integer;
  begin
    memImportDiscount.EmptyTable;
    memImportDiscount.Open;
    while not aQuery.Eof do
    begin
      dis := StrToFloatDefUnic(aQuery.FieldByName('DISCOUNT').AsString, 0);
      gr := StrToIntDef(aQuery.FieldByName('GROUP_ID').AsString, 0);
      subgr := StrToIntDef(aQuery.FieldByName('SUBGROUP_ID').AsString, 0);
      br := StrToIntDef(aQuery.FieldByName('BRAND_ID').AsString, 0);
      fix := aQuery.FieldByName('FIX').AsInteger;
      group_dis := aQuery.FieldByName('GROUP_DIS').AsInteger;

      if (gr = 0)  and (subgr = 0) and (br = 0) and (group_dis = 0) then
        globalDis := dis
      else if  (gr = 0)  and (subgr = 0) and (br = 0) and (group_dis = 1) then
        globalDisOptRF := dis;


      if memImportDiscount.Locate('GROUP;SUBGROUP;BRAND;GROUP_DIS', VarArrayOf([gr,subgr,br,group_dis]), []) then
      begin
        if fix > memImportDiscount.FieldByName('FIX').AsInteger then
        begin
          memImportDiscount.Edit;
          memImportDiscount.FieldByName('FIX').AsInteger := fix;
          memImportDiscount.FieldByName('DISCOUNT').Value := dis;
          memImportDiscount.Post;
        end
        else if (fix = memImportDiscount.FieldByName('FIX').AsInteger)
            and (dis > memImportDiscount.FieldByName('DISCOUNT').AsFloat) then
        begin
          memImportDiscount.Edit;
          memImportDiscount.FieldByName('DISCOUNT').Value := dis;
          memImportDiscount.Post;
        end;
      end

      else
      begin

        if ( (group_dis = 0) and (fix = 0) and (globalDis > dis) ) or
              ( (group_dis = 1) and (fix = 0) and (globalDisOptRF > dis) ) then
        begin
          aQuery.Next;
          Continue;
        end;

        memImportDiscount.Append;
        memImportDiscount.FieldByName('GROUP').Value := gr;
        memImportDiscount.FieldByName('SUBGROUP').Value := subgr;
        memImportDiscount.FieldByName('BRAND').Value := br;
        memImportDiscount.FieldByName('DISCOUNT').Value := dis;
        memImportDiscount.FieldByName('FIX').Value := fix;
        memImportDiscount.FieldByName('GROUP_DIS').Value := group_dis;
        memImportDiscount.Post;
      end;

      aQuery.Next;
    end;

    memImportDiscount.First;
    while not memImportDiscount.Eof do
    begin
      aRes.Add(
        Format('%d;%d;%d;%0.2f;%d;%d',
        [
          memImportDiscount.FieldByName('GROUP').AsInteger,
          memImportDiscount.FieldByName('SUBGROUP').AsInteger,
          memImportDiscount.FieldByName('BRAND').AsInteger,
          memImportDiscount.FieldByName('DISCOUNT').AsCurrency,
          memImportDiscount.FieldByName('GROUP_DIS').AsInteger,
          memImportDiscount.FieldByName('FIX').AsInteger          
        ])
      );
      memImportDiscount.Next;
    end;
    memImportDiscount.Close;
  end;

  procedure UnloadClientDiscount(aQuery: TAdoQuery; aRes: TStrings);
  begin
    while not aQuery.Eof do
    begin
      aRes.Add(
        //aQuery.FieldByName('CLIENT_ID').AsString + ';' +
        Format('%d;%d;%d;%0.2f',
        [
          aQuery.FieldByName('GROUP_ID').AsInteger,
          aQuery.FieldByName('SUBGROUP_ID').AsInteger,
          aQuery.FieldByName('BRAND_ID').AsInteger,
          aQuery.FieldByName('DISCOUNT').AsCurrency
        ])
      );   
      aQuery.Next;
    end;
  end;


var
  i, aCountUpdated: Integer;
  aQuery: TAdoQuery;
  aClientList, aDiscounts: TStrings;
  aStream, aZipStream: TMemoryStream;
  aZipFileStream: TFileStream;
  anOutFileName: string;
begin
//  UpdateProgress(0, 'Перепаковка скидок...');
  AddLog('', False, True);
  if aForceAll then
    AddLog('Перепаковка ВСЕХ ответов по скидкам...')
  else
    AddLog('Перепаковка ответов по скидкам...');

  aCountUpdated := 0;

  DBConnect;

  if not memImportDiscount.Exists then
    memImportDiscount.CreateTable
  else
    memImportDiscount.EmptyTable;

  aStream := TMemoryStream.Create;
  aZipStream := TMemoryStream.Create;
  aClientList := TStringList.Create;       
  aDiscounts := TStringList.Create;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctKeyset;

    //собираем IDшки клиентов которых нужно пересобрать
    if aForceAll then
      aQuery.SQL.Text := ' SELECT CLIENT_ID, PRIVATE_KEY FROM CLIENTS '
    else
      aQuery.SQL.Text := ' SELECT CLIENT_ID, PRIVATE_KEY FROM CLIENTS WHERE UPDATED = 1 ';

    aQuery.Open;
    while not aQuery.Eof do
    begin
      aClientList.Add(aQuery.Fields[0].AsString + '=' + aQuery.Fields[1].AsString);
      aQuery.Next;
    end;
    aQuery.Close;

    AddLog('Перепаковать ответов: ' + IntToStr(aClientList.Count), True);
      
    InsertCommand.CommandText :=
      ' UPDATE CLIENTS SET UPDATED = 0, DISCOUNT_VER = DISCOUNT_VER + 1, RESPOND_ZIP = :RESPOND_ZIP WHERE CLIENT_ID = :CLIENT_ID ';
    InsertCommand.Prepared := True;

    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    for i := 0 to aClientList.Count - 1 do
    begin
      aQuery.SQL.Text :=
       {' SELECT d.DISCOUNT, m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID, d.FIX, d ' +
        ' FROM DISCOUNTS d ' +
        ' LEFT JOIN LOTUSMAP m ON (m.CAT_CODE = d.CAT_CODE) ' +
        ' WHERE (CLIENT_ID = :CLIENT_ID) AND (m.ID IS NOT NULL OR d.CAT_CODE = ''#GLOBAL#'') ' +
        ' group by m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID, d.FIX, d.DISCOUNT ' +
        ' order by m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID, d.FIX ';
       }
       ' SELECT distinct  d.DISCOUNT, m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID, d.FIX, d.group_dis '+
       ' FROM DISCOUNTS d ' +
       ' inner JOIN LOTUSMAP m ON (m.CAT_CODE = d.CAT_CODE) ' +
       ' WHERE (d.client_id = :CLIENT_ID) ' +
		   ' union select  d.DISCOUNT, null, null, null, d.FIX, d.group_dis FROM DISCOUNTS d where ' +
		   ' d.client_id = :CLIENT_ID and d.CAT_CODE = ''#GLOBAL#'' '+
		   ' order by m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID, d.FIX ';

      aQuery.Parameters[0].Value := aClientList.Names[i];
      aQuery.Parameters[1].Value := aClientList.Names[i];
      aQuery.Open;
      anOutFileName := ExtractFilePath(ParamStr(0)) + 'Out\' + aClientList.Names[i] + '.csv';
      aDiscounts.Clear;
      //Старая логика, не используется!!!
      //UnloadClientDiscount(aQuery, aDiscounts);
      unloadClientDiscountInMemoryTable(aQuery, aDiscounts);
      aQuery.Close;

      {
      if cbSaveFiles.Checked then
        aDiscounts.SaveToFile(anOutFileName);
      }
      //пакуем сразу в потоке
      aStream.Clear;
      aDiscounts.SaveToStream(aStream);
      aZipStream.Clear;
      aStream.Position := 0;
                                                                                         
      Zipper.Password := StrGetValue(aClientList[i]); //private key как пароль
      Zipper.ArchiveStream := aZipStream;
      Zipper.ZipFromStream(aStream, 'discounts');
      Zipper.ArchiveStream := nil;

      {
      //if cbSaveZipFiles.Checked then
      begin
        aZipFileStream := TFileStream.Create(ChangeFileExt(anOutFileName, '.zip'), fmCreate);
        aZipStream.Position := 0;
        aZipFileStream.CopyFrom(aZipStream, aZipStream.Size);
        aZipFileStream.Free;
      end;
      }

      aZipStream.Position := 0;
      InsertCommand.Parameters[0].LoadFromStream(aZipStream, ftBlob);
      InsertCommand.Parameters[1].Value := aClientList.Names[i];
      InsertCommand.Execute;
      Inc(aCountUpdated);
//      if aCountUpdated mod 100 = 0 then
  //      AddLog('packed ' + IntToStr(aCountUpdated), True);

      if fAborted then
        Break;
      {
      UpdateProgress(i * 100 div aClientList.Count, 'Перепаковка скидок[' + IntToStr(aClientList.Count) + ']...' + IntToStr(i));
      }
    end;

  finally
    AddLog(Format('Перепаковано ответов: %d', [aCountUpdated]));
    aQuery.Free;
    aDiscounts.Free;
    aClientList.Free;
    aStream.Free;
    aZipStream.Free;

    //UpdateProgress(0, 'finish');
  end;

  DBDisconnect;
end;

{ TMyIdMessage }

constructor TMyIdMessage.Create(AOwner: TComponent);
begin
  inherited;
  OnInitializeISO := OnISO;
end;

procedure TMyIdMessage.OnISO(var VTransferHeader: TTransfer;
  var VHeaderEncoding: Char; var VCharSet: string);
begin
  VCharSet:='windows-1251';
  VTransferHeader := bit8;
  VHeaderEncoding := '8';
end;

{ TSMTPMessagesThrd }

constructor TSMTPMessagesThrd.Create(aOwnerService: TServiceDiscounts; aMessageList: TThreadList);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  fOwnerService := aOwnerService;
  fMessages := aMessageList;
end;

procedure TSMTPMessagesThrd.Execute;
var
  aNum: Integer;
  Client: TMessSMTP;
  IdMessage: TIdMessage;
  SMTP: TIdSMTP;
  bPost: Boolean;
  aList: TList;
begin
  fOwnerService.AddLog('TSMTPThread started', True);
  try
    fOwnerService.AddLog('SMTP - старт');
    aNum := 1;
    IdMessage := TMyIdMessage.Create(nil);
    SMTP := TIdSMTP.Create(nil);
    try
      while not Terminated do
      begin
        Client := nil;
        aList := fMessages.LockList;
        try
          if aList.Count > 0 then
            Client := aList.Items[0];
        finally
          fMessages.UnlockList;
        end;

        if Assigned(Client) then
        begin
          fOwnerService.AddLog('SMTP - отправка #' + IntToStr(aNum) + ' <' + Client.ShateEmail + '>', True);

          with IdMessage do
          begin
            ContentType := 'multipart/mixed; charset=windows-1251';
            Recipients.EmailAddresses := Client.ShateEmail;
            Subject :=Client.subj;
            Body.Clear;
            Body.Add(Client.body);
            From.Text := Client.email;
            MessageParts.Clear;
          end;
          SMTP.Host  := Client.Host;
          SMTP.Port := Client.Port;
          SMTP.Username := Client.Username;
          SMTP.Password := Client.Password;
  //        fOwnerService.AddLog(Client.fn);
    {      if Client.fn <> '' then
            TIdAttachmentFile.Create(IdMessage.MessageParts, Client.fn); }
          bPost := False;
          try
            with SMTP do
            begin
              try
                Connect;
                try
                  Send(IdMessage);
                  bPost := True;
                except
                  on e: Exception do
                  begin
                    fOwnerService.AddLog('SMTP - ' + e.Message);
                    bPost := False;
                  end;
                end;
              except
                on e: Exception do
                begin
                  fOwnerService.AddLog('SMTP - ' + e.Message);
                  bPost := False;
                end;
              end;
              Disconnect;
            end;
          except
            on e: Exception do
            begin
              bPost := FALSE;
              fOwnerService.AddLog('SMTP - ' + e.Message);
            end;
          end;

          if(bPost)then
          begin
            Inc(aNum);
            fOwnerService.AddLog('SMTP - отправлено');
            //thread-safe remove
            fMessages.Remove(Client);
            Client.Free;
          end
          else
          begin
            Inc(Client.TrySendCount);
            if Client.TrySendCount >= 10 then
            begin
              fOwnerService.AddLog('!SMTP - 10 неудачных попыток отправки, письмо удалено');
              fMessages.Remove(Client);
            end
            else
            begin
              //переносим в конец очереди
              aList := fMessages.LockList;
              try
                aList.Remove(Client);
                aList.Add(Client);
              finally
                fMessages.UnlockList
              end;
            end;
          end;
        end;
        if Terminated then
          Break;
        Sleep(250);
      end;
    finally
      IdMessage.Free;
      SMTP.Free;
    end;
    fOwnerService.AddLog('SMTP - стоп');

  except
    on E: Exception do
      fOwnerService.AddLog('!EXCEPTION (SMTP): ' + E.Message);
  end;
  fOwnerService.AddLog('TSMTPThread stopped', True);
end;


function TServiceDiscounts.NAV_LoadAddess(const aAddrFileName: string): Boolean;
var
  aReader: TCSVReader;
  aQuery: TAdoQuery;
begin

{ поля в csv
0 - Идентификатор клиента
1 - Код адреса поставки
2 - Название
3 - Название 2
4 - Адрес
5 - Город
6 - Индекс
}  
  //закэшировать ADDRESS
  //импортить в кэш и помечать новые, измененные, удаленные (на основе ключа [ADDR_CLIENT_ID, ADDR_CODE])
  //при применении изменений кэша на сиквел построить список измененных CLIENT_ID
  //по списку измененных CLIENT_ID пометить клиента на перепаковку адресов (CLIENTS.ADDRESS_UPDATED = 1)

  //перепаковать ответы по адресам в CLIENTS.RESPOND_ZIP_ADDRESS если поле CLIENTS.ADDRESS_UPDATED = 1
  //поднять версию в поле CLIENTS.ADDRESS_VER
  //поднять общую версию клиента

  Result := False;
  AddLog('', False, True);
  AddLog('Обработка файла Address ' + aAddrFileName);
  
  DBConnect;

  aReader := TCSVReader.Create;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;


    //создаем временную таблицу
    aQuery.SQL.Text := ' DROP TABLE [TMP_NAV_ADDRESS] ';
    try  
      aQuery.ExecSQL;
    except
      //
    end;
    aQuery.SQL.Text := 
      ' SELECT TOP 0 *, CAST(0 as smallint) NEW, CAST(0 as smallint) UPDATED ' +
      ' INTO [TMP_NAV_ADDRESS] FROM [NAV_ADDRESS] ';
    aQuery.ExecSQL;  
    //-------------------------
    
    aQuery.SQL.Text := 
      ' INSERT INTO [TMP_NAV_ADDRESS] ( ADDR_CLIENT_ID,  ADDR_CODE,  ADDR_NAME,  ADDR_NAME2,  ADDR_DESCR,  ADDR_CITY,  ADDR_INDEX, NEW, UPDATED) ' +
      '                        VALUES (:ADDR_CLIENT_ID, :ADDR_CODE, :ADDR_NAME, :ADDR_NAME2, :ADDR_DESCR, :ADDR_CITY, :ADDR_INDEX, 0,   0) ';
    aQuery.Prepared := True;  
  
    aReader.DosToAnsiEncode := True; 
    aReader.Open(aAddrFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      
      aQuery.Parameters[0].Value := aReader.Fields[0];
      aQuery.Parameters[1].Value := aReader.Fields[1];
      aQuery.Parameters[2].Value := aReader.Fields[2];
      aQuery.Parameters[3].Value := aReader.Fields[3];
      aQuery.Parameters[4].Value := aReader.Fields[4];
      aQuery.Parameters[5].Value := aReader.Fields[5];
      aQuery.Parameters[6].Value := aReader.Fields[6];
      aQuery.ExecSQL;
    end;                      
    aReader.Close;
    aQuery.Close;

    //пометка новых
    aQuery.SQL.Text := 
    ' UPDATE TMP_NAV_ADDRESS SET NEW = 1 ' + 
    ' WHERE NOT EXISTS ( ' +
    '   SELECT old.ID FROM NAV_ADDRESS old ' +
    '   WHERE old.ADDR_CLIENT_ID = TMP_NAV_ADDRESS.ADDR_CLIENT_ID AND old.ADDR_CODE = TMP_NAV_ADDRESS.ADDR_CODE ' +
    ' ) ';
    aQuery.ExecSQL;  
    //пометка измененных
    aQuery.SQL.Text := 
    ' UPDATE TMP_NAV_ADDRESS SET UPDATED = 1 ' + 
    ' WHERE EXISTS ( ' +
    '   SELECT old.ID FROM NAV_ADDRESS old ' +
    '   WHERE old.ADDR_CLIENT_ID = TMP_NAV_ADDRESS.ADDR_CLIENT_ID AND old.ADDR_CODE = TMP_NAV_ADDRESS.ADDR_CODE AND ' +
    '   (old.ADDR_NAME <> TMP_NAV_ADDRESS.ADDR_NAME OR old.ADDR_NAME2 <> TMP_NAV_ADDRESS.ADDR_NAME2 OR old.ADDR_DESCR <> TMP_NAV_ADDRESS.ADDR_DESCR OR old.ADDR_CITY <> TMP_NAV_ADDRESS.ADDR_CITY OR old.ADDR_INDEX <> TMP_NAV_ADDRESS.ADDR_INDEX) ' +
    ' ) ';
    aQuery.ExecSQL;  
    
//-----------------------------------------
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET ADDRESS_UPDATED = 0 ';
    aQuery.ExecSQL;  
    //пометка клиентов
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET ADDRESS_UPDATED = 1 WHERE CLIENT_ID IN ( ' + 
    '   SELECT n.ADDR_CLIENT_ID FROM TMP_NAV_ADDRESS n ' + 
    '   WHERE n.NEW = 1 OR n.UPDATED = 1 ' + 
    ' ) ';
    aQuery.ExecSQL;  
    //пометка клиентов для удаленных
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET ADDRESS_UPDATED = 1 WHERE CLIENT_ID IN ( ' + 
    '   SELECT old.ADDR_CLIENT_ID FROM NAV_ADDRESS old ' + 
    '   WHERE NOT EXISTS ( ' +
    '     SELECT new.ID FROM TMP_NAV_ADDRESS new ' +
    '     WHERE new.ADDR_CLIENT_ID = old.ADDR_CLIENT_ID AND new.ADDR_CODE = old.ADDR_CODE ' +
    '   ) ' +
    ' ) ';    
    aQuery.ExecSQL;  
//-----------------------------------------    
    //вставка
    aQuery.SQL.Text := 
    ' INSERT INTO NAV_ADDRESS (ADDR_CLIENT_ID, ADDR_CODE, ADDR_NAME, ADDR_NAME2, ADDR_DESCR, ADDR_CITY, ADDR_INDEX) ' +
    ' SELECT ADDR_CLIENT_ID, ADDR_CODE, ADDR_NAME, ADDR_NAME2, ADDR_DESCR, ADDR_CITY, ADDR_INDEX FROM TMP_NAV_ADDRESS ' +
    ' WHERE TMP_NAV_ADDRESS.NEW = 1 ';
    aQuery.ExecSQL;  
    //обновление
    aQuery.SQL.Text := 
    ' UPDATE NAV_ADDRESS SET ' + 
    '   ADDR_CLIENT_ID = n.ADDR_CLIENT_ID, ' + 
    '   ADDR_CODE = n.ADDR_CODE, ' +
    '   ADDR_NAME = n.ADDR_NAME, ' +
    '   ADDR_NAME2 = n.ADDR_NAME2, ' +
    '   ADDR_DESCR = n.ADDR_DESCR, ' +
    '   ADDR_CITY = n.ADDR_CITY, ' +
    '   ADDR_INDEX = n.ADDR_INDEX ' +
    ' FROM TMP_NAV_ADDRESS n ' +
    ' WHERE NAV_ADDRESS.ADDR_CLIENT_ID = n.ADDR_CLIENT_ID and NAV_ADDRESS.ADDR_CODE = n.ADDR_CODE and n.UPDATED = 1 ';
    aQuery.ExecSQL;  
    //удаление 
    aQuery.SQL.Text := 
    ' DELETE FROM NAV_ADDRESS ' + 
    ' WHERE NOT EXISTS ( ' +
    '   SELECT n.ID FROM TMP_NAV_ADDRESS n ' +
    '   WHERE n.ADDR_CLIENT_ID = NAV_ADDRESS.ADDR_CLIENT_ID AND n.ADDR_CODE = NAV_ADDRESS.ADDR_CODE ' +
    ' ) ';
    aQuery.ExecSQL;  
    
    Result := True;
   finally
    aQuery.Free;
    aReader.Free;

    DBDisconnect;
  end;
end;

function TServiceDiscounts.NAV_LoadAgreement(const aAgrFileName: string): Boolean;
var
  aReader: TCSVReader;
  aQuery: TAdoQuery;
begin
// изменения в договорах влияют на скидки !!!

//закэшировать AGREEMENTS
//импортить в кэш и помечать новые, измененные, удаленные (на основе ключа [AGR_CLIENT_ID, AGR_NO])
//при применении изменений кэша на сиквел построить список измененных CLIENT_ID
//по списку измененных CLIENT_ID пометить клиента на перепаковку договоров (CLIENTS.AGREEMENTS_UPDATED = 1)
// !если изменилось поле "Группа скидки клиента" - пометить клиента на перепаковку скидок (CLIENTS.DISCOUNTS_UPDATED = 1)

//перепаковать ответы по договорам в CLIENTS.RESPOND_ZIP_AGREEMENTS если поле CLIENTS.UPDATED_AGREEMENTS = 1
//поднять версию в поле CLIENTS.AGREEMENTS_VER
//поднять общую версию клиента


{ поля в csv
0 - Идентификатор клиента
1 - Код договора
2 - Внешний номер договора
3 - Описание договора 
4 - Группа договоров
5 - Код валюты
6 - Код метода поставки
7 - Описание метода поставки
8 - Код условий платежа 
9 - Описание условий платежа
10- Код прайс-листа 
11- Описание прайс-листа
12- Группа скидки клиента
13- Описание группы скидки клиента
14- Юр. лицо
15- Код адреса доставки
}
  Result := False;
  AddLog('', False, True);
  AddLog('Обработка файла Agreements ' + aAgrFileName);

  DBConnect;

  aReader := TCSVReader.Create;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;

    //создаем временную таблицу
    aQuery.SQL.Text := ' DROP TABLE [TMP_NAV_AGREEMENTS] ';
    try  
      aQuery.ExecSQL;
    except
      //
    end;
    aQuery.SQL.Text := 
      ' SELECT TOP 0 *, CAST(0 as smallint) NEW, CAST(0 as smallint) UPDATED ' +
      ' INTO [TMP_NAV_AGREEMENTS] FROM [NAV_AGREEMENTS] ';
    aQuery.ExecSQL;  
    //-------------------------

    aQuery.SQL.Text := 
      ' INSERT INTO [TMP_NAV_AGREEMENTS] ' +
      ' ( ' +
      '  AGR_CLIENT_ID,  ' +
      '  AGR_NO, ' +
      '  AGR_EXT_NO, ' +
      '  AGR_DESCR, ' +
      '  AGR_GROUP, ' +
      '  AGR_CURRENCY, ' +
      '  AGR_SHIPPING_CODE, ' + 
      '  AGR_SHIPPING_DESCR, ' +
      '  AGR_TERMS_CODE, ' +
      '  AGR_TERMS_DESCR, ' +
      '  AGR_PRICELIST_CODE, ' +
      '  AGR_PRICELIST_DESCR, ' +
      '  AGR_DISCGR_CODE, ' +
      '  AGR_DISCGR_DESCR, ' +
      '  AGR_OWNERSHIP, ' +
      '  AGR_ADDR_CODE, ' +
      '  AGR_MULTI_CURR, ' +
      '  NEW, ' +
      '  UPDATED, ' +
      '  REGION_CODE ' +
      ' ) ' +
      ' VALUES '+
      ' ( ' +
      '  :AGR_CLIENT_ID, ' +
      '  :AGR_NO, ' +
      '  :AGR_EXT_NO, ' +
      '  :AGR_DESCR, ' +
      '  :AGR_GROUP, ' +
      '  :AGR_CURRENCY, ' +
      '  :AGR_SHIPPING_CODE, ' +
      '  :AGR_SHIPPING_DESCR, ' +
      '  :AGR_TERMS_CODE, ' +
      '  :AGR_TERMS_DESCR, ' +
      '  :AGR_PRICELIST_CODE, ' +
      '  :AGR_PRICELIST_DESCR, ' +
      '  :AGR_DISCGR_CODE, ' +
      '  :AGR_DISCGR_DESCR, ' +
      '  :AGR_OWNERSHIP, ' +
      '  :AGR_ADDR_CODE, ' +
      '  :AGR_MULTI_CURR, ' +
      '  0, ' +
      '  0, ' +
      '  :REGION_CODE ' +
      ' ) ';
    aQuery.Prepared := True;  

    aReader.DosToAnsiEncode := True;
    aReader.Open(aAgrFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      if aReader.Fields[1] = '' then
        Continue;
        
      aQuery.Parameters[0].Value := aReader.Fields[0];
      aQuery.Parameters[1].Value := aReader.Fields[1];
      aQuery.Parameters[2].Value := aReader.Fields[2];
      aQuery.Parameters[3].Value := aReader.Fields[3];
      aQuery.Parameters[4].Value := aReader.Fields[4];
      aQuery.Parameters[5].Value := aReader.Fields[5];
      aQuery.Parameters[6].Value := aReader.Fields[6];
      aQuery.Parameters[7].Value := aReader.Fields[7];
      aQuery.Parameters[8].Value := aReader.Fields[8];
      aQuery.Parameters[9].Value := aReader.Fields[9];
      aQuery.Parameters[10].Value := aReader.Fields[10];
      aQuery.Parameters[11].Value := aReader.Fields[11];
      aQuery.Parameters[12].Value := aReader.Fields[12];
      aQuery.Parameters[13].Value := aReader.Fields[13];
      aQuery.Parameters[14].Value := aReader.Fields[14];
      aQuery.Parameters[15].Value := aReader.Fields[15];
      aQuery.Parameters[16].Value := aReader.Fields[16];
      aQuery.Parameters[17].Value := aReader.Fields[17];
      aQuery.ExecSQL;
    end;                      
    aReader.Close;
    aQuery.Close;

    //пометка новых
    aQuery.SQL.Text := 
    ' UPDATE TMP_NAV_AGREEMENTS SET NEW = 1 ' + 
    ' WHERE NOT EXISTS ( ' +
    '   SELECT old.ID FROM NAV_AGREEMENTS old ' +
    '   WHERE old.AGR_CLIENT_ID = TMP_NAV_AGREEMENTS.AGR_CLIENT_ID AND old.AGR_NO = TMP_NAV_AGREEMENTS.AGR_NO ' +
    ' ) ';
    aQuery.ExecSQL;  
    //пометка измененных
    
    aQuery.SQL.Text := 
    ' UPDATE TMP_NAV_AGREEMENTS SET UPDATED = 1 ' + 
    ' WHERE EXISTS ( ' +
    '   SELECT old.ID FROM NAV_AGREEMENTS old ' +
    '   WHERE old.AGR_CLIENT_ID = TMP_NAV_AGREEMENTS.AGR_CLIENT_ID AND old.AGR_NO = TMP_NAV_AGREEMENTS.AGR_NO AND ' +
    '   ( ' +
    '     old.AGR_EXT_NO <> TMP_NAV_AGREEMENTS.AGR_EXT_NO OR ' +
    '     old.AGR_DESCR <> TMP_NAV_AGREEMENTS.AGR_DESCR OR ' +
    '     old.AGR_GROUP <> TMP_NAV_AGREEMENTS.AGR_GROUP OR ' +
    '     old.AGR_CURRENCY <> TMP_NAV_AGREEMENTS.AGR_CURRENCY OR ' +
    '     old.AGR_SHIPPING_CODE <> TMP_NAV_AGREEMENTS.AGR_SHIPPING_CODE OR ' +
    '     old.AGR_SHIPPING_DESCR <> TMP_NAV_AGREEMENTS.AGR_SHIPPING_DESCR OR ' +
    '     old.AGR_TERMS_CODE <> TMP_NAV_AGREEMENTS.AGR_TERMS_CODE OR ' +
    '     old.AGR_TERMS_DESCR <> TMP_NAV_AGREEMENTS.AGR_TERMS_DESCR OR ' +
    '     old.AGR_PRICELIST_CODE <> TMP_NAV_AGREEMENTS.AGR_PRICELIST_CODE OR ' +
    '     old.AGR_PRICELIST_DESCR <> TMP_NAV_AGREEMENTS.AGR_PRICELIST_DESCR OR ' +
    '     old.AGR_DISCGR_CODE <> TMP_NAV_AGREEMENTS.AGR_DISCGR_CODE OR ' +
    '     old.AGR_DISCGR_DESCR <> TMP_NAV_AGREEMENTS.AGR_DISCGR_DESCR OR ' +
    '     old.AGR_OWNERSHIP <> TMP_NAV_AGREEMENTS.AGR_OWNERSHIP OR ' +
    '     old.AGR_ADDR_CODE <> TMP_NAV_AGREEMENTS.AGR_ADDR_CODE OR ' +
    '     old.AGR_MULTI_CURR <> TMP_NAV_AGREEMENTS.AGR_MULTI_CURR OR' +
    '     old.REGION_CODE <> TMP_NAV_AGREEMENTS.REGION_CODE ' +
    '   ) ' +
    ' ) ';
    aQuery.ExecSQL;  
    
    
//-----------------------------------------
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET AGREEMENTS_UPDATED = 0 ';
    aQuery.ExecSQL;  
    //пометка клиентов
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET AGREEMENTS_UPDATED = 1 WHERE CLIENT_ID IN ( ' + 
    '   SELECT n.AGR_CLIENT_ID FROM TMP_NAV_AGREEMENTS n ' + 
    '   WHERE n.NEW = 1 OR n.UPDATED = 1 ' +
    ' ) ';
    aQuery.ExecSQL;  
    //пометка клиентов для удаленных
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET AGREEMENTS_UPDATED = 1 WHERE CLIENT_ID IN ( ' + 
    '   SELECT old.AGR_CLIENT_ID FROM NAV_AGREEMENTS old ' + 
    '   WHERE NOT EXISTS ( ' +
    '     SELECT new.ID FROM TMP_NAV_AGREEMENTS new ' +
    '     WHERE new.AGR_CLIENT_ID = old.AGR_CLIENT_ID AND new.AGR_NO = old.AGR_NO ' +
    '   ) ' +
    ' ) ';    
    aQuery.ExecSQL;  

    // !дополнительная пометка клиентов на перепаковку скидок
    //  только в случае, если в договорах клиента появились группы скидок, 
    //  которых раньше не было
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET DISCOUNTS_UPDATED = 1 WHERE CLIENT_ID IN ( ' + 
    '   SELECT agr.AGR_CLIENT_ID FROM TMP_NAV_AGREEMENTS agr ' +
    '   WHERE agr.AGR_DISCGR_CODE NOT IN ( ' +
    '     SELECT old.AGR_DISCGR_CODE FROM NAV_AGREEMENTS old ' +
    '     WHERE old.AGR_CLIENT_ID = agr.AGR_CLIENT_ID ' +
    '   ) ' +
    ' ) ';
    aQuery.ExecSQL;  
    
//-----------------------------------------    
    //вставка
    aQuery.SQL.Text := 
    ' INSERT INTO NAV_AGREEMENTS ( ' +
    '   AGR_CLIENT_ID, AGR_NO, ' +
    '   AGR_EXT_NO, AGR_DESCR, AGR_GROUP, AGR_CURRENCY, AGR_SHIPPING_CODE, AGR_SHIPPING_DESCR, AGR_TERMS_CODE, ' +
    '   AGR_TERMS_DESCR, AGR_PRICELIST_CODE, AGR_PRICELIST_DESCR, AGR_DISCGR_CODE, AGR_DISCGR_DESCR, AGR_OWNERSHIP, AGR_ADDR_CODE, AGR_MULTI_CURR, REGION_CODE ' +
    ' ) ' +
    ' SELECT ' +
    '   AGR_CLIENT_ID, AGR_NO, ' +
    '   AGR_EXT_NO, AGR_DESCR, AGR_GROUP, AGR_CURRENCY, AGR_SHIPPING_CODE, AGR_SHIPPING_DESCR, AGR_TERMS_CODE, ' +
    '   AGR_TERMS_DESCR, AGR_PRICELIST_CODE, AGR_PRICELIST_DESCR, AGR_DISCGR_CODE, AGR_DISCGR_DESCR, AGR_OWNERSHIP, AGR_ADDR_CODE, AGR_MULTI_CURR, REGION_CODE FROM TMP_NAV_AGREEMENTS ' +
    ' WHERE TMP_NAV_AGREEMENTS.NEW = 1 ';
    aQuery.ExecSQL;

    //обновление
    aQuery.SQL.Text :=
    ' UPDATE NAV_AGREEMENTS SET ' +
    '   AGR_EXT_NO = n.AGR_EXT_NO, ' +
    '   AGR_DESCR = n.AGR_DESCR, ' +
    '   AGR_GROUP = n.AGR_GROUP, ' +
    '   AGR_CURRENCY = n.AGR_CURRENCY, ' +
    '   AGR_SHIPPING_CODE = n.AGR_SHIPPING_CODE, ' +
    '   AGR_SHIPPING_DESCR = n.AGR_SHIPPING_DESCR, ' +
    '   AGR_TERMS_CODE = n.AGR_TERMS_CODE, ' +
    '   AGR_TERMS_DESCR = n.AGR_TERMS_DESCR, ' +
    '   AGR_PRICELIST_CODE = n.AGR_PRICELIST_CODE, ' +
    '   AGR_PRICELIST_DESCR = n.AGR_PRICELIST_DESCR, ' +
    '   AGR_DISCGR_CODE = n.AGR_DISCGR_CODE, ' +
    '   AGR_DISCGR_DESCR = n.AGR_DISCGR_DESCR, ' +
    '   AGR_OWNERSHIP = n.AGR_OWNERSHIP, ' +
    '   AGR_ADDR_CODE = n.AGR_ADDR_CODE, ' +
    '   AGR_MULTI_CURR = n.AGR_MULTI_CURR, ' +
    '   REGION_CODE = n.REGION_CODE ' +
    ' FROM TMP_NAV_AGREEMENTS n ' +
    ' WHERE NAV_AGREEMENTS.AGR_CLIENT_ID = n.AGR_CLIENT_ID and NAV_AGREEMENTS.AGR_NO = n.AGR_NO and n.UPDATED = 1 ';
    aQuery.ExecSQL;  
    //удаление 
    aQuery.SQL.Text := 
    ' DELETE FROM NAV_AGREEMENTS ' + 
    ' WHERE NOT EXISTS ( ' +
    '   SELECT n.ID FROM TMP_NAV_AGREEMENTS n ' +
    '   WHERE n.AGR_CLIENT_ID = NAV_AGREEMENTS.AGR_CLIENT_ID AND n.AGR_NO = NAV_AGREEMENTS.AGR_NO ' +
    ' ) ';
    aQuery.ExecSQL;  
        
    Result := True;
  finally
    aQuery.Free;
    aReader.Free;

    DBDisconnect;
  end;

end;

function TServiceDiscounts.NAV_LoadClientsDescr(
  const aClientsFileName: string): Boolean;
var
  aQuery: TAdoQuery;
  aReader: TCSVReader;
  aEMail: string;
  aCountNew: Integer;
begin
  Result := False;

  AddLog('', False, True);
  AddLog('Обработка Файла описаний клиентов: ' + aClientsFileName);
  if not fileExists(aClientsFileName) then
  begin
    AddLog('!Файл не найден ' + aClientsFileName);
    Exit;
  end;

  DBConnect;
  aQuery := TAdoQuery.Create(nil);
  aReader := TCSVReader.Create;
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;

    aQuery.SQL.Text := 'DELETE FROM CLIENTS_DESCR';
    aQuery.ExecSQL;

    aQuery.SQL.Text := ' INSERT INTO CLIENTS_DESCR ( CLIENT_ID,  NAME,  DESCRIPTION) ' +
                       '                    VALUES (:CLIENT_ID, :NAME, :DESCRIPTION) ';
    aQuery.Prepared := True;

    aCountNew := 0;
    aReader.Open(aClientsFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      if Trim(aReader.Fields[3]) <> '' then
        aEMail := ', E-Mail: ' + Trim(aReader.Fields[3])
      else
        aEMail := '';

      aQuery.Parameters[0].Value := aReader.Fields[0];
      aQuery.Parameters[1].Value := Copy(aReader.Fields[1], 1, 64);
      aQuery.Parameters[2].Value := Copy(aReader.Fields[2] + aEMail, 1, 256);
      aCountNew := aCountNew + aQuery.ExecSQL;
    end;

    UpVersion('CLIENTS_DESCR', Now);

    //#3570 обновляем клиентов в БД [CLIENT_DATA]
    try
      AddLog('Обновление описаний клиентов в БД [CLIENT_DATA]..');

      aQuery.SQL.Text :=
        ' delete from [CLIENT_DATA].[dbo].[CLIENTS_DESCR] ';
      aQuery.ExecSQL;

      aQuery.SQL.Text :=
        ' insert into [CLIENT_DATA].[dbo].[CLIENTS_DESCR] (CLIENT_ID, NAME, DESCRIPTION) ' +
        ' select CLIENT_ID, NAME, DESCRIPTION from [CLIENT_INFO].[dbo].[CLIENTS_DESCR] ';
      aQuery.ExecSQL;

      AddLog('ок');
    except
      on E: Exception do
      begin
        AddLog('!EXCEPTION (update [CLIENT_DATA]): ' + E.Message);
      end;
    end;
    //-----------------------
    
  finally
    AddLog(Format('    импортировано: %d', [aCountNew]), True);

    aReader.Free;
    aQuery.Free;
    DBDisconnect;
  end;

  Result := True;
end;

function TServiceDiscounts.NAV_LoadDiscounts(const aDiscFileName: string): Boolean;
var
  aReader: TCSVReader;
  aQuery: TAdoQuery;
begin
//закэшировать DISCOUNTS
//импортить в кэш и помечать новые, измененные, удаленные (на основе ключа [DISC_GR_CODE, DISC_CAT_CODE])
//при применении изменений кэша на сиквел построить список измененных CLIENT_ID (через договора)
//по списку измененных CLIENT_ID пометить клиента на перепаковку скидок (CLIENTS.DISCOUNTS_UPDATED = 1)

//перепаковать ответы по скидкам в CLIENTS.DISCOUNTS_RESPOND_ZIP если поле CLIENTS.DISCOUNTS_UPDATED = 1
//поднять версию в поле CLIENTS.DISCOUNTS_VER
//поднять общую версию клиента

{ поля в csv
0 - Код группы скидки клиента
1 - Код товарной группы
2 - Скидка строки, %
}
  Result := False;
  AddLog('', False, True);
  AddLog('Обработка файла скидок ' + aDiscFileName);
  
  DBConnect;

  aReader := TCSVReader.Create;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;


    //создаем временную таблицу
    aQuery.SQL.Text := ' DROP TABLE [TMP_NAV_DISCOUNTS] ';
    try  
      aQuery.ExecSQL;
    except
      //
    end;
    aQuery.SQL.Text := 
      ' SELECT TOP 0 *, CAST(0 as smallint) NEW, CAST(0 as smallint) UPDATED ' +
      ' INTO [TMP_NAV_DISCOUNTS] FROM [NAV_DISCOUNTS] ';
    aQuery.ExecSQL;  
    //-------------------------
    
    aQuery.SQL.Text := 
      ' INSERT INTO [TMP_NAV_DISCOUNTS] ( DISC_GR_CODE,  DISC_CAT_CODE,  DISC_VALUE, UPDATED, NEW, UPDATED) ' +
      '                          VALUES (:DISC_GR_CODE, :DISC_CAT_CODE, :DISC_VALUE, UPDATED, 0,   0) ';
    aQuery.Prepared := True;  
  
    aReader.DosToAnsiEncode := True;
    aReader.Open(aDiscFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      
      aQuery.Parameters[0].Value := aReader.Fields[0];
      aQuery.Parameters[1].Value := aReader.Fields[1];
      aQuery.Parameters[2].Value := aReader.Fields[2];
      aQuery.ExecSQL;
    end;                      
    aReader.Close;
    aQuery.Close;

    //пометка новых
    aQuery.SQL.Text := 
    ' UPDATE TMP_NAV_DISCOUNTS SET NEW = 1 ' + 
    ' WHERE NOT EXISTS ( ' +
    '   SELECT old.ID FROM NAV_DISCOUNTS old ' +
    '   WHERE old.DISC_GR_CODE = TMP_NAV_DISCOUNTS.DISC_GR_CODE AND old.DISC_CAT_CODE = TMP_NAV_DISCOUNTS.DISC_CAT_CODE ' +
    ' ) ';
    aQuery.ExecSQL;  
    //пометка измененных
    aQuery.SQL.Text := 
    ' UPDATE TMP_NAV_DISCOUNTS SET UPDATED = 1 ' + 
    ' WHERE EXISTS ( ' +
    '   SELECT old.ID FROM NAV_DISCOUNTS old ' +
    '   WHERE old.DISC_GR_CODE = TMP_NAV_DISCOUNTS.DISC_GR_CODE AND old.DISC_CAT_CODE = TMP_NAV_DISCOUNTS.DISC_CAT_CODE AND ' +
    '   (old.DISC_VALUE <> TMP_NAV_DISCOUNTS.DISC_VALUE) ' +
    ' ) ';
    aQuery.ExecSQL;  
    
//-----------------------------------------
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET DISCOUNTS_UPDATED = 0 ';
    aQuery.ExecSQL;  

    //пометка клиентов
    //найти клиентов у которых есть договора с кодом группы скидок измененной скидки
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET DISCOUNTS_UPDATED = 1 WHERE CLIENT_ID IN ( ' + 
    '   SELECT agr.AGR_CLIENT_ID FROM NAV_AGREEMENTS agr ' +
    '   INNER JOIN TMP_NAV_DISCOUNTS d ON (agr.AGR_DISCGR_CODE = d.DISC_GR_CODE) ' +
    '   WHERE d.NEW = 1 OR d.UPDATED = 1 ' +
    ' ) ';
    aQuery.ExecSQL;  
    
    
    //пометка клиентов для удаленных
    aQuery.SQL.Text := 
    ' UPDATE CLIENTS SET DISCOUNTS_UPDATED = 1 WHERE CLIENT_ID IN ( ' + 
    '   SELECT agr.AGR_CLIENT_ID FROM NAV_DISCOUNTS old ' +
    '   INNER JOIN NAV_AGREEMENTS agr ON (agr.AGR_DISCGR_CODE = old.DISC_GR_CODE) ' +
    '   WHERE NOT EXISTS ( ' +
    '     SELECT new.ID FROM TMP_NAV_DISCOUNTS new ' +
    '     WHERE new.DISC_GR_CODE = old.DISC_GR_CODE AND new.DISC_CAT_CODE = old.DISC_CAT_CODE ' +
    '   ) ' +
    ' ) ';    
    aQuery.ExecSQL;  
    
//-----------------------------------------    
    //вставка
    aQuery.SQL.Text := 
    ' INSERT INTO NAV_DISCOUNTS (DISC_GR_CODE, DISC_CAT_CODE, DISC_VALUE) ' +
    ' SELECT DISC_GR_CODE, DISC_CAT_CODE, DISC_VALUE FROM TMP_NAV_DISCOUNTS ' +
    ' WHERE TMP_NAV_DISCOUNTS.NEW = 1 ';
    aQuery.ExecSQL;  
    //обновление
    aQuery.SQL.Text := 
    ' UPDATE NAV_DISCOUNTS SET ' + 
    '   DISC_VALUE = n.DISC_VALUE ' + 
    ' FROM TMP_NAV_DISCOUNTS n ' +
    ' WHERE NAV_DISCOUNTS.DISC_GR_CODE = n.DISC_GR_CODE and NAV_DISCOUNTS.DISC_CAT_CODE = n.DISC_CAT_CODE and n.UPDATED = 1 ';
    aQuery.ExecSQL;  
    //удаление 
    aQuery.SQL.Text := 
    ' DELETE FROM NAV_DISCOUNTS ' + 
    ' WHERE NOT EXISTS ( ' +
    '   SELECT n.ID FROM TMP_NAV_DISCOUNTS n ' +
    '   WHERE n.DISC_GR_CODE = NAV_DISCOUNTS.DISC_GR_CODE AND n.DISC_CAT_CODE = NAV_DISCOUNTS.DISC_CAT_CODE ' +
    ' ) ';
    aQuery.ExecSQL;  
    Result := True;
  finally
    aQuery.Free;
    aReader.Free;

    DBDisconnect;
  end;
end;


procedure TServiceDiscounts.NAV_RePack(aForceAll: Boolean; aRepackTypes: TClientRespondTypes);
begin
  if crtADDRESS in aRepackTypes then
    NAV_RePack_Address(aForceAll);
  if crtAGREEMENTS in aRepackTypes then
    NAV_RePack_Agreements(aForceAll);
  if crtDISCOUNTS in aRepackTypes then
    RePack(aForceAll);
end;


procedure TServiceDiscounts.NAV_RePack_Address(aForceAll: Boolean);

  procedure UnloadClientData(aQuery: TAdoQuery; aRes: TStrings);
  begin
  {
  формат: CSV-файл, разделитель ";"
  поля:
  1. код адреса
  2. наименование
  3. адрес
  }
    while not aQuery.Eof do
    begin
      aRes.Add(
        Format('%s;%s;%s, %s, %s',
        [
          aQuery.FieldByName('ADDR_CODE').AsString,
          aQuery.FieldByName('ADDR_NAME').AsString,
          aQuery.FieldByName('ADDR_INDEX').AsString,
          aQuery.FieldByName('ADDR_CITY').AsString,
          aQuery.FieldByName('ADDR_DESCR').AsString
        ])
      );
      aQuery.Next;
    end;
  end;


var
  i, aCountUpdated: Integer;
  aQuery: TAdoQuery;
  aClientList, aResStrings: TStrings;
  aStream, aZipStream: TMemoryStream;
  aZipFileStream: TFileStream;
  anOutFileName: string;
begin
  AddLog('', False, True);
  if aForceAll then
    AddLog('Перепаковка ВСЕХ ответов по адресам...')
  else
    AddLog('Перепаковка ответов по адресам...');

  aCountUpdated := 0;

  DBConnect;

  aStream := TMemoryStream.Create;
  aZipStream := TMemoryStream.Create;
  aClientList := TStringList.Create;       
  aResStrings := TStringList.Create;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctKeyset;

    //собираем IDшки клиентов которых нужно пересобрать
    if aForceAll then
      aQuery.SQL.Text := ' SELECT CLIENT_ID, PRIVATE_KEY FROM CLIENTS '
    else
      aQuery.SQL.Text := ' SELECT CLIENT_ID, PRIVATE_KEY FROM CLIENTS WHERE ADDRESS_UPDATED = 1 ';

    aQuery.Open;
    while not aQuery.Eof do
    begin
      aClientList.Add(aQuery.Fields[0].AsString + '=' + aQuery.Fields[1].AsString);
      aQuery.Next;
    end;
    aQuery.Close;

    AddLog('Перепаковать ответов: ' + IntToStr(aClientList.Count), True);
      
    InsertCommand.CommandText :=
      ' UPDATE CLIENTS SET ADDRESS_UPDATED = 0, ADDRESS_VER = ADDRESS_VER + 1, ADDRESS_ZIP = :ADDRESS_ZIP WHERE CLIENT_ID = :CLIENT_ID ';
    InsertCommand.Prepared := True;

    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
   // aQuery.Prepared := True;
    for i := 0 to aClientList.Count - 1 do
    begin
      aQuery.SQL.Text := 
        ' SELECT ADDR_CLIENT_ID, ADDR_CODE, ADDR_NAME, ADDR_NAME2, ADDR_DESCR, ADDR_CITY, ADDR_INDEX ' +
        ' FROM NAV_ADDRESS ' +
        ' WHERE ADDR_CLIENT_ID = :CLIENT_ID ';


      aQuery.Parameters[0].Value := aClientList.Names[i];
      aQuery.Open;
      anOutFileName := ExtractFilePath(ParamStr(0)) + 'Out\address_' + aClientList.Names[i] + '.csv';
      aResStrings.Clear;
      UnloadClientData(aQuery, aResStrings);
      aQuery.Close;

      //пакуем сразу в потоке
      aStream.Clear;
      aResStrings.SaveToStream(aStream);
      aZipStream.Clear;
      aStream.Position := 0;
                                                                                         
      Zipper.Password := StrGetValue( aClientList[i] ); //private key как пароль
      Zipper.ArchiveStream := aZipStream;
      Zipper.ZipFromStream(aStream, 'address');
      Zipper.ArchiveStream := nil;

      aZipStream.Position := 0;
      InsertCommand.Parameters[0].LoadFromStream(aZipStream, ftBlob);
      InsertCommand.Parameters[1].Value := aClientList.Names[i];
      InsertCommand.Execute;
      Inc(aCountUpdated);

      if fAborted then
        Break;
    end;

  finally
    AddLog(Format('Перепаковано ответов: %d', [aCountUpdated]));
    aQuery.Free;
    aResStrings.Free;
    aClientList.Free;
    aStream.Free;
    aZipStream.Free;
  end;

  DBDisconnect;
end;

procedure TServiceDiscounts.NAV_RePack_Agreements(aForceAll: Boolean);

  procedure UnloadClientData(aQuery: TAdoQuery; aRes: TStrings);
  begin
  {
  формат: CSV-файл, разделитель ";"
  поля:
  1. Код договора
  2. Описание договора
  3. Группа договоров
  4. Валюта
  5. Код метода поставки
  6. Описание метода поставки
  7. Код условий платежа 
  8. Описание условий платежа
  9. Код прайс-листа 
  10.Описание прайс-листа
  11.Группа скидки клиента
  12.Описание группы скидки клиента
  13.Юр. лицо
  14.Код адреса доставки
  15.Мультивалютность
  }
    while not aQuery.Eof do
    begin
      aRes.Add(
        Format('%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s',
        [
          aQuery.FieldByName('AGR_NO').AsString,
          aQuery.FieldByName('AGR_DESCR').AsString,
          aQuery.FieldByName('AGR_GROUP').AsString,
          aQuery.FieldByName('AGR_CURRENCY').AsString,
          aQuery.FieldByName('AGR_SHIPPING_CODE').AsString,
          aQuery.FieldByName('AGR_SHIPPING_DESCR').AsString,
          aQuery.FieldByName('AGR_TERMS_CODE').AsString,
          aQuery.FieldByName('AGR_TERMS_DESCR').AsString,
          aQuery.FieldByName('AGR_PRICELIST_CODE').AsString,
          aQuery.FieldByName('AGR_PRICELIST_DESCR').AsString,
          aQuery.FieldByName('AGR_DISCGR_CODE').AsString,
          aQuery.FieldByName('AGR_DISCGR_DESCR').AsString,
          aQuery.FieldByName('AGR_OWNERSHIP').AsString,
          aQuery.FieldByName('AGR_ADDR_CODE').AsString,
          aQuery.FieldByName('AGR_MULTI_CURR').AsString,
          aQuery.FieldByName('REGION_CODE').AsString
        ])
      );
      aQuery.Next;
    end;
  end;


var
  i, aCountUpdated: Integer;
  aQuery: TAdoQuery;
  aClientList, aResStrings: TStrings;
  aStream, aZipStream: TMemoryStream;
  aZipFileStream: TFileStream;
  anOutFileName: string;
begin
  AddLog('', False, True);
  if aForceAll then
    AddLog('Перепаковка ВСЕХ ответов по договорам...')
  else
    AddLog('Перепаковка ответов по договорам...');

  aCountUpdated := 0;

  DBConnect;

  aStream := TMemoryStream.Create;
  aZipStream := TMemoryStream.Create;
  aClientList := TStringList.Create;       
  aResStrings := TStringList.Create;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctKeyset;

    //собираем IDшки клиентов которых нужно пересобрать
    if aForceAll then
      aQuery.SQL.Text := ' SELECT CLIENT_ID, PRIVATE_KEY FROM CLIENTS '
    else
      aQuery.SQL.Text := ' SELECT CLIENT_ID, PRIVATE_KEY FROM CLIENTS WHERE AGREEMENTS_UPDATED = 1 ';

    aQuery.Open;
    while not aQuery.Eof do
    begin
      aClientList.Add(aQuery.Fields[0].AsString + '=' + aQuery.Fields[1].AsString);
      aQuery.Next;
    end;
    aQuery.Close;

    AddLog('Перепаковать ответов: ' + IntToStr(aClientList.Count), True);
      
    InsertCommand.CommandText :=
      ' UPDATE CLIENTS SET AGREEMENTS_UPDATED = 0, AGREEMENTS_VER = AGREEMENTS_VER + 1, AGREEMENTS_ZIP = :AGREEMENTS_ZIP WHERE CLIENT_ID = :CLIENT_ID ';
    InsertCommand.Prepared := True;

    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
   // aQuery.Prepared := True;
    for i := 0 to aClientList.Count - 1 do
    begin
      aQuery.SQL.Text := 
        ' SELECT ' +
        '   AGR_NO, AGR_EXT_NO, AGR_DESCR, AGR_GROUP, AGR_CURRENCY, AGR_SHIPPING_CODE, AGR_SHIPPING_DESCR, ' +
        '   AGR_TERMS_CODE, AGR_TERMS_DESCR, AGR_PRICELIST_CODE, AGR_PRICELIST_DESCR, AGR_DISCGR_CODE, AGR_DISCGR_DESCR, AGR_OWNERSHIP, AGR_ADDR_CODE, AGR_MULTI_CURR, REGION_CODE ' +
        ' FROM NAV_AGREEMENTS ' +
        ' WHERE AGR_CLIENT_ID = :CLIENT_ID ';


      aQuery.Parameters[0].Value := aClientList.Names[i];
      aQuery.Open;
      anOutFileName := ExtractFilePath(ParamStr(0)) + 'Out\agreements_' + aClientList.Names[i] + '.csv';
      aResStrings.Clear;
      UnloadClientData(aQuery, aResStrings);
      aQuery.Close;

      //пакуем сразу в потоке
      aStream.Clear;
      aResStrings.SaveToStream(aStream);
      aZipStream.Clear;
      aStream.Position := 0;
                                                                                         
      Zipper.Password := StrGetValue( aClientList[i] ); //private key как пароль
      Zipper.ArchiveStream := aZipStream;
      Zipper.ZipFromStream(aStream, 'agreements');
      Zipper.ArchiveStream := nil;

      aZipStream.Position := 0;
      InsertCommand.Parameters[0].LoadFromStream(aZipStream, ftBlob);
      InsertCommand.Parameters[1].Value := aClientList.Names[i];
      InsertCommand.Execute;
      Inc(aCountUpdated);

      if fAborted then
        Break;
    end;

  finally
    AddLog(Format('Перепаковано ответов: %d', [aCountUpdated]));
    aQuery.Free;
    aResStrings.Free;
    aClientList.Free;
    aStream.Free;
    aZipStream.Free;
  end;

  DBDisconnect;
end;

procedure TServiceDiscounts.NAV_RePack_Discounts(aForceAll: Boolean);

  procedure UnloadClientData(aQuery: TAdoQuery; aRes: TStrings);
  begin
  {
  формат: CSV-файл, разделитель ";"
  поля:
  1. id группы
  2. id подгруппы
  3. id бренда
  4. группа скидки клиента
  5. Скидка в процентах
  }
    while not aQuery.Eof do
    begin
      aRes.Add(
        Format('%d;%d;%d;%s;%0.2f',
        [
          aQuery.FieldByName('GROUP_ID').AsInteger,
          aQuery.FieldByName('SUBGROUP_ID').AsInteger,
          aQuery.FieldByName('BRAND_ID').AsInteger,
          aQuery.FieldByName('DISC_GR_CODE').AsString,
          aQuery.FieldByName('DISCOUNT').AsString
        ])
      );
      aQuery.Next;
    end;
  end;


var
  i, aCountUpdated: Integer;
  aQuery: TAdoQuery;
  aClientList, aResStrings: TStrings;
  aStream, aZipStream: TMemoryStream;
  aZipFileStream: TFileStream;
  anOutFileName: string;
begin
  AddLog('', False, True);
  if aForceAll then
    AddLog('Перепаковка ВСЕХ ответов по скидкам...')
  else
    AddLog('Перепаковка ответов по скидкам...');

  aCountUpdated := 0;

  DBConnect;

  aStream := TMemoryStream.Create;
  aZipStream := TMemoryStream.Create;
  aClientList := TStringList.Create;       
  aResStrings := TStringList.Create;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := defConnection;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctKeyset;

    //собираем IDшки клиентов которых нужно пересобрать
    if aForceAll then
      aQuery.SQL.Text := ' SELECT CLIENT_ID, PRIVATE_KEY FROM CLIENTS '
    else
      aQuery.SQL.Text := ' SELECT CLIENT_ID, PRIVATE_KEY FROM CLIENTS WHERE DISCOUNTS_UPDATED = 1 ';

    aQuery.Open;
    while not aQuery.Eof do
    begin
      aClientList.Add(aQuery.Fields[0].AsString + '=' + aQuery.Fields[1].AsString);
      aQuery.Next;
    end;
    aQuery.Close;

    AddLog('Перепаковать ответов: ' + IntToStr(aClientList.Count), True);
      
    InsertCommand.CommandText :=
      ' UPDATE CLIENTS SET DISCOUNTS_UPDATED = 0, DISCOUNTS_VER = DISCOUNTS_VER + 1, DISCOUNTS_ZIP = :DISCOUNTS_ZIP WHERE CLIENT_ID = :CLIENT_ID ';
    InsertCommand.Prepared := True;

    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
   // aQuery.Prepared := True;
    for i := 0 to aClientList.Count - 1 do
    begin
      aQuery.SQL.Text := 
        ' SELECT Min(d.DISC_VALUE) DISCOUNT, d.DISC_GR_CODE, m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID ' +
        ' FROM NAV_DISCOUNTS d ' +
        ' INNER JOIN NAV_AGREEMENTS agr ON (agr.AGR_DISCGR_CODE = d.DISC_GR_CODE) ' +
        ' LEFT JOIN LOTUSMAP m ON (m.CAT_CODE = d.DISC_CAT_CODE) ' +
        ' WHERE (agr.AGR_CLIENT_ID = :CLIENT_ID) AND (m.ID IS NOT NULL OR d.DISC_CAT_CODE = ''#GLOBAL#'') ' +
        ' GROUP BY d.DISC_GR_CODE, m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID ' +
        ' ORDER BY m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID ';

      aQuery.Parameters[0].Value := aClientList.Names[i];
      aQuery.Open;
      anOutFileName := ExtractFilePath(ParamStr(0)) + 'Out\discounts_' + aClientList.Names[i] + '.csv';
      aResStrings.Clear;
      UnloadClientData(aQuery, aResStrings);
      aQuery.Close;

      //пакуем сразу в потоке
      aStream.Clear;
      aResStrings.SaveToStream(aStream);
      aZipStream.Clear;
      aStream.Position := 0;
                                                                                         
      Zipper.Password := StrGetValue( aClientList[i] ); //private key как пароль
      Zipper.ArchiveStream := aZipStream;
      Zipper.ZipFromStream(aStream, 'discounts');
      Zipper.ArchiveStream := nil;

      aZipStream.Position := 0;
      InsertCommand.Parameters[0].LoadFromStream(aZipStream, ftBlob);
      InsertCommand.Parameters[1].Value := aClientList.Names[i];
      InsertCommand.Execute;
      Inc(aCountUpdated);

      if fAborted then
        Break;
    end;

  finally
    AddLog(Format('Перепаковано ответов: %d', [aCountUpdated]));
    aQuery.Free;
    aResStrings.Free;
    aClientList.Free;
    aStream.Free;
    aZipStream.Free;
  end;

  DBDisconnect;
end;

function TServiceDiscounts.NAV_ScanForTask: TNAV_FileTask;

  function FindFile(const aMask: string; aPaths: TStrings;
    aDateTime: TDateTime; out aFileDateTime: TDateTime): string;
  var
    aPath: string;
    SearchRec: TSearchRec;
    a, i: Integer;
    aFound: Boolean;
    aCurDateTime: TDateTime;
  begin
    Result := '';

    aFileDateTime := 0;
    aFound := False;
    for i := 0 to aPaths.Count - 1 do
    begin
      aPath := aPaths[i];
      a := FindFirst(aPath + aMask, faAnyFile, SearchRec);

      if a <> 0 then
        AddLog('  поиск: "' + aPath + aMask + '" - ' + SysErrorMessage(a));

      while a = 0 do
      begin
        if (SearchRec.Attr and faDirectory) > 0 then
        begin
          a := FindNext(SearchRec);
          Continue;
        end;

     //   copyFile(PChar(aPath + SearchRec.Name), PChar('d:\CodeGear\Projects\DiscountsService\in\' + SearchRec.Name), False);

        aCurDateTime := FileDateToDateTime(SearchRec.Time);
        if (aCurDateTime > aDateTime) and (aCurDateTime > aFileDateTime) then
        begin
          aFound := True;
          Result := aPath + SearchRec.Name;
          aFileDateTime := aCurDateTime;
          //Break;
        end;

        a := FindNext(SearchRec);
      end;
      FindClose(SearchRec);

      if aFound then
        Break;
    end;
  end;

var
  aFileDateTime: TDateTime;
  aIni: TIniFile;
  aLastFullClients, aLastDiscounts, aLastPartClients, aLastAgreements, aLastAddress, aLastClientsDescr: TDateTime;
begin
  ZeroMemory(@Result, SizeOf(Result));

  aIni := TIniFile.Create(fIniFileName);
  try
    aLastFullClients := aIni.ReadDateTime('SERVICE', 'NAV_FullClients', 0.0);
    aLastPartClients := aIni.ReadDateTime('SERVICE', 'NAV_PartClients', 0.0);
    aLastDiscounts := aIni.ReadDateTime('SERVICE', 'NAV_Discounts', 0.0);
    aLastAgreements := aIni.ReadDateTime('SERVICE', 'NAV_Agreements', 0.0);
    aLastAddress := aIni.ReadDateTime('SERVICE', 'NAV_Address', 0.0);
    aLastClientsDescr := aIni.ReadDateTime('SERVICE', 'NAV_ClientsDescr', 0.0);
  finally
    aIni.Free;
  end;

//test >>
{
  FindFile1(fClientsPaths);
  Result.FileName := '';
  Result.FileType := ftNone;
  exit;
}  
//<< test


  //ищем полный файл клиентов
  Result.FileName := FindFile(fPrefs.NAV_FullClientsMask, fNAV_ClientsPaths, aLastFullClients, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := nftFullClients;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

  //ищем частичный файл клиентов
  if aLastFullClients > aLastPartClients then
    aLastPartClients := aLastFullClients;
  Result.FileName := FindFile(fPrefs.NAV_PartClientsMask, fNAV_ClientsPaths, aLastPartClients, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := nftPartClients;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

  //ищем описания клиентов
  Result.FileName := FindFile(fPrefs.NAV_ClientsDescrMask, fNAV_ClientsPaths, aLastClientsDescr, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := nftClientsDescr;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;
  
  //ищем полный файл скидок
  Result.FileName := FindFile(fPrefs.NAV_DiscountsMask, fNAV_DiscountsPaths, aLastDiscounts, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := nftDiscounts;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

  //ищем файл договоров
  Result.FileName := FindFile(fPrefs.NAV_AgreementsMask, fNAV_AgreementsPaths, aLastAgreements, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := nftAgreements;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

  //ищем файл адресов
  Result.FileName := FindFile(fPrefs.NAV_AddressMask, fNAV_AddressPaths, aLastAddress, aFileDateTime);
  if Result.FileName <> '' then
  begin
    Result.FileType := nftAddress;
    Result.FileDateTime := aFileDateTime;
    Exit;
  end;

end;

procedure TServiceDiscounts.NAV_SaveProcessedData(aTaskType: TNAV_FileType;
  aFileDateTime: TDateTime);
var
  aIni: TIniFile;
  aKeyName: string;
begin
  aIni := TIniFile.Create(fIniFileName);
  try
    case aTaskType of
      nftNone: aKeyName := 'NONE';
      nftFullClients: aKeyName := 'NAV_FullClients';
      nftPartClients: aKeyName := 'NAV_PartClients';
      nftDiscounts:   aKeyName := 'NAV_Discounts';
      nftAddress:     aKeyName := 'NAV_Address';
      nftAgreements:  aKeyName := 'NAV_Agreements';
      nftClientsDescr: aKeyName := 'NAV_ClientsDescr';
    end;

    aIni.WriteDateTime('SERVICE', aKeyName, aFileDateTime);
  finally
    aIni.Free;
  end;
end;

end.
//формирование мапки
{
delete from [CLIENT_INFO].[dbo].[LOTUSMAP]
go
DBCC CHECKIDENT ([CLIENT_INFO].[dbo].[LOTUSMAP], RESEED, 0)
go
INSERT INTO [CLIENT_INFO].[dbo].[LOTUSMAP]
           ([CAT_CODE]
           ,[GROUP_ID]
           ,[SUBGROUP_ID]
           ,[BRAND_ID])

SELECT distinct
  [CATEGORY],
  [GROUP_ID],
  [SUBGROUP_ID],
  [BRAND_ID]
FROM [SERVICE].[dbo].[CATALOG]
where title = 0
order by category
}
