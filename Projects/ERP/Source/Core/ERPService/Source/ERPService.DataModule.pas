unit ERPService.DataModule;

interface

uses
  Winapi.WinSvc,
  System.SysUtils,
  System.Win.ScktComp,
  Vcl.SvcMgr,
  ERP.Package.ServerClasses.ServerTypes,
  ERP.Package.ServerClasses.IServerManager,
  ERP.Package.ServerClasses.IServerCustomManager,
  ERPService.Logic.TFileLogger;

type
  TERPServer = class(TService)
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    FServerManager: IServerManager;
    FFileLogger: TFileLogger;
    function GetCommandToString(aManagerType: TServerManagerType; aCommand: Integer): string;
    procedure DoProcLoggerCustomManager(aServerCustomManager: IServerCustomManager;
      aEventTypeSocketThread: TEventTypeSocketThread; aServerSocketCustomThread: TServerClientThread);
  public
    function GetServiceController: TServiceController; override;
  end;

var
  ERPServer: TERPServer;

implementation

{$R *.DFM}

uses
  Winapi.Windows,
  Winapi.ActiveX,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.Classes.TERPSocketStream,
  ERP.Package.ServerClasses.TServerManager;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ERPServer.Controller(CtrlCode);
end;

procedure TERPServer.DoProcLoggerCustomManager(aServerCustomManager: IServerCustomManager;
  aEventTypeSocketThread: TEventTypeSocketThread; aServerSocketCustomThread: TServerClientThread);
var
  MessageText: string;
  Manager: string;
  Who: string;
  Buffer: TERPSocketStream;
  Bytes: TBytes;
  Command: Integer;
begin
  case aServerCustomManager.ManagerType of
    smtClient:
      Manager := 'Клиент';
    smtService:
      Manager := 'Менеджер';
    smtUnknown:
      Manager := 'Unknown';
  end;
  Who := Format('%s (%s)', [aServerSocketCustomThread.ClientSocket.RemoteAddress, aServerSocketCustomThread.ClientSocket.RemoteHost]);
  case aEventTypeSocketThread of
    etstConnect:
      MessageText := 'подключился';
    etstDisconnect:
      MessageText := 'отключился';
    etstRead:
      MessageText := 'отправил данные';
    etstProcess:
      begin
        Buffer := TERPSocketStream.Create();
        try
          Bytes := TBytes(aServerSocketCustomThread.Data^);
          Buffer.WriteBuffer(Bytes[0], Length(Bytes));
          Buffer.Position := 0;
          Command := Buffer.ReadInteger();
          MessageText := Format('%s %s', ['обрабатывает сообщение', GetCommandToString(aServerCustomManager.ManagerType, Command)]);
        finally
          Buffer.Free();
        end;
      end;
  end;
  FFileLogger.WriteLog(Format('%s %s %s', [Manager, Who, MessageText]));
end;

function TERPServer.GetCommandToString(aManagerType: TServerManagerType; aCommand: Integer): string;
begin
  case aManagerType of
    smtClient:
      begin
        case aCommand of
          CLIENT_COMMAND_AUTH:
            Result := 'CLIENT_COMMAND_AUTH';
          CLIENT_COMMAND_GETDBLIST:
            Result := 'CLIENT_COMMAND_GETDBLIST';
          CLIENT_COMMAND_GETMODULES:
            Result := 'CLIENT_COMMAND_GETMODULES';
          CLIENT_COMMAND_GETMENU:
            Result := 'CLIENT_COMMAND_GETMENU';
          CLIENT_COMMAND_CHANGEPASSWORD:
            Result := 'CLIENT_COMMAND_CHANGEPASSWORD';
          else
            Result := 'Unknown Command';
        end;
      end;
    smtService:
      begin
        case aCommand of
          MANAGER_COMMAND_GETLISTCONNECTION:
            Result := 'MANAGER_COMMAND_GETLISTCONNECTION';
          MANAGER_COMMAND_DISCONNECT:
            Result := 'MANAGER_COMMAND_DISCONNECT';
          MANAGER_COMMAND_MESSAGE:
            Result := 'MANAGER_COMMAND_MESSAGE';
          else
            Result := 'Unknown Command';
        end;
      end;
    else
      Result := 'Unknown ManagerType';
  end;
end;

function TERPServer.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TERPServer.ServiceAfterInstall(Sender: TService);
var
  SvcMgr: SC_HANDLE;
  Svc: SC_HANDLE;
  Description: SERVICE_DESCRIPTION;
begin
  SvcMgr := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SvcMgr = 0 then RaiseLastOSError;
  try
    Svc := OpenService(SvcMgr, PChar(Name), SERVICE_ALL_ACCESS);
    if Svc = 0 then RaiseLastOSError;
    try
      if Pos(' ', ParamStr(0)) > 0 then
        ChangeServiceConfig(Svc, SERVICE_NO_CHANGE, SERVICE_NO_CHANGE, SERVICE_NO_CHANGE, PChar('"' + ParamStr(0) + '"'),
          nil, nil, nil, nil, nil, nil);
      Description.lpDescription := 'Служба является сервером аутентификации ERP и управлением клиентскими подключениями';
      ChangeServiceConfig2(Svc, SERVICE_CONFIG_DESCRIPTION, @Description);
    finally
      CloseServiceHandle(Svc);
    end;
  finally
    CloseServiceHandle(SvcMgr);
  end;
end;

procedure TERPServer.ServiceStart(Sender: TService; var Started: Boolean);
begin
  CoInitializeEx(nil, 0);
  FFileLogger := TFileLogger.Create();
  FFileLogger.IsFileRename := True;
  FFileLogger.FileExt := 'log';
  FFileLogger.Path := ExtractFilePath(ParamStr(0));
  FFileLogger.FileName := Name;
  FFileLogger.Init();
  FFileLogger.WriteLog('Сервис стартует');
  FServerManager := TServerManager.Create(DoProcLoggerCustomManager);
  FServerManager.Open();
  FFileLogger.WriteLog('Сервис стартовал');
end;

procedure TERPServer.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  FFileLogger.WriteLog('Сервис останавливается');
  FServerManager := nil;
  FFileLogger.WriteLog('Сервис остановился');
  FFileLogger.Free();
  CoUninitialize();
end;

end.
