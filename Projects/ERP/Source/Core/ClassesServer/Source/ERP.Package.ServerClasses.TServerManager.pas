unit ERP.Package.ServerClasses.TServerManager;

interface

uses
  ERP.Package.ServerClasses.IServerManager,
  ERP.Package.ServerClasses.IServerClientManager,
  ERP.Package.ServerClasses.IServerServiceManager,
  ERP.Package.ServerClasses.ServerTypes;

type
  TServerManager = class(TInterfacedObject, IServerManager)
  private
    FServerClientManager: IServerClientManager;
    FServerServiceManager: IServerServiceManager;
  public
    constructor Create(aProcLoggerCustomManager: TProcLoggerCustomManager);
    destructor Destroy; override;
    procedure Open;
    property ServerClientManager: IServerClientManager read FServerClientManager;
    property ServerServiceManager: IServerServiceManager read FServerServiceManager;
  end;

implementation

uses
  ERP.Package.ServerClasses.TServerClientManager,
  ERP.Package.ServerClasses.TServerServiceManager;

{ TServerManager }

constructor TServerManager.Create(aProcLoggerCustomManager: TProcLoggerCustomManager);
begin
  FServerClientManager := TServerClientManager.Create(Self, aProcLoggerCustomManager);
  FServerServiceManager := TServerServiceManager.Create(Self, aProcLoggerCustomManager);
end;

destructor TServerManager.Destroy;
begin
  FServerServiceManager := nil;
  FServerClientManager := nil;
  inherited Destroy();
end;

procedure TServerManager.Open;
begin
  FServerClientManager.Open();
  FServerServiceManager.Open();
end;

end.
