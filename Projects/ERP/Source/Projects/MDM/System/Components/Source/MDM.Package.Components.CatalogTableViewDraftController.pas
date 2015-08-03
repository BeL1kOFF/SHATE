unit MDM.Package.Components.CatalogTableViewDraftController;

interface

uses
  System.SysUtils,
  MDM.Package.Components.CustomCatalogTableViewController,
  MDM.Package.Interfaces.ICatalogDraftController,
  MDM.Package.Components.Types;

type
  TCatalogTableViewDraftController = class(TCustomCatalogTableViewController)
  private
    function GetController: ICatalogDraftController;
    procedure SetController(const aValue: ICatalogDraftController);
  protected
    function DoActionUpdate(aActionPropertyType: TCatalogActionPropertyType): Boolean; override;
    procedure DoActionExecute(aActionPropertyType: TCatalogActionPropertyType); override;
  public
    property Controller: ICatalogDraftController read GetController write SetController;
  end;

  ECatalogTableViewDraftController = class(Exception);

implementation

{ TCatalogTableViewDraftController }

procedure TCatalogTableViewDraftController.DoActionExecute(aActionPropertyType: TCatalogActionPropertyType);
begin
  if Assigned(Controller) then
    case aActionPropertyType of
      aptDraftRefresh:
        Controller.Refresh();
      aptDraftAdd:
        Controller.Add();
      aptDraftEdit:
        Controller.Edit();
      aptDraftDelete:
        Controller.Delete();
      aptDraftStatusReset:
        Controller.ChangeStatusReset();
      aptDraftStatusReady:
        Controller.ChangeStatusReady();
      aptDraftStatusDelete:
        Controller.ChangeStatusDelete();
      aptDraftMerge:
        Controller.Merge();
      aptDraftAnalysis:
        Controller.Analysis();
      aptDraftApprove:
        Controller.Approve();
      aptDraftImport:
        Controller.ImportDraft();
      else
        raise ECatalogTableViewDraftController.Create('aActionPropertyType не определен');
    end;
end;

function TCatalogTableViewDraftController.DoActionUpdate(aActionPropertyType: TCatalogActionPropertyType): Boolean;
begin
  if Assigned(Controller) then
    case aActionPropertyType of
      aptDraftRefresh:
        Result := Controller.UpdateRefresh();
      aptDraftAdd:
        Result := Controller.UpdateAdd();
      aptDraftEdit:
        Result := Controller.UpdateEdit();
      aptDraftDelete:
        Result := Controller.UpdateDelete();
      aptDraftStatusReset:
        Result := Controller.UpdateChangeStatusReset();
      aptDraftStatusReady:
        Result := Controller.UpdateChangeStatusReady();
      aptDraftStatusDelete:
        Result := Controller.UpdateChangeStatusDelete();
      aptDraftMerge:
        Result := Controller.UpdateMerge();
      aptDraftAnalysis:
        Result := Controller.UpdateAnalysis();
      aptDraftApprove:
        Result := Controller.UpdateApprove();
      aptDraftImport:
        Result := Controller.UpdateImportDraft();
      else
        raise ECatalogTableViewDraftController.Create('aActionPropertyType не определен');
    end
  else
    Result := False;
end;

function TCatalogTableViewDraftController.GetController: ICatalogDraftController;
begin
  Result := ICatalogDraftController(inherited Controller);
end;

procedure TCatalogTableViewDraftController.SetController(const aValue: ICatalogDraftController);
begin
  inherited Controller := aValue;
end;

end.
