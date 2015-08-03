unit uSmtpThread;

interface

uses
  Classes, SysUtils,
  IdMessageClient, IdSMTPBase, IdSMTP, IdMessage, IdCoderHeader,
  uMain, IdAttachmentFile;

type
  TMyIdMessage = class(TIdMessage)
  protected
    procedure OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
  public
    constructor Create(AOwner: TComponent);
  end;

  TSMTPMessagesThrd = class(TThread)
  private
    fOwnerService: TServiceQuantsProcessing;
    fMessages: TThreadList;
  protected
    procedure Execute; override;
  public
    constructor Create(aOwnerService: TServiceQuantsProcessing; aMessageList: TThreadList);
  end;

  TMessSMTP = class
    TrySendCount: Integer;
    ShateEmail: string;
    email: string;
    subj: string;
    fn: string;
    fn_orig: string;
    Host: string;
    Port: Integer;
    Username: string;
    Password: string;
    Body: string;
  end;

  
implementation


{ TSMTPMessagesThrd }

constructor TSMTPMessagesThrd.Create(aOwnerService: TServiceQuantsProcessing; aMessageList: TThreadList);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  fOwnerService := aOwnerService;
  fMessages := aMessageList;
end;

procedure TSMTPMessagesThrd.Execute;
var
  aNum: Integer;
  Client: TMessSMTP;
  IdMessage: TIdMessage;
  SMTP: TIdSMTP;
  bPost: Boolean;
  aList: TList;
begin
  fOwnerService.AddLog('TSMTPThread started', True);
  try
    fOwnerService.AddLog('SMTP - старт');
    aNum := 1;
    IdMessage := TMyIdMessage.Create(nil);
    SMTP := TIdSMTP.Create(nil);
    try
      while not Terminated do
      begin
        Client := nil;
        aList := fMessages.LockList;
        try
          if aList.Count > 0 then
            Client := aList.Items[0];
        finally
          fMessages.UnlockList;
        end;

        if Assigned(Client) then
        begin
          fOwnerService.AddLog('SMTP - отправка #' + IntToStr(aNum) + ' <' + Client.ShateEmail + '>', True);

          with IdMessage do
          begin
            ContentType := 'multipart/mixed; charset=windows-1251';
            Recipients.EmailAddresses := Client.ShateEmail;
            Subject :=Client.subj;
            Body.Clear;
            Body.Text := Client.body;
            From.Text := Client.email;
            MessageParts.Clear;
          end;
          SMTP.Host  := Client.Host;
          SMTP.Port := Client.Port;
          SMTP.Username := Client.Username;
          SMTP.Password := Client.Password;
          fOwnerService.AddLog(Client.fn + ';' + Client.fn_orig);
          if Client.fn <> '' then
            TIdAttachmentFile.Create(IdMessage.MessageParts, Client.fn); 
          if Client.fn_orig <> '' then
            TIdAttachmentFile.Create(IdMessage.MessageParts, Client.fn_orig); 
          bPost := False;
          try
            with SMTP do
            begin
              try
                Connect;
                try
                  Send(IdMessage);
                  bPost := True;
                except
                  on e: Exception do
                  begin
                    fOwnerService.AddLog('SMTP - ' + e.Message);
                    bPost := False;
                  end;
                end;
              except
                on e: Exception do
                begin
                  fOwnerService.AddLog('SMTP - ' + e.Message);
                  bPost := False;
                end;
              end;
              Disconnect;
            end;
          except
            on e: Exception do
            begin
              bPost := FALSE;
              fOwnerService.AddLog('SMTP - ' + e.Message);
            end;
          end;
                                     
          if(bPost)then
          begin
            Inc(aNum);
            fOwnerService.AddLog('SMTP - отправлено');
            //thread-safe remove
            fMessages.Remove(Client);
            Client.Free;
          end
          else
          begin
            Inc(Client.TrySendCount);
            if Client.TrySendCount >= 10 then
            begin
              fOwnerService.AddLog('!SMTP - 10 неудачных попыток отправки, письмо удалено');
              fMessages.Remove(Client);
            end
            else
            begin
              //переносим в конец очереди
              aList := fMessages.LockList;
              try
                aList.Remove(Client);
                aList.Add(Client);
              finally
                fMessages.UnlockList
              end;
            end;
          end;
        end;
        if Terminated then
          Break;
        Sleep(250);
      end;
    finally
      IdMessage.Free;
      SMTP.Free;
    end;
    fOwnerService.AddLog('SMTP - стоп');

  except
    on E: Exception do
      fOwnerService.AddLog('!EXCEPTION (SMTP): ' + E.Message);
  end;
  fOwnerService.AddLog('TSMTPThread stopped', True);
end;

{ TMyIdMessage }

constructor TMyIdMessage.Create(AOwner: TComponent);
begin
  inherited;
  OnInitializeISO := OnISO;
end;

procedure TMyIdMessage.OnISO(var VTransferHeader: TTransfer;
  var VHeaderEncoding: Char; var VCharSet: string);
begin
  VCharSet:='windows-1251';
  VTransferHeader := bit8;
  VHeaderEncoding := '8';
end;
end.

