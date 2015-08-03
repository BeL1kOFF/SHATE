unit Logic.XmlMessage.TCustomXmlMessageParams;

interface

uses
  Logic.Xml.TCustomXmlNode;

type
  ICustomXmlMessageParams = interface
  ['{C4EA47D3-B3E2-4904-B63A-860FF3F8B04C}']
  end;

  TCustomXmlMessageParams = class(TCustomXmlNode, ICustomXmlMessageParams)
  end;

implementation

end.
