library SPCatalogAPI;

uses
  ComServ,
  CatalogUtils in 'CatalogUtils.pas' {ServProgCatalog: CoClass},
  uDM in 'uDM.pas' {DM: TDataModule};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
