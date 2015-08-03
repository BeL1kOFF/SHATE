unit ERP.Package.ERPClasses.TPackageSystemScan;

interface

uses
  ERP.Package.CustomClasses.TCustomPackageScan;

type
  TPackageSystemItem = class(TCustomPackageItem)
  protected
    function CheckForExportedFunctions: Boolean; override;
  end;

  TPackageSystemScan = class(TCustomPackageScan)
  protected
    function CreateItem: TCustomPackageItem; override;
  public
    constructor Create; override;
  end;

implementation

{ TPackageSystemScan }

constructor TPackageSystemScan.Create;
begin
  inherited Create();
  CheckDuplicate := True;
end;

function TPackageSystemScan.CreateItem: TCustomPackageItem;
begin
  Result := TPackageSystemItem.Create();
end;

{ TPackageSystemItem }

function TPackageSystemItem.CheckForExportedFunctions: Boolean;
begin
  Result := True;
end;

end.
