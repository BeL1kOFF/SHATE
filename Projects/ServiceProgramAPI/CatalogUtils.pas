unit CatalogUtils;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, SPCatalogAPI_TLB, StdVcl,
  uDM;

type
  TServProgCatalogServProgCatalog = class(TAutoObject, IServProgCatalog)
  private
    fData: TDM;
  protected
    function GetCrosses(var aCode, aBrand: WideString): WideString; safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses ComServ, Windows, SysUtils;

//tools
function GetModulePath(Instance: THandle): string;
var
  buffer: array [0..MAX_PATH] of Char;
begin
  GetModuleFileName( Instance, buffer, MAX_PATH);
  Result := buffer;
  Result := ExtractFilePath(Result);
end;


procedure TServProgCatalogServProgCatalog.Initialize;
begin
  inherited;

  fData := TDM.Create(nil);
  fData.InitDatabase(GetModulePath(Hinstance));
end;

destructor TServProgCatalogServProgCatalog.Destroy;
begin
  fData.Free;
  //
  inherited;
end;

function TServProgCatalogServProgCatalog.GetCrosses(var aCode, aBrand: WideString): WideString;
begin
  Result := fData.GetCrosses(aCode, aBrand);
end;



initialization
  TAutoObjectFactory.Create(ComServer, TServProgCatalogServProgCatalog, Class_ServProgCatalog,
    ciMultiInstance, tmApartment);
end.
