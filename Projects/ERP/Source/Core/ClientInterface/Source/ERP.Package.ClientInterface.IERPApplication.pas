unit ERP.Package.ClientInterface.IERPApplication;

interface

uses
  System.Types,
  ERP.Package.ClientInterface.IDBConnection;

type
  IERPApplication = interface
  ['{450D7522-AA75-40B5-91D3-B9C738D2E1D2}']
    function CreateFDConnection(aId_DataBase: Integer; aModule: TGUID): IDBConnection;
    function GetApplicationClientBounds: TRect;
    function GetApplicationHandle: THandle;
    function GetApplicationMonitor: THandle;
    function GetModuleConnection: IDBConnection;
    procedure OpenModule(aIdDataBase: Integer; const aGuid: TGUID);

    property ApplicationClientBounds: TRect read GetApplicationClientBounds;
    property ApplicationHandle: THandle read GetApplicationHandle;
    property ApplicationMonitor: THandle read GetApplicationMonitor;
    property ModuleConnection: IDBConnection read GetModuleConnection;
  end;

implementation

end.
