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
  var email:string;
      subj,s:string;
      i:integer;
      UserData:TUserIDRecord;
begin
   //Отправка возврата
   if Main.CliComboBox.KeyValue = NULL  then
   begin
    MessageDlg('Не выбран клиент!',mtInformation, [mbOK],0);
    exit;
   end;

     UserData := Main.GetCurrentUser;




  email := Trim(UserData.sEmail);
  with Main do
  begin
    if Data.ParamTable.FieldByName('TCP_Direct').AsBoolean then
      begin
        try

        if email = '' then
          begin
            MessageDlg('Настройте Ваш email в параметрах программы!', mtError, [mbOK], 0);
            Exit;
          end;

        with TCPClient do
            begin
              try
//                Host := Data.SysParamTable.FieldByName('Host').AsString;
                Host := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
                Port := Data.SysParamTable.FieldByName('Port').AsInteger;
                Connect;
              except
                try
                  Host := Data.SysParamTable.FieldByName('Host').AsString;
                  Port := Data.SysParamTable.FieldByName('Port').AsInteger;
                  Connect;
                except
                  Host := Data.SysParamTable.FieldByName('TCPHost3').AsString;
                  Port := Data.SysParamTable.FieldByName('Port').AsInteger;
                  Connect;
                end;
            end;

          try
            IOHandler.Writeln(email);
            IOHandler.Writeln('QuestionToSP');
            for I := 0 to MemoLines.Lines.Count - 1 do
                IOHandler.Writeln(MemoLines.Lines[i]);
            IOHandler.Writeln('FINALYSEND');
            s := IOHandler.ReadLnWait;
          except
            on e: Exception do
            begin
              MessageDlg('Ошибка: ' + e.Message, mtError, [mbOK], 0);
              exit;
            end;
          end;
       end;
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
    with Mailer do
    begin
      Clear;
      Recipient.AddRecipient(Data.SysParamTable.FieldByName('QuestionEmail').AsString);
      Subject := email;
      Body := MemoLines.Lines;
      try
        SendMail;
      except
      end;
    end;
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
