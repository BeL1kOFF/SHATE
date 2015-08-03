
{********************************************************************************************}
{                                                                                            }
{                                      XML Data Binding                                      }
{                                                                                            }
{         Generated on: 20.08.2014 14:10:08                                                  }
{       Generated from: D:\Работа\Delphi\FileTransferService\Plugins\ADOCSVAdapter\TMS.xsd   }
{   Settings stored in: D:\Работа\Delphi\FileTransferService\Plugins\ADOCSVAdapter\TMS.xdb   }
{                                                                                            }
{********************************************************************************************}

unit ADOCSVAdapter.Logic.XMLOptions;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLXml = interface;
  IXMLXml_options = interface;
  IXMLXml_account = interface;
  IXMLXml_accountList = interface;

{ IXMLXml }

  IXMLXml = interface(IXMLNode)
    ['{79C27E5D-DC47-4E0F-8C86-D77C0C1D7502}']
    { Property Accessors }
    function Get_Options: IXMLXml_options;
    function Get_Account: IXMLXml_accountList;
    { Methods & Properties }
    property Options: IXMLXml_options read Get_Options;
    property Account: IXMLXml_accountList read Get_Account;
  end;

{ IXMLXml_options }

  IXMLXml_options = interface(IXMLNode)
    ['{C0D81738-9F6B-47B7-84F6-5C69F3A21300}']
    { Property Accessors }
    function Get_Server: UnicodeString;
    function Get_Db: UnicodeString;
    function Get_Lifetime: Byte;
    procedure Set_Server(Value: UnicodeString);
    procedure Set_Db(Value: UnicodeString);
    procedure Set_Lifetime(Value: Byte);
    { Methods & Properties }
    property Server: UnicodeString read Get_Server write Set_Server;
    property Db: UnicodeString read Get_Db write Set_Db;
    property Lifetime: Byte read Get_Lifetime write Set_Lifetime;
  end;

{ IXMLXml_account }

  IXMLXml_account = interface(IXMLNode)
    ['{88ADD2F5-F800-4A82-89D5-D7C11197502E}']
    { Property Accessors }
    function Get_Code: UnicodeString;
    function Get_Login: UnicodeString;
    function Get_Password: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
    procedure Set_Login(Value: UnicodeString);
    procedure Set_Password(Value: UnicodeString);
    { Methods & Properties }
    property Code: UnicodeString read Get_Code write Set_Code;
    property Login: UnicodeString read Get_Login write Set_Login;
    property Password: UnicodeString read Get_Password write Set_Password;
  end;

{ IXMLXml_accountList }

  IXMLXml_accountList = interface(IXMLNodeCollection)
    ['{CF50208E-9052-40B5-8B97-5E554113D3B4}']
    { Methods & Properties }
    function Add: IXMLXml_account;
    function Insert(const Index: Integer): IXMLXml_account;

    function Get_Item(Index: Integer): IXMLXml_account;
    property Items[Index: Integer]: IXMLXml_account read Get_Item; default;
  end;

{ Forward Decls }

  TXMLXml = class;
  TXMLXml_options = class;
  TXMLXml_account = class;
  TXMLXml_accountList = class;

{ TXMLXml }

  TXMLXml = class(TXMLNode, IXMLXml)
  private
    FAccount: IXMLXml_accountList;
  protected
    { IXMLXml }
    function Get_Options: IXMLXml_options;
    function Get_Account: IXMLXml_accountList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLXml_options }

  TXMLXml_options = class(TXMLNode, IXMLXml_options)
  protected
    { IXMLXml_options }
    function Get_Server: UnicodeString;
    function Get_Db: UnicodeString;
    function Get_Lifetime: Byte;
    procedure Set_Server(Value: UnicodeString);
    procedure Set_Db(Value: UnicodeString);
    procedure Set_Lifetime(Value: Byte);
  end;

{ TXMLXml_account }

  TXMLXml_account = class(TXMLNode, IXMLXml_account)
  protected
    { IXMLXml_account }
    function Get_Code: UnicodeString;
    function Get_Login: UnicodeString;
    function Get_Password: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
    procedure Set_Login(Value: UnicodeString);
    procedure Set_Password(Value: UnicodeString);
  end;

{ TXMLXml_accountList }

  TXMLXml_accountList = class(TXMLNodeCollection, IXMLXml_accountList)
  protected
    { IXMLXml_accountList }
    function Add: IXMLXml_account;
    function Insert(const Index: Integer): IXMLXml_account;

    function Get_Item(Index: Integer): IXMLXml_account;
  end;

{ Global Functions }

function Getxml(Doc: IXMLDocument): IXMLXml;
function Loadxml(const FileName: string): IXMLXml;
function Newxml: IXMLXml;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function Getxml(Doc: IXMLDocument): IXMLXml;
begin
  Result := Doc.GetDocBinding('xml', TXMLXml, TargetNamespace) as IXMLXml;
end;

function Loadxml(const FileName: string): IXMLXml;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('xml', TXMLXml, TargetNamespace) as IXMLXml;
end;

function Newxml: IXMLXml;
begin
  Result := NewXMLDocument.GetDocBinding('xml', TXMLXml, TargetNamespace) as IXMLXml;
end;

{ TXMLXml }

procedure TXMLXml.AfterConstruction;
begin
  RegisterChildNode('options', TXMLXml_options);
  RegisterChildNode('account', TXMLXml_account);
  FAccount := CreateCollection(TXMLXml_accountList, IXMLXml_account, 'account') as IXMLXml_accountList;
  inherited;
end;

function TXMLXml.Get_Options: IXMLXml_options;
begin
  Result := ChildNodes['options'] as IXMLXml_options;
end;

function TXMLXml.Get_Account: IXMLXml_accountList;
begin
  Result := FAccount;
end;

{ TXMLXml_options }

function TXMLXml_options.Get_Server: UnicodeString;
begin
  Result := ChildNodes['server'].Text;
end;

procedure TXMLXml_options.Set_Server(Value: UnicodeString);
begin
  ChildNodes['server'].NodeValue := Value;
end;

function TXMLXml_options.Get_Db: UnicodeString;
begin
  Result := ChildNodes['db'].Text;
end;

procedure TXMLXml_options.Set_Db(Value: UnicodeString);
begin
  ChildNodes['db'].NodeValue := Value;
end;

function TXMLXml_options.Get_Lifetime: Byte;
begin
  Result := ChildNodes['lifetime'].NodeValue;
end;

procedure TXMLXml_options.Set_Lifetime(Value: Byte);
begin
  ChildNodes['lifetime'].NodeValue := Value;
end;

{ TXMLXml_account }

function TXMLXml_account.Get_Code: UnicodeString;
begin
  Result := ChildNodes['code'].Text;
end;

procedure TXMLXml_account.Set_Code(Value: UnicodeString);
begin
  ChildNodes['code'].NodeValue := Value;
end;

function TXMLXml_account.Get_Login: UnicodeString;
begin
  Result := ChildNodes['login'].Text;
end;

procedure TXMLXml_account.Set_Login(Value: UnicodeString);
begin
  ChildNodes['login'].NodeValue := Value;
end;

function TXMLXml_account.Get_Password: UnicodeString;
begin
  Result := ChildNodes['password'].Text;
end;

procedure TXMLXml_account.Set_Password(Value: UnicodeString);
begin
  ChildNodes['password'].NodeValue := Value;
end;

{ TXMLXml_accountList }

function TXMLXml_accountList.Add: IXMLXml_account;
begin
  Result := AddItem(-1) as IXMLXml_account;
end;

function TXMLXml_accountList.Insert(const Index: Integer): IXMLXml_account;
begin
  Result := AddItem(Index) as IXMLXml_account;
end;

function TXMLXml_accountList.Get_Item(Index: Integer): IXMLXml_account;
begin
  Result := List[Index] as IXMLXml_account;
end;

end.