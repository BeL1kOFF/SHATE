unit FileTransfer.Logic.TThreadAdapter;

interface

uses
  System.Classes,
  System.SysUtils,
  System.SyncObjs,
  Data.Win.ADODB,
  Package.CustomInterface.ICustomSenderAdapter;

type
  TThreadAdapter = class(TThread)
  private
    FCustomSenderAdapter: ICustomSenderAdapter;
    FEvent: TEvent;
    FPauseEvent: TEvent;
  protected
    procedure Execute; override;
    procedure TerminatedSet; override;
  public
    constructor Create(aADOConnection: TADOConnection); reintroduce;
    destructor Destroy; override;
    procedure Continue;
    procedure Pause;

    property CustomSenderAdapter: ICustomSenderAdapter read FCustomSenderAdapter;
  end;

implementation

uses
  FileTransfer.Logic.TCustomSenderAdapter;

resourcestring
  rsSetContinueThread = 'Установка нити в работу...';
  rsSetPauseThread = 'Установка нити в ожидание...';
  rsCriticalError = 'Сбой выполнения нити. Нить не остановлена. т.к. нет пока возможности запустить вручную.';

{ TThreadAdapter }

procedure TThreadAdapter.Continue;
begin
  FCustomSenderAdapter.LogWrite(PChar(rsSetContinueThread));
  FPauseEvent.SetEvent();
end;

constructor TThreadAdapter.Create(aADOConnection: TADOConnection);
begin
  inherited Create(True);
  FCustomSenderAdapter := TCustomSenderAdapter.Create(aADOConnection);
end;

destructor TThreadAdapter.Destroy;
begin
  TCustomSenderAdapter(FCustomSenderAdapter).FinalizeAdapter();
  FCustomSenderAdapter := nil;
  inherited Destroy();
end;

procedure TThreadAdapter.Execute;
var
  guid: TGUID;
  wfsoResult: TWaitResult;
begin
  CreateGUID(guid);
  FEvent := TEvent.Create(nil, True, False, GUIDToString(guid));
  CreateGUID(guid);
  FPauseEvent := TEvent.Create(nil, True, True, GUIDToString(guid));
  try
    while not Terminated do
    begin
      try
        wfsoResult := FEvent.WaitFor(TCustomSenderAdapter(FCustomSenderAdapter).Interval);
        FPauseEvent.WaitFor(INFINITE);
        if wfsoResult = wrSignaled then
          Break;
        TCustomSenderAdapter(FCustomSenderAdapter).BeginExecute();
      except on E: Exception do
      begin
        FCustomSenderAdapter.LogWrite(PChar(E.Message));
        FCustomSenderAdapter.LogWrite(PChar(rsCriticalError));
        //Terminate;
      end;
      end;
    end;
  finally
    FPauseEvent.Free();
    FEvent.Free();
  end;
end;

procedure TThreadAdapter.Pause;
begin
  FCustomSenderAdapter.LogWrite(PChar(rsSetPauseThread));
  FPauseEvent.ResetEvent();
end;

procedure TThreadAdapter.TerminatedSet;
begin
  FEvent.SetEvent();
  FPauseEvent.SetEvent();
end;

end.
