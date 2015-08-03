unit ERP.Package.ClientInterface.IDBConnectionManager;

interface

uses
  ERP.Package.ClientInterface.IDBConnection;

type
  IDBConnectionManager = interface
  ['{1BA3B5D9-3640-456F-BD73-9170803836EC}']
    function GetCount: Integer;
    function GetId_User: Integer;
    function GetItems(aIndex: Integer): IDBConnection;
    function GetUserName: PChar;

    property Count: Integer read GetCount;
    property Id_User: Integer read GetId_User;
    property Items[aIndex: Integer]: IDBConnection read GetItems;
    property UserName: PChar read GetUserName;
  end;

implementation

end.
