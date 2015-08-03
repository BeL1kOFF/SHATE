unit Logic.XmlMessage.TXmlMessageLoginUser;

interface

uses
  Xml.XMLIntf,
  Logic.XmlMessage.TCustomXmlMessage,
  Logic.XmlMessage.TCustomXmlMessageParams,
  Logic.XmlMessage.TXmlMessageLoginUserParams;

type
  IXmlMessageLoginUser = interface(ICustomXmlMessage)
  ['{03602B1E-7C98-4E6C-9F27-C2889CC07128}']
    function GetParams: IXmlMessageLoginUserParams;

    property Params: IXmlMessageLoginUserParams read GetParams;
  end;

  TXmlMessageLoginUser = class(TCustomXmlMessage, IXmlMessageLoginUser)
  private
    function GetParams: IXmlMessageLoginUserParams;
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlMessageRegisterList;

{ TXmlMessageLoginUser }

function TXmlMessageLoginUser.GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams;
begin
  Result := TXmlMessageLoginUserParams.Create(aXmlNode);
end;

class function TXmlMessageLoginUser.GetMessageType: string;
begin
  Result := 'LoginUser';
end;

function TXmlMessageLoginUser.GetParams: IXmlMessageLoginUserParams;
begin
  Result := (inherited Params) as IXmlMessageLoginUserParams;
end;

initialization
  XmlMessageRegisterList.RegisterMessage(TXmlMessageLoginUser);

end.
