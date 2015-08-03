unit ERP.Admin.Server.UI.AdminServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ERP.Package.CustomForm.TERPCustomForm,
  dxBar, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxClasses,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid, Vcl.ActnList, Vcl.ImgList, cxCheckBox,
  System.Generics.Collections, ERP.Package.ClientInterface.IERPClientData, cxDBData, cxGridDBTableView, Vcl.StdCtrls,
  ERP.Package.ClientInterface.IModuleInfo, ERP.Package.ClientInterface.IModuleAccess,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  cxNavigator, System.Actions, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminServer = class(TERPCustomForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblServer: TcxGridTableView;
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    dxBarLargeButton4: TdxBarLargeButton;
    acRefresh: TAction;
    colId_Server: TcxGridColumn;
    colServerName: TcxGridColumn;
    colEnabled: TcxGridColumn;
    qrQuery: TFDQuery;
    ttDelServer: TsmFireDACTempTable;
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure tblServerCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    procedure DeleteRecords;
    procedure RefreshData;
    procedure ShowChild(aId_Server: Integer);
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo); stdcall;
function CreateForm(aERPClientData: IERPClientData): THandle; stdcall;
procedure RegisterAccess(aModuleAccess: IModuleAccess); stdcall;

exports CreateForm;
exports SetModuleInfo;
exports RegisterAccess;

implementation

{$R *.dfm}
{$R Resource\Icon.RES}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Admin.Server.UI.AdminServerDetail,
  ERP.Package.ClientInterface.IDBConnection;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';

const
  MODULE_NAME            = 'Сервера';
  MODULE_GUID: TGUID     = '{99A8C5FB-771A-4988-823C-7B4B28CF1B69}';
  MODULE_TYPEDB          = 1;

  COL_ID_SERVER          = 0;
  COL_SERVERNAME         = 1;
  COL_ENABLED            = 2;

  PROC_ADM_SRV_DEL_ITEM = 'adm_srv_del_item';
  PROC_ADM_SRV_SEL_ITEMLIST = 'adm_srv_sel_itemlist';

  FLD_ID_SERVER = 'Id_Server';
  FLD_SERVERNAME = 'ServerName';
  FLD_ENABLED = 'Enabled';

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAdminServer;
begin
  frmForm := TfrmAdminServer.Create(aERPClientData);
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

{ TfrmAdminServer }

procedure TfrmAdminServer.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
  RefreshData();
end;

procedure TfrmAdminServer.acDeleteExecute(Sender: TObject);
begin
  if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAdminServer.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblServer.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAdminServer.acEditExecute(Sender: TObject);
begin
  ShowChild(tblServer.Controller.FocusedRecord.Values[COL_ID_SERVER]);
  RefreshData();
end;

procedure TfrmAdminServer.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblServer.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAdminServer.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

constructor TfrmAdminServer.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  ttDelServer.Connection := FDConnection;
  qrQuery.Connection := FDConnection;
  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
  acAdd.ImageIndex := IL_ADD;
  acEdit.ImageIndex := IL_EDIT;
  acDelete.ImageIndex := IL_DELETE;
  acRefresh.ImageIndex := IL_REFRESH;
end;

procedure TfrmAdminServer.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttDelServer.CreateTempTable();
  try
    for k := 0 to tblServer.Controller.SelectedRecordCount - 1 do
      ttDelServer.InsertTempTable([TFieldValue.Create('Id_Server', tblServer.Controller.SelectedRecords[k].Values[COL_ID_SERVER])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_SRV_DEL_ITEM, []);
  finally
    ttDelServer.DropTempTable();
  end;
end;

procedure TfrmAdminServer.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminServer.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_SRV_SEL_ITEMLIST;
  try
    qrQuery.Open();
    tblServer.BeginUpdate();
    try
      tblServer.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblServer.DataController.RecordCount - 1 do
      begin
        tblServer.DataController.Values[k, COL_ID_SERVER] := qrQuery.FieldByName(FLD_ID_SERVER).AsInteger;
        tblServer.DataController.Values[k, COL_SERVERNAME] := qrQuery.FieldByName(FLD_SERVERNAME).AsString;
        tblServer.DataController.Values[k, COL_ENABLED] := qrQuery.FieldByName(FLD_ENABLED).AsBoolean;
        qrQuery.Next();
      end;
    finally
      tblServer.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminServer.ShowChild(aId_Server: Integer);
var
  frmAdminServerDetail: TfrmAdminServerDetail;
begin
  frmAdminServerDetail := TfrmAdminServerDetail.Create(aId_Server, FDConnection, Self);
  try
    frmAdminServerDetail.ShowModal();
  finally
    frmAdminServerDetail.Free();
  end;
  Refresh();
end;

procedure TfrmAdminServer.tblServerCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.
