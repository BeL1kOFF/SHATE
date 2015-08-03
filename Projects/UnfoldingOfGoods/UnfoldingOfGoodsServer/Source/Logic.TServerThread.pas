unit Logic.TServerThread;

interface

uses
  System.Win.ScktComp;

type
  TServerThread = class(TServerClientThread)
  protected
    procedure ClientExecute; override;
  end;

implementation

uses
  Winapi.ActiveX,
  System.SysUtils,
  System.Classes,
  Logic.TXmlMessageRegisterList,
  Logic.TXmlResponseRegisterList,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlResponse.TCustomXmlResponse,
  Logic.XmlResponse.TXmlResponseDefault,
  Logic.XmlMessage.TXmlMessageDefault,
  Logic.Request,
  Logic.InitUnit;

{ TServerThread }

procedure TServerThread.ClientExecute;
var
  SocketStream: TWinSocketStream;
  ReceiveLength: Integer;
  Buffer: TBytes;
  GlobalBuffer: TBytesStream;
  LengthCommand: Integer;
  XmlBytes: TBytes;
  XmlString: string;
  ClientAddress: string;
  Encoding1251: TEncoding;

  procedure BufferDeleteCommand(aBuffer: TBytesStream; aLengthCommand: Integer);
  var
    TempBuffer: TBytesStream;
  begin
    TempBuffer := TBytesStream.Create();
    try
      TempBuffer.LoadFromStream(GlobalBuffer);
      GlobalBuffer.Clear();
      GlobalBuffer.WriteBuffer(TempBuffer.Bytes[aLengthCommand], TempBuffer.Size - aLengthCommand);
    finally
      TempBuffer.Free();
    end;
  end;

  function ProcessCommand(const aCommand: string): string;
  var
    XmlMessageClass: TCustomXmlMessageClass;
    XmlResponseClass: TCustomXmlResponseClass;
    Request: TRequest;
  begin
    TLog.LogMethod(Self.ClassType, 'ProcessCommand');
    XmlResponseClass := nil;
    // Получаем класс полученного сообщения
    XmlMessageClass := XmlMessageRegisterList.GetMessageClass(aCommand);
    if Assigned(XmlMessageClass) then
      // Если класс найден, то получаем класс сообщения ответа
      XmlResponseClass := XmlResponseRegisterList.GetResponseClass(XmlMessageClass.GetMessageType())
    else
      XmlMessageClass := TXmlMessageDefault;
    if not Assigned(XmlResponseClass) then
      XmlResponseClass := TXmlResponseDefault;
    Request := TRequest.Create(aCommand);
    try
      Result := Request.Request(XmlMessageClass, XmlResponseClass);
    finally
      Request.Free();
    end;
  end;

begin
  CoInitialize(nil);
  try
    ClientAddress := ClientSocket.RemoteAddress;
    TLog.LogMessage(nil, Format('Клиент %s подключился', [ClientAddress]));
    SocketStream := TWinSocketStream.Create(ClientSocket, 10000);
    try
      GlobalBuffer := TBytesStream.Create();
      try
        while (not Terminated) and (ClientSocket.Connected) do
          if (not Terminated) and (SocketStream.WaitForData(1)) then
            try
              //Получаем длинну полученного сообщения
              ReceiveLength := ClientSocket.ReceiveLength;
              if ReceiveLength > 0 then
              begin
                TLog.LogMessage(nil, Format('Получено %d байт', [ReceiveLength]));
                // Выдялем буфер под сообщение
                SetLength(Buffer, ReceiveLength);
                // Читаем сообщение в буфер
                ReceiveLength := SocketStream.Read(Buffer[0], ReceiveLength);
                // Дописываем в конец глобального буфера прочитанный буфер
                GlobalBuffer.Seek(0, soEnd);
                GlobalBuffer.WriteBuffer(Buffer[0], ReceiveLength);
                // Если в глобальном буфере >= 4 байт
                while GlobalBuffer.Size >= 4 do
                begin
                  // Читаем размер будущего сообщения
                  LengthCommand := PInteger(@GlobalBuffer.Bytes[0])^;
                  // Если в буфере лежит все сообщение, то
                  if GlobalBuffer.Size >= LengthCommand + 4 then
                  begin
                    // Выделяем память для буфера сообщения
                    SetLength(XmlBytes, LengthCommand);
                    // Копируем в буфер сообщение
                    Move(GlobalBuffer.Bytes[4], XmlBytes[0], LengthCommand);
                    // Удаляем из глобального буфера вычитанное сообщение
                    BufferDeleteCommand(GlobalBuffer, LengthCommand + 4);
                    // Транслируем сообщение из буфера в XML строку
                    Encoding1251 := TEncoding.GetEncoding(1251);
                    try
                      XmlString := Encoding1251.GetString(XmlBytes, 0, LengthCommand);
                    finally
                      Encoding1251.Free();
                    end;
                    {$IFDEF DEBUG}
                    TLog.LogMessage(Self.ClassType, 'Получено: ' + XmlString);
                    {$ENDIF}
                    // Обрабатывает XML строку
                    XmlString := ProcessCommand(XmlString);
                    // Если обработанная строка пустая, то отключить клиента, т.к. предположительно пришел мусор
                    if XmlString.IsEmpty() then
                      Terminate()
                    else
                    begin
                      {$IFDEF DEBUG}
                      TLog.LogMessage(Self.ClassType, 'Отправляется: ' + XmlString);
                      {$ENDIF}
                      // Транслируем XML строку в буфер
                      XmlBytes := BytesOf(XmlString);
                      // Подготавливаем буфер к отправке по формуле {Размер}{Сообщение}
                      LengthCommand := Length(XmlBytes);
                      SetLength(Buffer, 4 + LengthCommand);
                      Move(LengthCommand, Buffer[0], 4);
                      Move(XmlBytes[0], Buffer[4], Length(XmlBytes));
                      ClientSocket.SendBuf(Buffer[0], Length(Buffer));
                    end;
                  end
                  else
                    Break;
                end;
              end
              else
                Terminate();
            except on E: Exception do
            begin
              TLog.LogException(E);
              Terminate();
            end;
            end;
        ClientSocket.Close;
      finally
        GlobalBuffer.Free();
      end;
    finally
      SocketStream.Free();
    end;
    TLog.LogMessage(nil, Format('Клиент %s отключен', [ClientAddress]));
  finally
    CoUninitialize();
  end;
end;

end.
