unit ERP.Package.CustomClasses.TCustomDBConnection;

interface

uses
  FireDAC.Stan.Def,
  FireDAC.Phys.MSSQL,
  FireDAC.DApt,
  FireDAC.Stan.Async,
  FireDAC.Comp.Client;

type
  TCustomDBConnection = class(TInterfacedObject)
  private
    FFDConnection: TFDConnection;
    FDataBase: string;
    FIsWinAuth: Boolean;
    FPassword: string;
    FServer: string;
    FUser: string;
    procedure InitConnection;
  protected
    function GetFDConnection: TFDConnection;
    function GetDataBase: PChar;
    function GetIsWinAuth: Boolean;
    function GetPassword: PChar;
    function GetServer: PChar;
    function GetUser: PChar;
    procedure SetDataBase(const aValue: PChar);
    procedure SetIsWinAuth(const aValue: Boolean);
    procedure SetPassword(const aValue: PChar);
    procedure SetServer(const aValue: PChar);
    procedure SetUser(const aValue: PChar);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    property FDConnection: TFDConnection read GetFDConnection;
    property DataBase: PChar read GetDataBase write SetDataBase;
    property IsWinAuth: Boolean read GetIsWinAuth write SetIsWinAuth;
    property Password: PChar read GetPassword write SetPassword;
    property Server: PChar read GetServer write SetServer;
    property User: PChar read GetUser write SetUser;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Option;

const
  STR_CONNECTION = 'Server=%s;Database=%s;OSAuthent=%s;DriverID=%s;User_Name=%s;Password=%s;';

{ TCustomDBConnection }

procedure TCustomDBConnection.Connect;
var
  IsWinAuthStr: string;
begin
  if not FFDConnection.Connected then
  begin
    if FIsWinAuth then
      IsWinAuthStr := 'Yes'
    else
      IsWinAuthStr := 'No';
    FFDConnection.ConnectionString := Format(STR_CONNECTION, [FServer, FDataBase, IsWinAuthStr, 'MSSQL', FUser, FPassword]);
    FFDConnection.Connected := True;
  end;
end;

constructor TCustomDBConnection.Create;
begin
  FDataBase := '';
  FIsWinAuth := True;
  FPassword := '';
  FServer := '';
  FUser := '';
  InitConnection();
end;

destructor TCustomDBConnection.Destroy;
begin
  FFDConnection.Free();
  inherited Destroy();
end;

procedure TCustomDBConnection.Disconnect;
begin
  FFDConnection.Connected := False;
end;

function TCustomDBConnection.GetDataBase: PChar;
begin
  Result := PChar(FDataBase);
end;

function TCustomDBConnection.GetFDConnection: TFDConnection;
begin
  Result := FFDConnection;
end;

function TCustomDBConnection.GetIsWinAuth: Boolean;
begin
  Result := FIsWinAuth;
end;

function TCustomDBConnection.GetPassword: PChar;
begin
  Result := PChar(FPassword);
end;

function TCustomDBConnection.GetServer: PChar;
begin
  Result := PChar(FServer);
end;

function TCustomDBConnection.GetUser: PChar;
begin
  Result := PChar(FUser);
end;

procedure TCustomDBConnection.InitConnection;
begin
  FFDConnection := TFDConnection.Create(nil);
  FFDConnection.LoginPrompt := False;
  FFDConnection.FetchOptions.AutoClose := False;
  FFDConnection.FetchOptions.Mode := fmAll;
  FFDConnection.ResourceOptions.SilentMode := True;
  FFDConnection.ResourceOptions.DirectExecute := True;
  FFDConnection.ResourceOptions.MacroCreate := False;
  FFDConnection.ResourceOptions.MacroExpand := False;
end;

procedure TCustomDBConnection.SetDataBase(const aValue: PChar);
begin
  FDataBase := aValue;
end;

procedure TCustomDBConnection.SetIsWinAuth(const aValue: Boolean);
begin
  FIsWinAuth := aValue;
end;

procedure TCustomDBConnection.SetPassword(const aValue: PChar);
begin
  FPassword := aValue;
end;

procedure TCustomDBConnection.SetServer(const aValue: PChar);
begin
  FServer := aValue;
end;

procedure TCustomDBConnection.SetUser(const aValue: PChar);
begin
  FUser := aValue;
end;

end.
