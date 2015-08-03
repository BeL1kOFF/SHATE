unit MDM.Package.Components.CatalogDraftColumn;

interface

uses
  MDM.Package.Components.CustomCatalogColumn,
  MDM.Package.Components.CustomCatalogColumnMetaOptions,
  MDM.Package.Components.CatalogDraftColumnMetaOptions;

type
  TCatalogDraftColumn = class(TCustomCatalogColumn)
  private
    function GetMetaOptions: TCatalogDraftColumnMetaOptions;
    procedure SetMetaOptions(const aValue: TCatalogDraftColumnMetaOptions);
  protected
    class function GetMetaOptionsClass: TCustomCatalogColumnMetaOptionsClass; override;
  published
    property MetaOptions: TCatalogDraftColumnMetaOptions read GetMetaOptions write SetMetaOptions;
  end;

implementation

{ TCatalogDraftColumn }

function TCatalogDraftColumn.GetMetaOptions: TCatalogDraftColumnMetaOptions;
begin
  Result := TCatalogDraftColumnMetaOptions(inherited MetaOptions);
end;

class function TCatalogDraftColumn.GetMetaOptionsClass: TCustomCatalogColumnMetaOptionsClass;
begin
  Result := TCatalogDraftColumnMetaOptions;
end;

procedure TCatalogDraftColumn.SetMetaOptions(const aValue: TCatalogDraftColumnMetaOptions);
begin
  inherited MetaOptions := aValue;
end;

end.
