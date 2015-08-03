unit Logic.XmlResponse.TXmlResponseLogoutUser;

interface

uses
  Logic.XmlResponse.TCustomXmlResponse;

type
  IXmlResponseLogoutUser = interface(ICustomXmlResponse)
  ['{369D57B6-CFBC-4BCA-B94E-9B18208BEB05}']
    procedure SetResult(const aValue: Integer);

    property Result: Integer write SetResult;
  end;

  TXmlResponseLogoutUser = class(TCustomXmlResponse, IXmlResponseLogoutUser)
  private
    procedure SetResult(const aValue: Integer);
  protected
    procedure CreateXml; override;
  public
    class function GetMessageType: string; override;
    property Result: Integer write SetResult;
  end;

implementation

uses
  Logic.TXmlResponseRegisterList;

{ TXmlResponseLogoutUser }

procedure TXmlResponseLogoutUser.CreateXml;
begin
  inherited CreateXml();
  SetMessage(GetMessageType());
end;

class function TXmlResponseLogoutUser.GetMessageType: string;
begin
  Result := 'LogoutUser';
end;

procedure TXmlResponseLogoutUser.SetResult(const aValue: Integer);
begin
  (inherited Result).NodeValue := aValue;
end;

initialization
  XmlResponseRegisterList.RegisterResponse(TXmlResponseLogoutUser);

end.
