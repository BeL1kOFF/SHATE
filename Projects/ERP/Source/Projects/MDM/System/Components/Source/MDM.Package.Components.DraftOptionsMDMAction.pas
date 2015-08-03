unit MDM.Package.Components.DraftOptionsMDMAction;

interface

uses
  cxGridCustomView,
  MDM.Package.Components.Types,
  MDM.Package.Components.CustomOptionsMDMAction,
  MDM.Package.Components.CatalogAction;

type
  TDraftOptionsMDMAction = class(TCustomOptionsMDMAction)
  private
    FMCActionPropertyTypes: TCatalogActionPropertyTypes;
  protected
    procedure AllocateDictionary; override;
    procedure DeallocateDictionary; override;
  public
    constructor Create(aGridView: TcxCustomGridView); override;
  published
    property ActionRefresh: TCatalogAction index aptDraftRefresh read GetPropertyAction write SetPropertyAction;
    property ActionAdd: TCatalogAction index aptDraftAdd read GetPropertyAction write SetPropertyAction;
    property ActionEdit: TCatalogAction index aptDraftEdit read GetPropertyAction write SetPropertyAction;
    property ActionDelete: TCatalogAction index aptDraftDelete read GetPropertyAction write SetPropertyAction;
    property ActionStatusReset: TCatalogAction index aptDraftStatusReset read GetPropertyAction write SetPropertyAction;
    property ActionStatusReady: TCatalogAction index aptDraftStatusReady read GetPropertyAction write SetPropertyAction;
    property ActionStatusDelete: TCatalogAction index aptDraftStatusDelete read GetPropertyAction write SetPropertyAction;
    property ActionMerge: TCatalogAction index aptDraftMerge read GetPropertyAction write SetPropertyAction;
    property ActionAnalysis: TCatalogAction index aptDraftAnalysis read GetPropertyAction write SetPropertyAction;
    property ActionApprove: TCatalogAction index aptDraftApprove read GetPropertyAction write SetPropertyAction;
    property ActionImport: TCatalogAction index aptDraftImport read GetPropertyAction write SetPropertyAction;
  end;

implementation

{ TDraftOptionsMDMAction }

procedure TDraftOptionsMDMAction.AllocateDictionary;
var
  ActionPropertyType: TCatalogActionPropertyType;
begin
  for ActionPropertyType in FMCActionPropertyTypes do
    ActionDictionary.Add(ActionPropertyType, nil);
end;

constructor TDraftOptionsMDMAction.Create(aGridView: TcxCustomGridView);
begin
  FMCActionPropertyTypes := [aptDraftRefresh, aptDraftAdd, aptDraftEdit, aptDraftDelete, aptDraftStatusReset,
    aptDraftStatusReady, aptDraftStatusDelete, aptDraftMerge, aptDraftAnalysis, aptDraftApprove, aptDraftImport];
  inherited Create(aGridView);
end;

procedure TDraftOptionsMDMAction.DeallocateDictionary;
var
  ActionPropertyType: TCatalogActionPropertyType;
begin
  for ActionPropertyType in FMCActionPropertyTypes do
    ActionDictionary.AddOrSetValue(ActionPropertyType, nil);
end;

end.
