unit MDM.Package.Components.CatalogTableViewDraftOptionsMDM;

interface

uses
  cxGridCustomView,
  MDM.Package.Components.Types,
  MDM.Package.Components.CustomCatalogTableViewOptionsMDM,
  MDM.Package.Components.CustomOptionsMDMAction,
  MDM.Package.Components.DraftOptionsMDMAction;

type
  TCatalogTableViewDraftOptionsMDM = class(TCustomCatalogTableViewOptionsMDM)
  private
    function GetActionOptions: TDraftOptionsMDMAction;
    function GetCatalogType: TCatalogType;
    procedure SetActionOptions(const aValue: TDraftOptionsMDMAction);
  protected
    class function GetActionOptionsClass: TCustomOptionsMDMActionClass; override;
  public
    constructor Create(aGridView: TcxCustomGridView); override;
  published
    property CatalogType: TCatalogType read GetCatalogType;
    property ActionOptions: TDraftOptionsMDMAction read GetActionOptions write SetActionOptions;
  end;

implementation

{ TCatalogTableViewDraftOptionsMDM }

constructor TCatalogTableViewDraftOptionsMDM.Create(aGridView: TcxCustomGridView);
begin
  inherited Create(aGridView);
  inherited CatalogType := ctDraft;
end;

function TCatalogTableViewDraftOptionsMDM.GetActionOptions: TDraftOptionsMDMAction;
begin
  Result := TDraftOptionsMDMAction(inherited ActionOptions);
end;

class function TCatalogTableViewDraftOptionsMDM.GetActionOptionsClass: TCustomOptionsMDMActionClass;
begin
  Result := TDraftOptionsMDMAction;
end;

function TCatalogTableViewDraftOptionsMDM.GetCatalogType: TCatalogType;
begin
  Result := inherited CatalogType;
end;

procedure TCatalogTableViewDraftOptionsMDM.SetActionOptions(const aValue: TDraftOptionsMDMAction);
begin
  inherited ActionOptions := aValue;
end;

end.
