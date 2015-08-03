unit MDM.Package.Components.CatalogTableViewCleanController;

interface

uses
  System.SysUtils,
  MDM.Package.Components.CustomCatalogTableViewController,
  MDM.Package.Components.CustomOptionsMDMAction,
  MDM.Package.Interfaces.ICatalogCleanController,
  MDM.Package.Components.Types;

type
  TCatalogTableViewCleanController = class(TCustomCatalogTableViewController)
  private
    function GetController: ICatalogCleanController;
    procedure SetController(const aValue: ICatalogCleanController);
  protected
    function DoActionUpdate(aActionPropertyType: TCatalogActionPropertyType): Boolean; override;
    procedure DoActionExecute(aActionPropertyType: TCatalogActionPropertyType); override;
  public
    property Controller: ICatalogCleanController read GetController write SetController;
  end;

  ECatalogTableViewCleanController = class(Exception);

implementation

{ TCatalogTableViewCleanController }

procedure TCatalogTableViewCleanController.DoActionExecute(aActionPropertyType: TCatalogActionPropertyType);
begin
  if Assigned(Controller) then
    case aActionPropertyType of
      aptRefresh:
        Controller.Refresh();
      aptMoveToDraft:
        Controller.MoveToDraft();
      aptCopyFrom:
        Controller.CopyFrom();
      aptRestore:
        Controller.Restore();
      aptExport:
        Controller.ExportClean();
      else
        raise ECatalogTableViewCleanController.Create('aActionPropertyType не определен');
    end;
end;

function TCatalogTableViewCleanController.DoActionUpdate(aActionPropertyType: TCatalogActionPropertyType): Boolean;
begin
  if Assigned(Controller) then
    case aActionPropertyType of
      aptRefresh:
        Result := Controller.UpdateRefresh();
      aptMoveToDraft:
        Result := Controller.UpdateMoveToDraft();
      aptCopyFrom:
        Result := Controller.UpdateCopyFrom();
      aptRestore:
        Result := Controller.UpdateRestore();
      aptExport:
        Result := Controller.UpdateExportClean();
      else
        raise ECatalogTableViewCleanController.Create('aActionPropertyType не определен');
    end
  else
    Result := False;
end;

function TCatalogTableViewCleanController.GetController: ICatalogCleanController;
begin
  Result := ICatalogCleanController(inherited Controller);
end;

procedure TCatalogTableViewCleanController.SetController(const aValue: ICatalogCleanController);
begin
  inherited Controller := aValue;
end;

end.
