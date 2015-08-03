unit _VerInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ImagingComponents, Gauges;

type
  TVersionInfo = class(TForm)
    CloseBtn: TBitBtn;
    InfoLabel: TLabel;
    Image1: TImage;
    Timer: TTimer;
    UpdateBtn: TBitBtn;
    btOrderService: TBitBtn;
    ggDaysLeft: TGauge;
    lbDaysLeft: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    cnt: integer;
    procedure EnableServiceOrderButton(aEnable: Boolean);
  public
    procedure Init(aDaysLeft, aDaysMax: Integer;
      aEnableServiceOrderButton: Boolean; const aCaption: string);
  end;

var
  VersionInfo: TVersionInfo;

implementation

uses _Main;

{$R *.dfm}

procedure TVersionInfo.FormShow(Sender: TObject);
begin
  cnt := 5;
  CloseBtn.Enabled := False;
  Timer.Enabled    := True;
end;

procedure TVersionInfo.Init(aDaysLeft, aDaysMax: Integer;
  aEnableServiceOrderButton: Boolean; const aCaption: string);
begin
  InfoLabel.Caption := aCaption;
  if aDaysLeft < 0 then
    aDaysLeft := 0;
  ggDaysLeft.MaxValue := aDaysMax;
  ggDaysLeft.Progress := aDaysLeft;
  if aDaysLeft <= 5 then
    ggDaysLeft.ForeColor := clRed
  else
    ggDaysLeft.ForeColor := $000D74FF;

  if aDaysLeft = 0 then
    lbDaysLeft.Caption := 'Срок действия программы истек'
  else
    lbDaysLeft.Caption := Format('%d дн. до окончания срока действия', [aDaysLeft]);
  btOrderService.Visible := aEnableServiceOrderButton;
end;

procedure TVersionInfo.TimerTimer(Sender: TObject);
begin
  cnt := cnt - 1;
  if cnt = 0 then
  begin
    CloseBtn.Caption := 'Закрыть';
    CloseBtn.Enabled := True;
    Timer.Enabled    := False;
  end
  else
    CloseBtn.Caption := 'Закрыть (' + IntToStr(cnt) + ')';
end;

procedure TVersionInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer.Enabled    := False;
end;

procedure TVersionInfo.EnableServiceOrderButton(aEnable: Boolean);
begin
end;

procedure TVersionInfo.FormCreate(Sender: TObject);
begin
  EnableServiceOrderButton(False);
end;

end.
