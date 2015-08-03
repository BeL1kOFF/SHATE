
{************************************************************************************}
{                                                                                    }
{                                  XML Data Binding                                  }
{                                                                                    }
{         Generated on: 04.09.2014 11:24:34                                          }
{       Generated from: D:\Работа\Delphi\AnalogCodeC&C\Source\Resource\Options.xml   }
{   Settings stored in: D:\Работа\Delphi\AnalogCodeC&C\Source\Resource\Options.xdb   }
{                                                                                    }
{************************************************************************************}

unit AnalogCodeCC.Logic.OptionsXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLAnalogCodeType = interface;
  IXMLConnectionType = interface;

{ IXMLAnalogCodeType }

  IXMLAnalogCodeType = interface(IXMLNode)
    ['{BF4D81E6-4478-41E3-8170-0E8A2F12CFD2}']
    { Property Accessors }
    function Get_Connection: IXMLConnectionType;
    { Methods & Properties }
    property Connection: IXMLConnectionType read Get_Connection;
  end;

{ IXMLConnectionType }

  IXMLConnectionType = interface(IXMLNode)
    ['{A4FEB909-3585-4469-9A23-5248D4977F39}']
    { Property Accessors }
    function Get_Server: UnicodeString;
    function Get_DataBase: UnicodeString;
    function Get_Company: UnicodeString;
    procedure Set_Server(Value: UnicodeString);
    procedure Set_DataBase(Value: UnicodeString);
    procedure Set_Company(Value: UnicodeString);
    { Methods & Properties }
    property Server: UnicodeString read Get_Server write Set_Server;
    property DataBase: UnicodeString read Get_DataBase write Set_DataBase;
    property Company: UnicodeString read Get_Company write Set_Company;
  end;

{ Forward Decls }

  TXMLAnalogCodeType = class;
  TXMLConnectionType = class;

{ TXMLAnalogCodeType }

  TXMLAnalogCodeType = class(TXMLNode, IXMLAnalogCodeType)
  protected
    { IXMLAnalogCodeType }
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
    function Get_Company: UnicodeString;
    procedure Set_Server(Value: UnicodeString);
    procedure Set_DataBase(Value: UnicodeString);
    procedure Set_Company(Value: UnicodeString);
  end;

{ Global Functions }

function GetAnalogCode(Doc: IXMLDocument): IXMLAnalogCodeType;
function LoadAnalogCode(const FileName: string): IXMLAnalogCodeType;
function NewAnalogCode: IXMLAnalogCodeType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetAnalogCode(Doc: IXMLDocument): IXMLAnalogCodeType;
begin
  Result := Doc.GetDocBinding('AnalogCode', TXMLAnalogCodeType, TargetNamespace) as IXMLAnalogCodeType;
end;

function LoadAnalogCode(const FileName: string): IXMLAnalogCodeType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('AnalogCode', TXMLAnalogCodeType, TargetNamespace) as IXMLAnalogCodeType;
end;

function NewAnalogCode: IXMLAnalogCodeType;
begin
  Result := NewXMLDocument.GetDocBinding('AnalogCode', TXMLAnalogCodeType, TargetNamespace) as IXMLAnalogCodeType;
end;

{ TXMLAnalogCodeType }

procedure TXMLAnalogCodeType.AfterConstruction;
begin
  RegisterChildNode('Connection', TXMLConnectionType);
  inherited;
end;

function TXMLAnalogCodeType.Get_Connection: IXMLConnectionType;
begin
  Result := ChildNodes['Connection'] as IXMLConnectionType;
end;

{ TXMLConnectionType }

function TXMLConnectionType.Get_Server: UnicodeString;
begin
  Result := ChildNodes['Server'].Text;
end;

procedure TXMLConnectionType.Set_Server(Value: UnicodeString);
begin
  ChildNodes['Server'].NodeValue := Value;
end;

function TXMLConnectionType.Get_DataBase: UnicodeString;
begin
  Result := ChildNodes['DataBase'].Text;
end;

procedure TXMLConnectionType.Set_DataBase(Value: UnicodeString);
begin
  ChildNodes['DataBase'].NodeValue := Value;
end;

function TXMLConnectionType.Get_Company: UnicodeString;
begin
  Result := ChildNodes['Company'].Text;
end;

procedure TXMLConnectionType.Set_Company(Value: UnicodeString);
begin
  ChildNodes['Company'].NodeValue := Value;
end;

end.