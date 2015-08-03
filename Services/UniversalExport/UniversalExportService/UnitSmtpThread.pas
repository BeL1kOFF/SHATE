unit UnitSmtpThread;

interface



uses
  Classes, SysUtils, Math,  Windows,
  IdMessageClient, IdSMTPBase, UnitIdSMTP, IdMessage, IdCoderHeader, DB, ADODB, ActiveX,
  {uMain,} IdAttachmentFile, IdText, UnitConfig, UnitLogging, iniFiles, VCLzip;

type
  TFAULTSTATUS = Record
    occurred: boolean;
    stampID: Integer;
    faultmsg: string; 
    procedure Init;
    procedure SetState(State: boolean; stamp: Integer; msg: string);
    function Recovery(Connection: TADOConnection): boolean;
    function Excited: boolean;
  End;
  //класс сообщения
  TMyIdMessage = class(TIdMessage)
  protected
    procedure OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
  public
    constructor Create(AOwner: TComponent);
  end;
  TMessSMTP = class

    TrySendCount: Integer;
    ShateEmail: string;
    email: string;
    subj: string;
    fn: string;
    fn_orig: string;
    Host: string;  //10.0.1.152
    Port: Integer; //25
    Username: string;
    Password: string;
    Body: string;
    bcc: boolean;
    filenamezip: string;
    arch, zip: boolean;
    index: integer;
    ID : int64;
    public
      class function GetFromSQLDatabase(exportID: Integer; Qu: TADOQuery): TMessSMTP;
    //published
    //destructor Destroy; override;
  end;
  //класс потока отправки сообщений

  TSMTPMessagesThrd = class(TThread)
  private
    //fOwnerService: TServiceQuantsProcessing;
    fMessages: TThreadList;
    Connection: TADOConnection;
    Mails: TADOTable;
    SQLserver, SQLDatabase: string;
    BithDay: TDateTime;
    function LoadQueue: integer;
    procedure InitDatabase;
    procedure DBGarbageClearing;
    function GotoRecByLetter(Letter: TMessSMTP):INT64; virtual;abstract;
    function UpdateMessageStatus(ID: Int64; ExpId: integer; email:string; status: Boolean; var errmsg: string): boolean;
    class var FAULTSTATUS : TFAULTSTATUS;
    function getQueueLength: integer;
  protected
    procedure Execute; override;
  public
    Logger: TLogger;
    errorslog: string;
    inhibit: boolean;
    SMTPHostIP: string;
    SMTPPortNo: Integer;
    SMTPLogin, SMTPPass: string;
    SMTPConnectTimeout, SMTPReadTimeout, SleepInterval: integer;//*
    emailcopies, emailret: string;
    property SQLSRV: string Read SQLServer Write SQLserver;
    property SQLDB: string Read SQLDatabase Write SQLDatabase;
    property ql:integer read getQueueLength;
    procedure Init;
    //создание потока озадаченного списком сообщений
    constructor Create(aMessageList: TThreadList);

    function isRunning: boolean;
    class function Restart(var Thread: TSMTPMessagesThrd): boolean;
  end;



  TEmailDscr = Record
    ID: int64;// eger
    mailTo, copies,
    subj, body, attouch: string;
    bcc, arch: boolean;
  End;

//const  SMTPHOSTIP = '10.0.1.152'; SMTPPORTNO = 25;
//       SHATEMEMAIL = 'roman.kushel@shate-m.com;Dmitry.Tetenkin@shate-m.com;Alexey.Vishnevetsky@shate-m.com;Pavel.Turomcha@shate-m.com;Oleg.Sinyakin@shate-m.com';//'Kirill.Shingarev@shate-m.com';
//       //EMAILSUBJECT = 'Склад Минск. Актуальное предложение ШАТЕ-М ПЛЮС';
const  ATTEMPTS = 3; //10
var    SMTPQueue: TThreadList;
       Zip: TVCLZip;

function Pass2Mailer(index: integer; EmailMsg: TEmailDscr; Connection: TADOConnection): boolean;
function AddEmail2Queue(index: integer;EmailMsg:TEmailDscr;eMailQueue: TThreadList): boolean; overload;
procedure AddEmail2Queue(msgText, mailTo, subj, attouchfile: string; bcc, arch: boolean; eMailQueue: TThreadList); overload;
implementation

const SQLMARK0 = 'SQLMARKEMAIL';




function Pass2Mailer0(index: integer; EmailMsg: TEmailDscr; Connection: TADOConnection): boolean;
const SQLINSERTEMAIL = 'SQLINSERTEMAIL';
var sqlstr: string;  TemplList, ReplList: TStringList;
begin

try
    RESULT:=False;
    if Connection<>nil then
     try
      //Connection.Open;
      TemplList:=TstringList.Create; ReplList:=TStringList.Create;
      try
        TemplList.Add('##ExpID##'); ReplList.Add(IntToStr(index));
        TemplList.Add('##email##'); ReplList.Add(EmailMsg.mailTo);
        TemplList.Add('##bcc##'); ReplList.Add(IntToStr(Ord(EmailMsg.bcc)));
        TemplList.Add('##Subject##'); ReplList.Add(EmailMsg.subj);
        TemplList.Add('##Body##'); ReplList.Add(EmailMsg.body);
        TemplList.Add('##attouch##'); ReplList.Add(EmailMsg.attouch);
        TemplList.Add('##arch##'); ReplList.Add(IntToStr(Ord(EmailMsg.arch)));
//        TemplList.Add('####'); ReplList.Add();
//        TemplList.Add('####'); ReplList.Add();
//        TemplList.Add('####'); ReplList.Add();
//        TemplList.Add('####'); ReplList.Add();

        sqlStr:=MultyReplace(loadTextDataByTag(SQLINSERTEMAIL), TemplList, ReplList);
        Connection.Execute(sqlStr);
        RESULT:=True;  //!логику результата доопределить потом
      finally
        FreeAndNil(TemplList);FreeAndNil(ReplList);
        //Connection.Close;
      end;
     except on E: Exception do
      EmailMsg.copies := E.Message;
     end;
finally
      AddEmail2Queue(index,EmailMsg,SMTPQueue);
//  with EmailMsg do
//   begin
//
//   end;
end;

  ;
end;


//функция добавляет сообщение и в очередь отправки и в таблицу
function Pass2Mailer(index: integer; EmailMsg: TEmailDscr; Connection: TADOConnection): boolean;
const SQLINSERTEMAIL = 'SQLINSERTEMAIL';
var sqlstr: string;  TemplList, ReplList: TStringList;
  EMail: TMessSMTP;
  p: integer;
  addresses: string;
begin
  RESULT:=False;

  TemplList:=TstringList.Create; ReplList:=TStringList.Create;
    TemplList.Add('##ExpID##'); ReplList.Add(IntToStr(index));
    {TemplList.Add('##email##'); ReplList.Add(EmailMsg.mailTo);}
    TemplList.Add('##bcc##'); ReplList.Add(IntToStr(Ord(EmailMsg.bcc)));
    TemplList.Add('##Subject##'); ReplList.Add(EmailMsg.subj);
    TemplList.Add('##Body##'); ReplList.Add(EmailMsg.body);
    TemplList.Add('##attouch##'); ReplList.Add(EmailMsg.attouch);
    TemplList.Add('##arch##'); ReplList.Add(IntToStr(Ord(EmailMsg.arch)));
    sqlStr:=MultyReplace(loadTextDataByTag(SQLINSERTEMAIL), TemplList, ReplList);




  with EmailMsg do
  try

    if NOT ((trim(mailTo)<>'') OR bcc) then exit;

    addresses:=StringReplace(trim(mailTo),';',',',[rfReplaceAll]);

    repeat
      p:=pos(',',addresses);
      if p=0 then mailTo:=addresses
       else mailTo:=copy(addresses,1,p-1);
      addresses:=copy(addresses,p+1,length(addresses)-p);

      EMail := TMessSMTP.Create;
      EMail.email := mailTo;
      EMail.ShateEmail := '';
      EMail.subj := subj;//EMAILSUBJECT;
      EMail.fn := attouch;
      EMail.fn_orig := EMail.fn;

      Email.zip:=(ExtractFileExt(attouch)='.zip');
      Email.arch := arch;
      EMail.Body := body;
      EMail.bcc := bcc;

      EMail.TrySendCount := 0;
      EMail.index := index;
      EMail.ID := ID;


      if Connection<>nil then
      try
        Connection.Execute(StringReplace(sqlStr,'##email##',mailTo,[rfIgnoreCase]));
      except on E: Exception do
      end;
      SMTPQueue.Add(EMail);
    until p*length(trim(StringReplace(addresses,',','',[rfReplaceAll])))=0;
  finally
    FreeAndNil(TemplList);FreeAndNil(ReplList);
  end;




end;
function PostMessageBySMTP(SMTP: TIdSMTP; eMsg: TIdMessage; var logmsg: string): boolean;
begin
  ;
  RESULT := False;
  try
    with SMTP do
    begin
      try
        if (Connected) then Disconnect;
        Connect;
        try
          Send(eMsg);
           RESULT := True;
        except
          on e: Exception do
          begin
            //fOwnerService.AddLog('SMTP - ' + e.Message);
            logmsg:='SENDING FAULT: "'+e.Message+'"';
            RESULT := False;
          end;
        end;
      except
        on e: Exception do
        begin
          //fOwnerService.AddLog('SMTP - ' + e.Message);
          logmsg:='CONNECTING FAULT: "'+e.Message+'"';
          RESULT := False;
        end;
      end;
      Disconnect;
    end;
  except
    on e: Exception do
    begin
      RESULT := FALSE;
      //fOwnerService.AddLog('SMTP - ' + e.Message);
      logmsg:=e.Message;
    end;
  end;
  if RESULT then logmsg:='Отправлено: ' + eMsg.Subject + '<'+eMsg.Recipients.EMailAddresses+'>';
end;

function AddEmail2Queue(index: integer;EmailMsg:TEmailDscr;eMailQueue: TThreadList): boolean;
var
  EMail: TMessSMTP;
  p: integer;
  addresses: string;
begin
  with EmailMsg do
  try
    if NOT ((trim(mailTo)<>'') OR bcc) then exit;

    addresses:=StringReplace(trim(mailTo),';',',',[rfReplaceAll]);

    repeat
      p:=pos(',',addresses);
      if p=0 then mailTo:=addresses
       else mailTo:=copy(addresses,1,p-1);
      addresses:=copy(addresses,p+1,length(addresses)-p);
      EMail := TMessSMTP.Create;
      EMail.email := mailTo;
      EMail.ShateEmail := '';
      EMail.subj := subj;//EMAILSUBJECT;
      EMail.fn := attouch;
      EMail.fn_orig := EMail.fn;

      Email.zip:=(ExtractFileExt(attouch)='.zip');
      Email.arch := arch;
      EMail.Body := body;
      EMail.bcc := bcc;

      EMail.TrySendCount := 0;
      EMail.index := index;
      EMail.ID := ID;
      eMailQueue.Add(EMail);
    until p*length(trim(StringReplace(addresses,',','',[rfReplaceAll])))=0;
  except on E: Exception do
  end;
end;

procedure AddEmail2Queue(msgText, mailTo, subj, attouchfile: string; bcc, arch: boolean; eMailQueue: TThreadList);
var
  EMail: TMessSMTP;
  p: integer;
  addresses: string;
begin
  if NOT ((trim(mailTo)<>'') OR bcc) then exit;

  addresses:=StringReplace(trim(mailTo),';',',',[rfReplaceAll]);

  repeat
    p:=pos(',',addresses);
    //case p of
    if p=0 then mailTo:=addresses
     else mailTo:=copy(addresses,1,p-1);// thenmailTo:=;
    //end;

    addresses:=copy(addresses,p+1,length(addresses)-p);
      //if trim(addresses) = ''  then p:=0;


    EMail := TMessSMTP.Create;



    EMail.email := mailTo;
    EMail.ShateEmail := ''; // 'webshop@shate-m.com';//'ШАТЕ-М Служба рассылки []';//SHATEMEMAIL;//!!!
    EMail.subj := subj;//EMAILSUBJECT;
    EMail.fn := attouchfile;
    EMail.fn_orig := EMail.fn;

    Email.zip:=(ExtractFileExt(attouchfile)='.zip');
    Email.arch := arch;

  //  EMail.Host := SMTPHOSTIP;
  //  EMail.Port := SMTPPORTNO;
  //  EMail.Username := '';
  //  EMail.Password := '';
    EMail.Body := msgText;
    EMail.bcc := bcc;

    EMail.TrySendCount := 0;

    eMailQueue.Add(EMail);
//    if (Trim(EMail.email) <> '') {"and   ShateEmail
//       (fPrefs.MailHost <> '') and
//       (fPrefs.MailPort > 0)} then
//    begin
//      //thread-safe add
//
//    end
//    else
//      EMail.Free;
  until p*length(trim(StringReplace(addresses,',','',[rfReplaceAll])))=0;
end;
//  EMail.email := 'QUANTS Processing Service';//from
//  if isSysReport then
//  begin
//    EMail.ShateEmail := fPrefs.ReportSysErrors;//to
//    EMail.subj := 'QUANTS Processing Service - оповещение о системных ошибках';
//  end
//  else
//  begin
//    EMail.ShateEmail := fPrefs.ReportUserErrors;//to
//    EMail.subj := 'QUANTS Processing Service - оповещение об ошибках';
//  end;

{ TSMTPMessagesThrd }

constructor TSMTPMessagesThrd.Create(aMessageList: TThreadList);
begin
  inherited Create(True);
  //self.Logger := MailLogger; исключаем дублирование действия (в Unit1)
  FreeOnTerminate := False;
  //fOwnerService := aOwnerService;
  fMessages := aMessageList;
  self.inhibit := false;
  self.BithDay := Now;
  //self.Init;
end;

procedure TSMTPMessagesThrd.DBGarbageClearing;
const SQLDELETEMAILS = 'SQLDeleteOldMessages';
var Action: IAction;   scc: boolean;
begin
  if self.FAULTSTATUS.stampID = 0 then exit;
  Action:=TAction.Create('Финализация отправлений с неопределённым статусом',self.Logger,false);
try   Action.Start;
    scc:=false;
  try
    if self.FAULTSTATUS.occurred then
      scc:=self.FAULTSTATUS.Recovery(self.Connection);     //*!* протестировать восстановление
    //self.Connection.Execute(SQLDELETEMAILS);      //??
    Action.Finish;
  except
    on E: Exception do
      Action.Catch(E);      
  end;
    Action.Resume(scc);
finally   Action.Report;
end;
end;

procedure TSMTPMessagesThrd.Execute;
CONST REINITINTERVAL =200;//15*60
var
  aNum: Integer;
  Client: TMessSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  SMTP: TIdSMTP;
  bPost: Boolean;
  aList: TList;
  k: integer;
  errf: text;
  errmsg: string;
  cycles: integer;

  Action, actEmail: IAction;
begin
  //fOwnerService.AddLog('TSMTPThread started', True);
  AssignFile(errf, errorslog);
try   Action:=TAction.Create('Поток отправки почты',self.Logger);
  try  Action.Start;
    //fOwnerService.AddLog('SMTP - старт');
    aNum := 1;
    IdMessage := TMyIdMessage.Create(nil);  //создаём сообщение
    SMTP := TIdSMTP.Create(nil);            //создаём почтовый ящик SMTP
    SMTP.ReadTimeout:=self.SMTPReadTimeout*1000; //20*1000;
    SMTP.ConnectTimeout:=self.SMTPConnectTimeout*1000;//20*1000;

    self.Connection := TADOConnection.Create(nil);
    self.Connection.ConnectionString := generateConnStr(true,SQLserver,SQLDatabase);

    self.Mails:= TADOTable.Create(nil);
    self.Mails.Connection := self.Connection;
    self.Mails.TableName := 'MAILS';

    Action.timeStamp('удаление устаревших сообщений...');
    self.DBGarbageClearing; //удаление устаревших сообщений
    if self.inhibit then Action.Interrupt;

    Action.timeStamp('загрузка очереди...');
    self.LoadQueue;
    if self.inhibit then Action.Interrupt;

    cycles:=REINITINTERVAL;    {sleep(60000);}     //*Synchronize(self.Init);
    try
      while not Terminated do
      begin
        Sleep(self.SleepInterval);   {1000} //* 100*sign(abs(cycles))
        if self.inhibit then exit;

        Client := nil;
        aList := fMessages.LockList;
        try
          if cycles=0 then  cycles:=sign(aList.Count);
          if aList.Count > 0 then
            Client := aList.Items[0];  //очередное клиентское сообщение
        finally
          fMessages.UnlockList;
        end;
        if cycles=0 then
         begin
          if self.FAULTSTATUS.Excited then  //.occurred                                   //функционал требует основательного тестирования
            Raise Exception.Create('Поток завершается в ожидании перезапуска');
              {!exit; !}

          Action.timeStamp('Реинициализация...');
          self.Init;//Synchronize() //*потенциальная взаимоблокировка
          cycles:=REINITINTERVAL;
          self.DBGarbageClearing; //удаление отправленных сообщений
          if self.inhibit then Action.Interrupt;
          self.LoadQueue;
         end
         else dec(cycles);

        if Assigned(Client) then
        try   actEmail:= TAction.Create('Цикл отправки '+ExtractFileName(Client.fn),self.Logger);
        try   actEmail.Start;
          //fOwnerService.AddLog('SMTP - отправка #' + IntToStr(aNum) + ' <' + Client.ShateEmail + '>', True);
          errmsg:='';
          if NOT self.UpdateMessageStatus(Client.ID,Client.index,Client.email,False, errmsg) then
           if Client.ID>0 then //письмо считано из очереди а не попало непосредственно
           begin  //cообщение уже было отправлено - мы его удаляем
            actEmail.Stamp('Сообщение удаляется из очереди, поскольку было отправлено ранее');
            fMessages.Remove(Client);
            Continue;
           end
           else
            actEmail.timeStamp('Не удалось связать сообщение в очереди и в таблице:  "'+errmsg+'"');
            

          actEmail.Stamp('Конфигурация полей отправления...');
          with IdMessage do
          begin
            CharSet:='windows-1251';
            ContentType := 'multipart/mixed; charset=windows-1251';   //=KOI8-R
            Recipients.EmailAddresses := Client.email;//'';
            BccList.EMailAddresses := '';
            if Client.email <> '' then
             begin
              //BccList.EMailAddresses := Client.email;
              //скрытые копии отправляем отдельно
              //if Client.bcc AND (self.emailcopies <> '') then
              //  BccList.EMailAddresses:= BccList.EMailAddresses  +', '+self.emailcopies;//+','+'Sergey.Doynikov@shate-m.com'+', '+'Dmitry.Tetenkin@shate-m.com';
             end
            ;// else  BccList.EMailAddresses:=self.emailcopies;                    //?

            Subject :=Client.subj;
            Body.Clear;
            //Body.Text := Client.body;
            From.Text := self.emailret;//Client.ShateEmail
            MessageParts.Clear;
          end;
          SMTP.Host  := self.SMTPHostIP;//Client.Host
          SMTP.Port :=  self.SMTPPortNo;//Client.Port
          SMTP.Username := self.SMTPLogin;       //Client.Username
          SMTP.Password := self.SMTPPass;      //Client.Password
          SMTP.ReadTimeout:=self.SMTPReadTimeout*1000;//5
          SMTP.ConnectTimeout:=self.SMTPConnectTimeout*1000;//20

          //fOwnerService.AddLog(Client.fn + ';' + Client.fn_orig);

          if Client.Body <> '' then
           begin
            IdText:=TIdText.Create(IdMessage.MessageParts);
            IdText.ContentType :='text/plain; charset=windows-1251';
            IdText.Body.Add(Client.Body);
            idText.ParentPart:=-1;
           end;


          if (Client.arch) then  // AND(NOT Client.zip)
           begin
             actEmail.Stamp('архивация...');
             //if Client.TrySendCount=0 then   //архивация нового вложения
              try

                if Client.filenamezip = '' then
                  begin
                    Zip.ZipName := ChangeFileExt(Client.fn_orig,'.zip');
                    Client.filenamezip := Zip.ZipName;
                  end
                  else Zip.ZipName := Client.filenamezip; //


                //Client.fn_orig := Client.fn;

                Zip.FilesList.Clear;
                Zip.FilesList.Add(Client.fn_orig);
                //Zip.Filename[0]:= Client.fn;
                if FileExists(Zip.ZipName) then
                 try
                   if not SysUtils.DeleteFile(Zip.ZipName) then
                    if not RenameFile(Zip.ZipName, Zip.ZipName+'_') then
                     begin
                      actEmail.Stamp('попытка сохранить архив под другим именем...');
                      Client.filenamezip:=StringReplace(Zip.ZipName
                          ,'.zip'
                          ,'_['+StringReplace(DateTimeToStr(NOw),':','-',[rfReplaceAll])+ '].zip'
                          ,[rfIgnoreCase]);

                      Zip.ZipName := Client.filenamezip;
                     end;
                 except
                  on Err: Exception do
                    continue; //дальнейшая судьба Client ???   см. ниже
                 end;

               if self.Terminated then break;

               try
                if Zip.Zip>0 then
                 begin
                  Client.zip := true;
                  Client.fn:=Zip.ZipName;
                 end;
               except
                on Err: Exception do
                  Raise;//continue; //?  сообщение выходит за поле зрения до следующей перезагрузки очереди
               end;
                 ;
              finally
                ;
              end;
              ;
           end;


          if Client.fn <> '' then
            TIdAttachmentFile.Create(IdMessage.MessageParts, Client.fn);


//          if Client.fn_orig <> '' then
//            TIdAttachmentFile.Create(IdMessage.MessageParts, Client.fn_orig);


          for k := 0 to IdMessage.MessageParts.Count - 1 do
            With IdMessage do
              MessageParts[k].CharSet := 'windows-1251';
            //End;
          if self.Terminated then actEmail.Interrupt; //exit; //*
          actEmail.timeStamp('попытка отправки...');
          bPost:=True;
          errmsg:='';
          if Client.email <> '' then
            bPost:=PostMessageBySMTP(SMTP,IdMessage, errmsg);
          if self.UpdateMessageStatus(Client.ID,Client.index,Client.email, bPost, errmsg) then//*
            actEmail.Resume(bPost)
           else
           begin
            actEmail.Stamp('Не удалось изменить статус записи в таблице отправлений: '+ '"'+errmsg+'"');
            actEmail.Resume(False);
           end;
          if bPost then actEmail.timeStamp('Завершена отправка основному адресату')
          else actEmail.timeStamp('# не отправлено: ' + errmsg);
          if self.Terminated then exit;
//             begin   //отправляем если корректный адрес
//              bPost:=SMTP.Verify(Client.email);
//              if bPost then bPost:=PostMessageBySMTP(SMTP,IdMessage, errmsg);
//             end;
          //если основному адресату сообщение отправилось - отправляем копии
          if (bPost AND (Client.bcc AND(trim(self.emailcopies)<>''))) then
           with IdMessage do
            begin
             Subject:= Client.subj+' {[' +ExtractFileName(trim(Client.fn))+'] --> <'+Recipients.EMailAddresses+'>}'; //
             Recipients.EMailAddresses :='';
             CCList.EMailAddresses  :='';
             Client.TrySendCount :=ATTEMPTS;//письмо будет удалено полюбак;
             BccList.EMailAddresses:=self.emailcopies;
             actEmail.timeStamp('Отправка копий...');
             if PostMessageBySMTP(SMTP, IdMessage, errmsg) then
               actEmail.timeStamp('...Отправка копий завершена')
              else
               actEmail.timeStamp('# не удалось отправить копию: "' +errmsg+ '"');
            end;

          //удаление отправленного архива
          if Client.filenamezip <>'' then
           try
            if FileExists(Client.filenamezip) then
              SysUtils.DeleteFile(Client.filenamezip);
           except
            on E:Exception do
              errmsg := E.Message;
           end;



          if(bPost)then
          begin
            Inc(aNum);
            actEmail.timeStamp('удаление отправления из очереди...');
            //thread-safe remove
            fMessages.Remove(Client);
            Client.Free;
          end
          else
          begin
            if errmsg<>'' then PrintLog(errorslog,errmsg);
            Inc(Client.TrySendCount);
            if Client.TrySendCount >= ATTEMPTS then
            begin
              actEmail.timeStamp('удаление отправления из очереди...');
              fMessages.Remove(Client);
              PrintLog(errorslog,'!SMTP: После '+IntToStr(Client.TrySendCount) +'неудачных попыток отправки, письмо удалено');
              Client.Free;
            end
            else
            begin
              //переносим в конец очереди
              aList := fMessages.LockList;
              try
                aList.Remove(Client);
                aList.Add(Client);
                actEmail.timeStamp('сообщение поставлено в конец очереди.');
              finally
                fMessages.UnlockList
              end;
            end;
          end;

        actEmail.Finish;
        except
          on Err: Exception do
            actEmail.Catch(Err);
        end;
        finally  actEmail.Report;

        end;
        if Terminated then
          Break;

      end;
      if Terminated then Action.Interrupt;
    finally
      IdMessage.Free;
      SMTP.Free;
      self.Mails.Free;
      self.Connection.Free;
    end;
    //fOwnerService.AddLog('SMTP - стоп');
    Action.Finish;
  except
    on E: Exception do
      Action.Catch(E); //writelnintofile(E.Message,self.errorslog);
      //fOwnerService.AddLog('!EXCEPTION (SMTP): ' + E.Message);
  end;
finally Action.Report;

end;
  //fOwnerService.AddLog('TSMTPThread stopped', True);
end;

function TSMTPMessagesThrd.getQueueLength: integer;
begin
  try
    RESULT:=self.fMessages.LockList.Count;
  finally
    self.fMessages.UnlockList;
  end;
end;

procedure TSMTPMessagesThrd.Init;
begin
  //Sleep(30*1000); //закомментировано непонятное ожидание
  self.errorslog:=FILEERRLOG;
  if (self.Terminated) or self.inhibit  then exit;
  SectINI.enter;//*
  try
    iniFile:=TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILENAMEINI);

    self.SMTPHostIP := ReadSMTPServer;

    if length(self.SMTPHostIP)=0 then //признак нежизнеспособности почальона
     begin
      self.inhibit := true;   //?
      exit;
     end;

    self.SMTPPortNo := ReadSMTPPort;
    self.SMTPLogin :=  ReadSMTPLogin;
    self.SMTPPass := ReadSMTPPassword;

    self.SMTPConnectTimeout := ReadSMTPConnectTimeout; //5;
    self.SMTPReadTimeout := ReadSMTPReadTimeout; //20;
    self.SleepInterval := ReadSMTPSleepInterval;

    self.emailcopies := ReadAddressees;
    self.emailret := ReadReturnAddress;


    self.SQLserver := ReadServerName;
    self.SQLDatabase := ReadDatabaseName;
  finally
    FreeAndNil(iniFile);
    SectINI.leave;
  end;
end;

procedure TSMTPMessagesThrd.InitDatabase;
var
  QEMails: TADOQuery;
  IDThreshold: Int64;
  birthstr: string;
begin
//    QEMails:=TADOQuery.Create(self.Connection);
//    QEMails.Connection := self.Connection;

//    try
//try
//        self.Connection.Open;
//        //self.Connection.Execute();
//        birthstr := DateTimeToStr(self.BithDay);
//        QEMails.SQL.Text := 'SELECT MIN(ID) FROM MAILS WHERE STATUS IS NULL';
//        try
//          QEMails.Open; QEMails.First;
//          if QEMails.RecordCount=1 then
//            IDThreshold:=QEMails.Fields[0].AsInteger //Int64?
//           else IDThreshold:=0;
//        finally
//
//        end;
//finally
//end;
//    except
//
//    end;
end;

function TSMTPMessagesThrd.isRunning: boolean;
var CNTX: _CONTEXT;
begin
  RESULT:=False;
try
    self.Suspend;
    try
        if self.inhibit then exit;
        CNTX.ContextFlags := 0; //CONTEXT_CONTROL or CONTEXT_INTEGER or CONTEXT_SEGMENTS;
        RESULT:=GetThreadContext(self.Handle,CNTX);
    finally
      self.Resume;
    end;
except on E: Exception do
    try
        if self.inhibit then exit;
        RESULT:=True;
        CNTX.ContextFlags := 0; //CONTEXT_CONTROL or CONTEXT_INTEGER or CONTEXT_SEGMENTS;
        RESULT:=GetThreadContext(self.Handle,CNTX);
    except on E: Exception do
              exit;
    end;
end;
end;

function TSMTPMessagesThrd.LoadQueue: integer;
const
  SQLSHUTOLD = 'SQLMARKOLDMESSAGES';
  SQLSELECTMAILS = 'SQLLoadQueue';
var i, j : integer;
  Qu: TADOQuery;
  EMessage: TEmailDscr;
begin
  RESULT:=0;
try
    Qu := TADOQuery.Create(nil);
    //sleep(30000);  *!* только для отладки *!*
    try
      //self.Connection.Execute(loadTextDataByTag(SQLSHUTOLD));    //не надо поскольку работает сборщик мусора
      Qu.Connection := self.Connection;
      Qu.SQL.Text := loadTextDataByTag(SQLSELECTMAILS);
      Qu.Open;
      if Qu.RecordCount = 0 then exit;
      i:=0;
      repeat
        with EMessage do
         begin
           ID := (Qu.Fields[0] as TLargeintField).AsLargeInt;
           mailTo:=Qu.FieldByName('email').AsString;
           subj := Qu.FieldByName('Subject').AsString;
           body := Qu.FieldByName('Body').AsString;
           attouch := Qu.FieldByName('attouch').AsString;
           bcc := Qu.FieldByName('bcc').AsBoolean;
           arch := Qu.FieldByName('arch').AsBoolean;
         end;
        //.ID := QU;
        AddEmail2Queue(Qu.FieldByName('ExpID').AsInteger,EMessage,Self.fMessages);
        Qu.Next;
      until Qu.Eof;
      RESULT:=i;
      Qu.Close;
    finally
      FreeAndNil(Qu);
    end;
except on E: Exception do
  EMessage.subj := E.Message;
end;
end;

class function TSMTPMessagesThrd.Restart(var Thread: TSMTPMessagesThrd): boolean;
var Queue: TThreadList;
begin
  RESULT:=Thread.inhibit;
  if Thread.inhibit then exit;
  self.FAULTSTATUS.faultmsg := '';
try
    Queue:=Thread.fMessages;
    Thread.Free;
    if Queue=nil then Queue := TThreadList.Create;
  
    Thread:=TSMTPMessagesThrd.Create(SMTPQueue);
    Thread.Logger:=MailLogger;
    Thread.Init;
    Thread.Resume;
  
    RESULT:=True;
except on E: Exception do
    self.FAULTSTATUS.faultmsg := E.Message;
end;
end;

//           try
//
//           except on E: Exception do
//            ID:=0;
//           end;

function TSMTPMessagesThrd.UpdateMessageStatus(ID: Int64; ExpId: integer; email: string; status: Boolean; var errmsg: string): boolean;
const SQLUPDATESTATUS = 'SQLUPDATEStatusCurrentRecord';
var SQLstr: string;
    TemplList, ReplList: TStringList; affect: integer;
begin
RESULT:=false;
affect:=-1;
  try
    SQLstr :=loadTextDataByTag(SQLUPDATESTATUS);//+IntToStr(ID);
    TemplList:=TStringList.Create; ReplList:=TStringList.Create;
    try
      TemplList.Add('##STATE##');  ReplList.Add(IntToStr(Ord(status)));
      TemplList.Add('##ID##');  ReplList.Add(IntToStr(ID));
      TemplList.Add('##ExpID##');  ReplList.Add(IntToStr(ExpID));
      TemplList.Add('##e-mail##'); ReplList.Add(email);
      SQLstr:=MultyReplace(SQLstr,TemplList,ReplList);
    finally
      FreeAndNil(TemplList); FreeAndNil(ReplList);
    end;
    Self.Connection.Execute(SQLstr, affect);
    ;
  except on E: Exception do
    begin
      if status then errmsg := copy(errmsg,pos(': ',errmsg)+1);
      errmsg:=trim( Concat(errmsg,' #'+IntToStr(ID),' [',IntToStr(ExpID) + ']: ', E.Message));
    end;
  end;
  self.FAULTSTATUS.SetState((affect<>1),ExpID,errmsg);
RESULT:=(affect = 1);
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
{ TMessSMTP }

//destructor TMessSMTP.Destroy;
//begin
//  try
////    if trim(filenamezip)='' then exit;
////
////    if FileExists(self.filenamezip) then
////      DeleteFile(self.filenamezip);
//  finally
//    inherited;
//  end;
//end;

{ TMessSMTP }

class function TMessSMTP.GetFromSQLDatabase(exportID: Integer;
  Qu: TADOQuery): TMessSMTP;
begin
//  Qu.SQL.Text := 'SELECT * FROM MAILS WHERE ID = (select max(ID) from MAILS where ProcessingTimestamp)';
end;

{ TFAULTSTATUS }

function TFAULTSTATUS.Excited: boolean;
begin
  RESULT:=self.occurred AND (self.stampID<>0);
end;

procedure TFAULTSTATUS.Init;
begin
  occurred:=False;
  stampID:=0;
  faultmsg:='';
end;

function TFAULTSTATUS.Recovery(Connection: TADOConnection): boolean;
const SQLFAULTRECOVERY = 'SQLFAULTRECOVERY';
var SQLstr: string; affect: integer;
begin
  RESULT:=false;
  if self.stampID=0 then exit;

  SQLStr:=loadTextDataByTag(SQLFAULTRECOVERY);
  SQLStr:=StringReplace(SQLstr,'##FAULTSTAMP##',IntToStr(self.stampID),[rfReplaceAll]);
  if Assigned(Connection) then  
  try
    Connection.Execute(SQLstr,affect);
    if (affect>0) then
      stampID := 0;
    RESULT:=(affect>0);
  except
  end;
end;

procedure TFAULTSTATUS.SetState(State: boolean; stamp: Integer; msg: string);
begin
  if State then
   begin
     if stampID = 0 then
      stampID := SIGN(Ord(occurred))*stamp;   //marquer la second occasion
     faultmsg := msg;
   end
   else
   begin
     stampID := 0;
     faultmsg := '';
   end;
  occurred:=State;
end;
begin
  TSMTPMessagesThrd.FAULTSTATUS.Init;
end.

