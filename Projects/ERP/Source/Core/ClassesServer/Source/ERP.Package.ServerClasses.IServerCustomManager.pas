unit ERP.Package.ServerClasses.IServerCustomManager;

interface

uses
  Winapi.WinSock,
  System.SysUtils,
  ERP.Package.Classes.TERPSocketStream;

type
  TSocketArray = TArray<TSocket>;

  TServerManagerType = (smtUnknown, smtClient, smtService);

  IServerCustomManager = interface
  ['{D3C52610-3DC9-4F25-BACA-F8DE8296B32B}']
    function GetManagerType: TServerManagerType;

    procedure AddBufferActiveConnections(aBuffer: TERPSocketStream);
    procedure Open;
    procedure SendAllBuffer(aBuffer: TERPSocketStream);
    procedure SendClientBuffer(aClientList: TSocketArray; aBuffer: TERPSocketStream);

    property ManagerType: TServerManagerType read GetManagerType;
  end;

implementation

end.
