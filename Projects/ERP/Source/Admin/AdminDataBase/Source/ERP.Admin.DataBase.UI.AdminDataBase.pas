unit ERP.Admin.DataBase.UI.AdminDataBase;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxStyles,
  cxCustomData,
  cxFilter,
  cxData,
  cxDataStorage,
  cxEdit,
  cxCheckBox,
  Vcl.ActnList,
  dxBar,
  cxClasses,
  cxGridLevel,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridCustomView,
  cxGrid,
  cxGridCustomPopupMenu,
  cxGridPopupMenu,
  Vcl.Menus,
  cxNavigator,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  System.Actions,
  Data.DB,
  Vcl.ImgList,
  ShateM.Components.TCustomTempTable,
  ShateM.Components.TFireDACTempTable,
  Vcl.StdCtrls;

type
  TfrmAdminDataBase = class(TERPCustomForm)
    cxGrid: TcxGrid;
    tblDataBase: TcxGridTableView;
    cxGridLevel: TcxGridLevel;
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
    colIdDataBase: TcxGridColumn;
    colIdServer: TcxGridColumn;
    colIdTemplateDataBase: TcxGridColumn;
    colDataBase: TcxGridColumn;
    colDataBaseName: TcxGridColumn;
    colEnabled: TcxGridColumn;
    colServerName: TcxGridColumn;
    colTemplateDataBaseName: TcxGridColumn;
    qrQuery: TFDQuery;
    dxBarLargeButton3: TdxBarLargeButton;
    acLinked: TAction;
    ilImageList: TcxImageList;
    ttDelDataBase: TsmFireDACTempTable;
    acRecreateAppRole: TAction;
    dxBarLargeButton6: TdxBarLargeButton;
    mLog: TMemo;
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure tblDataBaseCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure acDeleteExecute(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acLinkedUpdate(Sender: TObject);
    procedure acLinkedExecute(Sender: TObject);
    procedure acRecreateAppRoleUpdate(Sender: TObject);
    procedure acRecreateAppRoleExecute(Sender: TObject);
  strict private
    procedure AssignImage;
    procedure DeleteRecords;
    procedure ClearLog;
    procedure ShowSuccess;
    procedure LogError(const aMessage: string);
    procedure RecreationOfAppRole;
    procedure RefreshData;
    procedure ShowChild(const aId_DataBase: Integer);
  public
    constructor Create(const aERPClientData: IERPClientData); reintroduce;
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
  ERP.Admin.DataBase.UI.AdminDataBaseDetail,
  ERP.Admin.DataBase.UI.AdminDataBaseLinked,
  ERP.Package.ClientInterface.IDBConnection,
  ERP.Package.ClientInterface.IDBConnectionEx;

resourcestring
  rsDelete = 'Удаление';
  rsDeleteConfirm = 'Вы уверены, что хотите удалить выделенные записи?';
  rsRecreationOfAppRole = 'Пересоздание роли';
  rsRecreateAppRoleConfirm = 'Вы уверены, что хотите пересоздать роль?';
  rsActionSuccess = 'Действие выполнено успешно';
  rsConnectionNotFound = 'Соединение не найдено';

const
  MODULE_NAME = 'Базы данных';
  MODULE_GUID: TGUID = '{2C86C939-27CC-4E18-9BB7-F484DEEEDDFF}';
  MODULE_TYPEDB = 1;

  PROC_ADM_DB_DEL_ITEM = 'adm_db_del_item';
  PROC_ADM_DB_SEL_ITEMLIST = 'adm_db_sel_itemlist';

  FLD_ID_DATABASE = 'Id_DataBase';
  FLD_ID_SERVER = 'Id_Server';
  FLD_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';
  FLD_SERVERNAME = 'ServerName';
  FLD_TEMPLATEDATABASENAME = 'TemplateDataBaseName';
  FLD_DATABASE = 'DataBase';
  FLD_DATABASENAME = 'DataBaseName';
  FLD_VISIBLE = 'Visible';
  FLD_ENABLED = 'Enabled';

  COL_ID_DATABASE = 0;
  COL_ID_SERVER = 1;
  COL_ID_TEMPLATEDATABASE = 2;
  COL_SERVERNAME = 3;
  COL_TEMPLATEDATABASENAME = 4;
  COL_DATABASE = 5;
  COL_DATABASENAME = 6;
  COL_ENABLED = 7;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAdminDataBase;
begin
  frmForm := TfrmAdminDataBase.Create(aERPClientData);
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

{ TfrmAdminDataBase }

procedure TfrmAdminDataBase.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
  RefreshData();
end;

procedure TfrmAdminDataBase.acDeleteExecute(Sender: TObject);
begin
  if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAdminDataBase.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblDataBase.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAdminDataBase.acEditExecute(Sender: TObject);
begin
  ShowChild(tblDataBase.Controller.FocusedRecord.Values[COL_ID_DATABASE]);
  RefreshData();
end;

procedure TfrmAdminDataBase.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblDataBase.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAdminDataBase.acLinkedExecute(Sender: TObject);
var
  frmAdminDataBaseLinked: TfrmAdminDataBaseLinked;
begin
  frmAdminDataBaseLinked := TfrmAdminDataBaseLinked.Create(Self, FDConnection,
    tblDataBase.Controller.FocusedRecord.Values[COL_ID_DATABASE]);
  try
    frmAdminDataBaseLinked.ShowModal();
  finally
    frmAdminDataBaseLinked.Free();
  end;
end;

procedure TfrmAdminDataBase.acLinkedUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblDataBase.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAdminDataBase.acRecreateAppRoleExecute(Sender: TObject);
begin
  if Application.MessageBox(PChar(rsRecreateAppRoleConfirm), PChar(rsRecreationOfAppRole), MB_YESNO or MB_ICONQUESTION)
    = ID_YES then
  begin
    ClearLog();
    RecreationOfAppRole();
    ShowSuccess();
  end;
end;

procedure TfrmAdminDataBase.acRecreateAppRoleUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblDataBase.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAdminDataBase.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminDataBase.AssignImage;

  function CopyIL(aIndex: Integer): Integer;
  var
    Icon: TIcon;
  begin
    Icon := TIcon.Create();
    try
      GDDM.ilGlobal32.GetIcon(aIndex, Icon);
      Result := ilImageList.AddIcon(Icon);
    finally
      Icon.Free();
    end;
  end;

begin
  acAdd.ImageIndex := CopyIL(IL_ADD);
  acEdit.ImageIndex := CopyIL(IL_EDIT);
  acDelete.ImageIndex := CopyIL(IL_DELETE);
  acRefresh.ImageIndex := CopyIL(IL_REFRESH);
  acRecreateAppRole.ImageIndex := CopyIL(IL_RECREATE_APP_ROLE);
  acLinked.ImageIndex := 0;
end;

procedure TfrmAdminDataBase.ClearLog;
begin
  mLog.Clear();
end;

constructor TfrmAdminDataBase.Create(const aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  qrQuery.Connection := FDConnection;
  ttDelDataBase.Connection := FDConnection;
  AssignImage();
end;

procedure TfrmAdminDataBase.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttDelDataBase.CreateTempTable();
  try
    for k := 0 to Pred(tblDataBase.Controller.SelectedRecordCount) do
    begin
      ttDelDataBase.InsertTempTable([TFieldValue.Create(
        'Id_DataBase', tblDataBase.Controller.SelectedRecords[k].Values[COL_ID_DATABASE])]);
    end;
    TERPQueryHelp.Open(FDConnection, PROC_ADM_DB_DEL_ITEM, []);
  finally
    ttDelDataBase.DropTempTable();
  end;
end;

procedure TfrmAdminDataBase.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminDataBase.LogError(const aMessage: string);
var
  s: string;
begin
  s := Trim(aMessage);
  if s = EmptyStr then
  begin
    Exit();
  end;

  mLog.Lines.Add(s);
end;

procedure TfrmAdminDataBase.RecreationOfAppRole;
var
  i: Integer;
  j: Integer;
  tmpDatabaseId: Integer;
  tmpDBConnection: IDBConnection;
  tmpDBConnectionEx: IDBConnectionEx;
begin
  CreateSQLCursor();
  for i := 0 to Pred(tblDataBase.Controller.SelectedRecordCount) do
  begin
    tmpDatabaseId := tblDataBase.Controller.SelectedRecords[i].Values[COL_ID_DATABASE];
    for j := 0 to Pred(ERPClientData.DBConnectionManager.Count) do
    begin
      tmpDBConnection := ERPClientData.DBConnectionManager.Items[j];
      if tmpDBConnection.Id_DataBase <> tmpDatabaseId then
      begin
        if j = Pred(ERPClientData.DBConnectionManager.Count) then
        begin
          LogError(Format('[%s].[%s]: %s', [
            tblDataBase.Controller.SelectedRecords[i].Values[COL_SERVERNAME],
            tblDataBase.Controller.SelectedRecords[i].Values[COL_DATABASE],
            rsConnectionNotFound]));
        end;
        Continue;
      end;

      if Supports(tmpDBConnection, IDBConnectionEx, tmpDBConnectionEx) then
      begin
        try
          tmpDBConnectionEx.IncConnection();
          try
            tmpDBConnectionEx.UnsetAppRole();
            try
              tmpDBConnectionEx.RecreateAppRole;
            finally
              tmpDBConnectionEx.SetAppRole();
            end;
          finally
            tmpDBConnectionEx.DecConnection(MODULE_GUID);
          end;
          Break;
        except
          on e: Exception do
          begin
            LogError(Format('[%s].[%s]: %s', [tmpDBConnectionEx.Server, tmpDBConnectionEx.DataBase,
              e.ToString]));
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmAdminDataBase.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_DB_SEL_ITEMLIST;
  try
    qrQuery.Open();
    tblDataBase.BeginUpdate();
    try
      tblDataBase.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblDataBase.DataController.RecordCount - 1 do
      begin
        tblDataBase.DataController.Values[k, COL_ID_DATABASE] := qrQuery.FieldByName(FLD_ID_DATABASE).AsInteger;
        tblDataBase.DataController.Values[k, COL_ID_SERVER] := qrQuery.FieldByName(FLD_ID_SERVER).AsInteger;
        tblDataBase.DataController.Values[k, COL_ID_TEMPLATEDATABASE] := qrQuery.FieldByName(FLD_ID_TEMPLATEDATABASE).AsInteger;
        tblDataBase.DataController.Values[k, COL_SERVERNAME] := qrQuery.FieldByName(FLD_SERVERNAME).AsString;
        tblDataBase.DataController.Values[k, COL_TEMPLATEDATABASENAME] :=
          qrQuery.FieldByName(FLD_TEMPLATEDATABASENAME).AsString;
        tblDataBase.DataController.Values[k, COL_DATABASE] := qrQuery.FieldByName(FLD_DATABASE).AsString;
        tblDataBase.DataController.Values[k, COL_DATABASENAME] := qrQuery.FieldByName(FLD_DATABASENAME).AsString;
        tblDataBase.DataController.Values[k, COL_ENABLED] := qrQuery.FieldByName(FLD_ENABLED).AsBoolean;
        qrQuery.Next();
      end;
    finally
      tblDataBase.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminDataBase.ShowChild(const aId_DataBase: Integer);
var
  frmAdminDataBaseDetail: TfrmAdminDataBaseDetail;
begin
  frmAdminDataBaseDetail := TfrmAdminDataBaseDetail.Create(aId_DataBase, FDConnection, Self);
  try
    frmAdminDataBaseDetail.ShowModal();
  finally
    frmAdminDataBaseDetail.Free();
  end;
  RefreshData();
end;

procedure TfrmAdminDataBase.ShowSuccess;
begin
  if mLog.Lines.Count = 0 then
  begin
    ShowMessage(rsActionSuccess);
  end;
end;

procedure TfrmAdminDataBase.tblDataBaseCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.
