unit Logic.XmlMessage.TXmlMessageRegisterPlacement;

interface

uses
  Xml.XMLIntf,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlMessage.TCustomXmlMessageParams;

type
  IXmlMessageRegisterPlacement = interface(ICustomXmlMessage)
  ['{2C4EB887-C04E-483E-B2E5-CD1908564A5C}']
    function GetDocument: IXMLNode;
    function GetUserName: string;
    function GetUserLocation: string;

    property Document: IXMLNode read GetDocument;
    property UserName: string read GetUserName;
    property UserLocation: string read GetUserLocation;
  end;

  TXmlMessageRegisterPlacement = class(TCustomXmlMessage, IXmlMessageRegisterPlacement)
  private
    function GetDocument: IXMLNode;
    function GetUserName: string;
    function GetUserLocation: string;
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  System.SysUtils,
  Logic.TXmlMessageRegisterList;

{ TXmlMessageRegisterPlacement }

function TXmlMessageRegisterPlacement.GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams;
begin
  raise Exception.Create('Not Implemented');
end;

function TXmlMessageRegisterPlacement.GetDocument: IXMLNode;
begin
  Result := GetNode(XmlDOcument.DocumentElement, 'Document');
end;

class function TXmlMessageRegisterPlacement.GetMessageType: string;
begin
  Result := 'RegisterPlacement';
end;

function TXmlMessageRegisterPlacement.GetUserLocation: string;
begin
  Result := GetAttribute(XmlDOcument.DocumentElement, 'UserLocation');
end;

function TXmlMessageRegisterPlacement.GetUserName: string;
begin
  Result := GetAttribute(XmlDOcument.DocumentElement, 'UserName');
end;

initialization
  XmlMessageRegisterList.RegisterMessage(TXmlMessageRegisterPlacement);

end.
