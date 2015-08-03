unit RoutinesPackage.Logic.TEventLogger;

interface

uses
  Winapi.Windows,
  Vcl.SvcMgr,
  RoutinesPackage.Logic.IEventLogger;

type
  TEventLogger = class(TInterfacedObject, IEventLogger)
  strict private
    FEventLogger: Vcl.SvcMgr.TEventLogger;
  strict protected
    procedure LogMessage(const aMessage: string; aEventType: DWORD = 1; aCategory: Integer = 0; aId: Integer = 0);
  public
    constructor Create(const aName: string); reintroduce; virtual;
    destructor Destroy(); override;
  end;

implementation

uses
  System.SysUtils;

constructor TEventLogger.Create(const aName: string);
begin
  inherited Create();
  FEventLogger := Vcl.SvcMgr.TEventLogger.Create(aName);
end;

destructor TEventLogger.Destroy();
begin
  try
    if Assigned(FEventLogger) then
    begin
      FreeAndNil(FEventLogger);
    end;
  finally
    inherited;
  end;
end;

procedure TEventLogger.LogMessage(const aMessage: string; aEventType: DWORD; aCategory, aId: Integer);
begin
  if not Assigned(FEventLogger) then
  begin
    Exit;
  end;

  FEventLogger.LogMessage(aMessage, aEventType, aCategory, aId);
end;

end.
