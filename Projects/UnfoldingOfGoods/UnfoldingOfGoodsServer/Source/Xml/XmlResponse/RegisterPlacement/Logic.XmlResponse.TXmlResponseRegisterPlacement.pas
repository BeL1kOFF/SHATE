unit Logic.XmlResponse.TXmlResponseRegisterPlacement;

interface

uses
  Logic.XmlResponse.TCustomXmlResponse;

type
  IXmlResponseRegisterPlacement = interface(ICustomXmlResponse)
  ['{99CF0390-6041-40D9-B542-61F7DB7041D3}']
    procedure SetResult(const aValue: Integer);

    property Result: Integer write SetResult;
  end;

  TXmlResponseRegisterPlacement = class(TCustomXmlResponse, IXmlResponseRegisterPlacement)
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

{ TXmlResponseRegisterPlacement }

procedure TXmlResponseRegisterPlacement.CreateXml;
begin
  inherited CreateXml();
  SetMessage(GetMessageType());
end;

class function TXmlResponseRegisterPlacement.GetMessageType: string;
begin
  Result := 'RegisterPlacement';
end;

procedure TXmlResponseRegisterPlacement.SetResult(const aValue: Integer);
begin
  (inherited Result).NodeValue := aValue;
end;

initialization
  XmlResponseRegisterList.RegisterResponse(TXmlResponseRegisterPlacement);

end.
