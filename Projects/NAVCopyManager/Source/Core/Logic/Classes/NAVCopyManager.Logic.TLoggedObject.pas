unit NAVCopyManager.Logic.TLoggedObject;

interface

uses
  Vcl.SvcMgr,
  Winapi.Windows;

type
  TLoggedObject = class(TInterfacedObject)
  strict private
    FEventLogger: TEventLogger;
  strict protected
    procedure LogMessage(const aMessage: string; aEventType: DWORD = 1; aCategory: Integer = 0; aID: Integer = 0);
  public
    destructor Destroy; override;
  end;

resourcestring
  RsLastError = sLineBreak + '[Код ошибки: %d]: %s';

implementation

uses
  System.SysUtils;

destructor TLoggedObject.Destroy;
begin
  if Assigned(FEventLogger) then
  begin
    FreeAndNil(FEventLogger);
  end;
  inherited;
end;

procedure TLoggedObject.LogMessage(const aMessage: string; aEventType: DWORD; aCategory, aID: Integer);
begin
  if not Assigned(FEventLogger) then
  begin
    FEventLogger := TEventLogger.Create(ExtractFileName(ParamStr(0)));
  end;

  FEventLogger.LogMessage(aMessage, aEventType, aCategory, aID);
end;

end.
