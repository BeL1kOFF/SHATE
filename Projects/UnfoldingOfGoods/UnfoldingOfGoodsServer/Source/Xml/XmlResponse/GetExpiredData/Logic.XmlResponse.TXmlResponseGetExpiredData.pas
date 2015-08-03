unit Logic.XmlResponse.TXmlResponseGetExpiredData;

interface

uses
  Logic.XmlResponse.TCustomXmlResponse;

type
  IXmlResponseGetExpiredData = interface(ICustomXmlResponse)
  ['{AB8EF74E-4F07-4C52-BADF-DB21264DF498}']
    procedure SetResult(const aValue: Integer);

    property Result: Integer write SetResult;
  end;

  TXmlResponseGetExpiredData = class(TCustomXmlResponse, IXmlResponseGetExpiredData)
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

{ TXmlResponseGetExpiredData }

procedure TXmlResponseGetExpiredData.CreateXml;
begin
  inherited CreateXml();
  SetMessage(GetMessageType());
end;

class function TXmlResponseGetExpiredData.GetMessageType: string;
begin
  Result := 'GetExpiredData';
end;

procedure TXmlResponseGetExpiredData.SetResult(const aValue: Integer);
begin
  (inherited Result).NodeValue := aValue;
end;

initialization
  XmlResponseRegisterList.RegisterResponse(TXmlResponseGetExpiredData);

end.
