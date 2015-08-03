unit Logic.XmlResponse.TXmlResponseGetDocNumbersResult;

interface

uses
  Xml.XMLIntf,
  Logic.Xml.TCustomXmlNode;

type
  IXmlResponseGetDocNumbersResult = interface
  ['{865FB437-724C-4799-B9F1-693E37F62163}']
    function GetDocuments: IXMLNode;

    property Documents: IXMLNode read GetDocuments;
  end;

  TXmlResponseGetDocNumbersResult = class(TCustomXmlNode, IXmlResponseGetDocNumbersResult)
  private
    function GetDocuments: IXMLNode;
  end;

implementation

{ TXmlResponseGetDocNumbersResult }

function TXmlResponseGetDocNumbersResult.GetDocuments: IXMLNode;
begin
  Result := GetNode('Documents');
end;

end.
