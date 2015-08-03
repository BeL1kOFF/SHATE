unit Logic.XmlMessage.TXmlMessageDefault;

interface

uses
  Xml.XMLIntf,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlMessage.TCustomXmlMessageParams;

type
  TXmlMessageDefault = class(TCustomXmlMessage)
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  System.SysUtils;

{ TXmlMessageDefault }

function TXmlMessageDefault.GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams;
begin
  raise Exception.Create('Not Implemented');
end;

class function TXmlMessageDefault.GetMessageType: string;
begin
  Result := 'Default';
end;

end.
