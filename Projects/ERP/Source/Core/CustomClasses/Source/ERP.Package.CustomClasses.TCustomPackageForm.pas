unit ERP.Package.CustomClasses.TCustomPackageForm;

interface

uses
  Vcl.Forms;

type
  TCustomPackageForm = class
  private
    FBPLPath: string;
    FHandle: HMODULE;
    function GetFormClass(const aProcName: string): TFormClass;
  protected
    property FormClass[const aProcName: string]: TFormClass read GetFormClass;
  public
    constructor Create(const aBplPath: string);
    destructor Destroy; override;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.IOUtils,
  ERP.Package.CustomClasses.Consts;

{ TCustomPackageForm }

constructor TCustomPackageForm.Create(const aBplPath: string);
begin
  FHandle := 0;
  FBPLPath := aBplPath;
end;

destructor TCustomPackageForm.Destroy;
begin
  if FHandle > 0 then
    UnloadPackage(FHandle);
  inherited Destroy();
end;

function TCustomPackageForm.GetFormClass(const aProcName: string): TFormClass;
type
  TFuncRegisterForm = function: TFormClass;
var
  p: Pointer;
begin
  if FHandle = 0 then
    if TFile.Exists(FBPLPath) then
      FHandle := LoadPackage(FBPLPath);
  if FHandle > 0 then
  begin
    try
      p := GetProcAddress(FHandle, PChar(aProcName));
      if p <> nil then
        Result := TFuncRegisterForm(p)
      else
      begin
        UnloadPackage(FHandle);
        FHandle := 0;
        raise Exception.Create(Format(RsPackageFormNotProcLibrary, [aProcName, ExtractFilePath(FBPLPath)]));
      end;
    except
    begin
      UnloadPackage(FHandle);
      FHandle := 0;
      raise;
    end;
    end;
  end
  else
    raise Exception.Create(Format(RsPackageFormNotLibrary, [ExtractFileName(FBPLPath)]));
end;

end.
