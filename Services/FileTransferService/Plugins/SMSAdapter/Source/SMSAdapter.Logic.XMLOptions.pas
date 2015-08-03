
{*****************************************************************************************************}
{                                                                                                     }
{                                          XML Data Binding                                           }
{                                                                                                     }
{         Generated on: 27.02.2015 15:02:54                                                           }
{       Generated from: D:\Работа\SVN\trunk\Services\FileTransferService\Plugins\SMSAdapter\SMS.xml   }
{                                                                                                     }
{*****************************************************************************************************}

unit SMSAdapter.Logic.XMLOptions;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLXmlType = interface;
  IXMLOptionsType = interface;

{ IXMLXmlType }

  IXMLXmlType = interface(IXMLNode)
    ['{0D6764B3-A763-40CF-85C4-25C97CA6973C}']
    { Property Accessors }
    function Get_Options: IXMLOptionsType;
    { Methods & Properties }
    property Options: IXMLOptionsType read Get_Options;
  end;

{ IXMLOptionsType }

  IXMLOptionsType = interface(IXMLNode)
    ['{7CC5CF23-8E30-418A-9397-BA7AF4043400}']
    { Property Accessors }
    function Get_Server: string;
    function Get_Db: string;
    { Methods & Properties }
    property Server: string read Get_Server;
    property Db: string read Get_Db;
  end;

{ Forward Decls }

  TXMLXmlType = class;
  TXMLOptionsType = class;

{ TXMLXmlType }

  TXMLXmlType = class(TXMLNode, IXMLXmlType)
  protected
    { IXMLXmlType }
    function Get_Options: IXMLOptionsType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOptionsType }

  TXMLOptionsType = class(TXMLNode, IXMLOptionsType)
  protected
    { IXMLOptionsType }
    function Get_Server: string;
    function Get_Db: string;
  end;

{ Global Functions }

function Getxml(Doc: IXMLDocument): IXMLXmlType;
function Loadxml(const FileName: string): IXMLXmlType;
function Newxml: IXMLXmlType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function Getxml(Doc: IXMLDocument): IXMLXmlType;
begin
  Result := Doc.GetDocBinding('xml', TXMLXmlType, TargetNamespace) as IXMLXmlType;
end;

function Loadxml(const FileName: string): IXMLXmlType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('xml', TXMLXmlType, TargetNamespace) as IXMLXmlType;
end;

function Newxml: IXMLXmlType;
begin
  Result := NewXMLDocument.GetDocBinding('xml', TXMLXmlType, TargetNamespace) as IXMLXmlType;
end;

{ TXMLXmlType }

procedure TXMLXmlType.AfterConstruction;
begin
  RegisterChildNode('options', TXMLOptionsType);
  inherited;
end;

function TXMLXmlType.Get_Options: IXMLOptionsType;
begin
  Result := ChildNodes['options'] as IXMLOptionsType;
end;

{ TXMLOptionsType }

function TXMLOptionsType.Get_Server: string;
begin
  Result := ChildNodes['server'].Text;
end;

function TXMLOptionsType.Get_Db: string;
begin
  Result := ChildNodes['db'].Text;
end;

end.