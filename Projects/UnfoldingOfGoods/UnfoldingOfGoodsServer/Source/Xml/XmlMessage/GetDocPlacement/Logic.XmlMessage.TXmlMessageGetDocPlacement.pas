unit Logic.XmlMessage.TXmlMessageGetDocPlacement;

interface

uses
  Xml.XMLIntf,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlMessage.TCustomXmlMessageParams,
  Logic.XmlMessage.TXmlMessageGetDocPlacementParams;

type
  IXmlMessageGetDocPlacement = interface(ICustomXmlMessage)
  ['{651A9F88-A9AB-466F-A02F-5664FDC1C8EA}']
    function GetParams: IXmlMessageGetDocPlacementParams;

    property Params: IXmlMessageGetDocPlacementParams read GetParams;
  end;

  TXmlMessageGetDocPlacement = class(TCustomXmlMessage, IXmlMessageGetDocPlacement)
  private
    function GetParams: IXmlMessageGetDocPlacementParams;
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlMessageRegisterList;

{ TXmlMessageGetDocPlacement }

function TXmlMessageGetDocPlacement.GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams;
begin
  Result := TXmlMessageGetDocPlacementParams.Create(aXmlNode);
end;

class function TXmlMessageGetDocPlacement.GetMessageType: string;
begin
  Result := 'GetDocPlacement';
end;

function TXmlMessageGetDocPlacement.GetParams: IXmlMessageGetDocPlacementParams;
begin
  Result := (inherited Params) as IXmlMessageGetDocPlacementParams;
end;

initialization
  XmlMessageRegisterList.RegisterMessage(TXmlMessageGetDocPlacement);

end.
