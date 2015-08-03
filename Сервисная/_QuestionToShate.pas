unit _QuestionToShate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Psock, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTPRelay, Mapi, IdSMTP, IdException;

type

    
  TQuestionToShate = class(TForm)
    Label1: TLabel;
    MemoLines: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  QuestionToShate: TQuestionToShate;

implementation

Uses _Main, _Data;
{$R *.dfm}

procedure TQuestionToShate.BitBtn1Click(Sender: TObject);
var
  email:string;
  s:string;
  i:integer;
  UserData:TUserIDRecord;
begin
   //Отправка возврата
   if Main.CliComboBox.KeyValue = NULL  then
   begin
    MessageDlg('Не выбран клиент!', mtInformation, [mbOK], 0);
    exit;
   end;

//  if not Data.HostProtection then
//    exit;

  UserData := Main.GetCurrentUser;
  email := Trim(UserData.sEmail);
  if Data.ParamTable.FieldByName('TCP_Direct').AsBoolean then
  begin
    if email = '' then
    begin
      MessageDlg('Настройте Ваш email в параметрах программы!', mtError, [mbOK], 0);
      Exit;
    end;

    if not Main.DoTcpConnect(Main.TCPClient) then
      Exit;

    try
      Main.TCPClient.IOHandler.Writeln(email);
      Main.TCPClient.IOHandler.Writeln('QuestionToSP');
      for I := 0 to MemoLines.Lines.Count - 1 do
          Main.TCPClient.IOHandler.Writeln(MemoLines.Lines[i]);
      Main.TCPClient.IOHandler.Writeln('FINALYSEND');
      s := Main.TCPClient.IOHandler.ReadLnWait;
    except
      on e: Exception do
      begin
        MessageDlg('Ошибка: ' + e.Message, mtError, [mbOK], 0);
        exit;
      end;
    end;
  end
  else
  begin
      Main.Mailer.Clear;
      Main.Mailer.Recipient.AddRecipient(Data.SysParamTable.FieldByName('QuestionEmail').AsString);
      Main.Mailer.Subject := email;
      Main.Mailer.Body := MemoLines.Lines;
      try
        Main.Mailer.SendMail;
      except
      //
      end;
  end;

  MessageDlg('Письмо отправленно ', mtInformation, [mbOK], 0);
  Close;
end;

procedure TQuestionToShate.BitBtn2Click(Sender: TObject);
begin
   Close;
end;

procedure TQuestionToShate.FormCreate(Sender: TObject);
begin
  MemoLines.Lines.Clear;
end;

end.
