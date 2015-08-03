unit _UpdateClientsParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TUpdateClientsParamsForm = class(TForm)
    rbUseEmailClient: TRadioButton;
    rbUseEmailCustom: TRadioButton;
    btOK: TButton;
    btCancel: TButton;
    edEMail: TComboBox;
    Label1: TLabel;
    cbNotQuery: TCheckBox;
    procedure btOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Validate;
  public
    class function Execute(var aCustomEmail: string; var aNotQuery: Boolean): Boolean;
  end;

var
  UpdateClientsParamsForm: TUpdateClientsParamsForm;

implementation

{$R *.dfm}

uses
  _Data, dbisamtb,_Main;

procedure TUpdateClientsParamsForm.btOKClick(Sender: TObject);
begin
  Validate;
  ModalResult := mrOK;
end;

class function TUpdateClientsParamsForm.Execute(
  var aCustomEmail: string; var aNotQuery: Boolean): Boolean;
begin
  with TUpdateClientsParamsForm.Create(Application) do
  try
    if Trim(aCustomEmail) <> '' then
    begin
      rbUseEmailCustom.Checked := True;
      edEMail.Text := aCustomEmail;
    end
    else
      rbUseEmailClient.Checked := True;
    cbNotQuery.Checked := aNotQuery;
    Result :=  ShowModal = mrOK;
    if Result then
    begin
      if rbUseEmailClient.Checked then
        aCustomEmail := ''
      else
        aCustomEmail := edEMail.Text;
      aNotQuery := cbNotQuery.Checked;  
    end;
  finally
    Free;
  end;
end;

procedure TUpdateClientsParamsForm.FormCreate(Sender: TObject);
var
  aQuery: TDBISamQuery;
begin
  aQuery := TDBISamQuery.Create(nil);
  try
    aQuery.DatabaseName := Main.GetCurrentBD ;
    aQuery.SQL.Text := 'SELECT DISTINCT EMAIL FROM [011]';
    aQuery.Open;
    while not aQuery.Eof do
    begin
      edEmail.Items.Add(aQuery.FieldByName('email').AsString);
      aQuery.Next;
    end;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

procedure TUpdateClientsParamsForm.Validate;
begin
  if (rbUseEmailCustom.Checked) and (Trim(edEMail.Text) = '') then
  begin
    Application.MessageBox('E-Mail не указан', 'Ошибка', MB_OK or MB_ICONWARNING);
    Abort;
  end;
end;

end.

