unit ERP.Package.ClientInterface.IDBConnection;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client;

type
  IDBConnection = interface
  ['{EE9B8C88-36CF-46D2-87E5-E7B00E5EE20F}']
    function GetFDConnectionHandle: Pointer;
    function GetConnectionString: PChar;
    function GetDataBase: PChar;
    function GetDataBaseCaption: PChar;
    function GetId_DataBase: Integer;
    function GetServer: PChar;
    function GetTypeDB: Integer;
    function GetUser: PChar;

    procedure SetAppRole;
    procedure UnsetAppRole;

    function GetFDConnection: TFDConnection;{ TODO 1 : Временное решение до устранения бага с SharedCliHandle }

    property FDConnectionHandle: Pointer read GetFDConnectionHandle;
    property ConnectionString: PChar read GetConnectionString;
    property DataBase: PChar read GetDataBase;
    property DataBaseCaption: PChar read GetDataBaseCaption;
    property Id_DataBase: Integer read GetId_DataBase;
    property Server: PChar read GetServer;
    property TypeDB: Integer read GetTypeDB;
    property User: PChar read GetUser;
    property FDConnection: TFDConnection read GetFDConnection;{ TODO 1 : Временное решение до устранения бага с SharedCliHandle }
  end;

implementation

end.
