unit ERP.Admin.UI.UsersGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, System.Actions, Vcl.ActnList,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses,
  cxGridCustomView, cxGrid, dxBar, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, Vcl.StdCtrls, ShateM.Components.TCustomTempTable,
  ShateM.Components.TFireDACTempTable;


type
  TfrmUserGroup = class(TERPCustomForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    qrQuery: TFDQuery;
    cxGrid: TcxGrid;
    tblUserGroup: TcxGridTableView;
    colIdUserGroup: TcxGridColumn;
    colName: TcxGridColumn;
    colDescription: TcxGridColumn;
    cxGridLevel: TcxGridLevel;
    ttUserGroup: TsmFireDACTempTable;
    procedure acAddExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditClick(Sender: TObject);

    procedure acRefreshExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);

    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);

    procedure tblUserGroupCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    procedure RefreshData;
    procedure DeleteRecords;
    procedure ShowChild(aId_UserGroup: Integer);
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
  ERP.Admin.UI.UsersGroupDetail;

const
  MODULE_NAME            = 'Группы пользователей';
  MODULE_GUID: TGUID     = '{700FA0CE-CCA0-48E2-8E14-8B798A9AAE3D}';
  MODULE_TYPEDB          = 1;

  PROC_ADM_UG_SEL_ITEMLIST = 'adm_ug_sel_itemlist';
  PROC_ADM_UG_DEL_ITEM = 'adm_ug_del_item';

  FLD_ID_USER_GROUP = 'Id_UserGroup';
  FLD_NAME = 'Name';
  FLD_DESCRIPTION = 'Description';

  COL_ID_USER_GROUP = 0;
  COL_NAME = 1;
  COL_DESCRIPTION = 2;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';


function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmUserGroup;
begin
  frmForm := TfrmUserGroup.Create(aERPClientData);
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


{ TfrmUserGroup }

procedure TfrmUserGroup.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
  RefreshData();
end;

procedure TfrmUserGroup.acDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmUserGroup.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblUserGroup.Controller.SelectedRecordCount > 0;
end;

procedure TfrmUserGroup.acEditExecute(Sender: TObject);
begin
  ShowChild(tblUserGroup.Controller.FocusedRecord.Values[COL_ID_USER_GROUP]);
  RefreshData();
end;

procedure TfrmUserGroup.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblUserGroup.Controller.SelectedRecordCount = 1;
end;

procedure TfrmUserGroup.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmUserGroup.btnEditClick(Sender: TObject);
begin
  ShowChild(tblUserGroup.Controller.FocusedRecord.Values[COL_ID_USER_GROUP]);
  RefreshData();
end;

constructor TfrmUserGroup.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  acAdd.ImageIndex := IL_ADD;
  acEdit.ImageIndex := IL_EDIT;
  acDelete.ImageIndex := IL_DELETE;
  acRefresh.ImageIndex := IL_REFRESH;
  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
  qrQuery.Connection := FDConnection;
  ttUserGroup.Connection := FDConnection;
end;

procedure TfrmUserGroup.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttUserGroup.CreateTempTable();
  try
    for k := 0 to tblUserGroup.Controller.SelectedRecordCount - 1 do
      ttUserGroup.InsertTempTable([TFieldValue.Create('Id_UserGroup', tblUserGroup.Controller.SelectedRecords[k].Values[COL_ID_USER_GROUP])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_UG_DEL_ITEM, []);
  finally
    ttUserGroup.DropTempTable();
  end;
end;

procedure TfrmUserGroup.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmUserGroup.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_UG_SEL_ITEMLIST;
  try
    qrQuery.Open();
    tblUserGroup.BeginUpdate();
    try
      tblUserGroup.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblUserGroup.DataController.RecordCount - 1 do
      begin
        tblUserGroup.DataController.Values[k, COL_ID_USER_GROUP] := qrQuery.FieldByName(FLD_ID_USER_GROUP).AsInteger;
        tblUserGroup.DataController.Values[k, COL_NAME] := qrQuery.FieldByName(FLD_NAME).AsString;
        tblUserGroup.DataController.Values[k, COL_DESCRIPTION] := qrQuery.FieldByName(FLD_DESCRIPTION).AsString;
        qrQuery.Next();
      end;
    finally
      tblUserGroup.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmUserGroup.ShowChild(aId_UserGroup: Integer);
var
  frmAdminProfileGroupDetail: TfrmUserGroupDetail;
begin
  frmAdminProfileGroupDetail := TfrmUserGroupDetail.Create(aId_UserGroup, FDConnection, Self);
  try
    frmAdminProfileGroupDetail.ShowModal();
  finally
    frmAdminProfileGroupDetail.Free();
  end;
  RefreshData();
end;

procedure TfrmUserGroup.tblUserGroupCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.

