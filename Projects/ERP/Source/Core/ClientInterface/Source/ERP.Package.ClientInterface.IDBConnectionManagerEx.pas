unit ERP.Package.ClientInterface.IDBConnectionManagerEx;

interface

uses
  ERP.Package.ClientInterface.IDBConnectionManager,
  ERP.Package.ClientInterface.IDBConnectionEx;

type
  IDBConnectionManagerEx = interface(IDBConnectionManager)
  ['{C2EDB9EF-D65C-49E5-8E82-BBA60CC0A656}']
    function GetActiveConnection: IDBConnectionEx;
    function GetDBConnectionEx(aId_DataBase: Integer): IDBConnectionEx;
    function GetItems(aIndex: Integer): IDBConnectionEx;
    procedure AddConnection(aId_DataBase: Integer; const aServer, aDataBase, aDataBaseCaption: string; aTypeDB: Integer;
      const aUser, aPassword: string; aIsWinAuth: Boolean);
    procedure SetActiveConnection(aId_DataBase: Integer);
    procedure SetId_User(const aValue: Integer);
    procedure SetUserName(const aValue: PChar);

    property ActiveConnection: IDBConnectionEx read GetActiveConnection;
    property Id_User: Integer read GetId_User write SetId_User;
    property Items[aIndex: Integer]: IDBConnectionEx read GetItems;
    property UserName: PChar read GetUserName write SetUserName;
  end;

implementation

end.
