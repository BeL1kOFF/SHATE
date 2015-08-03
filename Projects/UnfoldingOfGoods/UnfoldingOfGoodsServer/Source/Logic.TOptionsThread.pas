unit Logic.TOptionsThread;

interface

uses
  System.SyncObjs,
  System.Classes;

type
  TOptionsThread = class(TThread)
  private
    FMainStartEvent: TEvent;
    FWaitEvent: TEvent;
  protected
    procedure Execute; override;
    procedure TerminatedSet; override;
  public
    constructor Create(aMainStartEvent: TEvent); reintroduce;
  end;

implementation

uses
  Winapi.ActiveX,
  System.SysUtils,
  Logic.Options,
  Logic.InitUnit;

{ TOptionsThread }

constructor TOptionsThread.Create(aMainStartEvent: TEvent);
begin
  FMainStartEvent := aMainStartEvent;
  inherited Create(False);
end;

procedure TOptionsThread.Execute;

  procedure AssignOptions;
  var
    Options: IXMLOptionsType;
  begin
    Options := LoadOptions(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Options.xml');
    TOptions.AssignOptions(Options);
  end;

begin
  CoInitialize(nil);
  try
    AssignOptions();
    FMainStartEvent.SetEvent();
    FWaitEvent := TEvent.Create(nil, True, False, TGUID.NewGuid().ToString(), False);
    try
      while not Terminated do
      begin
        try
          AssignOptions();
          FWaitEvent.WaitFor(60000);
        except
        end;
      end;
    finally
      FWaitEvent.Free();
    end;
  finally
    CoUninitialize();
  end;
end;

procedure TOptionsThread.TerminatedSet;
begin
  inherited;
  FWaitEvent.SetEvent();
end;

end.
