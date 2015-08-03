unit ERP.Package.ClientClasses.Variable;

interface

uses
  ERP.Package.ClientClasses.IClientManager;

var
  ClientManager: IClientManager;

implementation

uses
  ERP.Package.ClientClasses.TClientManager;

initialization
  ClientManager := TClientManager.Create();

finalization
  ClientManager := nil;

end.
