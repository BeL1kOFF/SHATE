unit MDM.Package.ComponentsDesign.CatalogTableView;

interface

uses
  System.Classes,
  System.Actions,
  cxGridCustomView,
  MDM.Package.Components.CatalogAction,
  MDM.Package.Components.CatalogTableViewClean,
  MDM.Package.Components.CatalogTableViewDraft,
  MDM.Package.Components.CatalogCleanColumn,
  MDM.Package.Components.CatalogDraftColumn;

implementation

initialization
  RegisterActions('MDM Catalog', [TCatalogAction], nil);
  cxGridRegisteredViews.Register(TCatalogTableViewClean, 'MDMCatalog Clean Table');
  cxGridRegisteredViews.Register(TCatalogTableViewDraft, 'MDMCatalog Draft Table');
  System.Classes.RegisterClass(TCatalogCleanColumn);
  System.Classes.RegisterClass(TCatalogDraftColumn);

finalization
  System.Classes.UnRegisterClass(TCatalogDraftColumn);
  System.Classes.UnRegisterClass(TCatalogCleanColumn);
  cxGridRegisteredViews.Unregister(TCatalogTableViewDraft);
  cxGridRegisteredViews.Unregister(TCatalogTableViewClean);
  UnRegisterActions([TCatalogAction]);

end.
