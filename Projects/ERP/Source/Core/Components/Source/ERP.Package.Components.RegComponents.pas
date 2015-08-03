unit ERP.Package.Components.RegComponents;

interface

uses
  ERP.Package.Components.TERPWebBrowser,
  ERP.Package.Components.TCatalogImportExcel,
  ERP.Package.Components.TCatalogExportExcel,
  ERP.Package.Components.TERPWebBrowserEditorProperties,
  ERP.Package.Components.TERPWebBrowserCollections;

procedure Register;

implementation

uses
  System.Classes,
  System.SysUtils,
  Vcl.Menus,
  DesignIntf;

procedure Register;
begin
  RegisterComponents('Shate-M ERP', [TERPWebBrowser, TCatalogExportExcel, TCatalogImportExcel]);
end;

initialization
  RegisterPropertyEditor(TypeInfo(TPopupMenu), TERPWebBrowser, 'PopupMenu', nil);
  RegisterPropertyEditor(TypeInfo(TFileName), TERPWebBrowserTemplate, 'TemplateFile', TWebBrowserFileNameProperty);

end.
