unit Logic.XmlResponse.TCustomXmlResponse;

interface

uses
  Xml.XMLIntf,
  Logic.Xml.TCustomXml,
  Logic.XmlResponse.TCustomXmlResponseError;

type
  ICustomXmlResponse = interface
  ['{719B9F7C-FDB7-4746-BC98-F411267D5A78}']
    function GetType: string;
    function GetError: ICustomXmlResponseError;
    function GetXml: string;

    procedure SetMessage(const aType: string);

    property Type_: string read GetType;
    property Error: ICustomXmlResponseError read GetError;
    property Xml: string read GetXml;
  end;

  TCustomXmlResponse = class abstract(TCustomXml, ICustomXmlResponse)
  private
    FXmlDocument: IXMLDocument;
    procedure CreateRoot;
    function GetXml: string;
    function GetType: string;
    function GetResult: IXMLNode;
    function GetError: ICustomXmlResponseError;
  protected
    function CreateNode(aXMLNode: IXMLNode; const aName: string): IXMLNode;
    procedure CreateAttribute(aXMLNode: IXMLNode; const aName: string);
    procedure CreateXml; virtual;
    procedure CreateResult; virtual;
    procedure SetMessage(const aType: string); virtual;
    property XmlDocument: IXMLDocument read FXmlDocument;
    property Result: IXMLNode read GetResult;
  public
    constructor Create; virtual;
    class function GetMessageType: string; virtual;
  end;

  TCustomXmlResponseClass = class of TCustomXmlResponse;

implementation

uses
  Xml.XmlDoc;

{ TCustomXmlResponse }

constructor TCustomXmlResponse.Create;
begin
  FXmlDocument := NewXMLDocument();
  CreateXml();
end;

procedure TCustomXmlResponse.CreateAttribute(aXMLNode: IXMLNode; const aName: string);
var
  XmlNode: IXMLNode;
begin
  XmlNode := aXMLNode.OwnerDocument.CreateNode(aName, ntAttribute, '');
  aXMLNode.AttributeNodes.Add(XmlNode);
end;

function TCustomXmlResponse.CreateNode(aXMLNode: IXMLNode; const aName: string): IXMLNode;
begin
  Result := aXMLNode.OwnerDocument.CreateNode(aName, ntElement, '');
  aXMLNode.ChildNodes.Add(Result);
end;

procedure TCustomXmlResponse.CreateResult;
begin
  CreateNode(FXmlDocument.DocumentElement, 'Result');
end;

procedure TCustomXmlResponse.CreateRoot;
var
  XmlNode: IXMLNode;
begin
  XmlNode := FXmlDocument.CreateNode('Response', ntElement, '');
  FXmlDocument.ChildNodes.Add(XmlNode);
end;

procedure TCustomXmlResponse.CreateXml;
var
  XmlNode: IXMLNode;
begin
  CreateRoot();
  CreateAttribute(FXmlDocument.DocumentElement, 'Type');
  XmlNode := CreateNode(FXmlDocument.DocumentElement, 'Error');
  CreateAttribute(XmlNode, 'Code');
  CreateResult();
end;

function TCustomXmlResponse.GetError: ICustomXmlResponseError;
begin
  Result := TCustomXmlResponseError.Create(GetNode(FXmlDocument.DocumentElement, 'Error'));
end;

class function TCustomXmlResponse.GetMessageType: string;
begin
  Result := '';
end;

function TCustomXmlResponse.GetResult: IXMLNode;
begin
  Result := GetNode(FXmlDocument.DocumentElement, 'Result');
end;

function TCustomXmlResponse.GetType: string;
begin
  Result := GetAttribute(FXmlDocument.DocumentElement, 'Type');
end;

function TCustomXmlResponse.GetXml: string;
begin
  Result := FXmlDocument.DocumentElement.XML;
end;

procedure TCustomXmlResponse.SetMessage(const aType: string);
begin
  SetAttribute(FXmlDocument.DocumentElement, 'Type', aType);
end;

end.
