unit Logic.TMain;

interface

uses
  System.Generics.Collections,
  System.Win.ScktComp,
  Xml.XMLIntf,
  Logic.TOptionsThread;

type

  TFuncLoadMessage = function (const aFileName: string): IXMLNode;

  TMain = class
  private
    FServerSocket: TServerSocket;
    FOptionsThread: TOptionsThread;
    procedure DoGetThread(aSender: TObject; aClientSocket: TServerClientWinSocket;
      var aSocketThread: TServerClientThread);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SyncObjs,
  System.SysUtils,
  Logic.TServerThread,
  Logic.Options;

{ TMain }

constructor TMain.Create;
var
  MainStartEvent: TEvent;
begin
  MainStartEvent := TEvent.Create(nil, True, False, TGUID.NewGuid().ToString(), False);
  try
    FOptionsThread := TOptionsThread.Create(MainStartEvent);
    MainStartEvent.WaitFor(INFINITE);
  finally
    MainStartEvent.Free();
  end;
  FServerSocket := TServerSocket.Create(nil);
  FServerSocket.OnGetThread := DoGetThread;
  FServerSocket.Port := TOptions.Options.Server.Port;
  FServerSocket.ServerType := stThreadBlocking;
  FServerSocket.Open();
end;

destructor TMain.Destroy;
begin
  FServerSocket.Free();
  FOptionsThread.Terminate();
  FOptionsThread.WaitFor();
  FOptionsThread.Free();
  inherited;
end;

procedure TMain.DoGetThread(aSender: TObject; aClientSocket: TServerClientWinSocket;
  var aSocketThread: TServerClientThread);
begin
  aSocketThread := TServerThread.Create(False, aClientSocket);
  aSocketThread.FreeOnTerminate := True;
end;

end.
