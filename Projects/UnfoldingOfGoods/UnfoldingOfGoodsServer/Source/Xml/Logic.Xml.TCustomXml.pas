unit Logic.Xml.TCustomXml;

interface

uses
  Xml.XMLIntf;

type
  TCustomXml = class abstract(TInterfacedObject)
  protected
    function GetAttribute(aXMLNode: IXMLNode; const aName: string): Variant; virtual;
    procedure SetAttribute(aXMLNode: IXMLNode; const aName: string; const aValue: Variant); virtual;
    function GetNode(aXMLNode: IXMLNode; const aName: string): IXMLNode; virtual;
    function GetValue(aXMLNode: IXMLNode; const aName: string): Variant; virtual;
  end;

implementation

{ TCustomXml }

function TCustomXml.GetAttribute(aXMLNode: IXMLNode; const aName: string): Variant;
begin
  Result := aXMLNode.Attributes[aName];
end;

function TCustomXml.GetNode(aXMLNode: IXMLNode; const aName: string): IXMLNode;
begin
  Result := aXMLNode.ChildNodes.FindNode(aName);
end;

function TCustomXml.GetValue(aXMLNode: IXMLNode; const aName: string): Variant;
begin
  Result := GetNode(aXMLNode, aName).NodeValue;
end;

procedure TCustomXml.SetAttribute(aXMLNode: IXMLNode; const aName: string; const aValue: Variant);
begin
  aXMLNode.Attributes[aName] := aValue;
end;

end.
