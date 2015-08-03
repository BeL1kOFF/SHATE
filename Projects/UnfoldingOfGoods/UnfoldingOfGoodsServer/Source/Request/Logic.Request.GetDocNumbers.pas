unit Logic.Request.GetDocNumbers;

interface

uses
  Logic.Request.TCustomRequest,
  Logic.Request.IRequest,
  Logic.XmlMessage.TXmlMessageGetDocNumbers,
  Logic.XmlResponse.TXmlResponseGetDocNumbers;

type
  TRequestGetDocNumbers = class(TCustomRequest, IRequest)
  private
    procedure GetProcessedXml;
  protected
    function GetXmlMessage: IXmlMessageGetDocNumbers;
    function GetXmlResponse: IXmlResponseGetDocNumbers;
  protected
    property XmlMessage: IXmlMessageGetDocNumbers read GetXmlMessage;
    property XmlResponse: IXmlResponseGetDocNumbers read GetXmlResponse;
  end;

implementation

uses
  System.SysUtils,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Logic.WmsRoutingWebServices,
  Logic.Session.TSessionFactory,
  Logic.Session.TSession,
  Logic.TErrorFactory,
  Logic.InitUnit;

{ TRequestGetDocNumbers }

procedure TRequestGetDocNumbers.GetProcessedXml;
var
  XmlReceiv: string;
  XmlDoc: IXMLDocument;
  k: Integer;
  Xa: IXMLNode;
begin
  TLog.LogMethod(Self.ClassType, 'GetProcessedXml');
  if CheckSession() then
  begin
    if GetWmsRoutingWebServices_Port().GetDocNumbers(Session.Location, XmlReceiv) then
    begin
      if not XmlReceiv.IsEmpty() then
      begin
        XmlDoc := TXMLDocument.Create(nil);
        try
          XmlDoc.LoadFromXML(XmlReceiv);
          for k := 0 to XmlDoc.DocumentElement.ChildNodes.Count - 1 do
            XmlResponse.Result.Documents.ChildNodes.Add(XmlDoc.DocumentElement.ChildNodes.Get(k));
          while XmlDoc.DocumentElement.AttributeNodes.Count > 0 do
          begin
            Xa := XmlDoc.DocumentElement.AttributeNodes.Get(0);
            XmlDoc.DocumentElement.AttributeNodes.Remove(Xa);
            XmlResponse.Result.Documents.AttributeNodes.Add(Xa);
          end;
        finally
          XmlDoc := nil;
        end;
      end;
    end
    else
      TErrorFactory.SetInnerWebService(XmlResponse.Error);
  end;
end;

function TRequestGetDocNumbers.GetXmlMessage: IXmlMessageGetDocNumbers;
begin
  Result := inherited XmlMessage as IXmlMessageGetDocNumbers;
end;

function TRequestGetDocNumbers.GetXmlResponse: IXmlResponseGetDocNumbers;
begin
  Result := inherited XmlResponse as IXmlResponseGetDocNumbers;
end;

end.
