unit ERP.Package.ClientClasses.TPackageModuleOpen;

interface

uses
  System.Types,
  System.SysUtils,
  System.Generics.Defaults,
  Vcl.Forms,
  ERP.Package.ClientClasses.TPackageModuleScan,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IDBConnectionEx;

type
  TPackageModuleOpen = class(TPackageModuleItem)
  private
    FDBConnectionEx: IDBConnectionEx;
    FERPClientData: IERPClientData;
    FFormHandle: THandle;
    FPageName: string;
    function GetFormHandle: THandle;
  public
    constructor Create(aDBConnectionEx: IDBConnectionEx); reintroduce;
    destructor Destroy; override;
    function Open: Boolean; override;
    procedure Close; override;
    procedure CreateForm(const aAccess: TBytes);
    procedure SendMainResize;
    property ERPClientData: IERPClientData read FERPClientData;
    property FormHandle: THandle read GetFormHandle;
    property PageName: string read FPageName write FPageName;
  end;

  TPackageModuleOpenComparer = class(TComparer<TPackageModuleOpen>)
  public
    function Compare(const Left, Right: TPackageModuleOpen): Integer; override;
  end;

implementation

uses
  Winapi.Windows,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.ClientClasses.TERPClientData;

type
  EPackageModuleCreateForm = class(Exception);

{ TPackageModuleOpen }

procedure TPackageModuleOpen.Close;
begin
  if Handle > 0 then
    FDBConnectionEx.DecConnection(GetModuleInfo.GUID);
  inherited Close();
end;

constructor TPackageModuleOpen.Create(aDBConnectionEx: IDBConnectionEx);
begin
  inherited Create();
  FDBConnectionEx := aDBConnectionEx;
  FERPClientData := TERPClientData.Create();
end;

procedure TPackageModuleOpen.CreateForm(const aAccess: TBytes);
type
  TFuncCreateForm = function(aERPClientData: IERPClientData): THandle; stdcall;
var
  p: Pointer;
begin
  p := GetProcAddress(Handle, 'CreateForm');
  if p <> nil then
  begin
    TERPClientData(FERPClientData).AssignConnection(FDBConnectionEx, aAccess);
    FFormHandle := TFuncCreateForm(p)(FERPClientData)
  end
  else
    FFormHandle := 0;
end;

destructor TPackageModuleOpen.Destroy;
begin
  FERPClientData := nil;
  inherited Destroy;
end;

function TPackageModuleOpen.GetFormHandle: THandle;
begin
  if FFormHandle <> 0 then
    Result := FFormHandle
  else
    raise EPackageModuleCreateForm.Create(Format('Форма в модуле ''%s'' не создана', [FileName]));
end;

function TPackageModuleOpen.Open: Boolean;
begin
  Result := inherited Open();
  if Result then
    FDBConnectionEx.IncConnection();
end;

procedure TPackageModuleOpen.SendMainResize;
begin
  SendMessage(FFormHandle, ERPM_MAIN_RESIZE, 0, 0);
end;

{ TPackageModuleOpenComparer }

function TPackageModuleOpenComparer.Compare(const Left, Right: TPackageModuleOpen): Integer;
begin
  Result := AnsiCompareText(Left.GetModuleInfo.Name, Right.GetModuleInfo.Name);
end;

end.
