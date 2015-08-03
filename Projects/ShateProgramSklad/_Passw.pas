unit _Passw;
 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Placemnt, inifiles, BSForm;

type
  TPassword = class(TBaseForm)
    PasswLabel: TLabel;
    PswEd: TEdit;
    AcceptBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure AcceptBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Password: TPassword;

implementation

{$R *.DFM}

uses StStrL, _Data, _Main;

procedure TPassword.AcceptBtnClick(Sender: TObject);
var
  s: string;
begin
  if PswEd.Text = 'supervisor' then
    ModalResult := mrOk
  else
  begin
    MessageDlg('Пароль неверен! Доступ запрещен...', mtError, [mbOk], 0);
    ModalResult := mrCancel;
  end;
end;


end.
