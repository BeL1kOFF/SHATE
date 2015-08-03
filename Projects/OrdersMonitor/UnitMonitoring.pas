unit UnitMonitoring;

interface

 uses
  Classes, SysUtils, Math,
  DB, ADODB, ActiveX, SyncObjs, Dialogs,inifiles
  ,UnitConfig;
 type

  TOrderDsc = Record
    tag: string;
    state: boolean;
    //N,Ready,queue,progress
    d: boolean;
    f: boolean;
  End;

  TOrder = Class
    Desc: TOrderDsc;
  public
    function Clone: TOrder;
  End;

  TFrame = array of TOrderDsc;

  TChannelSwitch = function(OrderDsc: TOrderDsc): boolean;

  TChannelDsc = Record
    condition: string;
    switch : TChannelSwitch;
  End;

  TChannel = Class
    Desc: TChannelDsc;
  published
    constructor Create;
    destructor Destroy;
  End;

  IMonitoring = interface     ['{611E0953-C36D-4A29-9A3C-A123B8D00F37}']

    function ConnectToChannel(Channel: TChannel): integer;
    function getFrameFromChannel(No: integer): TFrame;
    function isLive: boolean;
    function getError: string;
    property live: boolean read isLive;
    property lastError: string read getError;
  End;

  TTerminatorThread = Class(TTHread)
    private
      function GetTerminateState: boolean;
    public
      property Terminating: boolean read GetTerminateState;

  End;

  TMultyMonitor = Class(TInterfacedObject, IMonitoring)
  public

      function allocateChannel(Channel: TChannel): integer;
      function putFrameToChannel(No: integer): TFrame;
      function IMonitoring.ConnectToChannel = allocateChannel;
      function IMonitoring.getFrameFromChannel = putFrameToChannel;

      function getError: string;

      function liveStatus: boolean;
      function IMonitoring.isLive = liveStatus;
  private
      live: boolean;  lastError: string;
      Channels: array of TChannel;  //каналы для подключения экранов
      Monitors: array of TThreadList; //живые списки
      Frames: array of TFrame;     //защелкнутые кадры
      DimChls: integer;

  published
  constructor Create;
  destructor Destroy; override;
  End;

  TOrdersDispatcher = Class(TTerminatorThread)
    public
      Monitoring: TMultyMonitor;
      procedure Init;
      procedure Execute; override;

      //function allocateChannel(Channel: TChannel): integer;


      //function putFrameToChannel(No: integer): TList;



    published
      constructor Create;
      destructor Destroy; override;
    private
      HOLD: TCriticalSection;
            
      server, database,firm: string;

      Connection: TADOConnection;               //      Query: TADOQuery;
      apparole: boolean;
      Orders: TThreadList;         //№0!!!
      Channel0: TChannel;
      interval: integer;
      procedure Connect;
      procedure disconnect;
      function SendToMonitor(No: integer; Order: TOrder): integer;
      function LoadOrdersList(Q: TADOQuery): boolean;
      function RepayScreens: boolean;
      function LightScreens: boolean;
    //;

  End;

 CONST DEFAULTSLEEP = 30*1000;

        DEFAULTSERVER = 'SVBYPRISA0012';
        DEFAULTDATABASE = 'Shate-M-test';//-sdev

 var Dispatcher: TOrdersDispatcher;
     Monitoring : IMonitoring;
{$R RESLIB.RES}
implementation



   function trivial(OrderDsc: TOrderDsc): boolean; inline; begin RESULT:=True; end;


   procedure dogSleep(pause, part: integer; Thread: TTerminatorThread);
   var depart: integer;
   begin
    repeat
      sleep(part);
      if Thread.Terminated then exit;
      dec(pause, part);
    until pause<0;
   end;

   function inFrame(Desc:TOrderDsc; Frame0: TFrame; var k: integer): boolean;
   var L: integer;
   begin
     RESULT:=True;

     k:=0; L:=Length(Frame0);
     while k < L do
      begin
        if Frame0[k].tag = Desc.tag then exit;
        inc(k);
      end;
     RESULT:=False;
   end;

{ TOrdersDispatcher }

//function TOrdersDispatcher.allocateChannel(Channel: TChannel): integer;


procedure TOrdersDispatcher.Connect;
begin
try
   if self.Connection.Connected then
      self.Connection.Close
    else
      self.Connection.ConnectionString := generateConnStr(false,self.server,self.database);
except on E: Exception do
  //ShowMessage(E.Message);
end;
try
    self.Connection.Open;
except on E: Exception do
 begin
  Monitoring.lastError := '"'+E.Message+'"'; //MessageDlg(E.Message,mtError,[mbYes],0);
  exit;
 end;
end;
try
  if self.apparole  then
    self.Connection.Execute(loadTextDataByTag('SQLMAGICWORD'),cmdText,[eoExecuteNoRecords]);{loadStrFromFile('SQLMAGICWORD.QRY')}
except
  self.apparole:=false;
end;
end;

constructor TOrdersDispatcher.Create;
begin
  inherited Create(True);

  self.Connection := TADOConnection.Create(nil);

  self.Orders := TThreadList.Create;
  self.Channel0 := TChannel.Create;
  self.Monitoring:= TMultyMonitor.Create;
  //self.Monitoring.allocateChannel(self.Channel0);
  HOLD := TCriticalSection.Create;
end;

destructor TOrdersDispatcher.Destroy;
begin
  FreeAndNil(HOLD);

  //FreeAndNil(self.Channel0);
  FreeAndNil(self.Orders);
  //Monitoring не разрушается?
  FreeAndNil(self.Connection);
  CoUninitialize;
  inherited;
end;

procedure TOrdersDispatcher.disconnect;
begin
  self.Connection.Close;
end;

procedure TOrdersDispatcher.Execute;
const WAITING = 1000;
var Q: TADOQuery;  errf: text;
begin
  inherited;
  CoInitializeEx(nil, COINIT_MULTITHREADED);
  //self.Init;
  Q:=TADOQuery.Create(nil);

  Q.CursorLocation := clUseClient;
  Q.LockType := ltBatchOptimistic;
  Q.CursorType := ctStatic;

  Q.CommandTimeout := 2000;

  Q.SQL.Text := loadTextDataByTag('SQLLoadQUEUE');

try  try
    repeat
      self.RepayScreens;
      self.Monitoring.live := self.LoadOrdersList(Q);
      self.LightScreens;
      dogsleep(interval,WAITING,self);
    until Terminated;
except on Err: Exception do
  //ShowMessage('ПОток отвалился со следующей ошибкой: "'+Err.Message+'"')
  try
    assignfile(errf,'errors.log');
    if FileExists('errors.log') then Append(errf) else Rewrite(errf);
    writeln(errf,DateTimeToStr(Now())+' Поток отвалился со следующей ошибкой: "'+Err.Message+'"');
  finally
    CloseFile(errf);
  end;
end;
finally
  Q.Free;
  CoUninitialize;
end;
end;

procedure TOrdersDispatcher.Init;
begin
  self.Connection.LoginPrompt := false;
  self.interval := DEFAULTSLEEP;
  self.Monitoring.allocateChannel(Channel0);

  self.apparole :=TRUE;
  self.server :=  DEFAULTSERVER;
  self.database := DEFAULTDATABASE;


  iniFile:=TINIFile.Create(ExtractFilePath(Paramstr(0))+FILENAMEINI);
  try
    self.server:=ReadServerName;
    if self.server='' then self.server := DEFAULTSERVER;
    self.database := ReadDatabaseName;  if self.database='' then self.database := DEFAULTDATABASE;
    self.firm := ReadFirmName;

    self.interval := ReadSleepInterval; if self.interval=0 then self.interval := DEFAULTSLEEP;
  finally
    iniFile.Free;
  end;
end;

function TOrdersDispatcher.LightScreens: boolean;
var k: integer;   Frame: TList; Obj: TOrder; i: integer;
begin

end;

function TOrdersDispatcher.LoadOrdersList(Q: TADOQuery): boolean;
var Order: TOrder;
    k: integer;
    attenuer: integer;
    scc: boolean;
begin
  Q.Connection := self.Connection;

   attenuer:=$10; { self.interval div attenuer}
  repeat
   self.Connect;
   scc:=false;
  try
    Q.Open;

    Q.Connection := nil;
    self.disconnect;

    for k := 0 to self.Monitoring.DimChls - 1 do
      if self.Monitoring.Monitors[k]<>nil then self.Monitoring.Monitors[k].LockList;


    Q.First;
    repeat
      Order := TOrder.Create;
      with Order.Desc do
       begin
         tag := Q.FieldByName('TAG').AsString;
         //queue := Q.FieldByName('queue').AsInteger;
         //Ready := Q.FieldByName('READY').AsInteger;


         state :=  Q.FieldByName('COMPLETE').AsInteger=1; //queue=0;
          //N:= queue + Ready;
          if Q.FieldByName('LOCALIZATION').IsNull then
            d:= state
           else
            d := (Q.FieldByName('LOCALIZATION').AsInteger=0); // true;
          //progress := Q.FieldByName('PROGRESS').AsInteger;
         f:=false; //сброс флага обновления
       end;
      for k := 0 to self.Monitoring.DimChls - 1 do
        if self.Monitoring.Channels[k].Desc.switch(Order.Desc) then
          self.Monitoring.Monitors[k].Add(Order.Clone); //LockList необязательно?  //Клон обязателен!!!
      Q.Next;
      Order.Free;  //распускаем промежуточный объект
    until Q.Eof;
    Q.Close;
    for k := 0 to self.Monitoring.DimChls - 1 do
      if self.Monitoring.Monitors[k]<>nil then self.Monitoring.Monitors[k].UnLockList;
    
      scc:=true;
  except on E: Exception do //
   begin    //адаптивное ожидание интервал делится на 16
     self.Monitoring.lastError := E.Message;
     self.apparole := not(self.apparole);

     dogSleep($10 + self.interval div attenuer, $10 div attenuer, self);
     attenuer := attenuer div 2;
     //if attenuer<1 then ShowMessage(E.Message);
   end;
  end;
  until scc OR self.Terminated OR (attenuer<1);
  RESULT:=scc;
end;

//function TOrdersDispatcher.putFrameToChannel(No: integer): TList;




function TOrdersDispatcher.RepayScreens: boolean;
var k, i: integer; Monitor: TList;
begin
  //self.HOLD.Enter;
  try
    for k := 0 to self.Monitoring.DimChls - 1 do
    try
     begin
      Monitor:= self.Monitoring.Monitors[k].LockList;
      for i := 0 to Monitor.Count - 1 do
       if Monitor<>nil then
        TOrder(Monitor[i]).Free;
      self.Monitoring.Monitors[k].Clear;
     end;
    finally
      self.Monitoring.Monitors[k].UnlockList;
    end;
  finally
  //self.HOLD.Leave;
  end; 
end;

function TOrdersDispatcher.SendToMonitor(No: integer;
  Order: TOrder): integer;
  var Frame: TList;
begin
  RESULT:=0;
  if No+1>self.Monitoring.DimChls then exit;

  Frame:=self.Monitoring.Monitors[No].LockList;
  try
    self.Monitoring.Monitors[No].Add(Order);
    RESULT:=Frame.Count;
  finally
    self.Monitoring.Monitors[No].UnlockList;
  end;
end;

{ TTerminatorThread }

function TTerminatorThread.GetTerminateState: boolean;
begin
  RESULT:=self.Terminated;
end;

{ TMultyMonitor }

function TMultyMonitor.allocateChannel(Channel: TChannel): integer;
begin
  inc(self.DimChls);
  SetLength(self.Channels,DimChls);
  SetLength(self.Monitors,DimChls);
  //SetLength(self.Frames,DimChls);
  SetLength(self.Frames,self.DimChls); //кадр;
  dec(self.DimChls);
  self.Channels[self.DimChls]:=Channel;
  self.Monitors[self.DimChls]:=TThreadList.Create;
  //self.Frames[self.DimChls]:=TList.Create;
  inc(self.DimChls);
end;

constructor TMultyMonitor.Create;
begin
  inherited Create;
  self.DimChls := 0;
end;

destructor TMultyMonitor.Destroy;
var k: integer;
begin
  for k := DimChls - 1 downto 0 do
   try
       //FreeAndNil(self.Frames[k]);
       if Assigned(self.Monitors[k]) then         FreeAndNil(self.Monitors[k]);
       if Assigned(self.Channels[k]) then         FreeAndNil(self.Channels[k]);
   except
   end;
  inherited;
end;
function TMultyMonitor.getError: string;
begin
  RESULT:=self.lastError;
end;

function TMultyMonitor.liveStatus: boolean;
begin
  RESULT:= self.live
end;

//возвращает массив текущих состояний заказов
function TMultyMonitor.putFrameToChannel(No: integer): TFrame;
var Buf: TList; i, j, L: integer;
begin

  RESULT:=nil;
  if No+1>self.DimChls then exit;
  if self.Monitors[No] = nil then exit;
  Buf:=self.Monitors[No].LockList;
  if Buf=nil then exit;
  try
  if Buf.Count=0 then exit;
  L:=length(self.Frames[No]);//Buf.Count; //fixed приводило к ошибке при сокращении списка
  SetLength(RESULT, L);//Buf.Count
  for i := 0 to Buf.Count - 1 do   {RESULT[i]:=TOrder(Buf[i]).Desc;}
   begin //преемставенность фреймов, чтобы позиция по возможности оставалась на своём месте
     if inFrame(TOrder(Buf[i]).Desc,self.Frames[No],j) then
      begin
       RESULT[j]:=TOrder(Buf[i]).Desc;
       RESULT[j].f := RESULT[j].state>self.Frames[No][j].state;
       RESULT[j].f := RESULT[j].f OR (RESULT[j].d > self.Frames[No][j].d);
      end
      else
      begin
        SetLength(RESULT, L+1);
        RESULT[L]:=TOrder(Buf[i]).Desc;
        inc(L);
      end;
   end;

    L:=length(RESULT);
    j:=0;  L:=L-1;
    while j<L do
     if RESULT[j].tag='' then
      begin
        RESULT[j]:=RESULT[L];
        SetLength(RESULT,L);
        dec(L);
        if L<Buf.Count then break;
      end
      else inc(j);

    L:=L+1;
    SetLength(self.Frames[No],L);
    for j := 0 to L - 1 do
     self.Frames[No][j]:=RESULT[j];
  finally
    self.Monitors[No].UnlockList;
  end;
end;
//  try
//    if self.Frames[No] = nil then RESULT := self.Monitors[No].LockList
//     else                         RESULT := self.Frames[No];
//  finally
//    self.Monitors[No].UnlockList;
//  end;
{ TChannel }

constructor TChannel.Create;
begin
  inherited;
  self.Desc.condition := '1=1';
  self.Desc.switch := trivial;
end;

{ TOrder }


destructor TChannel.Destroy;
begin

  inherited;
end;

{ TOrder }

function TOrder.Clone: TOrder;
begin
  RESULT:=TOrder.Create;
  RESULT.Desc := self.Desc;
end;

end.
