unit ERP.Package.ClientClasses.TERPClientData;

interface

uses
  System.SysUtils,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IERPApplication,
  ERP.Package.ClientInterface.IDBConnectionEx,
  ERP.Package.ClientInterface.IDBConnectionManager,
  ERP.Package.ClientInterface.IDBConnectionManagerEx,
  ERP.Package.ClientInterface.IModuleAccess;

type
  TERPClientData = class(TInterfacedObject, IERPClientData)
  private
    FERPApplication: IERPApplication;
    FDBConnectionManager: IDBConnectionManagerEx;
    FModuleAccess: IModuleAccess;
    function GetERPApplication: IERPApplication;
    function GetDBConnectionManager: IDBConnectionManager;
    function GetModuleAccess: IModuleAccess;
    procedure AssignModuleAccess(const aModuleAccess: TBytes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AssignConnection(aDBConnectionEx: IDBConnectionEx; const aModuleAccess: TBytes);
  end;

implementation

uses
  ERP.Package.ClientClasses.TERPApplication,
  ERP.Package.ClientClasses.TDBConnectionEx,
  ERP.Package.ClientClasses.TModuleAccess;

{ TERPClientData }

procedure TERPClientData.AssignConnection(aDBConnectionEx: IDBConnectionEx; const aModuleAccess: TBytes);
begin
  AssignModuleAccess(aModuleAccess);
  FDBConnectionManager := TDBConnectionEx(aDBConnectionEx).DBConnectionManagerEx;
  TERPApplication(FERPApplication).SetModuleConnection(aDBConnectionEx);
end;

procedure TERPClientData.AssignModuleAccess(const aModuleAccess: TBytes);
var
  k: Integer;
begin
  FModuleAccess := TModuleAccess.Create(True);
  for k := Low(aModuleAccess) to High(aModuleAccess) do
    TModuleAccess(FModuleAccess).Add(k + 1, aModuleAccess[k] = 1);
end;

constructor TERPClientData.Create;
begin
  FERPApplication := TERPApplication.Create();
end;

destructor TERPClientData.Destroy;
begin
  FDBConnectionManager := nil;
  FERPApplication := nil;
  inherited Destroy;
end;

function TERPClientData.GetDBConnectionManager: IDBConnectionManager;
begin
  Result := FDBConnectionManager;
end;

function TERPClientData.GetERPApplication: IERPApplication;
begin
  Result := FERPApplication;
end;

function TERPClientData.GetModuleAccess: IModuleAccess;
begin
  Result := FModuleAccess;
end;

end.
