unit Logic.XmlMessage.TXmlMessageLogoutUserParams;

interface

uses
  Logic.XmlMessage.TCustomXmlMessageParams;

type
  IXmlMessageLogoutUserParams = interface(ICustomXmlMessageParams)
  ['{1B1CA460-AFFC-4F19-9AAF-7CE3E6065688}']
    function GetUserName: string;

    property UserName: string read GetUserName;
  end;

  TXmlMessageLogoutUserParams = class(TCustomXmlMessageParams, IXmlMessageLogoutUserParams)
  private
    function GetUserName: string;
  end;

implementation

{ TXmlMessageLogoutUserParams }

function TXmlMessageLogoutUserParams.GetUserName: string;
begin
  Result := GetAttribute('UserName');
end;

end.
