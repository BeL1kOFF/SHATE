unit SMSAdapter.Logic.TSMSAdapterReceiver;

interface

uses
  System.SysUtils,
  Package.CustomInterface.IReceiverAdapter,
  Package.CustomInterface.ICustomReceiverAdapter;

type
  TSMSAdapterReceiver = class(TInterfacedObject, IReceiverAdapter)
  private
    FCustomReceiverAdapter: ICustomReceiverAdapter;
    function Execute(aSenderFileName: PChar; const aBuffer: TBytes): Boolean;
    function SendSMS(const aPhone, aMessage: string; out aError: string): Boolean;
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomReceiverAdapter: ICustomReceiverAdapter);
    procedure LoadAdapter;
  end;

implementation

uses
  Winapi.Windows,
  System.Classes,
  Xml.XMLDoc,
  ShateM.Winapi.WinHttp,
  SMSAdapter.Logic.XMLSMSQuery;

{ TSMSAdapterReceiver }

function TSMSAdapterReceiver.Execute(aSenderFileName: PChar; const aBuffer: TBytes): Boolean;
type
  OEM = type AnsiString(CP_UTF8);
var
  tmpOEMString: OEM;
  tmpString: string;
  XMLDocumentType: IXMLDocumentType;
  Error: string;
begin
  Result := False;
  SetLength(tmpOEMString, Length(aBuffer));
  Move(aBuffer[0], tmpOEMString[1], Length(aBuffer));
  tmpString := string(tmpOEMString);
  try
    XMLDocumentType := (LoadXMLData(tmpString).GetDocBinding('Document', TXMLDocumentType, TargetNamespace) as IXMLDocumentType);
    FCustomReceiverAdapter.LogWrite(PChar('Обработка строки. Телефон = ' + XMLDocumentType.PhoneNumber));
    try
      if SendSMS(XMLDocumentType.PhoneNumber, XMLDocumentType.SmsText, Error) then
      begin
        Result := True;
        FCustomReceiverAdapter.LogWrite(PChar('СМС обработана: = ' + Error));
      end
      else
        FCustomReceiverAdapter.LogWrite(PChar('Ошибка: = ' + Error));
    except on E: Exception do
      FCustomReceiverAdapter.LogWrite(PChar('Ошибка: = ' + E.Message));
    end;
  except on E: Exception do
    FCustomReceiverAdapter.LogWrite(PChar('Ошибка: = ' + E.Message));
  end;
end;

procedure TSMSAdapterReceiver.FinalizeAdapter;
begin
  FCustomReceiverAdapter := nil;
end;

procedure TSMSAdapterReceiver.InitAdapter(aCustomReceiverAdapter: ICustomReceiverAdapter);
begin
  FCustomReceiverAdapter := aCustomReceiverAdapter;
end;

procedure TSMSAdapterReceiver.LoadAdapter;
begin

end;

function TSMSAdapterReceiver.SendSMS(const aPhone, aMessage: string; out aError: string): Boolean;
var
  hIntrnt: HINTERNET;
  hConnect: HINTERNET;
  hRequest: HINTERNET;
  IsEnd: Boolean;
  ReadyBufferCount: DWORD;
  Buffer: Pointer;
  ReallyReadCount: DWORD;
  FStream: TStringStream;
  MyOptions: DWORD;
begin
  Result := False;
  FStream := TStringStream.Create();
  try
    hIntrnt := WinHttpOpen('SMSAdapter', WINHTTP_ACCESS_TYPE_NO_PROXY, WINHTTP_NO_PROXY_NAME, WINHTTP_NO_PROXY_BYPASS, 0);
    if Assigned(hIntrnt) then
      try
        hConnect := WinHttpConnect(hIntrnt, 'sads.whoisd-blr.eyelinecom.com', INTERNET_DEFAULT_HTTPS_PORT, 0);
        if Assigned(hConnect) then
          try
            hRequest := WinHttpOpenRequest(hConnect, 'GET',
              PChar(Format('/sads/push?service=mobile2bel.Shate-M.push&subscriber=%s&message=%s&protocol=sms', [aPhone, aMessage])),
              nil, WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES, WINHTTP_FLAG_SECURE);
            if Assigned(hRequest) then
              try
                MyOptions := SECURITY_FLAG_IGNORE_CERT_CN_INVALID or
                             SECURITY_FLAG_IGNORE_UNKNOWN_CA or
                             SECURITY_FLAG_IGNORE_CERT_DATE_INVALID;
                if WinHttpSetOption(hRequest, WINHTTP_OPTION_SECURITY_FLAGS, @MyOptions, SizeOf(MyOptions)) then
                begin
                  if WinHttpSendRequest(hRequest, WINHTTP_NO_ADDITIONAL_HEADERS, 0, WINHTTP_NO_REQUEST_DATA, 0, 0, 0) then
                  begin
                    if WinHttpReceiveResponse(hRequest, nil) then
                    begin
                      IsEnd := False;
                      Repeat
                        if WinHttpQueryDataAvailable(hRequest, @ReadyBufferCount) then
                        begin
                          if ReadyBufferCount > 0 then
                          begin
                            Buffer := AllocMem(ReadyBufferCount);
                            try
                              if WinHttpReadData(hRequest, Buffer, ReadyBufferCount, @ReallyReadCount) then
                              begin
                                if ReallyReadCount = 0 then
                                begin
                                  IsEnd := True;
                                  aError := 'ReallyReadCount = 0';
                                end
                                else
                                  FStream.WriteBuffer(Buffer, ReallyReadCount);
                              end
                              else
                              begin
                                IsEnd := True;
                                aError := IntToStr(GetLastError());
                                Result := False;
                              end;
                            finally
                              FreeMem(Buffer);
                            end;
                          end
                          else
                          begin
                            IsEnd := True;
                            aError := 'ReadyBufferCount = 0';
                          end;
                        end
                        else
                        begin
                          IsEnd := True;
                          aError := IntToStr(GetLastError());
                          Result := False;
                        end;
                      Until IsEnd;
                    end
                    else
                    begin
                      aError := IntToStr(GetLastError());
                      Result := False;
                    end;
                  end
                  else
                  begin
                    aError := IntToStr(GetLastError());
                    Result := False;
                  end;
                end
                else
                begin
                  aError := IntToStr(GetLastError());
                  Result := False;
                end;
              finally
                if not WinHttpCloseHandle(hRequest) then
                begin
                  aError := IntToStr(GetLastError());
                  Result := False;
                end;
              end
            else
            begin
              aError := IntToStr(GetLastError());
              Result := False;
            end;
          finally
            if not WinHttpCloseHandle(hConnect) then
            begin
              aError := IntToStr(GetLastError());
              Result := False;
            end;
          end
        else
        begin
          aError := IntToStr(GetLastError());
          Result := False;
        end;
      finally
        if not WinHttpCloseHandle(hIntrnt) then
        begin
          aError := IntToStr(GetLastError());
          Result := False;
        end;
      end
    else
    begin
      aError := IntToStr(GetLastError());
      Result := False;
    end;
    FStream.Position := 0;
    if FStream.Size > 0 then
    begin
      aError := FStream.DataString;
      Result := True;
    end;
  finally
    FStream.Free();
  end;
end;

end.
