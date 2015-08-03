unit ERP.Package.ClientClasses.TDBConnectionEx;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  ERP.Package.CustomClasses.TCustomDBConnection,
  ERP.Package.ClientInterface.IDBConnectionEx,
  ERP.Package.ClientInterface.IDBConnectionManagerEx;

type
  PDependedDBConnection = ^TDependedDBConnection;

  TDependedDBConnection = record
    DBConnectionEx: IDBConnectionEx;
    Module: TGUID;
  end;

  TDBConnectionEx = class(TCustomDBConnection, IDBConnectionEx)
  private
    // IDBConnection
    FDataBaseCaption: string;
    FId_DataBase: Integer;
    FTypeDB: Integer;
    FDependedList: TList<PDependedDBConnection>;
    FCookie: TBytes;
    function GetFDConnectionHandle: Pointer;
    function GetConnectionString: PChar;
    function GetDataBaseCaption: PChar;
    function GetId_DataBase: Integer;
    function GetTypeDB: Integer;
    procedure SetAppRole;
    procedure UnsetAppRole;
    function GetFDConnection: TFDConnection; { TODO 1 : Временное решение до устранения бага с SharedCliHandle }
  private
    // IDBConnectionEx
    FCountConnection: Integer;
    procedure SetDataBaseCaption(const aValue: PChar);
    procedure SetId_DataBase(const aValue: Integer);
    procedure SetTypeDB(const aValue: Integer);
    procedure AddDependedConnection(aIDBConnectionEx: IDBConnectionEx; aModule: TGUID);
    procedure ClearDepended; overload;
    procedure ClearDepended(aModule: TGUID); overload;
    procedure DecConnection(aModule: TGUID);
    function GetRolePassword: string;
    procedure IncConnection;
    procedure RecreateAppRole;
  private
    { [Weak] } FDBConnectionManagerEx: IDBConnectionManagerEx;
    function IsExistDependedDBConnection(aIDBConnectionEx: IDBConnectionEx; aModule: TGUID): Boolean;
  public
    constructor Create(aParent: IDBConnectionManagerEx); reintroduce;
    destructor Destroy; override;
    property DBConnectionManagerEx: IDBConnectionManagerEx read FDBConnectionManagerEx;
  end;

implementation

uses
  System.Types,
  System.Classes;

const
  APP_ROLE_PASSWORD = 'Vskexitdct[';

  PROC_INIT_APP_ROLE = 'InitAppRole';

  SQL_CREATE_APP_ROLE =
    'SET NOCOUNT ON ' +
    'BEGIN TRY ' +
    '  IF EXISTS(SELECT 1 FROM sys.database_principals WHERE type != ''A'' AND [name] = ''ShateMERP'') ' +
    '  BEGIN ' +
    '    SELECT -1, ''%s'' ' +
    '  END ' +
    '  ELSE ' +
    '  BEGIN ' +
    '    IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE type = ''A'' AND [name] = ''ShateMERP'') ' +
    '    BEGIN ' +
    '      CREATE APPLICATION ROLE ShateMERP WITH PASSWORD = %s ' +
    '    END ' +
    '    SELECT 0 ' +
    '  END ' +
    'END TRY ' +
    'BEGIN CATCH ' +
    '  SELECT -2, ''[%s '' + CAST(ERROR_NUMBER() AS NVARCHAR) + ''] '' + ERROR_MESSAGE() ' +
    'END CATCH';

resourcestring
  rsAppRoleErrorWrongObjectType = 'Существующий объект не является ролью приложения';
  rsError = 'Ошибка';

procedure TDBConnectionEx.AddDependedConnection(aIDBConnectionEx: IDBConnectionEx; aModule: TGUID);
var
  DependedDBConnection: PDependedDBConnection;
begin
  if not IsExistDependedDBConnection(aIDBConnectionEx, aModule) then
  begin
    aIDBConnectionEx.IncConnection;
    New(DependedDBConnection);
    DependedDBConnection^.DBConnectionEx := aIDBConnectionEx;
    DependedDBConnection^.Module := aModule;
    FDependedList.Add(DependedDBConnection);
  end;
end;

procedure TDBConnectionEx.ClearDepended;
var
  k: Integer;
begin
  for k := 0 to Pred(FDependedList.Count) do
  begin
    PDependedDBConnection(FDependedList.Items[k])^.DBConnectionEx.DecConnection(GUID_NULL);
    PDependedDBConnection(FDependedList.Items[k])^.DBConnectionEx := nil;
    Dispose(FDependedList.Items[k]);
  end;
  FDependedList.Clear();
end;

procedure TDBConnectionEx.ClearDepended(aModule: TGUID);
var
  k: Integer;
begin
  for k := Pred(FDependedList.Count) downto 0 do
  begin
    if IsEqualGUID(PDependedDBConnection(FDependedList.Items[k])^.Module, aModule) then
    begin
      PDependedDBConnection(FDependedList.Items[k])^.DBConnectionEx.DecConnection(GUID_NULL);
      PDependedDBConnection(FDependedList.Items[k])^.DBConnectionEx := nil;
      Dispose(FDependedList.Items[k]);
      FDependedList.Delete(k);
    end;
  end;
end;

constructor TDBConnectionEx.Create(aParent: IDBConnectionManagerEx);
begin
  inherited Create();
  Pointer(FDBConnectionManagerEx) := Pointer(aParent);
  FDataBaseCaption := EmptyStr;
  FId_DataBase := -1;
  FTypeDB := -1;
  FCountConnection := 0;
  FDependedList := TList<PDependedDBConnection>.Create();
  SetLength(FCookie, 0);
end;

procedure TDBConnectionEx.DecConnection(aModule: TGUID);
begin
  Dec(FCountConnection);
  if FCountConnection = 0 then
  begin
    ClearDepended();
    UnsetAppRole();
    Disconnect();
  end
  else
  begin
    ClearDepended(aModule);
  end;
end;

destructor TDBConnectionEx.Destroy;
begin
  ClearDepended();
  FDependedList.Free();
  Pointer(FDBConnectionManagerEx) := nil;
  inherited;
end;

function TDBConnectionEx.GetConnectionString: PChar;
begin
  Result := PChar(FDConnection.ConnectionString);
end;

function TDBConnectionEx.GetDataBaseCaption: PChar;
begin
  Result := PChar(FDataBaseCaption);
end;

function TDBConnectionEx.GetFDConnection: TFDConnection;
begin
  Result := FDConnection;
end;

function TDBConnectionEx.GetFDConnectionHandle: Pointer;
begin
  Result := FDConnection.CliHandle;
end;

function TDBConnectionEx.GetId_DataBase: Integer;
begin
  Result := FId_DataBase;
end;

function TDBConnectionEx.GetRolePassword: string;
begin
  Result := APP_ROLE_PASSWORD;
end;

function TDBConnectionEx.GetTypeDB: Integer;
begin
  Result := FTypeDB;
end;

procedure TDBConnectionEx.IncConnection;
begin
  Inc(FCountConnection);
  if FCountConnection = 1 then
  begin
    Connect();
    SetAppRole();
  end;
end;

function TDBConnectionEx.IsExistDependedDBConnection(aIDBConnectionEx: IDBConnectionEx; aModule: TGUID): Boolean;
var
  k: Integer;
begin
  Result := False;
  for k := 0 to Pred(FDependedList.Count) do
  begin
    if (FDependedList.Items[k].DBConnectionEx = aIDBConnectionEx) and (FDependedList.Items[k].Module = aModule) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TDBConnectionEx.RecreateAppRole;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection;
    FDQuery.SQL.Text :=
      Format(SQL_CREATE_APP_ROLE, [rsAppRoleErrorWrongObjectType, QuotedStr(GetRolePassword()), rsError]);
    FDQuery.Open();
    try
      if FDQuery.FieldCount > 0 then
      begin
        if FDQuery.Fields[0].AsInteger < 0 then
        begin
          raise EDBConnectionEx.Create(FDQuery.Fields[1].AsString);
        end;
      end;
    finally
      FDQuery.Close();
    end;

    FDQuery.SQL.Text := PROC_INIT_APP_ROLE;
    FDQuery.Open();
    try
      if FDQuery.FieldCount > 0 then
      begin
        if FDQuery.Fields[0].AsInteger < 0 then
        begin
          raise EDBConnectionEx.Create(FDQuery.Fields[1].AsString);
        end;
      end;
    finally
      FDQuery.Close();
    end;
  finally
    FDQuery.Free();
  end;
end;

procedure TDBConnectionEx.SetAppRole;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection;
    FDQuery.SQL.Text := Format(
      'DECLARE @Cookie VARBINARY(8000); ' +
      'EXEC sp_setapprole %s, %s, %s, 1, @Cookie OUTPUT;' +
      'SELECT @Cookie AS [Cookie]',
      [QuotedStr('ShateMERP'), QuotedStr(GetRolePassword()), QuotedStr('none')]);
    try
      FDQuery.Open();
      FCookie := FDQuery.FieldByName('Cookie').AsBytes;
    finally
      FDQuery.Close();
    end;
  finally
    FDQuery.Free();
  end;
end;

procedure TDBConnectionEx.SetDataBaseCaption(const aValue: PChar);
begin
  FDataBaseCaption := aValue;
end;

procedure TDBConnectionEx.SetId_DataBase(const aValue: Integer);
begin
  FId_DataBase := aValue;
end;

procedure TDBConnectionEx.SetTypeDB(const aValue: Integer);
begin
  FTypeDB := aValue;
end;

procedure TDBConnectionEx.UnsetAppRole;
var
  FDQuery: TFDQuery;
  TempCookie: TBytes;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection;
    SetLength(TempCookie, Length(FCookie) * 2);
    BinToHex(FCookie, 0, TempCookie, 0, Length(FCookie));
    FDQuery.SQL.Text := Format(
      'DECLARE @Cookie VARBINARY(8000) = 0x%s; ' +
      'EXEC sp_unsetapprole @Cookie',
      [StringOf(TempCookie)]);
    FDQuery.ExecSQL();
    SetLength(FCookie, 0);
  finally
    FDQuery.Free();
  end;
end;

end.
