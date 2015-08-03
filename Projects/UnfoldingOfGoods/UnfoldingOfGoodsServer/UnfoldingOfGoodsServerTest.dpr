program UnfoldingOfGoodsServerTest;

uses
  Vcl.Forms,
  UI.MainTest in 'Source\UI.MainTest.pas' {Form4},
  Logic.WmsRoutingWebServices in 'Source\Logic.WmsRoutingWebServices.pas',
  Logic.TOptionsThread in 'Source\Logic.TOptionsThread.pas',
  Logic.InitUnit in 'Source\Logic.InitUnit.pas',
  Logic.TXmlMessageRegisterList in 'Source\Logic.TXmlMessageRegisterList.pas',
  Logic.TXmlResponseRegisterList in 'Source\Logic.TXmlResponseRegisterList.pas',
  Logic.Request.LoginUser in 'Source\Request\Logic.Request.LoginUser.pas',
  Logic.TRequestFactory in 'Source\Request\Logic.TRequestFactory.pas',
  Logic.Request.RegisterPlacement in 'Source\Request\Logic.Request.RegisterPlacement.pas',
  Logic.Request.LogoutUser in 'Source\Request\Logic.Request.LogoutUser.pas',
  Logic.Request.GetExpiredData in 'Source\Request\Logic.Request.GetExpiredData.pas',
  Logic.Request.GetDocPlacement in 'Source\Request\Logic.Request.GetDocPlacement.pas',
  Logic.Request.GetDocNumbers in 'Source\Request\Logic.Request.GetDocNumbers.pas',
  Logic.Request.GetBinContent in 'Source\Request\Logic.Request.GetBinContent.pas',
  Logic.Request.TCustomRequest in 'Source\Request\Logic.Request.TCustomRequest.pas',
  Logic.Request in 'Source\Request\Logic.Request.pas',
  Logic.TServerThread in 'Source\Logic.TServerThread.pas',
  Logic.TMain in 'Source\Logic.TMain.pas',
  Logic.Options in 'Source\Logic.Options.pas',
  Logic.TErrorFactory in 'Source\Logic.TErrorFactory.pas',
  Logic.Session.TSessionFactory in 'Source\Logic.Session.TSessionFactory.pas',
  Logic.TFileLogger in 'Source\Logic.TFileLogger.pas',
  Logic.XmlMessage.TCustomXmlMessage in 'Source\Xml\XmlMessage\Logic.XmlMessage.TCustomXmlMessage.pas',
  Logic.XmlResponse.TXmlResponseRegisterPlacement in 'Source\Xml\XmlResponse\RegisterPlacement\Logic.XmlResponse.TXmlResponseRegisterPlacement.pas',
  Logic.XmlMessage.TXmlMessageRegisterPlacement in 'Source\Xml\XmlMessage\RegisterPlacement\Logic.XmlMessage.TXmlMessageRegisterPlacement.pas',
  Logic.XmlResponse.TXmlResponseGetExpiredData in 'Source\Xml\XmlResponse\GetExpiredData\Logic.XmlResponse.TXmlResponseGetExpiredData.pas',
  Logic.XmlResponse.TXmlResponseLogoutUser in 'Source\Xml\XmlResponse\LogoutUser\Logic.XmlResponse.TXmlResponseLogoutUser.pas',
  Logic.XmlMessage.TXmlMessageLogoutUser in 'Source\Xml\XmlMessage\LogoutUser\Logic.XmlMessage.TXmlMessageLogoutUser.pas',
  Logic.XmlMessage.TXmlMessageLogoutUserParams in 'Source\Xml\XmlMessage\LogoutUser\Logic.XmlMessage.TXmlMessageLogoutUserParams.pas',
  Logic.XmlMessage.TXmlMessageGetBinContent in 'Source\Xml\XmlMessage\GetBinContent\Logic.XmlMessage.TXmlMessageGetBinContent.pas',
  Logic.XmlResponse.TXmlResponseGetBinContent in 'Source\Xml\XmlResponse\GetBinContent\Logic.XmlResponse.TXmlResponseGetBinContent.pas',
  Logic.XmlResponse.TXmlResponseGetBinContentResult in 'Source\Xml\XmlResponse\GetBinContent\Logic.XmlResponse.TXmlResponseGetBinContentResult.pas',
  Logic.XmlMessage.TXmlMessageGetBinContentParams in 'Source\Xml\XmlMessage\GetBinContent\Logic.XmlMessage.TXmlMessageGetBinContentParams.pas',
  Logic.XmlResponse.TXmlResponseLoginUserResult in 'Source\Xml\XmlResponse\LoginUser\Logic.XmlResponse.TXmlResponseLoginUserResult.pas',
  Logic.Session.TSession in 'Source\Logic.Session.TSession.pas',
  Logic.XmlResponse.TXmlResponseGetDocPlacement in 'Source\Xml\XmlResponse\GetDocPlacement\Logic.XmlResponse.TXmlResponseGetDocPlacement.pas',
  Logic.XmlResponse.TXmlResponseGetDocPlacementResult in 'Source\Xml\XmlResponse\GetDocPlacement\Logic.XmlResponse.TXmlResponseGetDocPlacementResult.pas',
  Logic.XmlResponse.TCustomXmlResponse in 'Source\Xml\XmlResponse\Logic.XmlResponse.TCustomXmlResponse.pas',
  Logic.XmlResponse.TXmlResponseGetDocNumbers in 'Source\Xml\XmlResponse\GetDocNumbers\Logic.XmlResponse.TXmlResponseGetDocNumbers.pas',
  Logic.XmlResponse.TXmlResponseLoginUser in 'Source\Xml\XmlResponse\LoginUser\Logic.XmlResponse.TXmlResponseLoginUser.pas',
  Logic.XmlMessage.TXmlMessageGetDocPlacement in 'Source\Xml\XmlMessage\GetDocPlacement\Logic.XmlMessage.TXmlMessageGetDocPlacement.pas',
  Logic.XmlMessage.TXmlMessageGetDocPlacementParams in 'Source\Xml\XmlMessage\GetDocPlacement\Logic.XmlMessage.TXmlMessageGetDocPlacementParams.pas',
  Logic.Request.IRequest in 'Source\Request\Logic.Request.IRequest.pas',
  Logic.XmlMessage.TXmlMessageDefault in 'Source\Xml\XmlMessage\Logic.XmlMessage.TXmlMessageDefault.pas',
  Logic.XmlResponse.TXmlResponseDefault in 'Source\Xml\XmlResponse\Logic.XmlResponse.TXmlResponseDefault.pas',
  Logic.XmlResponse.TXmlResponseGetDocNumbersResult in 'Source\Xml\XmlResponse\GetDocNumbers\Logic.XmlResponse.TXmlResponseGetDocNumbersResult.pas',
  Logic.XmlMessage.TXmlMessageGetDocNumbers in 'Source\Xml\XmlMessage\GetDocNumbers\Logic.XmlMessage.TXmlMessageGetDocNumbers.pas',
  Logic.XmlMessage.TXmlMessageGetExpiredDataParams in 'Source\Xml\XmlMessage\GetExpiredData\Logic.XmlMessage.TXmlMessageGetExpiredDataParams.pas',
  Logic.Xml.TCustomXmlNode in 'Source\Xml\Logic.Xml.TCustomXmlNode.pas',
  Logic.XmlMessage.TXmlMessageGetExpiredData in 'Source\Xml\XmlMessage\GetExpiredData\Logic.XmlMessage.TXmlMessageGetExpiredData.pas',
  Logic.XmlMessage.TXmlMessageLoginUser in 'Source\Xml\XmlMessage\LoginUser\Logic.XmlMessage.TXmlMessageLoginUser.pas',
  Logic.XmlMessage.TXmlMessageLoginUserParams in 'Source\Xml\XmlMessage\LoginUser\Logic.XmlMessage.TXmlMessageLoginUserParams.pas',
  Logic.XmlResponse.TCustomXmlResponseError in 'Source\Xml\XmlResponse\Logic.XmlResponse.TCustomXmlResponseError.pas',
  Logic.Xml.TCustomXml in 'Source\Xml\Logic.Xml.TCustomXml.pas',
  Logic.XmlMessage.TCustomXmlMessageParams in 'Source\Xml\XmlMessage\Logic.XmlMessage.TCustomXmlMessageParams.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
