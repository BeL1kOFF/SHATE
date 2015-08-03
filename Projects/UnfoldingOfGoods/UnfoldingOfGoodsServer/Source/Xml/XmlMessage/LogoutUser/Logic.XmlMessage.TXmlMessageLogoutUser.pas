unit Logic.XmlMessage.TXmlMessageLogoutUser;

interface

uses
  Xml.XMLIntf,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlMessage.TCustomXmlMessageParams,
  Logic.XmlMessage.TXmlMessageLogoutUserParams;

type
  IXmlMessageLogoutUser = interface(ICustomXmlMessage)
  ['{BBCECE70-16D5-4280-A71C-BF90C06BD7F6}']
    function GetParams: IXmlMessageLogoutUserParams;

    property Params: IXmlMessageLogoutUserParams read GetParams;
  end;

  TXmlMessageLogoutUser = class(TCustomXmlMessage, IXmlMessageLogoutUser)
  private
    function GetParams: IXmlMessageLogoutUserParams;
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlMessageRegisterList;

{ TXmlMessageLogoutUser }

function TXmlMessageLogoutUser.GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams;
begin
  Result := TXmlMessageLogoutUserParams.Create(aXmlNode);
end;

class function TXmlMessageLogoutUser.GetMessageType: string;
begin
  Result := 'LogoutUser';
end;

function TXmlMessageLogoutUser.GetParams: IXmlMessageLogoutUserParams;
begin
  Result := (inherited Params) as IXmlMessageLogoutUserParams;
end;

initialization
  XmlMessageRegisterList.RegisterMessage(TXmlMessageLogoutUser);

end.
