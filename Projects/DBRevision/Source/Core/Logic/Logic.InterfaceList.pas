unit Logic.InterfaceList;

interface

type
  IDataBase = interface
  ['{1180863A-B8CB-4610-955F-FF1FA0855C5C}']
    function GetId_DataBase: Integer;
    function GetServer: string;
    function GetDataBase: string;
    function GetId_Template: Integer;

    procedure SetId_DataBase(aId_DataBase: Integer);
    procedure SetServer(const aServer: string);
    procedure SetDataBase(const aDataBase: string);
    procedure SetId_Template(aId_Template: Integer);

    property Id_DataBase: Integer read GetId_DataBase write SetId_DataBase;
    property Server: string read GetServer write SetServer;
    property DataBase: string read GetDataBase write SetDataBase;
    property Id_Template: Integer read GetId_Template write SetId_Template;
  end;

implementation

end.
