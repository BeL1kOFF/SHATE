unit ERP.Package.ClientClasses.TERPSocketClient;

interface

uses
  System.Classes,
  System.Win.ScktComp,
  ERP.Package.Classes.TERPSocketStream;

type
  TOnProcessingCommand = procedure (const aBuffer; aSize: Integer) of object;

  TOnClientConnectionErrorEvent = procedure (Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer) of object;

  TClientConnectionLoggerEventType = (ccletConnect, ccletDisconnect);

  TOnClientConnectionLoggerEvent = procedure (const aEvent: TClientConnectionLoggerEventType;
    Socket: TCustomWinSocket) of object;

  TOnClientConnectionCommandEvent = procedure (aCommand: Integer) of object;

  TERPSocketClient = class
  private
    FClientSocket: TClientSocket;
    FOnClientConnectionCommandEvent: TOnClientConnectionCommandEvent;
    FOnClientConnectionErrorEvent: TOnClientConnectionErrorEvent;
    FOnClientConnectionLoggerEvent: TOnClientConnectionLoggerEvent;
    FOnProcessingCommand: TOnProcessingCommand;
    FGlobalBuffer: TERPSocketStream;
    procedure DoConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DoRead(Sender: TObject; Socket: TCustomWinSocket);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Close;
    procedure Open;
    procedure SendAuthData(const aLogin, aPassword: string);
    procedure SendChangePassword(const aLogin, aPassword: string);
    procedure SendCommandGetDBList(aId_User: Integer);
    procedure SendForLoadModule(aId_User, aIdDataBase: Integer);
    procedure SendLoadMenu(aId_User, aIdDataBase: Integer);
    procedure SetSocketEvent(aOnClientConnectionErrorEvent: TOnClientConnectionErrorEvent;
      aOnClientConnectionLoggerEvent: TOnClientConnectionLoggerEvent;
      aOnClientConnectionCommandEvent: TOnClientConnectionCommandEvent);
    property OnProcessingCommand: TOnProcessingCommand read FOnProcessingCommand write FOnProcessingCommand;
  end;

implementation

uses
  System.SysUtils,
  Vcl.Forms,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.Classes.TCustomWinSocketHelper,
  ERP.Package.ClientClasses.ERPOptions;

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(Application.ExeName) + 'ERP.xml');
end;

{ TERPSocketClient }

procedure TERPSocketClient.Close;
begin
  FClientSocket.Close();
end;

constructor TERPSocketClient.Create;
begin
  FGlobalBuffer := TERPSocketStream.Create(nil);
  FClientSocket := TClientSocket.Create(nil);
  FClientSocket.Host := GetOptions().Socket.Server;
  FClientSocket.Port := GetOptions().Socket.Port;
  FClientSocket.OnRead := DoRead;
  FClientSocket.OnError := DoError;
  FClientSocket.OnConnect := DoConnect;
  FClientSocket.OnDisconnect := DoDisconnect;
end;

destructor TERPSocketClient.Destroy;
begin
  FClientSocket.Free();
  FGlobalBuffer.Free();
  inherited Destroy();
end;

procedure TERPSocketClient.DoConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Assigned(FOnClientConnectionLoggerEvent) then
    FOnClientConnectionLoggerEvent(ccletConnect, Socket);
end;

procedure TERPSocketClient.DoDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Assigned(FOnClientConnectionLoggerEvent) then
    FOnClientConnectionLoggerEvent(ccletDisconnect, Socket);
end;

procedure TERPSocketClient.DoError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if Assigned(FOnClientConnectionErrorEvent) then
    FOnClientConnectionErrorEvent(Socket, ErrorEvent, ErrorCode);
end;

procedure TERPSocketClient.DoRead(Sender: TObject; Socket: TCustomWinSocket);
var
  SizeReceiveBuffer: Integer;
  Buffer: TBytes;
begin
  CreateSQLCursor();
  SizeReceiveBuffer := Socket.ReceiveLength();
  if SizeReceiveBuffer > 0 then
  begin
    SetLength(Buffer, SizeReceiveBuffer);
    Socket.ReceiveBuf(Buffer[0], SizeReceiveBuffer);
    // Добавляем в буфер то, что пришло.
    FGlobalBuffer.Seek(0, soEnd);
    FGlobalBuffer.WriteBuffer(Buffer[0], Length(Buffer));
    // Вычитываем 1-ую команду (это размер сообщения, которое мы должны получить)
    FGlobalBuffer.Position := 0;
    SizeReceiveBuffer := FGlobalBuffer.ReadInteger();
    // Если в буфере лежит всё сообщение, то отправляем на выполнение
    while (SizeReceiveBuffer <= FGlobalBuffer.Size - FGlobalBuffer.Position) and (FGlobalBuffer.Size > 0) do
    begin
      // Удаляем из буфера размер сообщения
      FGlobalBuffer.Delete(0, FGlobalBuffer.Position);
      // Отправляем сообщение на обработку
      FOnProcessingCommand(FGlobalBuffer.Bytes[0], FGlobalBuffer.Size);
      FGlobalBuffer.Position := 0;
      FOnClientConnectionCommandEvent(FGlobalBuffer.ReadInteger());
      // Удаляем обработанное сообщение
      FGlobalBuffer.Delete(0, SizeReceiveBuffer);
      // Вычитываем 1-ую команду (это размер сообщения, которое мы должны получить)
      if FGlobalBuffer.Size > 0 then
      begin
        FGlobalBuffer.Position := 0;
        SizeReceiveBuffer := FGlobalBuffer.ReadInteger();
      end;
    end;
  end;
end;

procedure TERPSocketClient.Open;
begin
  FClientSocket.Open();
end;

procedure TERPSocketClient.SendAuthData(const aLogin, aPassword: string);
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(CLIENT_COMMAND_AUTH);
    Buffer.WriteString(aLogin);
    Buffer.WriteString(aPassword);
    FClientSocket.Socket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

procedure TERPSocketClient.SendChangePassword(const aLogin, aPassword: string);
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(CLIENT_COMMAND_CHANGEPASSWORD);
    Buffer.WriteString(aLogin);
    Buffer.WriteString(aPassword);
    FClientSocket.Socket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

procedure TERPSocketClient.SendCommandGetDBList(aId_User: Integer);
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(CLIENT_COMMAND_GETDBLIST);
    Buffer.WriteInteger(aId_User);
    FClientSocket.Socket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

procedure TERPSocketClient.SendForLoadModule(aId_User, aIdDataBase: Integer);
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(CLIENT_COMMAND_GETMODULES);
    Buffer.WriteInteger(aId_User);
    Buffer.WriteInteger(aIdDataBase);
    FClientSocket.Socket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

procedure TERPSocketClient.SendLoadMenu(aId_User, aIdDataBase: Integer);
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(CLIENT_COMMAND_GETMENU);
    Buffer.WriteInteger(aId_User);
    Buffer.WriteInteger(aIdDataBase);
    FClientSocket.Socket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

procedure TERPSocketClient.SetSocketEvent(aOnClientConnectionErrorEvent: TOnClientConnectionErrorEvent;
  aOnClientConnectionLoggerEvent: TOnClientConnectionLoggerEvent;
  aOnClientConnectionCommandEvent: TOnClientConnectionCommandEvent);
begin
  FOnClientConnectionErrorEvent := aOnClientConnectionErrorEvent;
  FOnClientConnectionLoggerEvent := aOnClientConnectionLoggerEvent;
  FOnClientConnectionCommandEvent := aOnClientConnectionCommandEvent;
end;

end.
