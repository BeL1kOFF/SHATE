unit uWSThread;

interface

uses
  Classes, uMain, SvcMgr;

type
  TWSThread = class(TThread)
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

{ TWSThread }

constructor TWSThread.Create(aOwnerService: TOrdServiceIMAP);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  fOwnerService := aOwnerService;
end;

destructor TWSThread.Destroy;
begin
  //...
  inherited;
end;


procedure TWSThread.Execute;
var
  t: Cardinal;
  aFirstRun: Boolean;
begin
  fOwnerService.AddLogWS('TWSThread started', True);
  aFirstRun := True;

  t := 0;
  while not Terminated do
  begin
    if GetTickCount - t > fPrefs.ScanIncomingInterval * 1000 then
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
          fOwnerService.AddLogWS('Отправка заказов...', True);
          fOwnerService.SendOrders;
        end;

      except
        on E: Exception do
        begin
          fOwnerService.AddLogWS('!EXCEPTION: ' + E.Message);
          fOwnerService.AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
        end;
      end;
      t := GetTickCount;
      fOwnerService.AddLogWS('Спим ' + IntToStr(fPrefs.ScanIncomingInterval) + ' сек...', True);
    end;
    Sleep(250);
  end;
  fOwnerService.AddLogWS('TWSThread stopped', True);
end;

procedure TWSThread.Init(const aPrefs: TPrefs);
begin
  fPrefs := aPrefs;
end;

end.
