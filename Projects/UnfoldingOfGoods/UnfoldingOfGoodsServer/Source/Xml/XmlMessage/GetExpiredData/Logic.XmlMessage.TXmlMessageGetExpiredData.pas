unit Logic.XmlMessage.TXmlMessageGetExpiredData;

interface

uses
  Xml.XMLIntf,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlMessage.TCustomXmlMessageParams,
  Logic.XmlMessage.TXmlMessageGetExpiredDataParams;

type
  IXmlMessageGetExpiredData = interface(ICustomXmlMessage)
  ['{5E8B55F0-B59F-4C8D-B0E2-4822D86B44F2}']
    function GetParams: IXmlMessageGetExpiredDataParams;

    property Params: IXmlMessageGetExpiredDataParams read GetParams;
  end;

  TXmlMessageGetExpiredData = class(TCustomXmlMessage, IXmlMessageGetExpiredData)
  private
    function GetParams: IXmlMessageGetExpiredDataParams;
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlMessageRegisterList;

{ TXmlMessageGetExpiredData }

function TXmlMessageGetExpiredData.GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams;
begin
  Result := TXmlMessageGetExpiredDataParams.Create(aXmlNode);
end;

class function TXmlMessageGetExpiredData.GetMessageType: string;
begin
  Result := 'GetExpiredData';
end;

function TXmlMessageGetExpiredData.GetParams: IXmlMessageGetExpiredDataParams;
begin
  Result := (inherited Params) as IXmlMessageGetExpiredDataParams;
end;

initialization
  XmlMessageRegisterList.RegisterMessage(TXmlMessageGetExpiredData);

end.
