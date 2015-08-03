
{**************************************************************************************************************}
{                                                                                                              }
{                                               XML Data Binding                                               }
{                                                                                                              }
{         Generated on: 18.06.2015 18:45:56                                                                    }
{       Generated from: D:\Работа\SVN\branches\Matusevich\UnfoldingOfGoodsServer\Source\Resource\Options.xml   }
{                                                                                                              }
{**************************************************************************************************************}

unit Logic.Options;

interface

uses
  System.SyncObjs,
  Xml.xmldom,
  Xml.XMLDoc,
  Xml.XMLIntf;

type

{ Forward Decls }

  IXMLOptionsType = interface;
  IXMLLoggingType = interface;
  IXMLServerType = interface;
  IXMLWebServiceType = interface;

{ IXMLOptionsType }

  IXMLOptionsType = interface(IXMLNode)
    ['{5F00FBF0-3D16-48EA-804C-A4203343B968}']
    { Property Accessors }
    function Get_Logging: IXMLLoggingType;
    function Get_Server: IXMLServerType;
    { Methods & Properties }
    property Logging: IXMLLoggingType read Get_Logging;
    property Server: IXMLServerType read Get_Server;
  end;

{ IXMLLoggingType }

  IXMLLoggingType = interface(IXMLNode)
    ['{F7650F3D-1711-4630-9449-DCAAE8A4C532}']
    { Property Accessors }
    function Get_IsLog: Boolean;
    function Get_IsLogMethod: Boolean;
    function Get_ToFile: Boolean;
    function Get_ToCodeSite: Boolean;
    procedure Set_IsLog(const aValue: Boolean);
    procedure Set_IsLogMethod(const aValue: Boolean);
    procedure Set_ToFile(const aValue: Boolean);
    procedure Set_ToCodeSite(const aValue: Boolean);
    { Methods & Properties }
    property IsLog: Boolean read Get_IsLog write Set_IsLog;
    property IsLogMethod: Boolean read Get_IsLogMethod write Set_IsLogMethod;
    property ToFile: Boolean read Get_ToFile write Set_ToFile;
    property ToCodeSite: Boolean read Get_ToCodeSite write Set_ToCodeSite;
  end;

{ IXMLServerType }

  IXMLServerType = interface(IXMLNode)
    ['{9FE2656D-C7CB-496B-BA9B-47D76ECC3324}']
    { Property Accessors }
    function Get_Port: Integer;
    function Get_SessionExpired: Integer;
    function Get_WebService: IXMLWebServiceType;
    function Get_ClientVersion: string;
    procedure Set_Port(const aValue: Integer);
    procedure Set_SessionExpired(const aValue: Integer);
    procedure Set_ClientVersion(const aValue: string);
    { Methods & Properties }
    property Port: Integer read Get_Port write Set_Port;
    property SessionExpired: Integer read Get_SessionExpired write Set_SessionExpired;
    property WebService: IXMLWebServiceType read Get_WebService;
    property ClientVersion: string read Get_ClientVersion write Set_ClientVersion;
  end;

{ IXMLWebServiceType }

  IXMLWebServiceType = interface(IXMLNode)
    ['{E5DBDAA2-AA86-4537-AD72-0C3459A75B5F}']
    { Property Accessors }
    function Get_URL: string;
    function Get_ConnectTimeout: Integer;
    function Get_SendTimeout: Integer;
    function Get_ReceiveTimeout: Integer;
    procedure Set_URL(const aValue: string);
    procedure Set_ConnectTimeout(const aValue: Integer);
    procedure Set_SendTimeout(const aValue: Integer);
    procedure Set_ReceiveTimeout(const aValue: Integer);
    { Methods & Properties }
    property URL: string read Get_URL write Set_URL;
    property ConnectTimeout: Integer read Get_ConnectTimeout write Set_ConnectTimeout;
    property SendTimeout: Integer read Get_SendTimeout write Set_SendTimeout;
    property ReceiveTimeout: Integer read Get_ReceiveTimeout write Set_ReceiveTimeout;
  end;

{ Forward Decls }

  TXMLOptionsType = class;
  TXMLLoggingType = class;
  TXMLServerType = class;
  TXMLWebServiceType = class;

{ TXMLOptionsType }

  TXMLOptionsType = class(TXMLNode, IXMLOptionsType)
  protected
    { IXMLOptionsType }
    function Get_Logging: IXMLLoggingType;
    function Get_Server: IXMLServerType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLoggingType }

  TXMLLoggingType = class(TXMLNode, IXMLLoggingType)
  protected
    { IXMLLoggingType }
    function Get_IsLog: Boolean;
    function Get_IsLogMethod: Boolean;
    function Get_ToFile: Boolean;
    function Get_ToCodeSite: Boolean;
    procedure Set_IsLog(const aValue: Boolean);
    procedure Set_IsLogMethod(const aValue: Boolean);
    procedure Set_ToFile(const aValue: Boolean);
    procedure Set_ToCodeSite(const aValue: Boolean);
  end;

{ TXMLServerType }

  TXMLServerType = class(TXMLNode, IXMLServerType)
  protected
    { IXMLServerType }
    function Get_Port: Integer;
    function Get_SessionExpired: Integer;
    function Get_WebService: IXMLWebServiceType;
    function Get_ClientVersion: string;
    procedure Set_Port(const aValue: Integer);
    procedure Set_SessionExpired(const aValue: Integer);
    procedure Set_ClientVersion(const aValue: string);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWebServiceType }

  TXMLWebServiceType = class(TXMLNode, IXMLWebServiceType)
  protected
    { IXMLWebServiceType }
    function Get_URL: string;
    function Get_ConnectTimeout: Integer;
    function Get_SendTimeout: Integer;
    function Get_ReceiveTimeout: Integer;
    procedure Set_URL(const aValue: string);
    procedure Set_ConnectTimeout(const aValue: Integer);
    procedure Set_SendTimeout(const aValue: Integer);
    procedure Set_ReceiveTimeout(const aValue: Integer);
  end;

{ Global Functions }

function GetOptions(Doc: IXMLDocument): IXMLOptionsType;
function LoadOptions(const FileName: string): IXMLOptionsType;
function NewOptions: IXMLOptionsType;

const
  TargetNamespace = '';

type
  TOptions = class
  private
    class var
      FLock: TCriticalSection;
      FXMLOptionsType: IXMLOptionsType;
    class constructor Create;
    class destructor Destroy;
  public
    class procedure AssignOptions(aOptions: IXMLOptionsType);
    class function Options: IXMLOptionsType;
  end;

implementation

uses
  Winapi.ActiveX;

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
  RegisterChildNode('Logging', TXMLLoggingType);
  RegisterChildNode('Server', TXMLServerType);
  inherited;
end;

function TXMLOptionsType.Get_Logging: IXMLLoggingType;
begin
  Result := ChildNodes['Logging'] as IXMLLoggingType;
end;

function TXMLOptionsType.Get_Server: IXMLServerType;
begin
  Result := ChildNodes['Server'] as IXMLServerType;
end;

{ TXMLLoggingType }

function TXMLLoggingType.Get_IsLog: Boolean;
begin
  Result := ChildNodes['IsLog'].NodeValue;
end;

function TXMLLoggingType.Get_IsLogMethod: Boolean;
begin
  Result := ChildNodes['IsLogMethod'].NodeValue;
end;

function TXMLLoggingType.Get_ToFile: Boolean;
begin
  Result := ChildNodes['ToFile'].NodeValue;
end;

procedure TXMLLoggingType.Set_IsLog(const aValue: Boolean);
begin
  ChildNodes['IsLog'].NodeValue := aValue;
end;

procedure TXMLLoggingType.Set_IsLogMethod(const aValue: Boolean);
begin
  ChildNodes['IsLogMethod'].NodeValue := aValue;
end;

procedure TXMLLoggingType.Set_ToCodeSite(const aValue: Boolean);
begin
  ChildNodes['ToCodeSite'].NodeValue := aValue;
end;

procedure TXMLLoggingType.Set_ToFile(const aValue: Boolean);
begin
  ChildNodes['ToFile'].NodeValue := aValue;
end;

function TXMLLoggingType.Get_ToCodeSite: Boolean;
begin
  Result := ChildNodes['ToCodeSite'].NodeValue;
end;

{ TXMLServerType }

procedure TXMLServerType.AfterConstruction;
begin
  RegisterChildNode('WebService', TXMLWebServiceType);
  inherited;
end;

function TXMLServerType.Get_ClientVersion: string;
begin
  Result := ChildNodes['ClientVersion'].NodeValue;
end;

function TXMLServerType.Get_Port: Integer;
begin
  Result := ChildNodes['Port'].NodeValue;
end;

function TXMLServerType.Get_SessionExpired: Integer;
begin
  Result := ChildNodes['SessionExpired'].NodeValue;
end;

function TXMLServerType.Get_WebService: IXMLWebServiceType;
begin
  Result := ChildNodes['WebService'] as IXMLWebServiceType;
end;

procedure TXMLServerType.Set_ClientVersion(const aValue: string);
begin
  ChildNodes['ClientVersion'].NodeValue := aValue;
end;

procedure TXMLServerType.Set_Port(const aValue: Integer);
begin
  ChildNodes['Port'].NodeValue := aValue;
end;

procedure TXMLServerType.Set_SessionExpired(const aValue: Integer);
begin
  ChildNodes['SessionExpired'].NodeValue := aValue;
end;

{ TXMLWebServiceType }

function TXMLWebServiceType.Get_URL: string;
begin
  Result := ChildNodes['URL'].Text;
end;

function TXMLWebServiceType.Get_ReceiveTimeout: Integer;
begin
  Result := ChildNodes['ReceiveTimeout'].NodeValue;
end;

function TXMLWebServiceType.Get_SendTimeout: Integer;
begin
  Result := ChildNodes['SendTimeout'].NodeValue;
end;

function TXMLWebServiceType.Get_ConnectTimeout: Integer;
begin
  Result := ChildNodes['ConnectTimeout'].NodeValue;
end;

procedure TXMLWebServiceType.Set_ConnectTimeout(const aValue: Integer);
begin
  ChildNodes['ConnectTimeout'].NodeValue := aValue;
end;

procedure TXMLWebServiceType.Set_ReceiveTimeout(const aValue: Integer);
begin
  ChildNodes['ReceiveTimeout'].NodeValue := aValue;
end;

procedure TXMLWebServiceType.Set_SendTimeout(const aValue: Integer);
begin
  ChildNodes['SendTimeout'].NodeValue := aValue;
end;

procedure TXMLWebServiceType.Set_URL(const aValue: string);
begin
  ChildNodes['URL'].Text := aValue;
end;

{ TOptions }

class procedure TOptions.AssignOptions(aOptions: IXMLOptionsType);
begin
  FLock.Enter();
  try
    FXMLOptionsType.Logging.IsLog := aOptions.Logging.IsLog;
    FXMLOptionsType.Logging.IsLogMethod := aOptions.Logging.IsLogMethod;
    FXMLOptionsType.Logging.ToFile := aOptions.Logging.ToFile;
    FXMLOptionsType.Logging.ToCodeSite := aOptions.Logging.ToCodeSite;
    FXMLOptionsType.Server.Port := aOptions.Server.Port;
    FXMLOptionsType.Server.SessionExpired := aOptions.Server.SessionExpired;
    FXMLOptionsType.Server.WebService.URL := aOptions.Server.WebService.URL;
    FXMLOptionsType.Server.WebService.ConnectTimeout := aOptions.Server.WebService.ConnectTimeout;
    FXMLOptionsType.Server.WebService.SendTimeout := aOptions.Server.WebService.SendTimeout;
    FXMLOptionsType.Server.WebService.ReceiveTimeout := aOptions.Server.WebService.ReceiveTimeout;
    FXMLOptionsType.Server.ClientVersion := aOptions.Server.ClientVersion;
  finally
    FLock.Leave();
  end;
end;

class constructor TOptions.Create;
begin
  FLock := TCriticalSection.Create();
  CoInitialize(nil);
  FXMLOptionsType := NewOptions();
end;

class destructor TOptions.Destroy;
begin
  FXMLOptionsType := nil;
  CoUninitialize();
  FLock.Free();
end;

class function TOptions.Options: IXMLOptionsType;
begin
  FLock.Enter();
  try
    Result := FXMLOptionsType;
  finally
    FLock.Leave();
  end;
end;

end.