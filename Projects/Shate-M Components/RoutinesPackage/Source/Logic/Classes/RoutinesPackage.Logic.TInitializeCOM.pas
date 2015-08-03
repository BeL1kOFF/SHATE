unit RoutinesPackage.Logic.TInitializeCOM;

interface

uses
  Winapi.ActiveX;

type
  TInitializeCOM = class(TInterfacedObject)
  strict private
    FNeedToUninitialize: Boolean;
  public
    constructor Create(const aCoInit: Integer = COINIT_MULTITHREADED + COINIT_SPEED_OVER_MEMORY);
    destructor Destroy(); override;
  end;

implementation

constructor TInitializeCOM.Create(const aCoInit: Integer);
begin
  inherited Create();
  FNeedToUninitialize := Succeeded(CoInitializeEx(nil, aCoInit));
end;

destructor TInitializeCOM.Destroy();
begin
  try
    if FNeedToUninitialize then
    begin
      CoUninitialize();
    end;
  finally
    inherited;
  end;
end;

end.
