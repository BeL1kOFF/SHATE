unit MDM.Package.Components.CatalogCleanColumn;

interface

uses
  MDM.Package.Components.CustomCatalogColumn,
  MDM.Package.Components.CustomCatalogColumnMetaOptions,
  MDM.Package.Components.CatalogCleanColumnMetaOptions;

type
  TCatalogCleanColumn = class(TCustomCatalogColumn)
  private
    function GetMetaOptions: TCatalogCleanColumnMetaOptions;
    procedure SetMetaOptions(const aValue: TCatalogCleanColumnMetaOptions);
  protected
    class function GetMetaOptionsClass: TCustomCatalogColumnMetaOptionsClass; override;
  published
    property MetaOptions: TCatalogCleanColumnMetaOptions read GetMetaOptions write SetMetaOptions;
  end;

implementation

{ TCatalogCleanColumn }

function TCatalogCleanColumn.GetMetaOptions: TCatalogCleanColumnMetaOptions;
begin
  Result := TCatalogCleanColumnMetaOptions(inherited MetaOptions);
end;

class function TCatalogCleanColumn.GetMetaOptionsClass: TCustomCatalogColumnMetaOptionsClass;
begin
  Result := TCatalogCleanColumnMetaOptions;
end;

procedure TCatalogCleanColumn.SetMetaOptions(const aValue: TCatalogCleanColumnMetaOptions);
begin
  inherited MetaOptions := aValue;
end;

end.
