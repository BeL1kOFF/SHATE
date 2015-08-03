unit Logic.XmlMessage.TCustomXmlMessage;

interface

uses
  Xml.XMLIntf,
  Logic.Xml.TCustomXml,
  Logic.XmlMessage.TCustomXmlMessageParams;

type
  ICustomXmlMessage = interface
  ['{C8193D8E-4196-4465-B156-676C7DB1FC94}']
    function GetType: string;
    function GetSession: TGuid;
    function GetParams: ICustomXmlMessageParams;
    function GetDefaultType: string;

    property Type_: string read GetType;
    property Params: ICustomXmlMessageParams read GetParams;
    property Session: TGuid read GetSession;

    property DefaultType: string read GetDefaultType;
  end;

  TCustomXmlMessage = class abstract(TCustomXml, ICustomXmlMessage)
  private
    FXMLDocument: IXMLDocument;
    function GetType: string;
    function GetSession: TGuid;
    function GetParams: ICustomXmlMessageParams;
    function GetDefaultType: string;
  protected
    function GetClass(aXmlNode: IXMLNode): ICustomXmlMessageParams; virtual; abstract;
    property XmlDOcument: IXMLDocument read FXMLDocument;
    property Params: ICustomXmlMessageParams read GetParams;
  public
    constructor Create(const aXml: string);
    class function GetMessageType: string; virtual;
  end;

  TCustomXmlMessageClass = class of TCustomXmlMessage;

implementation

uses
  System.SysUtils,
  Xml.XmlDoc;

{ TCustomXmlMessage }

constructor TCustomXmlMessage.Create(const aXml: string);
begin
  FXMLDocument := TXMLDocument.Create(nil);
  FXMLDocument.LoadFromXML(aXml);
end;

function TCustomXmlMessage.GetDefaultType: string;
begin
  Result := GetMessageType();
end;

class function TCustomXmlMessage.GetMessageType: string;
begin
  Result := '';
end;

function TCustomXmlMessage.GetParams: ICustomXmlMessageParams;
begin
  Result := GetClass(GetNode(FXMLDocument.DocumentElement, 'params'));
end;

function TCustomXmlMessage.GetSession: TGUID;
var
  GuidStr: string;
begin
  GuidStr := GetAttribute(FXMLDocument.DocumentElement, 'Session');
  if GuidStr.IsEmpty() then
    Result := TGUID.Empty()
  else
    Result := TGUID.Create(GetAttribute(FXMLDocument.DocumentElement, 'Session'));
end;

function TCustomXmlMessage.GetType: string;
begin
  Result := GetAttribute(FXMLDocument.DocumentElement, 'Type');
end;

end.
