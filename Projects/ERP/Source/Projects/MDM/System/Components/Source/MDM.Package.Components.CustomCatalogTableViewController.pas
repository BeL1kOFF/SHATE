unit MDM.Package.Components.CustomCatalogTableViewController;

interface

uses
  Vcl.ActnList,
  cxGridTableView,
  MDM.Package.Interfaces.ICustomCatalogController,
  MDM.Package.Components.CatalogAction,
  MDM.Package.Components.CustomOptionsMDMAction,
  MDM.Package.Components.Types;

type
  TCustomCatalogTableViewController = class
  private
    FGridView: TcxGridTableView;
    FController: ICustomCatalogController;
  protected
    function DoActionUpdate(aActionPropertyType: TCatalogActionPropertyType): Boolean; virtual; abstract;
    procedure DoActionExecute(aActionPropertyType: TCatalogActionPropertyType); virtual; abstract;
    property GridView: TcxGridTableView read FGridView;
  public
    constructor Create(aGridView: TcxGridTableView); virtual;
    procedure ActionUpdate(aAction: TCatalogAction);
    procedure ActionExecute(aAction: TCatalogAction);
    property Controller: ICustomCatalogController read FController write FController;
  end;

  TCustomCatalogTableViewControllerClass = class of TCustomCatalogTableViewController;

implementation

uses
  MDM.Package.Components.CustomCatalogTableView;

{ TCustomCatalogTableViewController }

procedure TCustomCatalogTableViewController.ActionExecute(aAction: TCatalogAction);
var
  ActionPropertyType: TCatalogActionPropertyType;
begin
  ActionPropertyType := (FGridView as TCustomCatalogTableView).OptionsMDM.ActionOptions.GetPropertyTypeFromAction(aAction);
  DoActionExecute(ActionPropertyType);
end;

procedure TCustomCatalogTableViewController.ActionUpdate(aAction: TCatalogAction);
var
  ActionPropertyType: TCatalogActionPropertyType;
begin
  ActionPropertyType := (FGridView as TCustomCatalogTableView).OptionsMDM.ActionOptions.GetPropertyTypeFromAction(aAction);
  aAction.Enabled := DoActionUpdate(ActionPropertyType);
end;

constructor TCustomCatalogTableViewController.Create(aGridView: TcxGridTableView);
begin
  FGridView := aGridView;
end;

end.
