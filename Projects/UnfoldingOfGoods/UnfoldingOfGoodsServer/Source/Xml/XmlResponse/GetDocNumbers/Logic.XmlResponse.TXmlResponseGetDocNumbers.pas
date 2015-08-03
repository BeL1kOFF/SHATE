unit Logic.XmlResponse.TXmlResponseGetDocNumbers;

interface

uses
  Logic.XmlResponse.TCustomXmlResponse,
  Logic.XmlResponse.TXmlResponseGetDocNumbersResult;

type
  IXmlResponseGetDocNumbers = interface(ICustomXmlResponse)
  ['{A4D2A761-5E66-4501-831D-26F4AC74D693}']
    function GetResult: IXmlResponseGetDocNumbersResult;

    property Result: IXmlResponseGetDocNumbersResult read GetResult;
  end;

  TXmlResponseGetDocNumbers = class(TCustomXmlResponse, IXmlResponseGetDocNumbers)
  private
    function GetResult: IXmlResponseGetDocNumbersResult;
  protected
    procedure CreateXml; override;
    procedure CreateResult; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlResponseRegisterList;

{ TXmlResponseGetDocNumbers }

procedure TXmlResponseGetDocNumbers.CreateResult;
begin
  inherited CreateResult();
  CreateNode(inherited Result, 'Documents');
end;

procedure TXmlResponseGetDocNumbers.CreateXml;
begin
  inherited CreateXml();
  SetMessage(GetMessageType());
end;

class function TXmlResponseGetDocNumbers.GetMessageType: string;
begin
  Result := 'GetDocNumbers';
end;

function TXmlResponseGetDocNumbers.GetResult: IXmlResponseGetDocNumbersResult;
begin
  Result := TXmlResponseGetDocNumbersResult.Create(inherited Result);
end;

initialization
  XmlResponseRegisterList.RegisterResponse(TXmlResponseGetDocNumbers);

end.
