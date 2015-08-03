unit ServiceMain;

interface

uses
  Winapi.Windows,
  Vcl.SvcMgr,
  Logic.TMain;

type
  TTSDService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceAfterInstall(Sender: TService);
  private
    FMain: TMain;
  public
    function GetServiceController: TServiceController; override;
  end;

var
  TSDService: TTSDService;

implementation

uses
  Winapi.WinSvc,
  Winapi.ActiveX,
  System.SysUtils,
  Logic.InitUnit,
  Logic.TFileLogger,
  Logic.Options;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  TSDService.Controller(CtrlCode);
end;

function TTSDService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TTSDService.ServiceAfterInstall(Sender: TService);
var
  SvcMgr: SC_HANDLE;
  Svc: SC_HANDLE;
  Description: SERVICE_DESCRIPTION;
begin
  SvcMgr := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if SvcMgr = 0 then
    RaiseLastOSError;
  try
    Svc := OpenService(SvcMgr, PChar(Name), SERVICE_CHANGE_CONFIG);
    if Svc = 0 then
      RaiseLastOSError;
    try
      if Pos(' ', ParamStr(0)) > 0 then
        ChangeServiceConfig(Svc, SERVICE_NO_CHANGE, SERVICE_NO_CHANGE, SERVICE_NO_CHANGE, PChar(Format('"%s"', [ParamStr(0)])),
          nil, nil, nil, nil, nil, nil);
      Description.lpDescription := 'Служба обмена данными между ТСД и вебсервисами Navision';
      ChangeServiceConfig2(Svc, SERVICE_CONFIG_DESCRIPTION, @Description);
    finally
      CloseServiceHandle(Svc);
    end;
  finally
    CloseServiceHandle(SvcMgr);
  end;
end;

procedure TTSDService.ServiceCreate(Sender: TObject);
begin
//  FMain := TMain.Create();
//  while True do Sleep(0);
end;

procedure TTSDService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  CoInitialize(nil);
  FMain := TMain.Create();
  TLog.LogMessage(nil, 'Служба запущена');
end;

procedure TTSDService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  TLog.LogMessage(nil, 'Служба останавливается');
  FMain.Free();
  TLog.LogMessage(nil, 'Служба остановлена');
  CoUninitialize();
end;

end.
