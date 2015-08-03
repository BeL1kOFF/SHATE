unit Logic.XmlResponse.TXmlResponseLoginUser;

interface

uses
  Logic.XmlResponse.TCustomXmlResponse,
  Logic.XmlResponse.TXmlResponseLoginUserResult;

type
  IXmlResponseLoginUser = interface(ICustomXmlResponse)
  ['{6982DA90-11F6-46C6-ACBF-9B16A34E1F8A}']
    function GetResult: IXmlResponseLoginUserResult;

    property Result: IXmlResponseLoginUserResult read GetResult;
  end;

  TXmlResponseLoginUser = class(TCustomXmlResponse, IXmlResponseLoginUser)
  private
    function GetResult: IXmlResponseLoginUserResult;
  protected
    procedure CreateXml; override;
    procedure CreateResult; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlResponseRegisterList;

{ TXmlResponseLoginUser }

procedure TXmlResponseLoginUser.CreateResult;
begin
  inherited CreateResult();
  CreateNode(inherited Result, 'Session');
  CreateNode(inherited Result, 'UserFio');
  CreateNode(inherited Result, 'DateTime');
end;

procedure TXmlResponseLoginUser.CreateXml;
begin
  inherited CreateXml();
  SetMessage(GetMessageType());
end;

class function TXmlResponseLoginUser.GetMessageType: string;
begin
  Result := 'LoginUser';
end;

function TXmlResponseLoginUser.GetResult: IXmlResponseLoginUserResult;
begin
  Result := TXmlResponseLoginUserResult.Create(inherited Result);
end;

initialization
  XmlResponseRegisterList.RegisterResponse(TXmlResponseLoginUser);

end.
