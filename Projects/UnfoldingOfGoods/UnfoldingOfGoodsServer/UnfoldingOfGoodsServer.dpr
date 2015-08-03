program UnfoldingOfGoodsServer;

uses
  Logic.InitUnit in 'Source\Logic.InitUnit.pas',
  Vcl.SvcMgr,
  Logic.TXmlMessageRegisterList in 'Source\Logic.TXmlMessageRegisterList.pas',
  Logic.TXmlResponseRegisterList in 'Source\Logic.TXmlResponseRegisterList.pas',
  ServiceMain in 'Source\ServiceMain.pas' {TSDService: TService},
  Logic.TMain in 'Source\Logic.TMain.pas',
  Logic.TServerThread in 'Source\Logic.TServerThread.pas',
  Logic.XmlMessage.TCustomXmlMessage in 'Source\Xml\XmlMessage\Logic.XmlMessage.TCustomXmlMessage.pas',
  Logic.XmlMessage.TXmlMessageGetExpiredData in 'Source\Xml\XmlMessage\GetExpiredData\Logic.XmlMessage.TXmlMessageGetExpiredData.pas',
  Logic.XmlResponse.TCustomXmlResponse in 'Source\Xml\XmlResponse\Logic.XmlResponse.TCustomXmlResponse.pas',
  Logic.XmlResponse.TXmlResponseGetExpiredData in 'Source\Xml\XmlResponse\GetExpiredData\Logic.XmlResponse.TXmlResponseGetExpiredData.pas',
  Logic.XmlResponse.TXmlResponseDefault in 'Source\Xml\XmlResponse\Logic.XmlResponse.TXmlResponseDefault.pas',
  Logic.Request in 'Source\Request\Logic.Request.pas',
  Logic.XmlMessage.TXmlMessageLoginUser in 'Source\Xml\XmlMessage\LoginUser\Logic.XmlMessage.TXmlMessageLoginUser.pas',
  Logic.XmlMessage.TCustomXmlMessageParams in 'Source\Xml\XmlMessage\Logic.XmlMessage.TCustomXmlMessageParams.pas',
  Logic.Xml.TCustomXml in 'Source\Xml\Logic.Xml.TCustomXml.pas',
  Logic.Xml.TCustomXmlNode in 'Source\Xml\Logic.Xml.TCustomXmlNode.pas',
  Logic.XmlMessage.TXmlMessageLoginUserParams in 'Source\Xml\XmlMessage\LoginUser\Logic.XmlMessage.TXmlMessageLoginUserParams.pas',
  Logic.XmlResponse.TCustomXmlResponseError in 'Source\Xml\XmlResponse\Logic.XmlResponse.TCustomXmlResponseError.pas',
  Logic.XmlResponse.TXmlResponseLoginUser in 'Source\Xml\XmlResponse\LoginUser\Logic.XmlResponse.TXmlResponseLoginUser.pas',
  Logic.XmlResponse.TXmlResponseLoginUserResult in 'Source\Xml\XmlResponse\LoginUser\Logic.XmlResponse.TXmlResponseLoginUserResult.pas',
  Logic.Session.TSession in 'Source\Logic.Session.TSession.pas',
  Logic.XmlMessage.TXmlMessageGetExpiredDataParams in 'Source\Xml\XmlMessage\GetExpiredData\Logic.XmlMessage.TXmlMessageGetExpiredDataParams.pas',
  Logic.XmlMessage.TXmlMessageGetDocNumbers in 'Source\Xml\XmlMessage\GetDocNumbers\Logic.XmlMessage.TXmlMessageGetDocNumbers.pas',
  Logic.XmlResponse.TXmlResponseGetDocNumbers in 'Source\Xml\XmlResponse\GetDocNumbers\Logic.XmlResponse.TXmlResponseGetDocNumbers.pas',
  Logic.XmlResponse.TXmlResponseGetDocNumbersResult in 'Source\Xml\XmlResponse\GetDocNumbers\Logic.XmlResponse.TXmlResponseGetDocNumbersResult.pas',
  Logic.TRequestFactory in 'Source\Request\Logic.TRequestFactory.pas',
  Logic.Request.GetExpiredData in 'Source\Request\Logic.Request.GetExpiredData.pas',
  Logic.Request.IRequest in 'Source\Request\Logic.Request.IRequest.pas',
  Logic.Request.LoginUser in 'Source\Request\Logic.Request.LoginUser.pas',
  Logic.Request.GetDocNumbers in 'Source\Request\Logic.Request.GetDocNumbers.pas',
  Logic.Request.TCustomRequest in 'Source\Request\Logic.Request.TCustomRequest.pas',
  Logic.Session.TSessionFactory in 'Source\Logic.Session.TSessionFactory.pas',
  Logic.WmsRoutingWebServices in 'Source\Logic.WmsRoutingWebServices.pas',
  Logic.XmlMessage.TXmlMessageDefault in 'Source\Xml\XmlMessage\Logic.XmlMessage.TXmlMessageDefault.pas',
  Logic.XmlMessage.TXmlMessageGetDocPlacement in 'Source\Xml\XmlMessage\GetDocPlacement\Logic.XmlMessage.TXmlMessageGetDocPlacement.pas',
  Logic.XmlMessage.TXmlMessageGetDocPlacementParams in 'Source\Xml\XmlMessage\GetDocPlacement\Logic.XmlMessage.TXmlMessageGetDocPlacementParams.pas',
  Logic.XmlResponse.TXmlResponseGetDocPlacement in 'Source\Xml\XmlResponse\GetDocPlacement\Logic.XmlResponse.TXmlResponseGetDocPlacement.pas',
  Logic.XmlResponse.TXmlResponseGetDocPlacementResult in 'Source\Xml\XmlResponse\GetDocPlacement\Logic.XmlResponse.TXmlResponseGetDocPlacementResult.pas',
  Logic.Request.GetDocPlacement in 'Source\Request\Logic.Request.GetDocPlacement.pas',
  Logic.XmlMessage.TXmlMessageGetBinContent in 'Source\Xml\XmlMessage\GetBinContent\Logic.XmlMessage.TXmlMessageGetBinContent.pas',
  Logic.XmlMessage.TXmlMessageGetBinContentParams in 'Source\Xml\XmlMessage\GetBinContent\Logic.XmlMessage.TXmlMessageGetBinContentParams.pas',
  Logic.XmlResponse.TXmlResponseGetBinContent in 'Source\Xml\XmlResponse\GetBinContent\Logic.XmlResponse.TXmlResponseGetBinContent.pas',
  Logic.XmlResponse.TXmlResponseGetBinContentResult in 'Source\Xml\XmlResponse\GetBinContent\Logic.XmlResponse.TXmlResponseGetBinContentResult.pas',
  Logic.Request.GetBinContent in 'Source\Request\Logic.Request.GetBinContent.pas',
  Logic.XmlMessage.TXmlMessageLogoutUser in 'Source\Xml\XmlMessage\LogoutUser\Logic.XmlMessage.TXmlMessageLogoutUser.pas',
  Logic.XmlMessage.TXmlMessageLogoutUserParams in 'Source\Xml\XmlMessage\LogoutUser\Logic.XmlMessage.TXmlMessageLogoutUserParams.pas',
  Logic.XmlResponse.TXmlResponseLogoutUser in 'Source\Xml\XmlResponse\LogoutUser\Logic.XmlResponse.TXmlResponseLogoutUser.pas',
  Logic.Request.LogoutUser in 'Source\Request\Logic.Request.LogoutUser.pas',
  Logic.XmlMessage.TXmlMessageRegisterPlacement in 'Source\Xml\XmlMessage\RegisterPlacement\Logic.XmlMessage.TXmlMessageRegisterPlacement.pas',
  Logic.XmlResponse.TXmlResponseRegisterPlacement in 'Source\Xml\XmlResponse\RegisterPlacement\Logic.XmlResponse.TXmlResponseRegisterPlacement.pas',
  Logic.Request.RegisterPlacement in 'Source\Request\Logic.Request.RegisterPlacement.pas',
  Logic.TFileLogger in 'Source\Logic.TFileLogger.pas',
  Logic.Options in 'Source\Logic.Options.pas',
  Logic.TOptionsThread in 'Source\Logic.TOptionsThread.pas',
  Logic.TErrorFactory in 'Source\Logic.TErrorFactory.pas';

{$R *.RES}

begin
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TTSDService, TSDService);
  Application.Run;
end.
