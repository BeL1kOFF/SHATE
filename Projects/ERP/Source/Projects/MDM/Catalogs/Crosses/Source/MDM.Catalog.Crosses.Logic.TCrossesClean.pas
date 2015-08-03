unit MDM.Catalog.Crosses.Logic.TCrossesClean;

interface

uses
  FireDAC.Stan.Param,
  MDM.Package.Classes.TCatalogCleanController;

type
  TCrossesClean = class(TCatalogCleanController)
  protected
    function UpdateRefresh: Boolean; override;
    procedure InitCatalogAccess; override;
    procedure InitSQL; override;
    procedure SetRefreshParams(aParams: TFDParams); override;
  end;

implementation

uses
  System.Variants,
  Data.DB,
  cxBarEditItem,
  cxDBLookupComboBox,
//  MDM.Catalog.Crosses.Logic.Consts,
  MDM.Catalog.Crosses.UI.Main;

{ TCrossesClean }

procedure TCrossesClean.InitCatalogAccess;
begin
  CatalogAccess.MoveToDraft := 11;
  CatalogAccess.CopyFrom := 12;
  CatalogAccess.Restore := 13;
  CatalogAccess.ExportClean := 14;
end;

procedure TCrossesClean.InitSQL;
begin
  SQLProc.SQLRefreshSelect := 'c_itemlist_sel :Id_TradeMark';
  SQLProc.SQLCopyFromSelect := 'c_copyfrom_ins :UserName';
  SQLProc.SQLMoveToDraftCheck := 'c_todraft_check :UserName';
  SQLProc.SQLMoveToDraftSelect := 'c_todraft_upd :UserName';
  SQLProc.SQLRestoreSelect := 'c_restore_upd';
  SQLProc.SQLExportMeta := 'c_itemlist_export_meta';
  SQLProc.SQLExport := 'c_itemlist_export';
end;

procedure TCrossesClean.SetRefreshParams(aParams: TFDParams);
var
  ComboBox: TcxBarEditItem;
begin
  ComboBox := (ERPForm as TfrmMDMCrosses).cmbTradeMark;
  if VarIsNull(ComboBox.EditValue) then
    aParams.ParamByName('Id_TradeMark').DataType := ftInteger;
  aParams.ParamByName('Id_TradeMark').Value := ComboBox.EditValue;
end;

function TCrossesClean.UpdateRefresh: Boolean;
var
  ComboBox: TcxBarEditItem;
begin
  ComboBox := (ERPForm as TfrmMDMCrosses).cmbTradeMark;
  Result := inherited UpdateRefresh() and
    ((ComboBox.Properties as TcxLookupComboBoxProperties).DataController.FindRecordIndexByKey(ComboBox.EditValue) > -1);
end;

end.
