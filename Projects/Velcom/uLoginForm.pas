unit uLoginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMain, Buttons;

type
  TLoginEvent = function (const aUser, aPassword: string; aUseWinAuthority: Boolean): Boolean of object;

  TLoginForm = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    lbTitle: TLabel;
    cbClose: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    edUser: TEdit;
    edPassword: TEdit;
    btLogin: TButton;
    cbWinAuthority: TCheckBox;
    Label5: TLabel;
    procedure btLoginClick(Sender: TObject);
    procedure cbCloseClick(Sender: TObject);
    procedure cbWinAuthorityClick(Sender: TObject);
    procedure edPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edUserKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FOnLogin: TLoginEvent;
    procedure SetOnLogin(const Value: TLoginEvent);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    property OnLogin: TLoginEvent read FOnLogin write SetOnLogin;
    class function Execute(aLoginProc: TLoginEvent): Boolean;
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.dfm}

{ TLoginForm }

procedure TLoginForm.btLoginClick(Sender: TObject);
var
  aRes: Boolean;
begin
  if Assigned(fOnLogin) then
  begin
    aRes := FOnLogin(edUser.Text, edPassword.Text, cbWinAuthority.Checked);
    if aRes then
    begin
      ModalResult := mrOK;
    end;
  end;
end;

procedure TLoginForm.cbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TLoginForm.cbWinAuthorityClick(Sender: TObject);
begin
  if not cbWinAuthority.Checked then
  begin
    edUser.Color := clWindow;
    edPassword.Color := clWindow;
  end
  else
  begin
    edUser.Color := clSilver;
    edPassword.Color := clSilver;
  end;

  edUser.Enabled := not cbWinAuthority.Checked;
  edPassword.Enabled := not cbWinAuthority.Checked;
  if not cbWinAuthority.Checked then
    if edUser.CanFocus then
      edUser.SetFocus;
end;

procedure TLoginForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and (not WS_CAPTION);
end;

procedure TLoginForm.edPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btLogin.Click;
end;

procedure TLoginForm.edUserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if edPassword.CanFocus then
      edPassword.SetFocus;
end;

class function TLoginForm.Execute(aLoginProc: TLoginEvent): Boolean;
begin

  with TLoginForm.Create(Application) do
  try
    OnLogin := aLoginProc;
    cbWinAuthority.Checked := True;
    Result := ShowModal = mrOK;
  finally
    Free;
  end;

end;

procedure TLoginForm.lbTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TLoginForm.SetOnLogin(const Value: TLoginEvent);
begin
  FOnLogin := Value;
end;

end.

