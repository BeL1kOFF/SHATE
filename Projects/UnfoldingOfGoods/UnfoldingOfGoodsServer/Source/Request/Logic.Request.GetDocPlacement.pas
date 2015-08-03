unit Logic.Request.GetDocPlacement;

interface

uses
  Logic.Request.TCustomRequest,
  Logic.Request.IRequest,
  Logic.XmlMessage.TXmlMessageGetDocPlacement,
  Logic.XmlResponse.TXmlResponseGetDocPlacement;

type
  TRequestGetDocPlacement = class(TCustomRequest, IRequest)
  private
    procedure GetProcessedXml;
  protected
    function GetXmlMessage: IXmlMessageGetDocPlacement;
    function GetXmlResponse: IXmlResponseGetDocPlacement;
  protected
    property XmlMessage: IXmlMessageGetDocPlacement read GetXmlMessage;
    property XmlResponse: IXmlResponseGetDocPlacement read GetXmlResponse;
  end;

implementation

uses
  System.SysUtils,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Logic.WmsRoutingWebServices,
  Logic.TErrorFactory,
  Logic.InitUnit;

{ TRequestGetDocPlacement }

procedure TRequestGetDocPlacement.GetProcessedXml;
var
  XmlReceiv: string;
  XmlDoc: IXMLDocument;
  k: Integer;
  Xa: IXMLNode;
begin
  TLog.LogMethod(Self.ClassType, 'GetProcessedXml');
  if CheckSession() then
  begin
    if GetWmsRoutingWebServices_Port().GetDocPlacement(XmlMessage.Params.DocNo, XmlReceiv) then
    begin
      if not XmlReceiv.IsEmpty() then
      begin
        XmlDoc := TXMLDocument.Create(nil);
        try
          XmlDoc.LoadFromXML(XmlReceiv);
          for k := 0 to XmlDoc.DocumentElement.ChildNodes.Count - 1 do
            XmlResponse.Result.Document.ChildNodes.Add(XmlDoc.DocumentElement.ChildNodes.Get(k));
          while XmlDoc.DocumentElement.AttributeNodes.Count > 0 do
          begin
            Xa := XmlDoc.DocumentElement.AttributeNodes.Get(0);
            XmlDoc.DocumentElement.AttributeNodes.Remove(Xa);
            XmlResponse.Result.Document.AttributeNodes.Add(Xa);
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

function TRequestGetDocPlacement.GetXmlMessage: IXmlMessageGetDocPlacement;
begin
  Result := inherited XmlMessage as IXmlMessageGetDocPlacement;
end;

function TRequestGetDocPlacement.GetXmlResponse: IXmlResponseGetDocPlacement;
begin
  Result := inherited XmlResponse as IXmlResponseGetDocPlacement;
end;

end.
