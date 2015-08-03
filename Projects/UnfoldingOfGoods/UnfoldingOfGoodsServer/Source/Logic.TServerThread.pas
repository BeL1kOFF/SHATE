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
    // �������� ����� ����������� ���������
    XmlMessageClass := XmlMessageRegisterList.GetMessageClass(aCommand);
    if Assigned(XmlMessageClass) then
      // ���� ����� ������, �� �������� ����� ��������� ������
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
    TLog.LogMessage(nil, Format('������ %s �����������', [ClientAddress]));
    SocketStream := TWinSocketStream.Create(ClientSocket, 10000);
    try
      GlobalBuffer := TBytesStream.Create();
      try
        while (not Terminated) and (ClientSocket.Connected) do
          if (not Terminated) and (SocketStream.WaitForData(1)) then
            try
              //�������� ������ ����������� ���������
              ReceiveLength := ClientSocket.ReceiveLength;
              if ReceiveLength > 0 then
              begin
                TLog.LogMessage(nil, Format('�������� %d ����', [ReceiveLength]));
                // ������� ����� ��� ���������
                SetLength(Buffer, ReceiveLength);
                // ������ ��������� � �����
                ReceiveLength := SocketStream.Read(Buffer[0], ReceiveLength);
                // ���������� � ����� ����������� ������ ����������� �����
                GlobalBuffer.Seek(0, soEnd);
                GlobalBuffer.WriteBuffer(Buffer[0], ReceiveLength);
                // ���� � ���������� ������ >= 4 ����
                while GlobalBuffer.Size >= 4 do
                begin
                  // ������ ������ �������� ���������
                  LengthCommand := PInteger(@GlobalBuffer.Bytes[0])^;
                  // ���� � ������ ����� ��� ���������, ��
                  if GlobalBuffer.Size >= LengthCommand + 4 then
                  begin
                    // �������� ������ ��� ������ ���������
                    SetLength(XmlBytes, LengthCommand);
                    // �������� � ����� ���������
                    Move(GlobalBuffer.Bytes[4], XmlBytes[0], LengthCommand);
                    // ������� �� ����������� ������ ���������� ���������
                    BufferDeleteCommand(GlobalBuffer, LengthCommand + 4);
                    // ����������� ��������� �� ������ � XML ������
                    Encoding1251 := TEncoding.GetEncoding(1251);
                    try
                      XmlString := Encoding1251.GetString(XmlBytes, 0, LengthCommand);
                    finally
                      Encoding1251.Free();
                    end;
                    {$IFDEF DEBUG}
                    TLog.LogMessage(Self.ClassType, '��������: ' + XmlString);
                    {$ENDIF}
                    // ������������ XML ������
                    XmlString := ProcessCommand(XmlString);
                    // ���� ������������ ������ ������, �� ��������� �������, �.�. ���������������� ������ �����
                    if XmlString.IsEmpty() then
                      Terminate()
                    else
                    begin
                      {$IFDEF DEBUG}
                      TLog.LogMessage(Self.ClassType, '������������: ' + XmlString);
                      {$ENDIF}
                      // ����������� XML ������ � �����
                      XmlBytes := BytesOf(XmlString);
                      // �������������� ����� � �������� �� ������� {������}{���������}
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
    TLog.LogMessage(nil, Format('������ %s ��������', [ClientAddress]));
  finally
    CoUninitialize();
  end;
end;

end.
