unit ERP.Package.ClientInterface.IERPClientData;

interface

uses
  ERP.Package.ClientInterface.IERPApplication,
  ERP.Package.ClientInterface.IDBConnectionManager,
  ERP.Package.ClientInterface.IModuleAccess;

type
  IERPClientData = interface
  ['{485D3FFF-8C6D-48A7-9842-A085A98284C0}']
    function GetDBConnectionManager: IDBConnectionManager;
    function GetERPApplication: IERPApplication;
    function GetModuleAccess: IModuleAccess;

    property DBConnectionManager: IDBConnectionManager read GetDBConnectionManager;
    property ERPApplication: IERPApplication read GetERPApplication;
    property ModuleAccess: IModuleAccess read GetModuleAccess;
  end;

implementation

end.
