unit MDM.Package.Components.CustomCatalogTableViewOptionsMDM;

interface

uses
  System.Classes,
  Vcl.ExtCtrls,
  cxGridCustomView,
  ERP.Package.Components.TERPWebBrowser,
  MDM.Package.Components.CustomOptionsMDMAction,
  MDM.Package.Components.Types;

type
  TCustomCatalogTableViewOptionsMDM = class(TcxCustomGridOptions)
  private
    FCatalogType: TCatalogType;
    FCustomOptionsMDMAction: TCustomOptionsMDMAction;
    FWebBrowser: TERPWebBrowser;
    FInnerTimer: TTimer;
    procedure SetActionOptions(const aValue: TCustomOptionsMDMAction);
    procedure SetWebBrowser(const aValue: TERPWebBrowser);
    function GetDelayDetails: Cardinal;
    procedure SetDelayDetails(const aValue: Cardinal);
  protected
    class function GetActionOptionsClass: TCustomOptionsMDMActionClass; virtual;
    procedure Notification(aComponent: TComponent; aOperation: TOperation); override;
  public
    constructor Create(aGridView: TcxCustomGridView); override;
    destructor Destroy; override;
    property CatalogType: TCatalogType read FCatalogType write FCatalogType;
    property ActionOptions: TCustomOptionsMDMAction read FCustomOptionsMDMAction write SetActionOptions;
    property InnerTimer: TTimer read FInnerTimer;
  published
    property DelayDetails: Cardinal read GetDelayDetails write SetDelayDetails default 1500;
    property WebBrowser: TERPWebBrowser read FWebBrowser write SetWebBrowser;
  end;

  TCustomCatalogTableViewOptionsMDMClass = class of TCustomCatalogTableViewOptionsMDM;

implementation

uses
  System.SysUtils;

{ TCustomCatalogTableViewOptionsMDM }

constructor TCustomCatalogTableViewOptionsMDM.Create(aGridView: TcxCustomGridView);
begin
  inherited Create(aGridView);
  FCustomOptionsMDMAction := GetActionOptionsClass().Create(aGridView);
  FInnerTimer := TTimer.Create(nil);
  FInnerTimer.Enabled := False;
  FInnerTimer.Interval := 1500;
end;

destructor TCustomCatalogTableViewOptionsMDM.Destroy;
begin
  FreeAndNil(FInnerTimer);
  FreeAndNil(FCustomOptionsMDMAction);
  inherited;
end;

class function TCustomCatalogTableViewOptionsMDM.GetActionOptionsClass: TCustomOptionsMDMActionClass;
begin
  Result := TCustomOptionsMDMAction;
end;

function TCustomCatalogTableViewOptionsMDM.GetDelayDetails: Cardinal;
begin
  Result := FInnerTimer.Interval;
end;

procedure TCustomCatalogTableViewOptionsMDM.Notification(aComponent: TComponent; aOperation: TOperation);
begin
  inherited Notification(aComponent, aOperation);
  if (FWebBrowser = aComponent) and (aOperation = opRemove) then
    FWebBrowser := nil;
  if Assigned(FCustomOptionsMDMAction) then
    FCustomOptionsMDMAction.Notification(aComponent, aOperation);
end;

procedure TCustomCatalogTableViewOptionsMDM.SetActionOptions(const aValue: TCustomOptionsMDMAction);
begin
  FCustomOptionsMDMAction.Assign(aValue);
end;

procedure TCustomCatalogTableViewOptionsMDM.SetDelayDetails(const aValue: Cardinal);
begin
  FInnerTimer.Interval := aValue;
end;

procedure TCustomCatalogTableViewOptionsMDM.SetWebBrowser(const aValue: TERPWebBrowser);
begin
  FWebBrowser := aValue;
  if Assigned(aValue) then
    aValue.FreeNotification(GridView);
end;

end.
