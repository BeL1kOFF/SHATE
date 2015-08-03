unit Logic.XmlResponse.TXmlResponseGetBinContent;

interface

uses
  Logic.XmlResponse.TCustomXmlResponse,
  Logic.XmlResponse.TXmlResponseGetBinContentResult;

type
  IXmlResponseGetBinContent = interface(ICustomXmlResponse)
  ['{9B2791B4-9B06-44EA-9234-2C684C91BFB9}']
    function GetResult: IXmlResponseGetBinContentResult;

    property Result: IXmlResponseGetBinContentResult read GetResult;
  end;

  TXmlResponseGetBinContent = class(TCustomXmlResponse, IXmlResponseGetBinContent)
  private
    function GetResult: IXmlResponseGetBinContentResult;
  protected
    procedure CreateXml; override;
    procedure CreateResult; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlResponseRegisterList;

{ TXmlResponseGetBinContent }

procedure TXmlResponseGetBinContent.CreateResult;
begin
  inherited CreateResult();
  CreateNode(inherited Result, 'BinContent');
end;

procedure TXmlResponseGetBinContent.CreateXml;
begin
  inherited CreateXml();
  SetMessage(GetMessageType());
end;

class function TXmlResponseGetBinContent.GetMessageType: string;
begin
  Result := 'GetBinContent';
end;

function TXmlResponseGetBinContent.GetResult: IXmlResponseGetBinContentResult;
begin
  Result := TXmlResponseGetBinContentResult.Create(inherited Result);
end;

initialization
  XmlResponseRegisterList.RegisterResponse(TXmlResponseGetBinContent);

end.
