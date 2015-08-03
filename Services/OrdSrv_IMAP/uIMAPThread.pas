unit uIMAPThread;

interface

uses
  Classes, uMain, SvcMgr;

type
  TIMAPThread = class(TThread)
  private
    fOwnerService: TOrdServiceIMAP;
    fPrefs: TPrefs;
  protected
    procedure Execute; override;

  public
    constructor Create(aOwnerService: TOrdServiceIMAP);
    destructor Destroy; override;
    procedure Init(const aPrefs: TPrefs);
  end;

implementation

uses
  SysUtils, Windows;

{ TIMAPThread }

constructor TIMAPThread.Create(aOwnerService: TOrdServiceIMAP);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  fOwnerService := aOwnerService;
end;

destructor TIMAPThread.Destroy;
begin
  //...
  inherited;
end;


procedure TIMAPThread.Execute;
var
  t: Cardinal;
  aFirstRun: Boolean;
begin
  fOwnerService.AddLog('TIMAPThread started', True);
  aFirstRun := True;

  t := 0;
  while not Terminated do
  begin
    if GetTickCount - t > fPrefs.ScanMailInterval * 1000 then
    begin
      try
        if aFirstRun then
        begin
          aFirstRun := False;

          //sleep(20000);
          //fOwnerService.makeAllForAndroid;

          //task for first run - start here..
          //if fPrefs.RebuildAllTTNOnStartup then
          //  fOwnerService.AddAllTtn2DB;
        end;

        if not Terminated then
        begin
          try
            fOwnerService.ProcessEMail;
          except
            on E: Exception do
            begin
              fOwnerService.AddLog('!EXCEPTION(ProcessEMail): ' + E.Message);
              fOwnerService.AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
            end;
          end;
        end;

        if not Terminated then
        begin
          fOwnerService.ProcessIncomming;
        end;


      except
        on E: Exception do
        begin
          fOwnerService.AddLog('!EXCEPTION: ' + E.Message);
          fOwnerService.AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
        end;
      end;
      t := GetTickCount;
      fOwnerService.AddLog('Спим ' + IntToStr(fPrefs.ScanMailInterval) + ' сек...', True);
    end;
    Sleep(250);
  end;
  fOwnerService.AddLog('TIMAPThread stopped', True);
end;

procedure TIMAPThread.Init(const aPrefs: TPrefs);
begin
  fPrefs := aPrefs;
end;

end.
