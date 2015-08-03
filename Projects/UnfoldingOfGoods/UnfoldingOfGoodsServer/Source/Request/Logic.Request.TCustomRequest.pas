unit Logic.Request.TCustomRequest;

interface

uses
  Logic.Session.TSession,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlResponse.TCustomXmlResponse;

type
  TCustomRequest = class(TInterfacedObject)
  private
    FXmlMessage: ICustomXmlMessage;
    FXmlResponse: ICustomXmlResponse;
    FSession: ISession;
  protected
    function CheckSession: Boolean;
    property XmlMessage: ICustomXmlMessage read FXmlMessage;
    property XmlResponse: ICustomXmlResponse read FXmlResponse;
    property Session: ISession read FSession;
  public
    constructor Create(aXmlMessage: ICustomXmlMessage; aXmlResponse: ICustomXmlResponse);
  end;

implementation

uses
  Logic.InitUnit,
  Logic.Session.TSessionFactory,
  Logic.TErrorFactory;

{ TCustomRequest }

function TCustomRequest.CheckSession: Boolean;
begin
  TLog.LogMethod(Self.ClassType, 'CheckSession');
  FSession := TSessionFactory.GetSession(XmlMessage.Session);
  Result := Assigned(FSession);
  if not Result then
    TErrorFactory.SetExpiredSession(XmlResponse.Error);
end;

constructor TCustomRequest.Create(aXmlMessage: ICustomXmlMessage; aXmlResponse: ICustomXmlResponse);
begin
  FXmlMessage := aXmlMessage;
  FXmlResponse := aXmlResponse;
end;

end.
