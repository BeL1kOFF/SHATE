unit MDM.Package.Components.CatalogTableViewClean;

interface

uses
  cxGridCustomTableView,
  MDM.Package.Components.CustomCatalogTableViewController,
  MDM.Package.Components.CustomCatalogTableView,
  MDM.Package.Components.CustomCatalogTableViewOptionsMDM,
  MDM.Package.Components.CatalogTableViewCleanController,
  MDM.Package.Components.CatalogTableViewCleanOptionsMDM;

type
  TCatalogTableViewClean = class(TCustomCatalogTableView)
  private
    function GetCatalogTableViewController: TCatalogTableViewCleanController;
    function GetOptionsMDM: TCatalogTableViewCleanOptionsMDM;
    procedure SetOptionsMDM(const aValue: TCatalogTableViewCleanOptionsMDM);
  protected
    class function GetCatalogTableViewControllerClass: TCustomCatalogTableViewControllerClass; override;
    class function GetOptionsMDMClass: TCustomCatalogTableViewOptionsMDMClass; override;
    function GetItemClass: TcxCustomGridTableItemClass; override;
  public
    property CatalogTableViewController: TCatalogTableViewCleanController read GetCatalogTableViewController;
  published
    property OptionsMDM: TCatalogTableViewCleanOptionsMDM read GetOptionsMDM write SetOptionsMDM;
  end;

implementation

uses
  MDM.Package.Components.CatalogCleanColumn;

{ TCatalogTableViewClean }

function TCatalogTableViewClean.GetItemClass: TcxCustomGridTableItemClass;
begin
  Result := TCatalogCleanColumn;
end;

function TCatalogTableViewClean.GetCatalogTableViewController: TCatalogTableViewCleanController;
begin
  Result := TCatalogTableViewCleanController(inherited CatalogTableViewController);
end;

class function TCatalogTableViewClean.GetCatalogTableViewControllerClass: TCustomCatalogTableViewControllerClass;
begin
  Result := TCatalogTableViewCleanController;
end;

function TCatalogTableViewClean.GetOptionsMDM: TCatalogTableViewCleanOptionsMDM;
begin
  Result := TCatalogTableViewCleanOptionsMDM(inherited OptionsMDM);
end;

class function TCatalogTableViewClean.GetOptionsMDMClass: TCustomCatalogTableViewOptionsMDMClass;
begin
  Result := TCatalogTableViewCleanOptionsMDM;
end;

procedure TCatalogTableViewClean.SetOptionsMDM(const aValue: TCatalogTableViewCleanOptionsMDM);
begin
  inherited OptionsMDM := aValue;
end;

end.
