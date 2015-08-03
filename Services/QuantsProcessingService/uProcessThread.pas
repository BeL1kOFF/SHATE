unit uProcessThread;

interface

uses
  Classes, uMain, SvcMgr;

type
  TProcessThread = class(TThread)
  private
    fOwnerService: TServiceQuantsProcessing;
    fPrefs: TPrefs;
  protected
    procedure Execute; override;

  public
    constructor Create(aOwnerService: TServiceQuantsProcessing);
    destructor Destroy; override;
    procedure Init(const aPrefs: TPrefs);
  end;

implementation

uses
  SysUtils, Windows;

{ TProcessThread }

constructor TProcessThread.Create(aOwnerService: TServiceQuantsProcessing);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  fOwnerService := aOwnerService;
end;

destructor TProcessThread.Destroy;
begin
  //...
  inherited;
end;


procedure TProcessThread.Execute;
var
  t: Cardinal;
  aFirstRun: Boolean;
begin
  aFirstRun := True;
  t := 0;

  while not Terminated do
  begin
    if GetTickCount - t > fPrefs.ScanQuantsInterval * 1000 then
    begin
      try
        if aFirstRun then
        begin
          aFirstRun := False;
          //task for first run - start here..
        end;

        if not Terminated then
        begin
          fOwnerService.AddLog('Сканирую новые файлы...', True);
          fOwnerService.RenameKurses();
        end;

       if not Terminated then
         fOwnerService.RenamePricesClient();

       if not Terminated then
         fOwnerService.RenamePrices();

       if not Terminated then
         fOwnerService.RenameLimits();

       if not Terminated then
         fOwnerService.RenameQuants();

        if not Terminated then
          fOwnerService.RenameQuantsEx();

        if not Terminated then
          fOwnerService.CheckToDoExport();

      except
        on E: Exception do
        begin
          fOwnerService.AddLog('!EXCEPTION: ' + E.Message);
          fOwnerService.AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
        end;
      end;
      t := GetTickCount;
      fOwnerService.AddLog('Спим ' + IntToStr(fPrefs.ScanQuantsInterval) + ' сек...', True);
    end;
    Sleep(250);
  end;
  fOwnerService.AddLog('TProcessThread stopped', True);
end;

procedure TProcessThread.Init(const aPrefs: TPrefs);
begin
  fPrefs := aPrefs;
end;

end.
