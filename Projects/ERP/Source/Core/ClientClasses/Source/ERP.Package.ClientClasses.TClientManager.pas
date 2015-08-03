unit ERP.Package.ClientClasses.TClientManager;

interface

uses
  ERP.Package.ClientClasses.IClientManager,
  ERP.Package.ClientClasses.TPluginManager,
  ERP.Package.ClientClasses.TWindowManager,
  ERP.Package.ClientClasses.TERPSocketClient,
  ERP.Package.ClientInterface.IDBConnectionManagerEx;

type
  TClientManager = class(TInterfacedObject, IClientManager)
  private
    FUserLogin: string;
    FERPSocketClient: TERPSocketClient;
    FPassword: string;
    FIsWinAuth: Boolean;
    FPluginManager: TPluginManager;
    FWindowManager: TWindowManager;
    FDBConnectionManager: IDBConnectionManagerEx;
    function GetIsWinAuth: Boolean;
    function GetDBConnectionManager: IDBConnectionManagerEx;
    function GetPassword: string;
    function GetPluginManager: TPluginManager;
    function GetSocketClient: TERPSocketClient;
    function GetUserLogin: string;
    function GetWindowManager: TWindowManager;
    procedure SetIsWinAuth(const aValue: Boolean);
    procedure SetPassword(const aValue: string);
    procedure SetUserLogin(const aValue: string);
  private
    procedure ProcessingCommand(const aBuffer; aSize: Integer);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  Vcl.Forms,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.Classes.TERPSocketStream,
  ERP.Package.ClientClasses.ERPOptions,
  ERP.Package.ClientClasses.TDBConnectionManagerEx;

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(Application.ExeName) + 'ERP.xml');
end;

{ TClientManager }

constructor TClientManager.Create;
begin
  FERPSocketClient := TERPSocketClient.Create();
  FERPSocketClient.OnProcessingCommand := ProcessingCommand;

  FDBConnectionManager := TDBConnectionManagerEx.Create();
  FPluginManager := TPluginManager.Create();
  FWindowManager := TWindowManager.Create();
end;

destructor TClientManager.Destroy;
begin
  FWindowManager.Free();
  FPluginManager.Free();
  FDBConnectionManager := nil;
  FERPSocketClient.Free();
  inherited Destroy();
end;

function TClientManager.GetDBConnectionManager: IDBConnectionManagerEx;
begin
  Result := FDBConnectionManager;
end;

function TClientManager.GetIsWinAuth: Boolean;
begin
  Result := FIsWinAuth;
end;

function TClientManager.GetPassword: string;
begin
  Result := FPassword;
end;

function TClientManager.GetPluginManager: TPluginManager;
begin
  Result := FPluginManager;
end;

function TClientManager.GetSocketClient: TERPSocketClient;
begin
  Result := FERPSocketClient;
end;

function TClientManager.GetUserLogin: string;
begin
  Result := FUserLogin;
end;

function TClientManager.GetWindowManager: TWindowManager;
begin
  Result := FWindowManager;
end;

procedure TClientManager.ProcessingCommand(const aBuffer; aSize: Integer);
var
  Buffer: TERPSocketStream;
  Command: Integer;
  k: Integer;
  Count: Integer;
  tmpGUID: TGUID;
  id_DataBase: Integer;
  server, dataBase, dataBaseName: string;
  typeDB: Integer;
  access: string;
  p: PAccessModuleList;
  Id_MenuDesign: Integer;
  Id_MenuDesignParent: Integer;
  Id_Module: Integer;
  Caption: string;
  Level: Integer;
  TextMessage: string;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteBuffer(aBuffer, aSize);
    Buffer.Position := 0;
    Command := Buffer.ReadInteger();
    case Command of
      SERVER_COMMAND_DENIDED:
        Application.MessageBox('В доступе отказано!', 'Подключение', MB_OK or MB_ICONWARNING);
      SERVER_COMMAND_ACCEPT:
        begin
          FDBConnectionManager.Id_User := Buffer.ReadInteger();
          FDBConnectionManager.UserName := PChar(Buffer.ReadString());
          FERPSocketClient.SendCommandGetDBList(FDBConnectionManager.Id_User);
        end;
      SERVER_COMMAND_RESULTDBLIST:
        begin
          Count := Buffer.ReadInteger();
          for k := 0 to Count - 1 do
          begin
            id_DataBase := Buffer.ReadInteger();
            server := Buffer.ReadString();
            dataBase := Buffer.ReadString();
            dataBaseName := Buffer.ReadString();
            typeDB := Buffer.ReadInteger();
            FDBConnectionManager.AddConnection(id_DataBase, server, dataBase, dataBaseName, typeDB, FUserLogin, FPassword, FIsWinAuth);
          end;
        end;
      SERVER_COMMAND_RESULTMODULES:
        begin
          FPluginManager.ClearAccessModuleList();
          Count := Buffer.ReadInteger();
          for k := 0 to Count - 1 do
          begin
            tmpGUID := Buffer.ReadGUID();
            access := Buffer.ReadString();
            New(p);
            p^.GUID := tmpGUID;
            p^.Access := access;
            FPluginManager.AccessModuleList.Add(p);
          end;
          FERPSocketClient.SendLoadMenu(FDBConnectionManager.Id_User, FDBConnectionManager.ActiveConnection.Id_DataBase);
        end;
      SERVER_COMMAND_RESULTMENU:
        begin
          FPluginManager.MenuDesignManager.Clear();
          Count := Buffer.ReadInteger();
          for k := 0 to Count - 1 do
          begin
            Id_MenuDesign := Buffer.ReadInteger();
            Id_MenuDesignParent := Buffer.ReadInteger();
            Id_Module := Buffer.ReadInteger();
            Caption := Buffer.ReadString();
            Level := Buffer.ReadInteger();
            tmpGUID := Buffer.ReadGUID();
            FPluginManager.MenuDesignManager.Add(Id_MenuDesign, Id_MenuDesignParent, Id_Module, Caption, Level, tmpGUID);
          end;
        end;
      SERVER_COMMAND_DISCONNECT:
          FERPSocketClient.Close();
      SERVER_COMMAND_MESSAGE:
        begin
          TextMessage := Buffer.ReadString();
          Application.MessageBox(PChar(TextMessage), 'Сообщение от сервера', MB_OK or MB_ICONINFORMATION);
        end;
    end;
  finally
    Buffer.Free();
  end;
end;

procedure TClientManager.SetIsWinAuth(const aValue: Boolean);
begin
  FIsWinAuth := aValue;
end;

procedure TClientManager.SetPassword(const aValue: string);
begin
  FPassword := aValue;
end;

procedure TClientManager.SetUserLogin(const aValue: string);
begin
  FUserLogin := aValue;
end;

end.
