unit ERP.Package.ClientClasses.TPackageModuleScan;

interface

uses
  ERP.Package.CustomClasses.TCustomPackageScan,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess;

type
  TPackageModuleItem = class(TCustomPackageItem)
  private
    FAccess: string;
    FModuleInfo: IModuleInfo;
    FModuleAccess: IModuleAccess;
    FIsCorrupt: Boolean;
  protected
    function CheckForExportedFunctions: Boolean; override;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetModuleInfo: IModuleInfo;
    function GetRegisterAccess: IModuleAccess;
    function GetIcon(aSize: Integer): THandle;
    property Access: string read FAccess write FAccess;
    property IsCorrupt: Boolean read FIsCorrupt write FIsCorrupt;
  end;

  TPackageModuleScan = class(TCustomPackageScan)
  private
    function GetPackageModuleItem(aGuid: TGUID): TPackageModuleItem;
  protected
    function CreateItem: TCustomPackageItem; override;
  public
    property Items[aGuid: TGUID]: TPackageModuleItem read GetPackageModuleItem; default;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  ERP.Package.ClientClasses.TModuleInfo,
  ERP.Package.ClientClasses.TModuleAccess;

{ TPackageModuleScan }

function TPackageModuleScan.CreateItem: TCustomPackageItem;
begin
  Result := TPackageModuleItem.Create();
end;

function TPackageModuleScan.GetPackageModuleItem(aGuid: TGUID): TPackageModuleItem;
var
  k: Integer;
begin
  Result := nil;
  for k := 0 to Count - 1 do
    if not (Items[k] as TPackageModuleItem).IsCorrupt then
      try
        if (Items[k] as TPackageModuleItem).GetModuleInfo.Guid = aGuid then
        begin
          Result := Items[k] as TPackageModuleItem;
          Break;
        end;
      except
        (Items[k] as TPackageModuleItem).IsCorrupt := True;
      end;
end;

{ TPackageModuleItem }

function TPackageModuleItem.CheckForExportedFunctions: Boolean;
begin
  Result := IsExistsProc('CreateForm') and IsExistsProc('SetModuleInfo') and IsExistsProc('RegisterAccess');
end;

constructor TPackageModuleItem.Create;
begin
  FModuleInfo := TModuleInfo.Create();
  FModuleAccess := TModuleAccess.Create(False);
  FIsCorrupt := False;
end;

destructor TPackageModuleItem.Destroy;
begin
  FModuleAccess := nil;
  FModuleInfo := nil;
  inherited Destroy;
end;

function TPackageModuleItem.GetIcon(aSize: Integer): THandle;
var
  oldHandle: THandle;
begin
  oldHandle := Handle;
  if Handle = 0 then
    Open();
  try
    Result := LoadIcon(Handle, PChar(Format('%s%d', ['IconModule', aSize])));
  finally
    if oldHandle = 0 then
      Close();
  end;
end;

function TPackageModuleItem.GetModuleInfo: IModuleInfo;
type
  TProcSetModuleInfo = procedure (aModuleInfo: IModuleInfo); stdcall;
var
  p: Pointer;
  oldHandle: THandle;
begin
  oldHandle := Handle;
  if Handle = 0 then
    Open();
  try
    p := GetProcAddress(Handle, 'SetModuleInfo');
    if p <> nil then
      TProcSetModuleInfo(p)(FModuleInfo)
    else
      FModuleInfo := nil;
    Result := FModuleInfo;
  finally
    if oldHandle = 0 then
      Close();
  end;
end;

function TPackageModuleItem.GetRegisterAccess: IModuleAccess;
type
  TProcRegisterAccess = procedure (aModuleAccess: IModuleAccess); stdcall;
var
  p: Pointer;
  oldHandle: THandle;
begin
  oldHandle := Handle;
  if Handle = 0 then
    Open();
  try
    p := GetProcAddress(Handle, 'RegisterAccess');
    if p <> nil then
      TProcRegisterAccess(p)(FModuleAccess)
    else
      FModuleAccess := nil;
    Result := FModuleAccess;
  finally
    if oldHandle = 0 then
      Close();
  end;
end;

end.
