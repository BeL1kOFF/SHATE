unit ERP.Package.ClientInterface.IModuleInfo;

interface

type
  IModuleInfo = interface
  ['{67D18CF3-83C6-4F0A-94C5-11EB3D489776}']
    function GetGUID: TGUID;
    function GetName: PChar;
    function GetTypeDB: Integer;
    function GetTypeGuid: TGUID;
    procedure SetGUID(const aValue: TGUID);
    procedure SetName(const aValue: PChar);
    procedure SetTypeDB(const aValue: Integer);
    procedure SetTypeGuid(const aValue: TGUID);

    property GUID: TGUID read GetGUID write SetGUID;
    property Name: PChar read GetName write SetName;
    property TypeDB: Integer read GetTypeDB write SetTypeDB;
    property TypeGuid: TGUID read GetTypeGuid write SetTypeGuid;
  end;

implementation

end.
