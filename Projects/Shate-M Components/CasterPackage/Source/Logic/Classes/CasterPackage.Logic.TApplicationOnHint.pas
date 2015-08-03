unit CasterPackage.Logic.TApplicationOnHint;

interface

uses
  Vcl.ComCtrls,
  System.Classes;

type
  TApplicationOnHint = class(TComponent)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

  strict private
    FOldApplicationOnHint: TNotifyEvent;
    procedure ApplicationOnHint(Sender: TObject);

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
  end;

procedure Register();

implementation

uses
  Vcl.Forms,
  Vcl.Controls;

procedure Register();
begin
  RegisterComponents('CasterComponents', [TApplicationOnHint]);
end;

procedure TApplicationOnHint.ApplicationOnHint(Sender: TObject);
var
  s: string;
begin
  if csDesigning in ComponentState then
  begin
    Exit;
  end;

  if not Assigned(StatusBar) then
  begin
    Exit;
  end;

  s := GetLongHint(Application.Hint);
  if StatusBar.SimplePanel then
  begin
    StatusBar.SimpleText := s;
  end
  else
  begin
    if (BindPanelIndex > -1) and (BindPanelIndex < StatusBar.Panels.Count) then
    begin
      StatusBar.Panels[BindPanelIndex].Text := GetLongHint(Application.Hint);
    end;
  end;
end;

constructor TApplicationOnHint.Create(AOwner: TComponent);
begin
  inherited;
  BindPanelIndex := -1;
  FOldApplicationOnHint := Application.OnHint;
  Application.OnHint := ApplicationOnHint;
end;

destructor TApplicationOnHint.Destroy();
begin
  Application.OnHint := FOldApplicationOnHint;
  inherited;
end;

function TApplicationOnHint.GetBindPanelIndex(): Integer;
begin
  Result := FBindPanelIndex;
end;

function TApplicationOnHint.GetStatusBar(): TStatusBar;
begin
  Result := FStatusBar;
end;

procedure TApplicationOnHint.SetBindPanelIndex(const AValue: Integer);
begin
  if FBindPanelIndex <> AValue then
  begin
    FBindPanelIndex := AValue;
  end;
end;

procedure TApplicationOnHint.SetStatusBar(const AValue: TStatusBar);
begin
  if FStatusBar <> AValue then
  begin
    FStatusBar := AValue;
  end;
end;

end.
