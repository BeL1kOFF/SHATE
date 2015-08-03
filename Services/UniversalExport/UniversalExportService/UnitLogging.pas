unit UnitLogging;

interface
uses SysUtils,ADODB, Windows,  Classes,  Contnrs,
    UnitConfig;
Type

    IAction = Interface(IInterface)
      //procedure ReportResult(status: boolean);
      //procedure ReportError(Err: Exception);
      
      procedure Stamp(Step: string);
      procedure timeStamp(Step: string);
      procedure Start;
      procedure Interrupt;
      procedure Resume(success: boolean);
      procedure Finish;
      procedure Report;
      procedure Catch(Err: Exception);

      procedure Note(info: string);
    End;

    EInterrupt = Class(Exception)

    End;

    TLogMsg = Record
      msgtype, msglvl: integer;
      timestamping: boolean;
      eventtype,
      eventcategory: integer;
      title,
      body: string
    End;
    TLogger = Class//(TInterfacedObject)
    private
      level,back: integer;
      Actions: TList;
      successmsg, failmsg: string;
      toFile, toDatabase: boolean;
      filelog: string;
      ff: text;

      ActionsStack: TStack;

      ADOConn: TADOConnection;
      function Connect: boolean;
      function Disconnect: boolean;

      function Print(rec: TLogMsg): boolean;
      function ExecInsertLog(rec: TLogMsg): boolean;
      function WriteFileLog(rec: TLogMsg): boolean;

      function GetDirection: bit;
      procedure SetDirection(b: bit);
    public
      Name: string;
      serverName, DBName: string;
      procedure setDB(server,db: string);
      procedure setMessages(msgsuccess, msgfail: string);
      procedure logstep(step: string);
      procedure printtime(Action: IAction);
      procedure ErrorsLogging(Err: Exception; backlevel: integer);

      procedure PrintResult(success: boolean);

      procedure PrintInfo(content: string);
      procedure PrintLog(msg: string; timestamp: boolean);

    //published
      property direction: bit Read getDirection Write setDirection;

     published
      constructor Create(nick: string; level: integer);
      destructor  Destroy; override;
    End;


    TAction = Class(TInterfacedObject, IAction)
    public
      Name: string;
      InfoChannel: TLogger;
      status: boolean;
      success: boolean;
      catchException: boolean;
      procedure Start;
      procedure Interrupt;  //HALT?
      procedure Resume(success: boolean);
      procedure Finish;

      procedure Catch(Err: Exception);

      procedure Report; overload;
      procedure Report(Err: Exception); overload;
      procedure Report(status: boolean); overload;
      procedure Stamp(Step: string);
      procedure timestamp(Step:string);
      procedure Note(info: string);
      procedure IAction.Report=Report;
      procedure IAction.Catch = Catch;
      //procedure IAction.ReportResult=Report;
      //procedure IAction.ReportError=Report;
      //procedure IAction.StapStamp = Log
      constructor Create(act: string; Messager: TLogger; throwException: boolean); overload;
    private
      Err: Exception;
      ErrMsg: string;
      Info: string;
      Time0, Time: TDatetime;
    published
      constructor Create(act: string; Messager: TLogger); overload;
      destructor Destroy; override;
    End;



CONST SQLINSERTLOG = 'INSERT INTO [EVENTSLOG] ([Source],[EventTime],[EventLevel],[EventCategory],[EventType],[EventTitle],[EventMessage])'
//([Logger],[EventTime],[EventType],[EventLevel],[EventTitle],[EventMessage])'
                      +'  VALUES(##LOGGER##,##TIME##,##LEVEL##,##CATEGORY##,##TYPE##,##TITLE##,##MESSAGE##)';


var UniversalLogger, MailLogger : TLogger;
implementation

{ TLogger }

function TLogger.Connect: boolean;
var    userNameLen: Cardinal;
    user, provider,security,UserID,initcatalog,datasource: string;
begin
    RESULT:=False;
    if ADOConn.Connected then exit;
    userNameLen:=255;
    setLength(user, userNameLen);

    getUserName(PAnsiChar(user),userNameLen);
    provider:='Provider=SQLOLEDB.1;';
    security:='Integrated Security=SSPI;Persist Security Info=True;';
    userID  :='User ID='+copy(user,1,UserNameLen-1)+';';
    datasource:='Data Source='+serverName+';';
    InitCatalog := 'Initial Catalog='+dbName+';';

    ADOConn.ConnectionString := provider+security+UserID+initcatalog+datasource;
    ADOConn.Connected:=True;
    RESULT:=ADOConn.Connected;   //fix undefined result
end;

constructor TLogger.Create(nick: string; level: integer);
begin
inherited Create;
  self.Name:=nick;//Name; fix anonime logging
  ADOConn:= TADOConnection.Create(nil);
  //ADOConn.ConnectionString:=
  self.filelog := IncludeTrailingBackslash(ExtractFilePath(Paramstr(0)))+ nick+'.log';//'logger';
  self.toFile:=length(self.filelog)>0;
  self.toDatabase:=length(self.DBName)>0;
  if self.toFile then
   begin
    Assign(self.ff,self.filelog);
    if Not FileExists(self.filelog) then
    try
        try
           Rewrite(ff);
        finally
           CloseFile(ff);
        end;
    except on E: Exception do
      self.toFile:=false;
    end;
   end;
  self.successmsg := 'успешно';
  self.failmsg := 'неудачно';


  self.Actions := TList.Create;

end;

destructor TLogger.Destroy;
begin
//
  FreeAndNil(ADOConn);
inherited;
end;

function TLogger.Disconnect: boolean;
begin
  ADOConn.Connected:=False;
  RESULT:= NOT ADOConn.Connected;
end;

procedure TLogger.ErrorsLogging(Err: Exception; backlevel: integer);
var fe: text;  rec: TLogMsg;
begin
   //???

   with rec do
    begin
      msgtype := EVENTLOG_ERROR_TYPE;
      msglvl := backlevel;
      timestamping := true;
      eventtype := EVENTLOG_ERROR_TYPE;
      eventcategory := 0;
      title := Err.ClassName;
      body := Err.Message;
      if backlevel>0 then
        body := Concat(body, #$D#$A, '}');
    end;
   if self.Print(rec) then exit;
   if backlevel>0 then exit; //?? в лог не выводим внутренние ошибки?

   Assign(fe,FILEERRLOG);
   try
     if FileExists(FILEERRLOG) then Append(fe) Else Rewrite(fe);
     try
       writeln(Datetimetostr(Now),#9,Err.Message);
     finally
       CloseFile(fe);
     end;
   except

   end;
end;

function TLogger.ExecInsertLog(rec: TLogMsg): boolean;
var TemplList, ReplList: TStringList;
    SQLstr: string;
    aff:integer;
begin
  RESULT:=false;
  if rec.title='' then
   if rec.body[1] in ['{','}'] then
    begin
      rec.title := copy(rec.body,2);
      rec.body:=copy(rec.body,1,1);
    end;
  TemplList:=TStringList.Create;ReplList:=TStringList.Create;
  try
    TemplList.Add('##LOGGER##');
    if self.Name='' then REplList.Add('NULL') else ReplList.Add(''''+self.Name+'''');

    TemplList.Add('##TIME##');
    if rec.timestamping then  ReplList.Add('GetDate()')
     else                     ReplList.Add('NULL');
        TemplList.Add('##CATEGORY##');  ReplList.Add(IntToStr(rec.eventcategory));
    TemplList.Add('##TYPE##');  ReplList.Add(IntToStr(rec.msgtype));
    TemplList.Add('##LEVEL##');  ReplList.Add(IntToStr(rec.msglvl));
    TemplList.Add('##TITLE##');
    if rec.title='' then REplList.Add('NULL') else ReplList.Add(''''+rec.title+'''');
    TemplList.Add('##MESSAGE##');
    if rec.body='' then ReplList.Add('NULL') else ReplList.Add(''''+rec.body+'''');

    //TemplList.Add('##LOGGER##');  ReplList.Add('');
    SQLstr:=MultyReplace(SQLINSERTLOG,TemplList,ReplList);
    if self.Connect then
     try
      ADOConn.Execute(SQLstr,aff);
     finally
      self.Disconnect;
     end;
    RESULT := (aff>0);
  finally
    FreeAndNil(TemplList); FreeAndNil(ReplList);
  end;
end;

function TLogger.GetDirection: bit;
begin
  RESULT:=ORD(self.toFile<self.toDatabase);
end;

procedure TLogger.logstep(step: string);
var msgRec: TLogMsg;
begin
  with msgRec do
   begin
    msgtype := EVENTLOG_INFORMATION_TYPE;//0;
    msglvl := self.level;
    timestamping := false;
    title := TAction(self.Actions[0]).Name;
    body:='-- '+step;
   end;

   self.Print(msgRec);
end;

function TLogger.Print(rec: TLogMsg): boolean;
begin
  if self.toFile then
  try
    RESULT:=self.WriteFileLog(rec);
  except
    self.toFile:=False;
    self.direction:=1;
  end;
  if self.toDatabase then
  try
    RESULT:=self.ExecInsertLog(rec);
  except
    self.toDatabase:=False; //on E: Exception do self.failmsg:= E.Message;
    self.direction:=0;
  end;
end;

procedure TLogger.PrintInfo(content: string);
var msgRec: TLogMsg;
begin
  with msgRec do
   begin
    msgtype := EVENTLOG_INFORMATION_TYPE;//0;//TAction(self.ActionsStack[0]).
    msglvl := self.level;
    timestamping := false;
    title := TAction(self.Actions[0]).Name;
    body := content;
   end;
   self.Print(msgRec);
end;

procedure TLogger.PrintLog(msg: string; timestamp: boolean);
var msgRec: TLogMsg;
begin
  with msgRec do
   begin
    msgtype := EVENTLOG_INFORMATION_TYPE;//0;//TAction(self.ActionsStack[0]).
    msglvl := self.level;
    timestamping := timestamp;
    if msg='' then  title := TAction(self.Actions[0]).Name
     else body := msg;
   end;
   self.Print(msgRec);
end;

procedure TLogger.PrintResult(success: boolean);
var msgRec: TLogMsg;
begin
  with msgRec do
   begin
    msgtype := EVENTLOG_INFORMATION_TYPE;//0;//TAction(self.ActionsStack[0]).
    msglvl := self.level;
    timestamping := true;
    title := TAction(self.Actions[0]).Name;
    if success then body := #9+' # ' + self.successmsg
     else body := #9+' # ' + self.failmsg;
    body:=concat(body,#$D#$A)
   end;
   self.Print(msgRec);
end;

procedure TLogger.printtime(Action: IAction);
var msgRec: TLogMsg;
begin
  with msgRec do
   begin
    msgtype := EVENTLOG_INFORMATION_TYPE;//TAction(self.ActionsStack[0]).
    msglvl := self.level;
    timestamping := true;
    title :='.... '+ TAction(self.Actions[0]).Name + ' ....';
    body := '';
   end;
   self.Print(msgRec);
end;

procedure TLogger.setDB(server, db: string);
begin
  self.serverName:=trim(server);
  self.DBName:=trim(db);
  self.toDatabase:=length(server)*length(db)>0;
end;

procedure TLogger.SetDirection(b: bit);
begin
  case b of
    0:  self.toFile:=FileExists(self.filelog);
    1:  self.toDatabase:=(self.serverName<>'') AND (self.DBName<>'');
  end;   
end;

procedure TLogger.setMessages(msgsuccess, msgfail: string);
begin
  self.successmsg := msgsuccess;
  self.failmsg := msgfail;
end;

function TLogger.WriteFileLog(rec: TLogMsg): boolean;
var line: string;
begin
RESULT:=False;
  if isZeroMemoryRegion(@self.ff,SizeOf(self.ff)) then exit;

  if rec.timestamping then line:=DatetimeToStr(now)+#9 else line := StringOfChar(' ',20)+#9;//#9#9#9


  if trim(rec.body)<>'' then line:=line+{#$D#$A+4+}StringOfChar(#9,rec.msglvl)+rec.body//+'-- '
   else  line:= Concat(line, StringOfChar(#9,rec.msglvl),rec.title);
try
    Append(self.ff);
    Writeln(ff,line);
finally
    CloseFile(ff);
end;
RESULT:=True;
end;

{ TAction }

procedure TAction.Catch(Err: Exception);
begin
  dec(self.InfoChannel.level);
  //self.Err := ExceptClass(Err).Create(Err.Message);//Exception. изменено, чтобы сохранять класс ошибки
  self.Err := System.AcquireExceptionObject; //мавзолей ошибки 
  if self.catchException then  exit;
  if Err is EInterrupt then exit;
  //* Raise Err; ? выбросить ошибку?
end;

constructor TAction.Create(act: string; Messager: TLogger);
begin
  self.Name := act;
  self.InfoChannel := Messager;

  self.InfoChannel.Actions.Insert(0,self);
end;

constructor TAction.Create(act: string; Messager: TLogger;
  throwException: boolean);
begin
  Create(act,Messager);
  self.catchException := not throwException;
end;

destructor TAction.Destroy;
begin
  //уровень отступа может уменьшаться во время обработки ошибок - опционально
  //if self.InfoChannel.Actions.First=self then   dec(self.InfoChannel.level, 1-ord(self.status));
 //if self.InfoChannel.Actions.Count<self.InfoChannel.level then

  self.InfoChannel.Actions.Remove(self);
  if self.InfoChannel.level>self.InfoChannel.Actions.Count then  dec(self.InfoChannel.level);

  self.InfoChannel:=nil;
  inherited;
end;

procedure TAction.Finish;
begin
  self.Time := Now;
  self.status := (self.Err=nil);//True;

  self.InfoChannel.printtime(self);
  self.InfoChannel.PrintInfo('} Длительность операции: '+ DatetimeIntervalToString(Time-Time0));    // DateTimeToStr
  dec(self.InfoChannel.level);
end;

procedure TAction.Interrupt;
begin
  Raise EInterrupt.Create('# Во время выполнения операции <<'+self.Name+'>> поступил сигнал внешнего завершения');
end;

procedure TAction.Note(info: string);
begin
  self.Info := Info
end;

procedure TAction.Report;
begin
//  if Assigned(Err) then self.Report(Err)
//  else self.Report(self.status);
  if self.status then    self.Report(self.status AND self.success)
  else self.Report(Err);
end;

procedure TAction.Report(Err: Exception);
begin
  if Err=nil then exit;
  self.InfoChannel.PrintInfo(self.Info); //вывод отладочной информации
  self.InfoChannel.ErrorsLogging(Err, self.InfoChannel.level-1);//*!
  if catchException then exit;
  Raise Err;
end;

procedure TAction.Report(status: boolean);
begin
  self.InfoChannel.PrintResult(status);
end;

procedure TAction.Resume(success: boolean);
begin
  self.success := success
end;

procedure TAction.Stamp(Step: string);
begin
  self.InfoChannel.logstep(Step);
end;

procedure TAction.Start;
var msgRec: TLogMsg;
begin
  self.status := false;
  inc(self.InfoChannel.level);
  if self.success then
   begin //действие выполнялось ранее и требуется переинициализация
    self.success := false;
    self.InfoChannel.PrintLog('...{'+self.Name+'}...',true);
   end
   else
    self.InfoChannel.PrintLog('{ * '+self.Name+' * ',true);//'='+self.Name+'='
  self.Time0 := Now;
end;
procedure TAction.timestamp(Step: string);
begin
  self.InfoChannel.PrintLog(' -- '+Step,true);
end;

initialization


finalization
  //FreeAndNil(UniversalLogger);
end.
