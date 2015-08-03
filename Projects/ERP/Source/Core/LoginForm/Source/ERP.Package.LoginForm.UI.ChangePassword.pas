unit ERP.Package.LoginForm.UI.ChangePassword;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ActnList, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinCaramel, cxLabel,
  cxTextEdit, System.Actions;

type
  TfrmChangePassword = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    cxLabel1: TcxLabel;
    edtPassword: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    edtPassword2: TcxTextEdit;
    procedure FormShow(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
  private
    function CheckPassword: Boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmChangePassword.acCancelExecute(Sender: TObject);
begin
  Close();
  ModalResult := mrCancel;
end;

procedure TfrmChangePassword.acSaveExecute(Sender: TObject);
begin
  if CheckPassword then
  begin
    Close();
    ModalResult := mrOk;
  end;
end;

function TfrmChangePassword.CheckPassword: Boolean;
begin
  if edtPassword.Text <> edtPassword2.Text then
  begin
    Result := False;
    Application.MessageBox('Пароль должен совпадать!', 'Пароль', MB_OK or MB_ICONWARNING);
  end
  else
    if Length(edtPassword.Text) < 7 then
    begin
      Result := False;
      Application.MessageBox('Пароль должен быть более 6 символов!', 'Пароль', MB_OK or MB_ICONWARNING);
    end
    else
      Result := True;
end;

procedure TfrmChangePassword.FormShow(Sender: TObject);
begin
  edtPassword.SetFocus();
end;

end.
