unit ERP.Package.Components.TERPWebBrowserOptions;

interface

uses
  System.Classes,
  SHDocVw,
  ERP.Package.Components.TERPWebBrowserCollections;

type
  TERPWebBrowserOptions = class(TPersistent)
  private
    FWebBrowser: TWebBrowser;
    FAPPList: TERPWebBrowserAPPCollection;
    FTemplateList: TERPWebBrowserTemplateCollection;
    procedure SetAPPList(aValue: TERPWebBrowserAPPCollection);
    procedure SetTemplateList(aValue: TERPWebBrowserTemplateCollection);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(aWebBrowser: TWebBrowser);
    destructor Destroy; override;
    procedure AppStart;
    procedure AppStop;
  published
    property APProtocolList: TERPWebBrowserAPPCollection read FAPPList write SetAPPList;
    property TemplateList: TERPWebBrowserTemplateCollection read FTemplateList write SetTemplateList;
  end;

implementation

{ TERPWebBrowserOptions }

procedure TERPWebBrowserOptions.AppStart;
var
  k: Integer;
begin
  for k := 0 to FAPPList.Count - 1 do
    FAPPList.Items[k].Enabled := True;
end;

procedure TERPWebBrowserOptions.AppStop;
var
  k: Integer;
begin
  for k := 0 to FAPPList.Count - 1 do
    FAPPList.Items[k].Enabled := False;
end;

constructor TERPWebBrowserOptions.Create(aWebBrowser: TWebBrowser);
begin
  FWebBrowser := aWebBrowser;
  FAPPList := TERPWebBrowserAPPCollection.Create(FWebBrowser);
  FTemplateList := TERPWebBrowserTemplateCollection.Create(FWebBrowser);
end;

destructor TERPWebBrowserOptions.Destroy;
begin
  FTemplateList.Free();
  FAPPList.Free;
  inherited Destroy();
end;

function TERPWebBrowserOptions.GetOwner: TPersistent;
begin
  Result := FWebBrowser;
end;

procedure TERPWebBrowserOptions.SetAPPList(aValue: TERPWebBrowserAPPCollection);
begin
  FAPPList.Assign(aValue);
end;

procedure TERPWebBrowserOptions.SetTemplateList(aValue: TERPWebBrowserTemplateCollection);
begin
  FTemplateList.Assign(aValue);
end;

end.
