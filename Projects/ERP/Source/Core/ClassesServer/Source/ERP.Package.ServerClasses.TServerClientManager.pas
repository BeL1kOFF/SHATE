unit ERP.Package.ServerClasses.TServerClientManager;

interface

uses
  System.Win.ScktComp,
  ERP.Package.ServerClasses.IServerManager,
  ERP.Package.ServerClasses.IServerClientManager,
  ERP.Package.ServerClasses.TServerCustomManager,
  ERP.Package.ServerClasses.TAuthDBConnection,
  ERP.Package.ServerClasses.ServerTypes;

type
  TServerClientManager = class(TServerCustomManager, IServerClientManager)
  private
    FDBConnection: TAuthDBConnection;
    procedure RunCommand(aServerSocketCustomThread: TServerClientThread; aCommand: Integer; aParam: array of const);
  protected
    function GetPort: Integer; override;
    procedure DoProcSocketThread(aServerSocketCustomThread: TServerClientThread;
      const aBuffer; aSize: Integer); override;
    procedure DoProcEventCustomManager(aEventTypeSocketThread: TEventTypeSocketThread;
      aServerSocketCustomThread: TServerClientThread); override;
  public
    constructor Create(aServerManager: IServerManager; aProcLoggerCustomManager: TProcLoggerCustomManager); override;
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.Classes.TERPSocketStream,
  ERP.Package.Classes.TCustomWinSocketHelper,
  ERP.Package.ServerClasses.ERPAuthOptions,
  ERP.Package.ServerClasses.IServerCustomManager,
  ERP.Package.ServerClasses.TServerManager,
  ERP.Package.ServerClasses.TServerSocketCustomThread;

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(ParamStr(0)) + 'ERPAuth.xml');
end;

{ TServerClientManager }

constructor TServerClientManager.Create(aServerManager: IServerManager; aProcLoggerCustomManager: TProcLoggerCustomManager);
begin
  FDBConnection := TAuthDBConnection.Create();

  inherited Create(aServerManager, aProcLoggerCustomManager);

  ManagerType := smtClient;
end;

destructor TServerClientManager.Destroy;
begin
  inherited Destroy;

  FDBConnection.Free();
end;

function TServerClientManager.GetPort: Integer;
begin
  Result := GetOptions().Socket.PortClient;
end;

procedure TServerClientManager.DoProcEventCustomManager(aEventTypeSocketThread: TEventTypeSocketThread;
  aServerSocketCustomThread: TServerClientThread);
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create();
  try
    case aEventTypeSocketThread of
      etstConnect:
        begin
          Buffer.WriteInteger(SERVER_M_COMMAND_CLIENTCONNECT);
          Buffer.WriteSocket(aServerSocketCustomThread.ClientSocket.SocketHandle);
          Buffer.WriteString(aServerSocketCustomThread.ClientSocket.RemoteAddress);
          Buffer.WriteString(aServerSocketCustomThread.ClientSocket.RemoteHost);
          Buffer.WriteDateTime((aServerSocketCustomThread as TServerSocketCustomThread).StartTime);
          TServerManager(ServerManager).ServerServiceManager.SendAllBuffer(Buffer);
        end;
      etstDisconnect:
        begin
          Buffer.WriteInteger(SERVER_M_COMMAND_CLIENTDISCONNECT);
          Buffer.WriteSocket(aServerSocketCustomThread.ClientSocket.SocketHandle);
          TServerManager(ServerManager).ServerServiceManager.SendAllBuffer(Buffer);
        end;
    end;
  finally
    Buffer.Free();
  end;
end;

procedure TServerClientManager.DoProcSocketThread(aServerSocketCustomThread: TServerClientThread;
  const aBuffer; aSize: Integer);
var
  Command: Integer;
  login: string;
  password: string;
  id_user: Integer;
  id_database: Integer;
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteBuffer(aBuffer, aSize);
    Buffer.Position := 0;
    Command := Buffer.ReadInteger();
    case Command of
      CLIENT_COMMAND_AUTH:
        begin
          login := Buffer.ReadString();
          password := Buffer.ReadString();
          RunCommand(aServerSocketCustomThread, Command, [login, password]);
        end;
      CLIENT_COMMAND_CHANGEPASSWORD:
        begin
          login := Buffer.ReadString();
          password := Buffer.ReadString();
          RunCommand(aServerSocketCustomThread, Command, [login, password]);
        end;
      CLIENT_COMMAND_GETDBLIST:
        begin
          id_user := Buffer.ReadInteger();
          RunCommand(aServerSocketCustomThread, Command, [id_user]);
        end;
      CLIENT_COMMAND_GETMODULES:
        begin
          id_user := Buffer.ReadInteger();
          id_database := Buffer.ReadInteger();
          RunCommand(aServerSocketCustomThread, Command, [id_user, id_database]);
        end;
      CLIENT_COMMAND_GETMENU:
        begin
          id_user := Buffer.ReadInteger();
          id_database := Buffer.ReadInteger();
          RunCommand(aServerSocketCustomThread, Command, [id_user, id_database]);
        end;
    end;
  finally
    Buffer.Free();
  end;
end;

procedure TServerClientManager.Open;
begin
  FDBConnection.Connect();
  inherited Open();
end;

procedure TServerClientManager.RunCommand(aServerSocketCustomThread: TServerClientThread;
  aCommand: Integer; aParam: array of const);
var
  Query: TFDQuery;
  Buffer: TERPSocketStream;
  ResultType: Integer;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := FDBConnection.FDConnection;
      case aCommand of
        CLIENT_COMMAND_AUTH:
          begin
            Query.SQL.Text := 'adm_check_connect :IsWinAuth, :Login, :Password';
            Query.Params.ParamValues['IsWinAuth'] := aParam[1].VUnicodeString = nil;
            Query.Params.ParamValues['Login'] := string(PChar(aParam[0].VUnicodeString));
            if aParam[1].VUnicodeString = nil then
              Query.Params.ParamValues['Password'] := ''
            else
              Query.Params.ParamValues['Password'] := string(PChar(aParam[1].VUnicodeString));
            Query.Open();
            if Query.RecordCount = 0 then
              Buffer.WriteInteger(SERVER_COMMAND_DENIDED)
            else
            begin
              if Query.FieldByName('IsChangePassword').AsBoolean then
                Buffer.WriteInteger(SERVER_COMMAND_CHANGEPASSWORD)
              else
              begin
                Buffer.WriteInteger(SERVER_COMMAND_ACCEPT);
                Buffer.WriteInteger(Query.FieldByName('Id_User').AsInteger);
                Buffer.WriteString(Query.FieldByName('UserName').AsString);
              end;
            end;
            aServerSocketCustomThread.ClientSocket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
          end;
        CLIENT_COMMAND_CHANGEPASSWORD:
          begin
            Query.SQL.Text := 'adm_changepassword :Login, :Password';
            Query.Params.ParamValues['Login'] := string(PChar(aParam[0].VUnicodeString));
            Query.Params.ParamValues['Password'] := string(PChar(aParam[1].VUnicodeString));
            Query.Open();
            ResultType := Query.Fields.Fields[0].AsInteger;
            Query.Close();
            if ResultType = 1 then
            begin
              Query.SQL.Text := 'adm_check_connect :IsWinAuth, :Login, :Password';
              Query.Params.ParamValues['IsWinAuth'] := False;
              Query.Params.ParamValues['Login'] := string(PChar(aParam[0].VUnicodeString));
              Query.Params.ParamValues['Password'] := string(PChar(aParam[1].VUnicodeString));
              Query.Open();
              if Query.RecordCount = 0 then
                Buffer.WriteInteger(SERVER_COMMAND_DENIDED)
              else
              begin
                Buffer.WriteInteger(SERVER_COMMAND_ACCEPT);
                Buffer.WriteInteger(Query.FieldByName('Id_User').AsInteger);
                Buffer.WriteString(Query.FieldByName('UserName').AsString);
              end;
            end
            else
              Buffer.WriteInteger(SERVER_COMMAND_DENIDED);
            aServerSocketCustomThread.ClientSocket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
          end;
        CLIENT_COMMAND_GETDBLIST:
          begin
            Query.SQL.Text := 'adm_sel_dblist :Id_User';
            Query.Params.ParamValues['Id_User'] := aParam[0].VInteger;
            Query.Open();
            Query.First();
            Buffer.WriteInteger(SERVER_COMMAND_RESULTDBLIST);
            Buffer.WriteInteger(Query.RecordCount);
            while not Query.Eof do
            begin
              Buffer.WriteInteger(Query.FieldByName('Id_DataBase').AsInteger);
              Buffer.WriteString(Query.FieldByName('ServerName').AsString);
              Buffer.WriteString(Query.FieldByName('DataBase').AsString);
              Buffer.WriteString(Query.FieldByName('DataBaseName').AsString);
              Buffer.WriteInteger(Query.FieldByName('TypeDB').AsInteger);
              Query.Next();
            end;
            aServerSocketCustomThread.ClientSocket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
          end;
        CLIENT_COMMAND_GETMODULES:
          begin
            Query.SQL.Text := 'adm_sel_modulelist :Id_User, :Id_DataBase';
            Query.Params.ParamValues['Id_User'] := aParam[0].VInteger;
            Query.Params.ParamValues['Id_DataBase'] := aParam[1].VInteger;
            Query.Open();
            Query.First();
            Buffer.WriteInteger(SERVER_COMMAND_RESULTMODULES);
            Buffer.WriteInteger(Query.RecordCount);
            while not Query.Eof do
            begin
              Buffer.WriteGUID(StringToGUID(Query.FieldByName('GUID').AsString));
              Buffer.WriteString(Query.FieldByName('Access').AsString);
              Query.Next();
            end;
            aServerSocketCustomThread.ClientSocket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
          end;
        CLIENT_COMMAND_GETMENU:
          begin
            Query.SQL.Text := 'adm_sel_menu :Id_User, :Id_DataBase';
            Query.Params.ParamValues['Id_User'] := aParam[0].VInteger;
            Query.Params.ParamValues['Id_DataBase'] := aParam[1].VInteger;
            Query.Open();
            Query.First();
            Buffer.WriteInteger(SERVER_COMMAND_RESULTMENU);
            Buffer.WriteInteger(Query.RecordCount);
            while not Query.Eof do
            begin
              Buffer.WriteInteger(Query.FieldByName('Id_MenuDesign').AsInteger);
              Buffer.WriteInteger(Query.FieldByName('Id_MenuDesignParent').AsInteger);
              Buffer.WriteInteger(Query.FieldByName('Id_Module').AsInteger);
              Buffer.WriteString(Query.FieldByName('Caption').AsString);
              Buffer.WriteInteger(Query.FieldByName('Level').AsInteger);
              Buffer.WriteGUID(StringToGUID(Query.FieldByName('Guid').AsString));
              Query.Next();
            end;
            aServerSocketCustomThread.ClientSocket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
          end;
      end;
    finally
      Query.Free();
    end;
  finally
    Buffer.Free();
  end;
end;

end.
