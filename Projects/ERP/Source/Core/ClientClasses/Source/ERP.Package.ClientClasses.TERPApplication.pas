unit ERP.Package.ClientClasses.TERPApplication;

interface

uses
  System.Types,
  ERP.Package.ClientInterface.IERPApplication,
  ERP.Package.ClientInterface.IDBConnection,
  ERP.Package.ClientInterface.IDBConnectionEx;

type
  TERPApplication = class(TInterfacedObject, IERPApplication)
  private
    FModuleConnection: IDBConnectionEx;
    function CreateFDConnection(aId_DataBase: Integer; aModule: TGUID): IDBConnection;
    function GetApplicationHandle: THandle;
    function GetApplicationMonitor: THandle;
    function GetApplicationClientBounds: TRect;
    function GetModuleConnection: IDBConnection;
    procedure OpenModule(aIdDataBase: Integer; const aGuid: TGUID);
  public
    procedure SetModuleConnection(aDBConnection: IDBConnectionEx);
  end;

implementation

uses
  Winapi.Windows,
  Vcl.Forms,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.ClientClasses.Variable,
  ERP.Package.ClientClasses.Types;

{ TERPApplication }

function TERPApplication.CreateFDConnection(aId_DataBase: Integer; aModule: TGUID): IDBConnection;
begin
  Result := ClientManager.DBConnectionManager.GetDBConnectionEx(aId_DataBase);
  if FModuleConnection.Id_DataBase <> aId_DataBase then
    FModuleConnection.AddDependedConnection(Result as IDBConnectionEx, aModule);
end;

function TERPApplication.GetApplicationClientBounds: TRect;
var
  ClientRect: PRect;
begin
  New(ClientRect);
  try
    Result.Create(PRect(SendMessage(Application.MainForm.Handle, ERPM_APP_GET_CLIENTRECT, WPARAM(ClientRect), 0))^);
  finally
    Dispose(ClientRect);
  end;
end;

function TERPApplication.GetApplicationHandle: THandle;
begin
  Result := Application.Handle;
end;

function TERPApplication.GetApplicationMonitor: THandle;
begin
  Result := Application.MainForm.Monitor.Handle;
end;

function TERPApplication.GetModuleConnection: IDBConnection;
begin
  Result := FModuleConnection;
end;

procedure TERPApplication.OpenModule(aIdDataBase: Integer; const aGuid: TGUID);
var
  OpenModuleInfo: TOpenModuleInfo;
begin
  ZeroMemory(@OpenModuleInfo, SizeOf(OpenModuleInfo));
  OpenModuleInfo.Id_DataBase := aIdDataBase;
  OpenModuleInfo.Guid := aGuid;
  SendMessage(Application.MainForm.Handle, ERPM_APP_MODULE_OPEN, WPARAM(Addr(OpenModuleInfo)), 0);
end;

procedure TERPApplication.SetModuleConnection(aDBConnection: IDBConnectionEx);
begin
  FModuleConnection := aDBConnection;
end;

end.
