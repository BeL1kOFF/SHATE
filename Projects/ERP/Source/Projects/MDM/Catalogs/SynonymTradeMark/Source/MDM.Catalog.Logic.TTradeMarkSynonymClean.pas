unit MDM.Catalog.Logic.TTradeMarkSynonymClean;

interface

uses
  FireDAC.Stan.Param,
  MDM.Package.Classes.TCatalogCleanController,
  MDM.Catalog.Logic.STM.Consts;

type
  TSynonymTradeMarkClean = class(TCatalogCleanController)
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
  cxDBLookupComboBox,
  cxBarEditItem,
  MDM.Catalog.UI.TradeMarkSynonym;

{ TSynonymTradeMarkClean }

procedure TSynonymTradeMarkClean.InitCatalogAccess;
begin
  CatalogAccess.MoveToDraft := A11_TODRAFT;
  CatalogAccess.CopyFrom := A12_COPY;
  CatalogAccess.Restore := A13_RESTORE;
  CatalogAccess.ExportClean := A14_EXPORT;
end;

procedure TSynonymTradeMarkClean.InitSQL;
begin
  SQLProc.SQLRefreshSelect := 'tms_itemlist_sel :Id_TradeMark';
  SQLProc.SQLMoveToDraftCheck := 'tms_todraft_check :UserName';
  SQLProc.SQLMoveToDraftSelect := 'tms_todraft_upd :UserName';
  SQLProc.SQLCopyFromSelect := 'tms_copyfrom_ins :UserName';
  SQLProc.SQLRestoreSelect := 'tms_restore_upd';
  SQLProc.SQLExportMeta := 'tms_itemlist_export_meta';
  SQLProc.SQLExport := 'tms_itemlist_export';
end;

procedure TSynonymTradeMarkClean.SetRefreshParams(aParams: TFDParams);
var
  ComboBox: TcxBarEditItem;
begin
  ComboBox := (ERPForm as TfrmTradeMarkSynonym).cmbTradeMark;
  if VarIsNull(ComboBox.EditValue) then
    aParams.ParamByName('Id_TradeMark').DataType := ftInteger;
  aParams.ParamByName('Id_TradeMark').Value := ComboBox.EditValue;
end;

function TSynonymTradeMarkClean.UpdateRefresh: Boolean;
var
  ComboBox: TcxBarEditItem;
begin
  ComboBox := (ERPForm as TfrmTradeMarkSynonym).cmbTradeMark;
  Result := inherited UpdateRefresh() and
    ((ComboBox.Properties as TcxLookupComboBoxProperties).DataController.FindRecordIndexByKey(ComboBox.EditValue) > -1);
end;

end.
