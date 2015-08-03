unit Logic.Request;

interface

uses
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlResponse.TCustomXmlResponse;

type
  TRequest = class
  private
    FCommand: string;
  public
    constructor Create(const aCommand: string);
    function Request(aXmlMessageClass: TCustomXmlMessageClass; aXmlResponseClass: TCustomXmlResponseClass): string;
  end;

implementation

uses
  System.SysUtils,
  Soap.SOAPHTTPTrans,
  Soap.InvokeRegistry,
  Logic.InitUnit,
  Logic.TRequestFactory,
  Logic.Request.IRequest,
  Logic.TErrorFactory,
  Logic.Session.TSession,
  Logic.Session.TSessionFactory;

{ TRequest }

constructor TRequest.Create(const aCommand: string);
begin
  FCommand := aCommand;
end;

function TRequest.Request(aXmlMessageClass: TCustomXmlMessageClass; aXmlResponseClass: TCustomXmlResponseClass): string;
var
  XmlMessage: ICustomXmlMessage;
  XmlResponse: ICustomXmlResponse;
  RequestFactory: TRequestFactory;
  Request: IRequest;
  Session: ISession;
  MessageText: string;
begin
  TLog.LogMethod(Self.ClassType, 'Request');
  XmlMessage := aXmlMessageClass.Create(FCommand);
  try
    XmlResponse := aXmlResponseClass.Create();
    try
      TErrorFactory.SetSuccess(XmlResponse.Error);
      if XmlMessage.DefaultType.Equals('Default') then
      begin
        XmlResponse.SetMessage(XmlMessage.Type_);
        TErrorFactory.SetUnknownMessage(XmlResponse.Error);
      end
      else
        if XmlResponse.Type_.Equals('Default') then
        begin
          XmlResponse.SetMessage(XmlMessage.Type_);
          TErrorFactory.SetServerError(XmlResponse.Error);
        end
        else
        begin
          RequestFactory := TRequestFactory.Create(XmlMessage, XmlResponse);
          try
            Request := RequestFactory.CreateInstance(); // �������� �����-��������� ��������� ���������������� ������������� (�����������???) ���������
            if Assigned(Request) then
            begin
              Session := TSessionFactory.GetSession(XmlMessage.Session);
              if Assigned(Session) then
                MessageText := Format(' �� %s � ��� %s', [Session.UserName, Session.RemoteName])
              else
                MessageText := '';
              TLog.LogMessage(Self.ClassType, Format('�������� %s %s', [XmlMessage.Type_, MessageText]));
              try
                Request.GetProcessedXml();
              except
                on E1: ESOAPHTTPException do
                  TErrorFactory.SetWebServiceError(XmlResponse.Error, E1.StatusCode);
                on E2: ERemotableException do
                  TErrorFactory.SetWebServiceInnerError(XmlResponse.Error, E2.ToString());
              end;
              TLog.LogMessage(Self.ClassType, '��������� ' + XmlResponse.Type_);
            end
            else
              TErrorFactory.SetServerError2(XmlResponse.Error);
          finally
            RequestFactory.Free();
          end;
        end;
      if XmlResponse.Error.Code > 0 then
        TLog.LogMessage(Self.ClassType, Format('��� ������: %d. ������: %s', [XmlResponse.Error.Code, XmlResponse.Error.NodeValue]));
      Result := XmlResponse.Xml;
    finally
      XmlResponse := nil;
    end;
  finally
    XmlMessage := nil;
  end;
end;

end.
