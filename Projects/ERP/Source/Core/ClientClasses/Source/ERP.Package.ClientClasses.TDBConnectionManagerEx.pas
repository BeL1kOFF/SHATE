unit ERP.Package.ClientClasses.TDBConnectionManagerEx;

interface

uses
  System.Generics.Collections,
  ERP.Package.ClientInterface.IDBConnectionManager,
  ERP.Package.ClientInterface.IDBConnectionManagerEx,
  ERP.Package.ClientInterface.IDBConnection,
  ERP.Package.ClientInterface.IDBConnectionEx;

type
  TDBConnectionManagerEx = class(TInterfacedObject, IDBConnectionManager, IDBConnectionManagerEx)
  private
    FActiveConnectionIndex: Integer;
    FList: TList<IDBConnectionEx>;
    FId_User: Integer;
    FUserName: string;
    function GetActiveConnection: IDBConnectionEx;
    function GetCount: Integer;
    function GetDBConnectionEx(aId_DataBase: Integer): IDBConnectionEx;
    function GetItems(aIndex: Integer): IDBConnection;
    function GetItemsEx(aIndex: Integer): IDBConnectionEx;
    function GetId_User: Integer;
    function GetUserName: PChar;
    procedure AddConnection(aId_DataBase: Integer; const aServer, aDataBase, aDataBaseCaption: string; aTypeDB: Integer;
      const aUser, aPassword: string; aIsWinAuth: Boolean);
    procedure SetActiveConnection(aId_DataBase: Integer);
    procedure Clear;
    procedure SetId_User(const aValue: Integer);
    procedure SetUserName(const aValue: PChar);
    function IDBConnectionManager.GetItems = GetItems;
    function IDBConnectionManagerEx.GetItems = GetItemsEx;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils,
  ERP.Package.ClientClasses.TDBConnectionEx;

type
  ExceptionDBConnectionManager = class(Exception);

{ TDBConnectionManagerEx }

procedure TDBConnectionManagerEx.AddConnection(aId_DataBase: Integer; const aServer, aDataBase, aDataBaseCaption: string;
  aTypeDB: Integer; const aUser, aPassword: string; aIsWinAuth: Boolean);
var
  ERPDBConnectionEx: IDBConnectionEx;
begin
  ERPDBConnectionEx := TDBConnectionEx.Create(Self);
  ERPDBConnectionEx.Id_DataBase := aId_DataBase;
  ERPDBConnectionEx.Server := PChar(aServer);
  ERPDBConnectionEx.DataBase := PChar(aDataBase);
  ERPDBConnectionEx.DataBaseCaption := PChar(aDataBaseCaption);
  ERPDBConnectionEx.TypeDB := aTypeDB;
  ERPDBConnectionEx.User := PChar(aUser);
  ERPDBConnectionEx.Password := PChar(aPassword);
  ERPDBConnectionEx.IsWinAuth := aIsWinAuth;
  FList.Add(ERPDBConnectionEx);
end;

procedure TDBConnectionManagerEx.Clear;
var
  k: Integer;
begin
  for k := 0 to FList.Count - 1 do
    FList.Items[k] := nil;
  FList.Clear();
end;

constructor TDBConnectionManagerEx.Create;
begin
  FList := TList<IDBConnectionEx>.Create();
end;

destructor TDBConnectionManagerEx.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TDBConnectionManagerEx.GetActiveConnection: IDBConnectionEx;
begin
  Result := FList.Items[FActiveConnectionIndex];
end;

function TDBConnectionManagerEx.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TDBConnectionManagerEx.GetDBConnectionEx(aId_DataBase: Integer): IDBConnectionEx;
var
  k: Integer;
begin
  for k := 0 to GetCount() - 1 do
    if GetItemsEx(k).Id_DataBase = aId_DataBase then
    begin
      Result := GetItemsEx(k);
      Exit;
    end;
  raise ExceptionDBConnectionManager.Create('Идентификатор БД в Connection не обнаружен!');
end;

function TDBConnectionManagerEx.GetId_User: Integer;
begin
  Result := FId_User;
end;

function TDBConnectionManagerEx.GetItems(aIndex: Integer): IDBConnection;
begin
  Result := GetItemsEx(aIndex);
end;

function TDBConnectionManagerEx.GetItemsEx(aIndex: Integer): IDBConnectionEx;
begin
  Result := FList.Items[aIndex];
end;

function TDBConnectionManagerEx.GetUserName: PChar;
begin
  Result := PChar(FUserName);
end;

procedure TDBConnectionManagerEx.SetActiveConnection(aId_DataBase: Integer);
var
  k: Integer;
begin
  for k := 0 to FList.Count - 1 do
    if GetItemsEx(k).Id_DataBase = aId_DataBase then
    begin
      FActiveConnectionIndex := k;
      Exit;
    end;
  raise ExceptionDBConnectionManager.Create('Идентификатор БД в Connection не обнаружен!');
end;

procedure TDBConnectionManagerEx.SetId_User(const aValue: Integer);
begin
  FId_User := aValue;
end;

procedure TDBConnectionManagerEx.SetUserName(const aValue: PChar);
begin
  FUserName := aValue;
end;

end.
