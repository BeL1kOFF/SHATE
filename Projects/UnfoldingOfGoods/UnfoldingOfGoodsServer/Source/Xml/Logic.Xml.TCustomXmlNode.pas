unit Logic.Xml.TCustomXmlNode;

interface

uses
  Xml.XMLIntf,
  Logic.Xml.TCustomXml;

type
  TCustomXmlNode = class abstract(TCustomXml)
  private
    FXmlNode: IXMLNode;
  protected
    function GetAttribute(const aName: string): Variant; reintroduce;
    procedure SetAttribute(const aName: string; const aValue: Variant); reintroduce;
    function GetNode(const aName: string): IXMLNode; reintroduce;
    function GetValue(const aName: string): Variant; reintroduce;
    property XmlNode: IXMLNode read FXmlNode;
  public
    constructor Create(aXmlNode: IXMLNode);

  end;

implementation

{ TCustomXmlNode }

constructor TCustomXmlNode.Create(aXmlNode: IXMLNode);
begin
  FXmlNode := aXmlNode;
end;

function TCustomXmlNode.GetAttribute(const aName: string): Variant;
begin
  Result := inherited GetAttribute(FXmlNode, aName);
end;

function TCustomXmlNode.GetNode(const aName: string): IXMLNode;
begin
  Result := inherited GetNode(FXmlNode, aName);
end;

function TCustomXmlNode.GetValue(const aName: string): Variant;
begin
  Result := inherited GetValue(FXmlNode, aName);
end;

procedure TCustomXmlNode.SetAttribute(const aName: string; const aValue: Variant);
begin
  inherited SetAttribute(FXmlNode, aName, aValue);
end;

end.
