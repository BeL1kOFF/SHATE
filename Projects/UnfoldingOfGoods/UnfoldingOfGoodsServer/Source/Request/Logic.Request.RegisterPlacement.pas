unit Logic.Request.RegisterPlacement;

interface

uses
  Logic.Request.TCustomRequest,
  Logic.Request.IRequest,
  Logic.XmlResponse.TXmlResponseRegisterPlacement,
  Logic.XmlMessage.TXmlMessageRegisterPlacement;

type
  TRequestRegisterPlacement = class(TCustomRequest, IRequest)
  private
    procedure GetProcessedXml;
    function GetXmlMessage: IXmlMessageRegisterPlacement;
    function GetXmlResponse: IXmlResponseRegisterPlacement;
  protected
    property XmlMessage: IXmlMessageRegisterPlacement read GetXmlMessage;
    property XmlResponse: IXmlResponseRegisterPlacement read GetXmlResponse;
  end;

implementation

uses
  Logic.InitUnit,
  System.SysUtils,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Logic.WmsRoutingWebServices,
  Logic.TErrorFactory;

{ TRequestRegisterPlacement }

procedure TRequestRegisterPlacement.GetProcessedXml;
var
  XmlDoc: IXMLDocument;
  Xa: IXMLNode;
  XmlStr: string;

  procedure CreateAttribute(aXmlNode: IXMLNode; const aName, aValue: string);
  begin
    Xa := aXmlNode.OwnerDocument.CreateNode(aName, ntAttribute, '');
    Xa.NodeValue := aValue;
    aXmlNode.AttributeNodes.Add(Xa);
  end;

begin
  TLog.LogMethod(Self.ClassType, 'GetProcessedXml');
  XmlDoc := TXMLDocument.Create(nil);
  try
    XmlDoc.Active := True;
    XmlDoc.ChildNodes.Add(XmlMessage.Document);
    if CheckSession() then
    begin
      CreateAttribute(XmlDoc.DocumentElement, 'LocationCode', Session.Location);
      CreateAttribute(XmlDoc.DocumentElement, 'User', Session.UserLogin);
      XmlStr := XmlDoc.DocumentElement.XML;
      TLog.LogMessage(nil, 'RegisterPlacement: ' + XmlStr);
      XmlResponse.Result := GetWmsRoutingWebServices_Port().RegisterPlacement(XmlStr).ToInteger();
    end
    else
      if IsEqualGUID(XmlMessage.Session, TGUID.Empty()) then
      begin
        TErrorFactory.SetSuccess(XmlResponse.Error);
        CreateAttribute(XmlDoc.DocumentElement, 'LocationCode', XmlMessage.UserLocation);
        CreateAttribute(XmlDoc.DocumentElement, 'User', XmlMessage.UserName);
        XmlStr := XmlDoc.DocumentElement.XML;
        TLog.LogMessage(nil, 'RegisterPlacement: ' + XmlStr);
        XmlResponse.Result := GetWmsRoutingWebServices_Port().RegisterPlacement(XmlStr).ToInteger();
      end;
  finally
    XmlDoc := nil;
  end;
end;

function TRequestRegisterPlacement.GetXmlMessage: IXmlMessageRegisterPlacement;
begin
  Result := inherited XmlMessage as IXmlMessageRegisterPlacement;
end;

function TRequestRegisterPlacement.GetXmlResponse: IXmlResponseRegisterPlacement;
begin
  Result := inherited XmlResponse as IXmlResponseRegisterPlacement;
end;

end.
