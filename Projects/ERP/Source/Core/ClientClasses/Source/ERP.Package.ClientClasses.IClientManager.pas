unit ERP.Package.ClientClasses.IClientManager;

interface

uses
  System.Win.ScktComp,
  ERP.Package.ClientClasses.TPluginManager,
  ERP.Package.ClientClasses.TWindowManager,
  ERP.Package.ClientClasses.TERPSocketClient,
  ERP.Package.ClientInterface.IDBConnectionManagerEx;

type
  IClientManager = interface
  ['{6196D0AB-A1AC-4C46-8CEA-F4F1999EE548}']
    function GetDBConnectionManager: IDBConnectionManagerEx;
    function GetIsWinAuth: Boolean;
    function GetPassword: string;
    function GetPluginManager: TPluginManager;
    function GetSocketClient: TERPSocketClient;
    function GetWindowManager: TWindowManager;
    function GetUserLogin: string;
    procedure SetIsWinAuth(const aValue: Boolean);
    procedure SetPassword(const aValue: string);
    procedure SetUserLogin(const aValue: string);

    property DBConnectionManager: IDBConnectionManagerEx read GetDBConnectionManager;
    property IsWinAuth: Boolean read GetIsWinAuth write SetIsWinAuth;
    property Password: string read GetPassword write SetPassword;
    property PluginManager: TPluginManager read GetPluginManager;
    property SocketClient: TERPSocketClient read GetSocketClient;
    property UserLogin: string read GetUserLogin write SetUserLogin;
    property WindowManager: TWindowManager read GetWindowManager;
  end;

implementation

end.
