unit UnitTelevision;

interface
uses UnitMonitoring,

//IdCustomTCPServer,
//  IdTCPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, Grids, ExtCtrls, Math,  SyncObjs,  inifiles, Menus,  StdCtrls,
  IdCustomTCPServer,  IdContext,
  IdTCPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;
type
      TTelevisor = Class(TInterfacedObject, IMonitoring)
      public
          function allocateChannel(Channel: TChannel): integer;
          function ReceiveFromChannel(No: integer): TFrame;
          function IMonitoring.ConnectToChannel = allocateChannel;
          function IMonitoring.getFrameFromChannel = ReceiveFromChannel;

          function getError: string;

          function liveStatus: boolean;
          function IMonitoring.isLive = liveStatus;
      private
          Receiver : TIdTCPClient;
          ChannNo: integer;
          lastError: string;
          live: boolean;
      published
      constructor Create(Receiver: TIdTCPClient; ChannelNo: integer);
      destructor Destroy; override;

      End;


      TBroadcaster = Class//(TMultyMonitor)
      private
        Center: TMultyMonitor;
        Transmitter: TIdTCPServer;
       procedure TransmitToChannel(Frame: TFrame; Context:TIdContext);

      public
        procedure Session(Context:TIdContext);
        procedure AllocChannels;
      published
      constructor Create(MonitoringCenter: TMultyMonitor; Transmitter: TIdTCPServer);
      destructor Destroy; override;
      End;
 var Televisor: TTelevisor;
     BroadCaster: TBroadCaster;
     Channel1: TChannel;
implementation

{ TTelevisor }

function TTelevisor.allocateChannel(Channel: TChannel): integer;
begin

end;

constructor TTelevisor.Create(Receiver: TIdTCPClient; ChannelNo: integer);
begin
  inherited Create;
  self.Receiver := Receiver;
  self.ChannNo := ChannelNo;
end;

destructor TTelevisor.Destroy;
begin

  inherited;
end;

function TTelevisor.getError: string;
begin
  RESULT:=lastError;
end;

function TTelevisor.liveStatus: boolean;
begin
  RESULT:=self.live;
end;

function TTelevisor.ReceiveFromChannel(No: integer): TFrame;
var
  //numberString : string;
  float        : Extended;
  errorPos     : Integer;

data: string; k,L:integer;
attempts, attenuer: integer;
begin
  SetLength(RESULT,0);
  if self.Receiver.Connected then self.Receiver.Disconnect;
  self.Receiver.ConnectTimeout := 5000;
try
  self.live := false;
  attenuer := $10;//attempts
  repeat
    attenuer := attenuer div 2;
    try
          self.Receiver.Connect;
    except on E: Exception do
     begin
      self.lastError := E.Message;
        if attenuer=0 then break else sleep(self.Receiver.ConnectTimeout div attenuer);
     end;
    end;
  until (self.Receiver.Connected);

  if self.Receiver.Connected then
   try
      self.lastError :='';
      self.live := self.Receiver.Connected;  //==true
      self.Receiver.Socket.WriteLn(IntToStr(No));
      //self.Receiver.Socket.ReadLn;
      self.Receiver.Socket.ReadTimeout := 2000;
      data:=self.Receiver.Socket.ReadLn;
      Val(data,float,errorPos);
      if errorPos>0 then exit;
      L:=Trunc(float);
      //self.live := false;
      self.live := L>=0;
      if L<0 then self.lastError:='Удалённый сервер не смог предоставить актуальные данные'; //exit;
      //L:=L;//в дальнейшем не обязательно выход
      SetLength(RESULT,abs(L));
      //self.live := true;
      for k := 0 to L - 1 do
       begin
        RESULT[k].tag := self.Receiver.Socket.ReadLn;
        data:= self.Receiver.Socket.ReadLn;
        if length(data)>0 then
          case data[1] of
            '0': RESULT[k].state:= false;
            '1': RESULT[k].state:= true;
          end;
          RESULT[k].f:=false;
          if length(data)>1 then RESULT[k].f := data[2]='f';
       end;
   except on E: Exception do self.lastError:=E.Message;
   end;
finally
    self.Receiver.Disconnect;
end;



end;

{ TBroadcaster }

procedure TBroadcaster.AllocChannels;
begin
  Channel1:=TCHannel.Create;
  Channel1.Desc.condition:= '1=1';
  self.Center.allocateChannel(Channel1);
end;

constructor TBroadcaster.Create(MonitoringCenter: TMultyMonitor; Transmitter: TIdTCPServer);
begin
  inherited Create;
  self.Center := MonitoringCenter;
  self.Transmitter := Transmitter;
  self.AllocChannels;
end;

destructor TBroadcaster.Destroy;
begin

  inherited;
end;


procedure TBroadcaster.Session(Context:TIdContext);
var data: string;
    float: real; errorpos: integer;
    ChNo: integer;
    //Frame: TFrame;
begin
  Context.Connection.Socket.ReadTimeout := 2000;
  Data:=Context.Connection.Socket.ReadLn;
  Val(Data,float,errorpos);
  if errorpos<>0 then exit;
  ChNo:=trunc(float);

  //Frame:= ;
  self.TransmitToChannel(self.Center.putFrameToChannel(ChNo), Context);

end;

procedure TBroadcaster.TransmitToChannel(Frame: TFrame; Context:TIdContext);
var  data: string;  k, L : integer;
begin
  if Frame=nil then exit;
  L:=length(Frame);
try
    Context.Connection.Socket.WriteLn(IntToStr(L));
    for k := 0 to L - 1 do
     begin
       Context.Connection.Socket.WriteLn(Frame[k].tag);
       if Frame[k].state then data := '1' else data:='0';
       if Frame[k].f then data:=data+'f';
       Context.Connection.Socket.WriteLn(data);
     end;   
except on E: Exception do
  exit;
end; //

end;


end.
