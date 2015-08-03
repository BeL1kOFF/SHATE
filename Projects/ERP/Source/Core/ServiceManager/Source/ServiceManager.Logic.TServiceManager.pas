unit ServiceManager.Logic.TServiceManager;

interface

uses
  Winapi.Windows,
  Winapi.WinSvc;

type
  TServiceStatus = (ssStopped = 1, ssStartPending, ssStopPending, ssRunning, ssPausePending, ssPaused);

  TServiceManager = class
  private
    FMachineName: string;
    FServiceName: string;
    FSCManager: SC_HANDLE;
    FService: SC_HANDLE;
    function GetServiceStatusProcess: SERVICE_STATUS_PROCESS;
    procedure SetMachineName(const aValue: string);
    procedure SetServiceName(const aValue: string);
    function GetServiceStatus: TServiceStatus;
  public
    constructor Create(aConnect: Boolean);
    destructor Destroy; override;
    function IsHandle: Boolean;
    function IsRuning: Boolean;
    function IsStopped: Boolean;
    procedure ConnectManager;
    procedure DisconnectManager;
    procedure StartService;
    procedure StopService;
    property MachineName: string read FMachineName write SetMachineName;
    property ServiceName: string read FServiceName write SetServiceName;
    property ServiceStatus: TServiceStatus read GetServiceStatus;
  end;

implementation

uses
  System.SysUtils;

type
  ExceptionServiceManager = class(Exception);

{ TServiceManager }

procedure TServiceManager.ConnectManager;
begin
  FSCManager := OpenSCManager(PChar(FMachineName), nil, SC_MANAGER_CONNECT);
  if FSCManager = 0 then
    RaiseLastOSError();
  FService := OpenService(FSCManager, PChar(FServiceName), SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP);
  if FService = 0 then
    RaiseLastOSError();
end;

constructor TServiceManager.Create(aConnect: Boolean);
begin
  FSCManager := 0;
  if aConnect then
    ConnectManager();
end;

destructor TServiceManager.Destroy;
begin
  DisconnectManager();
  inherited Destroy;
end;

procedure TServiceManager.DisconnectManager;
begin
  if FService <> 0 then
    CloseServiceHandle(FService);
  if FSCManager <> 0 then
    CloseServiceHandle(FSCManager);
end;

function TServiceManager.GetServiceStatus: TServiceStatus;
begin
  Result := TServiceStatus(GetServiceStatusProcess().dwCurrentState);
end;

function TServiceManager.GetServiceStatusProcess: SERVICE_STATUS_PROCESS;
var
  BytesNeeded: DWORD;
  Return: BOOL;
begin
  ZeroMemory(@Result, SizeOf(Result));
  Return := QueryServiceStatusEx(FService, SC_STATUS_PROCESS_INFO, @Result, SizeOf(Result), BytesNeeded);
  if not Return then
    RaiseLastOSError();
end;

function TServiceManager.IsHandle: Boolean;
begin
  Result := (FSCManager <> 0) and (FService <> 0);
end;

function TServiceManager.IsRuning: Boolean;
begin
  Result := ServiceStatus <> ssStopped;
end;

function TServiceManager.IsStopped: Boolean;
begin
  Result := ServiceStatus = ssStopped;
end;

procedure TServiceManager.SetMachineName(const aValue: string);
begin
  if IsHandle() then
    raise ExceptionServiceManager.Create('Невозможно изменить имя удаленной машины, если подключение уже установлено.');
  if not SameText(FMachineName, aValue) then
    FMachineName := aValue;
end;

procedure TServiceManager.SetServiceName(const aValue: string);
begin
  if IsHandle() then
    raise ExceptionServiceManager.Create('Невозможно изменить имя сервиса, если подключение уже установлено.');
  if not SameText(FServiceName, aValue) then
    FServiceName := aValue;
end;

procedure TServiceManager.StartService;
var
  Return: BOOL;
  ServiceArgVectors: PChar;
begin
  if not IsRuning() then
  begin
    ServiceArgVectors := nil;
    Return := Winapi.WinSvc.StartService(FService, 0, ServiceArgVectors);
    if not Return then
      RaiseLastOSError();
  end;
end;

procedure TServiceManager.StopService;
var
  Return: DWORD;
  SCSRP: SERVICE_CONTROL_STATUS_REASON_PARAMS;
begin
  if ServiceStatus = ssRunning then
  begin
    ZeroMemory(@SCSRP, SizeOf(SCSRP));
    SCSRP.dwReason := SERVICE_STOP_REASON_FLAG_PLANNED or SERVICE_STOP_REASON_MAJOR_NONE or SERVICE_STOP_REASON_MINOR_NONE;
    SCSRP.pszComment := 'Остановка службы через ServiceManager';
    Return := ControlServiceEx(FService, SERVICE_CONTROL_STOP, SERVICE_CONTROL_STATUS_REASON_INFO, @SCSRP);
    if Return = 0 then
      RaiseLastOSError();
  end;
end;

end.
