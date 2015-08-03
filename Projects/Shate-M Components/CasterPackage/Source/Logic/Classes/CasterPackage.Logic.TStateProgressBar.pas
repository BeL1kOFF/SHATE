unit CasterPackage.Logic.TStateProgressBar;

interface

uses
  System.Classes,
  Vcl.ComCtrls;

type
  TStateProgressBar = class(TProgressBar)
  protected
    procedure Loaded(); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoSize default True;
    property Width default 98;
    property Height default 17;
    property Step default 1;

  private
    FStatusBar: TStatusBar;
    function GetStatusBar(): TStatusBar;
    procedure SetStatusBar(const AValue: TStatusBar);
  published
    property StatusBar: TStatusBar read GetStatusBar write SetStatusBar nodefault;

  private
    FBindPanelIndex: Integer;
    function GetBindPanelIndex(): Integer;
    procedure SetBindPanelIndex(const AValue: Integer);
  published
    property BindPanelIndex: Integer read GetBindPanelIndex write SetBindPanelIndex default -1;

  strict private
    procedure Bind();
  end;

procedure Register();

implementation

uses
  Winapi.Windows,
  Winapi.CommCtrl,
  CasterPackage.Logic.THackControl;

procedure Register();
begin
  RegisterComponents('CasterComponents', [TStateProgressBar]);
end;

procedure TStateProgressBar.Bind();
var
  r: TRect;
begin
  if not(csDesigning in ComponentState) then
  begin
    if not Assigned(StatusBar) then
    begin
      Exit;
    end;

    if BindPanelIndex < 0 then
    begin
      Exit;
    end;

    THackControl(Self).SetParent(StatusBar);
    SendMessage(StatusBar.Handle, SB_GETRECT, BindPanelIndex, Integer(@r));
    SetBounds(r.Left, r.Top, r.Right - r.Left, r.Bottom - r.Top - 1);
  end;
end;

constructor TStateProgressBar.Create(AOwner: TComponent);
begin
  inherited;
  AutoSize := True;
  Width := 98;
  Height := 17;
  Step := 1;
  Constraints.MaxHeight := 17;
  Constraints.MaxWidth := 98;
  Constraints.MinHeight := 17;
  Constraints.MinWidth := 98;
  BindPanelIndex := -1;
end;

function TStateProgressBar.GetBindPanelIndex(): Integer;
begin
  Result := FBindPanelIndex;
end;

function TStateProgressBar.GetStatusBar(): TStatusBar;
begin
  Result := FStatusBar;
end;

procedure TStateProgressBar.Loaded();
begin
  inherited;
  if not(csDesigning in ComponentState) then
  begin
    Bind();
  end;
end;

procedure TStateProgressBar.SetBindPanelIndex(const AValue: Integer);
begin
  if FBindPanelIndex <> AValue then
  begin
    FBindPanelIndex := AValue;
  end;
end;

procedure TStateProgressBar.SetStatusBar(const AValue: TStatusBar);
begin
  if FStatusBar <> AValue then
  begin
    FStatusBar := AValue;
  end;
end;

end.
