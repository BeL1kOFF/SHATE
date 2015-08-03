unit ERP.Package.ServerClasses.TServerServiceManager;

interface

uses
  System.Win.ScktComp,
  ERP.Package.ServerClasses.IServerServiceManager,
  ERP.Package.ServerClasses.TServerCustomManager,
  ERP.Package.ServerClasses.ServerTypes;

type
  TServerServiceManager = class(TServerCustomManager, IServerServiceManager)
  private
    procedure RunCommand(aServerSocketCustomThread: TServerClientThread; aCommand: Integer; aParam: array of const);
  protected
    function GetPort: Integer; override;
    procedure DoProcEventCustomManager(aEventTypeSocketThread: TEventTypeSocketThread;
      aServerSocketCustomThread: TServerClientThread); override;
    procedure DoProcSocketThread(aServerSocketCustomThread: TServerClientThread;
      const aBuffer; aSize: Integer); override;
  public
    procedure AfterConstruction; override;
  end;

implementation

uses
  System.SysUtils,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.Classes.TERPSocketStream,
  ERP.Package.Classes.TCustomWinSocketHelper,
  ERP.Package.ServerClasses.ERPAuthOptions,
  ERP.Package.ServerClasses.IServerCustomManager,
  ERP.Package.ServerClasses.TServerManager;

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(ParamStr(0)) + 'ERPAuth.xml');
end;

{ TServerServiceManager }

function TServerServiceManager.GetPort: Integer;
begin
  Result := GetOptions().Socket.PortManager;
end;

procedure TServerServiceManager.AfterConstruction;
begin
  inherited AfterConstruction();

  ManagerType := smtService;
end;

procedure TServerServiceManager.DoProcEventCustomManager(aEventTypeSocketThread: TEventTypeSocketThread;
  aServerSocketCustomThread: TServerClientThread);
begin

end;

procedure TServerServiceManager.DoProcSocketThread(aServerSocketCustomThread: TServerClientThread;
  const aBuffer; aSize: Integer);
var
  Buffer: TERPSocketStream;
  Command: Integer;
  Count: Integer;
  SocketArray: TSocketArray;
  k: Integer;
  TextMessage: string;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteBuffer(aBuffer, aSize);
    Buffer.Position := 0;
    Command := Buffer.ReadInteger();
    case Command of
      MANAGER_COMMAND_GETLISTCONNECTION:
        begin
          RunCommand(aServerSocketCustomThread, Command, []);
        end;
      MANAGER_COMMAND_DISCONNECT:
        begin
          Count := Buffer.ReadInteger();
          SetLength(SocketArray, Count);
          for k := 0 to Count - 1 do
            SocketArray[k] := Buffer.ReadSocket();
          RunCommand(aServerSocketCustomThread, Command, [SocketArray]);
        end;
      MANAGER_COMMAND_MESSAGE:
        begin
          TextMessage := Buffer.ReadString();
          Count := Buffer.ReadInteger();
          SetLength(SocketArray, Count);
          for k := 0 to Count - 1 do
            SocketArray[k] := Buffer.ReadSocket();
          RunCommand(aServerSocketCustomThread, Command, [SocketArray, TextMessage]);
        end;
    end;
  finally
    Buffer.Free();
  end;
end;

procedure TServerServiceManager.RunCommand(aServerSocketCustomThread: TServerClientThread; aCommand: Integer;
  aParam: array of const);
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create();
  try
    case aCommand of
      MANAGER_COMMAND_GETLISTCONNECTION:
        begin
          Buffer.WriteInteger(SERVER_M_COMMAND_RESULTLISTCONNECTION);
          TServerManager(ServerManager).ServerClientManager.AddBufferActiveConnections(Buffer);
          aServerSocketCustomThread.ClientSocket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
        end;
      MANAGER_COMMAND_DISCONNECT:
        begin
          Buffer.WriteInteger(SERVER_COMMAND_DISCONNECT);
          TServerManager(ServerManager).ServerClientManager.SendClientBuffer(TSocketArray(aParam[0].VPointer), Buffer);
        end;
      MANAGER_COMMAND_MESSAGE:
        begin
          Buffer.WriteInteger(SERVER_COMMAND_MESSAGE);
          Buffer.WriteString(string(PChar(aParam[1].VUnicodeString)));
          TServerManager(ServerManager).ServerClientManager.SendClientBuffer(TSocketArray(aParam[0].VPointer), Buffer);
        end;
    end;
  finally
    Buffer.Free();
  end;
end;

end.
