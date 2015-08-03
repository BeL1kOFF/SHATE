unit Logic.TRequestFactory;

interface

uses
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlResponse.TCustomXmlResponse,
  Logic.Request.IRequest;

type
  TRequestFactory = class
  private
    FXmlMessage: ICustomXmlMessage;
    FXmlResponse: ICustomXmlResponse;
  public
    constructor Create(aXmlMessage: ICustomXmlMessage; aXmlResponse: ICustomXmlResponse);
    function CreateInstance: IRequest;
  end;

implementation

uses
  System.SysUtils,
  Logic.Request.GetExpiredData,
  Logic.Request.LoginUser,
  Logic.Request.GetDocNumbers,
  Logic.Request.GetDocPlacement,
  Logic.Request.GetBinContent,
  Logic.Request.RegisterPlacement,
  Logic.Request.LogoutUser,
  Logic.XmlResponse.TXmlResponseGetExpiredData,
  Logic.XmlResponse.TXmlResponseLoginUser,
  Logic.XmlResponse.TXmlResponseGetDocNumbers,
  Logic.XmlResponse.TXmlResponseGetDocPlacement,
  Logic.XmlResponse.TXmlResponseGetBinContent,
  Logic.XmlResponse.TXmlResponseRegisterPlacement,
  Logic.XmlResponse.TXmlResponseLogoutUser,
  Logic.InitUnit;

{ TRequestFactory }

constructor TRequestFactory.Create(aXmlMessage: ICustomXmlMessage; aXmlResponse: ICustomXmlResponse);
begin
  FXmlMessage := aXmlMessage;
  FXmlResponse := aXmlResponse;
end;

function TRequestFactory.CreateInstance: IRequest;
begin
  TLog.LogMethod(Self.ClassType, 'CreateInstance');
  if Supports(FXmlResponse, IXmlResponseGetExpiredData) then
    Result := TRequestGetExpiredData.Create(FXmlMessage, FXmlResponse)
  else if Supports(FXmlResponse, IXmlResponseLoginUser) then
    Result := TRequestLoginUser.Create(FXmlMessage, FXmlResponse)
  else if Supports(FXmlResponse, IXmlResponseGetDocNumbers) then
    Result := TRequestGetDocNumbers.Create(FXmlMessage, FXmlResponse)
  else if Supports(FXmlResponse, IXmlResponseGetDocPlacement) then
    Result := TRequestGetDocPlacement.Create(FXmlMessage, FXmlResponse)
  else if Supports(FXmlResponse, IXmlResponseGetBinContent) then
    Result := TRequestGetBinContent.Create(FXmlMessage, FXmlResponse)
  else if Supports(FXmlResponse, IXmlResponseRegisterPlacement) then
    Result := TRequestRegisterPlacement.Create(FXmlMessage, FXmlResponse)
  else if Supports(FXmlResponse, IXmlResponseRegisterPlacement) then
    Result := TRequestRegisterPlacement.Create(FXmlMessage, FXmlResponse)
  else if Supports(FXmlResponse, IXmlResponseLogoutUser) then
    Result := TRequestLogoutUser.Create(FXmlMessage, FXmlResponse)
  else
    Result := nil;
end;

end.
