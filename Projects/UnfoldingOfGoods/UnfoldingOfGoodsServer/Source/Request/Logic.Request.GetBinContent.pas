unit Logic.Request.GetBinContent;

interface

uses
  Logic.Request.TCustomRequest,
  Logic.Request.IRequest,
  Logic.XmlMessage.TXmlMessageGetBinContent,
  Logic.XmlResponse.TXmlResponseGetBinContent;

type
  TRequestGetBinContent = class(TCustomRequest, IRequest)
  private
    procedure GetProcessedXml;
  protected
    function GetXmlMessage: IXmlMessageGetBinContent;
    function GetXmlResponse: IXmlResponseGetBinContent;
  protected
    property XmlMessage: IXmlMessageGetBinContent read GetXmlMessage;
    property XmlResponse: IXmlResponseGetBinContent read GetXmlResponse;
  end;

implementation

uses
  System.SysUtils,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Logic.WmsRoutingWebServices,
  Logic.TErrorFactory,
  Logic.InitUnit;

{ TRequestGetBinContent }

procedure TRequestGetBinContent.GetProcessedXml;
var
  XmlReceiv: string;
  XmlDoc: IXMLDocument;
  k: Integer;
  Xa: IXMLNode;
begin
  TLog.LogMethod(Self.ClassType, 'GetProcessedXml');
  if CheckSession() then
  begin
    if GetWmsRoutingWebServices_Port().GetBinContent(Session.Location, XmlMessage.Params.ItemNo, XmlReceiv) then
    begin
      if not XmlReceiv.IsEmpty() then
      begin
        XmlDoc := TXMLDocument.Create(nil);
        try
          XmlDoc.LoadFromXML(XmlReceiv);
          for k := 0 to XmlDoc.DocumentElement.ChildNodes.Count - 1 do
            XmlResponse.Result.BinContent.ChildNodes.Add(XmlDoc.DocumentElement.ChildNodes.Get(k));
          while XmlDoc.DocumentElement.AttributeNodes.Count > 0 do
          begin
            Xa := XmlDoc.DocumentElement.AttributeNodes.Get(0);
            XmlDoc.DocumentElement.AttributeNodes.Remove(Xa);
            XmlResponse.Result.BinContent.AttributeNodes.Add(Xa);
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

function TRequestGetBinContent.GetXmlMessage: IXmlMessageGetBinContent;
begin
  Result := inherited XmlMessage as IXmlMessageGetBinContent;
end;

function TRequestGetBinContent.GetXmlResponse: IXmlResponseGetBinContent;
begin
  Result := inherited XmlResponse as IXmlResponseGetBinContent;
end;

end.
