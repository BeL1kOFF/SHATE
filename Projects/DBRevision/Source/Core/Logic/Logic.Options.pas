
{***************************************************************************************************}
{                                                                                                   }
{                                         XML Data Binding                                          }
{                                                                                                   }
{         Generated on: 07.10.2014 17:21:52                                                         }
{       Generated from: D:\Работа\SVN\branches\Matusevich\DBRevision\Source\Resources\Options.xml   }
{                                                                                                   }
{***************************************************************************************************}

unit Logic.Options;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLOptionsType = interface;
  IXMLConnectionType = interface;

{ IXMLOptionsType }

  IXMLOptionsType = interface(IXMLNode)
    ['{81C0BA37-8C02-4D91-AE6A-005AA804E39D}']
    { Property Accessors }
    function Get_Connection: IXMLConnectionType;
    { Methods & Properties }
    property Connection: IXMLConnectionType read Get_Connection;
  end;

{ IXMLConnectionType }

  IXMLConnectionType = interface(IXMLNode)
    ['{0BB9CD25-4EF9-4121-A9C4-16813182D69E}']
    { Property Accessors }
    function Get_Server: UnicodeString;
    function Get_DataBase: UnicodeString;
    procedure Set_Server(Value: UnicodeString);
    procedure Set_DataBase(Value: UnicodeString);
    { Methods & Properties }
    property Server: UnicodeString read Get_Server write Set_Server;
    property DataBase: UnicodeString read Get_DataBase write Set_DataBase;
  end;

{ Forward Decls }

  TXMLOptionsType = class;
  TXMLConnectionType = class;

{ TXMLOptionsType }

  TXMLOptionsType = class(TXMLNode, IXMLOptionsType)
  protected
    { IXMLOptionsType }
    function Get_Connection: IXMLConnectionType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLConnectionType }

  TXMLConnectionType = class(TXMLNode, IXMLConnectionType)
  protected
    { IXMLConnectionType }
    function Get_Server: UnicodeString;
    function Get_DataBase: UnicodeString;
    procedure Set_Server(Value: UnicodeString);
    procedure Set_DataBase(Value: UnicodeString);
  end;

{ Global Functions }

function GetOptions(Doc: IXMLDocument): IXMLOptionsType;
function LoadOptions(const FileName: string): IXMLOptionsType;
function NewOptions: IXMLOptionsType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetOptions(Doc: IXMLDocument): IXMLOptionsType;
begin
  Result := Doc.GetDocBinding('Options', TXMLOptionsType, TargetNamespace) as IXMLOptionsType;
end;

function LoadOptions(const FileName: string): IXMLOptionsType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Options', TXMLOptionsType, TargetNamespace) as IXMLOptionsType;
end;

function NewOptions: IXMLOptionsType;
begin
  Result := NewXMLDocument.GetDocBinding('Options', TXMLOptionsType, TargetNamespace) as IXMLOptionsType;
end;

{ TXMLOptionsType }

procedure TXMLOptionsType.AfterConstruction;
begin
  RegisterChildNode('Connection', TXMLConnectionType);
  inherited;
end;

function TXMLOptionsType.Get_Connection: IXMLConnectionType;
begin
  Result := ChildNodes['Connection'] as IXMLConnectionType;
end;

{ TXMLConnectionType }

function TXMLConnectionType.Get_Server: UnicodeString;
begin
  Result := ChildNodes['Server'].NodeValue;
end;

procedure TXMLConnectionType.Set_Server(Value: UnicodeString);
begin
  ChildNodes['Server'].NodeValue := Value;
end;

function TXMLConnectionType.Get_DataBase: UnicodeString;
begin
  Result := ChildNodes['DataBase'].NodeValue;
end;

procedure TXMLConnectionType.Set_DataBase(Value: UnicodeString);
begin
  ChildNodes['DataBase'].NodeValue := Value;
end;

end.