unit Logic.XmlResponse.TXmlResponseDefault;

interface

uses
  Logic.XmlResponse.TCustomXmlResponse;

type
  TXmlResponseDefault = class(TCustomXmlResponse)
  protected
    procedure CreateXml; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

{ TXmlResponseDefault }

procedure TXmlResponseDefault.CreateXml;
begin
  inherited CreateXml();
  SetMessage(GetMessageType());
end;

class function TXmlResponseDefault.GetMessageType: string;
begin
  Result := 'Default';
end;

end.
