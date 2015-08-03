
{************************************************************************************}
{                                                                                    }
{                                  XML Data Binding                                  }
{                                                                                    }
{         Generated on: 02.07.2014 19:11:50                                          }
{       Generated from: D:\Работа\Delphi\ERP\Source\Core\Classes\Resources\ERP.xml   }
{   Settings stored in: D:\Работа\Delphi\ERP\Source\Core\Classes\Resources\ERP.xdb   }
{                                                                                    }
{************************************************************************************}

unit ERP.Package.ClientClasses.ERPOptions;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLOptionsType = interface;
  IXMLSocketType = interface;
  IXMLPackagesType = interface;

{ IXMLOptionsType }

  IXMLOptionsType = interface(IXMLNode)
    ['{9405D589-0C96-4371-8332-06FECC173283}']
    { Property Accessors }
    function Get_Socket: IXMLSocketType;
    function Get_Packages: IXMLPackagesType;
    { Methods & Properties }
    property Socket: IXMLSocketType read Get_Socket;
    property Packages: IXMLPackagesType read Get_Packages;
  end;

{ IXMLSocketType }

  IXMLSocketType = interface(IXMLNode)
    ['{9CC44CFD-F0CC-402E-99DD-6F11D65DBC46}']
    { Property Accessors }
    function Get_Server: UnicodeString;
    function Get_Port: Integer;
    procedure Set_Server(Value: UnicodeString);
    procedure Set_Port(Value: Integer);
    { Methods & Properties }
    property Server: UnicodeString read Get_Server write Set_Server;
    property Port: Integer read Get_Port write Set_Port;
  end;

{ IXMLPackagesType }

  IXMLPackagesType = interface(IXMLNodeCollection)
    ['{FD222188-6BEF-45F1-8BA0-128E61715E55}']
    { Property Accessors }
    function Get_Path(Index: Integer): UnicodeString;
    { Methods & Properties }
    function Add(const Path: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Path: UnicodeString): IXMLNode;
    property Path[Index: Integer]: UnicodeString read Get_Path; default;
  end;

{ Forward Decls }

  TXMLOptionsType = class;
  TXMLSocketType = class;
  TXMLPackagesType = class;

{ TXMLOptionsType }

  TXMLOptionsType = class(TXMLNode, IXMLOptionsType)
  protected
    { IXMLOptionsType }
    function Get_Socket: IXMLSocketType;
    function Get_Packages: IXMLPackagesType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSocketType }

  TXMLSocketType = class(TXMLNode, IXMLSocketType)
  protected
    { IXMLSocketType }
    function Get_Server: UnicodeString;
    function Get_Port: Integer;
    procedure Set_Server(Value: UnicodeString);
    procedure Set_Port(Value: Integer);
  end;

{ TXMLPackagesType }

  TXMLPackagesType = class(TXMLNodeCollection, IXMLPackagesType)
  protected
    { IXMLPackagesType }
    function Get_Path(Index: Integer): UnicodeString;
    function Add(const Path: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Path: UnicodeString): IXMLNode;
  public
    procedure AfterConstruction; override;
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
  RegisterChildNode('Packages', TXMLPackagesType);
  inherited;
end;

function TXMLOptionsType.Get_Socket: IXMLSocketType;
begin
  Result := ChildNodes['Socket'] as IXMLSocketType;
end;

function TXMLOptionsType.Get_Packages: IXMLPackagesType;
begin
  Result := ChildNodes['Packages'] as IXMLPackagesType;
end;

{ TXMLSocketType }

function TXMLSocketType.Get_Server: UnicodeString;
begin
  Result := ChildNodes['Server'].Text;
end;

procedure TXMLSocketType.Set_Server(Value: UnicodeString);
begin
  ChildNodes['Server'].NodeValue := Value;
end;

function TXMLSocketType.Get_Port: Integer;
begin
  Result := ChildNodes['Port'].NodeValue;
end;

procedure TXMLSocketType.Set_Port(Value: Integer);
begin
  ChildNodes['Port'].NodeValue := Value;
end;

{ TXMLPackagesType }

procedure TXMLPackagesType.AfterConstruction;
begin
  ItemTag := 'Path';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLPackagesType.Get_Path(Index: Integer): UnicodeString;
begin
  Result := List[Index].Text;
end;

function TXMLPackagesType.Add(const Path: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Path;
end;

function TXMLPackagesType.Insert(const Index: Integer; const Path: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Path;
end;

end.
