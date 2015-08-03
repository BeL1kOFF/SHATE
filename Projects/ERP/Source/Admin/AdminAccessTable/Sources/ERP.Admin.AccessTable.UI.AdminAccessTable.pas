unit ERP.Admin.AccessTable.UI.AdminAccessTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxClasses, dxBar, System.Actions, Vcl.ActnList, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  Data.DB, cxGridLevel, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, ShateM.Components.TCustomTempTable,
  ShateM.Components.TFireDACTempTable;

type
  TfrmAccessTable = class(TERPCustomForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblAccessTable: TcxGridTableView;
    colId_AccessTable: TcxGridColumn;
    colTemplateDataBase: TcxGridColumn;
    colTableName: TcxGridColumn;
    colFieldName: TcxGridColumn;
    colAccessCode: TcxGridColumn;
    qrQuery: TFDQuery;
    colTableCaption: TcxGridColumn;
    colFieldCaption: TcxGridColumn;
    colFieldId: TcxGridColumn;
    ttAccessTableDel: TsmFireDACTempTable;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
  private
    procedure DeleteRecords;
    procedure RefreshData;
    procedure ShowChild(aId_AccessTable: Integer);
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

function CreateForm(aERPClientData: IERPClientData): THandle; stdcall;
procedure RegisterAccess(aModuleAccess: IModuleAccess); stdcall;
procedure SetModuleInfo(aModuleInfo: IModuleInfo); stdcall;

exports CreateForm;
exports RegisterAccess;
exports SetModuleInfo;

implementation

{$R *.dfm}
{$R Resource\Icon.res}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Admin.AccessTable.UI.AdminAccessTableDetail;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';

const
  MODULE_NAME            = 'Таблицы доступа';
  MODULE_GUID: TGUID     = '{9329E5D4-680A-413C-AEA6-04A5BCCAA498}';
  MODULE_TYPEDB          = TYPE_DATABASE_ADMIN;

  PROC_ADM_AT_SEL_ITEMLIST  = 'adm_at_sel_itemlist';
  PROC_ADM_AT_DEL_ITEM = 'adm_at_del_item';

  FLD_ID_ACCESSTABLE        = 'Id_AccessTable';
  FLD_TEMPLATEDATABASENAME  = 'TemplateDataBaseName';
  FLD_TABLENAME             = 'TableName';
  FLD_TABLECAPTION          = 'TableCaption';
  FLD_FIELDID               = 'FieldId';
  FLD_FIELDNAME             = 'FieldName';
  FLD_FIELDCAPTION          = 'FieldCaption';
  FLD_ACCESSCODE            = 'AccessCode';

  COL_ID_ACCESSTABLE        = 0;
  COL_TEMPLATEDATABASENAME  = 1;
  COL_TABLENAME             = 2;
  COL_TABLECAPTION          = 3;
  COL_FIELDID               = 4;
  COL_FIELDNAME             = 5;
  COL_FIELDCAPTION          = 6;
  COL_ACCESSCODE            = 7;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAccessTable;
begin
  frmForm := TfrmAccessTable.Create(aERPClientData);
  Result := frmForm.Handle;
end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo);
begin
  aModuleInfo.GUID := MODULE_GUID;
  aModuleInfo.Name := MODULE_NAME;
  aModuleInfo.TypeDB := MODULE_TYPEDB;
  aModuleInfo.TypeGuid := TYPEMODULE_ADMIN;
end;

procedure RegisterAccess(aModuleAccess: IModuleAccess);
begin
end;

{ TfrmAccessTable }

procedure TfrmAccessTable.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
end;

procedure TfrmAccessTable.acDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAccessTable.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblAccessTable.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAccessTable.acEditExecute(Sender: TObject);
begin
  ShowChild(tblAccessTable.Controller.FocusedRecord.Values[COL_ID_ACCESSTABLE]);
end;

procedure TfrmAccessTable.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblAccessTable.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAccessTable.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

constructor TfrmAccessTable.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  qrQuery.Connection := FDConnection;
  ttAccessTableDel.Connection := FDConnection;
  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
  acAdd.ImageIndex := IL_ADD;
  acEdit.ImageIndex := IL_EDIT;
  acDelete.ImageIndex := IL_DELETE;
  acRefresh.ImageIndex := IL_REFRESH;
end;

procedure TfrmAccessTable.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttAccessTableDel.CreateTempTable();
  try
    for k := 0 to tblAccessTable.Controller.SelectedRecordCount - 1 do
      ttAccessTableDel.InsertTempTable([TFieldValue.Create('Id_AccessTable', tblAccessTable.Controller.SelectedRecords[k].Values[COL_ID_ACCESSTABLE])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_AT_DEL_ITEM, []);
  finally
    ttAccessTableDel.DropTempTable();
  end;
end;

procedure TfrmAccessTable.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAccessTable.RefreshData;
var
  k: Integer;
begin
  qrQuery.SQL.Text := PROC_ADM_AT_SEL_ITEMLIST;
  try
    qrQuery.Open();
    qrQuery.First();
    tblAccessTable.BeginUpdate();
    try
      tblAccessTable.DataController.RecordCount := qrQuery.RecordCount;
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblAccessTable.DataController.Values[k, COL_ID_ACCESSTABLE] := qrQuery.FieldByName(FLD_ID_ACCESSTABLE).AsInteger;
        tblAccessTable.DataController.Values[k, COL_TEMPLATEDATABASENAME] := qrQuery.FieldByName(FLD_TEMPLATEDATABASENAME).AsString;
        tblAccessTable.DataController.Values[k, COL_TABLENAME] := qrQuery.FieldByName(FLD_TABLENAME).AsString;
        tblAccessTable.DataController.Values[k, COL_TABLECAPTION] := qrQuery.FieldByName(FLD_TABLECAPTION).AsString;
        tblAccessTable.DataController.Values[k, COL_FIELDID] := qrQuery.FieldByName(FLD_FIELDID).AsString;
        tblAccessTable.DataController.Values[k, COL_FIELDNAME] := qrQuery.FieldByName(FLD_FIELDNAME).AsString;
        tblAccessTable.DataController.Values[k, COL_FIELDCAPTION] := qrQuery.FieldByName(FLD_FIELDCAPTION).AsString;
        tblAccessTable.DataController.Values[k, COL_ACCESSCODE] := qrQuery.FieldByName(FLD_ACCESSCODE).AsInteger;
        qrQuery.Next();
      end;
    finally
      tblAccessTable.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAccessTable.ShowChild(aId_AccessTable: Integer);
var
  frmAdminAccessTableDetail: TfrmAdminAccessTableDetail;
begin
  frmAdminAccessTableDetail := TfrmAdminAccessTableDetail.Create(Self, FDConnection, aId_AccessTable);
  try
    frmAdminAccessTableDetail.ShowModal();
  finally
    frmAdminAccessTableDetail.Free();
  end;
  RefreshData();
end;

end.
