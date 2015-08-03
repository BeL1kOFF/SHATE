unit Logic.XmlResponse.TXmlResponseGetBinContentResult;

interface

uses
  Xml.XMLIntf,
  Logic.Xml.TCustomXmlNode;

type
  IXmlResponseGetBinContentResult = interface
  ['{C39D85E1-4EB6-41BC-B2C5-EE832C6AD13B}']
    function GetBinContent: IXMLNode;

    property BinContent: IXMLNode read GetBinContent;
  end;

  TXmlResponseGetBinContentResult = class(TCustomXmlNode, IXmlResponseGetBinContentResult)
  private
    function GetBinContent: IXMLNode;
  end;

implementation

{ TXmlResponseGetBinContentResult }

function TXmlResponseGetBinContentResult.GetBinContent: IXMLNode;
begin
  Result := GetNode('BinContent');
end;

end.
