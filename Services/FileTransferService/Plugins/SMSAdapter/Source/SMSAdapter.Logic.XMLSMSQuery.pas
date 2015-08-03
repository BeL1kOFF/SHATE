
{**********************************************************************************************************}
{                                                                                                          }
{                                             XML Data Binding                                             }
{                                                                                                          }
{         Generated on: 27.02.2015 18:09:24                                                                }
{       Generated from: D:\Работа\SVN\trunk\Services\FileTransferService\Plugins\SMSAdapter\SMSQuery.xml   }
{                                                                                                          }
{**********************************************************************************************************}

unit SMSAdapter.Logic.XMLSMSQuery;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDocumentType = interface;

{ IXMLDocumentType }

  IXMLDocumentType = interface(IXMLNode)
    ['{565C8528-BE0C-4E8C-BADB-42088458CAE4}']
    { Property Accessors }
    function Get_Type_: string;
    function Get_PhoneNumber: string;
    function Get_SmsText: string;
    procedure Set_Type_(Value: string);
    procedure Set_PhoneNumber(Value: string);
    procedure Set_SmsText(Value: string);
    { Methods & Properties }
    property Type_: string read Get_Type_ write Set_Type_;
    property PhoneNumber: string read Get_PhoneNumber write Set_PhoneNumber;
    property SmsText: string read Get_SmsText write Set_SmsText;
  end;

{ Forward Decls }

  TXMLDocumentType = class;

{ TXMLDocumentType }

  TXMLDocumentType = class(TXMLNode, IXMLDocumentType)
  protected
    { IXMLDocumentType }
    function Get_Type_: string;
    function Get_PhoneNumber: string;
    function Get_SmsText: string;
    procedure Set_Type_(Value: string);
    procedure Set_PhoneNumber(Value: string);
    procedure Set_SmsText(Value: string);
  end;

{ Global Functions }

function GetDocument(Doc: IXMLDocument): IXMLDocumentType;
function LoadDocument(const FileName: string): IXMLDocumentType;
function NewDocument: IXMLDocumentType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDocument(Doc: IXMLDocument): IXMLDocumentType;
begin
  Result := Doc.GetDocBinding('Document', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

function LoadDocument(const FileName: string): IXMLDocumentType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Document', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

function NewDocument: IXMLDocumentType;
begin
  Result := NewXMLDocument.GetDocBinding('Document', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

{ TXMLDocumentType }

function TXMLDocumentType.Get_Type_: string;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLDocumentType.Set_Type_(Value: string);
begin
  SetAttribute('Type', Value);
end;

function TXMLDocumentType.Get_PhoneNumber: string;
begin
  Result := ChildNodes['PhoneNumber'].Text;
end;

procedure TXMLDocumentType.Set_PhoneNumber(Value: string);
begin
  ChildNodes['PhoneNumber'].NodeValue := Value;
end;

function TXMLDocumentType.Get_SmsText: string;
begin
  Result := ChildNodes['SmsText'].Text;
end;

procedure TXMLDocumentType.Set_SmsText(Value: string);
begin
  ChildNodes['SmsText'].NodeValue := Value;
end;

end.