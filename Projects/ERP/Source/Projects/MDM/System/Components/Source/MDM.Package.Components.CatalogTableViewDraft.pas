unit MDM.Package.Components.CatalogTableViewDraft;

interface

uses
  cxGridCustomTableView,
  MDM.Package.Components.CustomCatalogTableView,
  MDM.Package.Components.CatalogTableViewDraftController,
  MDM.Package.Components.CatalogTableViewDraftOptionsMDM,
  MDM.Package.Components.CustomCatalogTableViewController,
  MDM.Package.Components.CustomCatalogTableViewOptionsMDM;

type
  TCatalogTableViewDraft = class(TCustomCatalogTableView)
  private
    function GetCatalogTableViewController: TCatalogTableViewDraftController;
    function GetOptionsMDM: TCatalogTableViewDraftOptionsMDM;
    procedure SetOptionsMDM(const aValue: TCatalogTableViewDraftOptionsMDM);
  protected
    class function GetCatalogTableViewControllerClass: TCustomCatalogTableViewControllerClass; override;
    class function GetOptionsMDMClass: TCustomCatalogTableViewOptionsMDMClass; override;
    function GetItemClass: TcxCustomGridTableItemClass; override;
  public
    property CatalogTableViewController: TCatalogTableViewDraftController read GetCatalogTableViewController;
  published
    property OptionsMDM: TCatalogTableViewDraftOptionsMDM read GetOptionsMDM write SetOptionsMDM;
  end;

implementation

uses
  MDM.Package.Components.CatalogDraftColumn;

{ TCatalogTableViewDraft }

function TCatalogTableViewDraft.GetCatalogTableViewController: TCatalogTableViewDraftController;
begin
  Result := TCatalogTableViewDraftController(inherited CatalogTableViewController);
end;

class function TCatalogTableViewDraft.GetCatalogTableViewControllerClass: TCustomCatalogTableViewControllerClass;
begin
  Result := TCatalogTableViewDraftController;
end;

function TCatalogTableViewDraft.GetItemClass: TcxCustomGridTableItemClass;
begin
  Result := TCatalogDraftColumn;
end;

function TCatalogTableViewDraft.GetOptionsMDM: TCatalogTableViewDraftOptionsMDM;
begin
  Result := TCatalogTableViewDraftOptionsMDM(inherited OptionsMDM);
end;

class function TCatalogTableViewDraft.GetOptionsMDMClass: TCustomCatalogTableViewOptionsMDMClass;
begin
  Result := TCatalogTableViewDraftOptionsMDM;
end;

procedure TCatalogTableViewDraft.SetOptionsMDM(const aValue: TCatalogTableViewDraftOptionsMDM);
begin
  inherited OptionsMDM := aValue;
end;

end.
