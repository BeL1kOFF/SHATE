unit Logic.XmlMessage.TXmlMessageGetBinContent;

interface

uses
  Xml.XMLIntf,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlMessage.TCustomXmlMessageParams,
  Logic.XmlMessage.TXmlMessageGetBinContentParams;

type
  IXmlMessageGetBinContent = interface(ICustomXmlMessage)
  ['{BBCECE70-16D5-4280-A71C-BF90C06BD7F6}']
    function GetParams: IXmlMessageGetBinContentParams;

    property Params: IXmlMessageGetBinContentParams read GetParams;
  end;

  TXmlMessageGetBinContent = class(TCustomXmlMessage, IXmlMessageGetBinContent)
  private
    function GetParams: IXmlMessageGetBinContentParams;
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlMessageRegisterList;

{ TXmlMessageGetBinContent }

function TXmlMessageGetBinContent.GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams;
begin
  Result := TXmlMessageGetBinContentParams.Create(aXmlNode);
end;

class function TXmlMessageGetBinContent.GetMessageType: string;
begin
  Result := 'GetBinContent';
end;

function TXmlMessageGetBinContent.GetParams: IXmlMessageGetBinContentParams;
begin
  Result := (inherited Params) as IXmlMessageGetBinContentParams;
end;

initialization
  XmlMessageRegisterList.RegisterMessage(TXmlMessageGetBinContent);

end.
