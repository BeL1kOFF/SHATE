unit Logic.XmlResponse.TXmlResponseGetDocPlacement;

interface

uses
  Logic.XmlResponse.TCustomXmlResponse,
  Logic.XmlResponse.TXmlResponseGetDocPlacementResult;

type
  IXmlResponseGetDocPlacement = interface(ICustomXmlResponse)
  ['{E03B0384-A03E-4177-85A2-62A99EF114C8}']
    function GetResult: IXmlResponseGetDocPlacementResult;

    property Result: IXmlResponseGetDocPlacementResult read GetResult;
  end;

  TXmlResponseGetDocPlacement = class(TCustomXmlResponse, IXmlResponseGetDocPlacement)
  private
    function GetResult: IXmlResponseGetDocPlacementResult;
  protected
    procedure CreateXml; override;
    procedure CreateResult; override;
  public
    class function GetMessageType: string; override;
  end;

implementation

uses
  Logic.TXmlResponseRegisterList;

{ TXmlResponseGetDocPlacement }

procedure TXmlResponseGetDocPlacement.CreateResult;
begin
  inherited CreateResult();
  CreateNode(inherited Result, 'Document');
end;

procedure TXmlResponseGetDocPlacement.CreateXml;
begin
  inherited CreateXml();
  SetMessage(GetMessageType());
end;

class function TXmlResponseGetDocPlacement.GetMessageType: string;
begin
  Result := 'GetDocPlacement';
end;

function TXmlResponseGetDocPlacement.GetResult: IXmlResponseGetDocPlacementResult;
begin
  Result := TXmlResponseGetDocPlacementResult.Create(inherited Result);
end;

initialization
  XmlResponseRegisterList.RegisterResponse(TXmlResponseGetDocPlacement);

end.
