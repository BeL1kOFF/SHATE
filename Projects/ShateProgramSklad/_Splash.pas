unit _Splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvPanel, ExtCtrls, ComCtrls, AdvProgr, VclUtils, StdCtrls, Buttons,
  JvExButtons, JvBitBtn, Gauges;

type
  TSplash = class(TForm)
    Panel: TAdvPanel;
    Image1: TImage;
    PanelStyler: TAdvPanelStyler;
    OkBtn: TJvBitBtn;
    InfoLabel: TLabel;
    Progress: TGauge;
    Label1: TLabel;
  private
    WindowList: Pointer;
    fModal: Boolean;
    ActiveWindow: HWnd;
    procedure MakeModal(aModal: Boolean);
  public
    { Public declarations }
    procedure SplashOn;
    procedure SplashOff;
    procedure SplashOnModal;
  end;

var
  Splash: TSplash;

const
  SPLASH_TIMEOUT = 1000;

implementation

{$R *.dfm}


procedure TSplash.SplashOn;
begin
  StartWait;
  OkBtn.Visible := False;
  Show;
  Update;
end;

procedure TSplash.SplashOnModal;
begin
  StartWait;
  OkBtn.Visible := False;
  MakeModal(True);
  Update;
end;

procedure TSplash.MakeModal(aModal: Boolean);
begin
  Assert(fModal <> aModal);
  fModal := aModal;
  if aModal then
  begin
    CancelDrag;
    if Visible or not Enabled or (fsModal in FormState) or (FormStyle = fsMDIChild) then
      raise Exception.Create('Cannot do MakeModal');
    if GetCapture <> 0 then
      SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    ReleaseCapture;
    Include(FFormState, fsModal);
    ActiveWindow := GetActiveWindow;
    WindowList := DisableTaskWindows(0);
    Show;
    SendMessage(Handle, CM_ACTIVATE, 0, 0);
  end
  else
  begin
    SendMessage(Handle, CM_DEACTIVATE, 0, 0);
    if GetActiveWindow <> Handle then ActiveWindow := 0;
    Hide;
    EnableTaskWindows(WindowList);
    if ActiveWindow <> 0 then SetActiveWindow(ActiveWindow);
    Exclude(FFormState, fsModal);
  end;
end;

procedure TSplash.SplashOff;
var
  Ticks : Cardinal;
begin
  if fModal then
    MakeModal(False);

  Ticks := GetTickCount + SPLASH_TIMEOUT;
  while (GetTickCount<=Ticks) do ;
  Hide;
  Free;
  Splash := nil;
  StopWait;
end;

end.
