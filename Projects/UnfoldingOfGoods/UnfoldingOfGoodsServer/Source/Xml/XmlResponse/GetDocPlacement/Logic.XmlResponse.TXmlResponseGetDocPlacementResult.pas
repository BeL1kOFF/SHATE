unit Logic.XmlResponse.TXmlResponseGetDocPlacementResult;

interface

uses
  Xml.XMLIntf,
  Logic.Xml.TCustomXmlNode;

type
  IXmlResponseGetDocPlacementResult = interface
  ['{A0C33B25-59D6-4D89-9982-A44CB300F315}']
    function GetDocument: IXMLNode;

    property Document: IXMLNode read GetDocument;
  end;

  TXmlResponseGetDocPlacementResult = class(TCustomXmlNode, IXmlResponseGetDocPlacementResult)
  private
    function GetDocument: IXMLNode;
  end;

implementation

{ TXmlResponseGetDocPlacementResult }

function TXmlResponseGetDocPlacementResult.GetDocument: IXMLNode;
begin
  Result := GetNode('Document');
end;

end.
