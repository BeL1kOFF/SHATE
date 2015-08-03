
{***********************************************************************************************************}
{                                                                                                           }
{                                             XML Data Binding                                              }
{                                                                                                           }
{         Generated on: 23.01.2015 10:29:52                                                                 }
{       Generated from: D:\Работа\SVN\branches\Matusevich\ERP Core\ServiceManager\Resource\ERPManager.xml   }
{                                                                                                           }
{***********************************************************************************************************}

unit ServiceManager.Logic.Options;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLOptionsType = interface;
  IXMLSocketType = interface;

{ IXMLOptionsType }

  IXMLOptionsType = interface(IXMLNode)
    ['{100A3789-2B8D-4C05-BD1F-F56E39531442}']
    { Property Accessors }
    function Get_Socket: IXMLSocketType;
    { Methods & Properties }
    property Socket: IXMLSocketType read Get_Socket;
  end;

{ IXMLSocketType }

  IXMLSocketType = interface(IXMLNode)
    ['{8A9E3F3E-54E3-4649-8C89-89B1D26DE92A}']
    { Property Accessors }
    function Get_Server: string;
    function Get_Port: Integer;
    { Methods & Properties }
    property Server: string read Get_Server;
    property Port: Integer read Get_Port;
  end;

{ Forward Decls }

  TXMLOptionsType = class;
  TXMLSocketType = class;

{ TXMLOptionsType }

  TXMLOptionsType = class(TXMLNode, IXMLOptionsType)
  protected
    { IXMLOptionsType }
    function Get_Socket: IXMLSocketType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSocketType }

  TXMLSocketType = class(TXMLNode, IXMLSocketType)
  protected
    { IXMLSocketType }
    function Get_Server: string;
    function Get_Port: Integer;
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
  RegisterChildNode('Socket', TXMLSocketType);
  inherited;
end;

function TXMLOptionsType.Get_Socket: IXMLSocketType;
begin
  Result := ChildNodes['Socket'] as IXMLSocketType;
end;

{ TXMLSocketType }

function TXMLSocketType.Get_Server: string;
begin
  Result := ChildNodes['Server'].Text;
end;

function TXMLSocketType.Get_Port: Integer;
begin
  Result := ChildNodes['Port'].NodeValue;
end;

end.