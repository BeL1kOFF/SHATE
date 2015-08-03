unit MDM.Package.Components.CleanOptionsMDMAction;

interface

uses
  cxGridCustomView,
  MDM.Package.Components.CustomOptionsMDMAction,
  MDM.Package.Components.CatalogAction,
  MDM.Package.Components.Types;

type
  TCleanOptionsMDMAction = class(TCustomOptionsMDMAction)
  private
    FMCActionPropertyTypes: TCatalogActionPropertyTypes;
  protected
    procedure AllocateDictionary; override;
    procedure DeallocateDictionary; override;
  public
    constructor Create(aGridView: TcxCustomGridView); override;
  published
    property ActionRefresh: TCatalogAction index aptRefresh read GetPropertyAction write SetPropertyAction;
    property ActionMoveToDraft: TCatalogAction index aptMoveToDraft read GetPropertyAction write SetPropertyAction;
    property ActionCopyFrom: TCatalogAction index aptCopyFrom read GetPropertyAction write SetPropertyAction;
    property ActionRestore: TCatalogAction index aptRestore read GetPropertyAction write SetPropertyAction;
    property ActionExport: TCatalogAction index aptExport read GetPropertyAction write SetPropertyAction;
  end;

implementation

{ TCleanOptionsMDMAction }

procedure TCleanOptionsMDMAction.AllocateDictionary;
var
  ActionPropertyType: TCatalogActionPropertyType;
begin
  for ActionPropertyType in FMCActionPropertyTypes do
    ActionDictionary.Add(ActionPropertyType, nil);
end;

constructor TCleanOptionsMDMAction.Create(aGridView: TcxCustomGridView);
begin
  FMCActionPropertyTypes := [aptRefresh, aptMoveToDraft, aptCopyFrom, aptRestore, aptExport];
  inherited Create(aGridView);
end;

procedure TCleanOptionsMDMAction.DeallocateDictionary;
var
  ActionPropertyType: TCatalogActionPropertyType;
begin
  for ActionPropertyType in FMCActionPropertyTypes do
    ActionDictionary.AddOrSetValue(ActionPropertyType, nil);
end;

end.
