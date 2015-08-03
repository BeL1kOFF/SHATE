unit ERP.Package.ServerClasses.TServerCustomManager;

interface

uses
  System.SyncObjs,
  System.Win.ScktComp,
  ERP.Package.ServerClasses.IServerManager,
  ERP.Package.ServerClasses.IServerCustomManager,
  ERP.Package.ServerClasses.ServerTypes,
  ERP.Package.Classes.TERPSocketStream;

type
  TServerCustomManager = class(TInterfacedObject, IServerCustomManager)
  private
    FServerSocket: TServerSocket;
    FProcLoggerCustomManager: TProcLoggerCustomManager;
    {[Weak]} FServerManager: IServerManager;
    FLock: TCriticalSection;
    FManagerType: TServerManagerType;
    function GetManagerType: TServerManagerType;
    procedure AddBufferActiveConnections(aBuffer: TERPSocketStream);
    procedure DoGetThread(Sender: TObject; ClientSocket: TServerClientWinSocket;
      var SocketThread: TServerClientThread);
    procedure OnProcLoggerSocketThread(aEventTypeSocketThread: TEventTypeSocketThread;
      aServerSocketCustomThread: TServerClientThread);
    procedure OnProcProcessedSocketThread(aServerSocketCustomThread: TServerClientThread;
      const aBuffer; aSize: Integer);
    procedure SendAllBuffer(aBuffer: TERPSocketStream);
    procedure SendClientBuffer(aClientList: TSocketArray; aBuffer: TERPSocketStream);
  protected
    function GetPort: Integer; virtual; abstract;

    procedure DoProcEventCustomManager(aEventTypeSocketThread: TEventTypeSocketThread;
      aServerSocketCustomThread: TServerClientThread); virtual; abstract;

    procedure DoProcLoggerCustomManager(aServerCustomManager: IServerCustomManager;
      aEventTypeSocketThread: TEventTypeSocketThread; aServerSocketCustomThread: TServerClientThread); virtual;

    procedure DoProcSocketThread(aServerSocketCustomThread: TServerClientThread; const aBuffer; aSize: Integer); virtual; abstract;

    property ServerManager: IServerManager read FServerManager;
    property ManagerType: TServerManagerType read GetManagerType write FManagerType;
  public
    constructor Create(aServerManager: IServerManager; aProcLoggerCustomManager: TProcLoggerCustomManager); virtual;
    destructor Destroy; override;
    procedure Open; virtual;
  end;

implementation

uses
  Winapi.Winsock,
  ERP.Package.Classes.TCustomWinSocketHelper,
  ERP.Package.ServerClasses.TServerSocketCustomThread;

{ TServerCustomManager }

procedure TServerCustomManager.AddBufferActiveConnections(aBuffer: TERPSocketStream);
var
  k: Integer;
begin
  Assert(Assigned(aBuffer), 'aBuffer is nil');
  aBuffer.WriteInteger(FServerSocket.Socket.ActiveConnections);
  for k := 0 to FServerSocket.Socket.ActiveConnections - 1 do
  begin
    aBuffer.WriteSocket(FServerSocket.Socket.Connections[k].SocketHandle);
    aBuffer.WriteString(FServerSocket.Socket.Connections[k].RemoteAddress);
    aBuffer.WriteString(FServerSocket.Socket.Connections[k].RemoteHost);
    aBuffer.WriteDateTime((FServerSocket.Socket.GetClientThread(FServerSocket.Socket.Connections[k] as TServerClientWinSocket) as TServerSocketCustomThread).StartTime);
  end;
end;

constructor TServerCustomManager.Create(aServerManager: IServerManager;
  aProcLoggerCustomManager: TProcLoggerCustomManager);
begin
  Pointer(FServerManager) := Pointer(aServerManager);
  FProcLoggerCustomManager := aProcLoggerCustomManager;

  FLock := TCriticalSection.Create();

  FManagerType := smtUnknown;

  FServerSocket := TServerSocket.Create(nil);
  FServerSocket.Port := GetPort();
  FServerSocket.ServerType := stThreadBlocking;
  FServerSocket.OnGetThread := DoGetThread;
end;

destructor TServerCustomManager.Destroy;
var
  Flag: PBoolean;
begin
  New(Flag);
  try
    Flag^ := True;
    FLock.Enter();
    try
      FServerSocket.Socket.Data := Flag;
    finally
      FLock.Leave();
    end;
    FServerSocket.Free();
  finally
    Dispose(Flag);
  end;
  FLock.Free();
  Pointer(FServerManager) := nil;
  inherited Destroy;
end;

procedure TServerCustomManager.DoGetThread(Sender: TObject; ClientSocket: TServerClientWinSocket;
  var SocketThread: TServerClientThread);
begin
  SocketThread := TServerSocketCustomThread.Create(ClientSocket, OnProcProcessedSocketThread, OnProcLoggerSocketThread, FLock);
  SocketThread.FreeOnTerminate := True;
end;

procedure TServerCustomManager.DoProcLoggerCustomManager(aServerCustomManager: IServerCustomManager;
  aEventTypeSocketThread: TEventTypeSocketThread; aServerSocketCustomThread: TServerClientThread);
begin
  if Assigned(FProcLoggerCustomManager) then
    FProcLoggerCustomManager(Self, aEventTypeSocketThread, aServerSocketCustomThread);
end;

function TServerCustomManager.GetManagerType: TServerManagerType;
begin
  Result := FManagerType;
end;

procedure TServerCustomManager.OnProcLoggerSocketThread(aEventTypeSocketThread: TEventTypeSocketThread;
  aServerSocketCustomThread: TServerClientThread);
begin
  DoProcEventCustomManager(aEventTypeSocketThread, aServerSocketCustomThread);
  DoProcLoggerCustomManager(Self, aEventTypeSocketThread, aServerSocketCustomThread);
end;

procedure TServerCustomManager.OnProcProcessedSocketThread(aServerSocketCustomThread: TServerClientThread;
  const aBuffer; aSize: Integer);
begin
  DoProcSocketThread(aServerSocketCustomThread, aBuffer, aSize);
end;

procedure TServerCustomManager.Open;
begin
  FServerSocket.Open();
end;

procedure TServerCustomManager.SendAllBuffer(aBuffer: TERPSocketStream);
var
  k: Integer;
begin
  for k := 0 to FServerSocket.Socket.ActiveConnections - 1 do
    FServerSocket.Socket.Connections[k].SendSafeBuffer(aBuffer.Bytes[0], aBuffer.Size);
end;

procedure TServerCustomManager.SendClientBuffer(aClientList: TSocketArray; aBuffer: TERPSocketStream);
var
  k: Integer;
  ClientSocket: TCustomWinSocket;

  function GetConnection(aSocketHandle: TSocket): TCustomWinSocket;
  var
    k: Integer;
  begin
    for k := 0 to FServerSocket.Socket.ActiveConnections - 1 do
      if FServerSocket.Socket.Connections[k].SocketHandle = aSocketHandle then
        Exit(FServerSocket.Socket.Connections[k]);
    Result := nil;
  end;

begin
  for k := Low(aClientList) to High(aClientList) do
  begin
    ClientSocket := GetConnection(aClientList[k]);
    if Assigned(ClientSocket) then
      ClientSocket.SendSafeBuffer(aBuffer.Bytes[0], aBuffer.Size);
  end;
end;

end.
