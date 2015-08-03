unit Logic.XmlResponse.TCustomXmlResponseError;

interface

uses
  Logic.Xml.TCustomXmlNode;

type
  ICustomXmlResponseError = interface
  ['{856DFA07-CCA1-4CDC-8756-F314D14547FA}']
    function GetCode: Integer;
    function GetNodeValue: string;

    procedure SetCode(aValue: Integer);
    procedure SetNodeValue(const aValue: string);

    property Code: Integer read GetCode write SetCode;
    property NodeValue: string read GetNodeValue write SetNodeValue;
  end;

  TCustomXmlResponseError = class(TCustomXmlNode, ICustomXmlResponseError)
  private
    function GetCode: Integer;
    function GetNodeValue: string;

    procedure SetCode(aValue: Integer);
    procedure SetNodeValue(const aValue: string);
  end;

implementation

{ TCustomXmlResponseError }

function TCustomXmlResponseError.GetCode: Integer;
begin
  Result := GetAttribute('Code');
end;

function TCustomXmlResponseError.GetNodeValue: string;
begin
  Result := XmlNode.NodeValue;
end;

procedure TCustomXmlResponseError.SetCode(aValue: Integer);
begin
  SetAttribute('Code', aValue);
end;

procedure TCustomXmlResponseError.SetNodeValue(const aValue: string);
begin
  XmlNode.NodeValue := aValue;
end;

end.
