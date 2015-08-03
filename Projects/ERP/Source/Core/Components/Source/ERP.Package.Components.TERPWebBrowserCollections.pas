unit ERP.Package.Components.TERPWebBrowserCollections;

interface

uses
  Winapi.ActiveX,
  Winapi.UrlMon,
  System.Classes,
  System.SysUtils;

const
  GUID_MDMIMAGEPROTOCOL: TGUID = '{C379EAD1-CB34-4B09-AF6B-7E587F8BCD80}';

type
  TERPWebBrowserAPP = class(TCollectionItem)
  strict private
    FEnabled: Boolean;
    FFactory: IClassFactory;
    FInternetSession: IInternetSession;
    FNameProtocol: string;
    procedure SetEnabled(const aValue: Boolean);
    procedure SetNameProtocol(const aValue: string);
    procedure StartAPProtocol;
    procedure StopAPProtocol;
  public
    constructor Create(aCollection: TCollection); override;
    destructor Destroy; override;
    property Enabled: Boolean read FEnabled write SetEnabled;
  published
    property NameProtocol: string read FNameProtocol write SetNameProtocol;
  end;

  TItemChangeEvent = procedure(aItem: TCollectionItem) of object;

  TERPWebBrowserAPPCollection = class(TOwnedCollection)
  private
    FOnItemChange: TItemChangeEvent;
    function GetItem(aIndex: Integer): TERPWebBrowserAPP;
    procedure SetItem(aIndex: Integer; const aValue: TERPWebBrowserAPP);
  protected
    procedure DoItemChange(aItem: TCollectionItem); dynamic;
    procedure Update(aItem: TCollectionItem); override;
  public
    constructor Create(aOwner: TPersistent); virtual;
    function Add: TERPWebBrowserAPP;
    property Items[aIndex: Integer]: TERPWebBrowserAPP read GetItem write SetItem; default;
  published
    property OnItemChange: TItemChangeEvent read FOnItemChange write FOnItemChange;
  end;

  EERPWebBrowserAPP = class(Exception);

  TERPWebBrowserTemplate = class;
  TERPWebBrowserTemplateCollection = class;

  TWebBrowserTemplateCollectionEnumerator = class
  private
    FIndex: Integer;
    FCollection: TERPWebBrowserTemplateCollection;
  public
    constructor Create(aCollection: TERPWebBrowserTemplateCollection);
    function GetCurrent: TERPWebBrowserTemplate; inline;
    function MoveNext: Boolean;
    property Current: TERPWebBrowserTemplate read GetCurrent;
  end;

  TERPWebBrowserTemplate = class(TCollectionItem)
  strict private
    FTemplateFile: TFileName;
    FTemplateName: string;
    procedure SetTemplateFile(const aValue: TFileName);
    procedure SetTemplateName(const aValue: string);
  public
    constructor Create(aCollection: TCollection); override;
    destructor Destroy; override;
  published
    property TemplateFile: TFileName read FTemplateFile write SetTemplateFile;
    property TemplateName: string read FTemplateName write SetTemplateName;
  end;

  TERPWebBrowserTemplateCollection = class(TOwnedCollection)
  private
    FActiveIndex: Integer;
    function GetItem(aIndex: Integer): TERPWebBrowserTemplate;
    procedure SetItem(aIndex: Integer; const aValue: TERPWebBrowserTemplate);
    procedure SetActiveIndex(const aValue: Integer);
  public
    constructor Create(aOwner: TPersistent); virtual;
    function Add: TERPWebBrowserTemplate;
    function GetEnumerator: TWebBrowserTemplateCollectionEnumerator;
    property Items[aIndex: Integer]: TERPWebBrowserTemplate read GetItem write SetItem; default;
  published
    property ActiveIndex: Integer read FActiveIndex write SetActiveIndex default -1;
  end;

  EERPWebBrowserTemplate = class(Exception);

implementation

uses
  ERP.Package.Components.TERPWebBrowser;

{ TERPWebBrowserAPP }

constructor TERPWebBrowserAPP.Create(aCollection: TCollection);
begin
  inherited Create(aCollection);
  FEnabled := False;
  FNameProtocol := 'Default';
end;

destructor TERPWebBrowserAPP.Destroy;
begin
  Enabled := False;
  inherited Destroy;
end;

procedure TERPWebBrowserAPP.SetEnabled(const aValue: Boolean);
begin
  if FEnabled <> aValue then
  begin
    FEnabled := aValue;
    if FEnabled then
      StartAPProtocol
    else
      StopAPProtocol;
  end;
end;

procedure TERPWebBrowserAPP.SetNameProtocol(const aValue: string);
begin
  if FNameProtocol <> aValue then
  begin
    FNameProtocol := aValue;
    Changed(False);
  end;
end;

procedure TERPWebBrowserAPP.StartAPProtocol;
var
  HR: HResult;
begin
  HR := CoGetClassObject(GUID_MDMIMAGEPROTOCOL, CLSCTX_SERVER, nil, IClassFactory, FFactory);
  if Succeeded(HR) then
  begin
    CoInternetGetSession(0, FInternetSession, 0);
    FInternetSession.RegisterNameSpace(FFactory, GUID_MDMIMAGEPROTOCOL, PWideChar(FNameProtocol), 0, nil, 0);
  end
  else
  begin
    FEnabled := False;
    raise EERPWebBrowserAPP.Create('Asynchronous Pluggable Protocols не поддерживается');
  end;
end;

procedure TERPWebBrowserAPP.StopAPProtocol;
begin
  FInternetSession.UnregisterNameSpace(FFactory, PWideChar(FNameProtocol));
end;

{ TERPWebBrowserAPPCollection }

function TERPWebBrowserAPPCollection.Add: TERPWebBrowserAPP;
begin
  Result := TERPWebBrowserAPP(inherited Add);
end;

constructor TERPWebBrowserAPPCollection.Create(aOwner: TPersistent);
begin
  inherited Create(aOwner, TERPWebBrowserAPP);
end;

procedure TERPWebBrowserAPPCollection.DoItemChange(aItem: TCollectionItem);
begin
  if Assigned(FOnItemChange) then
    FOnItemChange(aItem);
end;

function TERPWebBrowserAPPCollection.GetItem(aIndex: Integer): TERPWebBrowserAPP;
begin
  Result := TERPWebBrowserAPP(inherited GetItem(aIndex));
end;

procedure TERPWebBrowserAPPCollection.SetItem(aIndex: Integer; const aValue: TERPWebBrowserAPP);
begin
  inherited SetItem(aIndex, aValue);
end;

procedure TERPWebBrowserAPPCollection.Update(aItem: TCollectionItem);
begin
  inherited Update(aItem);
  DoItemChange(aItem);
end;

{ TERPWebBrowserTemplateCollection }

function TERPWebBrowserTemplateCollection.Add: TERPWebBrowserTemplate;
begin
  Result := TERPWebBrowserTemplate(inherited Add());
end;

constructor TERPWebBrowserTemplateCollection.Create(aOwner: TPersistent);
begin
  inherited Create(aOwner, TERPWebBrowserTemplate);
  FActiveIndex := -1;
end;

function TERPWebBrowserTemplateCollection.GetEnumerator: TWebBrowserTemplateCollectionEnumerator;
begin
  Result := TWebBrowserTemplateCollectionEnumerator.Create(Self);
end;

function TERPWebBrowserTemplateCollection.GetItem(aIndex: Integer): TERPWebBrowserTemplate;
begin
  Result := TERPWebBrowserTemplate(inherited GetItem(aIndex));
end;

procedure TERPWebBrowserTemplateCollection.SetActiveIndex(const aValue: Integer);
begin
  if not (csLoading in TComponent(Owner).ComponentState) then
    if (aValue >= Count) or (aValue < -1) then
      raise EERPWebBrowserTemplate.Create('Index out of Count');
  FActiveIndex := aValue;
end;

procedure TERPWebBrowserTemplateCollection.SetItem(aIndex: Integer; const aValue: TERPWebBrowserTemplate);
begin
  inherited SetItem(aIndex, aValue);
end;

{ TERPWebBrowserTemplate }

constructor TERPWebBrowserTemplate.Create(aCollection: TCollection);
begin
  inherited Create(aCollection);
  FTemplateName := '';
end;

destructor TERPWebBrowserTemplate.Destroy;
begin
  inherited Destroy();
end;

procedure TERPWebBrowserTemplate.SetTemplateFile(const aValue: TFileName);
begin
  FTemplateFile := aValue;
end;

procedure TERPWebBrowserTemplate.SetTemplateName(const aValue: string);
begin
  if FTemplateName <> aValue then
  begin
    FTemplateName := aValue;
    Changed(False);
  end;
end;

{ TWebBrowserTemplateCollectionEnumerator }

constructor TWebBrowserTemplateCollectionEnumerator.Create(aCollection: TERPWebBrowserTemplateCollection);
begin
  inherited Create();
  FIndex := -1;
  FCollection := aCollection;
end;

function TWebBrowserTemplateCollectionEnumerator.GetCurrent: TERPWebBrowserTemplate;
begin
  Result := FCollection.Items[FIndex];
end;

function TWebBrowserTemplateCollectionEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FCollection.Count - 1;
  if Result then
    Inc(FIndex);
end;

end.
