unit Logic.Request.LogoutUser;

interface

uses
  Logic.Request.TCustomRequest,
  Logic.Request.IRequest,
  Logic.XmlMessage.TXmlMessageLogoutUser,
  Logic.XmlResponse.TXmlResponseLogoutUser;

type
  TRequestLogoutUser = class(TCustomRequest, IRequest)
  private
    procedure GetProcessedXml;
  protected
    function GetXmlMessage: IXmlMessageLogoutUser;
    function GetXmlResponse: IXmlResponseLogoutUser;
  protected
    property XmlMessage: IXmlMessageLogoutUser read GetXmlMessage;
    property XmlResponse: IXmlResponseLogoutUser read GetXmlResponse;
  end;

implementation

uses
  System.SysUtils,
  Logic.Session.TSessionFactory,
  Logic.TErrorFactory,
  Logic.InitUnit;

{ TRequestLogoutUser }

procedure TRequestLogoutUser.GetProcessedXml;
begin
  TLog.LogMethod(Self.ClassType, 'GetProcessedXml');
  if CheckSession() then
  begin
    if Session.UserLogin.Equals(XmlMessage.Params.UserName) then
    begin
      TSessionFactory.RemoveSession(Session);
      XmlResponse.Result := 1;
    end
    else
      TErrorFactory.SetIncorrectLoginForSession(XmlResponse.Error);
  end
  else
  begin
    TErrorFactory.SetSuccess(XmlResponse.Error);
    XmlResponse.Result := 1;
  end;
end;

function TRequestLogoutUser.GetXmlMessage: IXmlMessageLogoutUser;
begin
  Result := inherited XmlMessage as IXmlMessageLogoutUser;
end;

function TRequestLogoutUser.GetXmlResponse: IXmlResponseLogoutUser;
begin
  Result := inherited XmlResponse as IXmlResponseLogoutUser;
end;

end.
