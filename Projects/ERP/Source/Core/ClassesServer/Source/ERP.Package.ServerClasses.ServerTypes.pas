unit ERP.Package.ServerClasses.ServerTypes;

interface

uses
  System.SysUtils,
  System.Win.ScktComp,
  ERP.Package.ServerClasses.IServerCustomManager;

type
  PBytes = ^TBytes;

  TProcProcessedSocketThread = procedure (aServerSocketCustomThread: TServerClientThread;
    const aBuffer; aSize: Integer) of object;
  TEventTypeSocketThread = (etstConnect, etstDisconnect, etstRead, etstProcess);
  TProcLoggerSocketThread = procedure (aEventTypeSocketThread: TEventTypeSocketThread;
    aServerSocketCustomThread: TServerClientThread) of object;

  TProcLoggerCustomManager = procedure (aServerCustomManager: IServerCustomManager;
    aEventTypeSocketThread: TEventTypeSocketThread; aServerSocketCustomThread: TServerClientThread) of object;

implementation

end.
