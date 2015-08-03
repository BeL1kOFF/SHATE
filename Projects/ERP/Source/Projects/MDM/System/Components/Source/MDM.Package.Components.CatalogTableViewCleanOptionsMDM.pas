unit MDM.Package.Components.CatalogTableViewCleanOptionsMDM;

interface

uses
  cxGridCustomView,
  MDM.Package.Components.CustomCatalogTableViewOptionsMDM,
  MDM.Package.Components.CustomOptionsMDMAction,
  MDM.Package.Components.Types,
  MDM.Package.Components.CleanOptionsMDMAction;

type
  TCatalogTableViewCleanOptionsMDM = class(TCustomCatalogTableViewOptionsMDM)
  private
    procedure SetActionOptions(const aValue: TCleanOptionsMDMAction);
    function GetActionOptions: TCleanOptionsMDMAction;
    function GetCatalogType: TCatalogType;
  protected
    class function GetActionOptionsClass: TCustomOptionsMDMActionClass; override;
  public
    constructor Create(aGridView: TcxCustomGridView); override;
  published
    property CatalogType: TCatalogType read GetCatalogType;
    property ActionOptions: TCleanOptionsMDMAction read GetActionOptions write SetActionOptions;
  end;

implementation

{ TCatalogTableViewCleanOptionsMDM }

constructor TCatalogTableViewCleanOptionsMDM.Create(aGridView: TcxCustomGridView);
begin
  inherited Create(aGridView);
  inherited CatalogType := ctClean;
end;

function TCatalogTableViewCleanOptionsMDM.GetActionOptions: TCleanOptionsMDMAction;
begin
  Result := TCleanOptionsMDMAction(inherited ActionOptions);
end;

class function TCatalogTableViewCleanOptionsMDM.GetActionOptionsClass: TCustomOptionsMDMActionClass;
begin
  Result := TCleanOptionsMDMAction;
end;

function TCatalogTableViewCleanOptionsMDM.GetCatalogType: TCatalogType;
begin
  Result := inherited CatalogType;
end;

procedure TCatalogTableViewCleanOptionsMDM.SetActionOptions(const aValue: TCleanOptionsMDMAction);
begin
  inherited ActionOptions := aValue;
end;

end.
