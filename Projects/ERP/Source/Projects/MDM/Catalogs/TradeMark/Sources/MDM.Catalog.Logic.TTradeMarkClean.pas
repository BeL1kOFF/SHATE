unit MDM.Catalog.Logic.TTradeMarkClean;

interface

uses
  Data.DB,
  FireDAC.Stan.Param,
  MDM.Package.Classes.TCatalogCleanController;

type
  TTradeMarkClean = class(TCatalogCleanController)
  protected
    procedure InitCatalogAccess; override;
    procedure InitSQL; override;
    procedure LoadDetailsParserField(aField: TField; var aDocument: string; var aHandled: Boolean); override;
  end;

implementation

uses
  Winapi.ActiveX,
  System.Classes,
  System.SysUtils,
  MDM.Catalog.Logic.Consts;

{ TTradeMarkClean }

procedure TTradeMarkClean.InitCatalogAccess;
begin
  CatalogAccess.MoveToDraft := A11_TODRAFT;
  CatalogAccess.CopyFrom    := A12_COPY;
  CatalogAccess.Restore     := A13_RESTORE;
  CatalogAccess.ExportClean := A14_EXPORT;
end;

procedure TTradeMarkClean.InitSQL;
begin
{  SQLProc.SQLMetaSelect := 'tm_meta_sel';}
  SQLProc.SQLRefreshSelect        := PROC_TM_ITEMLIST_SEL;
  SQLProc.SQLMoveToDraftSelect    := PROC_TM_TODRAFT_UPD;
  SQLProc.SQLMoveToDraftCheck     := PROC_TM_TODRAFT_CHECK;
  SQLProc.SQLCopyFromSelect       := PROC_TM_COPYFROM_INS;
  SQLProc.SQLRestoreSelect        := PROC_TM_RESTORE_UPD;
  SQLProc.SQLExportMeta           := PROC_TM_ITEMLIST_EXPORT_META;
  SQLProc.SQLExport               := PROC_TM_ITEMLIST_EXPORT;
  SetLength(SQLProc.SQLRefreshDetailsSelect, 1);
  SQLProc.SQLRefreshDetailsSelect[0] := PROC_TM_ITEMLIST_DETAILS_SEL;
end;

procedure TTradeMarkClean.LoadDetailsParserField(aField: TField; var aDocument: string; var aHandled: Boolean);
var
  TempStream: TBytesStream;
  Stream: IStream;
begin
  if aField.FieldName = 'Logo' then
  begin
    TempStream := TBytesStream.Create();
    TempStream.Write(aField.AsBytes[0], Length(aField.AsBytes));
    Stream := TStreamAdapter.Create(TempStream, soOwned);
    Stream._AddRef();
    aDocument := StringReplace(aDocument, '<!-- #' + aField.FieldName + '# -->', Format('<img width="100" src="myhttp://%d" itemprop="image">', [Integer(Stream)]), [rfReplaceAll, rfIgnoreCase]);
    aHandled := True;
  end;
end;

end.
