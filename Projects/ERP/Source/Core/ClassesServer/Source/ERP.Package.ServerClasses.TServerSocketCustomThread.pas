unit ERP.Package.ServerClasses.TServerSocketCustomThread;

interface

uses
  System.SyncObjs,
  System.SysUtils,
  System.Win.ScktComp,
  ERP.Package.Classes.TERPSocketStream,
  ERP.Package.ServerClasses.ServerTypes;

type
  TServerSocketCustomThread = class(TServerClientThread)
  private
    FGlobalStream: TERPSocketStream;
    FLock: TCriticalSection;
    FProcLoggerSocketThread: TProcLoggerSocketThread;
    FProcProcessedSocketThread: TProcProcessedSocketThread;
    FStartTime: TDateTime;
    function IsDestroing: Boolean;
    procedure DoLogger(aEventTypeSocketThread: TEventTypeSocketThread);
    procedure DoLoggerProcess(const aBuffer: TBytes; aSize: Integer);
  protected
    procedure ClientExecute; override;
  public
    constructor Create(aSocket: TServerClientWinSocket; aProcProcessedSocketThread: TProcProcessedSocketThread;
      aProcLoggerSocketThread: TProcLoggerSocketThread; aLock: TCriticalSection);
    property StartTime: TDateTime read FStartTime;
  end;

implementation

uses
  System.Classes;

{ TServerSocketCustomThread }

procedure TServerSocketCustomThread.ClientExecute;
var
  SocketStream: TWinSocketStream;
  SizeReceiveBuffer: Integer;
  ReallySizeReceiveBuffer: Integer;
  Buffer: TBytes;
begin
  FStartTime := Now();
  DoLogger(etstConnect);
  SocketStream := TWinSocketStream.Create(ClientSocket, 10000);
  try
    FGlobalStream := TERPSocketStream.Create();
    try
      while (not Terminated) and (ClientSocket.Connected) do
      begin
        if (not Terminated) and (SocketStream.WaitForData(1)) then
        begin
          try
            SizeReceiveBuffer := ClientSocket.ReceiveLength;
            if SizeReceiveBuffer > 0 then
            begin
              SetLength(Buffer, SizeReceiveBuffer);
              ReallySizeReceiveBuffer := SocketStream.Read(Buffer[0], SizeReceiveBuffer);
              if ReallySizeReceiveBuffer <> SizeReceiveBuffer then
                SetLength(Buffer, ReallySizeReceiveBuffer);
              // Добавляем в буфер то, что пришло.
              FGlobalStream.Seek(0, soEnd);
              FGlobalStream.WriteBuffer(Buffer[0], ReallySizeReceiveBuffer);
              // Отправляем в логгер
              DoLogger(etstRead);
              // Вычитываем 1-ую команду (это размер сообщения, которое мы должны получить)
              FGlobalStream.Position := 0;
              SizeReceiveBuffer := FGlobalStream.ReadInteger();
              // Если в буфере лежит всё сообщение, то отправляем на выполнение
              while (SizeReceiveBuffer <= FGlobalStream.Size - FGlobalStream.Position) and (FGlobalStream.Size > 0) do
              begin
                // Удаляем из буфера размер сообщения
                FGlobalStream.Delete(0, FGlobalStream.Position);
                // Отправляем в логгер
                DoLoggerProcess(FGlobalStream.Bytes, SizeReceiveBuffer);
                // Отправляем сообщение на обработку
                Synchronize(procedure
                            begin
                              FProcProcessedSocketThread(Self, FGlobalStream.Bytes[0], SizeReceiveBuffer);
                            end);
                // Удаляем обработанное сообщение
                FGlobalStream.Delete(0, SizeReceiveBuffer);
                // Вычитываем 1-ую команду (это размер сообщения, которое мы должны получить)
                if FGlobalStream.Size > 0 then
                begin
                  FGlobalStream.Position := 0;
                  SizeReceiveBuffer := FGlobalStream.ReadInteger();
                end
              end;
            end
            else
              Terminate();
          except
            Terminate();
          end;
        end;
      end;
      if not IsDestroing() then
        DoLogger(etstDisconnect);
      ClientSocket.Close;
    finally
      FGlobalStream.Free();
    end;
  finally
    SocketStream.Free();
  end;
end;

constructor TServerSocketCustomThread.Create(aSocket: TServerClientWinSocket;
  aProcProcessedSocketThread: TProcProcessedSocketThread; aProcLoggerSocketThread: TProcLoggerSocketThread;
  aLock: TCriticalSection);
begin
  Assert(Assigned(aProcProcessedSocketThread), 'aProcProcessedSocketThread is nil');

  inherited Create(False, aSocket);

  FLock := aLock;
  FProcProcessedSocketThread := aProcProcessedSocketThread;
  FProcLoggerSocketThread := aProcLoggerSocketThread;
end;

procedure TServerSocketCustomThread.DoLogger(aEventTypeSocketThread: TEventTypeSocketThread);
begin
  Synchronize(procedure
              begin
                if Assigned(FProcLoggerSocketThread) then
                  FProcLoggerSocketThread(aEventTypeSocketThread, Self);
              end);
end;

procedure TServerSocketCustomThread.DoLoggerProcess(const aBuffer: TBytes; aSize: Integer);
var
  DataBuffer: PBytes;
begin
  New(DataBuffer);
  try
    DataBuffer^ := aBuffer;
    SetLength(DataBuffer^, aSize);
    Data := DataBuffer;
    DoLogger(etstProcess);
    Data := nil;
  finally
    Dispose(DataBuffer);
  end;
end;

function TServerSocketCustomThread.IsDestroing: Boolean;
begin
  FLock.Enter();
  try
    if Assigned(ServerSocket.Data) then
      Result := Boolean(ServerSocket.Data^)
    else
      Result := False;
  finally
    FLock.Leave();
  end;
end;

end.
