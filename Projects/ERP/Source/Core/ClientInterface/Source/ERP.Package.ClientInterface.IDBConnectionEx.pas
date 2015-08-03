unit ERP.Package.ClientInterface.IDBConnectionEx;

interface

uses
  ERP.Package.ClientInterface.IDBConnection,
  System.SysUtils;

type
  IDBConnectionEx = interface(IDBConnection)
    ['{B25742DF-814E-4F6B-9547-FF9F3ECAB712}']
    function GetIsWinAuth: Boolean;
    function GetPassword: PChar;
    procedure AddDependedConnection(aIDBConnectionEx: IDBConnectionEx; aModule: TGUID);
    procedure DecConnection(aModule: TGUID);
    procedure IncConnection;
    procedure RecreateAppRole;
    procedure SetDataBase(const aValue: PChar);
    procedure SetDataBaseCaption(const aValue: PChar);
    procedure SetId_DataBase(const aValue: Integer);
    procedure SetIsWinAuth(const aValue: Boolean);
    procedure SetPassword(const aValue: PChar);
    procedure SetServer(const aValue: PChar);
    procedure SetTypeDB(const aValue: Integer);
    procedure SetUser(const aValue: PChar);

    property DataBase: PChar read GetDataBase write SetDataBase;
    property DataBaseCaption: PChar read GetDataBaseCaption write SetDataBaseCaption;
    property Id_DataBase: Integer read GetId_DataBase write SetId_DataBase;
    property IsWinAuth: Boolean read GetIsWinAuth write SetIsWinAuth;
    property Password: PChar read GetPassword write SetPassword;
    property Server: PChar read GetServer write SetServer;
    property TypeDB: Integer read GetTypeDB write SetTypeDB;
    property User: PChar read GetUser write SetUser;
  end;

  EDBConnectionEx = class(Exception);

implementation

end.
