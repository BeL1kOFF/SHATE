unit Logic.XmlMessage.TXmlMessageGetDocNumbers;

interface

uses
  Xml.XMLIntf,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlMessage.TCustomXmlMessageParams,
  Logic.XmlMessage.TXmlMessageLoginUserParams;

type
  IXmlMessageGetDocNumbers = interface(ICustomXmlMessage)
  ['{03602B1E-7C98-4E6C-9F27-C2889CC07128}']
  end;

  TXmlMessageGetDocNumbers = class(TCustomXmlMessage, IXmlMessageGetDocNumbers)
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  System.SysUtils,
  Logic.TXmlMessageRegisterList;

{ TXmlMessageGetDocNumbers }

function TXmlMessageGetDocNumbers.GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams;
begin
  raise Exception.Create('Not Implemented');
end;

class function TXmlMessageGetDocNumbers.GetMessageType: string;
begin
  Result := 'GetDocNumbers';
end;

initialization
  XmlMessageRegisterList.RegisterMessage(TXmlMessageGetDocNumbers);

end.
