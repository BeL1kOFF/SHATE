
{*****************************************************************************************************}
{                                                                                                     }
{                                          XML Data Binding                                           }
{                                                                                                     }
{         Generated on: 23.01.2015 9:54:25                                                            }
{       Generated from: D:\Работа\SVN\branches\Matusevich\ERP Core\ERPService\Resources\ERPAuth.xml   }
{                                                                                                     }
{*****************************************************************************************************}

unit ERP.Package.ServerClasses.ERPAuthOptions;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLOptionsType = interface;
  IXMLConnectionType = interface;
  IXMLSocketType = interface;

{ IXMLOptionsType }

  IXMLOptionsType = interface(IXMLNode)
    ['{375F2B94-AF43-4389-AE99-50EC997BE379}']
    { Property Accessors }
    function Get_Connection: IXMLConnectionType;
    function Get_Socket: IXMLSocketType;
    { Methods & Properties }
    property Connection: IXMLConnectionType read Get_Connection;
    property Socket: IXMLSocketType read Get_Socket;
  end;

{ IXMLConnectionType }

  IXMLConnectionType = interface(IXMLNode)
    ['{5C22C0C2-7B7C-429D-9A2B-5B9D163AE316}']
    { Property Accessors }
    function Get_Server: string;
    function Get_DataBase: string;
    { Methods & Properties }
    property Server: string read Get_Server;
    property DataBase: string read Get_DataBase;
  end;

{ IXMLSocketType }

  IXMLSocketType = interface(IXMLNode)
    ['{12FE833D-7565-4CC6-8601-5F4087C1FCBF}']
    { Property Accessors }
    function Get_PortClient: Integer;
    function Get_PortManager: Integer;
    { Methods & Properties }
    property PortClient: Integer read Get_PortClient;
    property PortManager: Integer read Get_PortManager;
  end;

{ Forward Decls }

  TXMLOptionsType = class;
  TXMLConnectionType = class;
  TXMLSocketType = class;

{ TXMLOptionsType }

  TXMLOptionsType = class(TXMLNode, IXMLOptionsType)
  protected
    { IXMLOptionsType }
    function Get_Connection: IXMLConnectionType;
    function Get_Socket: IXMLSocketType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLConnectionType }

  TXMLConnectionType = class(TXMLNode, IXMLConnectionType)
  protected
    { IXMLConnectionType }
    function Get_Server: string;
    function Get_DataBase: string;
  end;

{ TXMLSocketType }

  TXMLSocketType = class(TXMLNode, IXMLSocketType)
  protected
    { IXMLSocketType }
    function Get_PortClient: Integer;
    function Get_PortManager: Integer;
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
  RegisterChildNode('Socket', TXMLSocketType);
  inherited;
end;

function TXMLOptionsType.Get_Connection: IXMLConnectionType;
begin
  Result := ChildNodes['Connection'] as IXMLConnectionType;
end;

function TXMLOptionsType.Get_Socket: IXMLSocketType;
begin
  Result := ChildNodes['Socket'] as IXMLSocketType;
end;

{ TXMLConnectionType }

function TXMLConnectionType.Get_Server: string;
begin
  Result := ChildNodes['Server'].Text;
end;

function TXMLConnectionType.Get_DataBase: string;
begin
  Result := ChildNodes['DataBase'].Text;
end;

{ TXMLSocketType }

function TXMLSocketType.Get_PortClient: Integer;
begin
  Result := ChildNodes['PortClient'].NodeValue;
end;

function TXMLSocketType.Get_PortManager: Integer;
begin
  Result := ChildNodes['PortManager'].NodeValue;
end;

end.