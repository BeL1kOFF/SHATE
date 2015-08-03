unit Logic.XmlResponse.TXmlResponseLoginUserResult;

interface

uses
  Logic.Xml.TCustomXmlNode;

type
  IXmlResponseLoginUserResult = interface
  ['{A2968BCB-AD4E-47F6-862A-6040CF0F265C}']
    procedure SetSession(const aValue: TGuid);
    procedure SetUserFio(const aValue: string);
    procedure SetDateTime(const aValue: TDateTime);

    property Session: TGuid write SetSession;
    property UserFio: string write SetUserFio;
    property DateTime: TDateTime write SetDateTime;
  end;

  TXmlResponseLoginUserResult = class(TCustomXmlNode, IXmlResponseLoginUserResult)
  private
    procedure SetSession(const aValue: TGuid);
    procedure SetUserFio(const aValue: string);
    procedure SetDateTime(const aValue: TDateTime);
  end;

implementation

uses
  System.SysUtils;

{ TXmlResponseLoginUserResult }

procedure TXmlResponseLoginUserResult.SetDateTime(const aValue: TDateTime);
begin
  GetNode('DateTime').NodeValue := FormatDateTime('dd.mm.yyyy hh:nn:ss', aValue);
end;

procedure TXmlResponseLoginUserResult.SetSession(const aValue: TGuid);
begin
  GetNode('Session').NodeValue := aValue.ToString();
end;

procedure TXmlResponseLoginUserResult.SetUserFio(const aValue: string);
begin
  GetNode('UserFio').NodeValue := aValue;
end;

end.
