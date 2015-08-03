unit ERP.Admin.ProfileGroup.AdminProfileGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxCheckBox, Data.DB, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView, cxGrid, dxBar, Vcl.ActnList,
  cxNavigator, System.Actions, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminProfileGroup = class(TERPCustomForm)
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    cxGrid: TcxGrid;
    tblProfileGroup: TcxGridTableView;
    cxGridLevel: TcxGridLevel;
    colIdProfileGroup: TcxGridColumn;
    colName: TcxGridColumn;
    colDescription: TcxGridColumn;
    qrQuery: TFDQuery;
    ttProfileGroup: TsmFireDACTempTable;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tblProfileGroupCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
  private
    procedure DeleteRecords;
    procedure RefreshData;
    procedure ShowChild(aId_ProfileGroup: Integer);
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
{$R Resource\Icon.RES}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Admin.ProfileGroup.AdminProfileGroupDetail;

const
  MODULE_NAME            = 'Группы профилей';
  MODULE_GUID: TGUID     = '{06194337-2246-4190-9CB5-C8AAFE86E8A9}';
  MODULE_TYPEDB          = 1;

  PROC_ADM_PG_SEL_ITEMLIST = 'adm_pg_sel_itemlist';
  PROC_ADM_PG_DEL_ITEM = 'adm_pg_del_item';

  FLD_ID_PROFILE_GROUP = 'Id_ProfileGroup';
  FLD_NAME = 'Name';
  FLD_DESCRIPTION = 'Description';

  COL_ID_PROFILE_GROUP = 0;
  COL_NAME = 1;
  COL_DESCRIPTION = 2;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAdminProfileGroup;
begin
  frmForm := TfrmAdminProfileGroup.Create(aERPClientData);
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

{ TfrmAdminProfileGroup }

procedure TfrmAdminProfileGroup.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
  RefreshData();
end;

procedure TfrmAdminProfileGroup.acDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAdminProfileGroup.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblProfileGroup.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAdminProfileGroup.acEditExecute(Sender: TObject);
begin
  ShowChild(tblProfileGroup.Controller.FocusedRecord.Values[COL_ID_PROFILE_GROUP]);
  RefreshData();
end;

procedure TfrmAdminProfileGroup.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblProfileGroup.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAdminProfileGroup.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

constructor TfrmAdminProfileGroup.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  acAdd.ImageIndex := IL_ADD;
  acEdit.ImageIndex := IL_EDIT;
  acDelete.ImageIndex := IL_DELETE;
  acRefresh.ImageIndex := IL_REFRESH;
  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
  qrQuery.Connection := FDConnection;
  ttProfileGroup.Connection := FDConnection;
end;

procedure TfrmAdminProfileGroup.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttProfileGroup.CreateTempTable();
  try
    for k := 0 to tblProfileGroup.Controller.SelectedRecordCount - 1 do
      ttProfileGroup.InsertTempTable([TFieldValue.Create('Id_ProfileGroup', tblProfileGroup.Controller.SelectedRecords[k].Values[COL_ID_PROFILE_GROUP])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_PG_DEL_ITEM, []);
  finally
    ttProfileGroup.DropTempTable();
  end;
end;

procedure TfrmAdminProfileGroup.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminProfileGroup.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_PG_SEL_ITEMLIST;
  try
    qrQuery.Open();
    tblProfileGroup.BeginUpdate();
    try
      tblProfileGroup.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblProfileGroup.DataController.RecordCount - 1 do
      begin
        tblProfileGroup.DataController.Values[k, COL_ID_PROFILE_GROUP] := qrQuery.FieldByName(FLD_ID_PROFILE_GROUP).AsInteger;
        tblProfileGroup.DataController.Values[k, COL_NAME] := qrQuery.FieldByName(FLD_NAME).AsString;
        tblProfileGroup.DataController.Values[k, COL_DESCRIPTION] := qrQuery.FieldByName(FLD_DESCRIPTION).AsString;
        qrQuery.Next();
      end;
    finally
      tblProfileGroup.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminProfileGroup.ShowChild(aId_ProfileGroup: Integer);
var
  frmAdminProfileGroupDetail: TfrmAdminProfileGroupDetail;
begin
  frmAdminProfileGroupDetail := TfrmAdminProfileGroupDetail.Create(aId_ProfileGroup, FDConnection, Self);
  try
    frmAdminProfileGroupDetail.ShowModal();
  finally
    frmAdminProfileGroupDetail.Free();
  end;
  RefreshData();
end;

procedure TfrmAdminProfileGroup.tblProfileGroupCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.
